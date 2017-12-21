//
//  ToAskViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/28.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "ToAnswerViewController.h"
#import "UITextView+Placeholder.h"
#import "LimitInput.h"
#import "CustomActionSheet.h"
#import <AVFoundation/AVFoundation.h>
#import "QNUploader.h"
#import "UIImageView+MHFacebookImageViewer.h"

#import "WonoCircleDetailViewController.h"

# define COUNTDOWN 60

@interface ToAnswerViewController ()<UITextFieldDelegate,UITextViewDelegate,CustomActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QNUploaderDelegate>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UIButton *nextBtn;

@property (nonatomic,strong)UITextField *headTextField;

@property (nonatomic,strong)UITextView *mainTextView;

@property (nonatomic,strong)UIView *selImageView;

@property (nonatomic,strong)UIButton *addBtn;




@property (nonatomic,strong) UIImageView  *iconImageView;
@property (nonatomic,strong) UILabel *locatLabel;

@property (nonatomic,strong) UIView *botView;

@property (nonatomic,strong) UIButton *leftIconBtn;
@property (nonatomic,strong) UIButton *recoardBtn;

@property (nonatomic,strong) UIImageView *hubImgView;


@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器
@property (nonatomic, strong) AVAudioPlayer *player; //播放器
@property (nonatomic, strong) NSURL *recordFileUrl; //文件地址


@end

@implementation ToAnswerViewController{
    NSMutableArray *dataArr;
    CGRect frame1;
    CGRect frame2;
    CGRect frame3;
    CGRect frame4;
    
    int height;
    
    int imageMark;
    
    NSTimer *timer; //定时器
    NSInteger countDown;  //倒计时
    NSString *filePath;
    NSString *resultPath;
    
    
    NSMutableArray *imageUrlArr;
    NSString *audioUrl;
    
    int uploadImageCount;
    int audiouploadMark;
    
    int state2;
    
    NSInteger tempCountDown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    resultPath = @"";
    state2 = 0;
    uploadImageCount = 0;
    audiouploadMark = 0;
    tempCountDown = 0;
    imageUrlArr = [NSMutableArray array];
    audioUrl = @"";
    
    imageMark = 0;
    height = 0;
    dataArr = [NSMutableArray array];
    
    // Do any additional setup after loading the view.
    [self creatTitleAndBackBtn];
    [self createNextBtn];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self createFirstHead];
    [self creatMainTextView];
    
    
    
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
    
    
    _iconImageView.alpha = 0;
    _locatLabel.alpha = 0;
//    [self deleteFile];
    [self prepareRecoard];
    [self createBotView];
    [self createImageContent];
}

-(void)prepareRecoard{
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if (session == nil) {
        
        NSLog(@"Error creating session: %@",[sessionError description]);
        
    }else{
        [session setActive:YES error:nil];
        
    }
    
    self.session = session;
    
    
    //1.获取沙盒地址
    NSString *path = NSTemporaryDirectory();
    filePath = [path stringByAppendingString:@"/RRecord.wav"];
    resultPath = [path stringByAppendingString:@"/ReRecord.wav"];
    //2.获取文件路径
    self.recordFileUrl = [NSURL fileURLWithPath:resultPath];
    
    NSURL *ur = [NSURL fileURLWithPath:filePath];
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:ur settings:recordSetting error:nil];
    
    [self deleteFile];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
//    if(height == 0){
    
        height = keyboardRect.size.height;
        
//        [self createBotView];
//    }
    
    
    if(_botView!=nil){
        [UIView animateWithDuration:0.5 animations:^{
            _botView.y = SCREEN_HEIGHT - height - _botView.height;
            _botView.alpha = 1;
        }];
    }
    
    _leftIconBtn.selected = NO;
    [_mainTextView becomeFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        _recoardBtn.alpha = 0;
    }];

}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
//    [UIView animateWithDuration:0.5 animations:^{
//        _selImageView.y = SCREEN_HEIGHT - _selImageView.height-HDAutoHeight(40);
//    }];
    
    if(_botView!=nil){
        [UIView animateWithDuration:0.5 animations:^{
            _botView.y = SCREEN_HEIGHT - _botView.height;
            _botView.alpha = 1;
        }];
    }
    
}



