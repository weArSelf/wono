//
//  RegeistViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/19.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "RegeistViewController.h"
#import "HDTimerBtn.h"
#import "AgreementViewController.h"
#import "ZhengZeSupport.h"
#import "CompleteInfoViewController.h"

@interface RegeistViewController ()<UITextFieldDelegate>


@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;


@property (nonatomic, strong) UITextField *textfPhoneNum;
@property (nonatomic, strong) UITextField *textfPassWord;
@property (nonatomic,strong) UITextField *verificationCodeTextF;
@property (nonatomic, strong) UIImageView *phoneNumimaVLine;
@property (nonatomic, strong) UIImageView *imaVLinePassWord;
@property (nonatomic,strong) UIImageView *imaVLineverificationCode;
@property (nonatomic, strong) UIButton *btnLogin;

@property (nonatomic, strong) UIButton *termsButton;
@property (nonatomic, strong) UITextField *textVerificationPassWord;
@property (nonatomic, strong) UIImageView *imaVerificationVLinePassWord;

@property (nonatomic, strong) UIImageView *phoneImage;
@property (nonatomic, strong) UIImageView *vcodeImage;
@property (nonatomic, strong) UIImageView *passwImage;
@property (nonatomic, strong) UIImageView *dpassImage;

@property (strong, nonatomic) UIWindow *actionWindow;

@property (strong, nonatomic) HDTimerBtn * timerBtn;

@end

@implementation RegeistViewController{
    NSString *phoneNum;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    phoneNum = @"";
    
    [self creatTitleAndBackBtn];
    [self createUI];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    UILabel* label = [[UILabel alloc] init];
    label.text = @"注册表示通过《沃农科技协议》";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:12.0];
    label.frame = CGRectMake(0, APP_CONTENT_HEIGHT-80, APP_CONTENT_WIDTH, 30);
    [self.view addSubview:label];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AgreementClick)];
    [label addGestureRecognizer:tap];
    label.userInteractionEnabled = YES;
    
    
}

-(void)AgreementClick{
    NSLog(@"点击协议");
    AgreementViewController *ag = [[AgreementViewController alloc]init];
    [self.navigationController pushViewController:ag animated:YES];
}


-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"注册";
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




