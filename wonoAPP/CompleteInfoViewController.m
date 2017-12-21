//
//  CompleteInfoViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/11.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "CompleteInfoViewController.h"

#import "BaseTabBarController.h"
#import "PlantControllViewController.h"
#import "StatisticsViewController.h"
#import "TempViewController.h"
#import "WonoCircleViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"
#import "BaseNavViewController.h"
#import "WSDatePickerView.h"
#import "MapViewController.h"

#import "BBFlashCtntLabel.h"

#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)

@interface CompleteInfoViewController ()<UITextFieldDelegate,MyLocationDelegate>

@property (nonatomic,strong)BaseTabBarController *base;

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel2;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *farmerBtn;
@property (nonatomic,strong)UIButton *employBtn;
@property (nonatomic,strong)UILabel *FnameLabel;
@property (nonatomic,strong)UILabel *YnameLabel;

@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *sexLabel;
@property (nonatomic,strong)UILabel *dateLabel;
@property (nonatomic,strong)UILabel *farmLabel;
@property (nonatomic,strong)UILabel *addressLabel;

@property (nonatomic,strong)UIButton *confirmBtn;

@property (nonatomic,strong)UITextField *nameTextField;
@property (nonatomic,strong)UITextField *farmTextField;

@property (nonatomic,strong)UILabel *sexSelectLabel;

@property (nonatomic,strong)UIButton *dateBtn;
@property (nonatomic,strong)UILabel *selDateLabel;
@property (nonatomic,strong)WSDatePickerView *datepicker;
@property (nonatomic,strong)NSDate *SelDate;

@property (nonatomic,strong)UIView *addressView;
@property (nonatomic,strong)UIButton *adrBtn;
@property (nonatomic,strong)BBFlashCtntLabel *adrLabel;


@end

@implementation CompleteInfoViewController{
    CGFloat height;
    CompleteModel *model;
    
    NSString *orgName;
    NSString *orgfarm;
    
    NSString *needlongitude;
    NSString *needlatitude;
    
    BMKReverseGeoCodeResult *res;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    orgName = @"";
    orgfarm = @"";
    
    model = [[CompleteModel alloc]init];
    
    model.type = 1;
    
    model.sex = -1;
    
    [self creatTitleAndBackBtn];
    [self createTitleAndBtn];
    [self createLabels];
    [self creatConfiemBtn];
    [self createTextField];
    [self createNext];
    [self createDate];
    [self createAddress];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchChange:) name:@"searchChange" object:nil];
    
}

//-(void)searchChange:(NSNotification *)noti{
//    NSDictionary *dic = (NSDictionary *)[noti object];
//
//    NSString *lat = dic[@"lat"];
//    NSString *lont = dic[@"lont"];
//    _adrLabel.text = dic[@"adress"];
//    
//    needlongitude = lont;
//    needlatitude = lat;
//    
//    NSLog(@"%@  %@  %@", dic[@"name"],lat,lont);
//    
//}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createTitleAndBtn{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"选择角色";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor grayColor];
    [self.view addSubview:_titleLabel];
   
  
    
    _farmerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_farmerBtn addTarget:self action:@selector(farmerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_farmerBtn setImage:[UIImage imageNamed:@"未选中-农场主"] forState:UIControlStateNormal];
    [_farmerBtn setImage:[UIImage imageNamed:@"选中-农场主"] forState:UIControlStateSelected];
    _farmerBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
//    [_farmerBtn setTitle:@"农场主" forState:UIControlStateNormal];
//    [_farmerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _farmerBtn.selected = YES;
    
    [self.view addSubview:_farmerBtn];
    

    
    _employBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_employBtn addTarget:self action:@selector(employBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_employBtn setImage:[UIImage imageNamed:@"未选中-员工"] forState:UIControlStateNormal];
     [_employBtn setImage:[UIImage imageNamed:@"选中-员工"] forState:UIControlStateSelected];
    _employBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
