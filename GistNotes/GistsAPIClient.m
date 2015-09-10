//
//  PlacesAPIClient.m
//  City Guide
//
//  Created by Veaceslav Macarov on 23.08.15.
//  Copyright (c) 2015 Veaceslav Macarov. All rights reserved.
//

#import "GistsAPIClient.h"
#import "AFHTTPSessionManager.h"

#define baseURL @"https://api.github.com/gists/public"

@implementation GistsAPIClient

- (void)retrieveGists
{    
    //-- Request
    __block id delegate = self.delegate;
    
    NSLog(@"!?! Communication Flow. Retrieve gists request");
    NSString *path = [NSString stringWithFormat:@"%@", baseURL];
    NSURL *url = [NSURL URLWithString:path];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"!?! Communication Flow. Retrieve gists request. Success answer");
        [delegate apiClientReceivedData:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"!?! Communication Flow. Retrieve gists request. Failure answer: %@", error);
        [delegate apiClientFailed];
        
    }];
}

@end
