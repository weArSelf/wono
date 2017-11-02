//
//  ToAskViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/28.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "ToAskViewController.h"
#import "UITextView+Placeholder.h"
#import "LimitInput.h"
#import "CustomActionSheet.h"


//百度地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#define BMK_KEY @"kClOFMdxGkzAgIr6MEfGF8cgGWMjqx02"//百度地图的key


#import "UIImageView+MHFacebookImageViewer.h"


#import "QNUploader.h"


@interface ToAskViewController ()<UITextFieldDelegate,UITextViewDelegate,CustomActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,QNUploaderDelegate>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UIButton *nextBtn;

@property (nonatomic,strong)UITextField *headTextField;

@property (nonatomic,strong)UITextView *mainTextView;

@property (nonatomic,strong)UIView *selImageView;

@property (nonatomic,strong)UIButton *addBtn;

//百度地图
@property (nonatomic, strong)BMKLocationService *locService;
@property (nonatomic, strong)BMKGeoCodeSearch *geocodesearch;
@property BOOL isGeoSearch;


@property (nonatomic,strong) UIImageView    *iconImageView;
@property (nonatomic,strong) UILabel *locatLabel;

@end

@implementation ToAskViewController{
    NSMutableArray *dataArr;
    CGRect frame1;
    CGRect frame2;
    CGRect frame3;
    CGRect frame4;
    NSMutableArray *resImageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArr = [NSMutableArray array];
    resImageArr = [NSMutableArray array];
    
    // Do any additional setup after loading the view.
    [self creatTitleAndBackBtn];
    [self createNextBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createFirstHead];
    [self creatMainTextView];
    [self createImageContent];
    [_headTextField becomeFirstResponder];
    
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
    [self createLocateContent];
//    [self getLocate];
    [self getReLocate];
    
}

-(void)getReLocate{
    
    [[InterfaceSingleton shareInstance].interfaceModel getMyFarmWithCallBack:^(int state, id data, NSString *msg) {
       
        if(state == 2000){
            NSLog(@"成功");
            NSDictionary *dic = data;
            NSString *add = dic[@"address"];
            _locatLabel.text = add;
            
        }else{
            _locatLabel.text = @"未指定农场";
//            [MBProgressHUD showSuccess:@"未定义农场位置"];
        }
        
    }];
    
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
//    //获取键盘的高度
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int height = keyboardRect.size.height;
    if(_selImageView!=nil){
        [UIView animateWithDuration:0.5 animations:^{
            _selImageView.y = _mainTextView.bottom+HDAutoHeight(70);
        }];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{

    [UIView animateWithDuration:0.5 animations:^{
        _selImageView.y = SCREEN_HEIGHT - _selImageView.height-HDAutoHeight(40);
    }];
    
}



-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"我要提问";
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
    if(![_mainTextView.text isEqualToString:@""]||dataArr.count!=0||![_headTextField.text isEqualToString:@""] ){
        
        [_headTextField resignFirstResponder];
        [_mainTextView resignFirstResponder];
        UIAlertController *AlertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"返回将失去当前填写内容\n是否继续？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *refuseAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [AlertC addAction:refuseAct];
        [AlertC addAction:confirmAct];
        [self presentViewController:AlertC animated:YES completion:nil];
        
        return;
    }

    [self.navigationController popViewControllerAnimated:YES];
}


-(void)createNextBtn{
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"发送" forState:UIControlStateNormal];
//    [_nextBtn setTitle:@"取消编辑" forState:UIControlStateSelected];
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
    if([_headTextField.text isEqualToString:@""]){
        [MBProgressHUD showSuccess:@"请添加标题"];
        return;
    }
    
    _nextBtn.enabled = NO;
    
    if(dataArr.count>0){
        [MBProgressHUD showLongSuccess:@"图片文件上传中" toView:self.view];
//        [MBProgressHUD showlongNormalMessage:@"图片文件上传中"];
        for (int i=0; i<dataArr.count; i++) {
            UIImage *image = dataArr[i];
            NSData *data = UIImagePNGRepresentation(image);
            if(data!=nil){
                QNUploader *uploader = [[QNUploader alloc] initWithUploadType:EQTT_Pic];
                uploader.delegate = self;
                
                NSString *name = [NSString stringWithFormat:@"%@.png",[self createGUID]];
                
                [uploader addTaskWithFileData:data FileName:name];
            }

        }
        
       
        
        
        return;
    }
    
    [MBProgressHUD showLongSuccess:@"提交中..." toView:self.view];
    [[InterfaceSingleton shareInstance].interfaceModel WonoAskQuestionWithContent:_mainTextView.text AndResources:nil WithTitle:_headTextField.text WithType:@"1" WithCallBack:^(int state, id data, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view];
        if(state == 2000){
            NSLog(@"成功");
            [MBProgressHUD showSuccess:@"提交成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"wonoCircleRe" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [MBProgressHUD showSuccess:msg];
        }
        _nextBtn.enabled = YES;
       
    }];
    
}
- (NSString *)createGUID{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

-(void)UploadSuccessWithFileName:(NSString *)fileName{
    
    
    NSString *imgUrl = [NSString stringWithFormat:@"http://ospirz9dn.bkt.clouddn.com/%@",fileName];
    
    NSLog(@"%@", imgUrl);
    NSLog(@"aaa");
    
    [resImageArr addObject:imgUrl];
    
    if(resImageArr.count == dataArr.count){
        NSString *resource = [self objArrayToJSON:resImageArr];
        NSLog(@"上传");
       
        [[InterfaceSingleton shareInstance].interfaceModel WonoAskQuestionWithContent:_mainTextView.text AndResources:resource WithTitle:_headTextField.text WithType:@"1" WithCallBack:^(int state, id data, NSString *msg) {
            [MBProgressHUD hideHUDForView:self.view];
            if(state == 2000){
                NSLog(@"成功");
                [MBProgressHUD showSuccess:@"提交成功"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"wonoCircleRe" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showSuccess:msg];
            }
            _addBtn.enabled = YES;
            
        }];
        
        
    }
    
}

- (NSString *)objArrayToJSON:(NSArray *)array {
    
    NSString *jsonStr = @"[\"";
    
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@"\",\""];
        }
        jsonStr = [jsonStr stringByAppendingString:array[i]];
    }
    jsonStr = [jsonStr stringByAppendingString:@"\"]"];
    
    return jsonStr;
}

