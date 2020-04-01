//
//  ViewController.m
//  OHMySQLDemo
//
//  Created by Bryant Reyn on 2019/11/28.
//  Copyright © 2019 Bryant Reyn. All rights reserved.
//

#import "ViewController.h"
#import "OHMySQL/OHMySQL.h"
#import "BankDict.h"

@interface ViewController ()
@property (nonatomic,strong)OHMySQLStoreCoordinator *coordinator;
@property (nonatomic,strong)NSMutableArray *array;
@end

@implementation ViewController

#pragma mark - array

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //建立数据库连接
    [self connnectMySQL];

    //判断是否连接成功
    [self connectionTrueORFalse];
//    //插入数据
//    [self deleteMySQL];
//    //查询数据库
    [self selectMySQL];
//    [self joinMySQL];
    //取消数据库连接
    [self disConnectMySQL];
}


#pragma mark - 建立数据库连接
- (void)connnectMySQL{
    //初始化数据库MySQL
    /*
     root@localhost:3306
     jdbc:mysql://localhost:3306/?user=root
     */
    /*
      模拟器为 /tmp/mysql.sock
      真机测试 nil
     */
    OHMySQLUser *user = [[OHMySQLUser alloc] initWithUserName:@"root" password:@"06250414" serverName:@"localhost" dbName:@"bank" port:3306 socket:@"/tmp/mysql.sock"];
    //建立数据库连接
    OHMySQLStoreCoordinator *coordinator = [[OHMySQLStoreCoordinator alloc] initWithUser:user];
    _coordinator = coordinator;
    //连接数据库
    [coordinator connect];
}

#pragma mark - 判断是否连接成功
- (void)connectionTrueORFalse{
    if (_coordinator.isConnected) {
        NSLog(@"Connection Successed...");
    }else{
        NSLog(@"Connection Error...");
    }
}

#pragma mark - 查询数据库
- (void)selectMySQL{
    NSLog(@"%s",__func__);
    //建立查询上下文
    OHMySQLQueryContext *query = [OHMySQLQueryContext new];
    query.storeCoordinator = _coordinator;
    
    //select * from bank.account - query查询
    OHMySQLQueryRequest *request = [OHMySQLQueryRequestFactory SELECT:@"account" condition:@"id=2"];
    NSError *error = nil;
    NSArray *tasks = [query executeQueryRequestAndFetchResult:request error:&error];
    NSLog(@"%@",tasks);
    if (tasks) {
        _array = [NSMutableArray array];
        for (NSMutableDictionary *dict in tasks) {
            NSLog(@"dict is %@",dict);
            BankDict *bandDict = [[BankDict alloc] initWithDict:dict];
            [_array addObject:bandDict];
        }
    }
}


#pragma mark - 插入数据
- (void)insertMySQL{
    OHMySQLQueryContext *query = [[OHMySQLQueryContext alloc] init];
    query.storeCoordinator = _coordinator;
    
    NSDictionary *dict = [NSDictionary dictionary];
    dict = @{@"id":@5,@"name":@"WEIHONGYAN",@"money":@10};
    OHMySQLQueryRequest *request = [OHMySQLQueryRequestFactory INSERT:@"account" set:dict];
    
    NSError *error = nil;
    [query executeQueryRequest:request error:&error];
}

#pragma mark - 修改数据
- (void)updateMySQL{
    OHMySQLQueryContext *queryContext = [[OHMySQLQueryContext alloc] init];
    queryContext.storeCoordinator = _coordinator;
    NSDictionary *dict = [NSDictionary dictionary];
    dict = @{@"money":@100};
    OHMySQLQueryRequest *request = [OHMySQLQueryRequestFactory UPDATE:@"account" set:dict condition:@"id=5"];
    NSError *error = nil;
    [queryContext executeQueryRequest:request error:&error];
}

#pragma mark - 多表连接查询
- (void)joinMySQL{
    OHMySQLQueryContext *queryContext = [[OHMySQLQueryContext alloc] init];
    queryContext.storeCoordinator = _coordinator;
    OHMySQLQueryRequest *request = [OHMySQLQueryRequestFactory JOINType:OHJoinInner fromTable:@"account" columnNames:@[@"id",@"name",@"money"] joinOn:@{@"user":@"account.id=user.id"}];
    NSArray *tasks = [queryContext executeQueryRequestAndFetchResult:request error:nil];
    if (tasks) {
        _array = [NSMutableArray array];
        for (NSMutableDictionary *dict in tasks) {
            BankDict *bandDict = [[BankDict alloc] initWithDict:dict];
            [_array addObject:bandDict];
        }
    }
}

#pragma mark - 删除数据
- (void)deleteMySQL{
    OHMySQLQueryContext *queryContext = [[OHMySQLQueryContext alloc] init];
    queryContext.storeCoordinator = _coordinator;
    OHMySQLQueryRequest *request = [OHMySQLQueryRequestFactory DELETE:@"account" condition:@"id=5"];
    NSError *error = nil;
    [queryContext executeQueryRequest:request error:&error];
}

#pragma mark - 取消连接数据库
- (void)disConnectMySQL{
    [_coordinator disconnect];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if(cell == NULL){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    BankDict *dictTest = self.array[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"%@ -- %zd",dictTest.name,dictTest.money];
    cell.textLabel.text = text;
    return cell;
}
@end
