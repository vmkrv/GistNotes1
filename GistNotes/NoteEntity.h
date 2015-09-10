//
//  NoteEntity.h
//  GistNotes
//
//  Created by Veaceslav Macarov on 09.09.15.
//  Copyright (c) 2015 Veaceslav Macarov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GistEntity.h"

@interface NoteEntity : NSManagedObject

@property (nonatomic, retain) NSString *gistDescription;
@property (nonatomic, retain) NSString *gistDate;
@property (nonatomic, retain) NSString *avatarPath;
@property (nonatomic, retain) NSString *userLogin;
@property (nonatomic, retain) NSString *noteText;
@property (nonatomic, retain) NSString *gistId;
@property (nonatomic) BOOL gistEdited;
@property (nonatomic, retain) GistEntity *originalGist;

@end
