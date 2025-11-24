package com.book.dto;

public class UserDTO {
	private String userId;
	private String password;
	private String email;
	private String nickname;
	
	public UserDTO() {}
	
	public UserDTO(String userId, String password, String email, String nickname) {
		this.userId = userId;
		this.password = password;
		this.email = email;
		this.nickname = nickname;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}


}
