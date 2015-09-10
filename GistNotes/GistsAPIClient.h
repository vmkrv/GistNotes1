//
//  PlacesAPIClient.h
//  City Guide
//
//  Created by Veaceslav Macarov on 23.08.15.
//  Copyright (c) 2015 Veaceslav Macarov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APIClientDelegate;

@interface GistsAPIClient : NSObject
@property (weak, nonatomic) id <APIClientDelegate>    delegate;
- (void)retrieveGists;
@end

@protocol APIClientDelegate <NSObject>
- (void)apiClientReceivedData:(id)receivedData;
- (void)apiClientFailed;
@end