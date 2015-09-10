//
//  AllGistsTableViewController.m
//  GistNotes
//
//  Created by Veaceslav Macarov on 08.09.15.
//  Copyright (c) 2015 Veaceslav Macarov. All rights reserved.
//

#import "AllGistsTableViewController.h"
//--Controllers
#import "GistDetailViewController.h"
//-- Models
#import "GistsModel.h"
#import "Gist.h"

@interface AllGistsTableViewController () <GistsModelDelegate>
{
    GistsModel *gistModel;
}
@end

@implementation AllGistsTableViewController

#pragma mark - App Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.navigationItem.title = @"All gists";
    
    gistModel = [[GistsModel alloc] init];
    gistModel.delegate = self;
    [gistModel retrieveGists];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getGists)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [gistModel retrieveGists];
    [self getGists];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private methods

- (void) getGists
{
    [gistModel downloadGists];
}

- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - GistsModelDelegate

- (void)gistsRetrieveSucceed
{
    [self reloadData];
}

- (void)gistsRetrieveFailed
{
   // [self.refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return gistModel.gists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Gist *gist = gistModel.gists[indexPath.row];
    cell.textLabel.text = gist.gistDescription;
    cell.detailTextLabel.text = gist.createdDate;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Gist *gist = gistModel.gists[indexPath.row];
    
    UIStoryboard *storyboard = self.storyboard;
    GistDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"gistDetaildID"];
    vc.selectedGist = gist;
    vc.aTitle = @"Gist";
    vc.original = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
