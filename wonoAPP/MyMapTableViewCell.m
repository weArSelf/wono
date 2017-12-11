//
//  MyMapTableViewCell.m
//  wonoAPP
//
//  Created by IF on 2017/12/8.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "MyMapTableViewCell.h"
#import "UITextView+Placeholder.h"



@interface MyMapTableViewCell()<UITextViewDelegate>

@property (nonatomic,strong) UILabel *latitudeLabel;//维度
@property (nonatomic,strong) UILabel *longitudeLabel;//经度

@property (nonatomic,strong) UILabel *nowPosiLabel;


@property (nonatomic,strong) UIButton *confirmBtn;

@property (nonatomic,strong) UIView *botView;

@end



@implementation MyMapTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRes:(BMKReverseGeoCodeResult *)res{
    
    _res = res;
    CLLocationCoordinate2D loc = res.location;
    
    NSString *latiStr = [NSString stringWithFormat:@"当前维度:%f    当前经度:%f",loc.latitude,loc.longitude];
    
    self.latitudeLabel.frame = CGRectMake(15, HDAutoHeight(10), SCREEN_WIDTH-30, 0);
    self.latitudeLabel.text = latiStr;
    self.latitudeLabel.textAlignment = NSTextAlignmentCenter;
    self.latitudeLabel.numberOfLines = 0;
    [self.latitudeLabel sizeToFit];
    [self.contentView addSubview:self.latitudeLabel];
    
    BMKAddressComponent *detail = res.addressDetail;
    NSString *locaDetail = [NSString stringWithFormat:@"地址所属：\n国家：%@     省份：%@ \n城市：%@     区县：%@",detail.country,detail.province,detail.city,detail.district];
    self.longitudeLabel.text = locaDetail;
    self.longitudeLabel.numberOfLines = 0;
    self.longitudeLabel.frame = CGRectMake(15, self.latitudeLabel.bottom +HDAutoHeight(15), SCREEN_WIDTH-30, 0);
    [self.longitudeLabel sizeToFit];
    [self.contentView addSubview:self.longitudeLabel];
    
    self.nowPosiLabel.text = @"农场地址:(可编辑)";
    self.nowPosiLabel.numberOfLines = 0;
    float wid = [self getLengthWithFont:15 AndText:@"农场地址:(可编辑)"];
//    float wid2 = [self getLengthWithFont:15 AndText:@"农场地址:"];
    self.nowPosiLabel.frame = CGRectMake(15, self.longitudeLabel.bottom +HDAutoHeight(15), wid, 0);
    [self.nowPosiLabel sizeToFit];
    [self.contentView addSubview:self.nowPosiLabel];
    
    NSString *add = res.address;
    self.posiTextView.text = add;
    self.posiTextView.font = [UIFont systemFontOfSize:14];
    self.posiTextView.textColor = MainColor;
    self.posiTextView.placeholder = @"请定义农场地址";
    self.posiTextView.frame = CGRectMake(10, _nowPosiLabel.bottom, SCREEN_WIDTH-30, HDAutoHeight(70));
//    UIReturnKeyType
    self.posiTextView.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:self.posiTextView];
    
    if(_botView == nil){
        _botView = [[UIView alloc]init];
        _botView.backgroundColor = [UIColor grayColor];
    }
    [self.contentView addSubview:_botView];
    _botView.frame = CGRectMake(0, self.posiTextView.bottom+HDAutoHeight(10), SCREEN_WIDTH, 1);
    _botView.alpha = 0.3;
    
}

-(float)needReturnHeight{
    return self.posiTextView.bottom+HDAutoHeight(15);
}

-(float)getLengthWithFont:(int)font AndText:(NSString *)text{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:font]};
    CGSize size=[text sizeWithAttributes:attrs];
    return size.width;
}

-(UILabel *)latitudeLabel{
    
    if(_latitudeLabel == nil){
        
        _latitudeLabel = [[UILabel alloc]init];
        _latitudeLabel.textColor = [UIColor lightGrayColor];
        _latitudeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _latitudeLabel;
}

-(UILabel *)longitudeLabel{
    if(_longitudeLabel == nil){
        _longitudeLabel = [[UILabel alloc]init];
        _longitudeLabel.textColor = [UIColor lightGrayColor];
        _longitudeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _longitudeLabel;
}

-(UILabel *)nowPosiLabel{
    
    if(_nowPosiLabel == nil){
        _nowPosiLabel = [[UILabel alloc]init];
        _nowPosiLabel.textColor = [UIColor grayColor];
        _nowPosiLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nowPosiLabel;
}

-(UITextView *)posiTextView{
    
    if(_posiTextView == nil){
        _posiTextView = [[UITextView alloc]init];
        _posiTextView.delegate = self;
    }
    return _posiTextView;
}

-(UIButton *)confirmBtn{
    if(_confirmBtn == nil){
        _confirmBtn = [[UIButton alloc]init];
        [_confirmBtn setTitle:@"使用此位置" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmBtn setTitleColor:MainColor forState:UIControlStateNormal];
        
    }
    return _confirmBtn;
}

-(void)confirmClick{
    
    NSLog(@"点击了");
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *res = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    
    if(_addressBlock){
        _addressBlock(res);
    }
    
    return YES;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.posiTextView resignFirstResponder];
    
}

@end
