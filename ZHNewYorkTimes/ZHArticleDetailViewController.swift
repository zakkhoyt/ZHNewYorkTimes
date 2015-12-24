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
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        ZHNYTManager.sharedInstance().getArticle(article) { (data: NSData!, error: NSError!) -> Void in
            // If we have no cache, display alert. Else display cache.
            if data == nil {
                self.presentAlertDialogWithTitle("Check your internet connection", errorAsMessage: error)
            } else {
                self.webView.loadData(data, MIMEType: "text/html", textEncodingName: "UTF-8", baseURL: NSURL())
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
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
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}