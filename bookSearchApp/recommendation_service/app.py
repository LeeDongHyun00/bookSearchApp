from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.neighbors import NearestNeighbors
from konlpy.tag import Okt
import re

app = Flask(__name__)
CORS(app)

import os

# Load Database Configuration from properties file
def load_db_config():
    config = {}
    # Path to db.properties - Now in src/main/java/db.properties
    current_dir = os.path.dirname(os.path.abspath(__file__))
    properties_path = os.path.join(current_dir, '..', 'src', 'main', 'java', 'db.properties')
    
    try:
        with open(properties_path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = line.split('=', 1)
                    config[key.strip()] = value.strip()
        
        return {
            'host': config.get('HOST', 'localhost'),
            'port': int(config.get('PORT', 3306)),
            'user': config.get('USER', 'root'),
            'password': config.get('PASS', ''),
            'database': config.get('DB_NAME', 'book_db')
        }
    except Exception as e:
        print(f"Error loading db.properties: {e}")
        # Return default fallback if file not found
        return {
            'host': 'localhost',
            'port': 3306,
            'user': 'root',
            'password': '',
            'database': 'BookSearchApp'
        }

DB_CONFIG = load_db_config()
print(f"Loaded DB Config: Host={DB_CONFIG['host']}, DB={DB_CONFIG['database']}")

class BookRecommender:
    def __init__(self):
        self.okt = None
        try:
            self.okt = Okt()
        except Exception as e:
            print(f"Warning: KoNLPy 초기화 실패. 자바 설정을 확인하세요. Error: {e}")
        
        # 불용어 리스트 정의 (검색에 도움 안 되는 단어들)
        self.stopwords = {'책', '추천', '해줘', '좀', '것', '수', '나', '저', '요', '서적', '도서', '관련', '대한'}

        if self.okt:
            print("Using KoNLPy (Okt) for text analysis.")
            self.vectorizer = TfidfVectorizer(
                max_features=5000,
                ngram_range=(1, 2),
                min_df=1,
                max_df=0.9, # 너무 흔한 단어(90% 이상 등장) 무시
                lowercase=True,
                strip_accents='unicode'
            )
        else:
            print("Using Character N-grams for text analysis (Fallback).")
            self.vectorizer = TfidfVectorizer(
                max_features=10000,
                analyzer='char',
                ngram_range=(2, 4),
                min_df=1,
                max_df=0.9,
                lowercase=True,
                strip_accents='unicode'
            )
            
        self.model = NearestNeighbors(metric='cosine', algorithm='brute')
        self.books_df = None
        self.tfidf_matrix = None
        self.prepare_model()

    def get_db_connection(self):
        try:
            conn = mysql.connector.connect(**DB_CONFIG)
            return conn
        except mysql.connector.Error as err:
            print(f"Error: {err}")
            return None

    def fetch_books(self):
        conn = self.get_db_connection()
        if not conn:
            return pd.DataFrame()
        
        try:
            cursor = conn.cursor(dictionary=True)
            query = """
                SELECT DISTINCT
                    b.ISBN,
                    b.책제목,
                    b.책소개,
                    b.표지이미지,
                    b.출판사,
                    GROUP_CONCAT(c.카테고리이름 SEPARATOR ' ') as categories
                FROM 책 b
                LEFT JOIN 책_카테고리 bc ON b.ISBN = bc.책id
                LEFT JOIN 카테고리 c ON bc.카테고리id = c.카테고리id
                GROUP BY b.ISBN, b.책제목, b.책소개, b.표지이미지, b.출판사
            """
            cursor.execute(query)
            result = cursor.fetchall()
            df = pd.DataFrame(result)
            cursor.close()
            conn.close()
            
            if not df.empty:
                df = df.rename(columns={
                    '책제목': 'title',
                    '책소개': 'synopsis',
                    '표지이미지': 'cover_image',
                    '출판사': 'publisher',
                    'ISBN': 'isbn',
                    'categories': 'categories'
                })
            
            return df
        except Exception as e:
            print(f"Error fetching data: {e}")
            return pd.DataFrame()

    def preprocess(self, text):
        if not isinstance(text, str):
            return ""
        
        text = text.lower()
        
        try:
            if self.okt:
                # stem=True: 어간 추출 ('슬픈' -> '슬프다', '울고' -> '울다')
                # norm=True: 정규화 ('사랑해' -> '사랑하다')
                pos_tags = self.okt.pos(text, stem=True, norm=True)
                
                # 명사, 동사, 형용사, 알파벳(영어)만 추출
                meaningful_words = [
                    word for word, tag in pos_tags 
                    if tag in ['Noun', 'Verb', 'Adjective', 'Alpha']
                ]
                
                # 불용어 제거
                tokens = [w for w in meaningful_words if w not in self.stopwords]
                
                return " ".join(tokens)
            else:
                cleaned = re.sub(r'[^\w\s가-힣a-zA-Z]', ' ', text)
                
                # 포괄적인 조사 리스트
                particles = [
                    '으로부터', '로부터', '에서부터', '까지도',
                    '되는', '하는', '된', '한', '했던', '할',
                    '에서', '으로', '로', '에게', '한테',
                    '은', '는', '이', '가', '을', '를', '에', '의', '도', '만', '부터', '까지'
                ]
                
                tokens = []
                for word in cleaned.split():
                    if len(word) <= 1:
                        continue
                    
                    # 반복해서 조사 제거 (최대 3회)
                    for _ in range(3):
                        removed = False
                        for p in particles:
                            if word.endswith(p) and len(word) > len(p) + 1:
                                word = word[:-len(p)]
                                removed = True
                                break
                        if not removed:
                            break
                    
                    # 불용어 제거 및 추가
                    if word not in self.stopwords and len(word) > 1:
                        tokens.append(word)
                
                return " ".join(tokens)
        except Exception as e:
            print(f"Error in preprocess: {e}")
            return text

    def prepare_model(self):
        print("Loading data and training model...")
        self.books_df = self.fetch_books()
        
        if self.books_df.empty:
            print("No books found.")
            return

        self.books_df['synopsis'] = self.books_df['synopsis'].fillna('')
        self.books_df['title'] = self.books_df['title'].fillna('')
        self.books_df['categories'] = self.books_df['categories'].fillna('')
        self.books_df['publisher'] = self.books_df['publisher'].fillna('')
        
        # TF-IDF 가중치 조정
        self.books_df['content'] = (
            (self.books_df['title'] + " ") * 2 +
            (self.books_df['categories'] + " ") * 2 +
            (self.books_df['synopsis'] + " ") * 2 +
            (self.books_df['publisher'] + " ") * 1
        )
        
        print("Preprocessing content...")
        self.books_df['processed_content'] = self.books_df['content'].apply(self.preprocess)
        
        if len(self.books_df) > 0:
            print(f"Sample raw: {self.books_df['synopsis'].iloc[0][:50]}")
            print(f"Sample processed: {self.books_df['processed_content'].iloc[0][:100]}")
        
        if not self.books_df.empty:
            try:
                self.tfidf_matrix = self.vectorizer.fit_transform(self.books_df['processed_content'])
                self.model.fit(self.tfidf_matrix)
                print(f"Model trained with {len(self.books_df)} books.")
            except ValueError as e:
                print(f"Model training error: {e}")
                self.tfidf_matrix = None
        
    def recommend(self, query):
        if self.books_df is None or self.books_df.empty:
            return []
        if self.tfidf_matrix is None:
            return []

        # 사용자 입력 전처리 확인
        processed_query = self.preprocess(query)
        print(f"User Query: '{query}' -> Processed: '{processed_query}'")
        
        if not processed_query.strip():
            # 키워드가 모두 제거되어 비어버린 경우 (예: "책 추천")
            print("Warning: Query is empty after preprocessing.")
            return []
        
        try:
            query_vec = self.vectorizer.transform([processed_query])
            
            # 검색된 결과가 너무 적을 수 있으므로 5개 혹은 전체 데이터 수 중 작은 값
            n_results = min(5, len(self.books_df))
            distances, indices = self.model.kneighbors(query_vec, n_neighbors=n_results)
            
            top_indices = indices[0]
            top_distances = distances[0]
            
            recommendations = []
            for i, idx in enumerate(top_indices):
                distance = top_distances[i]
                sim_score = 1 - distance
                
                # 유사도가 너무 낮으면(거리가 너무 멀면) 제외 (임계값 설정: 0.85 이상 거리면 무관할 확률 높음)
                if distance > 0.6: # 40% 미만 유사도 제거 
                    continue

                book = self.books_df.iloc[idx]
                
                img_url = book.get('cover_image', '')
                if not (img_url and isinstance(img_url, str) and img_url.startswith('http')):
                    img_url = 'https://via.placeholder.com/120x160?text=No+Image'
                
                recommendations.append({
                    'isbn': book['isbn'],
                    'title': book['title'],
                    'synopsis': book.get('synopsis', '')[:100] + '...' if book.get('synopsis', '') else 'No description', 
                    'cover_image': img_url,
                    'score': float(sim_score)
                })
            
            return recommendations

        except Exception as e:
            print(f"Error in recommend: {e}")
            return []

recommender = BookRecommender()

@app.route('/recommend', methods=['POST'])
def recommend():
    try:
        data = request.json
        query = data.get('query', '')
        if not query:
            return jsonify({'error': 'No query provided'}), 400
        
        results = recommender.recommend(query)
        return jsonify(results)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)