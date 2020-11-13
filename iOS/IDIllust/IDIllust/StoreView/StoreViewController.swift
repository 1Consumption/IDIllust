//
//  StoreViewController.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/11/09.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Kingfisher
import Photos
import UIKit

final class StoreViewController: UIViewController {
    
    @IBAction func cancelButtonPushed(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func store(_ sender: Any) {
        guard let image = resultImageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(checkPermission(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var currentLimitLabel: UILabel!
    @IBOutlet weak var titleLimitLabel: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!
    private var textLengthViewModel: Dynamic<Int> = Dynamic<Int>()
    private var images: [UIImage?] = [UIImage?]()
    private let limit: Int = 10
    var layerInfo: [LayerOrder: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundColor()
        setTitleLimitLabel()
        setUpTextLengthViewModel()
        titleTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveImages()
        overlayImages()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func setUpBackgroundColor() {
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0)
    }
    
    private func setTitleLimitLabel() {
        titleLimitLabel.text = String(limit)
    }
    
    private func setUpTextLengthViewModel() {
        textLengthViewModel.bind { [weak self] in
            self?.currentLimitLabel.text = String($0 ?? 0)
        }
        textLengthViewModel.fire()
    }
    
    private func retrieveImages() {
        layerInfo?.sorted { $0.key < $1.key }.forEach { layers in
            guard let cacheKey = URL(string: layers.value)?.cacheKey else { return }
            ImageCache.default.retrieveImage(forKey: cacheKey,
                                             options: [.loadDiskFileSynchronously],
                                             completionHandler: { [weak self] in
                                                switch $0 {
                                                case .success(let sequence):
                                                    self?.images.append(sequence.image)
                                                    
                                                case .failure(_): break
                                                // Todo: Error Alert 띄워주기
                                                }
                                             })
        }
    }
    
    private func overlayImages() {
        guard let size = images.first??.size else { return }
        
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        
        let box = CGRect(origin: .zero, size: size)
        
        images.forEach {
            $0?.draw(in: box)
        }
        
        let overlayedimage = UIGraphicsGetImageFromCurrentImageContext()
        resultImageView.image = overlayedimage
    }
    
    @objc func checkPermission(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized, .limited:
            print("authorized")
            
        case .denied:
            print("denied")
        default: break
        }
    }
}

extension StoreViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textLength = textField.text?.count else { return true }
        let length = textLength + string.count - range.length
        
        guard length <= limit else { return false }
        
        textLengthViewModel.value = length
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
