//
//  Friend.m
//  Piece
//
//  Created by 金小平 on 16/4/22.
//  Copyright © 2016年 金小平. All rights reserved.
//

#import "DataModel.h"

@implementation Friend

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end

@implementation Letter

- (NSArray *) fromWho {
    return [self linkingObjectsOfClass:@"Friend" forProperty:@"letters"];
}

@end
