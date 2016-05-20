//
//  CHKeychain.h
//  Piece
//
//  Created by 金小平 on 16/5/19.
//  Copyright © 2016年 金小平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

#define KEY_PASSWORD  @"com.jpj.piece.password"
#define KEY_USERNAME  @"com.jpj.piece.username"
#define KEY_USERNAME_PASSWORD @"com.jpj.piece.usernamepassword"

@interface CHKeychain : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;
@end