//
//  PeopleViewController.h
//  Piece
//
//  Created by 金小平 on 15/12/23.
//  Copyright © 2015年 金小平. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *friendCreate;
@property (weak, nonatomic) IBOutlet UITableView *friendTable;

@end
