//
//  PeopleViewController.m
//  Piece
//
//  Created by 金小平 on 15/12/23.
//  Copyright © 2015年 金小平. All rights reserved.
//

#import "PeopleViewController.h"
#import "FriendTableViewCell.h"

@interface PeopleViewController()
@property (nonatomic, retain) NSArray *frinedsArray;
@property (weak, nonatomic) IBOutlet UIView *addFriendView;

@end

@implementation PeopleViewController
@synthesize friendTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.frinedsArray = [NSArray arrayWithObjects:@"Brave new world",@"Call of the Wild",@"Catch-22",@"Atlas Shrugged",@"The Great Gatsby",@"The Art of War",@"The Catcher in the Rye",@"The Picture of Dorian Gray",@"The Grapes of Wrath", @"The Metamorphosis",nil];
    
    self.friendTable.delegate = self;
    self.friendTable.dataSource = self;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.addFriendView addGestureRecognizer:singleFingerTap];
    
 
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"press click on add friend view.");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.frinedsArray.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *friendTableIdentifier = @"FriendTableViewCell";
    
    FriendTableViewCell *cell = (FriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:friendTableIdentifier];
    
    cell.friendName.text = [self.frinedsArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
