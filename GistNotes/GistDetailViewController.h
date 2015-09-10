//
//  GistDetailViewController.h
//  GistNotes
//
//  Created by Veaceslav Macarov on 08.09.15.
//  Copyright (c) 2015 Veaceslav Macarov. All rights reserved.
//

#import "ViewController.h"
//-- Models
#import "Gist.h"

@interface GistDetailViewController : ViewController
@property (strong, nonatomic) Gist *selectedGist;
@property (strong, nonatomic) NSString *aTitle;
@property (nonatomic) BOOL original;
@end
