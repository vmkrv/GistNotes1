//
//  ViewController.m
//  GistNotes
//
//  Created by Veaceslav Macarov on 08.09.15.
//  Copyright (c) 2015 Veaceslav Macarov. All rights reserved.
//

#import "ViewController.h"
//-- Controllers
#import "AllGistsTableViewController.h"
#import "AllNotesTableViewController.h"
#import "AllInOneViewController.h"

@interface ViewController ()
@end

@implementation ViewController

#pragma mark - App Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Menu";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Selectors

- (IBAction)onAllGists:(id)sender
{
    UIStoryboard *storyboard = self.storyboard;
    AllGistsTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"allGistsID"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onAllNotes:(id)sender
{
    UIStoryboard *storyboard = self.storyboard;
    AllNotesTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"allNotesID"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onAllInOne:(id)sender
{
    UIStoryboard *storyboard = self.storyboard;
    AllInOneViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"allInOneID"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
