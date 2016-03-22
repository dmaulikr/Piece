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
@property (strong, nonatomic) IBOutlet UISearchDisplayController *friendSearchDisplay;

@end

@implementation SearchViewController



NSArray *results;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.friendSearch.delegate = self;
    self.friendSearchDisplay.delegate = self;
    self.friendSearchDisplay.searchResultsDataSource = self;
    self.friendSearchDisplay.searchResultsDelegate = self;
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
        
    }];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    NSLog(@"User canceled search");
    [searchBar resignFirstResponder]; // if you want the keyboard to go away
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomTableCell";
    UITableViewCell *ResultTableView;
    return ResultTableView;
}

@end
