//
//  SimpleHttp.h
//  Piece
//
//  Created by 金小平 on 15/11/14.
//  Copyright © 2015年 金小平. All rights reserved.
//

#ifndef SimpleHttp_h
#define SimpleHttp_h

#import <UIKit/UIKit.h>

@interface SimpleHttp : NSObject

+ (void)requestLogin:(NSString *)name withPassword:(NSString *)password responseBlock:(void(^)(NSData *data, NSURLResponse *response, NSError *error))block;
+ (void)requestRegister:(NSString *)name withPassword:(NSString *)password;
+ (void)uploadAvatar: (NSString *)userId avatar:(UIImage *)image;
+ (void)downloadAvatar: (NSString *)userId;

@end

#endif /* SimpleHttp_h */
