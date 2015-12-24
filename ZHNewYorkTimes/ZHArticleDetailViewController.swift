//
//  ZHArticleDetailViewController.swift
//  ZHNewYorkTimes
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

import UIKit

class ZHArticleDetailViewController: ZHViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var article: ZHNYTArticle? = nil {
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scalesPageToFit = true
        
//        if ZHReachability.isConnectedToNetwork() == false {
//            self.presentAlertDialogWithMessage("Please check your internet connection and try again")
//        } else {
            if let webUrl = article?.webUrl {
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                let request = NSURLRequest(URL: webUrl, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 30.0)
                webView.loadRequest(request)
            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ZHArticleDetailViewController: UIWebViewDelegate {    
    func webViewDidFinishLoad(webView: UIWebView) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        if let error = error {
            print("Error: " + error.localizedDescription)
        }
    }
}