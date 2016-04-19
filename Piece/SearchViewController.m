//
//  SearchViewController.m
//  Piece
//
//  Created by 金小平 on 16/3/22.
//  Copyright © 2016年 金小平. All rights reserved.
//

#import "SearchViewController.h"
#import "SimpleHttp.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *friendSearch;
@property (weak, nonatomic) IBOutlet UITableView *searchList;

@end

@implementation SearchViewController

@synthesize list = _list;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *array = [[NSArray alloc] initWithObjects:@"美国", @"菲律宾",
                      @"黄岩岛", @"中国", @"泰国", @"越南", @"老挝",
                      @"日本" , nil];
    self.list = array;
    
    self.friendSearch.delegate = self;
    self.searchList.delegate = self;
    self.searchList.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UISearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBar Search Button Clicked");
    [self handleSearch:searchBar];
}
 - (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBar Text Did End Editing");
    [self handleSearch:searchBar];
    
}

- (void)handleSearch:(UISearchBar *)searchBar {
    NSLog(@"User searched for %@", searchBar.text);
    [searchBar resignFirstResponder]; // if you want the keyboard to go away
    [SimpleHttp getUserInfo:searchBar.text responseBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict[@"error"]) {
                NSLog(@"dictionary error : %@", dict[@"error"]);
            } else {
                NSLog(@"%@", dict[@"friend"]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.list = [[NSArray alloc] initWithObjects:dict[@"friend"][@"user_name"], nil];
                    [self.searchList reloadData];
                });
            }
        } else {
            NSLog(@"error : %@", error.description);
        }
    }];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    NSLog(@"User canceled search");
    [searchBar resignFirstResponder]; // if you want the keyboard to go away
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
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
    NSLog(@"row text: %@", [self.list objectAtIndex:row]);
    ResultTableView.textLabel.text = [self.list objectAtIndex:row];
    return ResultTableView;
}

@end
