//
//  OnBoardingViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 25/4/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController, OnBoardingPagerViewControllerDelegate {

    @IBOutlet weak var pagerContainer: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var loginButton: UIButton!
    
    var pageViewController: OnBoardingPagerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.borderColor = loginButton.tintColor.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? OnBoardingPagerViewController {
            pageViewController = controller
            pageViewController!.pagerDelegate = self
        }
    }
    
    func updatePageControlCount(_ viewController: OnBoardingPagerViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func updatePageControlIndex(_ viewController: OnBoardingPagerViewController,
                                    didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }

    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
        pageViewController?.pagerControlValueChanged(index: sender.currentPage)
    }
    
}
