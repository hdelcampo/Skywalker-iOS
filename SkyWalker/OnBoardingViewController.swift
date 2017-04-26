//
//  OnBoardingViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 25/4/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import UIKit
import AVFoundation

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

    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
        pageViewController?.pagerControlValueChanged(index: sender.currentPage)
    }
    
}
