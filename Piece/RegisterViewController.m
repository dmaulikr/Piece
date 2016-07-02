//
//  RegisterViewController.m
//  Piece
//
//  Created by 金小平 on 15/11/8.
//  Copyright © 2015年 金小平. All rights reserved.
//

#import "RegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "SimpleHttp.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UITextField *phonenumberText;
@property (weak, nonatomic) IBOutlet UITextField *verifynumberText;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


@end

@implementation RegisterViewController

bool isVerified = NO;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setVerifyHidden:NO];
    [self setPasswordHidden:YES];

}

- (void)setPasswordHidden: (bool)isHidden {
    [self.passwordLabel setHidden:isHidden];
    [self.passwordText setHidden:isHidden];
    [self.nextButton setHidden:isHidden];
}

- (void)setVerifyHidden: (bool)isHidden {
    [self.verifynumberText setHidden:isHidden];
    [self.verifyButton setHidden:isHidden];
    [self.confirmButton setHidden:isHidden];
}

- (IBAction)confirmPhoneNumber:(id)sender {
    
    if (isVerified && self.verifynumberText.text.length >0 && self.phonenumberText.text.length > 0) {
        
        [SMSSDK  commitVerificationCode:self.verifynumberText.text
                            phoneNumber:self.phonenumberText.text
                                   zone:@"86"
                                 result:^(NSError *error) {
                                     if (!error) {
                                         NSLog(@"验证成功");
                                         [self setPasswordHidden:NO];
                                         [self setVerifyHidden:YES];
                                         
                                     } else {
                                         NSLog(@"验证失败");
                                     }
                                 }];
    }
}


- (IBAction)verifyCode:(id)sender {
    if (!isVerified && self.phonenumberText.text.length > 0) {
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
         //这个参数可以选择是通过发送验证码还是语言来获取验证码
                                phoneNumber:self.phonenumberText.text
                                       zone:@"86"
                           customIdentifier:nil //自定义短信模板标识
                                 result:^(NSError *error) {
                                     if (!error) {
                                         NSLog(@"block 获取验证码成功");
                                         isVerified = YES;
            
                                     } else {
            
                                         UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                                                         message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                                                        delegate:self
                                                                               cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                                               otherButtonTitles:nil, nil];
                                         [alert show];
            
                                     }
                                 }];
    }

}
- (IBAction)nexEvent:(id)sender {
    /*
    NSString *username = self.phonenumberText.text;
    NSString *password = self.passwordText.text;
    
    [SimpleHttp requestRegister:username withPassword:password];
    */
    
    // For test
    [self performSegueWithIdentifier:@"profileView" sender:self];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