-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"我来回答";
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
        make.height.equalTo(@(SafeAreaTopRealHeight));
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left).offset(15);
        make.top.equalTo(_headView.mas_top).offset(24+SafeAreaTopHeight);
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
    
    if(_iconImageView.alpha == 1||![_mainTextView.text isEqualToString:@""]||dataArr.count!=0){
    
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
    [_nextBtn setTitle:@"提交" forState:UIControlStateNormal];
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






- (NSString *)createGUID{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

-(void)createFirstHead{
    _headTextField = [[UITextField alloc]init];
    _headTextField.delegate = self;
    _headTextField.placeholder = @"请输入您的回答(120字以内)";
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
    _mainTextView.placeholder = @"请输入您的回答(120字以内)";
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
        
        make.left.equalTo(self.view.mas_left).offset(HDAutoWidth(30));
        make.right.equalTo(self.view.mas_right).offset(-HDAutoWidth(30));
        make.top.equalTo(_headView.mas_bottom).offset(HDAutoHeight(10));
        make.height.equalTo(@(HDAutoHeight(300)));
        
    }];
    [_mainTextView becomeFirstResponder];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [_headTextField resignFirstResponder];
//    [_mainTextView resignFirstResponder];
    _leftIconBtn.selected = YES;
    [_mainTextView resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        _recoardBtn.alpha = 1;
    }];
    
    
}

-(void)createImageContent{
    [_mainTextView layoutIfNeeded];
    [self.view layoutIfNeeded];
    _selImageView = [[UIView alloc]init];
    //    _selImageView.backgroundColor = [UIColor lightGrayColor];
    _selImageView.frame = CGRectMake(_mainTextView.x, _mainTextView.bottom+HDAutoHeight(20), _mainTextView.width, HDAutoHeight(155));
    
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
    
    _leftIconBtn.selected = YES;
//    [_mainTextView resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        _recoardBtn.alpha = 1;
    }];
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




-(void)createLocateContent{
    
    _iconImageView = [[UIImageView alloc]init];
    _iconImageView.image = [UIImage imageNamed:@"录制好的语音"];
    _iconImageView.contentMode = UIViewContentModeScaleToFill;
    
    _iconImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_iconImageView addGestureRecognizer:singleTap];

    
    [self.view addSubview:_iconImageView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_mainTextView.mas_left);
        make.top.equalTo(_mainTextView.mas_bottom).offset(HDAutoHeight(25));
        make.width.equalTo(@(HDAutoWidth(220)));
        make.height.equalTo(@(HDAutoWidth(65)));
        
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
        make.height.equalTo(@(HDAutoWidth(55)));
    }];
    
    
}

-(void)handleSingleTap:(UIGestureRecognizer *)ges{
    
    NSLog(@"qweqwe");
    
    [self PlayRecord];
    
}

-(void)createBotView{

    _botView = [[UIView alloc]init];
    _botView.backgroundColor = UIColorFromHex(0xefefef);
    _botView.frame = CGRectMake(0, SCREEN_HEIGHT -HDAutoHeight(100), SCREEN_WIDTH, HDAutoHeight(100));
    [self.view addSubview:_botView];
    _botView.alpha = 0;
//
//    [UIView animateWithDuration:0.5 animations:^{
//        _botView.alpha = 1;
//    }];
    _leftIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftIconBtn setImage:[UIImage imageNamed:@"话筒"] forState:UIControlStateNormal];
    [_leftIconBtn setImage:[UIImage imageNamed:@"键盘"] forState:UIControlStateSelected];
    [_leftIconBtn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    _leftIconBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _leftIconBtn.frame = CGRectMake(HDAutoWidth(24), HDAutoHeight(10), HDAutoHeight(70), HDAutoHeight(80));
    [_botView addSubview:_leftIconBtn];
    
    _recoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    [_recoardBtn setTitle:@"按住说话" forState:UIControlStateNormal];
//    
//    _recoardBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [_recoardBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    
////    _recoardBtn.layer.masksToBounds = YES;
//    _recoardBtn.layer.cornerRadius = 5;
//    _recoardBtn.layer.borderWidth = 1;
//    _recoardBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_recoardBtn setBackgroundImage:[UIImage imageNamed:@"按住说话"] forState:UIControlStateNormal];
    
    _recoardBtn.frame = CGRectMake((SCREEN_WIDTH- HDAutoWidth(500))/2, HDAutoHeight(10), HDAutoWidth(500), HDAutoHeight(80));
    
    [_recoardBtn addTarget:self action:@selector(QClick:) forControlEvents:UIControlEventTouchDown];
    [_recoardBtn addTarget:self action:@selector(WClick:) forControlEvents:UIControlEventTouchDragOutside];
    [_recoardBtn addTarget:self action:@selector(EClick:) forControlEvents:UIControlEventTouchDragInside];
    [_recoardBtn addTarget:self action:@selector(RClick:) forControlEvents:UIControlEventTouchUpInside];
    [_recoardBtn addTarget:self action:@selector(TClick:) forControlEvents:UIControlEventTouchUpOutside];
    [_botView addSubview:_recoardBtn];
    _recoardBtn.alpha = 0;
}

