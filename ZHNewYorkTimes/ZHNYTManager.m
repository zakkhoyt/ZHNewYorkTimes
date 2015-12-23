//
//  ZHNYTManager.m
//  ZHNewYorkTimes
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHNYTManager.h"


@interface ZHNYTManager ()
@property (nonatomic, strong) NSURLSession *session;
@end


@interface ZHNYTManager (NSURLSessionDelegate) <NSURLSessionDelegate>
@end

@interface ZHNYTManager (NSURLSessionTaskDelegate) <NSURLSessionTaskDelegate>
@end

@implementation ZHNYTManager

+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ZHNYTManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.allowsCellularAccess = YES;
        config.HTTPMaximumConnectionsPerHost = 1;
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue new]];

    }
    return self;
}

-(void)getArticlesWithPagination:(NSUInteger)page completionBlock:(ZHNYTManagerArticlesErrorBlock)completionBlock{
    
    NSURL *url = [NSURL URLWithString:@"http://api.nytimes.com/svc/search/v2/articlesearch.json?q=new+york+times&page=0&sort=oldest&api-key=3b224e328771da446ab6c6c5a23c427b:13:73834071"];
    
    NSURLSessionDataTask *articlesTask = [_session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        } else {
            NSError *jsonError = nil;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            if(jsonError != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, jsonError);
                });
            } else {
                NSArray <NSDictionary *> *articleDictionaries = [jsonDictionary valueForKeyPath:@"response.docs"];
                NSMutableArray *articles = [[NSMutableArray alloc]initWithCapacity:articleDictionaries.count];
                [articleDictionaries enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZHNYTArticle *article = [[ZHNYTArticle alloc]initWithDictionary:dictionary];
                    [articles addObject:article];
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(articles, nil);
                });                
            }
        }
    }];
    
    [articlesTask resume];
    
}
@end
