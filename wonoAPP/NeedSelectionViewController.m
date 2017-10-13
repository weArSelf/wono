//
//  NeedSelectionViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/7.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "NeedSelectionViewController.h"

@interface NeedSelectionViewController ()

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UITextField *mainTextField;
@property (nonatomic,strong)UIButton *confirmBtn;

@property (nonatomic,strong)UIButton *nextBtn;

@end

@implementation NeedSelectionViewController{
    FarmStyle MyStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    _titleLabel.text = @"员工总数";
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



-(void)createNextBtn{
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"确认修改" forState:UIControlStateNormal];
//    [_nextBtn setTitle:@"取消编辑" forState:UIControlStateSelected];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_nextBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_nextBtn];
    //    _saveBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.right.equalTo(_headView.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(26)));
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
    
    UIButton *hubBtn = [[UIButton alloc]init];
    hubBtn.backgroundColor = [UIColor clearColor];
    [hubBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:hubBtn];
    
    [hubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.right.equalTo(_headView.mas_right);
        make.height.equalTo(_headView.mas_height);
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
    
}


-(void)createMain{

    _mainTextField = [[UITextField alloc]init];
    _mainTextField.placeholder = @"请输入员工总数（个）";
    _mainTextField.font = [UIFont systemFontOfSize:13];
    _mainTextField.textColor = UIColorFromHex(0x727171);
    _mainTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mainTextField.layer.masksToBounds = YES;
    _mainTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _mainTextField.layer.borderWidth = 0.4;
    _mainTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    _mainTextField.leftViewMode = UITextFieldViewModeAlways;
    _mainTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_mainTextField];
    [_mainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(-1);
        make.right.equalTo(self.view.mas_right).offset(1);
        make.top.equalTo(_headView.mas_bottom).offset(HDAutoHeight(30));
        make.height.equalTo(@(HDAutoHeight(70)));
    }];
    
}

-(void)createConfirmBtn{
    _confirmBtn = [[UIButton alloc]init];
    [_confirmBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn setBackgroundColor:UIColorFromHex(0x3eb36e)];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_confirmBtn];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@(HDAutoHeight(98)));
    }];
}

-(void)confirmClick{
    NSLog(@"点击修改");
    if([_mainTextField.text isEqualToString:@""]){
        [MBProgressHUD showSuccess:@"输入不能为空"];
    }else{
        if([self.delegate respondsToSelector:@selector(clickConfirmWithType:AndStr:)]){
            [self.delegate clickConfirmWithType:MyStyle AndStr:_mainTextField.text];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)changeStyle:(FarmStyle)style{
    [self creatTitleAndBackBtn];
//    [self createConfirmBtn];
    [self createMain];
    [self createNextBtn];
    MyStyle = style;
    
    if(style == yuangongStyle){
        _titleLabel.text = @"员工总数";
        _mainTextField.placeholder = @"输入员工总数（个）";
    }else if(style == dapengStyle){
        _titleLabel.text = @"大棚总数";
        _mainTextField.placeholder = @"请输入大棚总数（座）";
    }else if(style == zhandiStyle){
        _titleLabel.text = @"占地面积";
        _mainTextField.placeholder = @"请输入占地面积（亩）";
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_mainTextField resignFirstResponder];
}

@end