-(void)QClick:(UIButton *)btn{
    NSLog(@"点击按下");
    imageMark = 0;
    self.hubImgView.alpha=1;
    self.hubImgView.image = [UIImage imageNamed:@"正在语音"];
    [self.view addSubview:self.hubImgView];
    
    
    [self addTimer];
    [self startRecoard];
    
    [_recoardBtn setBackgroundImage:[UIImage imageNamed:@"松开结束"] forState:UIControlStateNormal];
    
}
-(void)WClick:(UIButton *)btn{
    NSLog(@"按下后拖出去");
    if(imageMark == 0){
        self.hubImgView.image = [UIImage imageNamed:@"松开手指取消发送"];
        [_recoardBtn setBackgroundImage:[UIImage imageNamed:@"松开手指取消发送（按住）"] forState:UIControlStateNormal];
        
    }
    imageMark = 1;
}
-(void)EClick:(UIButton *)btn{
    NSLog(@"按下后自里边");
    
    if(imageMark == 1){
        self.hubImgView.image = [UIImage imageNamed:@"正在语音"];
        [_recoardBtn setBackgroundImage:[UIImage imageNamed:@"松开结束"] forState:UIControlStateNormal];
    }
    imageMark = 0;
    
}
-(void)RClick:(UIButton *)btn{
    NSLog(@"确定");
    [_recoardBtn setBackgroundImage:[UIImage imageNamed:@"按住说话"] forState:UIControlStateNormal];
    if(countDown>=COUNTDOWN){
        return;
    }
    
    [timer invalidate];
    [self stopRecord];
    
    if(countDown>=1){
        [self.hubImgView removeFromSuperview];
        
        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:resultPath];
        if (blHave) {
            NSLog(@"already have");
            UIAlertController *alertCont = [UIAlertController alertControllerWithTitle:@"提示" message:@"将会覆盖上一次录音文件 是否确定" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self removeFile];
                _iconImageView.alpha = 0;
                _locatLabel.alpha = 0;
                NSString *str = [NSString stringWithFormat:@"%ld'",(long)countDown];
                _locatLabel.text = str;
                [self.view bringSubviewToFront:_botView];
//                _botView
                [UIView animateWithDuration:0.5 animations:^{
                    _iconImageView.alpha = 1;
                    _locatLabel.alpha = 1;
                    _selImageView.y = _mainTextView.bottom+HDAutoHeight(120);
                } completion:nil];
            }];
            UIAlertAction *refuse = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                countDown = tempCountDown;
            }];
            [alertCont addAction:refuse];
            [alertCont addAction:confirm];
            
            [self presentViewController:alertCont animated:YES completion:nil];
            return ;
        }
        
        [self removeFile];
        
        _iconImageView.alpha = 0;
        _locatLabel.alpha = 0;
        NSString *str = [NSString stringWithFormat:@"%ld'",(long)countDown];
        _locatLabel.text = str;
        [self.view bringSubviewToFront:_botView];
        [UIView animateWithDuration:0.5 animations:^{
            _iconImageView.alpha = 1;
            _locatLabel.alpha = 1;
            _selImageView.y = _mainTextView.bottom+HDAutoHeight(120);
        } completion:nil];
        
        
    }else{
        self.hubImgView.image = [UIImage imageNamed:@"时间过短"];
//        [UIView animateWithDuration:0.5 animations:^{
//            self.hubImgView.alpha=0;
//        } completion:^(BOOL finished) {
//            [self.hubImgView removeFromSuperview];
//        }];
        countDown = tempCountDown;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self.hubImgView removeFromSuperview];
        });
    }
    
    NSLog(@"%ld", (long)countDown);

    
}
-(void)TClick:(UIButton *)btn{
    NSLog(@"取消");
    [_recoardBtn setBackgroundImage:[UIImage imageNamed:@"按住说话"] forState:UIControlStateNormal];
    [self.hubImgView removeFromSuperview];
    NSLog(@"%ld", (long)countDown);
    [timer invalidate];
    [self stopRecord];
}


