//
//  Friend.h
//  Piece
//
//  Created by 金小平 on 16/5/17.
//  Copyright © 2016年 金小平. All rights reserved.
//

#import <Realm/Realm.h>
#import "Letter.h"

@interface Friend : RLMObject
@property NSString             *name;
@property NSInteger            status;
@property NSString             *avatar;
@property NSDate               *birthdate;
@property RLMArray<Letter *><Letter> *letters;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Friend>
RLM_ARRAY_TYPE(Friend)
