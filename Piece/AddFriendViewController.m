//
//  AddFriendViewController.m
//  Piece
//
//  Created by 金小平 on 16/1/10.
//  Copyright © 2016年 金小平. All rights reserved.
//

#import "AddFriendViewController.h"
#import "FriendType.h"
#import "JPUSHService.h"

@interface AddFriendViewController ()
@property (weak, nonatomic) IBOutlet UITableView *receivedFriend;


@end

@implementation AddFriendViewController

static AddFriendViewController *_addFriendViewController;

@synthesize receivedFriendList = _receivedFriendList;
NSString *myFriendMessage;
NSString *myfriendId;

NSUInteger myFriendStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *myArray = [[NSMutableArray alloc] initWithCapacity:1];
    self.receivedFriendList = myArray;
    
    // Do any additional setup after loading the view.
    self.receivedFriend.delegate = self;
    self.receivedFriend.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.receivedFriendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *ResultTableView = [tableView dequeueReusableCellWithIdentifier:
                                        CellIdentifier];
    if (ResultTableView == nil) {
        ResultTableView = [[UITableViewCell alloc]
                           initWithStyle:UITableViewCellStyleDefault
                           reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NSLog(@"row text: %@", [self.receivedFriendList objectAtIndex:row]);
    FriendType *resultFt = [self.receivedFriendList objectAtIndex:row];
    ResultTableView.textLabel.text = resultFt.friendName;
    return ResultTableView;
}

#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    FriendType *passFt = [self.receivedFriendList objectAtIndex:row];
    myFriendMessage = [[NSString alloc]initWithFormat:@"From %@!",passFt.friendName];
    
    myfriendId = passFt.friendId;
    
    [self performSegueWithIdentifier:@"myFriend" sender:nil];
    
}



/*

- (void)setFriendInfo: (NSString *)name friendId:(NSString *)friendId friendStatus:(NSUInteger)status;
{
    
    FriendType *ft = [[FriendType alloc] init];
    ft.friendId = friendId;
    ft.friendName = name;
    
    NSLog(@"set friend info: %@", name);

    [self.receivedFriendList addObject:ft];
    [self.receivedFriend reloadData];
}
 */

@end
