//
//  GistsModel.m
//  GistNotes
//
//  Created by Veaceslav Macarov on 08.09.15.
//  Copyright (c) 2015 Veaceslav Macarov. All rights reserved.
//

#import "GistsModel.h"
//-- API Clients
#import "GistsAPIClient.h"
//-- CoreData models
#import "GistEntity.h"
#import "NoteEntity.h"
//-- Appdelegate
#import "AppDelegate.h"

@interface GistsModel () <APIClientDelegate> {
    GistsAPIClient *apiClient;
}
@end

@implementation GistsModel
@synthesize gists, delegate;

- (id)init
{
    if (self = [super init]) {
        gists = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public methods

- (void)downloadGists
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        apiClient = [[GistsAPIClient alloc] init];
        apiClient.delegate = self;
        [apiClient retrieveGists];
    });
}

- (void)retrieveGists
{
    [self getData];
}

- (void)retrieveNotes
{
    [gists removeAllObjects];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NoteEntity" inManagedObjectContext:appDelegate.managedObjectContext];
    [request setEntity:entity];
    [request setReturnsObjectsAsFaults:NO];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gistEdited = YES"];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gistDate" ascending:NO selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    for (int i = 0; i < result.count; i++) {
        NoteEntity *noteEntity = result[i];
        Gist *gist = [[Gist alloc] initWithEntity:noteEntity];
        [gists addObject:gist];
    }
    [delegate gistsRetrieveSucceed];
}

- (void)saveNote:(NSString*)noteId description:(NSString*)noteDescription text:(NSString*)noteText
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NoteEntity"
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gistId LIKE %@",noteId];
    [request setPredicate:predicate];
    NSArray *result = [context executeFetchRequest:request error:NULL];
    
    if (result.count > 0) {
        NoteEntity *noteObject = (NoteEntity*)result[0];
        if (noteDescription.length > 0) {
            noteObject.gistDescription = noteDescription;
        }
        if (noteText.length > 0) {
            noteObject.noteText = noteText;
        }
        noteObject.gistEdited = YES;
        [noteObject.managedObjectContext save:nil];
    }
}

- (Gist*)getGistOriginalWithId:(NSString*)gistId
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GistEntity"
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gistId LIKE %@",gistId];
    [request setPredicate:predicate];
    NSArray *result = [context executeFetchRequest:request error:NULL];
    
    NoteEntity *gistObject = (NoteEntity*)result[0];
    Gist *gist = [[Gist alloc] initWithEntity:gistObject];
    
    return gist;
}

# pragma mark - APIClientDelegate

- (void)apiClientReceivedData:(id)receivedData
{
    [self parseReceivedData:receivedData];
}

- (void)apiClientFailed
{
    [delegate gistsRetrieveFailed];
    [self getData];
}

# pragma mark - Private methods

- (void)parseReceivedData:(id)receivedData
{
    [gists removeAllObjects];
    for (NSDictionary *gistInfo in receivedData) {
        Gist *gist = [[Gist alloc] initWithInfo:gistInfo];
        [gists addObject:gist];
    }
    [self saveData];
}

- (void)saveData
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    for (int i = 0; i < gists.count; i++) {
        Gist *gist = gists[i];
        
        if (![self isGistExistWithId:gist.gistId]) {
            // save gist original
            GistEntity *gistObject = [NSEntityDescription insertNewObjectForEntityForName:@"GistEntity"
                                                                   inManagedObjectContext:appDelegate.managedObjectContext];
            [gistObject setGistId:gist.gistId];
            [gistObject setGistDescription:gist.gistDescription];
            [gistObject setGistDate:gist.createdDate];
            [gistObject setAvatarPath:gist.owner.avatarUrl];
            [gistObject setUserLogin:gist.owner.login];
            
            // save gist mutable copy with note
            // create gist
            NoteEntity *noteObject = [NSEntityDescription insertNewObjectForEntityForName:@"NoteEntity"
                                                                   inManagedObjectContext:appDelegate.managedObjectContext];
            [noteObject setGistId:gist.gistId];
            [noteObject setGistDescription:gist.gistDescription];
            [noteObject setGistDate:gist.createdDate];
            [noteObject setAvatarPath:gist.owner.avatarUrl];
            [noteObject setUserLogin:gist.owner.login];
           // [noteObject setNoteText:@""];
        }
    }
    // save data to storage
    [appDelegate saveContext];
    
    [self getData];
}

- (BOOL)isGistExistWithId:(NSString*)gistId
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPredicate:[NSPredicate predicateWithFormat:@"gistId = %@", gistId]];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GistEntity" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];
    if (!error && count > 0){
        return YES;
    } else {
        return NO;
    }
}

- (void)getData
{
    [gists removeAllObjects];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NoteEntity" inManagedObjectContext:appDelegate.managedObjectContext];
    [request setEntity:entity];
    [request setReturnsObjectsAsFaults:NO];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gistDate" ascending:NO selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    for (int i = 0; i < result.count; i++) {
        NoteEntity *gistEntity = result[i];
        Gist *gist = [[Gist alloc] initWithEntity:gistEntity];
        [gists addObject:gist];
    }
    [delegate gistsRetrieveSucceed];
}
@end
