//
//  EmployeeViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/2.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "EmployeeViewController.h"
#import "StuffTableViewCell.h"
#import "AddStuffViewController.h"


@interface EmployeeViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIButton *nextBtn;

@property (nonatomic,strong)UITableView *stuffTableView;

@property (nonatomic,strong)UIButton *addBtn;



@end

@implementation EmployeeViewController{
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


-(void)requestStuff{
    
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    
    [[InterfaceSingleton shareInstance].interfaceModel getFarmStuffWithFid:str WithCallBack:^(int state, id data, NSString *msg) {
        if(state == 2000){
            NSArray *arr = data;
            dataArr = [NSMutableArray array];
            
            if(arr.count == 0){
                _nextBtn.enabled = false;
                [_nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }else{
                
                _nextBtn.enabled = true;
                [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }
            
            for (int i=0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                SearchModel *model = [[SearchModel alloc]init];
                model.imageUrl = dic[@"avatar"];
                model.name = dic[@"username"];
                model.phoneNum = dic[@"greenHouse"];
                model.stufID = dic[@"id"];
                
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

-(void)viewDidAppear:(BOOL)animated{
    [_stuffTableView flashScrollIndicators];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestStuff];
//    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"员工列表";
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
    //    _plantTableView.showsVerticalScrollIndicator = NO;
    _stuffTableView.backgroundColor = [UIColor clearColor];
    //    _plantTableView.frame = self.view.frame;
//    _stuffTableView.showsVerticalScrollIndicator = NO;
//    _stuffTableView.scrollEnabled = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    [_stuffTableView addGestureRecognizer:tap];
    
    _stuffTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.01)];
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
    changeMark = false;
    [self changeBtnBack];
}

-(void)flash{

    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [_stuffTableView flashScrollIndicators];
        [self flash];
    });

    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    StuffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
        cell = [[StuffTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    
        
        cell.changeMark = changeMark;
        
               //        [cell setLeftColor:[UIColor blueColor]];
//    }
    
    
    [cell setCellClickBlock:^(StuffTableViewCell *cell){
        //            NSLog(@"%ld", (long)tag);
        
        
        
        
        //            [_stuffTableView reloadData];
        
        NSIndexPath *index = [_stuffTableView indexPathForCell:cell];
        
        SearchModel *nowModel = dataArr[indexPath.row];
        //            count--;
        
        NSString *title = [NSString stringWithFormat:@"是否删除员工%@?\n一旦删除，相关数据则对该员工将会不可见",nowModel.name];
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定");
            
            NSString *fid = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
            [[InterfaceSingleton shareInstance].interfaceModel farmDeleteEmployeeWithFid:fid AndUid:nowModel.stufID WithCallBack:^(int state, id data, NSString *msg) {
                if(state == 2000){
                    
                    [MBProgressHUD showSuccess:@"删除成功"];
                    [dataArr removeObjectAtIndex:indexPath.row];
                    
                    
                    if(dataArr.count == 0){
                        [_stuffTableView reloadData];
                    }else{
                        [_stuffTableView beginUpdates];
                        [_stuffTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [_stuffTableView endUpdates];
                        [_stuffTableView reloadData];
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
        
        
        
//        UIAlertController *alertC2 = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
//
//        [alertC2 addAction:cancel];
//        [alertC2 addAction:confirm];
//        [self presentViewController:alertC2 animated:YES completion:nil];
        
        
        
        
    }];

    
    cell.tag = 300 +indexPath.row;
    SearchModel *model = dataArr[indexPath.row];
    cell.searchModel = model;
    //    [cell creatConView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HDAutoHeight(130);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteUnClick" object:nil];
    _nextBtn.selected = NO;
    changeMark = false;
    [self changeBtnBack];
}

-(void)createAddBtn{
    
    _addBtn = [[UIButton alloc]init];
    [_addBtn setImage:[UIImage imageNamed:@"添加新员工"] forState:UIControlStateNormal];
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
    AddStuffViewController *addStuff = [[AddStuffViewController alloc]init];
    [self.navigationController pushViewController:addStuff animated:YES];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    
    return  NO;
}

@end
