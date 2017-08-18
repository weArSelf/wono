//
//  LoginViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/11.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "LoginViewController.h"
#import "CompleteInfoViewController.h"
#import "AgreementViewController.h"
#import "ForgetViewController.h"
#import "RegeistViewController.h"
#import "ZhengZeSupport.h"
#import "BaseTabBarController.h"

@interface LoginViewController ()<UITextFieldDelegate>


@property (nonatomic,strong) UIImageView *titleImageView;
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UITextField *pswTextField;
@property (nonatomic,strong) UIImageView *phoneImageView;
@property (nonatomic,strong) UIImageView *pswImageView;

@property (nonatomic,strong) UIImageView *phoneLine;
@property (nonatomic,strong) UIImageView *pswLine;

@property (nonatomic,strong) UIButton *btnLogin;
@property (nonatomic,strong) UIButton *regBtn;
@property (nonatomic,strong) UIButton *forgetBtn;

@property (nonatomic,strong) UIButton *infoBtn;

@end

@implementation LoginViewController{
    NSString *phoneNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    phoneNum = @"";
    [self createTitleImage];
    // Do any additional setup after loading the view.
    [self createTextFieldUI];
    
    
}

-(void)createTitleImage{
    _titleImageView = [[UIImageView alloc]init];
    _titleImageView.image = [UIImage imageNamed:@"登录图标"];
    _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_titleImageView];
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(84);
        make.width.equalTo(@(100));
        make.height.equalTo(@(100));
    }];
}


-(void)createTextFieldUI{
    self.phoneImageView.frame = CGRectMake(45+2, 64+180+5, 20, 25);
    self.phoneTextField.frame = CGRectMake(45+30, 64+185, APP_CONTENT_WIDTH-90-30, 30);
    _phoneLine = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ic_login_line.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]
                                      highlightedImage:[[UIImage imageNamed:@"ic_logoin_green"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]];
    _phoneLine.frame = CGRectMake(self.phoneTextField.frame.origin.x-30,
                                     self.phoneTextField.frame.origin.y+self.phoneTextField.frame.size.height,
                                     self.phoneTextField.frame.size.width+30,
                                     3);
    
    [self.view addSubview:self.phoneImageView];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:_phoneLine];
    
    
    self.pswTextField.frame = CGRectMake(45+30,5+self.phoneTextField.frame.size.height+self.phoneTextField.frame.origin.y+20,APP_CONTENT_WIDTH-90-30,30);
    
    self.pswImageView.frame = CGRectMake(45+2, self.phoneTextField.frame.size.height+self.phoneTextField.frame.origin.y+20+5, 20, 25);
    
    _pswLine = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ic_login_line.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]
                                          highlightedImage:[[UIImage imageNamed:@"ic_logoin_green"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]];
    _pswLine.frame = CGRectMake(self.pswTextField.frame.origin.x-30,
                                         self.pswTextField.frame.origin.y+self.pswTextField.frame.size.height,
                                         self.pswTextField.frame.size.width+30,
                                         3);
    
    [self.view addSubview:self.pswTextField];
    [self.view addSubview:self.pswImageView];
    [self.view addSubview:_pswLine];
    
    
    //登录
    _btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(APP_CONTENT_WIDTH/5,
                                                           self.pswTextField.frame.origin.y+self.pswTextField.frame.size.height+50+12,
                                                           APP_CONTENT_WIDTH*3/5,
                                                           38)];
