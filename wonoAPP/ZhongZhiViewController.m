//
//  WorkViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/28.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "ZhongZhiViewController.h"
#import "UITextView+Placeholder.h"




#import "CDZPicker.h"
#import "LimitInput.h"
#import "WSDatePickerView.h"

@interface ZhongZhiViewController ()<UITextViewDelegate>


@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UIButton *saveBtn;

@property (nonatomic,strong)UILabel *catLabel;
@property (nonatomic,strong)UILabel *catDetailLabel;

@property (nonatomic,strong)UILabel *moneyLabel;
@property (nonatomic,strong)UITextView *moneyTextView;

@property (nonatomic,strong)UILabel *perLabel;
@property (nonatomic,strong)UITextView *perTextView;

@property (nonatomic,strong)UILabel *addLabel;
@property (nonatomic,strong)UITextView *addTextView;

@property (nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,strong)WSDatePickerView *datepicker;

@property (nonatomic,strong)NSDate *SelDate;


@end

@implementation ZhongZhiViewController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    [self createSaveBtn];
    
//    [self createTime];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)createSaveBtn{
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_saveBtn addTarget:self action:@selector(SaveClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_saveBtn];
    //    _saveBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.right.equalTo(_headView.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(26)));
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
}

-(void)SaveClick{
    
    [_moneyTextView resignFirstResponder];
    [_perTextView resignFirstResponder];
    [_addTextView resignFirstResponder];
    NSLog(@"点击提交");
    
    if([_moneyTextView.text isEqualToString:@""]||[_perTextView.text isEqualToString:@""]){
        [MBProgressHUD showSuccess:@"请完善信息"];
        return;
    }
    
    _model.price = _perTextView.text;
    _model.amount = _moneyTextView.text;
    _model.note = _addTextView.text;
    
    
    [[InterfaceSingleton shareInstance].interfaceModel PostPlantWithModel:_model WithCallBack:^(int state, id data, NSString *msg) {
       
        if(state == 2000){
            NSLog(@"成功");
            [MBProgressHUD showSuccess:@"提交成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
        
    }];
    
}

-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"种植";
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
    
    [_moneyTextView resignFirstResponder];
    [_perTextView resignFirstResponder];
    [_addTextView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createCon{
    _catLabel = [[UILabel alloc]init];
    _catLabel.text = @"品种:";
    _catLabel.font = [UIFont systemFontOfSize:13];
    _catLabel.textColor = UIColorFromHex(0x000000);
    [self.view addSubview:_catLabel];
    _catDetailLabel = [[UILabel alloc]init];
    _catDetailLabel.text = @"蔬菜>西红柿>小西红柿";
    _catDetailLabel.font = [UIFont systemFontOfSize:13];
    _catDetailLabel.textColor = UIColorFromHex(0x9fa0a0);
    [self.view addSubview:_catDetailLabel];
    
    [_catLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(HDAutoWidth(40));
        make.height.equalTo(@(HDAutoHeight(32)));
        make.top.equalTo(_headView.mas_bottom).offset(HDAutoHeight(45));
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
    [_catDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_catLabel.mas_right).offset(HDAutoWidth(10));
        make.centerY.equalTo(_catLabel.mas_centerY);
        make.height.equalTo(_catLabel.mas_height);
        make.width.equalTo(@(HDAutoWidth(500)));
    }];
    
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.text = @"设置数值:";
    _moneyLabel.font = [UIFont systemFontOfSize:13];
    _moneyLabel.textColor = UIColorFromHex(0x000000);
    [self.view addSubview:_moneyLabel];
    
    _perLabel = [[UILabel alloc]init];
    _perLabel.text = @"单价:";
    _perLabel.font = [UIFont systemFontOfSize:13];
    _perLabel.textColor = UIColorFromHex(0x000000);
    [self.view addSubview:_perLabel];
    
    _addLabel = [[UILabel alloc]init];
    _addLabel.text = @"备注信息:";
    _addLabel.font = [UIFont systemFontOfSize:13];
    _addLabel.textColor = UIColorFromHex(0x000000);
    [self.view addSubview:_addLabel];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(HDAutoWidth(40));
        make.height.equalTo(@(HDAutoHeight(32)));
        make.top.equalTo(_catLabel.mas_bottom).offset(HDAutoHeight(55));
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
    [_perLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(HDAutoWidth(40));
        make.height.equalTo(@(HDAutoHeight(32)));
        make.top.equalTo(_moneyLabel.mas_bottom).offset(HDAutoHeight(55));
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
    
    _moneyTextView = [[UITextView alloc]init];
    _moneyTextView.layer.masksToBounds = YES;
    _moneyTextView.layer.cornerRadius = 5;
    _moneyTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _moneyTextView.layer.borderWidth = 1;
    _moneyTextView.font = [UIFont systemFontOfSize:14];
    _moneyTextView.textAlignment = NSTextAlignmentCenter;
    _moneyTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [self.view addSubview:_moneyTextView];
    
    [_moneyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_moneyLabel.mas_centerY);
        make.height.equalTo(@(HDAutoHeight(68)));
        make.width.equalTo(@(HDAutoWidth(320)));
        make.left.equalTo(_catDetailLabel.mas_left);
    }];
    
    _perTextView = [[UITextView alloc]init];
    _perTextView.layer.masksToBounds = YES;
    _perTextView.layer.cornerRadius = 5;
    _perTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _perTextView.layer.borderWidth = 1;
    _perTextView.font = [UIFont systemFontOfSize:14];
    _perTextView.textAlignment = NSTextAlignmentCenter;
    _perTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [self.view addSubview:_perTextView];
    
    [_perTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_perLabel.mas_centerY);
        make.height.equalTo(@(HDAutoHeight(68)));
        make.width.equalTo(@(HDAutoWidth(320)));
        make.left.equalTo(_catDetailLabel.mas_left);
    }];
    
    _addTextView = [[UITextView alloc]init];
    _addTextView.layer.masksToBounds = YES;
    _addTextView.layer.cornerRadius = 5;
    _addTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _addTextView.layer.borderWidth = 1;
    _addTextView.font = [UIFont systemFontOfSize:14];
    //    _addTextView.textAlignment = NSTextAlignmentCenter;
    //    _addTextView.keyboardType = UIKeyboardTypeNumberPad;
    _addTextView.placeholder = @"建议输入具体的品种,限100字";
    
    [self.view addSubview:_addTextView];
    
    
    _moneyTextView.delegate = self;
    _perTextView.delegate = self;
    _addTextView.delegate = self;
    
    
    UILabel *extraLabel = [[UILabel alloc]init];
    extraLabel.text = @"株/粒";
    extraLabel.font = [UIFont systemFontOfSize:13];
    extraLabel.textColor = UIColorFromHex(0x9fa0a0);
    [self.view addSubview:extraLabel];
    UILabel *extraLabel2 = [[UILabel alloc]init];
    extraLabel2.text = @"元";
    extraLabel2.font = [UIFont systemFontOfSize:13];
    extraLabel2.textColor = UIColorFromHex(0x9fa0a0);
    [self.view addSubview:extraLabel2];
    
    [extraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_moneyTextView.mas_right).offset(HDAutoWidth(15));
        make.centerY.equalTo(_moneyTextView.mas_centerY);
        make.width.equalTo(@(HDAutoWidth(120)));
        make.height.equalTo(_moneyLabel.mas_height);
    }];
    [extraLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_moneyTextView.mas_right).offset(HDAutoWidth(15));
        make.centerY.equalTo(_perTextView.mas_centerY);
        make.width.equalTo(@(HDAutoWidth(50)));
        make.height.equalTo(_moneyLabel.mas_height);
    }];
    
