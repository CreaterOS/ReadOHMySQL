//
//  BankDict.m
//  OHMySQLDemo
//
//  Created by Bryant Reyn on 2019/11/28.
//  Copyright © 2019 Bryant Reyn. All rights reserved.
//

#import "BankDict.h"

@implementation BankDict
- (instancetype)initWithDict:(NSMutableDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
