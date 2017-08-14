//
//  NeedSelectionViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/7.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "PengAddViewController.h"
#import "CDZPicker.h"
#import "AddStuffViewController.h"
#import "StuffTableViewCell.h"
#import "PengTypeViewController.h"

@interface PengAddViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UITextField *mainTextField;
@property (nonatomic,strong)UIButton *searchBtn;

@property (nonatomic,strong)UIButton *confirmBtn;

@property (nonatomic,strong)UILabel *searchLabel;

@property (nonatomic,strong)UITextField *pengNameTextField;

@property (nonatomic,strong)UIButton *catSelBtn;

@property (nonatomic,strong)UILabel *typeLabel;

@property (nonatomic,strong)UIButton *addBtn;

@property (nonatomic,strong)UITableView *stuffTableView;


@end

@implementation PengAddViewController{
    int count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    count = 5;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatTitleAndBackBtn];
    [self createConfirmBtn];
    [self createMain];
    [self createPengNameAndOther];
    [self createTypeLabel];
    [self createAddBtn];
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
    _titleLabel.text = @"添加大棚";
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

-(void)createMain{
    
    _mainTextField = [[UITextField alloc]init];
    _mainTextField.placeholder = @"请输入设备的识别号";
    _mainTextField.font = [UIFont systemFontOfSize:13];
    _mainTextField.textColor = UIColorFromHex(0x727171);
    _mainTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mainTextField.layer.masksToBounds = YES;
    _mainTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _mainTextField.layer.borderWidth = 0.6;
    _mainTextField.layer.cornerRadius = 5;
    _mainTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    _mainTextField.leftViewMode = UITextFieldViewModeAlways;
//    _mainTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_mainTextField];
    [_mainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(HDAutoWidth(30));
        make.width.equalTo(@(HDAutoWidth(430)));
        make.top.equalTo(_headView.mas_bottom).offset(HDAutoHeight(30));
        make.height.equalTo(@(HDAutoHeight(68)));
    }];
    
    _searchBtn = [[UIButton alloc]init];
    [_searchBtn setBackgroundColor:UIColorFromHex(0x3eb36e)];
    [_searchBtn setTitle:@"搜索设备" forState:UIControlStateNormal];
    [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    _searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _searchBtn.layer.masksToBounds = YES;
    _searchBtn.layer.cornerRadius = 5;
    [self.view addSubview:_searchBtn];
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainTextField.mas_right).offset(HDAutoWidth(30));
        make.top.equalTo(_mainTextField.mas_top);
        make.height.equalTo(_mainTextField.mas_height);
        make.width.equalTo(@(HDAutoWidth(225)));
    }];
    
    _searchLabel = [[UILabel alloc]init];
    _searchLabel.font = [UIFont systemFontOfSize:13];
    _searchLabel.textColor = UIColorFromHex(0x727171);
    _searchLabel.text = @"当前设备未被绑定，可连接";
    _searchLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_searchLabel];
    
    [_searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainTextField.mas_left);
        make.top.equalTo(_mainTextField.mas_bottom).offset(HDAutoHeight(10));
        make.right.equalTo(_searchLabel.mas_right);
        make.height.equalTo(@(HDAutoHeight(45)));
    }];
    
}

-(void)searchClick{
    NSLog(@"点击搜索设备");
    
    
}

-(void)createConfirmBtn{
    _confirmBtn = [[UIButton alloc]init];
    [_confirmBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn setBackgroundColor:UIColorFromHex(0x3eb36e)];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_confirmBtn];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@(HDAutoHeight(98)));
    }];
}

