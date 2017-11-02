//
//  MineDataViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/3.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "MineDataViewController.h"
#import "ChangeNameViewController.h"
#import "CustomActionSheet.h"
#import "QNUploader.h"
//#import "QiniuUploader.h"

@interface MineDataViewController ()<UITableViewDelegate,UITableViewDataSource,CustomActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QNUploaderDelegate,changeNameDelegate>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong) UITableView *contentTableView;

@end

@implementation MineDataViewController{
    NSArray *dataArr;
    NSMutableArray *contArr;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatTitleAndBackBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    dataArr = [NSArray arrayWithObjects:@"修改头像",@"手机号",@"昵称",@"性别",nil];
    
    contArr = [NSMutableArray array];
    [contArr addObject:@""];
    [contArr addObject:@""];
    [contArr addObject:@""];
    [contArr addObject:@""];
    
    [self createTable];
    
    
    [self requestData];
//    [self aboutQiniu];
    
    
}

-(void)requestData{
    
    [[InterfaceSingleton shareInstance].interfaceModel getUserInfoWithCallBack:^(int state, id data, NSString *msg) {
        
        if(state == 2000){
            NSDictionary *dic= data;
            NSString *imageUrl = dic[@"avatar"];
            
//            if(![imageUrl isEqualToString:@""]){
//                imageUrl = [NSString stringWithFormat:@"http://ospirz9dn.bkt.clouddn.com/%@",imageUrl];
//            }
            
            NSString *phone = dic[@"mobile"];
            NSString *name = dic[@"username"];
            NSString *sex;
            int se = [dic[@"sex"]intValue];
            if(se == 1){
                sex = @"男";
            }else{
                sex = @"女";
            }
            contArr = [NSMutableArray array];
            [contArr addObject:imageUrl];
            [contArr addObject:phone];
            [contArr addObject:name];
            [contArr addObject:sex];
            
            
            [_contentTableView reloadData];
            
        }else{
            [MBProgressHUD showSuccess:msg];
        }
        
    }];
    
}


-(void)uploadWithImage:(UIImage *)image{
    
    
    
    QNUploader *uploader = [[QNUploader alloc] initWithUploadType:EQTT_Pic];
    uploader.delegate = self;
    
    NSString *name = [NSString stringWithFormat:@"%@.png",[self createGUID]];
    
//    UIImage *image = [UIImage imageNamed:@"年度收入与支出"];
    
    NSData *data = UIImageJPEGRepresentation(image,0.1);
    
    [uploader addTaskWithFileData:data FileName:name];

    
}

-(void)UploadSuccessWithFileName:(NSString *)fileName{
    [MBProgressHUD showSuccess:@"上传成功"];
    NSLog(@"aaa");
    
    NSString *imageUrl = [NSString stringWithFormat:@"http://ospirz9dn.bkt.clouddn.com/%@",fileName];
    contArr[0] = imageUrl;
    [_contentTableView reloadData];
    
    
    [[InterfaceSingleton shareInstance].interfaceModel updateUserInfoWithAvatar:imageUrl AndSex:nil AndName:nil AndCallBack:^(int state, id data, NSString *msg) {
        
        if(state == 2000){
            [MBProgressHUD showSuccess:@"修改成功"];
            
            
        }else{
        
            [MBProgressHUD showSuccess:msg];
            
        }
        
        
        
    }];
    
    
}

-(void)UploadFailedWithFileName:(NSString *)fileName{
    [MBProgressHUD showSuccess:@"上传失败"];
    NSLog(@"bbb");
}



