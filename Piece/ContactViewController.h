//
//  ContactViewController.h
//  Piece
//
//  Created by 金小平 on 16/1/10.
//  Copyright © 2016年 金小平. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *list; 
@end
