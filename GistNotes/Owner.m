//
//  Owner.m
//  GistNotes
//
//  Created by Veaceslav Macarov on 08.09.15.
//  Copyright (c) 2015 Veaceslav Macarov. All rights reserved.
//

#import "Owner.h"

#define kParameterAvatar @"avatar_url"
#define kParameterLogin @"login"

@implementation Owner
@synthesize avatarUrl, login;

- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        avatarUrl = info[kParameterAvatar];
        login = info[kParameterLogin];
    }
    return self;
}
@end
