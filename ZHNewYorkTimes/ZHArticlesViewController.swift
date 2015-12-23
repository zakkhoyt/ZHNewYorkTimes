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
    var pagination: ZHNYTPagination? = nil
    var isGettingNextPage: Bool = false
    var refreshControl: UIRefreshControl? =  nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        resetNYT()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // TODO: dump some of the articles. Those which are far away on the tableView
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueArticlesToDetail {
            let vc = segue.destinationViewController as? ZHArticleDetailViewController
            vc?.article = sender as? ZHNYTArticle
        }
    }
    
    func setupTableView() {
        // Setup TableView
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Add pull to refresh control
        refreshControl = UIRefreshControl()
        let attr = [NSForegroundColorAttributeName : UIColor.yellowColor()]
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attr)
        refreshControl?.tintColor = UIColor.yellowColor()
        refreshControl?.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    func refreshControlAction(sender: UIRefreshControl) {
        sender.endRefreshing()
        resetNYT()
    }
    
    func resetNYT() {
        // We don't want to wipe the tableView unless we know there is an active connection.
        if ZHReachability.isConnectedToNetwork() == false {
            self.presentAlertDialogWithMessage("Please check your internet connection and try again")
        } else {
            // Clear any articles, wipe the tableView, reset pagination.
            articles.removeAll()
            tableView.reloadData()
            pagination = nil
            
            // Get new articles, populate tableView, and mark pagination.
            getNYTArticles()
        }
    }
    
    func getNYTArticles() {
        if ZHReachability.isConnectedToNetwork() == false {
            self.presentAlertDialogWithMessage("Please check your internet connection and try again")
        } else {
            MBProgressHUD.showHUDAddedTo(view, animated: true)
            isGettingNextPage = true
            ZHNYTManager.sharedInstance().getArticlesWithPagination(pagination) { (articles: [ZHNYTArticle]!, pagination: ZHNYTPagination!, error: NSError!) -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if let error = error {
                    print("error: " + error.localizedDescription)
                    self.presentAlertDialogWithTitle("Could not get articles", errorAsMessage: error)
                } else {
                    // Set pagination for next time
                    self.pagination = pagination
                    
                    // Insert new articles
                    let start = self.articles.count
                    self.articles.appendContentsOf(articles)
                    let end = self.articles.count
                    var indexPaths: [NSIndexPath] = []
                    for index in start ..< end {
                        let indexPath = NSIndexPath(forRow: index, inSection: 0)
                        indexPaths.append(indexPath)
                    }
                    self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Right)
                }
                
                // Pause so we don't get a rush of next pages
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.isGettingNextPage = false
                }
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

extension ZHArticlesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentSize.height == 0 || self.isGettingNextPage {
            return;
        } else if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height {
            getNYTArticles()
        }
    }
}



