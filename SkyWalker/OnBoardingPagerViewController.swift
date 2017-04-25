//
//  EntryViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 6/4/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import UIKit
import AVFoundation

class OnBoardingPagerViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pagerDelegate: OnBoardingPagerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        pagerDelegate?.pageViewController(self, didUpdatePageCount: orderedViewControllers.count)
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        if (!hasCameraPermission()) {
            requestCameraPermission()
        }
        
    }
    
    // MARK: View Pager
    
    /**
        The pages to show
    */
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newPage(label:"pageOne"), self.newPage(label:"pageTwo"), self.newPage(label:"pageThree")]
    }()
    
    /**
        Creates a new page view
        - Parameters:
            - label: The view storyboard's id
    */
    private func newPage(label: String) -> UIViewController {
        return storyboard!.instantiateViewController(withIdentifier:label)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            pagerDelegate?.pageViewController(self, didUpdatePageIndex: index)
        }
    }
    
    /**
        Checks whether user has granted camera permissions.
     
        - Returns: True if permissions are granted, false otherwise.
    */
    private func hasCameraPermission() -> Bool {
        return (.authorized ==
            AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo))
    }
    
    private func requestCameraPermission () {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo,
                                      completionHandler: { (granted : Bool) -> Void in
                                        if (!granted) {
                                            self.requestCameraPermission()
                                        }
        })
    }

}

protocol OnBoardingPagerViewControllerDelegate {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func pageViewController(_ viewController: OnBoardingPagerViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func pageViewController(_ viewController: OnBoardingPagerViewController,
                                    didUpdatePageIndex index: Int)
    
}