//    _btnLogin.layer.masksToBounds = YES;
    _btnLogin.layer.cornerRadius = 18;
    [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    _btnLogin.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [_btnLogin addTarget:self action:@selector(LogOnClick) forControlEvents:UIControlEventTouchUpInside];
    _btnLogin.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    _btnLogin.backgroundColor = RGBColor(30, 172, 134);
    _btnLogin.backgroundColor = UIColorFromHex(0x3aa566);
    
    _btnLogin.layer.shadowColor = UIColorFromHex(0x3aa566).CGColor;
    _btnLogin.layer.shadowOpacity = 0.3f;
    _btnLogin.layer.shadowRadius =18;
    _btnLogin.layer.shadowOffset = CGSizeMake(5,5);
    [self.view addSubview:_btnLogin];
    
    //注册
    UIButton *btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(45,self.pswTextField.frame.origin.y+self.pswTextField.frame.size.height+5,
                                                                       30,
                                                                       30)];
    [btnRegister setTitle:@"注册" forState:UIControlStateNormal];
    [btnRegister setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btnRegister.titleLabel.font =  [UIFont boldSystemFontOfSize:14.0];
    //btnRegister.titleLabel.alignmentRectInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    btnRegister.titleLabel.textAlignment = NSTextAlignmentLeft;
    btnRegister.backgroundColor = [UIColor clearColor];
    [btnRegister addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRegister];
    
    //忘记密码
    UIButton *btnForget = [[UIButton alloc] initWithFrame:CGRectMake(self.pswTextField.frame.size.width+self.pswTextField.frame.origin.x-65,
                                                                     self.pswTextField.frame.origin.y+self.pswTextField.frame.size.height+5,
                                                                     75,
                                                                     30)];
    [btnForget addTarget:self action:@selector(btnForgetClick) forControlEvents:UIControlEventTouchUpInside];
    [btnForget setTitle:@"忘记密码" forState:UIControlStateNormal];
    [btnForget setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btnForget.titleLabel.font =  [UIFont boldSystemFontOfSize:14.0];
    //    btnForget.titleLabel.font = [UIFont systemFontOfSize:15];
    btnForget.backgroundColor = [UIColor clearColor];
    btnForget.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:btnForget];

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

-(void)registerClick{
    NSLog(@"点击注册");
    RegeistViewController *reg = [[RegeistViewController alloc]init];
    [self.navigationController pushViewController:reg animated:YES];
    
}
-(void)btnForgetClick{
    NSLog(@"点击忘记密码");
    ForgetViewController *forVc = [[ForgetViewController alloc]init];
    [self.navigationController pushViewController:forVc animated:YES];
}

-(void)LogOnClick{
    NSLog(@"点击登录");
    
//    CompleteInfoViewController *com = [[CompleteInfoViewController alloc]init];
//    [self.navigationController pushViewController:com animated:YES];
//    

    BOOL res = [ZhengZeSupport isMobileNumber:_phoneTextField.text];
    
    if(res == true){
        
        NSString *pswStr = _pswTextField.text;
        if(pswStr.length>=6){
            NSLog(@"下一步");
            
            [[InterfaceSingleton shareInstance].interfaceModel userLoginWithPhone:_phoneTextField.text AndSecret:_pswTextField.text WithCallBack:^(int state, id data, NSString *msg) {
                
                
                
                if(state == 2000){
                    
                    NSDictionary *dic = (NSDictionary *)data;
                    
                    NSString *token = dic[@"token"];
                    NSString *fid = dic[@"fid"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                    [[NSUserDefaults standardUserDefaults] setObject:fid forKey:@"fid"];
                    
                    int status = [dic[@"status"]intValue];
                    if(status == 0 ){
                        [MBProgressHUD showSuccess:@"您的账号已被冻结"];
                        return ;
                    }else if(status == 1){
                        _btnLogin.enabled = false;
                        //正常状态
                        [MBProgressHUD showSuccess:@"登陆成功"];
                        
                        [[NSUserDefaults standardUserDefaults]setObject:@"login" forKey:@"loginMark"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.5* NSEC_PER_SEC);
                        
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            BaseTabBarController *base = [[BaseTabBarController alloc]init];
                            appDelegate.window.rootViewController = base;
                            
                            
                        });

                        
                       
                        
                        return;
                    }else if(status == 2){
                        //完善信息
                        
                        [MBProgressHUD showSuccess:@"请先完善信息后再登录"];
                        CompleteInfoViewController *com = [[CompleteInfoViewController alloc]init];
                        [self.navigationController pushViewController:com animated:YES];

                        return;
                    }
                    
                    //                [[JXTCacher cacher]setValue:token forKey:@"token"];
//                    [[JXTCacher cacher]setObject:token forKey:@"token" userId:UserId useArchive:YES];
                    
                    
                }else{
                    [MBProgressHUD showSuccess:msg];
                    
                }
//                [[JXTCacher cacher]objectForKey:@"token" userId:UserId achive:^(JXTCacher *cacher, id obj, CacheError error) {
//                    NSString *token = obj;
//                  
//                }];
               
                
            }];

            
        }else{
//            NSLog(@"密码长度小于6位");
            [MBProgressHUD showSuccess:@"密码长度小于6位"];
        }
        
        
    }else{
        [MBProgressHUD showSuccess:@"手机号格式错误"];
    }
    
    
    
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    NSLog(@"输入改变");
    if(textField == _phoneTextField){
        
        NSString *str = textField.text;
        
        if(str.length>11){
            _phoneTextField.text = phoneNum;
            
            [MBProgressHUD showSuccess:@"手机号应为11位"];
        }else{
            phoneNum = str;
        }
        
    }
    

}



