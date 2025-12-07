# Flask Server Setup

## Running the Server (Development)

```bash
cd /Users/donghyunlee/Desktop/bookSearchApp/bookSearchApp
python3 recommendation_service/app.py
```

Keep this terminal open. The server will run on `http://localhost:5000`.

## Testing the Server

```bash
curl -X POST http://localhost:5000/recommend \
  -H "Content-Type: application/json" \
  -d '{"query": "romance"}'
```

## Troubleshooting

1. **Port Conflict**: If port 5000 is in use:

   ```bash
   lsof -i :5000 | awk 'NR!=1 {print $2}' | xargs kill-9
   ```

2. **Check Logs**: Look for errors in the terminal where Flask is running

3. **Database Connection**: Ensure MySQL is running on port 3307
