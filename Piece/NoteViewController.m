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
@property (weak, nonatomic) IBOutlet UITextView *radomTextView;
@property (weak, nonatomic) IBOutlet UITextField *leaveMessageView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation NoteViewController

extern NSString *userId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _nextButton.hidden = true;
    [self loadImage];
    [self loadNoteText];

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

- (void)loadImage
{

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
- (IBAction)leaveMessageChanged:(id)sender {
    _nextButton.hidden = false;
    
}
- (IBAction)nextPage:(id)sender {
    if (_leaveMessageView.text.length > 0) {
        [SimpleHttp createNote:userId withNote:_leaveMessageView.text];
    } else {
        NSLog(@"content has nothing");
    }
}

- (void)loadNoteText
{
    [SimpleHttp getNote:userId responseBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([dict[@"error"] isEqual:[NSNull null]]) {
                NSLog(@"content is %@", dict[@"content"]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.radomTextView.text = dict[@"content"];
                });
            } else {
                NSLog(@"dictionary error : %@", dict[@"error"]);
            }
        } else {
            NSLog(@"error : %@", error);
        }
    }];
}

@end
