//
//  ZHNYTArticle.h
//  ZHNewYorkTimes
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZHNYTArticle : NSObject

// Although the NYT API has several more properties, these are the only ones we will use.
@property (nonatomic, strong) NSURL *webUrl;
@property (nonatomic, strong) NSString *snippet;
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSDate *publishDate;
@property (nonatomic, strong) NSURL *multimedia;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
