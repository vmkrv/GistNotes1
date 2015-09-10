//
//  AllInOneViewController.m
//  GistNotes
//
//  Created by Veaceslav Macarov on 09.09.15.
//  Copyright (c) 2015 Veaceslav Macarov. All rights reserved.
//

#import "AllInOneViewController.h"
//-- Controllers
#import "GistDetailViewController.h"
//-- Models
#import "GistsModel.h"
#import "Gist.h"

@interface AllInOneViewController () <UITabBarDelegate,GistsModelDelegate>
{
    GistsModel *gistModel;
}
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AllInOneViewController
@synthesize tabBar;

#pragma mark - App Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"All in one";
    
    tabBar.delegate = self;
    gistModel = [[GistsModel alloc] init];
    gistModel.delegate = self;
    [gistModel retrieveGists];
    
    [tabBar setSelectedItem:tabBar.items[0]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (tabBar.selectedItem.tag == 0) {
        [gistModel retrieveGists];
    } else {
        [gistModel retrieveNotes];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - GistsModelDelegate

- (void)gistsRetrieveSucceed
{
    [self.tableView reloadData];
}

- (void)gistsRetrieveFailed
{
    
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 0) {
        [gistModel retrieveGists];
    } else {
        [gistModel retrieveNotes];
    }
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
