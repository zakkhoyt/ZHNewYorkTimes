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
        
        if let webUrl = article?.webUrl {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            let request = NSURLRequest(URL: webUrl)
            webView.loadRequest(request)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    

}

extension ZHArticleDetailViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(webView: UIWebView) {
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
    }
}