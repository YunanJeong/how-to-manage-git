# how-to-set-gituserinfo
개인 참고용

## 잔디심기 오류
- 깃허브에 등록된 email과 name이 local git의 email과 name이 다르면 커밋 내역이 안보인다.
- 다음 명령어를 로컬 터미널환경에서 설정해주자.
  `$git config --global user.name "{github유저이름}"`
  `$git config --global user.email "{github에 등록된 이메일}"`

- 확인
  `$git config --list`

- 참고: https://velog.io/@jeeseob5761/github-%EC%9E%94%EB%94%94%EC%8B%AC%EA%B8%B0-%EC%98%A4%EB%A5%98-%ED%95%B4%EA%B2%B0%EB%B0%A9%EB%B2%95

------------------------------
## 토큰 생성
- git push 사용시 password에서 계정 비번 사용은 2021년 여름에 막혔다.
- 반드시 token 생성해서 써야한다.

- `우측상단 프로필-"Settings"-"Developer Settings"-"personal access tokens"에서 진행`
- 토큰 권한은 repo 항목만 체크해줘도 일반적 사용에 충분하다.

- 참고: https://hyeo-noo.tistory.com/184
