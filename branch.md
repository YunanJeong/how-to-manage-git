# 용어, 브랜치 관리 및 헷갈리는 부분 메모

## 'origin' 표현

- 원격 저장소의 약칭 (shorthand name for remote repository)
- 한국어 블로그에서 다들 그냥 '원격 저장소의 이름'이라고만 해서 헷갈린다. 주의할 것.

## 'master'와 'main' 표현

- 둘 다 별도 설정하지 않았을 때 디폴트 branch 이름이다.
- master가 노예제를 떠올리게해 불편하다는 이유로 2020년 이후로는 디폴트가 main으로 설정된다.
- 기존 git 사용법 설명자료에는 master로 설명하는 것이 많다.

## 'origin/main'과 'main' 표현

- origin/main: 원격 저장소
- main: 로컬 저장소

------------------------------

## How to use branch

- 새 branch 생성
  - `$git branch {branchname}`
- branch 전환
  - `$git branch`: branch 목록 및 현재 선택된 branch 확인
  - `$git checkout {branchname}`: 작업할 branch 선택
    - `git 작업시 항상 시작 전 작업할 branch를 선택 및 확인하자`
    - main 외에 새로운 branch를 만들어서 이제부터 해당 branch를 사용할것이라고 선언(checkout)하지 않는 이상,모든 작업은 main에 속한다.
  - branch 전환시,
    - Working Directory(실제 작업 경로)는 선택된 branch의 최신상태로 바뀐다.
    - 전환하고 파일이 삭제, 수정되었다고 놀라지말자. 다른 branch로 잘 백업되어 있다.
    - 항상 현재까지 작업물은 commit 단계까지 수행해놓고 전환하는 것이 충돌방지에 좋다.

  - HEAD?
    - 모든 branch에 HEAD(선두) 값이 존재한다. HEAD는 해당 branch의 마지막 commit을 의미한다.

- 이후 해당 branch에서 작업하고 commit 한다.

- branch 병합하기(branch 'feature'를 branch 'main'으로 흡수통합 시키는 예제로 기술한다.)
  - 현재까지 작업물을 commit 하고 다음을 수행한다.
  - `$git checkout main`: branch main으로 이동
  - `$git merge feature`: feature를 main에 합치기
    - 다른 설명: feature의 HEAD가 main의 HEAD보다 더 앞서나가는, 최신상태인 것이고 main이 이를 따라가도록 해주는 것이다.

- branch 삭제하기
  - `$ git branch -d {branchname}`

## 현재 변경사항을 다른 브랜치에 커밋하기

- e.g. main branch에 작업하다가 `아?맞다. 다른 branch에 해야했었는데!`같은 경우

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

------------------------------

## 병합시 branch끼리 충돌 해결

- 한 repository의 디렉토리 및 파일이 잘게 쪼개져있으면 merge 자체를 쓸 일이 적지만,
- 같은 파일을 여러 사람이 작업할시 충돌은 필연적이다.
- merge 절차에서 충돌이 발생하면, 해당 파일을 열어보면 충돌내역이 표기되어 있다.
- 적절히 수정하여 commit 한다.
- merge 절차를 다시 수행한다.

------------------------------

## 원격과 로컬 저장소 사이 관리

- `$git pull`을 사용하여 로컬 저장소를 최신 버전으로 업데이트하는 경우
  - pull은 "원격에서 로컬로, 데이터 가져오기(fetch) + 병합(merge)"이 합쳐진 기능이다.
  - 원격, 로컬 저장소 각각 업데이트 내역이 있을 때,
    - 서로 충돌파일이 없다면 문제없이 "로컬 저장소"로 병합된다.
    - 이후, commit 및 push하면 원격에도 최종본이 업데이트 된다.

- `$git fetch`
  - git pull로 업데이트시, 충돌 파일이 있을 것으로 예상될 때 사용할 수 있다.
  - fetch는 원격 저장소의 데이터를 별도 branch로 로컬 저장소에 다운로드한다.
  - 로컬 저장소에서 두 branch의 충돌부분을 직접 수동작업하여 commit 및 merge한다.

- `$ git push {원격 저장소 약칭} {branchname}`
  - 로컬의 특정 branch를 원격 저장소로 업데이트한다.
  - 일반적으로 `$git push` 사용시, `$git push origin main`을 의미한다.
  - 로컬 저장소에서 원격 저장소의 main으로 직접 push를 자제하도록 하자.
    - git flow 등 규격을 사용하는 정도는 아니라도, main과 feature 브랜치들 사이에 develop 브랜치 등을 두도록 하자.
    - main은 라이브 서비스 용도

------------------------------

## stash

- 작업 중 checkout하여 branch를 변경할 때, 충돌 파일이 있다면(기존 변경내역은 있으나 커밋은 하지 않은 상태), 현재 branch에서 변경내역을 임시저장소에 기록해두었다가 새로 전환한 branch에서 불러와 커밋할 수 있는 기능. 자주 쓰지는 않을 듯 싶다.
