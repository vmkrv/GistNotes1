//
//  GistDetailViewController.m
//  GistNotes
//
//  Created by Veaceslav Macarov on 08.09.15.
//  Copyright (c) 2015 Veaceslav Macarov. All rights reserved.
//

#import "GistDetailViewController.h"
//-- Categories
#import "UIImageView+AFNetworking.h"
//-- Models
#import "GistsModel.h"

@interface GistDetailViewController ()
{
    GistsModel *gistModel;
}
@property (strong,nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong,nonatomic) IBOutlet UILabel *loginLabel;
@property (strong,nonatomic) IBOutlet UITextField *nameTextField;
@property (strong,nonatomic) IBOutlet UITextView *noteTextView;
@property (strong,nonatomic) IBOutlet UIButton *originalButton;
@property (strong,nonatomic) IBOutlet UIButton *saveButton;
@end

@implementation GistDetailViewController
@synthesize avatarImageView, loginLabel, nameTextField, noteTextView, selectedGist;
@synthesize original, originalButton, saveButton;

#pragma mark - App Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.aTitle;
    
    gistModel = [[GistsModel alloc] init];
    
    [avatarImageView setImageWithURL:[NSURL URLWithString:self.selectedGist.owner.avatarUrl] placeholderImage:[UIImage imageNamed:@"noAvatar"]];
    loginLabel.text = selectedGist.owner.login;
    nameTextField.text = selectedGist.gistDescription;
    noteTextView.text = selectedGist.noteText;
    
    if (original) {
        //hide original button and make all fields non-editable
        [originalButton setHidden:YES];
        [saveButton setHidden:YES];
        
        [nameTextField setEnabled:NO];
        [noteTextView setEditable:NO];
    }
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(resignOnSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Selectors

- (IBAction)onSaveChanges:(id)sender
{
    [gistModel saveNote:selectedGist.gistId description:nameTextField.text text:noteTextView.text];
}

- (IBAction)onOriginalGist:(id)sender
{
    Gist *originalGist = [gistModel getGistOriginalWithId:selectedGist.gistId];
    
    UIStoryboard *storyboard = self.storyboard;
    GistDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"gistDetaildID"];
    vc.selectedGist = originalGist;
    vc.aTitle = @"Original gist";
    vc.original = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)resignOnSwipe:(id)sender
{
    [self.view endEditing:YES];
}

@end
