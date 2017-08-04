//
//  EmployeeViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/2.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "PengViewController.h"
#import "StuffTableViewCell.h"

@interface PengViewController ()<UITableViewDelegate,UITableViewDataSource>

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
}

-(void)SaveClick{
    NSLog(@"点击编辑");
    
    if(_nextBtn.selected == NO){
        changeMark = true;
        _nextBtn.selected = YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteClick" object:nil];
    }else{
        _nextBtn.selected = NO;
        changeMark = false;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteUnClick" object:nil];
    }
    
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
    [_stuffTableView flashScrollIndicators];
    [self.view addSubview:_stuffTableView];
    
    [_stuffTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.headView.mas_bottom).offset(5);
        make.height.equalTo(@(HDAutoHeight(520)));
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    StuffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[StuffTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.changeMark = changeMark;
        
        
        
        cell.changeMark = changeMark;
        
        [cell setCellClickBlock:^(StuffTableViewCell *cell){
            //            NSLog(@"%ld", (long)tag);
            
            
            
            
            //            [_stuffTableView reloadData];
            
            NSIndexPath *index = [_stuffTableView indexPathForCell:cell];
            
            count--;
            
            if(count == 0){
                [_stuffTableView reloadData];
            }else{
                [_stuffTableView beginUpdates];
                [_stuffTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
                [_stuffTableView endUpdates];
            }
            
            
            
        }];
        //        [cell setLeftColor:[UIColor blueColor]];
    }
    cell.tag = 300 +indexPath.row;
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
        make.top.equalTo(_stuffTableView.mas_bottom).offset(HDAutoHeight(100));
        
    }];
    
}

-(void)addBtnClick{
    NSLog(@"点击添加新员工");
}


@end
