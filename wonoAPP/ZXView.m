//
//  ZXView.m
//  折线图
//
//  Created by iOS on 16/6/28.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import "ZXView.h"
#import "UIView+Extension.h"

//#define NedY HDAutoWidth(-80)

@interface ZXView ()
@property (nonatomic, strong) CAShapeLayer *lineChartLayer;
@property (nonatomic, strong)UIBezierPath * path1;
/** 渐变背景视图 */
@property (nonatomic, strong) UIView *gradientBackgroundView;
/** 渐变图层 */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
/** 颜色数组 */
@property (nonatomic, strong) NSMutableArray *gradientLayerColors;
@end
@implementation ZXView{
    NSArray *max;
    NSArray *min;
    NSArray *temp;
    NSArray *date;
    
}
static CGFloat bounceX = 20;
static CGFloat bounceY = 20;
static NSInteger countq = 0;
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
     //   self.my
        self.backgroundColor = [UIColor clearColor];
        
        
        //[self setNeedsDisplay];
    

        
    }
    return self;
}

-(void)setDataArray:(NSArray *)dataArray{
//    self.dataArray = [NSArray arrayWithArray:dataArray];
//    self.dataArray = dataArray;
    
    max = dataArray[0];
    min = dataArray[1];
    temp = dataArray[2];
    date = dataArray[3];
    
    
    [self createLabelX];
    //        [self createLabelY];
    [self drawGradientBackgroundView];
    //        [self setLineDash];
    
    [self dravLine];
    
    self.lineChartLayer.lineWidth = 2;
    [self.lineChartLayer addAnimation:nil forKey:@"strokeEnd"];
    
}

- (void)drawRect:(CGRect)rect{
       /*******画出坐标轴********/
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 2.0);
//    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
//    CGContextMoveToPoint(context, bounceX, bounceY);
//    CGContextAddLineToPoint(context, bounceX, rect.size.height - bounceY);
//    CGContextAddLineToPoint(context,rect.size.width -  bounceX, rect.size.height - bounceY);
//    CGContextStrokePath(context);
    
      }

#pragma mark 添加虚线
- (void)setLineDash{

    for (NSInteger i = 0;i < 6; i++ ) {
        CAShapeLayer * dashLayer = [CAShapeLayer layer];
          dashLayer.strokeColor = [UIColor whiteColor].CGColor;
        dashLayer.fillColor = [[UIColor clearColor] CGColor];
        // 默认设置路径宽度为0，使其在起始状态下不显示
        dashLayer.lineWidth = 1.0;


        UILabel * label1 = (UILabel*)[self viewWithTag:2000 + i];
        
        UIBezierPath * path = [[UIBezierPath alloc]init];
        path.lineWidth = 1.0;
        UIColor * color = [UIColor orangeColor];
        
        [color set];
 [path moveToPoint:CGPointMake( 0, label1.frame.origin.y - bounceY)];
 [path addLineToPoint:CGPointMake(self.frame.size.width - 2*bounceX,label1.frame.origin.y - bounceY)];
        CGFloat dash[] = {10,10};
        [path setLineDash:dash count:2 phase:10];
        [path stroke];
        dashLayer.path = path.CGPath;
        [self.gradientBackgroundView.layer addSublayer:dashLayer];
         }
}

