//
//  Localization.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/11/19.
//  Copyright © 2020 신한섭. All rights reserved.
//

import Foundation

struct Localization {
    static let tutorialImageName = (1...6).map { String($0) }
    static let skip = "skip".localized()
    static let start = "start".localized()
    static let imageLoadingFailureAlertTitle = "imageLoadingFailureAlertTitle".localized()
    static let imageLoadingFailureAlertMessage = "imageLoadingFailureAlertMessage".localized()
    static let shouldSelectImageAlertMessage = "shouldSelectImageAlertMessage".localized()
    static let saveSuccessAlertTitle = "saveSuccessAlertTitle".localized()
    static let saveSuccessAlertMessage = "saveSuccessAlertMessage".localized()
    static let furtherEditing = "furtherEditing".localized()
    static let createNew = "createNew".localized()
    static let confirm = "confirm".localized()
    static let cancel = "cancel".localized()
    static let settingUp = "settingUp".localized()
    static let previousItemEditAlertMessage = "previousItemEditAlertMessage".localized()
    static let requestForPermissionAlertTitle = "requestForPermissionAlertTitle".localized()
    static let requestForPermissionAlertMessage = "requestForPermissionAlertMessage".localized()
}

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
