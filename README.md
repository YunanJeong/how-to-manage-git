# Git 관리시 헷갈릴 수 있는 부분 정리

[용어, 브랜치 관리 등](https://github.com/YunanJeong/how-to-manage-git/blob/main/branch.md)

[how-to-set-gituserinfo](https://github.com/YunanJeong/how-to-manage-git/blob/main/how-to-set-gituserinfo.md)

[여러 레포지토리 통합 방법](https://github.com/YunanJeong/how-to-manage-git/blob/main/integration.md)

## Git 버전관리

- Tag(버전) 붙이기

```sh
# 지금 태그 붙이기
git tag vX.X.X

# 바로 직전 커밋에 태그 붙이기. 커밋 해시값은 git관리페이지나 git log로 확인
git tag vX.X.X {커밋에 붙는 SHA 해시값}

# 아직 remote 적용은 안됨. 취소하고 싶으면 다음과 같이 태그 삭제
git tag -d vX.X.X

# remote에 반영
git push origin vX.X.X
```

- issue 등록된 것 해결했을 때 다음과 같이 커밋

```sh
# XX는 이슈넘버
git commit -m"Resolves #XX"
```