#pragma mark 画折线图
- (void)dravLine{
    
    NSString *maxstr = max[0];
    NSString *minstr = min[0];
    
    int maxval = [maxstr intValue];
    int minval = [minstr intValue];
    
    float real = (float)(maxval + minval)/2;
    
    UILabel * label = (UILabel*)[self viewWithTag:1000];
    UIBezierPath * path = [[UIBezierPath alloc]init];
    path.lineWidth = 0.7;
    self.path1 = path;
    UIColor * color = [UIColor orangeColor];
    [color set];
    
   
    
    [path moveToPoint:CGPointMake( label.frame.origin.x - bounceX, (50 -real) /50 * (self.frame.size.height - bounceY*2 ) + _NedY)];
    
    
    
    UIView *pointView = [[UIView alloc]init];
    pointView.center = CGPointMake( label.frame.origin.x - bounceX, (50 -real) /50 * (self.frame.size.height - bounceY*2 ) + _NedY );
    pointView.width = HDAutoWidth(10);
    pointView.height = HDAutoWidth(10);
    pointView.layer.masksToBounds = YES;
    pointView.layer.cornerRadius = HDAutoWidth(5);
    pointView.x -= HDAutoWidth(5);
    pointView.y -= HDAutoWidth(5);
    
    pointView.backgroundColor = [UIColor orangeColor];
    
    [self.gradientBackgroundView addSubview:pointView];
    
    
    
    UILabel * falglabel = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x -15,_NedY + (50 -real) /50 * (self.frame.size.height - bounceY*2 )+ bounceY +4 , 30, 15)];
    //  falglabel.backgroundColor = [UIColor blueColor];
    falglabel.tag = 3000;
    
    falglabel.text = [NSString stringWithFormat:@"%d",minval];
    
    falglabel.font = [UIFont systemFontOfSize:8.0];
    
    falglabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel * falglabelTop = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x -15,_NedY+ (50 -real) /50 * (self.frame.size.height - bounceY*2 )+ bounceY -22 , 30, 15)];
    falglabelTop.textAlignment = NSTextAlignmentCenter;
    //  falglabel.backgroundColor = [UIColor blueColor];
    falglabelTop.tag = 4000;
    
    falglabelTop.text = [NSString stringWithFormat:@"%d",maxval];
    
    falglabelTop.font = [UIFont systemFontOfSize:8.0];

    [self addSubview:falglabelTop];
    
    
    [self addSubview:falglabel];
    
    //创建折现点标记
    for (NSInteger i = 1; i< max.count; i++) {
        
        NSString *maxstr2 = max[i];
        NSString *minstr2 = min[i];
        
        int maxval2 = [maxstr2 intValue];
        int minval2 = [minstr2 intValue];
        
        float real2 = (float)(maxval2 + minval2)/2;
        
        
        
        
        
        UILabel * label1 = (UILabel*)[self viewWithTag:1000 + i];
        CGFloat  arc = real2;
        [path addLineToPoint:CGPointMake(label1.frame.origin.x - bounceX, _NedY + (50 -arc) /50 * (self.frame.size.height - bounceY*2 ) )];
        
        UILabel * falglabel = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x -15,_NedY+ (50 -arc) /50 * (self.frame.size.height - bounceY*2 )+ bounceY +4 , 30, 15)];
        
        falglabel.textAlignment = NSTextAlignmentCenter;
        
        UIView *pointView = [[UIView alloc]init];
        
        pointView.center = CGPointMake(label1.frame.origin.x - bounceX,_NedY+  (50 -arc) /50 * (self.frame.size.height - bounceY*2 ));
        
        pointView.width = HDAutoWidth(10);
        pointView.height = HDAutoWidth(10);
        pointView.layer.masksToBounds = YES;
        pointView.layer.cornerRadius = HDAutoWidth(5);
        pointView.x -= HDAutoWidth(5);
        pointView.y -= HDAutoWidth(5);
        
        pointView.backgroundColor = [UIColor orangeColor];
        
        [self.gradientBackgroundView addSubview:pointView];
        
        
      //  falglabel.backgroundColor = [UIColor blueColor];
        falglabel.tag = 3000+ i;
        
        falglabel.text = [NSString stringWithFormat:@"%d",minval2];
        
        falglabel.font = [UIFont systemFontOfSize:8.0];
        [self addSubview:falglabel];
        
        UILabel * falglabelTop2 = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x -15 ,_NedY + (50 -arc) /50 * (self.frame.size.height - bounceY*2 ) + bounceY -22 , 30, 15)];
        //  falglabel.backgroundColor = [UIColor blueColor];
        falglabelTop2.textAlignment = NSTextAlignmentCenter;
        falglabelTop2.tag = 4000+i;
        
        falglabelTop2.text = [NSString stringWithFormat:@"%d",maxval2];
        
        falglabelTop2.font = [UIFont systemFontOfSize:8.0];
        
        [self addSubview:falglabelTop2];
        
    }
    // [path stroke];
    
    
    self.lineChartLayer = [CAShapeLayer layer];
    self.lineChartLayer.path = path.CGPath;
    self.lineChartLayer.strokeColor = [UIColor orangeColor].CGColor;
    self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    // 默认设置路径宽度为0，使其在起始状态下不显示
