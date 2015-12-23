//
//  ZHNYTPagination.m
//  ZHNewYorkTimes
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHNYTPagination.h"

@implementation ZHNYTPagination

- (instancetype)initWithPage:(NSUInteger)page perPage:(NSUInteger)perPage totalCount:(NSUInteger)totalCount {
    self = [super init];
    if (self) {
        _page = page;
        _perPage = perPage;
        _totalCount = totalCount;
    }
    return self;
}
@end
