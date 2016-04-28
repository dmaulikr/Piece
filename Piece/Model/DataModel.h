//
//  Friend.h
//  Piece
//
//  Created by 金小平 on 16/4/22.
//  Copyright © 2016年 金小平. All rights reserved.
//

#import <Realm/Realm.h>

@class Friend;

@interface Letter : RLMObject
@property Friend               *fromWho;
@property NSString             *textContent;
@property NSString             *imageContent;
@property NSInteger            *imageFlag;
@property NSDate               *updateAt;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Letter>
RLM_ARRAY_TYPE(Letter)

@interface Friend : RLMObject
@property NSString             *name;
@property NSInteger            *status;
@property NSString             *avatar;
@property NSDate               *birthdate;
@property RLMArray<Letter *><Letter> *letters;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Friend>
RLM_ARRAY_TYPE(Friend)

