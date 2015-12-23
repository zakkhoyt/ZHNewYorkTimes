//
//  ZHNYTPagination.m
//  ZHNewYorkTimes
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHNYTPagination.h"

const NSUInteger ZHNYTPaginationPageSize = 10;

@implementation ZHNYTPagination

- (instancetype)init {
    self = [super init];
    if (self) {
        _page = 0;
        _perPage = ZHNYTPaginationPageSize;
    }
    return self;
}
@end
