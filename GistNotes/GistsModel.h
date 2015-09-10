//
//  GistsModel.h
//  GistNotes
//
//  Created by Veaceslav Macarov on 08.09.15.
//  Copyright (c) 2015 Veaceslav Macarov. All rights reserved.
//

#import <Foundation/Foundation.h>
//-- Models
#import "Gist.h"

@protocol GistsModelDelegate;

@interface GistsModel : NSObject
@property (strong, nonatomic) NSMutableArray *gists;
@property (weak, nonatomic) id<GistsModelDelegate> delegate;
- (void)retrieveGists;
- (void)retrieveNotes;
- (void)downloadGists;
- (Gist*)getGistOriginalWithId:(NSString*)gistId;
- (void)saveNote:(NSString*)noteId description:(NSString*)noteDescription text:(NSString*)noteText;
@end

@protocol GistsModelDelegate
- (void)gistsRetrieveSucceed;
- (void)gistsRetrieveFailed;
@end