- (void)createUI
{
    
    
    
    //账号
    _textfPhoneNum = [[UITextField alloc] initWithFrame:CGRectMake(45+30, 64+80, APP_CONTENT_WIDTH-90-30, 30)];
    _textfPhoneNum.backgroundColor = [UIColor clearColor];
    _textfPhoneNum.contentMode = UIViewContentModeCenter;
    _textfPhoneNum.returnKeyType = UIReturnKeyDone;
    _textfPhoneNum.keyboardType = UIKeyboardTypeNumberPad;
    _textfPhoneNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textfPhoneNum.delegate = self;
    _textfPhoneNum.placeholder = @"手机号";
    _textfPhoneNum.font = [UIFont systemFontOfSize:14];
    [_textfPhoneNum addTarget:self
                       action:@selector(textFieldEditChanged:)
             forControlEvents:UIControlEventEditingChanged];
    _textfPhoneNum.secureTextEntry = NO;
    [self.view addSubview:_textfPhoneNum];
    
    _phoneImage = [[UIImageView alloc] initWithFrame:CGRectMake(45+2, 64+80+5, 20, 20)];
    _phoneImage.image = [UIImage imageNamed:@"0-手机号"];
    [self.view addSubview:_phoneImage];
    
    _phoneNumimaVLine = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ic_login_line"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]
                                          highlightedImage:[[UIImage imageNamed:@"ic_logoin_green"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]];
    _phoneNumimaVLine.frame = CGRectMake(_textfPhoneNum.frame.origin.x-30,
                                         _textfPhoneNum.frame.origin.y+_textfPhoneNum.frame.size.height,
                                         _textfPhoneNum.frame.size.width+30,
                                         3);
    [self.view addSubview:_phoneNumimaVLine];
    
    //验证码
    _verificationCodeTextF = [[UITextField alloc] initWithFrame:CGRectMake(45+30, CGRectGetMaxY(_phoneNumimaVLine.frame) +20, APP_CONTENT_WIDTH - 284/2 - 60  -15-(HDAutoWidth(260) - 80), 30)];
    
    _verificationCodeTextF.backgroundColor = [UIColor clearColor];
    _verificationCodeTextF.contentMode = UIViewContentModeCenter;
    _verificationCodeTextF.returnKeyType = UIReturnKeyDone;
    _verificationCodeTextF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _verificationCodeTextF.delegate = self;
    _verificationCodeTextF.secureTextEntry = NO;
    _verificationCodeTextF.placeholder = @"验证码";
    _verificationCodeTextF.font = [UIFont systemFontOfSize:14];
    _verificationCodeTextF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_verificationCodeTextF];
    [_verificationCodeTextF addTarget:self
                               action:@selector(textFieldEditChanged:)
                     forControlEvents:UIControlEventEditingChanged];
    
    _vcodeImage = [[UIImageView alloc] initWithFrame:CGRectMake(45+2, CGRectGetMaxY(_phoneNumimaVLine.frame) +20+5, 20, 20)];
    _vcodeImage.image = [UIImage imageNamed:@"0-验证码"];
    [self.view addSubview:_vcodeImage];
    
    
    _imaVLineverificationCode = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ic_login_line.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]
                                                  highlightedImage:[[UIImage imageNamed:@"ic_logoin_green"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]];
    _imaVLineverificationCode.frame = CGRectMake(_verificationCodeTextF.frame.origin.x-30,
                                                 _verificationCodeTextF.frame.origin.y+_verificationCodeTextF.frame.size.height,
                                                 _phoneNumimaVLine.frame.size.width,
                                                 3);
    [self.view addSubview:_imaVLineverificationCode];
    
    //获取验证码时间
    self.timerBtn = [[HDTimerBtn alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_verificationCodeTextF.frame) + 5 + 10,CGRectGetMinY( _verificationCodeTextF.frame),HDAutoWidth(300), 30)];
    [self.timerBtn addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.timerBtn];
    
    //密码
    _textfPassWord = [[UITextField alloc] initWithFrame:CGRectMake(45+30,
                                                                   _verificationCodeTextF.frame.size.height+_verificationCodeTextF.frame.origin.y+20,
                                                                   APP_CONTENT_WIDTH-90-30,
                                                                   30)];
    
    _textfPassWord.backgroundColor = [UIColor clearColor];
    _textfPassWord.contentMode = UIViewContentModeCenter;
    _textfPassWord.returnKeyType = UIReturnKeyDone;
    _textfPassWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textfPassWord.delegate = self;
    _textfPassWord.keyboardType = UIKeyboardTypeASCIICapable;
    _textfPassWord.secureTextEntry = YES;
    _textfPassWord.placeholder = @"密码";
    _textfPassWord.font = [UIFont systemFontOfSize:14];
    [_textfPassWord addTarget:self
                       action:@selector(textFieldEditChanged:)
             forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_textfPassWord];
    
    _passwImage = [[UIImageView alloc] initWithFrame:CGRectMake(45+2, _verificationCodeTextF.frame.size.height+_verificationCodeTextF.frame.origin.y+20+5, 20, 20)];
    _passwImage.image = [UIImage imageNamed:@"0-密码"];
    [self.view addSubview:_passwImage];
    
    _imaVLinePassWord = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ic_login_line.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]
                                          highlightedImage:[[UIImage imageNamed:@"ic_logoin_green"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]];
    _imaVLinePassWord.frame = CGRectMake(_textfPassWord.frame.origin.x-30,
                                         _textfPassWord.frame.origin.y+_textfPassWord.frame.size.height,
                                         _textfPassWord.frame.size.width+30,
                                         3);
    [self.view addSubview:_imaVLinePassWord];
    
    //确认密码
    _textVerificationPassWord = [[UITextField alloc] initWithFrame:CGRectMake(45+30,
                                                                              _textfPassWord.frame.size.height+_textfPassWord.frame.origin.y+20,
                                                                              APP_CONTENT_WIDTH-90-30,
                                                                              30)];
    
    _textVerificationPassWord.backgroundColor = [UIColor clearColor];
    _textVerificationPassWord.contentMode = UIViewContentModeCenter;
    _textVerificationPassWord.returnKeyType = UIReturnKeyDone;
    _textVerificationPassWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textVerificationPassWord.delegate = self;
    _textVerificationPassWord.keyboardType = UIKeyboardTypeASCIICapable;
    _textVerificationPassWord.secureTextEntry = YES;
    _textVerificationPassWord.font = [UIFont systemFontOfSize:14];
    _textVerificationPassWord.placeholder = @"确认密码";
    [_textVerificationPassWord addTarget:self
                                  action:@selector(textFieldEditChanged:)
                        forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_textVerificationPassWord];
    
    _dpassImage = [[UIImageView alloc] initWithFrame:CGRectMake(45+2, _textfPassWord.frame.size.height+_textfPassWord.frame.origin.y+20+5, 20, 20)];
    _dpassImage.image = [UIImage imageNamed:@"0-确认密码"];
    [self.view addSubview:_dpassImage];
    
    _imaVerificationVLinePassWord = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ic_login_line.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]
                                                      highlightedImage:[[UIImage imageNamed:@"ic_logoin_green"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]];
    _imaVerificationVLinePassWord.frame = CGRectMake(_textVerificationPassWord.frame.origin.x-30,
                                                     _textVerificationPassWord.frame.origin.y+_textVerificationPassWord.frame.size.height,
                                                     _textVerificationPassWord.frame.size.width+30,
                                                     3);
    [self.view addSubview:_imaVerificationVLinePassWord];
    
    //注册完毕
    _btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(APP_CONTENT_WIDTH/5,
                                                           CGRectGetMaxY(_imaVerificationVLinePassWord.frame)+50,
                                                           APP_CONTENT_WIDTH*3/5,
                                                           38)];
    [_btnLogin addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnLogin.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    _btnLogin.backgroundColor = [UIColor lightGrayColor];
    _btnLogin.layer.cornerRadius = 18;
    [_btnLogin setTitle:@"完成" forState:UIControlStateNormal];
    _btnLogin.backgroundColor = UIColorFromHex(0x3aa566);
    _btnLogin.layer.shadowColor = UIColorFromHex(0x3fb36f).CGColor;
    _btnLogin.layer.shadowOpacity = 0.3f;
    _btnLogin.layer.shadowRadius =18;
    _btnLogin.layer.shadowOffset = CGSizeMake(5,5);
    
    [self.view addSubview:_btnLogin];
    //    _btnLogin.enabled = NO;
    //    _btnLogin.alpha = 0.2;
    
    //    //注册协议
    //    _termsButton = [[UIButton alloc] init];
    //    [_termsButton setTitleColor:UIColorFromRGB(130, 130, 130) forState:UIControlStateNormal];
    //    _termsButton.titleLabel.font = [UIFont systemFontOfSize:12];
    //    [_termsButton addTarget:self action:@selector(termsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:_termsButton];
    //
    //    NSString *btnTitle = @"已阅读并通过《注册协议》";
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:btnTitle];
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [btnTitle length])];
    //    [attributedString addAttribute:(NSString *)NSForegroundColorAttributeName
    //                             value:[UIColor lightGrayColor]
    //                             range:NSMakeRange(6, 6)];
    //    [_termsButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    //
    //    WS(ws);
    //    [_termsButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(ws.view).offset(-49);
    //        make.centerX.equalTo(ws.view.mas_centerX);
    //        make.width.equalTo(@(300));
    //    }];
}


