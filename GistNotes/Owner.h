//
//  Owner.h
//  GistNotes
//
//  Created by Veaceslav Macarov on 08.09.15.
//  Copyright (c) 2015 Veaceslav Macarov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Owner : NSObject
@property (strong, nonatomic) NSString *avatarUrl;
@property (strong, nonatomic) NSString *login;

- (instancetype)initWithInfo:(NSDictionary*)info;
@end
