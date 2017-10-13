//
//  MineViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/11.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "MineViewController.h"
#import "AboutViewController.h"
#import "ChangeNameViewController.h"
#import "ChangePswViewController.h"
#import "CallBackViewController.h"
#import "EmployeeViewController.h"
#import "MineSettingViewController.h"
#import "MineDataViewController.h"
#import "PengViewController.h"
#import "MyFarmViewController.h"
#import "MyCollectionViewController.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *headView2;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIButton *headImgBtn;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UITableView *contentTableView;

@end

@implementation MineViewController{
    NSArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    dataArr = [NSArray arrayWithObjects:@"我的收藏",@"修改密码",@"意见反馈",@"关于沃农",@"注销账号", nil];
    
    
    
    
    
    
    
    // Do any additional setup after loading the view.
//    [self CreateTitleLabelWithText:@"我的"];
    [self creatTitleAndBackBtn];
    [self createHead];
    [self createTable];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"AleKey"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
    
    
    int userType = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userType"]intValue];
    int nongChangHave = [[[NSUserDefaults standardUserDefaults]objectForKey:@"fid"]intValue];
    NSString *pengHave = [[NSUserDefaults standardUserDefaults]objectForKey:@"pengID"];
    
    
    if(userType == 1){
        dataArr = [NSArray arrayWithObjects:@"我的收藏",@"管理员工",@"管理大棚",@"我的农场",@"设置",nil];
    }else{
        if(nongChangHave == 0){
            
            dataArr = [NSArray arrayWithObjects:@"我的收藏",@"设置",nil];
            
//            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"AleKey"];
            NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"AleKey"];
            if([str isEqualToString:@"1"]){
                
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"AleKey"];
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有进入农场,请联系相关农场主" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertC addAction:confirmAct];
                [self presentViewController:alertC animated:YES completion:nil];
            }
        }else{
            
            dataArr = [NSArray arrayWithObjects:@"我的收藏",@"我的农场",@"设置",nil];
            
        }
        
        
    }
    

    
    
    
//    dataArr = [NSArray arrayWithObjects:@"我的收藏",@"管理员工",@"管理大棚",@"我的农场",@"设置",nil];

    [_contentTableView reloadData];
//    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)requestData{
    
    [[InterfaceSingleton shareInstance].interfaceModel getUserInfoWithCallBack:^(int state, id data, NSString *msg) {
      
        if(state == 2000){
            
            NSLog(@"成功");
            
            NSDictionary *dic = data;
            NSString *imageUrl = dic[@"avatar"];
            
            NSString *name = dic[@"username"];
            
            _nameLabel.text = name;
            
            NSURL *ur = [NSURL URLWithString:imageUrl];
            
            [self.headImgBtn sd_setImageWithURL:ur forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"]];
            
//            [_headImgBtn setImage:[UIImage imageNamed:@"默认头像"] forState:UIControlStateNormal];
            
            
        
        }else{
            [MBProgressHUD showSuccess:msg];
        }
        
    }];

}


-(void)createHead{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = [UIColor whiteColor];
    _headView.layer.shadowColor = [UIColor grayColor].CGColor;
    _headView.layer.shadowOpacity = 0.3f;
//    _headView.layer.shadowRadius =5;
    _headView.layer.shadowOffset = CGSizeMake(2,2);
    [self.view addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(64);
        make.height.equalTo(@(HDAutoHeight(230)));
    }];
    
    _headImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _headImgBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    _headImgBtn.image = [UIImage imageNamed:@"选中-农场主"];
    [_headImgBtn setImage:[UIImage imageNamed:@"默认头像"] forState:UIControlStateNormal];
    [_headImgBtn addTarget:self action:@selector(selImg) forControlEvents:UIControlEventTouchUpInside];
    _headImgBtn.layer.cornerRadius = HDAutoHeight(70);
    _headImgBtn.layer.masksToBounds = YES;
    _headImgBtn.imageView.contentMode = UIViewContentModeScaleToFill;
    [_headView addSubview:_headImgBtn];
    [_headImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headView.mas_centerX);
        make.top.equalTo(@(HDAutoHeight(30)));
        make.width.equalTo(@(HDAutoHeight(140)));
        make.height.equalTo(@(HDAutoHeight(140)));
    }];
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.text = @"";
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = [UIColor grayColor];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_headView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headView.mas_centerX);
        make.width.equalTo(@(100));
        make.height.equalTo(@(HDAutoHeight(40)));
        make.bottom.equalTo(_headView.mas_bottom).offset(-HDAutoHeight(5));
    }];
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
    _contentTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.01)];
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
    int userType = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userType"]intValue];
    if(userType == 1){
    
    
    switch (indexPath.row) {
        case 0:{
            
            
            
            MyCollectionViewController *myVc = [[MyCollectionViewController alloc]init];
            myVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myVc animated:YES];
            break;
        }
        case 1:{
            
            
            EmployeeViewController *empVc = [[EmployeeViewController alloc]init];
            empVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:empVc animated:YES];
            
            break;
        }
        case 2:{
            PengViewController *pengVc = [[PengViewController alloc]init];
            pengVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pengVc animated:YES];
