//
//  TutorialViewController.swift
//  IDIllust
//
//  Created by 신한섭 on 2020/11/16.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

final class TutorialViewController: UIViewController {
    
    static let identifier: String = "tutorialViewController"
    
    @IBOutlet weak var tutorialScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipButton: BorderPaddingButton!
    
    private let tutorialViewModel: TutorialViewModel = TutorialViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
