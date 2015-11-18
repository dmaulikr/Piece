//
//  ANRImageStore.m
//  Piece
//
//  Created by 金小平 on 15/11/16.
//  Copyright © 2015年 金小平. All rights reserved.
//

#import "ANRImageStore.h"

@interface ANRImageStore()

@property (nonatomic,strong) NSMutableDictionary *dictionary;

@end

@implementation ANRImageStore

+ (instancetype)sharedStore
{
    static ANRImageStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[ImageStore sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    [self.dictionary setObject:image forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key
{
    return [self.dictionary objectForKey:key];
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    [self.dictionary removeObjectForKey:key];
}


@end
