//
//  ZHNYTManager.h
//  ZHNewYorkTimes
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNYTArticle.h"

typedef void (^ZHNYTManagerArticlesErrorBlock) (NSArray <ZHNYTArticle*> *articles, NSError *error);

@interface ZHNYTManager : NSObject
+(instancetype)sharedInstance;
-(void)getArticlesWithPagination:(NSUInteger)page completionBlock:(ZHNYTManagerArticlesErrorBlock)completionBlock;
@end
