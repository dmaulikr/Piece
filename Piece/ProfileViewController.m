//
//  ProfileViewController.m
//  Piece
//
//  Created by 金小平 on 15/11/15.
//  Copyright © 2015年 金小平. All rights reserved.
//

#import "ProfileViewController.h"
#import "ANRImageStore.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileViewController() <UINavigationBarDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end


@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height < self.imageView.frame.size.width?self.imageView.frame.size.height/2:self.imageView.frame.size.width/2;
    self.imageView.clipsToBounds = YES;
    //self.imageView.layer.masksToBounds = YES;

}

- (IBAction)camera:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.imageView.image = image;

    ANRImageStore *imageStore = ANRImageStore.sharedStore;
    [imageStore setImage:image forKey:@"avatar"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
