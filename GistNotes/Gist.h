//
//  Place.h
//  City Guide
//
//  Created by Veaceslav Macarov on 23.08.15.
//  Copyright (c) 2015 Veaceslav Macarov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Owner.h"
#import "NoteEntity.h"

@interface Gist : NSObject

@property (strong, nonatomic) NSString *gistId;
@property (strong, nonatomic) NSString *gistDescription;
@property (strong, nonatomic) NSString *createdDate;
@property (strong, nonatomic) NSString *noteText;
@property (strong, nonatomic) Owner *owner;

- (instancetype)initWithInfo:(NSDictionary*)info;
- (instancetype)initWithEntity:(NoteEntity *)noteEntity;
@end
