# Git 관리시 헷갈릴 수 있는 부분 정리
[용어, 브랜치 관리 등](https://github.com/YunanJeong/how-to-manage-git/blob/main/branch.md)

[how-to-set-gituserinfo](https://github.com/YunanJeong/how-to-manage-git/blob/main/how-to-set-gituserinfo.md)

# 여러 레포지토리 통합 방법
- `기존 저장소 A, B`를 `새로운 저장소 C`로 옮겨서 통합시킨다고 하자.
- 기존 커밋 내역도 그대로 포함하여 통합하는 것이 목표

1. 일반적인 저장소 신규생성과 동일하게, 새로운 저장소 C 생성 후, 로컬 PC에서 git clone 한다.
2. **저장소 C 디렉토리**에서 작업한다. `$ cd C`
3. 다음과 같이 git subtree 명령어를 수행한다.

    ```
    $ git subtree add --prefix={A 저장소명} {A의 github 주소} {A에서 가져올 branch명}
    $ git subtree add --prefix={B 저장소명} {B의 github 주소} {B에서 가져올 branch명}
    e.g.) $ git subtree add --prefix=dpkg-extraction https://github.com/YunanJeong/dpkg-extraction main
    ```
    - `--prefix` 옵션으로 저장소명 표기하는 이유: git subtree 원래 기능은 A,B 저장소 안의 내용만 가져오고, 저장소명으로 디렉토리 구분을 해주지 않기 때문이다.
4. 커밋내역이 옮겨졌는지 확인
    - 통합 저장소 C의 github페이지에서 A,B 기준 과거시간으로 커밋내역이 나오는지 확인하면 된다.
5. 기존 저장소 A,B 미련없이 삭제