-(void)createPengNameAndOther{
    _pengNameTextField = [[UITextField alloc]init];
    _pengNameTextField.placeholder = @"大棚的名称";
    _pengNameTextField.font = [UIFont systemFontOfSize:13];
    _pengNameTextField.textColor = UIColorFromHex(0x727171);
    _pengNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pengNameTextField.layer.masksToBounds = YES;
    _pengNameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _pengNameTextField.layer.borderWidth = 0.6;
    _pengNameTextField.layer.cornerRadius = 5;
    _pengNameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    _pengNameTextField.leftViewMode = UITextFieldViewModeAlways;
//    _pengNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_pengNameTextField];
    [_pengNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(HDAutoWidth(30));
        make.right.equalTo(_searchBtn.mas_right);
        make.top.equalTo(_searchLabel.mas_bottom).offset(HDAutoHeight(10));
        make.height.equalTo(@(HDAutoHeight(68)));
    }];
    
    
    NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:@"请选择大棚种植的品种"];
    [attri setAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]} range:NSMakeRange(0, attri.length)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, attri.length)];
    
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"1-进入"];
    // 设置图片大小
    attch.bounds = CGRectMake(HDAutoWidth(10), -HDAutoHeight(10.5), HDAutoHeight(35), HDAutoHeight(35));
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:string];
    
    
    
    
    _catSelBtn = [[UIButton alloc]init];
    [_catSelBtn setBackgroundColor:UIColorFromHex(0x3eb36e)];
    [_catSelBtn setAttributedTitle:attri forState:UIControlStateNormal];
    [_catSelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_catSelBtn addTarget:self action:@selector(catClick) forControlEvents:UIControlEventTouchUpInside];
//    _catSelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _catSelBtn.layer.masksToBounds = YES;
    _catSelBtn.layer.cornerRadius = 5;
    [self.view addSubview:_catSelBtn];
    [_catSelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainTextField.mas_left);
        make.top.equalTo(_pengNameTextField.mas_bottom).offset(HDAutoHeight(15));
        make.height.equalTo(_mainTextField.mas_height);
        make.width.equalTo(@(HDAutoWidth(380)));
    }];


}

-(void)catClick{
    PengTypeViewController *pengtype = [[PengTypeViewController alloc]init];
    [self.navigationController pushViewController:pengtype animated:YES];
}

-(void)createTypeLabel{
    _typeLabel = [[UILabel alloc]init];
    _typeLabel.text = @"点击选择大棚类型";
    _typeLabel.textColor = UIColorFromHex(0x9fa0a0);
    _typeLabel.font = [UIFont systemFontOfSize:13];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeClick)];
    _typeLabel.userInteractionEnabled = YES;
    [_typeLabel addGestureRecognizer:tap];
    _typeLabel.layer.masksToBounds = YES;
    _typeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _typeLabel.layer.borderWidth = 0.6;
    _typeLabel.layer.cornerRadius = 5;

    
    [self.view addSubview:_typeLabel];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pengNameTextField.mas_left);
        make.top.equalTo(_catSelBtn.mas_bottom).offset(HDAutoHeight(15));
        make.width.equalTo(_catSelBtn.mas_width);
        make.height.equalTo(_catSelBtn.mas_height);
    }];
}

-(void)typeClick{
    NSLog(@"点击选择类型");
    
    NSArray *arr = [NSArray arrayWithObjects:@"水果大棚",@"啊啊啊啊",@"呜呜呜呜",@"嗯嗯嗯嗯", nil];
    
      [CDZPicker showPickerInView:self.view withStrings:arr confirm:^(NSArray<NSString *> *stringArray) {
          
          _typeLabel.text = stringArray.firstObject;
          
      } cancel:^{
          NSLog(@"点击取消了");
      }];
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
        make.bottom.equalTo(_confirmBtn.mas_top);
        
    }];
    
}

-(void)addBtnClick{
    NSLog(@"点击添加新员工");
    AddStuffViewController *addStuff = [[AddStuffViewController alloc]init];
    [self.navigationController pushViewController:addStuff animated:YES];
}

-(void)createTable{
    
    _stuffTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _stuffTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _stuffTableView.dataSource = self;
    _stuffTableView.delegate = self;
    _stuffTableView.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:_stuffTableView];
    
    [_stuffTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_typeLabel.mas_bottom).offset(HDAutoHeight(15));
        make.bottom.equalTo(_addBtn.mas_top).offset(-HDAutoHeight(10));
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



-(void)confirmClick{
    NSLog(@"点击修改");
    
}



@end
