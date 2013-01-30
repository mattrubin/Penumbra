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
@property (nonatomic, strong) NSMutableArray *suggestedUsers;

@end


@implementation PENSuggestedUsersViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.bag = [NSCountedSet set];
        self.outstandingFetches = 0;
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
    
    if (!self.isFetching) {
        [self fetch];
    }
}

- (void)fetch
{
    self.fetching = YES;
    
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
    NSLog(@"%@",final);
    
    self.suggestedUsers = final;
    [self.tableView reloadData];
    
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
    NSDictionary *userDict = [self.suggestedUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", [userDict objectForKey:@"userId"], [userDict objectForKey:@"count"]];
    
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

@end