-(void)UploadFailedWithFileName:(NSString *)fileName{
    [MBProgressHUD showSuccess:@"上传失败,请重试"];
    _nextBtn.enabled = YES;
}

-(void)createFirstHead{
    _headTextField = [[UITextField alloc]init];
    _headTextField.delegate = self;
    _headTextField.placeholder = @"请输入提问的标题";
    _headTextField.font = [UIFont systemFontOfSize:13];
    _headTextField.textColor = UIColorFromHex(0x727171);
    _headTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _headTextField.layer.masksToBounds = YES;
    _headTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _headTextField.layer.borderWidth = 0.6;
    _headTextField.layer.cornerRadius = 5;
    [_headTextField setValue:@20 forKey:@"limit"];
    _headTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _headTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    _headTextField.leftViewMode = UITextFieldViewModeAlways;
    //    _pengNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_headTextField];
    [_headTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(HDAutoWidth(30));
        make.right.equalTo(self.view.mas_right).offset(-HDAutoWidth(30));
        make.height.equalTo(@(HDAutoHeight(68)));
        make.top.equalTo(_headView.mas_bottom).offset(HDAutoHeight(10));
    }];
    
    
    
}


-(void)creatMainTextView{
    
    _mainTextView = [[UITextView alloc]init];
    _mainTextView.placeholder = @"120字以内的问题描述";
    _mainTextView.delegate = self;
    
    _mainTextView.font = [UIFont systemFontOfSize:13];
    _mainTextView.textColor = UIColorFromHex(0x727171);
//    _mainTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mainTextView.layer.masksToBounds = YES;
    _mainTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _mainTextView.layer.borderWidth = 0.6;
    _mainTextView.layer.cornerRadius = 5;
    
//    _mainTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _mainTextView.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
//    _headTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [_mainTextView setValue:@120 forKey:@"limit"];

    [self.view addSubview:_mainTextView];
    
    [_mainTextView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_headTextField.mas_left);
        make.right.equalTo(_headTextField.mas_right);
        make.top.equalTo(_headTextField.mas_bottom).offset(HDAutoHeight(10));
        make.height.equalTo(@(HDAutoHeight(370)));
        
    }];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_headTextField resignFirstResponder];
    [_mainTextView resignFirstResponder];
    
    
}

-(void)createImageContent{
    [_mainTextView layoutIfNeeded];
    [self.view layoutIfNeeded];
    _selImageView = [[UIView alloc]init];
//    _selImageView.backgroundColor = [UIColor lightGrayColor];
    _selImageView.frame = CGRectMake(_mainTextView.x, _mainTextView.bottom+HDAutoHeight(70), _mainTextView.width, HDAutoHeight(155));
    
    [self.view addSubview:_selImageView];
    
    
    [self createDetail];
    
    
}

