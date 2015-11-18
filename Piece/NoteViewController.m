//
//  NoteViewController.m
//  Piece
//
//  Created by 金小平 on 15/11/18.
//  Copyright © 2015年 金小平. All rights reserved.
//

#import "NoteViewController.h"
#import "ANRImageStore.h"

@interface NoteViewController()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ANRImageStore *imageStore = ANRImageStore.sharedStore;
    UIImage *storedImage = [imageStore imageForKey:@"avatar"];
    self.imageView.image = storedImage;
}

@end
