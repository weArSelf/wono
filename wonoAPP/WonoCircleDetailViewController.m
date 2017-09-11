//
//  WonoCircleDetailViewController.m
//  wonoAPP
//
//  Created by IF on 2017/9/1.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "WonoCircleDetailViewController.h"
#import "WonoAskTableViewCell.h"
#import "WonoAnswerTableViewCell.h"
#import "CMInputView.h"
#import "ToAnswerViewController.h"


#define HEIGHT [ [ UIScreen mainScreen ] bounds ].size.height


@interface WonoCircleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UIButton *nextBtn;



@property (nonatomic,strong) UITableView *mainTabelView;

@property(nonatomic,strong)WonoAskModel *askModel;


@property (nonatomic,strong) UIView *botView;
@property (nonatomic,strong) CMInputView *botTextView;

@end

@implementation WonoCircleDetailViewController{
    NSMutableArray *answerArr;
    int page;
    int mark;
    
    NSString *replyID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    replyID = @"";
    mark = 0;
    page = 1;
    // Do any additional setup after loading the view.
    answerArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    [self createNextBtn];
    
    [self createTabel];
    
//    [self requestData];
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self createBottom];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideKey) name:@"hidKey" object:nil];
    

    _mainTabelView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _mainTabelView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMore)];
    _mainTabelView.mj_footer.hidden = YES;
    
    [self makePlaceHolderWithTitle:@"加载数据中..."];
    [self requsetDetail];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"wonoCircleRe" object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setQid:(NSString *)qid{
    _qid = qid;
    
}

-(void)requsetDetail{
    [[InterfaceSingleton shareInstance].interfaceModel getAskDetailWithID:_qid WithCallBack:^(int state, id data, NSString *msg) {
        mark = 1;
        if(state == 2000){
            
            NSDictionary *dic = data;
            
            NSLog(@"成功");
            _askModel = [[WonoAskModel alloc]init];
            
            _askModel.titleStr = dic[@"title"];
            _askModel.contentStr = dic[@"content"];
            NSDictionary *reDic = dic[@"author"];
            _askModel.imageArr = dic[@"pic_urls"];
            _askModel.askId = dic[@"id"];
            _askModel.name = reDic[@"username"];
            _askModel.time = dic[@"created_at"];
            _askModel.headUrl = reDic[@"avatar"];
            _askModel.sujjestCount = @"233";
            _askModel.positionStr = dic[@"location"];
            
            if([_askModel.contentStr isEqualToString:@""]&&_askModel.imageArr.count == 0){
                _askModel.type = 1;
            }
            if(![_askModel.contentStr isEqualToString:@""]&&_askModel.imageArr.count == 0){
                _askModel.type = 2;
            }
            if([_askModel.contentStr isEqualToString:@""]&&_askModel.imageArr.count != 0){
                _askModel.type = 3;
            }
            if(![_askModel.contentStr isEqualToString:@""]&&_askModel.imageArr.count != 0){
                _askModel.type = 4;
            }
            
//            [_mainTabelView reloadData];
            [self requestData];
            
        }else{
            [MBProgressHUD showSuccess:msg];
        }
        
    }];
}



-(void)makePlaceHolderWithTitle:(NSString *)title{
    
    [self.view layoutIfNeeded];
    [_mainTabelView layoutIfNeeded];
    [_mainTabelView jr_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
        //        [_plantTableView setScrollEnabled:NO];
        UIView *view = [[UIView alloc]initWithFrame:_mainTabelView.bounds];
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
        [_mainTabelView setScrollEnabled:YES];
    }];
    [_mainTabelView reloadData];
    
    
}

-(void)refresh{
    
    
    page = 1;
    
    for(int i=0;i<answerArr.count;i++){
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:1];
        //        NSString *cellIdentifier = [NSString stringWithFormat:@"identy%d",i];
        WonoAnswerTableViewCell *cell = [_mainTabelView cellForRowAtIndexPath:path];
        if(cell == nil){
            break;
        }
        cell.changeMark = @"1";
    }
    
    answerArr = [NSMutableArray array];
    
    
    
    [self requestData];

}
-(void)requestMore{
    page++;
    
    [self requestData];
    
}



