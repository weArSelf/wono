//
//  CallBackViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/2.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "CallBackViewController.h"
#import "UITextView+Placeholder.h"

@interface CallBackViewController ()


@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIButton *nextBtn;

@property (nonatomic,strong)UITextView *contentTextView;


@end

@implementation CallBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatTitleAndBackBtn];
    [self createNextBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatContent];
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
    _titleLabel.text = @"意见反馈";
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
    [_nextBtn setTitle:@"提交" forState:UIControlStateNormal];
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

-(void)creatContent{
    _contentTextView = [[UITextView alloc]init];
    _contentTextView.placeholder = @"请尽可能详细的描述您所遇到的问题，以便于我们更好的为您服务";
    _contentTextView.layer.shadowColor = [UIColor grayColor].CGColor;
    _contentTextView.layer.shadowOpacity = 0.3f;
    _contentTextView.layer.shadowRadius =5;
    _contentTextView.layer.shadowOffset = CGSizeMake(5,5);
    _contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _contentTextView.layer.borderWidth = 0.3;
    //    _ConView.layer.masksToBounds = YES;
    _contentTextView.layer.cornerRadius = 5;
    _contentTextView.layer.masksToBounds = NO;

    [self.view addSubview:_contentTextView];
    
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(HDAutoWidth(30)));
        make.right.equalTo(self.view.mas_right).offset(-HDAutoWidth(30));
        make.top.equalTo(self.view.mas_top).offset(64+HDAutoHeight(22));
        make.height.equalTo(@(HDAutoHeight(672)));
    }];
    
}


@end
