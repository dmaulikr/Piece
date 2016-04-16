//
//  SearchViewController.h
//  Piece
//
//  Created by 金小平 on 16/3/22.
//  Copyright © 2016年 金小平. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UISearchControllerDelegate>

@property (strong, nonatomic) NSArray *list; 
@end
