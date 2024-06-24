# FLO

FLO 앱

## Minimum DeployMent Target
- iOS: 17.5+

## Framework
- [Moya](https://github.com/Moya/Moya)
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [ReactorKit](https://github.com/ReactorKit/ReactorKit)
- [Kingfisher](https://github.com/onevcat/Kingfisher)
- [SnapKit](https://github.com/SnapKit/SnapKit)

## Description
- UICollectionViewCompositionalLayout을 이용한 UI 구현
- RXSwift, ReactorKit을 이용한 단방향 Data Flow
- UI 확인을 위한 UI 통합 테스트 코드 작성

## UI
- 둘러보기 화면
  - UICollectionViewCompositionalLayout 이용
  
- 곡 상세화면

## 기능    
- Sticky Anchor Header
  - [x] Anchor 누르면 해당 부분으로 Scrolling
  - [ ] Scroll 시, 현재 Anchor 자동 선택
 
- 화면 이동
  - [x] music Cell 클릭 시, 곡 상세 화면 이동

- Error Handling
  - [x] Newtork Error 발생 시, Alert Present
  
## 참고
- SPM 관련 Build Error가 발생한다면, Package.resolved를 지우고 다시 빌드해주세요.
  (FLO.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved)