-(void)createDetail{
    
   
    
    
    frame1 = CGRectMake(0, 0, (_selImageView.width-HDAutoWidth(40))/3, _selImageView.height);
    frame2 = CGRectMake((_selImageView.width-HDAutoWidth(40))/3+HDAutoWidth(20), 0, (_selImageView.width-HDAutoWidth(40))/3, _selImageView.height);
    frame3 = CGRectMake((_selImageView.width-HDAutoWidth(40))/3*2+HDAutoWidth(40), 0, (_selImageView.width-HDAutoWidth(40))/3, _selImageView.height);
    frame4 = CGRectMake(HDAutoWidth(660)+HDAutoWidth(90), 0, (_selImageView.width-HDAutoWidth(40))/3, _selImageView.height);
    if(dataArr.count == 0){
        
        
        _addBtn = [[UIButton alloc]init];
        
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _addBtn.frame = frame1;
        
        [_selImageView addSubview:_addBtn];
        
    }
    

}

-(void)addClick{
    
    NSLog(@"点击添加");
    
    [_mainTextView resignFirstResponder];
    [_headTextField resignFirstResponder];
    //修改用户头像
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithTitle:nil
                                                           buttonTitles:[NSArray arrayWithObjects:@"从相册选择",@"拍照", nil]
                                                      cancelButtonTitle:@"取消"
                                                               delegate:(id<CustomActionSheetDelegate>)self];
    sheet.tag = 2;
    [sheet show];

}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(CustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"clickedButtonAtIndex:%ld",buttonIndex);
    
    
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIImage *newImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    if(newImage!=nil){
        
        [dataArr addObject:newImage];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        
        switch (dataArr.count) {
            case 1:{
                imageView.frame = frame1;
                break;
            }
            case 2:{
                imageView.frame = frame2;
                break;
            }
            case 3:{
                imageView.frame = frame3;
                break;
            }
                
                
            default:
                break;
        }
        imageView.image = newImage;
//        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.alpha = 0;
        imageView.tag = dataArr.count+300;
        imageView.userInteractionEnabled=true;
        
        [imageView setupImageViewer];
        
        [_selImageView addSubview:imageView];
        
        UIButton *deleteBtn = [[UIButton alloc]init];
        
        deleteBtn.tag = dataArr.count+200;
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
//        deleteBtn.frame = CGRectMake(imageView.width-HDAutoWidth(25), -HDAutoWidth(25), HDAutoWidth(50), HDAutoWidth(50));
        deleteBtn.frame = CGRectMake(imageView.width-HDAutoWidth(40), -HDAutoWidth(10), HDAutoWidth(50), HDAutoWidth(50));
        [deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        
        deleteBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        [imageView addSubview:deleteBtn];
        
        deleteBtn.alpha = 0;
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW,0.5 * NSEC_PER_SEC);
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                deleteBtn.alpha = 1;
                imageView.alpha = 1;
                if(dataArr.count == 3){
                    _addBtn.x = _addBtn.x+(_selImageView.width-HDAutoWidth(40))/3+HDAutoWidth(60);
                }else{
                    _addBtn.x = _addBtn.x+(_selImageView.width-HDAutoWidth(40))/3+HDAutoWidth(20);
                }
            }];

        });
        
        
//        [self uploadWithImage:newImage];
    }
    //    UIImage *resizeImage = [newImage imageEqualRatioScaledToSize:CGSizeMake(150, 150)];
    //    [self savaClicked:resizeImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)deleteClick:(UIButton *)btn{
    
    NSLog(@"%ld", (long)btn.tag);
    int org = btn.tag;
    int index = org-201;
    int retag = org+100;
    
    
    
    UIImageView *imgView = (UIImageView *)[_selImageView viewWithTag:retag];
    
//    int count = index +1;
    
    for (int i=org+101; i<304; i++) {
        UIImageView *imV = (UIImageView *)[_selImageView viewWithTag:i];
        
        UIButton *btn = (UIButton *)[_selImageView viewWithTag:i-100];
        btn.tag = i-101;
        
        imV.tag = i-1;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            imV.x = imV.x - (_selImageView.width-HDAutoWidth(40))/3-HDAutoWidth(20);
            
        } completion:nil];
        
    }
    
//    if(count!=dataArr.count){
//    
//    }
    
    [dataArr removeObjectAtIndex:index];
    [UIView animateWithDuration:0.5 animations:^{
        imgView.alpha = 0;
        btn.alpha = 0;
        
//        _addBtn.x =
        
        if(dataArr.count == 2){
            _addBtn.x = (_selImageView.width-HDAutoWidth(40))/3*2+HDAutoWidth(40);
        }else{
            _addBtn.x = _addBtn.x - (_selImageView.width-HDAutoWidth(40))/3-HDAutoWidth(20);
        }

        
    } completion:^(BOOL finished) {
        [imgView removeFromSuperview];
        [btn removeFromSuperview];
    }];
    
    
}