-(void)changeClick:(UIButton *)btn{
    
    if(btn.selected == NO){
        btn.selected = YES;
        [_mainTextView resignFirstResponder];
        [UIView animateWithDuration:0.5 animations:^{
            _recoardBtn.alpha = 1;
        }];
        
    }else{
        btn.selected = NO;
        [_mainTextView becomeFirstResponder];
        [UIView animateWithDuration:0.5 animations:^{
            _recoardBtn.alpha = 0;
        }];
        
    }
    
}

-(UIImageView *)hubImgView{
    
    if(_hubImgView == nil){
        _hubImgView = [[UIImageView alloc]init];
//        _hubImgView.image = [UIImage imageNamed:@"正在语音"];
        _hubImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        _hubImgView.width = HDAutoWidth(250);
        _hubImgView.height = HDAutoWidth(250);
        _hubImgView.center = self.view.center;
    }
    
    return _hubImgView;
}

-(void)addTimer{
    tempCountDown = countDown;
    countDown = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [timer fireDate];
    
    
}

-(void)timerFired{
    
    countDown++;
    
    if(countDown==COUNTDOWN){
        
        [self.hubImgView removeFromSuperview];
        [timer invalidate];
        [self stopRecord];
        [MBProgressHUD showSuccess:@"录音不得超过一分钟"];
        [self removeFile];
        _iconImageView.alpha = 0;
        _locatLabel.alpha = 0;
        NSString *str = [NSString stringWithFormat:@"%ld'",(long)countDown];
        _locatLabel.text = str;
        [self.view bringSubviewToFront:_botView];
        
        [UIView animateWithDuration:0.5 animations:^{
            _iconImageView.alpha = 1;
            _locatLabel.alpha = 1;
            
            _selImageView.y = _mainTextView.bottom+HDAutoHeight(120);
            
            
        } completion:nil];
        
    }

}

-(void)startRecoard{
    if (_recorder) {
        
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        

        
        
        
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
        
    }
    
   
}

- (void)stopRecord {
    
    [timer invalidate];
    NSLog(@"停止录音");
    
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        NSString *str = [NSString stringWithFormat:@"录了 %ld 秒,文件大小为 %.2fKb",COUNTDOWN - (long)countDown,[[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1024.0];
        NSLog(@"%@", str);
        
    }else{
        
//        _noticeLabel.text = @"最多录60秒";
        
    }
    
    
    
}


- (void)PlayRecord {
    
    NSLog(@"播放录音");
    [self.recorder stop];
    
    if ([self.player isPlaying])return;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:nil];
    
    
    
    NSLog(@"%li",self.player.data.length/1024);
    
    
    
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player play];
    
    
    
    
}


