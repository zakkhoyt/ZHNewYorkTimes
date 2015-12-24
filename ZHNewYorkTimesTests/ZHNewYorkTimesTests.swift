//
//  ZHNewYorkTimesTests.swift
//  ZHNewYorkTimesTests
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

import XCTest
@testable import ZHNewYorkTimes

class ZHNewYorkTimesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testArticles() {
        // Get a page of articles
        ZHNYTManager.sharedInstance().getArticlesWithPagination(nil) { (articles: [ZHNYTArticle]!, pagination: ZHNYTPagination!, error: NSError!) -> Void in
            XCTAssert(error == nil, "Error received back from get first page of articles")
            XCTAssert(articles != nil, "Received no articles")
            XCTAssert(articles.count >= 10, "Failed to receive a full page of articles")
            
            // Get first article
            let article = articles.first
            ZHNYTManager.sharedInstance().getArticle(article, completionBlock: { (data: NSData!, error: NSError!) -> Void in
                XCTAssert(error == nil, "Error received back from get article detail")
                XCTAssert(data != nil, "Received no data")
            })
        }
    }
}
