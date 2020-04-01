//
//  BankDict.h
//  OHMySQLDemo
//
//  Created by Bryant Reyn on 2019/11/28.
//  Copyright © 2019 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankDict : NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)NSUInteger id;
@property (nonatomic,assign)NSInteger money;


- (instancetype)initWithDict:(NSMutableDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