// 删除沙盒里的文件
-(void)deleteFile {
    NSFileManager* fileManager=[NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath= resultPath;
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}

-(void)removeFile{
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    BOOL result = [data writeToFile:resultPath atomically:YES];
    if (result) {
        NSLog(@"success");
    }else {
        NSLog(@"no success");
    }

}


-(void)SaveClick{
    NSLog(@"点击发送");
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:resultPath];
    
    
    //    UIImage *image = [UIImage imageNamed:@"年度收入与支出"];
    if(dataArr.count == 0&&blHave == false&&[_mainTextView.text isEqualToString:@""]){
        [MBProgressHUD showSuccess:@"请填写内容"];
        return;
    }
    
    _nextBtn.enabled = NO;
    imageUrlArr = [NSMutableArray array];
    audioUrl = @"";
    state2 = 0;
    [MBProgressHUD showLongSuccess:@"发送中" toView:self.view];
    
    if(dataArr.count == 0&&blHave == false){
        state2 = 1;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_mainTextView.text forKey:@"content"];
        
        NSString *json = [self DataTOjsonString:dic];
        
        [[InterfaceSingleton shareInstance].interfaceModel wonoAnswerWithQid:_askID AndContent:json WithRepID:nil WithCallBack:^(int state, id data, NSString *msg) {
            [MBProgressHUD hideHUDForView:self.view];
            _nextBtn.enabled = YES;
            if(state == 2000){
                NSLog(@"成功");
                [MBProgressHUD showSuccess:@"提交成功"];
                
                if([_turnMark isEqualToString:@"1"]){
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"wonoCircleRe" object:_askID];
                    WonoCircleDetailViewController *detailVC = [[WonoCircleDetailViewController alloc]init];
                    detailVC.qid = _askID;
                    [self.navigationController pushViewController:detailVC animated:YES];
                }else{
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"wonoCircleRe" object:_askID];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }else{
                [MBProgressHUD showSuccess:msg];
            }
            
            
        }];
        
        return;
    }
    
    if(dataArr.count == 0&&blHave == true){
        state2 = 2;
        //只有语音 可能存在描述的情况
        NSData *data = [NSData dataWithContentsOfFile:resultPath];
        
        if(data!=nil){
            QNUploader *uploader = [[QNUploader alloc] initWithUploadType:EQTT_Pic];
            uploader.delegate = self;
            
            NSString *name = [NSString stringWithFormat:@"%@.wav",[self createGUID]];
            
            [uploader addTaskWithFileData:data FileName:name];
        }
        
        return;
    }
    
    if(dataArr.count != 0&&blHave == false){
        state2 = 3;
        //只有图片 可能存在描述的情况
        for(int i=0;i<dataArr.count;i++){
            
            UIImage *image = dataArr[i];
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            
            QNUploader *uploader = [[QNUploader alloc] initWithUploadType:EQTT_Pic];
            uploader.delegate = self;
            
            NSString *name = [NSString stringWithFormat:@"%@.png",[self createGUID]];
            
            [uploader addTaskWithFileData:data FileName:name];
            
        }
        return;
        
    }
    
    if(dataArr.count != 0&&blHave == true){
        //图片 语音都有 可能存在描述的情况
        state2 = 4;
        
        NSData *data = [NSData dataWithContentsOfFile:resultPath];
        
        if(data!=nil){
            QNUploader *uploader = [[QNUploader alloc] initWithUploadType:EQTT_Pic];
            uploader.delegate = self;
            
            NSString *name = [NSString stringWithFormat:@"%@.wav",[self createGUID]];
            
            [uploader addTaskWithFileData:data FileName:name];
        }
        for(int i=0;i<dataArr.count;i++){
            
            UIImage *image = dataArr[i];
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            
            QNUploader *uploader = [[QNUploader alloc] initWithUploadType:EQTT_Pic];
            uploader.delegate = self;
            
            NSString *name = [NSString stringWithFormat:@"%@.png",[self createGUID]];
            
            [uploader addTaskWithFileData:data FileName:name];
            
        }
    }
    
    
    
    
    
}