//    [_employBtn setTitle:@"员工" forState:UIControlStateNormal];
//    [_employBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    [self.view addSubview:_employBtn];
    
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom).offset(HDAutoHeight(20));
        make.height.equalTo(@(30));
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(100));
    }];
    [_farmerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_centerX).offset(-10);
        make.width.equalTo(@(100));
        make.height.equalTo(@(100));
    }];

    [_employBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(20);
        make.left.equalTo(_farmerBtn.mas_right).offset(20);
        make.width.equalTo(@(100));
        make.height.equalTo(@(100));
    }];
    
    
    _FnameLabel = [[UILabel alloc]init];
    _FnameLabel.text = @"农场主";
    _FnameLabel.textColor = [UIColor blackColor];
    _FnameLabel.font = [UIFont systemFontOfSize:14];
    _FnameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_FnameLabel];
    
    _YnameLabel = [[UILabel alloc]init];
    _YnameLabel.text = @"员工";
    _YnameLabel.textColor = [UIColor blackColor];
    _YnameLabel.font = [UIFont systemFontOfSize:14];
    _YnameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_YnameLabel];
    
    [_FnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_farmerBtn.mas_centerX);
        make.top.equalTo(_farmerBtn.mas_bottom);
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];
    [_YnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_employBtn.mas_centerX);
        make.top.equalTo(_employBtn.mas_bottom);
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));

    }];
    
//    [self initButton:_farmerBtn];
//    [self initButton:_employBtn];
    
    //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
   
    
    
//    _employBtn.imageEdgeInsets = UIEdgeInsetsMake(- (_employBtn.frame.size.height - _employBtn.titleLabel.frame.size.height- _employBtn.titleLabel.frame.origin.y),(_employBtn.frame.size.width -_employBtn.titleLabel.frame.size.width)/2.0f -_employBtn.imageView.frame.size.width, 0, 0);
//    _employBtn.titleEdgeInsets = UIEdgeInsetsMake(_employBtn.frame.size.height-_employBtn.imageView.frame.size.height-_employBtn.imageView.frame.origin.y, -_employBtn.imageView.frame.size.width, 0, 0);

}

-(void)initButton:(UIButton*)btn{
    //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height+30 ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

-(void)farmerBtnClick{
    NSLog(@"点击农场主");
    
    model.type = 1;
    _farmerBtn.selected = YES;
    _employBtn.selected = NO;
    
    [_farmTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        _farmLabel.alpha = 1;
        _farmTextField.alpha = 1;
        _addressLabel.alpha = 1;
        _addressView.alpha = 1;
    }];
}

-(void)employBtnClick{
    NSLog(@"点击员工");
    
    model.type = 2;
    _farmerBtn.selected = NO;
    _employBtn.selected = YES;
    
    [_farmTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        _farmLabel.alpha = 0;
        _farmTextField.alpha = 0;
        _addressLabel.alpha = 0;
        _addressView.alpha = 0;
    }];
    
    
}