- (NSString *)createGUID{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    _titleLabel.text = @"个人信息";
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
    
    _contentTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.01)];
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
        make.height.equalTo(cell.contentView.mas_height);
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
    
    
    switch (indexPath.row) {
        case 0:{
            
            UIImageView *headImgView = [[UIImageView alloc]init];
            headImgView.tag = 200+indexPath.row;
//            [headImgView sd_setImageWithURL:contArr[indexPath.row]];
            
            NSString *url = contArr[0];
            NSURL *rurl = [NSURL URLWithString:url];
            
            
            
            [headImgView sd_setImageWithURL:rurl placeholderImage:[UIImage imageNamed:@"默认头像"]];
            
            headImgView.contentMode = UIViewContentModeScaleAspectFill;
            
//            headImgView.backgroundColor = [UIColor greenColor];
//            headImgView.contentMode = UIViewContentModeScaleToFill;
//            headImgView.image = [UIImage imageNamed:@"我的-selected"];
            headImgView.layer.cornerRadius = HDAutoWidth(35);
            headImgView.layer.masksToBounds = YES;
            [cell.contentView addSubview:headImgView];
            [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(HDAutoWidth(70)));
                make.height.equalTo(@(HDAutoWidth(70)));
                make.right.equalTo(imgView.mas_left).offset(-HDAutoWidth(30));
                make.centerY.equalTo(imgView.mas_centerY);
            }];
            
             break;
        }
        case 1:{
            
            UILabel *phoneLabel = [[UILabel alloc]init];
            phoneLabel.tag = 200+indexPath.row;
            phoneLabel.text = contArr[indexPath.row];
            phoneLabel.textColor = UIColorFromHex(0x9fa0a0);
            phoneLabel.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:phoneLabel];
            phoneLabel.textAlignment = NSTextAlignmentRight;
            [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(HDAutoWidth(250)));
                make.height.equalTo(@(HDAutoHeight(50)));
                make.centerY.equalTo(imgView.mas_centerY);
                make.right.equalTo(imgView.mas_left).offset(-HDAutoWidth(30));
            }];
            imgView.alpha = 0;
            break;
        }
        case 2:{
            UILabel *phoneLabel = [[UILabel alloc]init];
            phoneLabel.tag = 200+indexPath.row;
            phoneLabel.text = contArr[indexPath.row];
            phoneLabel.textColor = UIColorFromHex(0x9fa0a0);
            phoneLabel.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:phoneLabel];
            phoneLabel.textAlignment = NSTextAlignmentRight;
            [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(HDAutoWidth(250)));
                make.height.equalTo(@(HDAutoHeight(50)));
                make.centerY.equalTo(imgView.mas_centerY);
                make.right.equalTo(imgView.mas_left).offset(-HDAutoWidth(30));
            }];
            break;
        }
        case 3:{
            UILabel *phoneLabel = [[UILabel alloc]init];
            phoneLabel.tag = 200+indexPath.row;
            phoneLabel.text = contArr[indexPath.row];
            phoneLabel.textColor = UIColorFromHex(0x9fa0a0);
            phoneLabel.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:phoneLabel];
            phoneLabel.textAlignment = NSTextAlignmentRight;
            [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(HDAutoWidth(250)));
                make.height.equalTo(@(HDAutoHeight(50)));
                make.centerY.equalTo(imgView.mas_centerY);
                make.right.equalTo(imgView.mas_left).offset(-HDAutoWidth(30));
            }];
            break;
        }
           
            
        default:
            break;
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return HDAutoHeight(100);
    }else{
        return HDAutoHeight(80)+1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
//            AboutViewController *about = [[AboutViewController alloc]init];
//            [self.navigationController pushViewController:about animated:YES];
            //修改用户头像
            CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithTitle:nil
                                                                   buttonTitles:[NSArray arrayWithObjects:@"从相册选择",@"拍照", nil]
                                                              cancelButtonTitle:@"取消"
                                                                       delegate:(id<CustomActionSheetDelegate>)self];
            sheet.tag = 2;
            [sheet show];
            break;
        }
        case 1:{
//            CallBackViewController *CallVc = [[CallBackViewController alloc]init];
//            [self.navigationController pushViewController:CallVc animated:YES];
            break;
        }
        case 2:{
//            ChangePswViewController *ChangeVc = [[ChangePswViewController alloc]init];
//            [self.navigationController pushViewController:ChangeVc animated:YES];
            ChangeNameViewController *nameVC = [[ChangeNameViewController alloc]init];
            nameVC.delegate = self;
            
            nameVC.needName = contArr[indexPath.row];
            
            [self.navigationController pushViewController:nameVC animated:YES];
            break;
            
            
        }
        case 3:{
            
            CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithTitle:nil
                                                                   buttonTitles:[NSArray arrayWithObjects:@"男",@"女", nil]
                                                              cancelButtonTitle:@"取消"
                                                                       delegate:(id<CustomActionSheetDelegate>)self];
            sheet.tag = 1;
            [sheet show];
            
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    NSLog(@"%ld",(long)indexPath.row);
}


-(void)nameChangedWithName:(NSString *)name{

    contArr[2] = name;
    
    [_contentTableView reloadData];
    
    
    
    
    
}


#pragma mark UIActionSheetDelegate

- (void)actionSheet:(CustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"clickedButtonAtIndex:%ld",buttonIndex);
    
    if(actionSheet.tag == 1){
    
        switch (buttonIndex) {
            case 0:{
                
                [[InterfaceSingleton shareInstance].interfaceModel updateUserInfoWithAvatar:nil AndSex:@"1" AndName:nil AndCallBack:^(int state, id data, NSString *msg) {
                    if(state == 2000){
                        [MBProgressHUD showSuccess:@"修改成功"];
                        UILabel *label = (UILabel *)[_contentTableView viewWithTag:203];
                        label.text = @"男";
                    }else{
                        [MBProgressHUD showSuccess:msg];
                    }
                    
                   

                }];
                
            }
                break;
            case 1:{
                
                [[InterfaceSingleton shareInstance].interfaceModel updateUserInfoWithAvatar:nil AndSex:@"2" AndName:nil AndCallBack:^(int state, id data, NSString *msg) {
                    if(state == 2000){
                        [MBProgressHUD showSuccess:@"修改成功"];
                        UILabel *label = (UILabel *)[_contentTableView viewWithTag:203];
                        label.text = @"女";
                    }else{
                        [MBProgressHUD showSuccess:msg];
                    }
                }];
                            }
                break;
                
            default:
                break;
        }
        
    }else{
    
        NSLog(@"修改用户头像");
        switch (buttonIndex) {
            case 0: {
                //打开相册
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                //设置选择后的图片可被编辑
                picker.allowsEditing = YES;
                [self presentViewController:picker animated:YES completion:nil];
    //            UIPopoverController *popoverController = [[UIPopoverController alloc]initWithContentViewController:picker];
    //            [popoverController presentPopoverFromRect:CGRectMake(0, 0, HDAutoWidth(467), HDAutoWidth(467)) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
            }
                break;
            case 1: {
                //手机拍照
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    //设置拍照后的图片可被编辑
                    picker.allowsEditing = YES;
                    picker.sourceType = sourceType;
                    [self presentViewController:picker animated:YES completion:nil];
    //                UIPopoverController *popoverController = [[UIPopoverController alloc]initWithContentViewController:picker];
    //                [popoverController presentPopoverFromRect:CGRectMake(0, 0, HDAutoWidth(467), HDAutoWidth(467)) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                } else {
                    //模拟器没有
                }
            }
                break;
        }
            
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIImage *newImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    if(newImage!=nil){
    
        [self uploadWithImage:newImage];
    }
//    UIImage *resizeImage = [newImage imageEqualRatioScaledToSize:CGSizeMake(150, 150)];
//    [self savaClicked:resizeImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
