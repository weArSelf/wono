//
//  ChangeNameViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/2.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "ChangeNameViewController.h"


@interface ChangeNameViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIButton *nextBtn;

@property (nonatomic,strong)UITextField *nameTextField;


@end

@implementation ChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatTitleAndBackBtn];
    [self createNextBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTextField];
    
    _nextBtn.enabled = NO;
    [_nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    _nextBtn.titleLabel.textColor = [UIColor grayColor];
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
    _titleLabel.text = @"修改昵称";
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
    if([_nameTextField.text isEqualToString:@""]){
        [MBProgressHUD showSuccess:@"昵称不能为空"];
        return;
    }
    [[InterfaceSingleton shareInstance].interfaceModel updateUserInfoWithAvatar:nil AndSex:nil AndName:_nameTextField.text AndCallBack:^(int state, id data, NSString *msg) {
       
        if(state == 2000){
            [MBProgressHUD showSuccess:@"修改成功"];
            if([self.delegate respondsToSelector:@selector(nameChangedWithName:)]){
                [self.delegate nameChangedWithName:_nameTextField.text];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [MBProgressHUD showSuccess:msg];
            
        }
        
        
    }];
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_nameTextField resignFirstResponder];
    
}

-(void)createTextField{
    _nameTextField = [[UITextField alloc]init];
    
    _nameTextField.text = _needName;
    
    _nameTextField.placeholder = @"请输入昵称";
    
    _nameTextField.layer.cornerRadius = 5;
    
    _nameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _nameTextField.layer.borderWidth = 1;
    
    _nameTextField.font = [UIFont systemFontOfSize:13];
    
    _nameTextField.textColor = UIColorFromHex(0x727171);
    
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _nameTextField.delegate = self;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HDAutoWidth(15), HDAutoHeight(70))];
    _nameTextField.leftView = paddingView;
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
//    _nameTextField.rightView = paddingView;
    [self.view addSubview:_nameTextField];
    
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(HDAutoWidth(15));
        make.right.equalTo(self.view.mas_right).offset(HDAutoWidth(-15));
        make.top.equalTo(@(64+HDAutoHeight(22)));
        make.height.equalTo(@(HDAutoHeight(70)));
    }];
}

-(void)setNeedName:(NSString *)needName{
    _needName = needName;
//    _nameTextField.text = _needName;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 当点击键盘的返回键（右下角）时，执行该方法。
    // 一般用来隐藏键盘
    [textField resignFirstResponder];
    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if([toBeString isEqualToString:self.needName]){
        _nextBtn.enabled = NO;
        [_nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        _nextBtn.titleLabel.textColor = [UIColor grayColor];
    }else{
        _nextBtn.enabled = YES;
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _nextBtn.titleLabel.textColor = [UIColor whiteColor];
    }
    
    
       return YES;
}





@end
