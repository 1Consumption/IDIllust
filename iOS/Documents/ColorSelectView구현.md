# ColorSelectView 구현

<img width="1922" alt="colorSelect" src="https://user-images.githubusercontent.com/37682858/99883088-56d5b880-2c68-11eb-9fa6-98378b3575c9.png">


## 배경

`ComponentCollectionView`에 `LongPressGesture`가 등록되어 있고 `LongPressBegan` 이벤트가 발생하면 해당 cell 위에 `ColorSelectView`를 띄움. 그리고 `LongPressChanged` 이벤트가 발생하면 발생한 좌표에 맞게 `ColorSelectViewController` 내에 있는 `ColorSelectCollectionView` 의 cell을 선택해야함. `LongPressEended` 제스처가 발생하면 `ColorSelectView` 를 hidden 하고 color 에 맞는 thumbnailImage를 받아와야함.

따라서 `CustomizeViewController`가 containerView 형태로 `ColorSelectViewController`의 View를 `ColorSelectView`에서 보여주고 있음.



## 구현 방법

`ColorSelectView` 를 띄우는 방법은 [여기](https://github.com/1Consumption/IDIllust/tree/dev/iOS/Documents/UISynchronization.md)를 참고

`LongPressChanged` 이벤트가 발생하면 `ComponentCollectionView`에서 현재 발생한 좌표를 노티피케이션에 담아서 보냄. 이를 `ColorSelectViewController` 에서 받음. 그런데 `LongPressGesture` 는 `ComponentCollectionView`에 등록되어 있기 때문에 `ColorSelectCollectionView` 와 좌표 매칭이 되지 않음. 이를 `UIView`의 `convert(to:)` 메소드로 변환하려 했으나, `ColorSelectCollectionView`의 contentSize가 parentView의 width 보다 크면 중간 부분이 너무 빠르게 스크롤되어 제대로 선택하지 못하는 문제가 발생 했음. 따라서 contentSize와 parentView의 width를 비례식으로 세워 전달된 point를 변환 했음.

`LongPressEnded` 이벤트가 발생하면 `ColorSelectViewController` 에서 delegate 메소드를 호출 하게 하였음. 이 delegate 메소드는 `CustomizeViewController` 에서 구현을 하게 되었는데, `ColorSelecetView` 를 hidden 처리 해줘야 했기 때문에 `ColorSelectViewController`의 부모 뷰컨트롤러인 `CustomizeViewController` 에서 수행 했음. 또한 선택된 colorId 값을 delegate 메소드 매개변수로 전달하여 어떤 color를 선택했는지 알 수 있게 했음. 그리고 colorId에 맞는 thumbnail image를 서버에 요청해 원하는 color에 대한 이미지를 요청할 수 있음.



## Notification VS Delegate 

`ComponentsCollectionView` 의 이벤트를 전달할 때는 Notification을 사용했고, `ColorSelectCollectionView`의 선택값을 전달할 때는 delegate를 사용했음. 

#### Notification

`ComponentsCollectionView` 의 이벤트는 `CustonizeViewController`, `ColorSelectViewController` 에서 받아서 사용하기 때문에 1:N 이 가능한 Notification을 사용했음. 하지만 Notification을 통해 값을 넘길 때 `userInfo`를 사용해 값을 넘긴다면 key 값을 잘못 입력하는 경우가 생길 수도 있고, 여러군데 분산된 Notification을 관리하기 힘들다는 단점이 있음. 이를 Enum으로 관리해([소스코드](https://github.com/1Consumption/IDIllust/blob/dev/iOS/IDIllust/IDIllust/CustomizeView/ComponentCollectionView/ComponentCollectionViewEvent.swift)) `userInfo`를 사용하지 않고 switch 문 case의 매개변수로 넘겨 개발자의 실수를 줄일 수 있었음. 

#### Delegate

그에 반해 `ColorSelectViewController`의 colorId는 `CustomizeViewController`에서만 쓰이는 1:1 관계임. 따라서 delegate 패턴을 채용했음. 이는 해당 메소드가 어디서 처리되는지 명확하게 알 수 있고, 역할을 분리할 수 있다는 장점이 있음. 하지만 상호참조의 위험이 있으므로, delegate 프로퍼티는 weak로 선언하였음.