#pragma mark - textfield delegate
- (void)textFieldEditChanged:(UITextField *)textField{
    
    NSLog(@"输入改变");
    if(textField == _textfPhoneNum){
        
        NSString *str = textField.text;
        
        if(str.length>11){
            _textfPhoneNum.text = phoneNum;
            
            [MBProgressHUD showSuccess:@"手机号应为11位"];
        }else{
            phoneNum = str;
        }
        
    }
    
    
}

//获取验证码
-(void)getVerificationCode:(HDTimerBtn *)btn{
    
    NSLog(@"获取验证码");
        //判断手机号是不是11位
    BOOL phoneB = [ZhengZeSupport isMobileNumber:_textfPhoneNum.text];
    if (phoneB == false) {
        //[self showHUDInView:self.view justWithText:phoneNumCountIllegal disMissAfterDelay:2.0];
        [MBProgressHUD showSuccess:@"请输入正确的手机号"];
        return;
    }
    [btn addTimer];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(getSMS) object:btn];
    [self performSelector:@selector(getSMS) withObject:btn afterDelay:0.2f];
}

-(void)getSMS{
    [[InterfaceSingleton shareInstance].interfaceModel getMsgWithPhoneNumber:_textfPhoneNum.text WithCallBack:^(int state, id data, NSString *msg) {
        
        if(state == 2000){
            NSLog(@"获取成功");
            [MBProgressHUD showSuccess:@"验证码发送成功"];
        }else{
            [MBProgressHUD showSuccess:msg];
        }
        NSLog(@"111");
    }];
}

- (void)registerBtnClick:(id)sender{
    NSLog(@"点击完成");
    
    BOOL mark = [ZhengZeSupport isMobileNumber:_textfPhoneNum.text];
    
    if(mark == false){
        [MBProgressHUD showSuccess:@"手机号不符合规则"];
        return;
    }
    
    if(_textfPassWord.text.length<6){
        [MBProgressHUD showSuccess:@"密码长度小于6位"];
        return;
    }
    
    if(![_textfPassWord.text isEqualToString:_textVerificationPassWord.text]){
        [MBProgressHUD showSuccess:@"两次密码输入不一致"];
        return;
    }
    
    if([_verificationCodeTextF.text isEqualToString: @""]){
        [MBProgressHUD showSuccess:@"验证码不能为空"];
        return;
    }
    
    
    
    [[InterfaceSingleton shareInstance].interfaceModel userRegisWithUserMobile:_textfPhoneNum.text AndPsw:_textfPassWord.text AndMessageReceive:_verificationCodeTextF.text WithCallBack:^(int state, id data, NSString *msg) {
        
        
        
        if(state == 2000){
            NSLog(@"成功");
            [MBProgressHUD showSuccess:@"注册成功"];
            
            NSDictionary *dic = (NSDictionary *)data;
            
            NSString *token = dic[@"token"];
            
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
            
            CompleteInfoViewController *com = [[CompleteInfoViewController alloc]init];
            
            [self.navigationController pushViewController:com animated:YES];
            
//            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showSuccess:msg];
        }
        
        NSLog(@"111");
        
    }];
    
    
    
}

//注册协议
- (void)termsButtonClick:(id)sender
{
    NSLog(@"注册协议");
    
    
}

-(void)BackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textfPassWord resignFirstResponder];
    [_textfPhoneNum resignFirstResponder];
    [_verificationCodeTextF resignFirstResponder];
    [_textVerificationPassWord resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder];//关闭键盘
    return YES;
}


@end