//    [self.view layoutIfNeeded];
//    // 选择框
//    UILabel *nowView = [[UILabel alloc] initWithFrame:CGRectMake(extraLabel.x+extraLabel.width+HDAutoWidth(10), _perTextView.y, HDAutoWidth(150), HDAutoHeight(68))];
//    //    // 显示选中框
//    //    fzpickerView.fzdelegate = self;
//    //    fzpickerView.proTitleList = @[@[@"g",@"kg",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"]];
//    nowView.textColor = UIColorFromHex(0x9fa0a0);
//    nowView.text = @"单位";
//    nowView.font = [UIFont systemFontOfSize:14];
//    nowView.textAlignment = NSTextAlignmentCenter;
//    nowView.layer.masksToBounds = YES;
//    nowView.layer.cornerRadius = 5;
//    nowView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    nowView.layer.borderWidth = 1;
//    nowView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
//    [nowView addGestureRecognizer:labelTapGestureRecognizer];
//    
//    [self.view addSubview:nowView];
    
    [_addTextView setValue:@100 forKey:@"limit"];
    
    [_addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(HDAutoWidth(40));
        make.height.equalTo(@(HDAutoHeight(32)));
        make.top.equalTo(_perTextView.mas_bottom).offset(HDAutoHeight(20));
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
    [_addTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_perTextView.mas_bottom).offset(HDAutoHeight(20));
        make.height.equalTo(@(HDAutoHeight(330)));
        make.width.equalTo(@(HDAutoWidth(530)));
        make.left.equalTo(_catDetailLabel.mas_left);
    }];

    
}

