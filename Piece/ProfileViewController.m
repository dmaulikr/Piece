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
#import "SimpleHttp.h"
#import "User.h"

@interface ProfileViewController() <UINavigationBarDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end


@implementation ProfileViewController

extern NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height < self.imageView.frame.size.width?self.imageView.frame.size.height/2:self.imageView.frame.size.width/2;
    self.imageView.clipsToBounds = YES;
    //self.imageView.layer.masksToBounds = YES;

}

- (IBAction)camera:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
    
    [self uploadImage:userId avatar:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage: (NSString *)userId avatar:(UIImage *)image
{
    
    // Build the request body
    NSString *boundary = @"---011000010111000001101001";
    NSMutableData *body = [NSMutableData data];
    // Body part for the attachament. This is an image.
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"avatar"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Setup the session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Content-Type"  : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary],
                                                   @"cache-control": @"no-cache"
                                                   };
    
    // Create the session
    // We can use the delegate to track upload progress
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
    // Data uploading task. We could use NSURLSessionUploadTask instead of NSURLSessionDataTask if we needed to support uploads in the background
    NSString *avatarURL = [NSString stringWithFormat:@"http://127.0.0.1:3000/profile/upload/%@",userId];
    NSURL *url = [NSURL URLWithString:avatarURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    request.HTTPMethod = @"POST";
    request.HTTPBody = body;
    NSURLSessionDataTask *uploadTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict[@"error"]) {
                NSLog(@"dictionary error : %@", dict[@"error"]);
            } else {
                NSLog(@"status : %@", dict[@"status"]);
            }
        } else {
            NSLog(@"error : %@", error);
        }
    }];
    [uploadTask resume];
    
}

@end
