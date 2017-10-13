//
//  MessageViewController.m
//  wonoAPP
//
//  Created by IF on 2017/9/6.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageModel.h"
#import "BBFlashCtntLabel.h"
#import "WonoCircleDetailViewController.h"
#import "PPBadgeView.h"
#import "WonoWebMessageViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UIButton *nextBtn;

@property (nonatomic,strong)UITableView *mainTableView;

@end

@implementation MessageViewController{
    NSMutableArray *dataArr;
    int page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    // Do any additional setup after loading the view.
    dataArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    [self createTabel];
    [self makePlaceHolderWithTitle:@"加载数据中"];
    dataArr = [NSMutableArray array];
    [self requestData];
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
}

-(void)refresh{
    page = 1;
    dataArr = [NSMutableArray array];
    [self requestData];
}
-(void)loadMore{
    page++;
    [self requestData];
}

-(void)requestData{
    

//    MessageModel *model = [[MessageModel alloc]init];
//    model.type = 1;
//    model.content = @"消息内容消息内容消息内容消息内容";
//    model.needID = @"233";
//    
//    [dataArr addObject:model];
//    [dataArr addObject:model];
//    [dataArr addObject:model];
//    [dataArr addObject:model];
//    [dataArr addObject:model];
//    [dataArr addObject:model];
//    [dataArr addObject:model];
//    [dataArr addObject:model];
//    [_mainTableView reloadData];
    
    
    [[InterfaceSingleton shareInstance].interfaceModel getMyMessageWithPage:page WithCallBack:^(int state, id data, NSString *msg) {
       
        if(state == 2000){
            
            [_mainTableView.mj_header endRefreshing];
            [_mainTableView.mj_footer endRefreshing];
            NSLog(@"成功");
            NSArray *arr = data[@"data"];
            
            if(arr.count == 0){
                if(page!=1){
                    page--;
                    [_mainTableView.mj_footer endRefreshingWithNoMoreData];
                    return;
                }
            }
            
            for (int i=0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                MessageModel *model = [[MessageModel alloc]init];
                model.type = [dic[@"type"]intValue];
                model.content = dic[@"title"];
                model.needID = dic[@"param1"];
                model.statu = dic[@"status"];
                model.msgID = dic[@"id"];
                [dataArr addObject:model];
            }
            if(dataArr.count<15){
                _mainTableView.mj_footer.hidden = YES;
            }
            
            [_mainTableView reloadData];
        }else{
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self makePlaceHolderWithTitle:@"暂无数据"];
            });
        }
        
    }];
    
    
}

-(void)changeStateWithMsgID:(NSString *)needID{
    
    [[InterfaceSingleton shareInstance].interfaceModel changeMsgStateWithMessageID:needID AndStatus:@"1" WithCallBack:^(int state, id data, NSString *msg) {
       
        if(state == 2000){
//            [self refresh];
        }
        
    }];
    
}

-(void)makePlaceHolderWithTitle:(NSString *)title{
    
    [self.view layoutIfNeeded];
    [_mainTableView layoutIfNeeded];
    [_mainTableView jr_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
        //        [_plantTableView setScrollEnabled:NO];
        UIView *view = [[UIView alloc]initWithFrame:_mainTableView.bounds];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = title;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = MainColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(APP_CONTENT_WIDTH/2-150, HDAutoHeight(390), 300, HDAutoHeight(60));
        [view addSubview:label];
        
        
        return view;
    } normalBlock:^(UITableView * _Nonnull sender) {
        [_mainTableView setScrollEnabled:YES];
    }];
    [_mainTableView reloadData];
    
    
}


-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"消息";
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

