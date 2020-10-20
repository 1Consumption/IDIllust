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
    
    // MARK: Properties
    private var entryImage: EntryImage? {
        didSet {
            setEntryImage()
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        entryImageView.kf.indicatorType = .activity
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
    
    private func setEntryImage() {
        guard let imageURL = entryImage?.url else { return }
        DispatchQueue.main.async { [weak self] in
            self?.entryImageView.kf.setImage(with: URL(string: imageURL))
        }
    }
}
