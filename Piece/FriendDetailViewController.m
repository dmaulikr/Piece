//
//  FriendDetailViewController.m
//  Piece
//
//  Created by 金小平 on 16/4/28.
//  Copyright © 2016年 金小平. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "SimpleHttp.h"

@interface FriendDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *friendMessage;
@property (weak, nonatomic) IBOutlet UIButton *addFriend;

@end

@implementation FriendDetailViewController

NSString *friendText;
NSString *friendId;
extern NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.friendMessage setText:friendText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addFriend:(id)sender {
    
    [SimpleHttp addFriend:userId withFriend:friendId responseBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"data: %@, response: %@",data,response);
        if (error) {
            NSLog(@"something wrong");
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setFriendText: (NSString *)value
{
    friendText = value;
}

- (void)setFriendId: (NSString *)value
{
    friendId = value;
}


@end
