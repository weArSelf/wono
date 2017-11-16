//
//  MyZView.m
//  wonoAPP
//
//  Created by IF on 2017/8/1.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "MyZView.h"

#define BorX HDAutoWidth(40)

#define LineColor UIColorFromHex(0xff8585)

#define LineColor2 UIColorFromHex(0x00479d)

@interface MyZView ()

@property (nonatomic, strong) CAShapeLayer *lineLayer;

@property (nonatomic, strong) UIScrollView *BackgroundView;

@end


@implementation MyZView


- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.BackgroundView = [[UIScrollView alloc]initWithFrame:self.frame];
        self.BackgroundView.y=0;
        self.BackgroundView.x=0;
        self.BackgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.BackgroundView];
        [self createTitle];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame AndData:(NSMutableArray *)arr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.BackgroundView = [[UIScrollView alloc]initWithFrame:self.frame];
        self.BackgroundView.y=0;
        self.BackgroundView.x=0;
        self.BackgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.BackgroundView];
        [self createTitle];
        
        _dataArr = arr;
        [self drawView];
        [self drawView2];
        
    }
    return self;
}

-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self drawView];
    [self drawView2];
}





-(void)drawView{
    
    if(_maxVal!=100){
        
        _maxVal = -200;
        _minVal = 200;
        
        for (int i=0; i<_dataArr.count; i++) {
            PointModel *mod = _dataArr[i];
            if(mod.Height>=mod.Height2){
                if(mod.Height>_maxVal){
                    _maxVal = mod.Height;
                }
                if(mod.Height2<_minVal){
                    _minVal = mod.Height2;
                }
            }else{
                
                if(mod.Height2>_maxVal){
                    _maxVal = mod.Height2;
                }
                if(mod.Height<_minVal){
                    _minVal = mod.Height;
                }
                
            }
        }
        
        _maxVal = _maxVal*1.3;
        
    }
    
    
    
    float cen = _maxVal -_minVal;
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    path.lineWidth = 0.7;
    
    path.lineCapStyle = kCGLineCapRound;
    
    
    PointModel *firM = _dataArr[0];
    
    float nowHeight = firM.Height - _minVal;
    
    CGPoint orginP = CGPointMake(BorX, HDAutoHeight(100)+(self.height-HDAutoHeight(210))*(cen-nowHeight)/cen);
    
    UIView *pointView = [[UIView alloc]init];
    pointView.center = orginP;
    pointView.width = HDAutoWidth(10);
    pointView.height = HDAutoWidth(10);
    pointView.backgroundColor = LineColor;
    pointView.y-=HDAutoWidth(5);
    pointView.x-=HDAutoWidth(5);
    pointView.layer.cornerRadius = HDAutoWidth(5);
    [self.BackgroundView addSubview:pointView];
    
    UILabel *pointLabel = [[UILabel alloc]init];
    pointLabel.textAlignment = NSTextAlignmentCenter;
    pointLabel.textColor = [UIColor grayColor];
    
    int val = [firM.firstBottomStr intValue];
    NSString *restr = [NSString stringWithFormat:@"%d",val];
    if(_maxVal == 100){
        restr = [NSString stringWithFormat:@"%d%%",val];
    }
    
    float length = [self getLengthWithFont:12 AndText:restr];
    
    pointLabel.text = restr;
    pointLabel.font = [UIFont systemFontOfSize:11];
    pointLabel.center = orginP;
    
    pointLabel.width = length;
    pointLabel.height = HDAutoHeight(40);
    
    pointLabel.y -= HDAutoHeight(55);
    pointLabel.x -=length/2;
    
    [self.BackgroundView addSubview:pointLabel];
    
    [path moveToPoint:orginP];
    
    
    if(_dataArr.count>10){
        
        _BackgroundView.contentSize = CGSizeMake((self.width - BorX*2)*(_dataArr.count)/(9), self.height);
        
    }
    
    
    for(int i = 1;i<_dataArr.count;i++){
        
        PointModel *nowM = _dataArr[i];
        
        float realX = BorX + (self.width - BorX*2)*i/(_dataArr.count-1);
        
        //        if(_dataArr.count>10){
        realX = BorX + i*(self.width - BorX*2)/(9);
        //        }
        
        float nowHeight2 = nowM.Height - _minVal;
        
        //        CGPoint orginP = CGPointMake(BorX, HDAutoHeight(60)+(self.height-HDAutoHeight(140))*(cen-nowHeight)/cen);
        
        CGPoint nowP = CGPointMake(realX,HDAutoHeight(100)+(self.height-HDAutoHeight(210))*(cen-nowHeight2)/cen);
        
        
        UIView *pointView = [[UIView alloc]init];
        pointView.center = nowP;
        pointView.width = HDAutoWidth(10);
        pointView.height = HDAutoWidth(10);
        pointView.backgroundColor = LineColor;
        pointView.y-=HDAutoWidth(5);
        pointView.x-=HDAutoWidth(5);
        pointView.layer.cornerRadius = HDAutoWidth(5);
        [self.BackgroundView addSubview:pointView];
        
        
        UILabel *pointLabel = [[UILabel alloc]init];
        pointLabel.textAlignment = NSTextAlignmentCenter;
        pointLabel.textColor = [UIColor grayColor];
        
        int val = [nowM.firstBottomStr intValue];
        NSString *restr2 = [NSString stringWithFormat:@"%d",val];
        if(_maxVal == 100){
            restr2 = [NSString stringWithFormat:@"%d%%",val];
        }
        float length2 = [self getLengthWithFont:12 AndText:restr2];
        
        pointLabel.text = restr2;
        pointLabel.font = [UIFont systemFontOfSize:11];
        pointLabel.center = nowP;
        
        pointLabel.width = length2;
        pointLabel.height = HDAutoHeight(40);
        
        pointLabel.y -= HDAutoHeight(55);
        pointLabel.x -=length2/2;
        
        //        if(_dataArr.count>3){
        //
        //            if(i==_dataArr.count-1){
        //                pointLabel.x = SCREEN_WIDTH - pointLabel.width-HDAutoWidth(10);
        //    //            pointLabel.textAlignment = NSTextAlignmentRight;
        //            }
        //
        //        }
        
        [self.BackgroundView addSubview:pointLabel];
        
        
        [path addLineToPoint:nowP];
        
    }
    
    
    //    [path addLineToPoint:CGPointMake(100, 100)];
    //    [path addLineToPoint:CGPointMake(200, 400)];
    
    [path stroke];
    
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.path = path.CGPath;
    self.lineLayer.strokeColor = LineColor.CGColor;
    self.lineLayer.fillColor = [UIColor clearColor].CGColor;
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.lineJoin = kCALineJoinRound;
    [self.BackgroundView.layer addSublayer:self.lineLayer];
    
    
}


