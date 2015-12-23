//
//  ZHNYTArticle.m
//  ZHNewYorkTimes
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHNYTArticle.h"

@implementation ZHNYTArticle

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
//        @property (nonatomic, strong) NSURL *webUrl;
//        @property (nonatomic, strong) NSString *snippet;
//        @property (nonatomic, strong) NSString *leadParagraph;
//        @property (nonatomic, strong) NSString *source;
//        @property (nonatomic, strong) NSString *headline;
//        @property (nonatomic, strong) NSString *uuid;
        if(dictionary[@"web_url"]) {
            self.webUrl = [NSURL URLWithString:dictionary[@"web_url"]];
        }
        if(dictionary[@"_id"]) {
            self.uuid = dictionary[@"_id"];
        }
        if(dictionary[@"snippet"]) {
            self.snippet = dictionary[@"snippet"];
        }

        if( [dictionary valueForKeyPath:@"headline.main"]) {
            self.headline = [dictionary valueForKeyPath:@"headline.main"];
        }

    }
    return self;
}
@end
