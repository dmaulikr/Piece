//
//  DetailMessageViewController.h
//  Piece
//
//  Created by 金小平 on 15/12/23.
//  Copyright © 2015年 金小平. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailMessageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

- (void)setMessageText: (NSString *)value;
@end