-(void)drawView2{
    
//    _maxVal = -200;
//    _minVal = 200;
    
//    for (int i=0; i<_dataArr.count; i++) {
//        PointModel *mod = _dataArr[i];
//        if(mod.Height>=mod.Height2){
//            if(mod.Height>_maxVal){
//                _maxVal = mod.Height;
//            }
//            if(mod.Height2<_minVal){
//                _minVal = mod.Height2;
//            }
//        }else{
//
//            if(mod.Height2>_maxVal){
//                _maxVal = mod.Height2;
//            }
//            if(mod.Height<_minVal){
//                _minVal = mod.Height;
//            }
//
//        }
//    }
//
//    _maxVal = _maxVal*1.3;
    
    
    
    float cen = _maxVal -_minVal;
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    path.lineWidth = 0.7;
    
    path.lineCapStyle = kCGLineCapRound;
    
    
    PointModel *firM = _dataArr[0];
    
    float nowHeight = firM.Height2 - _minVal;
    
    CGPoint orginP = CGPointMake(BorX, HDAutoHeight(100)+(self.height-HDAutoHeight(210))*(cen-nowHeight)/cen);
    
    //    CGPoint orginP = CGPointMake(BorX, HDAutoHeight(60)+(self.height-HDAutoHeight(140))*(50-firM.Height2)/60);
    
    UIView *pointView = [[UIView alloc]init];
    pointView.center = orginP;
    pointView.width = HDAutoWidth(10);
    pointView.height = HDAutoWidth(10);
    pointView.backgroundColor = LineColor2;
    pointView.y-=HDAutoWidth(5);
    pointView.x-=HDAutoWidth(5);
    pointView.layer.cornerRadius = HDAutoWidth(5);
    [self.BackgroundView addSubview:pointView];
    
    
    UILabel *pointLabel = [[UILabel alloc]init];
    pointLabel.textAlignment = NSTextAlignmentCenter;
    pointLabel.textColor = [UIColor grayColor];
    
    
    int val = [firM.nextBottomStr intValue];
    NSString *restr = [NSString stringWithFormat:@"%d",val];
    if(_maxVal == 100){
        restr = [NSString stringWithFormat:@"%d%%",val];
    }
    float length = [self getLengthWithFont:12 AndText:restr];
    
    pointLabel.text = restr;
    //    pointLabel.text = firM.nextBottomStr;
    pointLabel.font = [UIFont systemFontOfSize:11];
    pointLabel.center = orginP;
    
    pointLabel.width = length;
    pointLabel.height = HDAutoHeight(40);
    
    pointLabel.y += HDAutoHeight(5);
    pointLabel.x -=length/2;
    
    [self.BackgroundView addSubview:pointLabel];
    
    
    UILabel *bottomLabel = [[UILabel alloc]init];
    bottomLabel.font = [UIFont systemFontOfSize:12];
    bottomLabel.textColor = [UIColor grayColor];
    bottomLabel.text =firM.lineName;
    //    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.numberOfLines = 0;
    
    //    [self setLabelSpace:bottomLabel withValue: firM.lineName withFont:[UIFont systemFontOfSize:13]];
    
    CGFloat height = [self getSpaceLabelHeight:firM.lineName withFont:[UIFont systemFontOfSize:13] withWidth:HDAutoWidth(60)];
    
    
    
    
    bottomLabel.frame = CGRectMake(BorX-HDAutoWidth(30), self.height -HDAutoHeight(80) , HDAutoWidth(70), HDAutoHeight(80));
    
    
    [self.BackgroundView addSubview:bottomLabel];
    
    [path moveToPoint:orginP];
    
    for(int i = 1;i<_dataArr.count;i++){
        
        PointModel *nowM = _dataArr[i];
        
        float realX = BorX + (self.width - BorX*2)*i/(_dataArr.count-1);
        
        //        if(_dataArr.count>10){
        realX = BorX + i*(self.width - BorX*2)/(9);
        //        }
        
        float nowHeight = nowM.Height2 - _minVal;
        
        CGPoint nowP = CGPointMake(realX, HDAutoHeight(100)+(self.height-HDAutoHeight(210))*(cen-nowHeight)/cen);
        
        //        CGPoint nowP = CGPointMake(realX, HDAutoHeight(60)+(self.height-HDAutoHeight(140))*(50-nowM.Height2)/60);
        
        
        UIView *pointView = [[UIView alloc]init];
        pointView.center = nowP;
        pointView.width = HDAutoWidth(10);
        pointView.height = HDAutoWidth(10);
        pointView.backgroundColor = LineColor2;
        pointView.y-=HDAutoWidth(5);
        pointView.x-=HDAutoWidth(5);
        pointView.layer.cornerRadius = HDAutoWidth(5);
        [self.BackgroundView addSubview:pointView];
        
        
        UILabel *pointLabel = [[UILabel alloc]init];
        pointLabel.textAlignment = NSTextAlignmentCenter;
        pointLabel.textColor =[UIColor grayColor];
        
        int val = [nowM.nextBottomStr intValue];
        NSString *restr2 = [NSString stringWithFormat:@"%d",val];
        if(_maxVal == 100){
            restr2 = [NSString stringWithFormat:@"%d%%",val];
        }
        float length2 = [self getLengthWithFont:12 AndText:restr2];
        
        pointLabel.text = restr2;
        pointLabel.font = [UIFont systemFontOfSize:11];
        pointLabel.center = nowP;
        
        pointLabel.width = length2;
        pointLabel.height = HDAutoHeight(40);
        
        pointLabel.y += HDAutoHeight(5);
        pointLabel.x -=length2/2;
        
        //        if(_dataArr.count>3){
        //
        //            if(i==_dataArr.count-1){
        //                pointLabel.x = SCREEN_WIDTH - pointLabel.width-HDAutoWidth(10);
        //                //            pointLabel.textAlignment = NSTextAlignmentRight;
        //            }
        //
        //        }
        
        [self.BackgroundView addSubview:pointLabel];
        
        
        UILabel *bottomLabel = [[UILabel alloc]init];
        bottomLabel.font = [UIFont systemFontOfSize:12];
        bottomLabel.textColor = [UIColor grayColor];
        bottomLabel.text =nowM.lineName;
        //        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        bottomLabel.numberOfLines = 0;
        //        [self setLabelSpace:bottomLabel withValue: nowM.lineName withFont:[UIFont systemFontOfSize:13]];
        
        CGFloat height = [self getSpaceLabelHeight:nowM.lineName withFont:[UIFont systemFontOfSize:13] withWidth:HDAutoWidth(60)];
        
        
        bottomLabel.frame = CGRectMake(realX-HDAutoWidth(30), self.height  - HDAutoHeight(80) , HDAutoWidth(70),HDAutoHeight(80));
        
        
        [self.BackgroundView addSubview:bottomLabel];
        
        
        [path addLineToPoint:nowP];
        
    }
    
    
    //    [path addLineToPoint:CGPointMake(100, 100)];
    //    [path addLineToPoint:CGPointMake(200, 400)];
    
    [path stroke];
    
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.path = path.CGPath;
    self.lineLayer.strokeColor = LineColor2.CGColor;
    self.lineLayer.fillColor = [UIColor clearColor].CGColor;
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.lineJoin = kCALineJoinRound;
    [self.BackgroundView.layer addSublayer:self.lineLayer];
    
    
    
    
}