-(void)createLabels{
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.text = @"姓名:";
    [self.view addSubview:_nameLabel];
    
    _sexLabel = [[UILabel alloc]init];
    _sexLabel.backgroundColor = [UIColor clearColor];
    _sexLabel.textColor = [UIColor blackColor];
    _sexLabel.font = [UIFont systemFontOfSize:14];
    _sexLabel.text = @"性别:";
    [self.view addSubview:_sexLabel];
    
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textColor = [UIColor blackColor];
    _dateLabel.font = [UIFont systemFontOfSize:14];
    _dateLabel.text = @"出生年月:";
    [self.view addSubview:_dateLabel];
    
    _farmLabel = [[UILabel alloc]init];
    _farmLabel.backgroundColor = [UIColor clearColor];
    _farmLabel.textColor = [UIColor blackColor];
    _farmLabel.font = [UIFont systemFontOfSize:14];
    _farmLabel.text = @"农场名:";
    [self.view addSubview:_farmLabel];
    
    _addressLabel = [[UILabel alloc]init];
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.textColor = [UIColor blackColor];
    _addressLabel.font = [UIFont systemFontOfSize:14];
    _addressLabel.text = @"农场地址:";
    [self.view addSubview:_addressLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.top.equalTo(self.farmerBtn.mas_bottom).offset(40);
        make.height.equalTo(@(40));
        make.width.equalTo(@(80));
    }];
    
    [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.top.equalTo(_nameLabel.mas_bottom).offset(10);
        make.height.equalTo(@(40));
        make.width.equalTo(@(80));
    }];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.top.equalTo(_sexLabel.mas_bottom).offset(10);
        make.height.equalTo(@(40));
        make.width.equalTo(@(80));
    }];
    [_farmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.top.equalTo(_dateLabel.mas_bottom).offset(10);
        make.height.equalTo(@(40));
        make.width.equalTo(@(80));
    }];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.top.equalTo(_farmLabel.mas_bottom).offset(10);
        make.height.equalTo(@(40));
        make.width.equalTo(@(80));
    }];
    
}

-(void)creatConfiemBtn{
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setTitle:@"开始使用" forState:UIControlStateNormal];
//    [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_confirmBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmBtn];
    
    if(IS_IPHONE_5){
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressLabel.mas_bottom).offset(HDAutoHeight(30));
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(APP_CONTENT_WIDTH*3/5));
        make.height.equalTo(@(HDAutoHeight(90)));
    }];
//    _confirmBtn.layer.masksToBounds = YES;
    _confirmBtn.layer.cornerRadius = HDAutoHeight(40);
    _confirmBtn.backgroundColor = UIColorFromHex(0x3aa566);
    _confirmBtn.layer.shadowColor = UIColorFromHex(0x3fb36f).CGColor;
    _confirmBtn.layer.shadowOpacity = 0.3f;
    _confirmBtn.layer.shadowRadius =18;
    _confirmBtn.layer.shadowOffset = CGSizeMake(5,5);
        
    }else{
        
        [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_addressLabel.mas_bottom).offset(40);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(@(APP_CONTENT_WIDTH*3/5));
            make.height.equalTo(@(HDAutoHeight(90)));
        }];
        //    _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = 18;
        _confirmBtn.backgroundColor = UIColorFromHex(0x3aa566);
        _confirmBtn.layer.shadowColor = UIColorFromHex(0x3fb36f).CGColor;
        _confirmBtn.layer.shadowOpacity = 0.3f;
        _confirmBtn.layer.shadowRadius =18;
        _confirmBtn.layer.shadowOffset = CGSizeMake(5,5);
    
    }
    
}

