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

@interface NoteViewController()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NoteViewController

extern NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadImage];

}

- (NSURL *)documentsDirectoryURL
{
    NSError *error = nil;
    NSURL *url = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                        inDomain:NSUserDomainMask
                                               appropriateForURL:nil
                                                          create:NO
                                                           error:&error];
    if (error) {
        // Figure out what went wrong and handle the error.
    }
    
    return url;
}

- (void)loadImage {

    /* For Test
     ANRImageStore *imageStore = ANRImageStore.sharedStore;
     UIImage *storedImage = [imageStore imageForKey:@"avatar"];
     self.imageView.image = storedImage;
     */
    
    [SimpleHttp downloadAvatar:userId responseBlock:^(NSURL *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            
            NSError *openDataError = nil;
            NSData *temp = [NSData dataWithContentsOfURL:data
                                                 options:kNilOptions
                                                   error:&openDataError];
            
            if (openDataError) {
                NSLog(@"open error is %@", [openDataError localizedDescription]);
            }
            NSURL *documentsDirectoryURL = [self documentsDirectoryURL];
            NSURL *saveLocation = [documentsDirectoryURL URLByAppendingPathComponent:@"NSURLSession.png"];
            NSError *saveError = nil;
            BOOL writeWasSuccessful = [temp writeToURL:saveLocation
                                                         options:kNilOptions
                                                           error:&saveError];
            UIImage *downloadImage =[UIImage imageWithData:[NSData dataWithContentsOfURL:saveLocation]];
            ANRImageStore *imageStore = ANRImageStore.sharedStore;
            [imageStore setImage:downloadImage forKey:@"avatar"];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                ANRImageStore *imageStore = ANRImageStore.sharedStore;
                UIImage *storedImage = [imageStore imageForKey:@"avatar"];
                self.imageView.image = storedImage;
            });
        } else {
            NSLog(@"error : %@", error);
        }
        
    }];
}

@end
