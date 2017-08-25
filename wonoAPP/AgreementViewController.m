//
//  AgreementViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/13.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UILabel *agreeLabel;
@property (nonatomic,strong)UITextView *contentScroll;



@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    [self createContent];
    
}

-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"沃农科技";
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
        make.height.equalTo(@(64));
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left).offset(15);
        make.top.equalTo(_headView.mas_top).offset(24);
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
    _agreeLabel = [[UILabel alloc]init];
    _agreeLabel.text = @"注册协议";
    _agreeLabel.textColor = [UIColor grayColor];
    _agreeLabel.font = [UIFont systemFontOfSize:16];
    _agreeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_agreeLabel];
    
    _contentScroll = [[UITextView alloc]init];
    _contentScroll.textColor = [UIColor lightGrayColor];
    _contentScroll.font = [UIFont systemFontOfSize:14];
    _contentScroll.text = @"啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文啊啊啊啊啊我我我问问企鹅全文";
    [self.view addSubview:_contentScroll];
    
    [_agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(40));
        make.width.equalTo(@(100));
    }];
    [_contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_agreeLabel.mas_bottom).offset(2);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(self.view.bounds.size.width-60));
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
    }];
    
    UILabel *bottomLabel = [[UILabel alloc]init];
    bottomLabel.text = @"Copyright © 2014-2018 沃农科技有限公司";
    bottomLabel.font = [UIFont systemFontOfSize:12];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:bottomLabel];
    
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_contentScroll.mas_bottom).offset(20);
        make.width.equalTo(@(300));
        make.height.equalTo(@(40));
    }];
}

@end