-(UITextField *)phoneTextField{
    if(_phoneTextField == nil){
        _phoneTextField = [[UITextField alloc]init];
        _phoneTextField.placeholder = @"手机号";
        _phoneTextField.backgroundColor = [UIColor clearColor];
        _phoneTextField.contentMode = UIViewContentModeCenter;
        _phoneTextField.returnKeyType = UIReturnKeyDone;
        _phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneTextField.delegate = self;
        _phoneTextField.keyboardType =UIKeyboardTypePhonePad;//键盘:英文+数字
        [_phoneTextField addTarget:self
                           action:@selector(textFieldEditChanged:)
                 forControlEvents:UIControlEventEditingChanged];
        _phoneTextField.secureTextEntry = NO;

    }
    return _phoneTextField;
}
-(UITextField *)pswTextField{
    if(_pswTextField == nil){
        _pswTextField = [[UITextField alloc]init];
        _pswTextField.placeholder = @"密码";
        _pswTextField.backgroundColor = [UIColor clearColor];
        _pswTextField.contentMode = UIViewContentModeCenter;
        _pswTextField.returnKeyType = UIReturnKeyDone;
        _pswTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _pswTextField.delegate = self;
        _pswTextField.secureTextEntry = YES;
        [_pswTextField addTarget:self
                           action:@selector(textFieldEditChanged:)
                 forControlEvents:UIControlEventEditingChanged];

    }
    return _pswTextField;
}

-(UIImageView *)phoneImageView{
    if(_phoneImageView == nil){
        _phoneImageView = [[UIImageView alloc]init];
        _phoneImageView.image = [UIImage imageNamed:@"0-手机号"];
        _phoneImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _phoneImageView.backgroundColor = [UIColor grayColor];
    }
    return _phoneImageView;
}

-(UIImageView *)pswImageView{
    if(_pswImageView == nil){
        _pswImageView = [[UIImageView alloc]init];
        _pswImageView.image = [UIImage imageNamed:@"0-密码"];
        _pswImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _pswImageView.backgroundColor = [UIColor grayColor];
    }
    return _pswImageView;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_pswTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder];//关闭键盘
    return YES;
}


//
//-(UIView *)phoneLine{
//    if(_phoneLine == nil){
//        _phoneLine = [[UIView alloc]init];
//        _phoneLine.backgroundColor = [UIColor lightGrayColor];
//    }
//    return _phoneLine;
//}
//
//-(UIView *)pswLine{
//    if(_pswLine == nil){
//        _pswLine = [[UIView alloc]init];
//        _pswLine.backgroundColor = [UIColor lightGrayColor];
//    }
//    return _pswLine;
//}


@end