-(void)hideKey{
    [_botTextView resignFirstResponder];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [_botView layoutIfNeeded];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        _botView.y = SCREEN_HEIGHT - height - _botView.height;
    }];
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    [_botView layoutIfNeeded];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        _botView.y = SCREEN_HEIGHT;
    }];
    
}

-(void)createBottom{

    _botView = [[UIView alloc]init];
    _botView.backgroundColor = UIColorFromHex(0xefefef);
    _botView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, HDAutoHeight(100));
    [self.view addSubview:_botView];
//    [_botView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view.mas_bottom);
//        make.height.equalTo(@(HDAutoHeight(100)));
//    }];
    
    
//    NSDictionary *dict=@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
//    CGSize contentSize=[@"我" sizeWithAttributes:dict];
    
    _botTextView = [[CMInputView alloc]initWithFrame:CGRectMake(HDAutoWidth(60), HDAutoHeight(15), SCREEN_WIDTH-HDAutoWidth(120), 33)];
    _botTextView.backgroundColor = [UIColor whiteColor];
    _botTextView.layer.masksToBounds = YES;
    _botTextView.layer.cornerRadius = 5;
    
    _botTextView.delegate = self;
    
    _botTextView.returnKeyType = UIReturnKeySend;
     _botTextView.font = [UIFont systemFontOfSize:14];
    
    _botTextView.layer.borderColor = [UIColor grayColor].CGColor;
    
    [_botTextView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        CGRect frame = _botTextView.frame;
        
        float mut = textHeight - frame.size.height;
        
        frame.size.height = textHeight;
        
        [UIView animateWithDuration:0.3 animations:^{
            _botTextView.frame = frame;
            
            //        _botTextView.y-=mut;
            _botView.y-=mut;
            _botView.height +=mut;
        }];
        

        
    }];
    
    _botTextView.maxNumberOfLines = 4;
    
    [_botView addSubview:_botTextView];
    
   
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    
    NSString *res = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSLog(@"%@", res);
    
    if ([text isEqualToString:@"\n"])
        
    {
        
        if(![textView.text isEqualToString:@""]){
            
            NSMutableDictionary *needDic = [NSMutableDictionary dictionary];
            [needDic setObject:textView.text forKey:@"content"];
            NSString *cont = [self DataTOjsonString:needDic];
            
            [[InterfaceSingleton shareInstance].interfaceModel wonoAnswerWithQid:_qid AndContent:cont WithRepID:replyID WithCallBack:^(int state, id data, NSString *msg) {
                if(state == 2000){
                    NSLog(@"成功");
                    [MBProgressHUD showSuccess:@"评论成功"];
                    [self refresh];
                    
                }else{
                    [MBProgressHUD showSuccess:msg];
                }
            }];
            
            
            
            textView.text = @"";
            [textView resignFirstResponder];
        }
        
        _botTextView.height = HDAutoHeight(70);
        _botView.height = HDAutoHeight(100);
        
    }
    
    return YES;
    
}

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_botTextView resignFirstResponder];
}

