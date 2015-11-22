//
//  SimpleHttp.m
//  Piece
//
//  Created by 金小平 on 15/11/14.
//  Copyright © 2015年 金小平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleHttp.h"
#import <UIKit/UIKit.h>

@implementation SimpleHttp

+ (void)requestLogin:(NSString *)name withPassword:(NSString *)password responseBlock:(void(^)(NSData *data, NSURLResponse *response, NSError *error))block
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
                                                    completionHandler:block];
        [dataTask resume];
    }
    
}

+ (void)requestRegister:(NSString *)name withPassword:(NSString *)password
{
    
    //NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://127.0.0.1:3000/users/register"]];
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

+ (void)uploadAvatar: (NSString *)userId avatar:(UIImage *)image;
{
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    NSURLSession *session = [NSURLSession sharedSession];

    NSString *avatarURL = [NSString stringWithFormat:@"http://127.0.0.1:3000/profile/upload?userId=%@",userId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:avatarURL]];
    request.HTTPMethod = @"POST";
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    NSError *error = nil;
    NSData *bodyData = UIImageJPEGRepresentation(image, 0.75);
    request.HTTPBody = bodyData;
    
    if (!error) {
        
        [indicator startAnimating];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (!error) {
                                                            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                                            if (dict[@"error"]) {
                                                                NSLog(@"dictionary error : %@", dict[@"error"]);
                                                            } else {
                                                                NSLog(@"%@", dict[@"status"]);
                                                            }
                                                        } else {
                                                            NSLog(@"error : %@", error.description);
                                                        }
                                                        
                                                        [NSThread sleepForTimeInterval:5.0f];
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            [indicator stopAnimating];
                                                            
                                                            [indicator removeFromSuperview];
                                                            
                                                        });
                                                    }];
        [dataTask resume];
    }
    
}

+ (void)downAvatar: (NSString *)userId
{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *avatarURL = [NSString stringWithFormat:@"http://127.0.0.1:3000/profile/avatar"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:avatarURL]];
    request.HTTPMethod = @"POST";
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *dictionary = @{@"userId":userId};
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
                                                                NSLog(@"%@", dict);
                                                            }
                                                        } else {
                                                            NSLog(@"error : %@", error.description);
                                                        }
                                                        
                                                    }];
        [dataTask resume];
    }
    
}

@end