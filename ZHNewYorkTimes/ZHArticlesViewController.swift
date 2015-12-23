//
//  ZHArticlesViewController.swift
//  ZHNewYorkTimes
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

import UIKit


let SegueArticlesToDetail = "SegueArticlesToDetail"

class ZHArticlesViewController: ZHViewController {

    var articles: [ZHNYTArticle] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        getNextPage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueArticlesToDetail {
            let vc = segue.destinationViewController as? ZHArticleDetailViewController
            vc?.article = sender as? ZHNYTArticle
        }
    }

    func getNextPage() {
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        ZHNYTManager.sharedInstance().getArticlesWithPagination(0) { (articles: [ZHNYTArticle]!, error: NSError!) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if let error = error {
                print("error: " + error.localizedDescription)
            } else {
                print("Retrieved \(articles.count) articles")
                self.articles = articles
                // TODO: Append data instead of reload
                self.tableView.reloadData()
            }
        }
    }
}

extension ZHArticlesViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ZHArticleTableViewCell") as? ZHArticleTableViewCell
        let article = self.articles[indexPath.row]
        cell!.article = article
        return cell!
    }
}

extension ZHArticlesViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let article = self.articles[indexPath.row]
        performSegueWithIdentifier(SegueArticlesToDetail, sender: article)
    }
}



