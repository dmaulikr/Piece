//
//  MessageTableViewController.m
//  Piece
//
//  Created by 金小平 on 15/12/21.
//  Copyright © 2015年 金小平. All rights reserved.
//

#import "MessageTableViewController.h"
#import "ANRImageStore.h"
#import "DetailMessageViewController.h"

@implementation MessageTableViewController
@synthesize booksArray;
NSString *transformMessage;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.booksArray = [NSArray arrayWithObjects:@"Brave new world",@"Call of the Wild",@"Catch-22",@"Atlas Shrugged",@"The Great Gatsby",@"The Art of War",@"The Catcher in the Rye",@"The Picture of Dorian Gray",@"The Grapes of Wrath", @"The Metamorphosis",nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.booksArray.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    ANRImageStore *imageStore = ANRImageStore.sharedStore;
    UIImage *storedImage = [imageStore imageForKey:@"avatar"];
    cell.imageView.image = storedImage;
    
    cell.textLabel.text = [self.booksArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    transformMessage = [[NSString alloc]initWithFormat:@"From %@!",[self.booksArray objectAtIndex:row]];
    
    [self performSegueWithIdentifier:@"detailMessage" sender:nil];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"detailMessage"]) {
        DetailMessageViewController *detailView = (DetailMessageViewController *)segue.destinationViewController;
        [detailView setMessageText:transformMessage];
    }
    
}
@end
