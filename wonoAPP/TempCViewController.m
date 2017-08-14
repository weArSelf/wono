//
//  TempCViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/31.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "TempCViewController.h"
#import "MyZView.h"
#import "PlantModel.h"
#import "CustomLabel.h"

@interface TempCViewController ()

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIImageView *backgroundImageView;

@property (nonatomic,strong)UIButton *rightBtn;

@property (nonatomic,strong)CustomLabel *appearLabel;

@end

@implementation TempCViewController{
    NSMutableArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    [self createRight];
    [self createBackGround];
    [self createZXview];
    [self createZXview2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)createRight{
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_rightBtn setImage:[UIImage imageNamed:@"问号"] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_headView addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_headView.mas_right).offset(-15);
        make.top.equalTo(_headView.mas_top).offset(24);
        make.width.equalTo(@(26));
        make.height.equalTo(@(26));
    }];
}

-(void)rightClick{
    NSLog(@"点击问号");
    if(_appearLabel == nil){
        _appearLabel = [[CustomLabel alloc]init];
        _appearLabel.numberOfLines = 0;
        _appearLabel.backgroundColor = [UIColor whiteColor];
        _appearLabel.textColor = UIColorFromHex(0x4db366);
//        _appearLabel.font = [UIFont systemFontOfSize:13];
        [self setLabelSpace:_appearLabel withValue: @"最近记录的为近十次的记录 （每隔15分钟记录一次），每天凌晨12点刷新昨日全部数据，曲线中记录的是每日气温（气温、地温、地湿）的平均值" withFont:[UIFont systemFontOfSize:13]];
//        _appearLabel.text = @"新一次，每天凌晨12点刷新昨日全部数据，曲线图中记录的每日额平均值";
        _appearLabel.layer.masksToBounds = YES;
        _appearLabel.layer.cornerRadius = 5;

        _appearLabel.textInsets = UIEdgeInsetsMake(HDAutoHeight(20),HDAutoWidth(30), HDAutoHeight(20), HDAutoWidth(30));
    }
    
    CGFloat height = [self getSpaceLabelHeight:@"最近记录的为近十次的记录 （每隔15分钟记录一次），每天凌晨12点刷新昨日全部数据，曲线中记录的是每日气温（气温、地温、地湿）的平均值" withFont:[UIFont systemFontOfSize:13] withWidth:HDAutoWidth(365)];
    height +=HDAutoHeight(50);
    _appearLabel.alpha = 0.1;
    [self.view addSubview:_appearLabel];
    
    [_appearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(HDAutoWidth(425)));
        make.top.equalTo(_headView.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(-HDAutoWidth(14));
        make.height.equalTo(@(height));
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        _appearLabel.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC);
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1 animations:^{
                _appearLabel.alpha = 0;
            }];

        });
    }];
    
}

-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = HDAutoHeight(13);
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, [ [ UIScreen mainScreen ] bounds ].size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = HDAutoHeight(13); //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}


-(void)creatTitleAndBackBtn{
    
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    
    NSArray *array = [NSArray arrayWithObjects:@"最近",@"近七天",@"近一个月", nil];
    //初始化UISegmentedControl
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
//    segment.backgroundColor = [UIColor whiteColor];
    segment.tintColor = UIColorFromHex(0xefefef);
    
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor grayColor]} forState:UIControlStateSelected];
    //设置选中的选项卡
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(segmentControlDidChangedValue:) forControlEvents:UIControlEventValueChanged];
    //设置frame
//    segment.frame = CGRectMake(10, 100, self.view.frame.size.width-20, 30);
    //添加到视图
    [_headView addSubview:segment];

    
//    _titleLabel = [[UILabel alloc]init];
//    _titleLabel.text = @"";
//    _titleLabel.textColor = [UIColor whiteColor];
//    _titleLabel.font = [UIFont systemFontOfSize:18];
//    _titleLabel.textAlignment = NSTextAlignmentCenter;
//    [_headView addSubview:_titleLabel];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"0-返回"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(BackClick) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    //    _backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [_headView addSubview:_backBtn];
    
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(64));
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left).offset(15);
        make.top.equalTo(_headView.mas_top).offset(24);
        make.width.equalTo(@(26));
        make.height.equalTo(@(26));
    }];
    
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headView.mas_centerX);
        make.centerY.equalTo(_backBtn.mas_centerY);
        make.width.equalTo(@(HDAutoWidth(510)));
        make.height.equalTo(@(HDAutoHeight(60)));
    }];
}

- (void)segmentControlDidChangedValue:(UISegmentedControl *)sender
{
    //这里实现点击事件的方法
    
    NSLog(@"测试");
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"1");
    }else if (sender.selectedSegmentIndex == 1){
        NSLog(@"2");
//        [self createZXview3];
        //记得remove对应tag的view再重新添加
        
    }else if (sender.selectedSegmentIndex == 2){
        NSLog(@"3");
    }
    
  
}

-(void)BackClick{
    NSLog(@"点击返回");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createZXview{
    MyZView *Zview = [[MyZView alloc]initWithFrame:CGRectMake(0, 64,APP_CONTENT_WIDTH,HDAutoHeight(550))];
    
    Zview.tag = 201;
    
    PointModel *model = [[PointModel alloc]init];
    model.Height = 34;
    
    model.firstBottomStr = @"描述";
    
    model.Height2 = 20;
    
    model.nextBottomStr = @"描述";
    
    model.lineName = @"时间";
    
    PointModel *model2 = [[PointModel alloc]init];
    model2.Height = 30;
    
    model2.Height2 = 20;
    
    model2.firstBottomStr = @"唉唉";
    
    model2.nextBottomStr = @"问问";
    
    model2.lineName = @"时间";

    
    dataArr = [NSMutableArray array];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    
    Zview.dataArr = dataArr;
    
    [self.view addSubview:Zview];
    
}

-(void)createZXview2{
    
    
    PointModel *model = [[PointModel alloc]init];
    
    
    model.Height = 34;
    
    model.firstBottomStr = @"描述";
    
    model.Height2 = 20;
    
    model.nextBottomStr = @"描述";
    
    model.lineName = @"时间";
    
    PointModel *model2 = [[PointModel alloc]init];
    model2.Height = 30;
    
    model2.Height2 = 20;
    
    model2.firstBottomStr = @"唉唉";
    
    model2.nextBottomStr = @"问问";
    
    model2.lineName = @"时间";
    
    
    dataArr = [NSMutableArray array];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    
    
    MyZView *Zview = [[MyZView alloc]initWithFrame:CGRectMake(0, 64 +HDAutoHeight(550), APP_CONTENT_WIDTH, HDAutoHeight(550)) AndData:dataArr];
    
    
    Zview.tag = 202;
    
    [self.view addSubview:Zview];
    
}

-(void)createBackGround{
    _backgroundImageView = [[UIImageView alloc]init];
    _backgroundImageView.image = [UIImage imageNamed:@"天气背景"];
    _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    
    [self.view addSubview:_backgroundImageView];
    
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}






@end
