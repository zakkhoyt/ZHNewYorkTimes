//
//  ZHViewController.swift
//  ZHNewYorkTimes
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

import UIKit

class ZHViewController: UIViewController {
    @IBOutlet weak var offlineView: UIVisualEffectView!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let offlineView = self.offlineView {
            offlineView.hidden = true
        }
    }
}
