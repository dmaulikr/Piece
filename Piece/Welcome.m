//
//  Welcome.m
//  Piece
//
//  Created by 金小平 on 16/5/21.
//  Copyright © 2016年 金小平. All rights reserved.
//

#import "Welcome.h"
#import "SimpleHttp.h"
#import "CHKeychain.h"
#import "JPUSHService.h"

@interface Welcome ()

@end

@implementation Welcome

extern NSString *userId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self autoLoadView];
}

- (void)autoLoadView {
    
    NSMutableDictionary *usernamepasswordKV = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD];
    NSString *username = (NSString *)[usernamepasswordKV objectForKey:KEY_USERNAME];
    NSString *password = (NSString *)[usernamepasswordKV objectForKey:KEY_PASSWORD];;
    
    if (!username || !password) {
        [self performSegueWithIdentifier:@"loginViewFromWel" sender:self];
    } else {
        
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
                                [self performSegueWithIdentifier:@"noteReviewFromWel" sender:self];
                            });
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self performSegueWithIdentifier:@"chatFriendFromWel" sender:self];
                            });
                        }
                    }];
                    
                    
                    
                }
            } else {
                NSLog(@"error : %@", error);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString = [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,tags, alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}

@end