//-(void)labelClick:(UITapGestureRecognizer *)recognizer{
//    UILabel *label=(UILabel*)recognizer.view;
//    NSLog(@"%ld被点击了",(long)label.tag);
//    
//    NSArray *arr = [NSArray arrayWithObjects:@"g",@"kg",@"qq",@"ww",@"ee", nil];
//    
//    [CDZPicker showPickerInView:self.view withStrings:arr confirm:^(NSArray<NSString *> *stringArray) {
//        //        self.label.text = stringArray.firstObject;
//        NSLog(@"点击");
//        
//        //        NSString *str = stringArray.firstObject;
//        //        NSString *str2 = label.text;
//        //        str2 = [str2 substringToIndex:8];
//        //
//        //        NSString *result = [NSString stringWithFormat:@"%@%@°C",str2,str];
//        //
//        label.text = stringArray.firstObject;
//    }cancel:^{
//        //your code
//        NSLog(@"取消");
//        
//    }];
//    
//}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_moneyTextView resignFirstResponder];
    [_perTextView resignFirstResponder];
    [_addTextView resignFirstResponder];
    
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//
//}
- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"%@",textView.text);
}

-(void)createTime{
    UILabel *titletimeLabel = [[UILabel alloc]init];
    titletimeLabel.font = [UIFont systemFontOfSize:13];
    titletimeLabel.textColor = UIColorFromHex(0x000000);

    titletimeLabel.text = @"时间:";
    [self.view addSubview:titletimeLabel];
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = UIColorFromHex(0x9fa0a0);
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"  点击添加"];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"0-日历"];
    attch.bounds = CGRectMake(0, -HDAutoHeight(8), HDAutoWidth(32), HDAutoWidth(32));
    //创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    //将图片放在最后一位
    //[attri appendAttributedString:string];
    //将图片放在第一位
    [attri insertAttributedString:string atIndex:0];
    //用label的attributedText属性来使用富文本
    _timeLabel.attributedText = attri;
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [_timeLabel addGestureRecognizer:labelTapGestureRecognizer];
    
    _timeLabel.userInteractionEnabled = YES;
    
    [self.view addSubview:_timeLabel];
    
    [titletimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_perLabel.mas_left);
        make.top.equalTo(_perTextView.mas_bottom).offset(HDAutoHeight(20));
        make.height.equalTo(@(HDAutoHeight(40)));
        make.width.equalTo(@(HDAutoWidth(80)));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_perTextView.mas_bottom).offset(HDAutoHeight(20));
        make.left.equalTo(_perTextView.mas_left);
        make.height.equalTo(@(HDAutoHeight(40)));
        make.width.equalTo(@(HDAutoWidth(300)));
    }];
    
    
    
    [_addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(HDAutoWidth(40));
        make.height.equalTo(@(HDAutoHeight(32)));
        make.top.equalTo(_perTextView.mas_bottom).offset(HDAutoHeight(20));
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
    [_addTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_perTextView.mas_bottom).offset(HDAutoHeight(20));
        make.height.equalTo(@(HDAutoHeight(330)));
        make.width.equalTo(@(HDAutoWidth(530)));
        make.left.equalTo(_catDetailLabel.mas_left);
    }];


    
}

-(void)labelClick:(UITapGestureRecognizer *)recognizer{
    UILabel *label=(UILabel*)recognizer.view;
    
    _datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *startDate) {
        NSString *date = [startDate stringWithFormat:@"yyyy-MM-dd"];
        NSLog(@"时间： %@",date);
        
        _SelDate = startDate;
        
        //创建富文本
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",date]];
        //NSTextAttachment可以将要插入的图片作为特殊字符处理
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        //定义图片内容及位置和大小
        attch.image = [UIImage imageNamed:@"0-日历"];
        attch.bounds = CGRectMake(0, -HDAutoHeight(8), HDAutoWidth(32), HDAutoWidth(32));
        //创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        //将图片放在最后一位
        //[attri appendAttributedString:string];
        //将图片放在第一位
        [attri insertAttributedString:string atIndex:0];
        //用label的attributedText属性来使用富文本
        label.attributedText = attri;
        
        
        
    }];
    if(_SelDate != nil){
        [_datepicker getNowDate:_SelDate animated:YES];
    }
    
    _datepicker.doneButtonColor = UIColorFromHex(0x3fb36f);//确定按钮的颜色
    
    [_datepicker show];
    
    
}

-(void)setModel:(PlantAddModel *)model{
    _model = model;
    [self createCon];
    _catDetailLabel.text = _model.varName;
    
    
}


@end
