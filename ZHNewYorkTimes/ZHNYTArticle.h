//
//  ZHNYTArticle.h
//  ZHNewYorkTimes
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZHNYTArticle : NSObject
@property (nonatomic, strong) NSURL *webUrl;
@property (nonatomic, strong) NSString *snippet;
@property (nonatomic, strong) NSString *leadParagraph;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *uuid;




- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
