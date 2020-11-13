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
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveResult(_:didFinishSavingWithError:contextInfo:)), nil)
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
    
    private func showConfirmAlert(title: String, message: String) {
        let alert = UIAlertController().confirmAlert(title: title, message: message)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showSaveFailureAlert() {
        let failure = UIAlertController(title: "권한 요청", message: "당신의 IDIllust를 앨범에 저장하기 위해서는 Photo Library에 대한 권한이 필요합니다.", preferredStyle: .alert)
        failure.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        failure.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
        }))
        
        present(failure, animated: true, completion: nil)
    }
    
    @objc func saveResult(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            showConfirmAlert(title: "저장 실패", message: "당신의 IDIllust를 저장하는 도중 문제가 발생했습니다.")
            return
        }
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized, .limited: showConfirmAlert(title: "저장 성공", message: "당신의 IDIllust가 PhotoLibrary에 성공적으로 저장되었습니다.")
        case .denied: showSaveFailureAlert()
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