-(void)confirmBtnClick{
    NSLog(@"点击开始使用");
    
    model.name = _nameTextField.text;
    model.farmName = _farmTextField.text;
    model.address = _adrLabel.text;
    
    BMKAddressComponent *addDeal = res.addressDetail;
    model.city = addDeal.city;
    model.province = addDeal.province;
    model.district = addDeal.district;
    
    NSString *locate = [NSString stringWithFormat:@"%f,%f",res.location.longitude,res.location.latitude];
    
    model.location = locate;
    
    if([model.name isEqualToString:@""]){
        [MBProgressHUD showSuccess:@"请填写姓名"];
        return;
    }
    if(model.sex == -1){
        [MBProgressHUD showSuccess:@"请选择性别"];
        return;
    }
    if(model.birth == nil){
        [MBProgressHUD showSuccess:@"请选择出生年月"];
        return;
    }
    if(model.type == 1){
        if([model.farmName isEqualToString:@""]){
            [MBProgressHUD showSuccess:@"请填写农场名"];
            return;
        }
        //判断农场地址相关内容！！！！！
        if([_adrLabel.text isEqualToString:@""]){
            [MBProgressHUD showSuccess:@"请填写农场地址"];
            return;
        }
        
        
        
        
        

    }
    
    [[InterfaceSingleton shareInstance].interfaceModel completeUserInfoWthModel:model WithCallBack:^(int state, id data, NSString *msg) {
       
        
        if(state == 2000){
            [MBProgressHUD showSuccess:@"完善信息成功"];
            BaseTabBarController *base = [[BaseTabBarController alloc]init];
            appDelegate.window.rootViewController = base;
            
            [[NSUserDefaults standardUserDefaults]setObject:@"login" forKey:@"loginMark"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSDictionary *dic = data;
            
            NSString *fid = dic[@"fid"];
            
            [[NSUserDefaults standardUserDefaults] setObject:fid forKey:@"fid"];
            
            NSString *type = dic[@"type"];
            if(type){
                int tyint = [type intValue];
                NSString *reType = [NSString stringWithFormat:@"%d",tyint];
                [[NSUserDefaults standardUserDefaults] setObject:reType forKey:@"type"];
            }
            
        }else{
            [MBProgressHUD showSuccess:msg];
        }
        
    }];
    
    
    
    
    
    
   
    
    
    
    
    
//    self.base = [[BaseTabBarController alloc]init];
//    appDelegate.window.rootViewController = self.base;
    
}

-(void)createTextField{

    _nameTextField = [[UITextField alloc]init];
    _nameTextField.placeholder=@"请输入您的姓名";
//    _nameTextField.backgroundColor = [UIColor lightGrayColor];
    _nameTextField.layer.masksToBounds = YES;
    _nameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _nameTextField.layer.borderWidth = 1;
    _nameTextField.layer.cornerRadius = 5;
//    _nameTextField.textAlignment = NSTextAlignmentCenter;
    _nameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 0)];
    //设置显示模式为永远显示(默认不显示)
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    _nameTextField.font = [UIFont systemFontOfSize:14];
    _nameTextField.returnKeyType = UIReturnKeyDone;
    _nameTextField.delegate = self;
    
    [_nameTextField addTarget:self
                        action:@selector(textFieldEditChanged:)
              forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:_nameTextField];
    
    _farmTextField = [[UITextField alloc]init];
    _farmTextField.placeholder=@"请输入您的农场名称";
    [_farmTextField setValue:@10 forKey:@"limit"];
    //    _nameTextField.backgroundColor = [UIColor lightGrayColor];
    _farmTextField.layer.masksToBounds = YES;
    _farmTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _farmTextField.layer.borderWidth = 1;
    _farmTextField.layer.cornerRadius = 5;
//    _farmTextField.textAlignment = NSTextAlignmentCenter;
    
    [_farmTextField addTarget:self
                       action:@selector(textFieldEditChanged:)
             forControlEvents:UIControlEventEditingChanged];
    
    _farmTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 0)];
    //设置显示模式为永远显示(默认不显示)
    _farmTextField.leftViewMode = UITextFieldViewModeAlways;
    _farmTextField.font = [UIFont systemFontOfSize:14];
    _farmTextField.returnKeyType = UIReturnKeyDone;
    _farmTextField.delegate = self;
    [self.view addSubview:_farmTextField];

    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel.mas_centerY);
        make.height.equalTo(@(30));
        make.left.equalTo(_nameLabel.mas_right).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-30);
    }];
    
    [_farmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_farmLabel.mas_centerY);
        make.height.equalTo(@(30));
        make.left.equalTo(_farmLabel.mas_right).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-30);

    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
     [aTextfield resignFirstResponder];//关闭键盘
    return YES;
}