//    self.lineChartLayer.lineWidth = 0;
    self.lineChartLayer.lineCap = kCALineCapRound;
    self.lineChartLayer.lineJoin = kCALineJoinRound;
    
    [self.gradientBackgroundView.layer addSublayer:self.lineChartLayer];//直接添加导视图上
 //   self.gradientBackgroundView.layer.mask = self.lineChartLayer;//添加到渐变图层

}
#pragma mark 创建x轴的数据
- (void)createLabelX{
//    CGFloat  month = 12;
    for (NSInteger i = 0; i < max.count; i++) {
        UILabel * LabelMonth = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width)/max.count * i + bounceX , self.frame.size.height - bounceY + bounceY*0.3-HDAutoWidth(50), (self.frame.size.width - 2*bounceX)/max.count- 5, 20)];
 //       LabelMonth.backgroundColor = [UIColor greenColor];
        
        UILabel *labelMonth2 = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width)/max.count * i + bounceX , self.frame.size.height - bounceY + bounceY*0.3-HDAutoWidth(50), (self.frame.size.width - 2*bounceX)/max.count- 5, 20)];
        
        labelMonth2.x -= ((self.frame.size.width - 2*bounceX)/max.count- 5)/3;
        
        
        
        LabelMonth.tag = 1000 + i;
        
        NSString *dateStr = temp[i];
        
        NSString *realDate = [self featureWeekdayWithDate:dateStr];
        
        if(i==0){
            labelMonth2.text = @"昨天";
        }else if (i==1){
            labelMonth2.text = @"今天";
        }else if(i==2){
            labelMonth2.text = @"明天";
        }else{
            labelMonth2.text = realDate;
        }
        labelMonth2.numberOfLines = 0;
        labelMonth2.font = [UIFont systemFontOfSize:10];
//        LabelMonth.transform = CGAffineTransformMakeRotation(M_PI * 0.3);
//        LabelMonth.backgroundColor = [UIColor greenColor];
        NSString *imageStr = [NSString stringWithFormat:@"W%@",date[i]];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:imageStr];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.frame = CGRectMake((self.frame.size.width - 2*bounceX)/month * i + bounceX -5, self.frame.size.height - bounceY + bounceY*0.3, (self.frame.size.width - 2*bounceX)/month- 5, 20);
        

        
       
        [self addSubview:LabelMonth];
        [self addSubview:labelMonth2];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(HDAutoWidth(40)));
            make.height.equalTo(@(HDAutoWidth(40)));
            make.left.equalTo(labelMonth2.mas_left).offset(HDAutoWidth(-5));
            make.top.equalTo(labelMonth2.mas_bottom).offset(HDAutoHeight(5));
        }];
    }

}
#pragma mark 创建y轴数据
- (void)createLabelY{
    CGFloat Ydivision = 6;
    for (NSInteger i = 0; i < Ydivision; i++) {
        UILabel * labelYdivision = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height - 2 * bounceY)/Ydivision *i + bounceX, bounceY, bounceY/2.0)];
     //   labelYdivision.backgroundColor = [UIColor greenColor];
        labelYdivision.tag = 2000 + i;
        labelYdivision.text = [NSString stringWithFormat:@"%.0f",(Ydivision - i)*100];
         labelYdivision.font = [UIFont systemFontOfSize:10];
        [self addSubview:labelYdivision];
    }
}


