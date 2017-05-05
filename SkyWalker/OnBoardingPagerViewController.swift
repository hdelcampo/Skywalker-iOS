//
//  EntryViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 6/4/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

class OnBoardingPagerViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pagerDelegate: OnBoardingPagerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        pagerDelegate?.updatePageControlCount(self, didUpdatePageCount: orderedViewControllers.count)
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
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
            pagerDelegate?.updatePageControlIndex(self, didUpdatePageIndex: index)
        }
    }
    
    
    /*
        Handler for page controller events
        - Parameters:
            - index: the new page index
    */
    func pagerControlValueChanged(index: Int) {
        
        var direction: UIPageViewControllerNavigationDirection
        
        if (orderedViewControllers.index(of: viewControllers!.first!)! - index < 0) {
            direction = .forward
        } else {
            direction = .reverse
        }
        
        setViewControllers([orderedViewControllers[index]], direction: direction, animated: true, completion: nil)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pagerDelegate?.updatingPage()
    }

}

protocol OnBoardingPagerViewControllerDelegate {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func updatePageControlCount(_ viewController: OnBoardingPagerViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func updatePageControlIndex(_ viewController: OnBoardingPagerViewController,
                                    didUpdatePageIndex index: Int)
    
    /**
        Called when a transition to a new page begins
    */
    func updatingPage()
    
}