-(void)createNext{
    _sexSelectLabel = [[UILabel alloc]init];
    _sexSelectLabel.text = @"请选择";
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
    
//    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sexClick)];
    [_sexSelectLabel addGestureRecognizer:labelTapGestureRecognizer];
    _sexSelectLabel.font = [UIFont systemFontOfSize:14];
    _sexSelectLabel.textColor = [UIColor grayColor];
    _sexSelectLabel.userInteractionEnabled = YES;
    [self.view addSubview:_sexSelectLabel];
    
    [_sexSelectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_sexLabel.mas_centerY);
        make.left.equalTo(_nameTextField.mas_left);
        make.width.equalTo(@(100));
        make.height.equalTo(@(30));
    }];
}

-(void)labelClick{
    NSLog(@"选择性别");
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"男");
        _sexSelectLabel.text = @"男";
        
        model.sex = 1;
    }];
    [alertController addAction:maleAction];
    UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"女");
        _sexSelectLabel.text = @"女";
        
        model.sex = 2;
    }];
    [alertController addAction:femaleAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)createDate{
    _dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dateBtn setImage:[UIImage imageNamed:@"0-日历"] forState:UIControlStateNormal];
    [_dateBtn addTarget:self action:@selector(dateClick) forControlEvents:UIControlEventTouchUpInside];
    _dateBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:_dateBtn];
    _selDateLabel = [[UILabel alloc]init];
    _selDateLabel.font = [UIFont systemFontOfSize:14];
    _selDateLabel.text = @"请选择日期";
    _selDateLabel.textColor = [UIColor grayColor];
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateClick)];
    _selDateLabel.userInteractionEnabled = YES;
    [_selDateLabel addGestureRecognizer:labelTapGestureRecognizer];
    [self.view addSubview:_selDateLabel];
    
    [_dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_dateLabel.mas_centerY);
        make.left.equalTo(_sexSelectLabel.mas_left);
        make.height.equalTo(@(20));
        make.width.equalTo(@(20));
    }];
    [_selDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_dateLabel.mas_centerY);
        make.left.equalTo(_dateBtn.mas_right).offset(5);
        make.height.equalTo(@(30));
        make.width.equalTo(@(300));
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_nameTextField resignFirstResponder];
    [_farmTextField resignFirstResponder];
}

-(void)dateClick{
    NSLog(@"选择日期");
    _datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *startDate) {
        
        NSString *date = [startDate stringWithFormat:@"yyyy-MM-dd"];
        NSLog(@"时间： %@",date);
        
        model.birth = date;
        
        _selDateLabel.text = date;
         _SelDate = startDate;
        
    }];
    if(_SelDate != nil){
        [_datepicker getNowDate:_SelDate animated:YES];
    }
    
    _datepicker.doneButtonColor = UIColorFromHex(0x3fb36f);//确定按钮的颜色

    [_datepicker show];
    
}

-(void)createAddress{
    
    _addressView = [[UIView alloc]init];
    _addressView.backgroundColor = [UIColor clearColor];
    _addressView.layer.masksToBounds = YES;
    _addressView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _addressView.layer.borderWidth = 1;
    _addressView.layer.cornerRadius = 5;
    [self.view addSubview:_addressView];
    [_addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_addressLabel.mas_centerY);
        make.left.equalTo(_nameTextField.mas_left);
        make.width.equalTo(_nameTextField.mas_width);
        make.height.equalTo(_nameTextField.mas_height);
    }];
    _adrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_adrBtn setImage:[UIImage imageNamed:@"0-地点"] forState:UIControlStateNormal];
    [_adrBtn addTarget:self action:@selector(adrClick) forControlEvents:UIControlEventTouchUpInside];
    _adrBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_addressView addSubview:_adrBtn];
    
    _adrLabel = [[BBFlashCtntLabel alloc]init];
    _adrLabel.font = [UIFont systemFontOfSize:14];
    _adrLabel.text = @"";
