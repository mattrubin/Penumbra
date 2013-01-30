//
//  PENSuggestedUsersViewController.m
//  Penumbra
//
//  Created by Me on 1/30/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import "PENSuggestedUsersViewController.h"


@interface PENSuggestedUsersViewController ()

@property (nonatomic, assign, getter = isFetching) BOOL fetching;
@property (nonatomic, assign) NSUInteger outstandingFetches;
//@property (nonatomic, strong) NSMutableArray *usersYouFollow;
@property (nonatomic, strong) NSCountedSet *bag;
@property (nonatomic, strong) NSArray *suggestedIds;
@property (nonatomic, strong) NSMutableArray *suggestedUsers;
@property (nonatomic, assign, getter = isReadyForMoreUsers) BOOL readyForMoreUsers;

@end


@implementation PENSuggestedUsersViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(fetch) forControlEvents:UIControlEventValueChanged];
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self fetch];
}

- (void)fetch
{
    if (self.isFetching) return;
    self.fetching = YES;
    [self.refreshControl beginRefreshing];
    
    self.bag = [NSCountedSet set];
    self.suggestedUsers = [NSMutableArray arrayWithCapacity:0];
    self.readyForMoreUsers = NO;
    [self.tableView reloadData];

    self.outstandingFetches = 0;

    self.outstandingFetches++;
    [[ADNClient sharedClient] getFollowedUserIdsForUser:@"me" withCompletionHandler:^(NSArray *objects, ADNMetadata *meta, NSError *error) {
        self.outstandingFetches--;
        
        for (NSString *idOfUserYouFollow in objects) {
            
            self.outstandingFetches++;
            [[ADNClient sharedClient] getFollowedUserIdsForUser:idOfUserYouFollow withCompletionHandler:^(NSArray *objects, ADNMetadata *meta, NSError *error) {
                self.outstandingFetches--;
                //NSLog(@"FOF %@ recieved, %i fetches reamining", idOfUserYouFollow, self.outstandingFetches);
                
                for (NSString *idOfUserTheyFollow in objects) {
                    [self.bag addObject:idOfUserTheyFollow];
                    //NSLog(@" %@ (%i)", idOfUserTheyFollow, [self.bag countForObject:idOfUserTheyFollow]);
                }
                
                if (!self.outstandingFetches) {
                    self.fetching = NO;
                    [self.refreshControl endRefreshing];
                    
                    [self processFetchedData];
                }
            }];
        }
    }];
}

- (void)processFetchedData
{
    NSMutableArray *dictArray = [NSMutableArray array];
    for (NSString *userId in self.bag) {
        NSDictionary *dict = @{@"userId":userId, @"count":@([self.bag countForObject:userId])};
        [dictArray addObject:dict];
    }
    NSArray *final = [dictArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO ]]];
    
    self.suggestedIds = final;
    self.suggestedUsers = [NSMutableArray arrayWithCapacity:self.suggestedIds.count];
    [self fetchUserInfo];
    [self.tableView reloadData];
    
}

- (void)fetchUserInfo
{
    self.readyForMoreUsers = NO;
    NSUInteger fetchCount = 20;
    NSUInteger startingIndex = self.suggestedUsers.count;
    
    NSMutableArray *usersToFetch = [NSMutableArray arrayWithCapacity:fetchCount];
    for (NSUInteger i=startingIndex; i<startingIndex+fetchCount; i++) {
        [usersToFetch addObject:[[self.suggestedIds objectAtIndex:i] objectForKey:@"userId"]];
    }
    
    for (NSString *userId in usersToFetch) {
        NSLog(@"%@", userId);
    }

    [[ADNClient sharedClient] getUsers:usersToFetch withCompletionHandler:^(NSArray *objects, ADNMetadata *meta, NSError *error) {
        //for (ADNUser *user in objects) {
        //    NSLog(@"%@: %@", user.userId, user.name);
        //}
        
        [self.tableView beginUpdates];
        
        for (NSUInteger i=startingIndex; i<startingIndex+fetchCount; i++) {
            NSString *userId = [[self.suggestedIds objectAtIndex:i] objectForKey:@"userId"];
            
            NSPredicate *p = [NSPredicate predicateWithFormat:@"userId = %@", userId];
            NSArray *matchedUsers = [objects filteredArrayUsingPredicate:p];
            
            if (matchedUsers.count == 1) {
                ADNUser *user = [matchedUsers objectAtIndex:0];
                NSLog(@"%@: %@", user.userId, user.name);
                [self.suggestedUsers addObject:user];
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                NSLog(@"ERROR: found more than one user with id %@", userId);
            }
            
        }
        
        [self.tableView endUpdates];
        
        if (startingIndex+fetchCount < self.suggestedIds.count) {
            self.readyForMoreUsers = YES;
        }

    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.suggestedUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    ADNUser *user = [self.suggestedUsers objectAtIndex:indexPath.row];
    NSDictionary *userInfo = [self.suggestedIds objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", user.name, [userInfo objectForKey:@"count"]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)) {
//        NSLog(@"bottom!");
        if (self.isReadyForMoreUsers) {
            NSLog(@"GET MORE!!");
            [self fetchUserInfo];
        }
        //NSLog(@"%@", [self getLastMessageID]);
        //[self getMoreStuff:[self getLastMessageID]];
    }
}

@end