-(void)getLocate{
    
    if(appDelegate.LocatePermission == YES){
        _locService = [[BMKLocationService alloc]init];//定位功能的初始化
        _locService.delegate = self;//设置代理位self
        [_locService startUserLocationService];//启动定位服务
    }else{
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self getLocate];
        });
        
    }
    
}


#pragma mark - BMK_LocationDelegate 百度地图
/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"地图定位失败======%@",error);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
    
    //从manager获取左边
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;//位置坐标
    //存储经纬度
    //    [self.userLocationInfoModel SaveLocationCoordinate2D:coordinate];
    
    if ((userLocation.location.coordinate.latitude != 0 || userLocation.location.coordinate.longitude != 0))
    {
        
        
        //发送反编码请求
        //[self sendBMKReverseGeoCodeOptionRequest];
        
        NSString *latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
        [self reverseGeoCodeWithLatitude:latitude withLongitude:longitude];
        
    }else{
        NSLog(@"位置为空");
    }
    
    //关闭坐标更新
    [self.locService stopUserLocationService];
}

//地图定位
- (BMKLocationService *)locService
{
    if (!_locService)
    {
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
    }
    return _locService;
}

//检索对象
- (BMKGeoCodeSearch *)geocodesearch
{
    if (!_geocodesearch)
    {
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
        _geocodesearch.delegate = self;
    }
    return _geocodesearch;
}

#pragma mark ----反向地理编码
- (void)reverseGeoCodeWithLatitude:(NSString *)latitude withLongitude:(NSString *)longitude
{
    
    //发起反向地理编码检索
    
    CLLocationCoordinate2D coor;
    coor.latitude = [latitude doubleValue];
    coor.longitude = [longitude doubleValue];
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = coor;
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];;
    if (flag)
    {
        NSLog(@"反地理编码成功");//可注释
    }
    else
    {
        NSLog(@"反地理编码失败");//可注释
    }
}

//发送反编码请求
- (void)sendBMKReverseGeoCodeOptionRequest{
    
    self.isGeoSearch = false;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};//初始化
    if (_locService.userLocation.location.coordinate.longitude!= 0
        && _locService.userLocation.location.coordinate.latitude!= 0) {
        //如果还没有给pt赋值,那就将当前的经纬度赋值给pt
        pt = (CLLocationCoordinate2D){_locService.userLocation.location.coordinate.latitude,
            _locService.userLocation.location.coordinate.longitude};
    }
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];//初始化反编码请求
    reverseGeocodeSearchOption.reverseGeoPoint = pt;//设置反编码的店为pt
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];//发送反编码请求.并返回是否成功
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}


//发送成功,百度将会返回东西给你
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                          result:(BMKReverseGeoCodeResult *)result
                       errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        NSString *address1 = result.address; // result.addressDetail ///层次化地址信息
        NSLog(@"我的位置在 %@",address1);
        
        _locatLabel.text = address1;
        
//        _posiLabel.text = @"当前定位:";
//        
//        _posiContLabel.text = address1;
//        
//        needLocate = result.location;
//        model.nowPosi = address1;
//        model.Locate = needLocate;
//        
//        [self getTemp];
//        [self getQuality];
//        [self getAlert];
        //保存位置信息到模型
        //        [self.userLocationInfoModel saveLocationInfoWithBMKReverseGeoCodeResult:result];
        
        //进行缓存处理，上传到服务器等操作
    }
}

-(void)createLocateContent{
    
    _iconImageView = [[UIImageView alloc]init];
    _iconImageView.image = [UIImage imageNamed:@"地点"];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:_iconImageView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_mainTextView.mas_left);
        make.top.equalTo(_mainTextView.mas_bottom).offset(HDAutoHeight(10));
        make.width.equalTo(@(HDAutoWidth(30)));
        make.height.equalTo(@(HDAutoWidth(30)));
        
    }];
    
    _locatLabel = [[UILabel alloc]init];
    _locatLabel.text = @"";
    _locatLabel.textColor = [UIColor grayColor];
    _locatLabel.font = [UIFont systemFontOfSize:13];
    
    [self.view addSubview:_locatLabel];
    [_locatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(HDAutoWidth(10));
        make.right.equalTo(_mainTextView.mas_right);
        make.top.equalTo(_iconImageView.mas_top);
        make.height.equalTo(@(HDAutoWidth(40)));
    }];
    
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
