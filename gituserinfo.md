# how-to-set-gituserinfo

매번 깜빡하는 내용. 개인 참고용 메모

---

## gitconfig란?

git이 사용자 이름·이메일·인증 방식 등을 읽어오는 설정 파일. 세 단계 계층이 있고, 범위가 좁은 쪽이 우선한다 (local > global > system).

- system: 머신 전체 공통, 거의 건드리지 않음
  - Linux/Mac: `/etc/gitconfig`
  - Windows: `C:\Program Files\Git\etc\gitconfig`
- global: 해당 사용자의 기본값
  - Linux/Mac: `~/.gitconfig`
  - Windows: `C:\Users\{username}\.gitconfig`
- local: 해당 레포 전용 (가장 높은 우선순위)
  - 프로젝트 내 `.git/config`

일반적으로 수정하는 건 global과 local. global `.gitconfig`의 `includeIf` 지시어를 쓰면 "특정 디렉토리 밑의 레포지토리에선 다른 설정 파일을 끼워넣기"가 가능하다. 이걸로 개인용/업무용 등 디렉토리 단위로 용도분리 가능.

### 설정 파일 위치/값 확인

```bash
# 현재 적용되는 모든 설정을 출처 파일과 함께 보기 (system/global/local + includeIf 포함)
git config --list --show-origin

# 레벨별로 보기
git config --list --system --show-origin
git config --list --global --show-origin
git config --list --local  --show-origin
```

global `.gitconfig`가 없는 경우, `git config --global user.name "..."`을 한 번 실행하거나 직접 만들면 된다.

---

## 사용자 정보 설정 (잔디심기 오류 해결)

GitHub에 등록된 `{name, email}`과 로컬 git의 `{name, email}`이 다르면 커밋 내역(잔디)이 보이지 않는다.

```bash
# user.name은 대소문자 구분 없음
git config --global user.name "{github유저이름}"
git config --global user.email "{github에 등록된 이메일}"

# 확인
git config --list
```

참고: <https://velog.io/@jeeseob5761/github-%EC%9E%94%EB%94%94%EC%8B%AC%EA%B8%B0-%EC%98%A4%EB%A5%98-%ED%95%B4%EA%B2%B0%EB%B0%A9%EB%B2%95>

---

## 인증 토큰 생성 (PAT, Personal Access Token)

`git push` 시 password 자리에 계정 비밀번호를 쓰는 방식은 2021년 여름부터 막혔다. 반드시 PAT(토큰)을 발급해 사용해야 한다.

- 발급 경로: `우측 상단 프로필 → Settings → Developer Settings → Personal access tokens`
- 권한: 일반적인 사용은 `repo` 항목만 체크해도 충분

참고:
- <https://hyeo-noo.tistory.com/184>
- <https://curryyou.tistory.com/344>

---

## 디렉토리별 gitconfig 분리 (global)

개인용/업무용 계정을 디렉토리 기준으로 나눠 쓰고 싶을 때.

### 1. 디렉토리 별 config파일 생성

```conf
# ~/.gitconfig-private
[user]
  email = myMail@gmail.com
  name = yunanjeong
```

```conf
# ~/.gitconfig-works
[user]
  email = myCompanyMail@company.com
  name = myCompanyNickName
```

### 2. 기존 `~/.gitconfig`에서 디렉토리 별 적용할 config파일 지정

`~/private/`은 개인용, `~/works/`는 업무용 예시.

```conf
# Ubuntu / Mac # Apply gitconfig according to the directory usage
[includeIf "gitdir:~/private/"]
  path = .gitconfig-private
[includeIf "gitdir:~/works/"]
  path = .gitconfig-works
```

```conf
# Windows
[includeIf "gitdir/i:c:/private/"]
        path = .gitconfig-private
[includeIf "gitdir/i:c:/works/"]
        path = .gitconfig-works
```

### 3. 참고. 기존 `~/.gitconfig`에서 `[user]` 삭제

다음과 같은 내용이 남아있으면 공통 적용되어버리니 삭제한다.

```conf
[user]
  email = myMail@gmail.com
  name = yunanjeong
```

> `[user]` 외 섹션(ex. `[core]`)은 공통으로 쓰고 싶다면 그대로 둬도 됨.

---

## 인증 토큰(PAT) 중앙관리 (레포지토리마다 인증정보 입력 X)

- 디렉토리별 공통 credential 파일 하나로 해당 디렉토리 내 모든 레포의 PAT 인증을 대신한다.

### 배경

이상적으로는 레포마다 최소 권한의 개별 토큰을 쓰는 것이 맞다. 하지만 현실적으로는 두 가지 문제가 있다.

- 관리 부담: 레포 수가 많아지면 토큰 발급·교체·만료를 일일이 챙기기 어렵다.
- 유출 경로: 레포 내부(`.git/config`)에 토큰을 두는 순간 파일 자체가 노출 지점이 된다.
  - e.g. 프로젝트 폴더가 OneDrive·Dropbox 등에 동기화되는 경우
  - e.g. `.git/config`가 실수로 원격에 push되는 경우
  - e.g. **`Claude Code, LLM 에이전트, IDE 인덱서 등이 프로젝트 폴더를 스캔하는 경우`**

절충안으로, 홈 경로의 공통 credential파일을 두고 디렉토리 단위로 이를 바라보게 한다.

### 설정 방법

```conf
# .gitconfig-private
[user]
  email = myMail@gmail.com
  name = yunanjeong
[credential]
  helper = store --file=$HOME/.git-credentials-private
```

```conf
# ~/.git-credentials-private
https://yunanjeong:ghp_MY_TOKEN@github.com
```

```sh
# 보안상 credential 파일은 600 권한
sudo chown -R $USER:$USER ~/.git-credentials-private
sudo chmod 600 ~/.git-credentials-private
```

이후 `~/private/` 하위 레포에서는 인증정보가 없어도 `~/.git-credentials-private`을 가져다 쓴다.
