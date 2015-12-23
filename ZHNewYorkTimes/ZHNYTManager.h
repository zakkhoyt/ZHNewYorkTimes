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

typedef void (^ZHNYTManagerArticlesrBlock) (NSArray <ZHNYTArticle*> *articles, ZHNYTPagination *pagination, NSError *error);

@interface ZHNYTManager : NSObject
+(instancetype)sharedInstance;
-(void)getArticlesWithPagination:(ZHNYTPagination*)pagination completionBlock:(ZHNYTManagerArticlesrBlock)completionBlock;
@end
