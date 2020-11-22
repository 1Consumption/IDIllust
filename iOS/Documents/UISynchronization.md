# UISynchronization

<img width="1922" alt="uisync" src="https://user-images.githubusercontent.com/37682858/99897180-b1a7f800-2cda-11eb-9cfb-4824200dbcc8.png">



## 배경

`CustomizeViewController`는 containerView로 `ColorSelectView`를 가지고 이는 `ColorSelectViewController`의 view를 보여줌.

특정 셀을 길게 눌러 해당 셀 위에 `ColorSelectView`를 띄워야함. 따라서 `LongPressBegan`이 발생한 좌표에 해당하는 colors 모델을 `ColroSelectViewController`에 전달함. `ColroSelectViewController`는 전달받은 colors 모델을 `ColorSelectCollectionView`의 dataSource에 전달하고 reload함. 그리고 `CustomizeView`의 width를 `ColorSelectCollectionView`의 contentSize에 맞게 변경하였음. 그러나 `reloadData()`메소드는 비동기 메소드이기 때문에 reload가 완료되기 전에 `ColorSelectView`의 width를 결정해서 원하는 width만큼 변경이 되지 않음.



## 해결 방법

`DispatchQueue.main`은 Serial Queue임을 이용했음. Serial Queue는 한 번에 하나의 작업만 수행 가능함. 또한 ViewController의 코드는 `DispatchQueue.main.sync` 내에서 돌아감. 따라서 `ColorSelectViewController`에서 `reloadData()`를 실행하고 `DispachQueue.main.async`에서 delegate 메소드를 통해 contentSize를 불렀더니 `reloadData()`가 되고 난 후에 contentSize가 불려서 의도했던 기능을 구현할 수 있었음.



``` swift
colorSelectCollectionView.reloadData()
            
DispatchQueue.async { [weak self] in
    self?.delegate?.colorSelectCollectionViewReloaded(self?.colorSelectCollectionView)
}
```

