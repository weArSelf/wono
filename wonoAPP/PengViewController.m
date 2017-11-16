//
//  EmployeeViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/2.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "PengViewController.h"

#import "PengTableViewCell.h"

#import "PengAddViewController.h"

#import "PengUpdateViewController.h"



@interface PengViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIButton *nextBtn;

@property (nonatomic,strong)UITableView *stuffTableView;

@property (nonatomic,strong)UIButton *addBtn;



@end

@implementation PengViewController{
    int count;
    BOOL changeMark;
    NSMutableArray *dataArr;
    BOOL animateMark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    animateMark = true;
    dataArr = [NSMutableArray array];
    
    count = 5;
    changeMark = false;
    // Do any additional setup after loading the view.
    [self creatTitleAndBackBtn];
    [self createNextBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTable];
    [self createAddBtn];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_stuffTableView reloadData];
    [self requestData];
//    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteUnClick" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [_stuffTableView flashScrollIndicators];
}

-(void)requestData{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    [[InterfaceSingleton shareInstance].interfaceModel getPengWithFid:str AndCallBack:^(int state, id data, NSString *msg) {
        if (state == 2000) {
            NSLog(@"请求数据成功");
            NSArray *arr = data;
            
            if(arr.count == 0){
                _nextBtn.enabled = false;
                [_nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }else{
                
                _nextBtn.enabled = true;
                [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }
            
            dataArr = [NSMutableArray array];
            for (int i=0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                PengModel *model = [[PengModel alloc]init];
                model.pengName = dic[@"name"];
                model.contentStr = dic[@"imei"];
                model.status = dic[@"status"];
                model.pengId = dic[@"id"];
                [dataArr addObject:model];
            }
            
            [_stuffTableView reloadData];
            if(animateMark == true){
                animateMark = false;
                _stuffTableView.alpha = 0;
                [UIView animateWithDuration:0.5 animations:^{
                    _stuffTableView.alpha = 1;
                }];
            }
            
        }else{
            _nextBtn.enabled = false;
            [_nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
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
    _titleLabel.text = @"大棚列表";
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
    [_nextBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_nextBtn setTitle:@"取消编辑" forState:UIControlStateSelected];
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
    
    UIButton *hubBtn = [[UIButton alloc]init];
    hubBtn.backgroundColor = [UIColor clearColor];
    [hubBtn addTarget:self action:@selector(SaveClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:hubBtn];
    
    [hubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.right.equalTo(_headView.mas_right);
        make.height.equalTo(_headView.mas_height);
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
}

-(void)SaveClick{
    NSLog(@"点击编辑");
    if(_nextBtn.enabled == NO){
        return;
    }
    if(_nextBtn.selected == NO){
        changeMark = true;
        _nextBtn.selected = YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteClick" object:nil];
        [self changeBtn];
    }else{
        _nextBtn.selected = NO;
        changeMark = false;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteUnClick" object:nil];
        [self changeBtnBack];
    }
    
}

-(void)changeBtn{
    [_addBtn layoutIfNeeded];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        _addBtn.transform = CGAffineTransformMakeTranslation(0, 200);
    }];
    
}
-(void)changeBtnBack{
    [UIView animateWithDuration:0.5 animations:^{
        _addBtn.transform = CGAffineTransformIdentity;
    }];
}

-(void)createTable{
    
    _stuffTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    //    [_plantTableView registerClass:[PlantCell class] forHeaderFooterViewReuseIdentifier:@"plantCell"];
    _stuffTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _stuffTableView.dataSource = self;
    _stuffTableView.delegate = self;
    _stuffTableView.scrollsToTop = NO;
    //    _plantTableView.showsVerticalScrollIndicator = NO;
    _stuffTableView.backgroundColor = [UIColor clearColor];
    //    _plantTableView.frame = self.view.frame;
    //    _stuffTableView.showsVerticalScrollIndicator = NO;
    //    _stuffTableView.scrollEnabled = NO;
//    if (@available(iOS 11.0, *)) {
//        _stuffTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
////        _stuffTableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
////        _stuffTableView.scrollIndicatorInsets = _stuffTableView.contentInset;
//    }
    _stuffTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.01)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    [_stuffTableView addGestureRecognizer:tap];
    
    
    [self.view addSubview:_stuffTableView];
    
    [_stuffTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.headView.mas_bottom).offset(5);
        make.bottom.equalTo(self.view.mas_bottom).offset(-HDAutoHeight(200));
    }];
    
    
    
    
    
    
}

-(void)tapClick{
    NSLog(@"点击了");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteUnClick" object:nil];
    _nextBtn.selected = NO;
    
    [self changeBtnBack];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArr.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PengModel *model = dataArr[indexPath.row];
    _nextBtn.selected = NO;
    changeMark = false;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteUnClick" object:nil];
    [self changeBtnBack];
    PengUpdateViewController *pengUpdateVc = [[PengUpdateViewController alloc]init];
    pengUpdateVc.pengID = model.pengId;
    [self.navigationController pushViewController:pengUpdateVc animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    PengTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
        cell = [[PengTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.changeMark = changeMark;
        
        
        
//        cell.changeMark = changeMark;
        
        [cell setCellClickBlock:^(PengTableViewCell *cell){
            NSIndexPath *index = [_stuffTableView indexPathForCell:cell];
            
            PengModel *nowModel = dataArr[indexPath.row];
            //            count--;
            
            NSString *title = [NSString stringWithFormat:@"是否删除大棚%@?\n将清除此大棚相关一切数据",nowModel.pengName];
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"确定");
                
                NSString *fid = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
                [[InterfaceSingleton shareInstance].interfaceModel DeletePengWithFid:fid AndGid:nowModel.pengId WithCallBack:^(int state, id data, NSString *msg) {
                    if(state == 2000){
                        
                        [MBProgressHUD showSuccess:@"删除成功"];
                        [dataArr removeObjectAtIndex:indexPath.row];
                        
                        
                        if(dataArr.count == 0){
                            [_stuffTableView reloadData];
                        }else{
                            [_stuffTableView beginUpdates];
                            [_stuffTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
                            [_stuffTableView endUpdates];
                        }
                        
                    }
                    if(state<2000){
                        [MBProgressHUD showSuccess:msg];
                    }
                }];
                
                
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }];
            [alertC addAction:cancel];
            [alertC addAction:confirm];
            [self presentViewController:alertC animated:YES completion:nil];
            
            
        }];
        //        [cell setLeftColor:[UIColor blueColor]];
//    }
    cell.tag = 300 +indexPath.row;
    //    [cell creatConView];
    
    PengModel *model = dataArr[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HDAutoHeight(130);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    if(_nextBtn.selected == NO){
//        changeMark = true;
//        _nextBtn.selected = YES;
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteClick" object:nil];
//        [self changeBtn];
//    }else{
        _nextBtn.selected = NO;
        changeMark = false;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteUnClick" object:nil];
        [self changeBtnBack];
//    }
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteUnClick" object:nil];
//    _nextBtn.selected = NO;
//    [self changeBtnBack];
    
}

-(void)createAddBtn{
    
    _addBtn = [[UIButton alloc]init];
    [_addBtn setImage:[UIImage imageNamed:@"添加新大棚"] forState:UIControlStateNormal];
    _addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_addBtn];
    
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(HDAutoWidth(520)));
        make.height.equalTo(@(HDAutoHeight(128)));
        make.bottom.equalTo(self.view.mas_bottom).offset(-HDAutoHeight(30));
        
    }];
    
}

-(void)addBtnClick{
    NSLog(@"点击添加新员工");
    PengAddViewController *pengAdd = [[PengAddViewController alloc]init];
    [self.navigationController pushViewController:pengAdd animated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    
    return  NO;
}

@end
