//
//  NoteViewController.m
//  Piece
//
//  Created by 金小平 on 15/11/18.
//  Copyright © 2015年 金小平. All rights reserved.
//

#import "NoteViewController.h"
#import "ANRImageStore.h"
#import "SimpleHttp.h"
#import "User.h"

@interface NoteViewController()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NoteViewController

extern NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* For Test
    ANRImageStore *imageStore = ANRImageStore.sharedStore;
    UIImage *storedImage = [imageStore imageForKey:@"avatar"];
    self.imageView.image = storedImage;
    */
    
    [SimpleHttp downloadAvatar:userId];
}

@end
