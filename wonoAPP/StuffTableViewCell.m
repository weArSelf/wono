//
//  StuffTableViewCell.m
//  wonoAPP
//
//  Created by IF on 2017/8/3.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "StuffTableViewCell.h"
#import "BBFlashCtntLabel.h"


@interface StuffTableViewCell()

@property(nonatomic,strong) UIView *ConView;

@property(nonatomic,strong) UIButton *deleteBtn;

@property(nonatomic,strong) UIImageView *headImageView;
@property(nonatomic,strong) UILabel *nameLabel;

//@property(nonatomic,strong) UILabel *contentLabel;


@property (nonatomic,strong) UIButton *hubBtn;

@property (nonatomic,strong) BBFlashCtntLabel *conLabel;

@end


@implementation StuffTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectMark = false;
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
    _headImageView = [[UIImageView alloc]init];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.image = [UIImage imageNamed:@"选中-员工"];
    
    [_ConView addSubview:_headImageView];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(40));
        make.centerY.equalTo(_ConView.mas_centerY);
        make.width.equalTo(@(HDAutoWidth(70)));
        make.height.equalTo(@(HDAutoWidth(70)));
    }];
    
    _headImageView.layer.cornerRadius = HDAutoWidth(35);
    _headImageView.layer.masksToBounds = YES;
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.text = @"啊啊";
    _nameLabel.textColor = UIColorFromHex(0x000000);
    _nameLabel.font = [UIFont systemFontOfSize:13];
    
    float nameLength = [self getLengthWithFont:14 AndText:@"啊啊啊啊啊啊啊"];
    
    [_ConView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(HDAutoWidth(20));
        make.centerY.equalTo(_ConView.mas_centerY);
        make.width.equalTo(@(nameLength));
        make.height.equalTo(@(HDAutoHeight(60)));
    }];
    
    [_nameLabel layoutIfNeeded];
    [_ConView layoutIfNeeded];
    [self layoutIfNeeded];
    _conLabel = [[BBFlashCtntLabel alloc]initWithFrame:CGRectMake(_nameLabel.x+_nameLabel.width+HDAutoWidth(40), _nameLabel.y, HDAutoWidth(300), HDAutoHeight(60))];
    if(IS_IPHONE_5){
        _conLabel = [[BBFlashCtntLabel alloc]initWithFrame:CGRectMake(_nameLabel.x+_nameLabel.width+HDAutoWidth(40), _nameLabel.y, HDAutoWidth(280), HDAutoHeight(60))];
    }
    _conLabel.text = @"大棚1·大棚2·大棚3";
    _conLabel.speed = -1;
    _conLabel.textColor = UIColorFromHex(0x9fa0a0);
    _conLabel.font = [UIFont systemFontOfSize:13];
    [_ConView addSubview:_conLabel];
//    [_conLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_nameLabel.mas_right).offset(HDAutoWidth(40));
//        make.centerY.equalTo(_ConView.mas_centerY);
//        make.right.equalTo(_ConView.mas_right).offset(HDAutoWidth(20));
//        make.height.equalTo(@(HDAutoHeight(60)));
//    }];
    
    
    
}


-(void)setSearchModel:(SearchModel *)searchModel{
    _searchModel = searchModel;
    
    NSURL *imageUrl = [NSURL URLWithString:_searchModel.imageUrl];
    
    [_headImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"选中-员工"]];
    _nameLabel.text = _searchModel.name;
    
    _conLabel.text = _searchModel.phoneNum;
    
}

-(void)changeColor{
    _ConView.backgroundColor = [UIColor whiteColor];
    _ConView.layer.shadowColor = [UIColor grayColor].CGColor;
    _ConView.layer.shadowOpacity = 0.3f;
    _ConView.layer.shadowRadius =5;
    _ConView.layer.shadowOffset = CGSizeMake(3,3);
    _ConView.layer.borderColor = [UIColor orangeColor].CGColor;
    _ConView.layer.borderWidth = 0.6;
    //    _ConView.layer.masksToBounds = YES;
    _ConView.layer.cornerRadius = 5;
    
    self.selectMark = true;
}

-(void)changeColorBack{

    _ConView.backgroundColor = [UIColor whiteColor];
    _ConView.layer.shadowColor = [UIColor grayColor].CGColor;
    _ConView.layer.shadowOpacity = 0.3f;
    _ConView.layer.shadowRadius =5;
    _ConView.layer.shadowOffset = CGSizeMake(3,3);
    _ConView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _ConView.layer.borderWidth = 0.6;
    //    _ConView.layer.masksToBounds = YES;
    _ConView.layer.cornerRadius = 5;
    
    self.selectMark = false;
}

-(float)getLengthWithFont:(int)font AndText:(NSString *)text{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:font]};
    CGSize size=[text sizeWithAttributes:attrs];
    return size.width;
}

@end
