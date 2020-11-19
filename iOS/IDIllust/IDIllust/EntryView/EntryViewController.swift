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
    @IBOutlet private weak var entryImageView: UIImageView!
    @IBAction func idIllustButtonPushed(_ sender: Any) {
        presentNextScence()
    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadSelections()
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
    
    private func presentNextScence() {
        guard let isBeginner = UserDefaults.standard.value(forKey: UserDefaults.beginnerKey) as? Bool else {
            presentTutorialViewController()
            return
        }
        
        isBeginner ? presentTutorialViewController() : presentCusomizeViewController(selectionManager: SelectionManager())
    }
    
    private func presentTutorialViewController() {
        guard let tutorialViewController = storyboard?.instantiateViewController(withIdentifier: TutorialViewController.identifier) else { return }
        
        tutorialViewController.modalPresentationStyle = .fullScreen
        present(tutorialViewController, animated: true, completion: nil)
    }
    
    private func loadSelections() {
        guard let selectionManager = SelectionManager(userDefaults: UserDefaults.standard) else { return }
        
        let loadAlert = UIAlertController(title: nil, message: Localization.previousItemEditAlertMessage, preferredStyle: .alert)
        loadAlert.addAction(UIAlertAction(title: Localization.cancel, style: .cancel, handler: { _ in
            selectionManager.removeCurrentSelection(from: UserDefaults.standard)
        }))
        loadAlert.addAction(UIAlertAction(title: Localization.confirm, style: .default, handler: { [weak self] _ in
            self?.presentCusomizeViewController(selectionManager: selectionManager)
        }))
        present(loadAlert, animated: true, completion: nil)
    }
    
    private func presentCusomizeViewController(selectionManager: SelectionManager) {
        guard let customizeViewController = storyboard?.instantiateViewController(identifier: CustomizeViewController.identifier, creator: { (coder) -> CustomizeViewController? in
            CustomizeViewController.init(coder: coder, selectionManager: selectionManager)
        }) else { return }
        
        customizeViewController.modalPresentationStyle = .fullScreen
        present(customizeViewController, animated: true, completion: nil)
    }
}
