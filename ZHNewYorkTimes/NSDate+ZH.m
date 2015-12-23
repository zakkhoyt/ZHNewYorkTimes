//
//  NSDate+ZH.m
//  ZH
//
//  Created by Zakk Hoyt on 4/20/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "NSDate+ZH.h"

@implementation NSDate (ZH)

+(NSDate*)dateFromString:(NSString*)string{
    NSString *dateFormatString = @"yyyy-MM-dd'T'HH:mm:ssZ";

    NSDateFormatter* dateLocal = [[NSDateFormatter alloc] init];
    [dateLocal setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateLocal setDateFormat:dateFormatString];
    
    NSDate *date = [dateLocal dateFromString:string];
    return date;
}

-(NSString*)stringRelativeTimeFromDate{
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    NSUInteger minutes;
    
    NSString* text;
    
    if(self == nil){
        return @"";
    } else if(deltaSeconds < 5) {
        text = @"just now";
    } else if(deltaSeconds < 60) {
        return [NSString stringWithFormat:@"%ld seconds ago", (long)deltaSeconds];
    } else if(deltaSeconds < 120) {
        text = [NSString stringWithFormat:@"a minute ago"];
    } else if (deltaMinutes < 60) {
        return [NSString stringWithFormat:@"%ld minutes ago", (long)deltaMinutes];
    } else if (deltaMinutes < 120) {
        text = [NSString stringWithFormat:@"an hour ago"];
    } else if (deltaMinutes < (24 * 60)) {
        minutes = (NSUInteger)floor(deltaMinutes/60);
        return [NSString stringWithFormat:@"%ld hours ago", (long)minutes];
    } else if (deltaMinutes < (24 * 60 * 2)) {
        return @"Yesterday";
    } else if (deltaMinutes < (24 * 60 * 7)) {
        minutes = (NSUInteger)floor(deltaMinutes/(60 * 24));
        return [NSString stringWithFormat:@"%ld days ago", (long)minutes];
    } else if (deltaMinutes < (24 * 60 * 14)) {
        text = [NSString stringWithFormat:@"last week"];
    } else if (deltaMinutes < (24 * 60 * 31)) {
        minutes = (NSUInteger)floor(deltaMinutes/(60 * 24 * 7));
        return [NSString stringWithFormat:@"%ld weeks ago", (long)minutes];
    } else if (deltaMinutes < (24 * 60 * 61)) {
        text = @"last month";
    } else if (deltaMinutes < (24 * 60 * 365.25)) {
        minutes = (NSUInteger)floor(deltaMinutes/(60 * 24 * 30));
        return [NSString stringWithFormat:@"%ld months ago", (long)minutes];
    } else if (deltaMinutes < (24 * 60 * 731)) {
        text = @"last year";
    }
    
    if (!text) {
        minutes = (NSUInteger)floor(deltaMinutes/(60 * 24 * 365));
        text = [NSString stringWithFormat:@"%ld years ago", (long)minutes];
    }
    
    return text;
}




@end