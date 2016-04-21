//
//  Friend.h
//  Piece
//
//  Created by 金小平 on 16/4/22.
//  Copyright © 2016年 金小平. All rights reserved.
//

#import <Realm/Realm.h>

@interface Friend : RLMObject
@property NSString             *name;
@property NSInteger            *status;
@property NSString             *avatar;
@property NSDate               *birthdate;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Friend>
RLM_ARRAY_TYPE(Friend)
