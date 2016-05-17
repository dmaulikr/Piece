//
//  Friend.h
//  Piece
//
//  Created by 金小平 on 16/4/22.
//  Copyright © 2016年 金小平. All rights reserved.
//

#import <Realm/Realm.h>

@interface Letter : RLMObject
@property NSString             *textContent;
@property NSString             *imageContent;
@property NSInteger            imageFlag;
@property NSDate               *updateAt;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Letter>
RLM_ARRAY_TYPE(Letter)



