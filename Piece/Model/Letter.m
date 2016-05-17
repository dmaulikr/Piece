//
//  Friend.m
//  Piece
//
//  Created by 金小平 on 16/4/22.
//  Copyright © 2016年 金小平. All rights reserved.
//

#import "Letter.h"

@implementation Letter

- (NSArray *) fromWho {
    return [self linkingObjectsOfClass:@"Friend" forProperty:@"letters"];
}

@end
