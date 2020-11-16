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
        tutorialScrollView.delegate = self
        pageControl.currentPageIndicatorTintColor = .black
        setTutorialViewModel()
    }
    
    private func setTutorialViewModel() {
        tutorialViewModel.bindCurrentPage { [weak self] in
            guard let page = $0 else { return }
            guard let pageControl = self?.pageControl else { return }
            pageControl.currentPage = page
            
            if pageControl.numberOfPages - 1 == page {
                self?.skipButton.setTitle("Start", for: .normal)
            } else {
                self?.skipButton.setTitle("Skip", for: .normal)
            }
        }
        tutorialViewModel.fireCurrentPage()
    }
}

extension TutorialViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let curX = scrollView.contentOffset.x
        let width = view.frame.width
        let page = Int(round(curX / width))
        
        tutorialViewModel.setPage(page)
    }
}
