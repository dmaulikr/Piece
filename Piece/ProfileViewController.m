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

@interface ProfileViewController() <UINavigationBarDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSwitcher;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *birthDayTextView;
@property (weak, nonatomic) IBOutlet UITextField *birthPlaceTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *doneToolbar;
@property (weak, nonatomic) IBOutlet UIPickerView *placePickerView;

@property (weak, nonatomic) IBOutlet UIToolbar *okToolbar;
@property (weak, nonatomic) NSString *genderValue;

@property (nonatomic, strong) NSArray *areaList;
@property (nonatomic, strong) NSString *currentPlace;
@end


@implementation ProfileViewController

extern NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height < self.imageView.frame.size.width?self.imageView.frame.size.height/2:self.imageView.frame.size.width/2;
    self.imageView.clipsToBounds = YES;
    //self.imageView.layer.masksToBounds = YES;
    
    [self.genderSwitcher addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    _datePickerView.hidden = true;
    _doneToolbar.hidden = true;
    
    [self.placePickerView init];
    _placePickerView.hidden = true;
    _okToolbar.hidden = true;
    //Needed for textFieldShouldBeginEditing
    [_birthDayTextView setDelegate:self];
    _placePickerView.dataSource = self;
    _placePickerView.delegate = self;
    
    self.areaList = @[@[@"1", @"东台"],
                      @[@"2", @"盐城"],
                      @[@"3", @"南京"],
                      @[@"4", @"成都"],
                      @[@"5", @"厦门"],
                      @[@"6", @"上海"],
                      @[@"7", @"北京"]];
    [_birthPlaceTextView setDelegate:self];

}
     
- (void)segmentAction:(UISegmentedControl *)Seg
{
    
    NSInteger index = Seg.selectedSegmentIndex;
    
    switch (index) {
        case 0:
            NSLog(@"male clicked.");
            _genderValue = @"male";
            break;
        case 1:
            NSLog(@"female clicked.");
            _genderValue = @"female";
            break;
        default:
            break;
    }
}
     
- (IBAction)textFieldClicked:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _birthDayTextView.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate: _datePickerView.date]];
    _datePickerView.hidden = false;
    _doneToolbar.hidden = false;
}

- (IBAction)datePickerChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _birthDayTextView.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate: _datePickerView.date]];
}

- (IBAction)closeDatePicker:(id)sender {
    _datePickerView.hidden = true;
    _doneToolbar.hidden = true;
}

- (IBAction)textPlaceFieldClicked:(id)sender {
    _birthPlaceTextView.text = [NSString stringWithFormat:@"%@", self.areaList[0][1]];
    _placePickerView.hidden = false;
    _okToolbar.hidden = false;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.areaList.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.areaList[row][1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Place Picker View: %ld/%@", row, self.areaList[row][1]);
    self.currentPlace = self.areaList[row][1];
     _birthPlaceTextView.text = [NSString stringWithFormat:@"%@", self.currentPlace];
    
}


- (IBAction)closePlacePicker:(id)sender {
    _placePickerView.hidden = true;
    _okToolbar.hidden = true;
}

//Needed to prevent keyboard from opening
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (IBAction)updateProfile:(id)sender {
    NSLog(@"update profile:%@: %@: %@",_genderValue, _birthDayTextView.text, _birthPlaceTextView.text);
    [SimpleHttp updateProfile:userId withGender:_genderValue withBirthDay:_birthDayTextView.text withBirthPlace:_birthPlaceTextView.text];
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
