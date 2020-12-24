# UISynchronization

<img width="1922" alt="uisync" src="https://user-images.githubusercontent.com/37682858/99897180-b1a7f800-2cda-11eb-9cfb-4824200dbcc8.png">



## 배경

`CustomizeViewController`는 containerView로 `ColorSelectView`를 가지고 이는 `ColorSelectViewController`의 view를 보여줌.

특정 셀을 길게 눌러 해당 셀 위에 `ColorSelectView`를 띄워야함. 따라서 `LongPressBegan`이 발생한 좌표에 해당하는 colors 모델을 `ColroSelectViewController`에 전달함. `ColroSelectViewController`는 전달받은 colors 모델을 `ColorSelectCollectionView`의 dataSource에 전달하고 reload함. 그리고 `CustomizeView`의 width를 `ColorSelectCollectionView`의 contentSize에 맞게 변경하였음. 그러나 `reloadData()`메소드는 비동기 메소드이기 때문에 reload가 완료되기 전에 `ColorSelectView`의 width를 결정해서 원하는 width만큼 변경이 되지 않음.



## 해결 방법

한 번에 하나의 작업만 수행 가능한 Serial Queue의 속성과 `sync` 작업은 작업을 시킨 객체가 작업이 끝날 때 까지 기다린다는 점을 이용함.

### 작업 큐를 하나 둬서 한번에 하나의 작업만 수행하기.

`reloadQueue` 는 한번에 하나의 작업만 수행 가능한 Serial Queue임. 

첫번째 단락을 보면 async 내에서 DispatchQueue.main.sync 작업을 수행하는데, 이 동안 `reloadQueue`는 DispatchQueue.main.sync 내의 작업이 끝날 때 까지 기다림. 따라서 `reloadData()` 작업이 완료 될 때까지 기다린 다음, 원하는 작업을 수행할 수 있었음.



``` swift
reloadQueue.async { [weak self] in
    self?.reloadColorSelectCollectionViewSynchronous()
}

reloadQueue.async { [weak self] in
    self?.selectItemIfSelectedIdExist()
}

reloadQueue.async { [weak self] in
    self?.delegate?.colorSelectCollectionViewReloaded(self?.colorSelectCollectionView)
}
```

``` swift
private func reloadColorSelectCollectionViewSynchronous() {
  	DispatchQueue.main.sync {
      	colorSelectCollectionView.reloadData()
    }
}
```

