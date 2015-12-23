//
//  DetailMessageViewController.m
//  Piece
//
//  Created by 金小平 on 15/12/23.
//  Copyright © 2015年 金小平. All rights reserved.
//

#import "DetailMessageViewController.h"

@implementation DetailMessageViewController

NSString *messageText;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.messageLabel setText:messageText];
}

- (void)setMessageText: (NSString *)value
{
    messageText = value;
}
@end
