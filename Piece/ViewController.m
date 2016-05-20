//
//  ViewController.m
//  Piece
//
//  Created by 金小平 on 15/11/4.
//  Copyright © 2015年 金小平. All rights reserved.
//

#import "ViewController.h"
#import "SimpleHttp.h"
#import "JPUSHService.h"
#import "CHKeychain.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ViewController

extern NSString *userId;


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)unwindToHome:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)login:(id)sender
{

    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    
    
    [SimpleHttp requestLogin:username withPassword:password responseBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict[@"error"]) {
                NSLog(@"dictionary error : %@", dict[@"error"]);
            } else {
                NSLog(@"dict: %@", dict);
                userId = dict[@"user_id"];
                
                [JPUSHService setTags:nil alias:userId callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];

                NSLog(@"user id: %@", userId);
                // save u/p to Keychain
                NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
                [usernamepasswordKVPairs setObject:username forKey:KEY_USERNAME];
                [usernamepasswordKVPairs setObject:password forKey:KEY_PASSWORD];
                [CHKeychain save:KEY_USERNAME_PASSWORD data:usernamepasswordKVPairs];
                
                // check note
                [SimpleHttp checkNote:userId responseBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    NSLog(@"result is : %@", result);
                    if ([result[@"status"] compare:@"0"] == NSOrderedSame) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self performSegueWithIdentifier:@"noteReview" sender:self];
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self performSegueWithIdentifier:@"chatFriend" sender:self];
                        });
                    }
                }];
                

                
            }
        } else {
            NSLog(@"error : %@", error);
        }
    }];
    
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString = [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,tags, alias];

    NSLog(@"TagsAlias回调:%@", callbackString);
}


@end
