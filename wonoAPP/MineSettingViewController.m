//
//  MineSettingViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/2.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "MineSettingViewController.h"

#import "AboutViewController.h"
#import "CallBackViewController.h"
#import "ChangePswViewController.h"
#import "LoginViewController.h"

@interface MineSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIButton *nextBtn;

@property (nonatomic,strong) UITableView *contentTableView;

@end

@implementation MineSettingViewController{
    NSArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatTitleAndBackBtn];
    
    self.view.backgroundColor = [UIColor whiteColor];
    dataArr = [NSArray arrayWithObjects:@"关于沃农",@"意见反馈",@"修改密码",@"注销账号",nil];
    [self createTable];
    
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
    _titleLabel.text = @"设置";
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






-(void)createTable{
    
    _contentTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    //    [_plantTableView registerClass:[PlantCell class] forHeaderFooterViewReuseIdentifier:@"plantCell"];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.dataSource = self;
    _contentTableView.delegate = self;
    //    _plantTableView.showsVerticalScrollIndicator = NO;
    _contentTableView.backgroundColor = [UIColor clearColor];
    //    _plantTableView.frame = self.view.frame;
    _contentTableView.showsVerticalScrollIndicator = NO;
    _contentTableView.scrollEnabled = NO;
    [self.view addSubview:_contentTableView];
    
    [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.headView.mas_bottom).offset(5);
        make.bottom.equalTo(self.view.mas_bottom).offset(-HDAutoHeight(200));
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArr.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.backgroundColor = UIColorFromHex(0xf8f8f8);
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = dataArr[indexPath.row];
    titleLabel.textColor = UIColorFromHex(0x9fa0a0);
    titleLabel.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.height.equalTo(@(HDAutoHeight(60)));
        make.left.equalTo(@(HDAutoWidth(32)));
        make.width.equalTo(@(120));
    }];
    UIView *botView = [[UIView alloc]init];
    botView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:botView];
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left);
        make.right.equalTo(cell.contentView.mas_right);
        make.height.equalTo(@(1));
        make.bottom.equalTo(cell.contentView.mas_bottom);
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = [UIImage imageNamed:@"我的-进入"];
    [cell.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.right.equalTo(cell.contentView.mas_right).offset(-HDAutoWidth(32));
        make.width.equalTo(@(HDAutoWidth(60)));
        make.height.equalTo(@(HDAutoWidth(60)));
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HDAutoHeight(80)+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            AboutViewController *about = [[AboutViewController alloc]init];
            [self.navigationController pushViewController:about animated:YES];
            
            break;
        }
        case 1:{
            CallBackViewController *CallVc = [[CallBackViewController alloc]init];
            [self.navigationController pushViewController:CallVc animated:YES];
            break;
        }
        case 2:{
            ChangePswViewController *ChangeVc = [[ChangePswViewController alloc]init];
            [self.navigationController pushViewController:ChangeVc animated:YES];
            break;
        }
        case 3:{
//             [[NSUserDefaults standardUserDefaults]objectForKey:@"loginMark"];
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认注销" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"loginMark"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 LoginViewController *login = [[LoginViewController alloc]init];
                 UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
                 nav.navigationBarHidden = YES;
                 
                 appDelegate.window.rootViewController = nav;

             }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击取消");
            }];
            
            [alertC addAction:cancelAction];
            [alertC addAction:confirmAction];
            [self presentViewController:alertC animated:YES completion:nil];
            
            
            break;
        }
            
        default:
            break;
    }
    
    
    NSLog(@"%ld",(long)indexPath.row);
}


@end
