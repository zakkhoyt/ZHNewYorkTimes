//
//  ZHNYTManager.h
//  ZHNewYorkTimes
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNYTArticle.h"
#import "ZHNYTPagination.h"

// Completion block protos
typedef void (^ZHNYTManagerArticlesBlock) (NSArray <ZHNYTArticle*> *articles, ZHNYTPagination *pagination, NSError *error);
typedef void (^ZHNYTArticleBlock)(NSData *data, NSError *eror);

@interface ZHNYTManager : NSObject

// Singleton which contains instance of NSURLSession
+(instancetype)sharedInstance;

// Returns next page of articles as an array of ZHNYTArticle objects and updated pagination object. Also NSError if any.
-(void)getArticlesWithPagination:(ZHNYTPagination*)pagination completionBlock:(ZHNYTManagerArticlesBlock)completionBlock;

// Returns the article's HTML content as NSData and NSError if any
-(void)getArticle:(ZHNYTArticle*)article completionBlock:(ZHNYTArticleBlock)completionBlock;

// Print the available cache to the console
-(void)printCache;
@end