-(void)UploadSuccessWithFileName:(NSString *)fileName{
//    [MBProgressHUD showSuccess:@"上传成功"];
    
    
    NSString *Url = [NSString stringWithFormat:@"http://ospirz9dn.bkt.clouddn.com/%@",fileName];
    if([Url containsString:@".wav"]){
        audioUrl = Url;
        
    }else{
        [imageUrlArr addObject:Url];
    }
    
    
    if(state2 == 2){
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_mainTextView.text forKey:@"content"];
        
        NSMutableDictionary *audioDic = [NSMutableDictionary dictionary];
        [audioDic setObject:audioUrl forKey:@"url"];
        NSString *str = [NSString stringWithFormat:@"%ld",(long)countDown];
        [audioDic setObject:str forKey:@"time"];
        
        [dic setObject:audioDic forKey:@"audio"];
        
        
        NSString *json = [self DataTOjsonString:dic];
        
        
        [[InterfaceSingleton shareInstance].interfaceModel wonoAnswerWithQid:_askID AndContent:json WithRepID:nil WithCallBack:^(int state, id data, NSString *msg) {
            _nextBtn.enabled = YES;
            [MBProgressHUD hideHUDForView:self.view];
            if(state == 2000){
                NSLog(@"成功");
                [MBProgressHUD showSuccess:@"提交成功"];
                if([_turnMark isEqualToString:@"1"]){
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"wonoCircleRe" object:_askID];
                    WonoCircleDetailViewController *detailVC = [[WonoCircleDetailViewController alloc]init];
                    detailVC.qid = _askID;
                    [self.navigationController pushViewController:detailVC animated:YES];
                }else{
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"wonoCircleRe" object:_askID];
                    [self.navigationController popViewControllerAnimated:YES];
                }

            }else{
                [MBProgressHUD showSuccess:msg];
            }
            
            
        }];
        
        
        
    }

    
    if(state2 ==3 ){
        
        if(imageUrlArr.count == dataArr.count){
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:_mainTextView.text forKey:@"content"];
            [dic setObject:imageUrlArr forKey:@"images"];
            
            NSString *json = [self DataTOjsonString:dic];
            
            
            [[InterfaceSingleton shareInstance].interfaceModel wonoAnswerWithQid:_askID AndContent:json WithRepID:nil WithCallBack:^(int state, id data, NSString *msg) {
                _nextBtn.enabled = YES;
                [MBProgressHUD hideHUDForView:self.view];
                if(state == 2000){
                    NSLog(@"成功");
                    [MBProgressHUD showSuccess:@"提交成功"];
                    if([_turnMark isEqualToString:@"1"]){
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"wonoCircleRe" object:_askID];
                        WonoCircleDetailViewController *detailVC = [[WonoCircleDetailViewController alloc]init];
                        detailVC.qid = _askID;
                        [self.navigationController pushViewController:detailVC animated:YES];
                    }else{
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"wonoCircleRe" object:_askID];
                        [self.navigationController popViewControllerAnimated:YES];
                    }

                }else{
                    [MBProgressHUD showSuccess:msg];
                }
                
                
            }];
            
        }
        
    }
    
    if(state2 == 4){
        
        if(imageUrlArr.count == dataArr.count&&![audioUrl isEqualToString:@""]){
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:_mainTextView.text forKey:@"content"];
            [dic setObject:imageUrlArr forKey:@"images"];
            NSMutableDictionary *audioDic = [NSMutableDictionary dictionary];
            [audioDic setObject:audioUrl forKey:@"url"];
            NSString *str = [NSString stringWithFormat:@"%ld",(long)countDown];
            [audioDic setObject:str forKey:@"time"];
            
            [dic setObject:audioDic forKey:@"audio"];
            
            NSString *json = [self DataTOjsonString:dic];
            
            
            [[InterfaceSingleton shareInstance].interfaceModel wonoAnswerWithQid:_askID AndContent:json WithRepID:nil WithCallBack:^(int state, id data, NSString *msg) {
                _nextBtn.enabled = YES;
                [MBProgressHUD hideHUDForView:self.view];
                if(state == 2000){
                    NSLog(@"成功");
                    [MBProgressHUD showSuccess:@"提交成功"];
                    if([_turnMark isEqualToString:@"1"]){
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"wonoCircleRe" object:_askID];
                        WonoCircleDetailViewController *detailVC = [[WonoCircleDetailViewController alloc]init];
                        detailVC.qid = _askID;
                        [self.navigationController pushViewController:detailVC animated:YES];
                    }else{
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"wonoCircleRe" object:_askID];
                        [self.navigationController popViewControllerAnimated:YES];
                    }

                }else{
                    [MBProgressHUD showSuccess:msg];
                }
                
                
            }];
            
            
        }
        
    }

    
    
    
    NSLog(@"%@", Url);
    NSLog(@"aaa");
    
    
}

-(void)UploadFailedWithFileName:(NSString *)fileName{
    [MBProgressHUD showSuccess:@"上传失败，请重试"];
    _nextBtn.enabled = YES;
    NSLog(@"bbb");
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


@end
