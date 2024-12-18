# how-to-set-gituserinfo

매번 깜빡하는 내용. 개인 참고용 메모

## 잔디심기 오류

- 깃허브에 등록된 {name, email}과 local git의 {name, email}이 다르면 커밋 내역이 안보인다.
- 로컬 터미널환경에서 다음 명령어로 설정해주자.
- 유저이름은 대소문자 구분이 없는 듯 하다.
  - `$git config --global user.name "{github유저이름}"`
  - `$git config --global user.email "{github에 등록된 이메일}"`
  - password는 token을 사용하기 때문에 global옵션으로 등록하지 않고, repository별로 등록한다. (보안, 토큰 만료 등 이유)

- 확인
  `$git config --list`

- 참고: https://velog.io/@jeeseob5761/github-%EC%9E%94%EB%94%94%EC%8B%AC%EA%B8%B0-%EC%98%A4%EB%A5%98-%ED%95%B4%EA%B2%B0%EB%B0%A9%EB%B2%95

------------------------------

## 토큰 생성

- git push 사용시 password에서 계정 비번 사용은 2021년 여름에 막혔다.
- 반드시 token 생성해서 써야한다.

- 생성방법
  - `우측상단 프로필-"Settings"-"Developer Settings"-"personal access tokens"` 에서 진행
- 토큰 권한은 repo 항목만 체크해줘도 일반적 사용에 충분하다.

- 참고
  - https://hyeo-noo.tistory.com/184
  - https://curryyou.tistory.com/344

------------------------------

## 디렉토리 별 git config 다르게 설정하기(global설정)

### git config 설정파일(.gitconfig) 찾기

- `git config --list --show-origin`
- Ubuntu, Mac의 경우 일반적으로 홈디렉토리에 있다. 없으면 만들면 된다.
- Windows는 git 설치 후, `C:\\Program Files\\Git\\etc\\gitconfig`

### 다음과 같이 기존 .gitconfig 파일의 [user] 내용이 있다면 삭제

```conf
[user]
  email = myMail@gmail.com
  name = yunanjeong
```

### .gitconfig 작성 내용

- 디렉토리에 따라 다른 git설정파일이 적용되는 조건문이다.
- `~/private/`은 개인용 디렉토리, `~/works/`는 업무용 디렉토리를 나타낸 예시이다.
- `.gitconfig-private`과 `.gitconfig-works` 는 각각 적용될 git설정파일 이름이고, 별도 생성해야 한다.

```conf
# Ubuntu # Apply gitconfig according to the working directory
[includeIf "gitdir:~/private/"]
  path = .gitconfig-private
[includeIf "gitdir:~/works/"]
  path = .gitconfig-works
```

```conf
# Windows # Apply gitconfig according to the working directory
[includeIf "gitdir/i:c:/private/"]
        path = .gitconfig-private
[includeIf "gitdir/i:c:/works/"]
        path = .gitconfig-works
```

- `.gitconfig`와 동일한 경로에 개별 config 파일(`.gitconfig-private`, `.gitconfig-works`)을 생성

```conf
# .gitconfig-private
[user]
  email = myMail@gmail.com
  name = yunanjeong
```

```conf
# .gitconfig-works
[user]
  email = myCompanyMail@company.com
  name = myCompanyNickName
```

- 만약 기존 .gitconfig파일에 [user]외에 세팅값이 있다면 공통 적용된다. ex) [core] 설정 등

## 프로젝트 별 git config 다르게 설정하기 (local설정)

- 프로젝트 경로 내, .git 하위에서 설정 파일을 찾을 수 있다.
