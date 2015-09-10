//
//  GistEntity.h
//  GistNotes
//
//  Created by Veaceslav Macarov on 09.09.15.
//  Copyright (c) 2015 Veaceslav Macarov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NoteEntity;

@interface GistEntity : NSManagedObject

@property (nonatomic, retain) NSString *gistDescription;
@property (nonatomic, retain) NSString *gistDate;
@property (nonatomic, retain) NSString *avatarPath;
@property (nonatomic, retain) NSString *userLogin;
@property (nonatomic, retain) NSString *gistId;
@property (nonatomic, retain) NoteEntity *gistNote;

@end
