//
//  Place.m
//  City Guide
//
//  Created by Veaceslav Macarov on 23.08.15.
//  Copyright (c) 2015 Veaceslav Macarov. All rights reserved.
//

#import "Gist.h"

#define kParameterId @"id"
#define kParameterDescription @"description"
#define kParameterDateCreated @"created_at"
#define kParameterOwner @"owner"

#define kParameterAvatar @"avatar_url"
#define kParameterLogin @"login"

@implementation Gist
@synthesize gistId, gistDescription, createdDate, owner, noteText;

#pragma mark - Designated Initializer

- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        gistId = info[kParameterId];
        gistDescription = info[kParameterDescription];
        
        if ([gistDescription isEqual:[NSNull null]]) {
            gistDescription = @"";
        }
        
        createdDate = info[kParameterDateCreated];
        owner = [[Owner alloc] initWithInfo:info[kParameterOwner]];
        noteText = @"";
    }
    return self;
}

- (instancetype)initWithEntity:(NoteEntity *)noteEntity
{
    self = [super init];
    if (self) {
        gistId = noteEntity.gistId;
        gistDescription = noteEntity.gistDescription;
        createdDate = noteEntity.gistDate;
        
        if ([noteEntity respondsToSelector:@selector(noteText)]) {
            noteText = noteEntity.noteText;
        }
        
        NSString *tempAvatarPath;
        NSString *tempLogin;
        if (noteEntity.avatarPath.length > 0) {
            tempAvatarPath = noteEntity.avatarPath;
        } else {
            tempAvatarPath = @"";
        }
        if (noteEntity.userLogin.length > 0) {
            tempLogin = noteEntity.userLogin;
        } else {
           tempLogin = @"";
        }
        NSDictionary *info = @{kParameterAvatar:tempAvatarPath,kParameterLogin:tempLogin};
        owner = [[Owner alloc] initWithInfo:info];
    }
    return self;
}

@end
