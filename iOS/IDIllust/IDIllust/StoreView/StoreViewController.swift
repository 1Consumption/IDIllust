//
//  StoreViewController.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/11/09.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

final class StoreViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    private let limit: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0)
        titleTextField.delegate = self
    }
}
extension StoreViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textLength = textField.text?.count else { return true }
        let length = textLength + string.count - range.length
        
        return length <= limit
    }
}