-(void)requestData{
    
    
    [[InterfaceSingleton shareInstance].interfaceModel getWonoAllAnswerWithPage:page AndQid:_qid WithCallBack:^(int state, id data, NSString *msg) {
        [_mainTabelView.mj_header endRefreshing];
        [_mainTabelView.mj_footer endRefreshing];
        if(state == 2000){
            NSLog(@"chenggong");
            
            NSDictionary *dic = data;
            NSArray *arr = dic[@"data"];
            
            if(arr.count==0){
                if(page !=1){
                    page--;
                }
            }
            
            for(int i=0;i<arr.count;i++){
            
                NSDictionary *dataDic = arr[i];
                
                WonoAnswerModel *model = [[WonoAnswerModel alloc]init];
                NSDictionary *redic = dataDic[@"author"];
                model.headUrl = redic[@"avatar"];
                model.name = redic[@"username"];
                model.time = dataDic[@"created_at"];
                model.contentStr = dataDic[@"content"];
                model.positionStr = dataDic[@"location"];
                model.audioUrl = dataDic[@"audio"];
                model.audioLength = @"0";//!!!!!!!!!!!!!!!!!!!!
                model.imageArr = dataDic[@"pic_urls"];
                model.answerId = dataDic[@"id"];
                model.replyName = dataDic[@"reply_name"];
                
                if(![model.contentStr isEqualToString:@""]&&model.imageArr.count==0&&[model.audioUrl isEqualToString:@""]){
                    model.type = 1;
                }
                if([model.contentStr isEqualToString:@""]&&model.imageArr.count==0&&![model.audioUrl isEqualToString:@""]){
                    model.type = 2;
                }
                if([model.contentStr isEqualToString:@""]&&model.imageArr.count!=0&&[model.audioUrl isEqualToString:@""]){
                    model.type = 3;
                }
                if(![model.contentStr isEqualToString:@""]&&model.imageArr.count!=0&&[model.audioUrl isEqualToString:@""]){
                    model.type = 4;
                }
                if(![model.contentStr isEqualToString:@""]&&model.imageArr.count==0&&![model.audioUrl isEqualToString:@""]){
                    model.type = 5;
                }
                if([model.contentStr isEqualToString:@""]&&model.imageArr.count!=0&&![model.audioUrl isEqualToString:@""]){
                    model.type = 6;
                }
                if(![model.contentStr isEqualToString:@""]&&model.imageArr.count!=0&&![model.audioUrl isEqualToString:@""]){
                    model.type = 7;
                }
                
                [answerArr addObject:model];
            }
            [_mainTabelView reloadData];
            
            if(answerArr.count<4){
                _mainTabelView.mj_footer.hidden = YES;
            }else{
                _mainTabelView.mj_footer.hidden = NO;
            }
            
        }else{
            [MBProgressHUD showNormalMessage:msg];
            if(page!=1){
                page--;
            }
        }
        
    }];
    
    
    
 
    
    
}

-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"问题详情";
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
    [_nextBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [_nextBtn setTitle:@"取消收藏" forState:UIControlStateSelected];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_nextBtn addTarget:self action:@selector(SaveClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_nextBtn];
    //    _saveBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY).offset(HDAutoHeight(5));
        make.right.equalTo(_headView.mas_right).offset(-HDAutoWidth(10));
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
    NSLog(@"点击发送");
    [_botTextView resignFirstResponder];
}


