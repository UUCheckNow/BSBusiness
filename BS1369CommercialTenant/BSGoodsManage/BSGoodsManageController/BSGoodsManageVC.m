//
//  BSGoodsManageVC.m
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 16/3/16.
//  Copyright © 2016年 UU. All rights reserved.
//

#import "BSGoodsManageVC.h"

#import "MyMD5.h"
#import "BSparam.h"
#import "BSHttpTool.h"

#import "Common.h"
#import <MJRefresh/MJRefresh.h>
#import "MBProgressHUD+MJ.h"
#import "SVProgressHUD.h"

#import "BSAlwaysSendNavigationView.h"
#import "BSGoodsManageTabCell.h"
#import "GoodsManageModel.h"

#import "UIImage+BSImage.h"



@interface BSGoodsManageVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate> {
    BOOL _canRequest;
    //    这个里面放的是赚星币
    UITableView *_tableView;
    NSMutableArray *_data1Array;
    CGFloat _lastContentOffSetX;
}

@property(nonatomic,strong) BSparam *bsparam;

@property (nonatomic,strong) UIScrollView *scrollView;
//这里面放的是星币购
@property (nonatomic,strong) UITableView *tableView2;

@property (nonatomic,strong) NSMutableArray *data2Array;

@property (nonatomic,strong) BSAlwaysSendNavigationView *navigationView;


@end

@implementation BSGoodsManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    _data1Array = [[NSMutableArray alloc]init];
    self.data2Array = [[NSMutableArray alloc]init];
    _canRequest = YES;
    
    [self setNavigation];
    
    [self getDataFromNetWithType:@"1"];
    
    [self setScrollView];
    [self createTableViews];
    
    //    下拉刷新
    [self example02];
    //    上拉加载
    [self example12];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //如果修改地址之后 重新刷新数据
    
    //选择赚星币(1)
    [self selectedType:@"1"];
    _lastContentOffSetX = 0;
    [self loadNewData:(MJRefreshNormalHeader *)_tableView.mj_header];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 70)];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * 2, ScreenHeight - 64);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    self.scrollView.bounces = NO;
}
- (void)getDataFromNetWithType:(NSString *)tttt {
    if (!_canRequest) {
        return;
    }
    _canRequest = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _bsparam = [[BSparam alloc]init];
    _bsparam.name = [userDefaults objectForKey:@"loginTel"];
    _bsparam.pwdUrlMd5 = [MyMD5 md5:[userDefaults objectForKey:@"loginPwd"]];
    _bsparam.position = tttt;
    _bsparam.iStart = @"0";
    _bsparam.max = @"10";
    //    获取赚星币订单已消费情况 (freeOrderManage)
    [BSHttpTool POST:@"MakeXbGoods" parameters:_bsparam success:^(id responseObject) {
        _canRequest = YES;
        if ([responseObject[@"code"]isEqualToString:@"0"]) {
            
            if (_lastContentOffSetX == 0) {
                for (NSDictionary *dict  in responseObject[@"info"]) {
#pragma 赚星币
                    [_data1Array addObject:dict];
                }
                [_tableView reloadData];
                return ;
            }
            
#pragma 星币购
            for (NSDictionary *dict  in responseObject[@"info"]) {
                [self.data2Array addObject:dict];
            }
            [self.tableView2 reloadData];
            
        }else {
            [MBProgressHUD showError:responseObject[@"code_text"]];
        }
        
    } failure:^(NSError *error) {
        _canRequest = YES;
        [SVProgressHUD dismiss];
    }];
    
}