//            CallBackViewController *CallVc = [[CallBackViewController alloc]init];
//            [self.navigationController pushViewController:CallVc animated:YES];
            break;
        }
        case 3:{
            MyFarmViewController *MyVc = [[MyFarmViewController alloc]init];
            MyVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:MyVc animated:YES];
            //            CallBackViewController *CallVc = [[CallBackViewController alloc]init];
            //            [self.navigationController pushViewController:CallVc animated:YES];
            break;
        }
        case 4:{
//            AboutViewController *about = [[AboutViewController alloc]init];
//            [self.navigationController pushViewController:about animated:YES];
            MineSettingViewController *setVc = [[MineSettingViewController alloc]init];
            setVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setVc animated:YES];
        }
            break;
            
        default:
            break;
    }
        
    }else{
        
        int nongChangHave = [[[NSUserDefaults standardUserDefaults]objectForKey:@"fid"]intValue];
        if(nongChangHave == 0){
            
            switch (indexPath.row) {
                case 0:{
                    MyCollectionViewController *myVc = [[MyCollectionViewController alloc]init];
                    myVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myVc animated:YES];

                    break;
                }
                case 1:{
                    MineSettingViewController *setVc = [[MineSettingViewController alloc]init];
                    setVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:setVc animated:YES];

                    break;
                }

                    
                default:
                    break;
            }
            
        }else{
        
            switch (indexPath.row) {
                case 0:{
                    MyCollectionViewController *myVc = [[MyCollectionViewController alloc]init];
                    myVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myVc animated:YES];
                    
                    break;
                }
                case 1:{
                    
                    MyFarmViewController *MyVc = [[MyFarmViewController alloc]init];
                    MyVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:MyVc animated:YES];
                    
                    break;
                }
                case 2:{
                    MineSettingViewController *setVc = [[MineSettingViewController alloc]init];
                    setVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:setVc animated:YES];
                    
                    break;
                }

                    
                    
                default:
                    break;
            }

            
        }
        
    }
    
    
    NSLog(@"%ld",(long)indexPath.row);
}
-(void)selImg{
    NSLog(@"选择图片");
//    EmployeeViewController *empVC = [[EmployeeViewController alloc]init];
//    [self.navigationController pushViewController:empVC animated:YES];
    
//    ChangeNameViewController *nameVC = [[ChangeNameViewController alloc]init];
//    [self.navigationController pushViewController:nameVC animated:YES];
    
    MineDataViewController *mineDataVC = [[MineDataViewController alloc]init];
    mineDataVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mineDataVC animated:YES];
}


-(void)creatTitleAndBackBtn{
    
    _headView2 = [[UIView alloc]init];
    _headView2.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView2.alpha = 0.8;
    [self.view addSubview:_headView2];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"我的";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_headView2 addSubview:_titleLabel];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"0-返回"] forState:UIControlStateNormal];
    //    [_backBtn addTarget:self action:@selector(BackClick) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    //    _backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [_headView2 addSubview:_backBtn];
    
    _backBtn.hidden = YES;
    
    [_headView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(64));
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView2.mas_left).offset(15);
        make.top.equalTo(_headView2.mas_top).offset(24);
        make.width.equalTo(@(26));
        make.height.equalTo(@(26));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headView2.mas_centerX);
        make.centerY.equalTo(_backBtn.mas_centerY);
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];
    
   
}
@end
