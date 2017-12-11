//
//  BSAlwaysSendNavigationView.m
//  BS1369
//
//  Created by bsmac1 on 16/1/27.
//  Copyright © 2016年 bsw1369. All rights reserved.
//

#import "BSAlwaysSendNavigationView.h"
#import "Masonry.h"
#import "Common.h"
@interface BSAlwaysSendNavigationView()
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic,strong) UIButton *underRedBtn;
@end

@implementation BSAlwaysSendNavigationView

-(instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle mapImageStr:(NSString *)mapImageStr searchImageStr:(NSString *)searchImageStr andComplate:(completionAlwaysSelectedType)selectedType andMap:(completionAlwaysSelectedMap)selectedMap andSearch:(completionAlwaysSelectedSearch)selectedSearch
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = REDCOLOR;
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.leftBtn.tag = 2016012701;
        [self.leftBtn addTarget:self action:@selector(selectedType:) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.rightBtn.tag = 2016012702;
        [self.rightBtn addTarget:self action:@selector(selectedType:) forControlEvents:UIControlEventTouchUpInside];

        self.underRedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.underRedBtn.layer.cornerRadius = 0.2;
        self.underRedBtn.clipsToBounds = YES;
        self.underRedBtn.backgroundColor = [UIColor whiteColor];
        
        
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [self addSubview:self.underRedBtn];
        
        
        self.typeblock = selectedType;
        self.mapblock = selectedMap;
        self.searchblock = selectedSearch;
    }
    return self;
}
-(void)selectedType:(UIButton *)sender
{
    [self refreshSelectedBtn:(int)(sender.tag - 2016012700)];
}
-(void)selectedMap
{
    //点击地图
    self.mapblock();
}
-(void)selectedSearch
{
    //点击搜索
    self.searchblock();
}
-(void)refreshSelectedBtn:(int)page
{
    for (UIButton *btn in self.subviews) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (btn.tag == 2016012700 + page) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.1 animations:^{
                CGPoint centerPoint = _underRedBtn.center;
                centerPoint.x = btn.center.x;
                _underRedBtn.center = centerPoint;
            }];
        }
    }
    self.typeblock([NSString stringWithFormat:@"%d",page]);
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.leading.equalTo(self.mas_leading).with.offset(10);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.centerY.equalTo(self.leftBtn);
        make.leading.equalTo(self.leftBtn.mas_trailing).with.offset(20);
    }];
    
    [self.underRedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(47, 1));
        make.top.equalTo(self.leftBtn.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.leftBtn);
    }];
    
    [super layoutSubviews];
}
@end
