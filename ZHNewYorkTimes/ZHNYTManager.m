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
        
        // Setup cache
        NSURLCache *cache = [[NSURLCache alloc]initWithMemoryCapacity:50 * 1024 * 1024
                                                         diskCapacity:200 * 1024 * 1024
                                                             diskPath:nil];
        [NSURLCache setSharedURLCache:cache];
        
        // Setup session
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.allowsCellularAccess = YES;
        config.HTTPMaximumConnectionsPerHost = 1;
        config.URLCache = [NSURLCache sharedURLCache];
        config.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
        
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue new]];
    }
    return self;
}

-(void)getArticlesWithPagination:(ZHNYTPagination*)pagination completionBlock:(ZHNYTManagerArticlesBlock)completionBlock {
    
    // Create a pagination object if none was passed in
    if(pagination == nil) {
        pagination = [ZHNYTPagination new];
    }
    
    // Build our GET URL
    NSString *urlString = [NSString stringWithFormat:@"http://api.nytimes.com/svc/search/v2/articlesearch.json"
                           @"?q=new+york+times"
                           @"&page=%lu"
                           @"&sort=newest"
                           @"&api-key=%@",
                           pagination.page,
                           ZHNYTKey];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Request json. This completionHandler will be run on a background queue as configured in init.
    // We will call this function's completionHandler on the main queue.
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    NSURLSessionDataTask *articlesTask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, nil, error);
            });
        } else {
            
            [self printCache];
            
            NSError *jsonError = nil;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            if(jsonError != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, nil, jsonError);
                });
            } else {
                // Get pagination
                NSNumber *offsetNumber = [jsonDictionary valueForKeyPath:@"response.meta.offset"];
                NSUInteger page = offsetNumber.unsignedIntegerValue / pagination.perPage + 1;
                pagination.page = page;
                
                // Get articles
                NSArray <NSDictionary *> *articleDictionaries = [jsonDictionary valueForKeyPath:@"response.docs"];
                NSMutableArray *articles = [[NSMutableArray alloc]initWithCapacity:articleDictionaries.count];
                [articleDictionaries enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZHNYTArticle *article = [[ZHNYTArticle alloc]initWithDictionary:dictionary];
                    [articles addObject:article];
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(articles, pagination, nil);
                });
            }
        }
    }];
    
    
    [articlesTask resume];
    
}


-(void)getArticle:(ZHNYTArticle*)article completionBlock:(ZHNYTArticleBlock)completionBlock{
    
    // Request article data. This completionHandler will be run on a background queue as configured in init.
    // We will call this function's completionHandler on the main queue.
    NSURLRequest *request = [NSURLRequest requestWithURL:article.webUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    NSURLSessionDataTask *articleTask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        } else {
            
            [self printCache];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(data, nil);
            });
        }
    }];
    
    
    [articleTask resume];
}

-(void)printCache{
    NSLog(@"DiskCache: %@ of %@", @([[NSURLCache sharedURLCache] currentDiskUsage]), @([[NSURLCache sharedURLCache] diskCapacity]));
    NSLog(@"MemoryCache: %@ of %@", @([[NSURLCache sharedURLCache] currentMemoryUsage]), @([[NSURLCache sharedURLCache] memoryCapacity]));
    
}
@end
