//
//  ZHNYTArticle.m
//  ZHNewYorkTimes
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHNYTArticle.h"
#import "NSDate+ZH.h"

@implementation ZHNYTArticle

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
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

        if(dictionary[@"pub_date"]) {
            NSString *dateString = dictionary[@"pub_date"];
            self.publishDate = [NSDate dateFromString:dateString];
        }

        if(dictionary[@"multimedia"]) {
            // Sample return value
//            {
//                height = 126;
//                legacy =     {
//                    wide = "images/2015/12/18/arts/18armory-1/18armory-1-thumbWide.jpg";
//                    wideheight = 126;
//                    widewidth = 190;
//                };
//                subtype = wide;
//                type = image;
//                url = "images/2015/12/18/arts/18armory-1/18armory-1-thumbWide.jpg";
//                width = 190;
//            },
            
            // TODO: Get biggest image possible
            
            NSArray *multimedia = dictionary[@"multimedia"];
            NSDictionary *firstMultimedia = [multimedia firstObject];
            NSString *imageURL = [firstMultimedia valueForKeyPath:@"url"];
            NSString *baseURL = @"http://www.nytimes.com/";
            NSURL *mediaURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, imageURL]];
            self.multimedia = mediaURL;
        }

    }
    return self;
}
@end
