//
//  OnBoardingViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 25/4/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import UIKit
import AVFoundation

/**
 On Boarding View Controller.
*/
class OnBoardingViewController: UIViewController, OnBoardingPagerViewControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var pagerContainer: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var loginButton: UIButton!
    
    /**
        Pager view controller inside the view.
    */
    var pageViewController: OnBoardingPagerViewController?
    
    /**
        The carrousel page changing handler
    */
    var carrouselTimer: Timer?
    
    /**
        The inital time between pages change
    */
    let carrouselTime = 1.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.borderColor = loginButton.tintColor.cgColor
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        carrouselTimer = Timer.scheduledTimer(timeInterval: carrouselTime, target: self, selector: #selector(changePage(_:)), userInfo: nil, repeats: true)
        if (!OrientationSensor.isAvailable()) {
            onIncompatibleDevice()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        carrouselTimer?.invalidate()
    }
    
    /**
        Handles when the device is not compatible, warning user and preventing login.
    */
    private func onIncompatibleDevice () {
        
        self.loginButton.isEnabled = false
        
        let alert = UIAlertController(title: NSLocalizedString("incompatible_device_title", comment: ""),
                                      message: NSLocalizedString("incompatible_device_msg", comment: ""),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""),
                                      style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    /**
        Changes page.
        - Parameter value: Caller.
    */
    func changePage(_ value: Any) {
        let currentIndex = pageControl.currentPage
        
        let newIndex = currentIndex == pageControl.numberOfPages - 1 ? 0 : currentIndex + 1
        
        let pages = pageViewController?.orderedViewControllers
        pageViewController?.setViewControllers([(pages?[newIndex])!],
                                               direction: newIndex == 0 ?
                                                UIPageViewControllerNavigationDirection.reverse : UIPageViewControllerNavigationDirection.forward,
                                               animated: true,
                                               completion: { _ in
            self.pageControl.currentPage = newIndex
        })
        
        if ( carrouselTime == carrouselTimer?.timeInterval) {
            carrouselTimer?.invalidate()
            carrouselTimer = Timer.scheduledTimer(timeInterval: carrouselTime*2, target: self, selector: #selector(changePage(_:)), userInfo: nil, repeats: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? OnBoardingPagerViewController {
            pageViewController = controller
            pageViewController!.pagerDelegate = self
        }
    }
    
    /*
        Handler for login button click.
        Checks if App has enough permissions, and if not asks for them, once granted, login screen will be shown.
    */
    @IBAction func loginClick() {
        if (hasCameraPermission()) {
            present(storyboard!.instantiateViewController(withIdentifier: "loginView"), animated: true, completion: nil)
        } else {
            requestCameraPermission()
        }
    }
    
    
    /*
     Checks whether user has granted camera permissions.
     - Returns: True if permissions are granted, false otherwise.
     */
    private func hasCameraPermission() -> Bool {
        return (.authorized ==
            AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo))
    }
    
    /**
        Requests camera permission to the user.
    */
    private func requestCameraPermission () {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo,
                                      completionHandler: {granted in
                                        if (!granted) {
                                            self.requestCameraPermission()
                                        } else {
                                            self.present(self.storyboard!.instantiateViewController(withIdentifier: "loginView"), animated: true, completion: nil)
                                        }
        })
    }

    // MARK: Pager Control
    
    func updatePageControlCount(_ viewController: OnBoardingPagerViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func updatePageControlIndex(_ viewController: OnBoardingPagerViewController,
                                    didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
    func updatingPage() {
        carrouselTimer?.invalidate()
    }

    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
        pageViewController?.pagerControlValueChanged(index: sender.currentPage)
        updatingPage()
    }
    
}