-(void)createTabel{
    _mainTabelView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _mainTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTabelView.backgroundColor = [UIColor whiteColor];
    _mainTabelView.delegate = self;
    _mainTabelView.dataSource = self;
//    _mainTabelView.style = UITableViewStyleGrouped;
//    [_mainTabelView style]
    
    UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onLabelEvent:)];
    tapGestureTel.delegate = self;
    [_mainTabelView addGestureRecognizer:tapGestureTel];
    
    
    
    [self.view addSubview:_mainTabelView];
    
    [_mainTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(_headView.mas_bottom);
        
    }];
    
}

 -(void) onLabelEvent:(UITapGestureRecognizer *)recognizer{
     NSLog(@"点击");
     [_botTextView resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    if([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    [_botTextView resignFirstResponder];
    return  NO;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0){
        if(_askModel){
            return 1;
        }
    }
    
    return answerArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section == 0){
        NSString *cellIdentifier = @"cellIdenty";
        WonoAskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell =  [[WonoAskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = _askModel;
            
            

        }
        
        [cell setCellBlock:^(NSDictionary *dic){
            
            NSString *needID = dic[@"ID"];
            NSLog(@"点击了");
            if([_botTextView isFirstResponder]){
                [_botTextView resignFirstResponder];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.5/*延迟执行时间*/ * NSEC_PER_SEC);
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    ToAnswerViewController *ansC = [[ToAnswerViewController alloc]init];
                    ansC.askID = needID;
                    [self.navigationController pushViewController:ansC animated:YES];
                });
                
            }else{
                ToAnswerViewController *ansC = [[ToAnswerViewController alloc]init];
                ansC.askID = needID;
                [self.navigationController pushViewController:ansC animated:YES];
            }
            
        }];
//        [cell setCellBlock:<#void (^)(NSDictionary *)cellBlock#>]
        
        
        return cell;
    }else{
        
        
        NSString *cellIdentifier = [NSString stringWithFormat:@"identy%ld",(long)indexPath.row];
        WonoAnswerModel *model = answerArr[indexPath.row];
        
        WonoAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[WonoAnswerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
            
            
        }
        
        if([cell.changeMark isEqualToString:@"1"]){
            NSLog(@"aaa");
            
            cell = [[WonoAnswerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
            cell.changeMark = @"0";
        }
    
        [cell setCellBlock:^(NSDictionary *dic){
            NSLog(@"点击了");
            
            [_botTextView becomeFirstResponder];
            
            NSString *repID = dic[@"ID"];
            replyID = repID;
            
            
        }];
        
        return cell;
    }
    
//    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        
        CGFloat height233 = [self getSpaceLabelHeight:_askModel.contentStr withFont:[UIFont systemFontOfSize:13] withWidth:SCREEN_WIDTH - HDAutoWidth(80)]+HDAutoHeight(20);
        CGFloat height = 0;
        
        switch (_askModel.type) {
            case 1:{
                height = HDAutoHeight(270)+HDAutoHeight(90);
                break;
            }
            case 2:{
                height = HDAutoHeight(310)+HDAutoHeight(10)+height233;
                break;
            }
            case 3:{
                height = HDAutoHeight(550)+HDAutoHeight(90)-HDAutoHeight(180);
                break;
            }
            case 4:{
                height = HDAutoHeight(630)+HDAutoHeight(20)-HDAutoHeight(180)+height233;
                break;
            }
           
                
            default:
                break;
        }
        
        return height;
        
    }else{
        
        WonoAnswerModel *model = answerArr[indexPath.row];
        CGFloat height233 = [self getSpaceLabelHeight:model.contentStr withFont:[UIFont systemFontOfSize:13] withWidth:SCREEN_WIDTH - HDAutoWidth(80)]+HDAutoHeight(20);
        CGFloat height = 0;
        
        switch (model.type) {
            case 1:{
                height = HDAutoHeight(250)+height233;
                break;
            }
            case 2:{
                if([model.replyName isEqualToString:@""]){
                    height = HDAutoHeight(310)+HDAutoHeight(10)+height233+HDAutoHeight(40)-HDAutoHeight(80)-HDAutoHeight(70);
                }else{
                    height = HDAutoHeight(310)+HDAutoHeight(10)+height233+HDAutoHeight(40)-HDAutoHeight(70);
                }
                break;
            }
            case 3:{
                
                if([model.replyName isEqualToString:@""]){
                    height = HDAutoHeight(310)+HDAutoHeight(10)+height233+HDAutoHeight(40)-HDAutoHeight(80)-HDAutoHeight(70)+HDAutoHeight(90);
                }else{
                    height = HDAutoHeight(310)+HDAutoHeight(10)+height233+HDAutoHeight(40)-HDAutoHeight(70)+HDAutoHeight(90);
                }
                
//                height = HDAutoHeight(550)+HDAutoHeight(90)-HDAutoHeight(180);
                break;
            }
            case 4:{
                
                    height = HDAutoHeight(310)+HDAutoHeight(10)+height233+HDAutoHeight(40)-HDAutoHeight(70)+HDAutoHeight(90);
                break;
            case 5:{
                
                    height = HDAutoHeight(310)+HDAutoHeight(10)+height233+HDAutoHeight(40)-HDAutoHeight(70);
                
                break;
            }
                
            case 6:{
                if([model.replyName isEqualToString:@""]){
                    height = HDAutoHeight(310)+HDAutoHeight(10)+height233+HDAutoHeight(40)-HDAutoHeight(80)-HDAutoHeight(70)+HDAutoHeight(160);
                }else{
                    height = HDAutoHeight(310)+HDAutoHeight(10)+height233+HDAutoHeight(40)-HDAutoHeight(70)+HDAutoHeight(160);
                }
                break;
            }
            case 7:{
               
                    height = HDAutoHeight(310)+HDAutoHeight(10)+height233+HDAutoHeight(40)-HDAutoHeight(70)+HDAutoHeight(160);
                
                break;
            }


                break;
            }
                
            default:
                break;
        }
        
        return height;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section==0){
        return 0.01;
    }else{
        return HDAutoHeight(40);
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 3;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    if(section == 1){
    UILabel *label = [[UILabel alloc]init];
        if(mark != 0){
            label.text = [NSString stringWithFormat:@"%lu个回答",(unsigned long)answerArr.count];
        }
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    label.frame = CGRectMake(HDAutoWidth(20), 0, HDAutoWidth(400), HDAutoWidth(40));
    [view addSubview:label];
    }
    
    
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell");
    [_botTextView resignFirstResponder];
    
}

@end
