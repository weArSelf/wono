
//
//  AboutViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/2.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *contentLabel;

@property (nonatomic,strong)UILabel *bottomLabel;



@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    [self createContent];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"关于沃农";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_headView addSubview:_titleLabel];
    
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
        make.height.equalTo(@(SafeAreaTopRealHeight));
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left).offset(15);
        make.top.equalTo(_headView.mas_top).offset(24+SafeAreaTopHeight);
        make.width.equalTo(@(26));
        make.height.equalTo(@(26));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headView.mas_centerX);
        make.centerY.equalTo(_backBtn.mas_centerY);
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];

    
    UIButton *hubBtn = [[UIButton alloc]init];
    hubBtn.backgroundColor = [UIColor clearColor];
    [hubBtn addTarget:self action:@selector(BackClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:hubBtn];
    
    [hubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left);
        make.right.equalTo(_backBtn.mas_right).offset(HDAutoWidth(40));
        make.top.equalTo(_headView.mas_top);
        make.bottom.equalTo(_headView.mas_bottom);
    }];
}


-(void)BackClick{
    NSLog(@"点击返回");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createContent{
    
    _iconImageView = [[UIImageView alloc]init];
    _iconImageView.image = [UIImage imageNamed:@"我的-图标"];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_iconImageView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(@(HDAutoHeight(250)));
        make.width.equalTo(@(HDAutoWidth(210)));
        make.height.equalTo(@(HDAutoWidth(210)));
    }];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.textColor = UIColorFromHex(0x727171);
    _contentLabel.text = @"";
//    沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容沃农科技描述内容
    _contentLabel.numberOfLines = 0;
    
    [self.view addSubview:_contentLabel];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(HDAutoWidth(80));
        make.right.equalTo(self.view.mas_right).offset(-HDAutoWidth(80));
        make.top.equalTo(_iconImageView.mas_bottom).offset(HDAutoHeight(100));
        make.height.equalTo(@(HDAutoHeight(300)));
    }];
    
    _bottomLabel = [[UILabel alloc]init];
    _bottomLabel.font = [UIFont systemFontOfSize:11];
    _bottomLabel.textColor = UIColorFromHex(0x9fa0a0);
    _bottomLabel.text = @"Copyright © 2014-2018 沃农科技有限公司";
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_bottomLabel];
    
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(HDAutoHeight(40)));
        make.width.equalTo(@(HDAutoWidth(700)));
        make.bottom.equalTo(self.view.mas_bottom).offset(-64-HDAutoHeight(15));
    }];
}




@end
