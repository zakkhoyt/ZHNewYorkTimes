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

typedef void (^ZHNYTManagerArticlesBlock) (NSArray <ZHNYTArticle*> *articles, ZHNYTPagination *pagination, NSError *error);
typedef void (^ZHNYTArticleBlock)(NSData *data, NSError *eror);

@interface ZHNYTManager : NSObject
+(instancetype)sharedInstance;
-(void)getArticlesWithPagination:(ZHNYTPagination*)pagination completionBlock:(ZHNYTManagerArticlesBlock)completionBlock;
-(void)getArticle:(ZHNYTArticle*)article completionBlock:(ZHNYTArticleBlock)completionBlock;
-(void)printCache;
@end