-(void)createTabel{
    
    _mainTableView = [[UITableView alloc]init];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = [UIColor whiteColor];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    
    [self.view addSubview:_mainTableView];
    
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_headView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArr.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identy = @"cellIdenty";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
//    if(cell == nil){
    
        cell = [[UITableViewCell alloc]init];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    UIView *conView = [[UIView alloc]init];
    conView.backgroundColor = [UIColor whiteColor];
    conView.layer.masksToBounds  = YES;
    conView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    conView.layer.borderWidth = 0.3;
    [cell addSubview:conView];
    [conView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(-1);
        make.right.equalTo(cell.mas_right).offset(1);
        make.top.equalTo(cell.mas_top);
        make.bottom.equalTo(cell.mas_bottom);
    }];
    
    
    
    MessageModel *model = dataArr[indexPath.row];
    
    float width = [self getLengthWithFont:14 AndText:model.content];
    
    if(width>=SCREEN_WIDTH-HDAutoWidth(90)){
        width = SCREEN_WIDTH-HDAutoWidth(90);
    }
    
    if(model.type == 10){
        
        UIImageView *officialImageView = [[UIImageView alloc]init];
        officialImageView.image = [UIImage imageNamed:@"官方消息"];
        officialImageView.contentMode = UIViewContentModeScaleAspectFill;
        officialImageView.frame = CGRectMake(HDAutoWidth(41), HDAutoHeight(34), HDAutoWidth(94), HDAutoHeight(32));
        [conView addSubview:officialImageView];
        
        
        
        BBFlashCtntLabel *label = [[BBFlashCtntLabel alloc]initWithFrame:CGRectMake(HDAutoWidth(150), HDAutoHeight(10), width, HDAutoHeight(80))];
        label.text = model.content;
        label.speed = -1;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor grayColor];
        [conView addSubview:label];

        int val = [model.statu intValue];
        
        if(val == 0){
            [label pp_addDotWithColor:nil];
            [label pp_moveBadgeWithX:-HDAutoWidth(14) Y:HDAutoHeight(20)];
            [label pp_setBadgeHeightPoints:HDAutoWidth(10)];
        }
    }else{
        
        BBFlashCtntLabel *label = [[BBFlashCtntLabel alloc]initWithFrame:CGRectMake(HDAutoWidth(41), HDAutoHeight(10), width, HDAutoHeight(80))];
        label.text = model.content;
        label.speed = -1;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor grayColor];
        [conView addSubview:label];
        
        int val = [model.statu intValue];
        
        if(val == 0){
            [label pp_addDotWithColor:nil];
            [label pp_moveBadgeWithX:-HDAutoWidth(14) Y:HDAutoHeight(20)];
            [label pp_setBadgeHeightPoints:HDAutoWidth(10)];
        }
    }
    
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(conView.mas_left).offset(HDAutoWidth(40));
//        make.top.equalTo(conView.mas_top);
//        make.bottom.equalTo(conView.mas_bottom);
//        make.right.equalTo(conView.mas_right).offset(-HDAutoWidth(150));
//    }];
    
    return cell;
    
}

-(float)getLengthWithFont:(int)font AndText:(NSString *)text{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:font]};
    CGSize size=[text sizeWithAttributes:attrs];
    return size.width;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HDAutoHeight(100);

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了");
    
    
    
    WonoCircleDetailViewController *wonoDetailVc = [[WonoCircleDetailViewController alloc]init];
    MessageModel *model = dataArr[indexPath.row];
    
    if(model.type == 10){
        
        WonoWebMessageViewController *webVC = [[WonoWebMessageViewController alloc]init];
        webVC.needID = model.needID;
        //一会测试一下 这样的时候viewdidload里边 needid到底有没有值 很期待~
        [self.navigationController pushViewController:webVC animated:YES];
        if([model.statu intValue]==0){
            model.statu = @"1";
            dataArr[indexPath.row] = model;
            NSArray *arr = [NSArray arrayWithObjects:indexPath, nil];
            [tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationRight];
            [self changeStateWithMsgID:model.msgID];
            
        }
        
    }else if(model.type == 1){
    
        wonoDetailVc.qid = model.needID;
        wonoDetailVc.Cmark = @"1";
        [self.navigationController pushViewController:wonoDetailVc animated:YES];
        
        if([model.statu intValue]==0){
            model.statu = @"1";
            dataArr[indexPath.row] = model;
            NSArray *arr = [NSArray arrayWithObjects:indexPath, nil];
            [tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationRight];
            [self changeStateWithMsgID:model.msgID];
            
        }
    }else if(model.type == 2){
        
//        wonoDetailVc.qid = model.needID;
//        wonoDetailVc.Cmark = @"1";
//        [self.navigationController pushViewController:wonoDetailVc animated:YES];
        
        if([model.statu intValue]==0){
            model.statu = @"1";
            dataArr[indexPath.row] = model;
            NSArray *arr = [NSArray arrayWithObjects:indexPath, nil];
            [tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationRight];
            
            
            [self changeStateWithMsgID:model.msgID];
            
        }
    }
    
    
}
@end
