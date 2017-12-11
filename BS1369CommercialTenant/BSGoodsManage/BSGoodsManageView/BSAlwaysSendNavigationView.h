//
//  BSAlwaysSendNavigationView.h
//  BS1369
//
//  Created by bsmac1 on 16/1/27.
//  Copyright © 2016年 bsw1369. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^completionAlwaysSelectedType) (NSString *type);
typedef void(^completionAlwaysSelectedMap) ();
typedef void(^completionAlwaysSelectedSearch) ();

@interface BSAlwaysSendNavigationView : UIView

@property (nonatomic,strong) completionAlwaysSelectedType typeblock;
@property (nonatomic,strong) completionAlwaysSelectedMap mapblock;
@property (nonatomic,strong) completionAlwaysSelectedSearch searchblock;



-(instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle mapImageStr:(NSString *)mapImageStr searchImageStr:(NSString *)searchImageStr andComplate:(completionAlwaysSelectedType)selectedType andMap:(completionAlwaysSelectedMap)selectedMap andSearch:(completionAlwaysSelectedSearch)selectedSearch;


-(void)refreshSelectedBtn:(int)page;
@end
