# 용어, 브랜치 관리 및 헷갈리는 부분 메모

## 용어

### 'origin'

- 원격 저장소의 약칭 (shorthand name for remote repository)
- 한국어 블로그에서 다들 그냥 '원격 저장소의 이름'이라고만 해서 헷갈린다. 주의할 것.

### 'master'와 'main' 표현

- 둘 다 별도 설정하지 않았을 때 디폴트 branch 이름이다.
- master가 노예제를 떠올리게해 불편하다는 이유로 2020년 이후로는 디폴트가 main으로 설정된다.
- 기존 git 사용법 설명자료에는 master로 설명하는 것이 많다.

### 'origin/main'과 'main' 표현

- origin/main: 원격 저장소
- main: 로컬 저장소

## How to use branch

### 특정 branch만 원격 저장소에서 다운로드

```sh
git clone {URL} -b {branchname}
```

### 새 branch 생성

```sh
git branch {branchname}
```

### branch 전환

```sh
# branch 목록 및 현재 선택된 branch 확인 
git branch

# 작업할 branch 선택
git checkout {branchname}
```

- `git 작업시 항상 시작 전 작업할 branch를 선택 및 확인하자`
- main 외에 새로운 branch를 만들어서 이제부터 해당 branch를 사용할것이라고 선언(checkout)하지 않는 이상,모든 작업은 main에 속한다.
- branch 전환시,
  - Working Directory(실제 작업 경로)는 선택된 branch의 최신상태로 바뀐다.
  - 전환하고 파일이 삭제, 수정되었다고 놀라지말자. 다른 branch로 잘 백업되어 있다.
  - 항상 **현재까지 작업물은 commit 단계까지 수행해놓고 전환**하는 것이 충돌방지에 좋다. commit 이전 단계의 변경사항은 항상 "현재 branch"에 반영된다.
- 이후 해당 branch에서 작업하고 commit 한다.

### HEAD?

- 모든 branch에 HEAD(선두) 값이 존재한다. HEAD는 해당 branch의 마지막 commit을 의미한다.

### branch 병합하기

- 다음은 branch 'feature'를 branch 'main'으로 흡수통합 시키는 예시다.
- feature의 HEAD가 main의 HEAD보다 더 앞서나가는, 최신상태인 것이고 main이 이를 따라가도록 해주는 것이다.

```sh
# branch feature에서 현재까지 작업물을 commit
git add .
git commit -m"Resolve #{my-issue-number}"

# branch main으로 이동
git checkout main

# feature를 main에 합치기
git merge feature
```

### branch 삭제하기

```sh
git branch -d {branchname}
```

### git stash (현재 변경사항을 다른 브랜치에 커밋하기)

- e.g. main branch에 작업하다가 `아?맞다. 다른 branch에 commit 해야됐었는데!!!`같은 경우에 사용

```sh
# 커밋없이 현재 변경내역(git status했을 때 대상들) 임시저장하기
git stash -m"임시저장"

# 다른 branch로 이동
git checkout feature-branch

# 임시저장한 것 꺼내기
git stash pop

# 이후 status로 상태확인하고, add, commit, push하면된다.
git status
```

### git merge시 branch끼리 충돌 해결 방법

- 한 저장소에서도 개별 디렉토리, 파일 단위로 작업을 하는 등, 가급적 충돌 자체를 피하는게 좋다.
- But, 같은 파일을 여럿이 작업할시 충돌은 필연적이다.
- merge 절차에서 충돌 발생시, 해당 파일을 열어보면 충돌내역이 표기되어 있다.
- 적절히 수정하여 commit 한다.
- merge 절차를 다시 수행한다.

## 원격과 로컬 저장소 사이 관리

모든 명령어는 저장소 전체가 아니라 branch 단위를 대상으로 한다.

`git push`와 `git pull`는 편의상 옵션이 생략된 것이고, 현재 작업중(checkout)인 로컬 branch 이름을 대상으로 한다. git 버전 마다 동작이 조금씩 다를 수 있는데, 명령어 에러 발생시 터미널 출력 내용을 참고하면 된다.

### git push

- 로컬 저장소의 branch 내용을 원격 저장소의 branch에 반영
- 충돌로 인해 push 실패시, 먼저 pull을 써서 원격 내용을 로컬에 반영해줘야 한다.

```sh
# git push {원격저장소약칭} {branchname}
git push                 # 작업 중인 branch를 원격 branch에 반영
git push origin main     # 로컬 main을 원격 main에 반영
git push origin feature  # 로컬 feature를 원격 feature에 반영
```

- 일반적으로 production ready수준에선, 원격 main에 직접 push는 권장되지 않는다.
  - git flow 등의 정책을 사용하거나,
  - feature, develop 등의 이름으로 여러 branch를 생성하여 역할을 분리 하는 것이 좋다.
  - main은 실제 배포되는 라이브 서비스 용도로 사용하면 좋다.

### git pull

- 원격 저장소의 branch 내용을 로컬 저장소의 branch에 반영
- `데이터 가져오기(fetch) + 병합(merge)`이 합쳐진 기능
- 원격, 로컬 저장소에서 각각 업데이트 내역이 있을 때, git pull
  - 서로 충돌파일이 없다면, 문제없이 "로컬 저장소"로 병합된다.
  - 충돌 파일이 있다면, 위 merge 케이스처럼 별도 처리 필요
  - 이후, commit 및 push하면 원격에도 최종본이 업데이트 된다.

```sh
# git pull {원격저장소약칭} {branchname}

# 원격 branch를 로컬 branch에 반영
# 현재 작업중인 로컬 branch와 동일한 이름의 원격 branch를 찾는다. 해당 branch가 없으면 에러 발생
git pull                 

git pull origin main     # 원격 main을 로컬 main에 반영
git pull origin feature  # 원격 feature를 로컬 feature에 반영
```

### git fetch

- `git pull 사용시 로컬 저장소에서 충돌 파일이 있을 것으로 예상될 때 사용`
- git fetch로 원격 저장소의 변경사항을 별도 branch로 로컬 저장소에 다운로드
- 로컬 저장소에서 두 branch의 충돌부분을 직접 수동작업하여 commit 및 merge한다.