//    点击选择位置
    _adrLabel.textColor = [UIColor lightGrayColor];
    [_addressView addSubview:_adrLabel];
    _adrLabel.speed = -1;
    [_adrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressView.mas_left).offset(5);
        make.centerY.equalTo(_addressView.mas_centerY);
        make.width.equalTo(@(20));
        make.height.equalTo(@(20));
    }];
    [_adrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_adrBtn.mas_right).offset(5);
        make.centerY.equalTo(_addressView.mas_centerY);
        make.right.equalTo(_addressView.mas_right).offset(-HDAutoWidth(40));
        make.height.equalTo(@(30));
    }];
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adrClick)];
    _adrLabel.userInteractionEnabled = YES;
    [_adrLabel addGestureRecognizer:labelTapGestureRecognizer];
    
}

-(void)adrClick{
    NSLog(@"跳地图去");
    
    MapViewController *map = [[MapViewController alloc]init];
    map.delegate = self;
    [self.navigationController pushViewController:map animated:YES];
}















- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    if (_nameTextField.isFirstResponder) {
        return;
    }
    if(_farmTextField.isFirstResponder){
        [_addressLabel layoutIfNeeded];
        [self.view layoutIfNeeded];
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        height = keyboardRect.size.height;
        CGFloat realHeight = height - (APP_CONTENT_HEIGHT - _addressLabel.y);
    //    float raiseHeight =  CGRectGetMaxY(self.farmLabel.frame)-height;
        [UIView animateWithDuration:0.3 animations:^{
            self.view.transform =CGAffineTransformMakeTranslation(0, -realHeight);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    NSLog(@"aaa");
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    height = keyboardRect.size.height;
//    float raiseHeight = height - CGRectGetMaxY(self.farmLabel.frame);
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.transform =CGAffineTransformIdentity;
        
        
    } completion:^(BOOL finished) {
        
    }];
    
    NSLog(@"bbb");
}



-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel2 = [[UILabel alloc]init];
    _titleLabel2.text = @"完善信息";
    _titleLabel2.textColor = [UIColor whiteColor];
    _titleLabel2.font = [UIFont systemFontOfSize:18];
    _titleLabel2.textAlignment = NSTextAlignmentCenter;
    [_headView addSubview:_titleLabel2];
    
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
    
    [_titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *str = textField.text;
    
    if (textField == _nameTextField) {
        if(str.length>8){
            [MBProgressHUD showSuccess:@"姓名不得超过8个字符"];
            NSString *res = [str substringWithRange:NSMakeRange(0, 6)];
            _nameTextField.text = res;
        }
    }else if (textField == _farmTextField){
        
        if(str.length>15){
            [MBProgressHUD showSuccess:@"农场名不得超过15个字符"];
            NSString *res = [str substringWithRange:NSMakeRange(0, 15)];
            _farmTextField.text = res;
        }
        
    }

    
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    NSLog(@"输入改变");
//    
//    NSString *content = textField.text;
//    
//    if(textField == _nameTextField){
//        
//        if(content.length>6){
//            [MBProgressHUD showSuccess:@"姓名不得超过6个字符"];
//            _nameTextField.text = orgName;
//        }else{
//            orgName = _nameTextField.text;
//        }
//        
//    }else if (textField == _farmTextField){
//        
//        if(content.length>15){
//            [MBProgressHUD showSuccess:@"农场名不得超过15个字符"];
//            _farmTextField.text = orgfarm;
//        }else{
//            orgfarm = _farmTextField.text;
//        }
//        
//    }
    
}


-(void)confirmWithobj:(BMKReverseGeoCodeResult *)serRes AndName:(NSString *)name{
    res = serRes;
    _adrLabel.text = name;
    
}

//-(void)confirmWithName:(NSString *)name AndLongitude:(NSString *)longitude AndLatitude:(NSString *)latitude AndCity:(NSString *)city AndAddress:(NSString *)address{
//
//    needlongitude = longitude;
//    needlatitude = latitude;
//
//    NSLog(@"%@  %@  %@", address,longitude,latitude);
//
//    _adrLabel.text = address;
//
//
//
//
//}



@end
