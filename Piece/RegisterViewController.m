//
//  RegisterViewController.m
//  Piece
//
//  Created by 金小平 on 15/11/8.
//  Copyright © 2015年 金小平. All rights reserved.
//

#import "RegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UITextField *phonenumberText;
@property (weak, nonatomic) IBOutlet UITextField *verifynumberText;


@end

@implementation RegisterViewController

bool isVerified = NO;

- (void)textFieldChanged:(id)sender {
    UITextField *_field = (UITextField *)sender;
    if (/*isVerified && */_field.text.length >0) {
        [self.verifyButton setTitle:@"confirm" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.verifynumberText addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.passwordLabel setHidden:YES];
    [self.passwordText setHidden:YES];
    [self.nextButton setHidden:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if (isVerified && self.verifynumberText.text.length >0) {
   
        [SMSSDK  commitVerificationCode:self.verifynumberText.text
                            phoneNumber:self.phonenumberText.text
                                   zone:@"86"
                                 result:^(NSError *error) {
                                     if (!error) {
                                         NSLog(@"验证成功");
                                     } else {
                                         NSLog(@"验证失败");
                                     }
                                 }];
    }
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
