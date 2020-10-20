//
//  EntryViewController.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/09/03.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Kingfisher
import UIKit

final class EntryViewController: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var entryImageView: UIImageView!
    
    // MARK: - Properties
    private var entryImage: EntryImage?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        entryImageUseCase()
    }
    
    // MARK: - Methods
    private func entryImageUseCase() {
        EntryImageUseCase()
            .retrieveEntryImageInfo(networkManager: NetworkManager(),
                                    failureHandler: { _ in
                                        // Todo: UseCaseError에 따른 예외 처리
                                    },
                                    successHandler: { [weak self] in
                                        self?.entryImage = $0
                                    })
    }
}
