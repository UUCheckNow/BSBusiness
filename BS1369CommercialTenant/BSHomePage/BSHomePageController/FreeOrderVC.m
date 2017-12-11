//
//  FreeOrderVC.m
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/17.
//  Copyright © 2015年 UU. All rights reserved.
//

#import "FreeOrderVC.h"
#import "BSSetNavigationView.h"
#import "Common.h"

#import "MyMD5.h"
#import "BSHttpTool.h"
#import "BSparam.h"

#import "FreeOrderTabViewCell.h"

#import <MJRefresh/MJRefresh.h>
#import "MBProgressHUD+MJ.h"



@interface FreeOrderVC () <UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UILabel *footview;
    NSString *allCount;
}

@property(nonatomic,strong) BSparam *bsparam;

@end

@implementation FreeOrderVC

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    allCount = @"0";
    _dataArray = [NSMutableArray array];
    footview = [[UILabel alloc]initWithFrame:CGRectMake(10 , ScreenHeight-40, ScreenWidth, 40)];
    footview.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:footview];
    // Do any additional setup after loading the view.
    [self setNavigation];
    [self getDataFromNet];
    [self createTableView];
    //    下拉刷新
    [self example02];
    //    上拉加载
    [self example12];
}
#pragma mark UITableView + 下拉刷新 动画图片
- (void)example02
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置header
    _tableView.mj_header = header;
}
#pragma mark UITableView + 上拉刷新 动画图片
- (void)example12
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.mj_footer.automaticallyHidden = NO;
}
#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    //    移除数据源数组
    [_dataArray removeAllObjects];
    
    //    从新请求数据
    [self getDataFromNet];
    //    刷新表格
    [_tableView reloadData];
    //    拿到当前的下拉刷新控件，结束刷新状态
    [_tableView.mj_header endRefreshing];
}
#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    //    移除数据源数组
    [_dataArray removeAllObjects];
    [self getDataFromNet];
    [_tableView reloadData];
        if (_dataArray.count == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
}
- (void)setPositionnn:(NSString *)positionnn {
    _positionnn = positionnn;
}
- (void)setNavigation {
    BSSetNavigationView *navg = [BSSetNavigationView navigationWithLeftImageName:@"fanhui" centerTitleName:self.title andFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    navg.backgroundColor = [UIColor whiteColor];
    navg.titleLabel.textColor = [UIColor blackColor];
    navg.delegateVC = self;
    [self.view addSubview:navg];
}
- (void)getDataFromNet {

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _bsparam = [[BSparam alloc]init];
        _bsparam.name = [userDefaults objectForKey:@"loginTel"];
        _bsparam.pwdUrlMd5 = [MyMD5 md5:[userDefaults objectForKey:@"loginPwd"]];
        _bsparam.position = _positionnn;
        _bsparam.iStart = [NSString stringWithFormat:@"%lu",(unsigned long)_dataArray.count];
        _bsparam.max = @"10";
        //    获取星币商圈消费记录 (XBConsumptionNotes)
        [BSHttpTool POST:@"XBConsumptionNotes" parameters:_bsparam success:^(id responseObject) {
            if ([responseObject[@"code"]isEqualToString:@"0"]) {
                allCount = responseObject[@"sumNum"];
                for (NSDictionary *dict in responseObject[@"info"]) {
                    [_dataArray addObject:dict];
                }
                [_tableView reloadData];
            }else {
                [MBProgressHUD showError:responseObject[@"code_text"]];
            }
            footview.text = [NSString stringWithFormat:@"共计：%@条消费记录",allCount];
        } failure:^(NSError *error) {
            NSLog(@"error=%@",[error description]);
        }];
    
}
- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-40) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (![_dataArray isEqual:@""]) {
        return _dataArray.count;
    }else {
    
    return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray.count != 0) {
        return 1;
    }else {
    return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hello"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"hello" forIndexPath:indexPath];
    }
    if (_dataArray.count != 0) {
        static NSString *customCell2 = @"FreeOrderTabViewCell";
        UINib * nib = [UINib nibWithNibName:@"FreeOrderTabViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:customCell2];
        FreeOrderTabViewCell *activeCell = (FreeOrderTabViewCell *)[tableView dequeueReusableCellWithIdentifier:customCell2];
        activeCell.selectionStyle=UITableViewCellSelectionStyleNone;
        activeCell.freeordermodel = _dataArray[indexPath.section];
        
        return activeCell;
        
    }else {
        
    return cell;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
