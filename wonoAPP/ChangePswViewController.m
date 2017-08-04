//
//  ChangePswViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/2.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "ChangePswViewController.h"

@interface ChangePswViewController ()

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIButton *nextBtn;

@property (nonatomic,strong)UITextField *orginPsw;
@property (nonatomic,strong)UITextField *nextPsw;
@property (nonatomic,strong)UITextField *confirmPsw;




@end

@implementation ChangePswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    [self createNextBtn];
    [self cgreateContent];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"修改密码";
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
}


-(void)BackClick{
    NSLog(@"点击返回");
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)createNextBtn{
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_nextBtn addTarget:self action:@selector(SaveClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_nextBtn];
    //    _saveBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.right.equalTo(_headView.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(26)));
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
}

-(void)SaveClick{
    NSLog(@"点击确认修改");
    
    
}


-(void)cgreateContent{
    
    UIImageView *orginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"0-密码"]];
    orginImageView.contentMode = UIViewContentModeScaleAspectFit;
    _orginPsw = [[UITextField alloc]init];
    _orginPsw.font = [UIFont systemFontOfSize:14];
    _orginPsw.placeholder = @"原密码";
    _orginPsw.textColor = UIColorFromHex(0x9fa0a0);
    UIView *orginView = [[UIView alloc]init];
    orginView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:orginImageView];
    [self.view addSubview:_orginPsw];
    [self.view addSubview:orginView];
    
    [orginImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64+HDAutoHeight(240));
        make.left.equalTo(self.view.mas_left).offset(HDAutoWidth(85));
        make.width.equalTo(@(HDAutoWidth(40)));
        make.height.equalTo(@(HDAutoWidth(40)));
    }];
    [_orginPsw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orginImageView.mas_right).offset(HDAutoWidth(20));
        make.centerY.equalTo(orginImageView.mas_centerY);
        make.height.equalTo(@(HDAutoHeight(50)));
        make.width.equalTo(@(HDAutoWidth(500)));
    }];
    [orginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orginPsw.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(HDAutoWidth(614)));
        make.height.equalTo(@(1));
    }];
    
    
    
    
    UIImageView *orginImageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"0-密码"]];
    orginImageView2.contentMode = UIViewContentModeScaleAspectFit;
    _nextPsw = [[UITextField alloc]init];
    _nextPsw.font = [UIFont systemFontOfSize:14];
    _nextPsw.placeholder = @"新密码";
    _nextPsw.textColor = UIColorFromHex(0x9fa0a0);
    UIView *orginView2 = [[UIView alloc]init];
    orginView2.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:orginImageView2];
    [self.view addSubview:_nextPsw];
    [self.view addSubview:orginView2];
    
    [orginImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orginView.mas_bottom).offset(HDAutoHeight(55));
        make.left.equalTo(self.view.mas_left).offset(HDAutoWidth(85));
        make.width.equalTo(@(HDAutoWidth(40)));
        make.height.equalTo(@(HDAutoWidth(40)));
    }];
    [_nextPsw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orginImageView2.mas_right).offset(HDAutoWidth(20));
        make.centerY.equalTo(orginImageView2.mas_centerY);
        make.height.equalTo(@(HDAutoHeight(50)));
        make.width.equalTo(@(HDAutoWidth(500)));
    }];
    [orginView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nextPsw.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(HDAutoWidth(614)));
        make.height.equalTo(@(1));
    }];

    
    
    UIImageView *orginImageView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"0-确认密码"]];
    orginImageView3.contentMode = UIViewContentModeScaleAspectFit;
    _confirmPsw = [[UITextField alloc]init];
    _confirmPsw.font = [UIFont systemFontOfSize:14];
    _confirmPsw.placeholder = @"新密码";
    _confirmPsw.textColor = UIColorFromHex(0x9fa0a0);
    UIView *orginView3 = [[UIView alloc]init];
    orginView3.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:orginImageView3];
    [self.view addSubview:_confirmPsw];
    [self.view addSubview:orginView3];
    
    [orginImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orginView2.mas_bottom).offset(HDAutoHeight(55));
        make.left.equalTo(self.view.mas_left).offset(HDAutoWidth(85));
        make.width.equalTo(@(HDAutoWidth(40)));
        make.height.equalTo(@(HDAutoWidth(40)));
    }];
    [_confirmPsw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orginImageView3.mas_right).offset(HDAutoWidth(20));
        make.centerY.equalTo(orginImageView3.mas_centerY);
        make.height.equalTo(@(HDAutoHeight(50)));
        make.width.equalTo(@(HDAutoWidth(500)));
    }];
    [orginView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_confirmPsw.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(HDAutoWidth(614)));
        make.height.equalTo(@(1));
    }];
    
    
    
}


@end