#pragma mark 渐变的颜色
- (void)drawGradientBackgroundView {
    // 渐变背景视图（不包含坐标轴）
    self.gradientBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(bounceX, bounceY, self.bounds.size.width - bounceX*2, self.bounds.size.height - 2*bounceY)];
    self.gradientBackgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.gradientBackgroundView];
//    /** 创建并设置渐变背景图层 */
//    //初始化CAGradientlayer对象，使它的大小为渐变背景视图的大小
//    self.gradientLayer = [CAGradientLayer layer];
//    self.gradientLayer.frame = self.gradientBackgroundView.bounds;
//    //设置渐变区域的起始和终止位置（范围为0-1），即渐变路径
//    self.gradientLayer.startPoint = CGPointMake(0, 0.0);
//    self.gradientLayer.endPoint = CGPointMake(1.0, 0.0);
//    //设置颜色的渐变过程
//    self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithRed:253 / 255.0 green:164 / 255.0 blue:8 / 255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:251 / 255.0 green:37 / 255.0 blue:45 / 255.0 alpha:1.0].CGColor]];
//    self.gradientLayer.colors = self.gradientLayerColors;
//    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
//    [self.gradientBackgroundView.layer addSublayer:self.gradientLayer];
//     //[self.layer addSublayer:self.gradientLayer];
}




//#pragma mark 点击重新绘制折线和背景
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    countq++;
//    if (countq%2 == 0) {
//        [self.lineChartLayer removeFromSuperlayer];
//        for (NSInteger i = 0; i < 12; i++) {
//            UILabel * label = (UILabel*)[self viewWithTag:3000 + i];
//            [label removeFromSuperview];
//        }
//    }else{
//
//        [self dravLine];
//
//    self.lineChartLayer.lineWidth = 2;
//    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimation.duration = 3;
//    pathAnimation.repeatCount = 1;
//    pathAnimation.removedOnCompletion = YES;
//    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
//    // 设置动画代理，动画结束时添加一个标签，显示折线终点的信息
//    pathAnimation.delegate = self;
//    [self.lineChartLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
//        //[self setNeedsDisplay];
//    }
//}
//- (void)animationDidStart:(CAAnimation *)anim{
//    NSLog(@"开始®");
//}
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    NSLog(@"停止~~~~~~~~");
//}


- (NSString *)featureWeekdayWithDate:(NSString *)featureDate{
    // 创建 格式 对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置 日期 格式 可以根据自己的需求 随时调整， 否则计算的结果可能为 nil
    formatter.dateFormat = @"yyyy-MM-dd";
    // 将字符串日期 转换为 NSDate 类型
    NSDate *endDate = [formatter dateFromString:featureDate];
    // 判断当前日期 和 未来某个时刻日期 相差的天数
    long days = [self daysFromDate:[NSDate date] toDate:endDate];
    // 将总天数 换算为 以 周 计算（假如 相差10天，其实就是等于 相差 1周零3天，只需要取3天，更加方便计算）
    long day = days >= 7 ? days % 7 : days;
    long week = [self getNowWeekday] + day;
    week = week % 7;
    switch (week) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 0:
            return @"周六";
            break;
            
        default:
            break;
    }
    return nil;
}

-(NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //得到相差秒数
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/3600/60;
    if (days <= 0 && hours <= 0&&minute<= 0) {
        NSLog(@"0天0小时0分钟");
        return 0;
    }
    else {
        NSLog(@"%@",[[NSString alloc] initWithFormat:@"%i天%i小时%i分钟",days,hours,minute]);
        // 之所以要 + 1，是因为 此处的days 计算的结果 不包含当天 和 最后一天\
        （如星期一 和 星期四，计算机 算的结果就是2天（星期二和星期三），日常算，星期一——星期四相差3天，所以需要+1）\
        对于时分 没有进行计算 可以忽略不计
        return days + 1;
    }
}

// 获取当前是星期几
- (NSInteger)getNowWeekday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday];
}

@end
