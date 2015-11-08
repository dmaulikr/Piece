//
//  ViewController.m
//  Piece
//
//  Created by 金小平 on 15/11/4.
//  Copyright © 2015年 金小平. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ViewController

- (IBAction)login:(id)sender
{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [self requestLogin:username withPassword:password];
    
}

- (void)requestLogin:(NSString *)name withPassword:(NSString *)password
{

    //NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSession *session = [NSURLSession sharedSession];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://127.0.0.1:3000/users/login"]];
    request.HTTPMethod = @"POST";
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *dictionary = @{@"username":name, @"password": password};
    NSError *error = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&error];
    request.HTTPBody = bodyData;
    
    if (!error) {

        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              if (!error) {
                                                                  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                                                  if (dict[@"error"]) {
                                                                      NSLog(@"dictionary error : %@", dict[@"error"]);
                                                                  } else {
                                                                      NSLog(@"%@", dict[@"username"]);
                                                                  }
                                                              } else {
                                                                  NSLog(@"error : %@", error.description);
                                                              }
                                                          }];
        [dataTask resume];
    }

}

@end