#pragma mark UITableView + 下拉刷新 动画图片
- (void)example02
{
    //1.
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData:)];
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置header
    _tableView.mj_header = header;
    
        //2.
        MJRefreshNormalHeader *header2 = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData:)];
        header2.lastUpdatedTimeLabel.hidden = YES;
        // 设置header
        self.tableView2.mj_header = header2;
}
#pragma mark UITableView + 上拉刷新 动画图片
- (void)example12
{
    //1.
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
    _tableView.mj_footer.automaticallyHidden = NO;
        //2.
        self.tableView2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
        self.tableView2.mj_footer.automaticallyHidden = NO;
}
#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData:(MJRefreshNormalHeader *)header
{
    if ([header isEqual:_tableView.mj_header]) {
        //    移除数据源数组
        [_data1Array removeAllObjects];
        //    从新请求数据
        [self getDataFromNetWithType:@"1"];
        //    刷新表格
        [_tableView reloadData];
        //    拿到当前的下拉刷新控件，结束刷新状态
        [_tableView.mj_header endRefreshing];
    } else {
        //    移除数据源数组
        [self.data2Array removeAllObjects];
        //    从新请求数据
        [self getDataFromNetWithType:@"2"];
        //    刷新表格
        [self.tableView2 reloadData];
        [self.tableView2.mj_header endRefreshing];
    }
    
}
#pragma mark 上拉加载更多数据
- (void)loadMoreData:(MJRefreshAutoNormalFooter *)footer
{
    //    [self getDataFromNet];
    if ([footer isEqual:_tableView.mj_footer]) {
        [_tableView reloadData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [_tableView.mj_footer endRefreshing];
    } else {
                //相关操作
                [self.tableView2 reloadData];
                [self.tableView2.mj_footer endRefreshing];
    }
    
}
//设置导航栏
- (void)setNavigation
{
    self.navigationView = [[BSAlwaysSendNavigationView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44) leftTitle:@"赚星币" rightTitle:@"星币购" mapImageStr:@"" searchImageStr:@"" andComplate:^(NSString *type) {
        //点击选择星币购 还是 赚星币
        [self selectedType:type];
    } andMap:^{
        //点击地图
        //        [self touchMap:nil];
    } andSearch:^{
        //点击搜索
        //        [self touchSearch:nil];
    }];
    [self.view addSubview:self.navigationView];
}
//设置选择星币购  还是赚星币
- (void)selectedType:(NSString *)type
{
    [self.scrollView setContentOffset:CGPointMake(([type intValue] - 1) * ScreenWidth, 0) animated:YES];
    _lastContentOffSetX = ([type intValue] - 1) * ScreenWidth;
        //选择完之后 如果数组没有数据 则重新请求数据
        if (_lastContentOffSetX == ScreenWidth && self.data2Array.count == 0) {
            [self getDataFromNetWithType:@"2"];
        }
}

//创建tableView
- (void)createTableViews {
    _tableView   = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.scrollView.frame)) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollView addSubview:_tableView];
    
    self.tableView2  = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.scrollView.frame)) style:UITableViewStyleGrouped];
    self.tableView2.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.showsHorizontalScrollIndicator = NO;
    self.tableView2.showsVerticalScrollIndicator = NO;
    self.tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollView addSubview:self.tableView2];
    
    [_tableView registerNib:[UINib nibWithNibName:@"BSGoodsManageTabCell" bundle:nil] forCellReuseIdentifier:@"BSGoodsManageTabCell"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"BSGoodsManageTabCell" bundle:nil] forCellReuseIdentifier:@"BSGoodsManageTabCell"];
//    self.tableView2.bounces = NO;
//    _tableView.bounces = NO;
}
#pragma mark - 协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:_tableView]) {
        return _data1Array.count;
    } else {
        return self.data2Array.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSGoodsManageTabCell *cells = [tableView dequeueReusableCellWithIdentifier:@"BSGoodsManageTabCell"];
    if (cells == nil) {
        cells = [[BSGoodsManageTabCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BSGoodsManageTabCell"];
    }
    if ([tableView isEqual:_tableView]) {
        cells.goodsmanagemodel = _data1Array[indexPath.section];
    }else {
        cells.goodsmanagemodel = self.data2Array[indexPath.section];
    }
    UIImageView *imageView=[[UIImageView alloc] init];
    imageView.image=[UIImage imageWithOriginalName:@"cell_backView"];
    [imageView sizeToFit];
    cells.backgroundColor=[UIColor clearColor];
    cells.backgroundView=imageView;
    cells.selectionStyle=UITableViewCellSelectionStyleNone;
    return cells;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.x == _lastContentOffSetX) {
        return;
    }
    
    _lastContentOffSetX = self.scrollView.contentOffset.x;
    [self.navigationView refreshSelectedBtn:(scrollView.contentOffset.x / ScreenWidth) + 1];
}


@end
