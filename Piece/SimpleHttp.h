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
+ (void)downloadAvatar: (NSString *)userId responseBlock:(void(^)(NSURL *data, NSURLResponse *response, NSError *error))block;
+ (void)uploadAvatar2: (NSString *)userId avatar:(UIImage *)image;
+ (void)updateProfile: (NSString *)userId withGender:(NSString *)gender withBirthDay:(NSString *)birthDay withBirthPlace:(NSString *)birthPlace;
+ (void)getNote: (NSString *)userId responseBlock:(void(^)(NSData *data, NSURLResponse *response, NSError *error))block;
+ (void)createNote: (NSString *)userId withNote:(NSString *)note;
+ (void)getUserInfo: (NSString *)userId responseBlock:(void(^)(NSData *data, NSURLResponse *response, NSError *error))block;
+ (void)contactSync: (NSString *)userId withContacts: (NSString *)contacts responseBlock:(void(^)(NSData *data, NSURLResponse *response, NSError *error))block;
@end

#endif /* SimpleHttp_h */
