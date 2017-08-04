//
//  AddViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/28.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "AddViewController.h"
#import "WorkViewController.h"
#import "ShifeiViewController.h"
#import "ZhiBaoViewController.h"
#import "ZhongZhiViewController.h"

#import "WSDatePickerView.h"

@interface AddViewController ()

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIButton *nextBtn;

@property (nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,strong)WSDatePickerView *datepicker;

@property (nonatomic,strong)NSDate *SelDate;

@end

@implementation AddViewController
{
    NSMutableArray *pengData;
    UIButton *selcBtn;
    CGFloat bottomY;
    UIButton *typeSelcBtn;
    float typeIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    typeIndex = 0;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    [self createTime];
    [self createNextBtn];
    [self createContent];
    [self createType];
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
    _titleLabel.text = @"添加记录";
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

-(void)createTime{
    UILabel *titletimeLabel = [self mylabel];
    titletimeLabel.text = @"时间:";
    [self.view addSubview:titletimeLabel];
    _timeLabel = [self mylabel];
    
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"  添加"];
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
        make.left.equalTo(self.view.mas_left).offset(HDAutoWidth(30));
        make.top.equalTo(_headView.mas_bottom).offset(HDAutoHeight(20));
        make.height.equalTo(@(HDAutoHeight(40)));
        make.width.equalTo(@(HDAutoWidth(80)));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom).offset(HDAutoHeight(20));
        make.left.equalTo(titletimeLabel.mas_right);
        make.height.equalTo(@(HDAutoHeight(40)));
        make.width.equalTo(@(HDAutoWidth(300)));
    }];
    
}

-(UILabel *)mylabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UIColorFromHex(0x727171);
    return label;
}

-(void)createNextBtn{
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
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
    NSLog(@"点击下一步");
    
    int index = typeIndex;
    switch (index) {
        case 1:{
            ZhongZhiViewController *zhongzhi = [[ZhongZhiViewController alloc]init];
            [self.navigationController pushViewController:zhongzhi animated:YES];
             break;
        }
        case 2:{
            ShifeiViewController *shifei = [[ShifeiViewController alloc]init];
            [self.navigationController pushViewController:shifei animated:YES];
        }
            break;
        case 3:{
            ZhiBaoViewController *zhibao = [[ZhiBaoViewController alloc]init];
            [self.navigationController pushViewController:zhibao animated:YES];
        }
            break;
        case 4:{
            WorkViewController *work = [[WorkViewController alloc]init];
            [self.navigationController pushViewController:work animated:YES];
        }
            break;
            
        default:
            [MBProgressHUD showSuccess:@"请选择类型"];
            break;
    }

    
}

-(void)createContent{
    UILabel *selecLabel = [self mylabel];
    selecLabel.text = @"选择大棚:";
    [self.view addSubview:selecLabel];
    [selecLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(HDAutoWidth(30));
        make.top.equalTo(_timeLabel.mas_bottom).offset(HDAutoHeight(20));
        make.height.equalTo(@(HDAutoHeight(40)));
        make.width.equalTo(@(HDAutoWidth(280)));
    }];
    
    pengData = [NSMutableArray arrayWithObjects:@"黄瓜大棚",@"西瓜大棚",@"X瓜大棚",@"黄瓜大棚",@"黄瓜大棚",@"黄瓜大棚", nil];
    
    [selecLabel layoutIfNeeded];
    [self.view layoutIfNeeded];
    for (int i=0; i<pengData.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitle:pengData[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromHex(0x9fa0a0) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.tag = 200+i;
        [btn addTarget:self action:@selector(pengClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = UIColorFromHex(0x9fa0a0).CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 5;
        int j = i%2;
        //每行的第几个
        int k = i/2;
        //第几行
        btn.frame = CGRectMake(selecLabel.x +HDAutoWidth(360)*j, selecLabel.y+selecLabel.height+HDAutoHeight(20)+HDAutoHeight(100)*k, HDAutoWidth(320), HDAutoHeight(80));
        [self.view addSubview:btn];
        
        bottomY = selecLabel.y+selecLabel.height+HDAutoHeight(20)+HDAutoHeight(90)*k +HDAutoHeight(80);
    }
}
-(void)pengClick:(UIButton *)btn{
    NSLog(@"%ld", (long)btn.tag);
    if(selcBtn == nil){
        selcBtn = btn;
    }else{
        selcBtn.selected = NO;
        [selcBtn setBackgroundColor:[UIColor whiteColor]];
        selcBtn = btn;
    }
    btn.selected = YES;
    [btn setBackgroundColor:MainColor];
}

-(void)createType{
    
    UILabel *typeLabel = [self mylabel];
    typeLabel.text = @"类型:";
    typeLabel.frame = CGRectMake(HDAutoWidth(30), bottomY+HDAutoHeight(20), HDAutoWidth(280), HDAutoHeight(30));
    [self.view addSubview:typeLabel];
    
    UIButton *btn1 = [[UIButton alloc]init];
    btn1.tag = 300;
    [btn1 setImage:[UIImage imageNamed:@"种植2"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"种植1"] forState:UIControlStateSelected];
    [btn1 addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
    btn1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *btn2 = [[UIButton alloc]init];
    btn2.tag = 301;
    [btn2 setImage:[UIImage imageNamed:@"施肥"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"施肥1"] forState:UIControlStateSelected];
    [btn2 addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
    btn2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *btn3 = [[UIButton alloc]init];
    btn3.tag = 302;
    [btn3 setImage:[UIImage imageNamed:@"植保"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"植保1"] forState:UIControlStateSelected];
    [btn3 addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
    btn3.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *btn4 = [[UIButton alloc]init];
    btn4.tag = 303;
    [btn4 setImage:[UIImage imageNamed:@"采收"] forState:UIControlStateNormal];
    [btn4 setImage:[UIImage imageNamed:@"采收1"] forState:UIControlStateSelected];
    [btn4 addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
    btn4.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    btn1.frame = CGRectMake(HDAutoWidth(30), typeLabel.y+typeLabel.height+HDAutoHeight(20), HDAutoWidth(320), HDAutoHeight(80));
    btn2.frame = CGRectMake(HDAutoWidth(30) +HDAutoWidth(360), typeLabel.y+typeLabel.height+HDAutoHeight(20), HDAutoWidth(320), HDAutoHeight(80));
    btn3.frame = CGRectMake(HDAutoWidth(30),HDAutoHeight(90) + typeLabel.y+typeLabel.height+HDAutoHeight(30), HDAutoWidth(320), HDAutoHeight(80));
    btn4.frame = CGRectMake(HDAutoWidth(30) +HDAutoWidth(360),HDAutoHeight(90) + typeLabel.y+typeLabel.height+HDAutoHeight(30), HDAutoWidth(320), HDAutoHeight(80));
    
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    [self.view addSubview:btn4];
    
    
}

-(void)typeClick:(UIButton *)btn{
    NSLog(@"%ld", (long)btn.tag);
    
    typeIndex = btn.tag - 300 + 1;
    if(typeSelcBtn == nil){
        typeSelcBtn = btn;
    }else{
        typeSelcBtn.selected = NO;
//        [typeSelcBtn setBackgroundColor:[UIColor whiteColor]];
        typeSelcBtn = btn;
    }
    btn.selected = YES;
//    [btn setBackgroundColor:MainColor];
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


@end
