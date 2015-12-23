//
//  ZHNYTManager.m
//  ZHNewYorkTimes
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHNYTManager.h"

static NSString *ZHNYTKey = @"3b224e328771da446ab6c6c5a23c427b:13:73834071";

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

-(void)getArticlesWithPagination:(ZHNYTPagination*)pagination completionBlock:(ZHNYTManagerArticlesrBlock)completionBlock {
    
    // Create a pagination object if none was passed in
    if(pagination == nil) {
        pagination = [ZHNYTPagination new];
    }

    // Build our URL
    NSString *urlString = [NSString stringWithFormat:@"http://api.nytimes.com/svc/search/v2/articlesearch.json"
                           @"?q=new+york+times"
                           @"&page=%lu"
                           @"&sort=newest"
                           @"&api-key=%@",
                           pagination.page,
                           ZHNYTKey];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Request json. This completionHandler will be run on a background queue as configured in init.
    // We will call our completionHandler on the main queue.
    NSURLSessionDataTask *articlesTask = [_session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, nil, error);
            });
        } else {
            NSError *jsonError = nil;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            if(jsonError != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, nil, jsonError);
                });
            } else {
                NSArray <NSDictionary *> *articleDictionaries = [jsonDictionary valueForKeyPath:@"response.docs"];
                NSMutableArray *articles = [[NSMutableArray alloc]initWithCapacity:articleDictionaries.count];
                [articleDictionaries enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZHNYTArticle *article = [[ZHNYTArticle alloc]initWithDictionary:dictionary];
                    [articles addObject:article];
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // TODO: do some checking. Should this be a method?
                    pagination.page++;
                    completionBlock(articles, pagination, nil);
                });                
            }
        }
    }];
    
    [articlesTask resume];
    
}
@end
