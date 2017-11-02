//
//  StuffTableViewCell.m
//  wonoAPP
//
//  Created by IF on 2017/8/3.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "PengTableViewCell.h"
#import "BBFlashCtntLabel.h"


@interface PengTableViewCell()

@property(nonatomic,strong) UIView *ConView;

@property(nonatomic,strong) UIButton *deleteBtn;


@property(nonatomic,strong) BBFlashCtntLabel *nameLabel;

@property(nonatomic,strong) BBFlashCtntLabel *contentLabel;

@property(nonatomic,strong) UILabel *stateLabel;


@property (nonatomic,strong) UIButton *hubBtn;

@end


@implementation PengTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        [self createBtn];
        [self creatConView];
        [self createContent];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createAnimate) name:@"deleteClick" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unCreateAnimate) name:@"deleteUnClick" object:nil];
        
    }
    return self;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setChangeMark:(BOOL)changeMark{
    _changeMark = changeMark;
    if(_changeMark == true){
        _ConView.x = HDAutoWidth(60)+10;
        [self layoutIfNeeded];
    }
}

-(void)creatConView{
    
    _ConView = [[UIView alloc]init];
    _ConView.backgroundColor = [UIColor whiteColor];
    _ConView.layer.shadowColor = [UIColor grayColor].CGColor;
    _ConView.layer.shadowOpacity = 0.3f;
    _ConView.layer.shadowRadius =5;
    _ConView.layer.shadowOffset = CGSizeMake(3,3);
    _ConView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _ConView.layer.borderWidth = 0.6;
    //    _ConView.layer.masksToBounds = YES;
    _ConView.layer.cornerRadius = 5;
    
    _ConView.frame = CGRectMake(10, HDAutoHeight(8), HDAutoWidth(750)-20, HDAutoHeight(114));
    
    [self addSubview:_ConView];
    
    if(_changeMark == true){
        _ConView.x = HDAutoWidth(60)+10;
        [self layoutIfNeeded];
    }
    
    
    //    [_ConView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.mas_top).offset(HDAutoHeight(8));
    //        make.bottom.equalTo(self.mas_bottom).offset(-HDAutoHeight(8));
    //        make.left.equalTo(self.mas_left).offset(10);
    //        make.right.equalTo(self.mas_right).offset(-10);
    //    }];
    
    
}

-(void)createBtn{
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"圆加减"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(HDAutoWidth(25)));
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(HDAutoWidth(40)));
        make.height.equalTo(@(HDAutoWidth(40)));
    }];
    _hubBtn = [[UIButton alloc]init];
    [_hubBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    _hubBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:_hubBtn];
    [_hubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(HDAutoWidth(0)));
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(HDAutoWidth(85)));
        make.height.equalTo(self.mas_height);
    }];
    _hubBtn.enabled = NO;
}

-(void)deleteClick{
    NSLog(@"点击删除");
    self.cellClickBlock(self);
    
}

-(void)createAnimate{
    _hubBtn.enabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        _ConView.x+= HDAutoWidth(60);
    }];
}

-(void)unCreateAnimate{
    _hubBtn.enabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _ConView.x =10;
    }];
}

-(void)createContent{
    
    _nameLabel = [[BBFlashCtntLabel alloc]init];
    
    [_ConView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(35));
        make.centerY.equalTo(_ConView.mas_centerY);
        make.width.equalTo(@(HDAutoWidth(200)));
        make.height.equalTo(@(HDAutoHeight(60)));
    }];
    [self layoutIfNeeded];
    _nameLabel.text = @"大棚1";
    _nameLabel.textColor = UIColorFromHex(0x000000);
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.speed = -1;
    
    _contentLabel = [[BBFlashCtntLabel alloc]init];
    
    [_ConView addSubview:_contentLabel];
    
    
    
    _stateLabel = [[UILabel alloc]init];
    _stateLabel.text = @"正常";
    _stateLabel.textColor = UIColorFromHex(0x000000);
    _stateLabel.font = [UIFont systemFontOfSize:13];
    _stateLabel.textAlignment = NSTextAlignmentRight;
    [_ConView addSubview:_stateLabel];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_ConView.mas_centerY);
        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(35));
        make.height.equalTo(@(HDAutoHeight(60)));
        make.width.equalTo(@(HDAutoWidth(100)));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_ConView.mas_centerY);
        make.right.equalTo(_stateLabel.mas_left).offset(-HDAutoWidth(20));
        make.left.equalTo(_nameLabel.mas_right).offset(HDAutoWidth(30));
        make.height.equalTo(@(HDAutoHeight(60)));
    }];
    [self layoutIfNeeded];
    _contentLabel.text = @"TPG92347842";
    _contentLabel.textColor = UIColorFromHex(0x9fa0a0);
    _contentLabel.font = [UIFont systemFontOfSize:13];
//    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.speed = -1;
    
    
}


-(void)setModel:(PengModel *)model{
    _model = model;
    _nameLabel.text = model.pengName;
    _contentLabel.text = model.contentStr;
    int state = [model.status intValue];
    switch (state) {
        case 1:{
            _stateLabel.text = @"正常";
            _stateLabel.textColor = [UIColor blackColor];
            break;
        }
        case 2:{
            _stateLabel.text = @"异常";
            _stateLabel.textColor = [UIColor orangeColor];
            break;
        }
        case 3:{
            _stateLabel.text = @"报警";
            _stateLabel.textColor = [UIColor redColor];
            break;
        }
            
        default:
            break;
    }
    
}

@end
