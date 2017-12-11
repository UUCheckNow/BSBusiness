//
//  XingbiRecordPresentVC.m
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/17.
//  Copyright © 2015年 UU. All rights reserved.
//

#import "XingbiRecordPresentVC.h"
#import "BSSetNavigationView.h"
#import "Common.h"

#import "MyMD5.h"
#import "BSHttpTool.h"
#import "BSparam.h"

#import "XingbiRecordPreTabCell.h"
#import "RecordPresentModel.h"
#import "MBProgressHUD+MJ.h"

#import <MJRefresh/MJRefresh.h>

@interface XingbiRecordPresentVC ()<UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_footArr;
    UILabel *footview;
}

@property(nonatomic,strong) BSparam *bsparam;
@property(nonatomic,strong) RecordPresentModel *recordPmodel;

@end

@implementation XingbiRecordPresentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    _footArr = [NSMutableArray array];
    self.navigationController.navigationBarHidden = YES;
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
    // 设置正在刷新状态的动画图片
    //[header setImages:@[[UIImage imageNamed:@"refreshHomePageGif"]] forState:MJRefreshStateRefreshing];
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
    [self getDataFromNet];
    [_tableView reloadData];
    // 拿到当前的上拉刷新控件，结束刷新状态
    [_tableView.mj_footer endRefreshing];
}

- (void)setNavigation {
    BSSetNavigationView *navg = [BSSetNavigationView navigationWithLeftImageName:@"redfanhui" centerTitleName:@"星币赠送记录" andFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    navg.delegateVC = self;

    [self.view addSubview:navg];
}

- (void)getDataFromNet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _bsparam = [[BSparam alloc]init];
    
    _bsparam.name = [userDefaults objectForKey:@"loginTel"];
    _bsparam.pwdUrlMd5 = [MyMD5 md5:[userDefaults objectForKey:@"loginPwd"]];
    _bsparam.position = [NSString stringWithFormat:@"%lu",(unsigned long)_dataArray.count];
    _bsparam.max = @"10";
//    获取商户的赠送记录分页 (obtainBusinessGiveRecord)
    [BSHttpTool POST:@"obtainBusinessGiveRecord" parameters:_bsparam success:^(id responseObject) {
        if ([responseObject[@"code"]isEqualToString:@"0"]) {
            for (NSDictionary *item in responseObject[@"item"]) {
                [_dataArray addObject:item];
            }
            for (NSDictionary *info in responseObject[@"info"]) {
                [_footArr addObject:info];
            }
            [_tableView reloadData];
            [self createfootView];
        }else {
            [MBProgressHUD showError:responseObject[@"code_text"]];
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-40) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

        return _dataArray.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hello"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"hello" forIndexPath:indexPath];
    }
    static NSString *customCell2 = @"XingbiRecordPreTabCell";
    UINib * nib = [UINib nibWithNibName:@"XingbiRecordPreTabCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:customCell2];
    XingbiRecordPreTabCell *aCell = (XingbiRecordPreTabCell *)[tableView dequeueReusableCellWithIdentifier:customCell2];
    aCell.recordpresentmodel = _dataArray[indexPath.section];
    aCell.selectionStyle=UITableViewCellSelectionStyleNone;
    return aCell;
}

- (void)createfootView {
    if (_footArr.count != 0) {
        footview.text = [NSString stringWithFormat:@"共计：%@笔   %@星币",[_footArr[0] valueForKey:@"count"],[_footArr[0] valueForKey:@"sum"]];
    }else {
        footview.text = @"共计：0笔   0星币";
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