-(void)createTitle{
    
    UIView *firView = [[UIView alloc]init];
    firView.backgroundColor = LineColor;
    firView.layer.cornerRadius = HDAutoWidth(10);
    
    UIView *secView = [[UIView alloc]init];
    secView.backgroundColor = LineColor2;
    secView.layer.cornerRadius = HDAutoWidth(10);
    
    
    UILabel *firLabel = [[UILabel alloc]init];
    firLabel.font = [UIFont systemFontOfSize:13];
    firLabel.textColor = [UIColor whiteColor];
    
    firLabel.tag = 350;
    
    firLabel.text = @"气温";
    UILabel *secLabel = [[UILabel alloc]init];
    secLabel.font = [UIFont systemFontOfSize:13];
    secLabel.textColor = [UIColor whiteColor];
    secLabel.text = @"地温";
    
    secLabel.tag = 351;
    
    float wid = [self getLengthWithFont:14 AndText:@"气温"];
    
    firView.frame = CGRectMake(HDAutoWidth(510), HDAutoHeight(45), HDAutoWidth(20), HDAutoWidth(20));
    firLabel.frame = CGRectMake(HDAutoWidth(540), HDAutoHeight(45), wid, HDAutoHeight(30));
    firView.centerY = firLabel.centerY;
    
    secView.frame = CGRectMake(HDAutoWidth(550)+wid, HDAutoHeight(45), HDAutoWidth(20), HDAutoWidth(20));
    secLabel.frame = CGRectMake(HDAutoWidth(580)+wid, HDAutoHeight(45), wid, HDAutoHeight(30));
    secView.centerY = secLabel.centerY;
    
    
    
    [self addSubview:firView];
    [self addSubview:secView];
    [self addSubview:firLabel];
    [self addSubview:secLabel];
    [firLabel sizeThatFits:CGSizeZero];
    [secLabel sizeThatFits:CGSizeZero];
    
    
    
}
-(float)getLengthWithFont:(int)font AndText:(NSString *)text{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:font]};
    CGSize size=[text sizeWithAttributes:attrs];
    return size.width;
}
-(void)changeTitle{

    UILabel *label = (UILabel *)[self viewWithTag:350];
    label.text = @"气湿";
    UILabel *label2 = (UILabel *)[self viewWithTag:351];
    label2.text = @"地湿";
    
}




-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = HDAutoHeight(6);
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, [ [ UIScreen mainScreen ] bounds ].size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = HDAutoHeight(6); //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}





@end
