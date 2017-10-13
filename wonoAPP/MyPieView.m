//
//  StatisticsTableViewCell.m
//  wonoAPP
//
//  Created by IF on 2017/7/21.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "MyPieView.h"
#import "Charts/Charts.h"


@interface MyPieView()<ChartViewDelegate>

@property (nonatomic,strong) UILabel *headLabel;
@property (strong, nonatomic) PieChartView *chartView;

@end


@implementation MyPieView{
    NSArray *dataArr;
    NSArray *percentArr;
}



-(void)tapClick{
    NSLog(@"qweqwe");
}

-(void)createFirstPie{
    
    self.chartView = [[PieChartView alloc]init];
    //    self.chartView.frame = CGRectMake(20, 84, 300, 300);
    [self addSubview:self.chartView];
    //    self.chartView.backgroundColor = [UIColor orangeColor];
    
    _chartView.delegate = self;
    
    
    //    ChartLegend *l = _chartView.legend;
    //    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    //    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    //    l.orientation = ChartLegendOrientationVertical;
    //    l.drawInside = NO;
    //    l.xEntrySpace = 7.0;
    //    l.yEntrySpace = 0.0;
    //    l.yOffset = 0.0;
    
    // entry label styling
    _chartView.entryLabelColor = UIColor.whiteColor;
    _chartView.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    
    //    _sliderX.value = 4.0;
    //    _sliderY.value = 100.0;
    //    [self slidersValueChanged:nil];
    
    [_chartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    
    NSArray *arr = _model.nameArr;
    [self setDataCount:arr.count range:100];
    
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(HDAutoHeight(50));
        make.bottom.equalTo(self.mas_bottom).offset(HDAutoHeight(10));
        make.width.equalTo(self.mas_width);
    }];
    
}


- (void)setDataCount:(int)count range:(double)range
{
    //    double mult = range;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        NSNumber *resNum = percentArr[i];
        double real = [resNum doubleValue];
        if([dataArr[i] isEqual:[NSNull null]]){
            [values addObject:[[PieChartDataEntry alloc] initWithValue:real label:@"未知"]];
         }else{
            [values addObject:[[PieChartDataEntry alloc] initWithValue:real label:dataArr[i]]];
         }
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@""];
    //    election results
    dataSet.sliceSpace = 2.0;
    
    // add a lot of colors
    
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    if(_model.colorArr){
    
        NSArray *arr = _model.colorArr;
        for(int i=0;i<arr.count;i++){
            [colors addObject:arr[i]];
        }
    }else{
    
//        [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
        [colors addObjectsFromArray:ChartColorTemplates.joyful];
        [colors addObjectsFromArray:ChartColorTemplates.colorful];
        [colors addObjectsFromArray:ChartColorTemplates.liberty];
        [colors addObjectsFromArray:ChartColorTemplates.pastel];
        [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    }
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    _chartView.data = data;
    [_chartView highlightValues:nil];
}
#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

- (void)chartTranslated:(ChartViewBase * _Nonnull)chartView dX:(CGFloat)dX dY:(CGFloat)dY{
    NSLog(@"aaa");
}

- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY{
    NSLog(@"qwe");
}

-(void)creatLabel{
    _headLabel = [[UILabel alloc]init];
    _headLabel.font = [UIFont systemFontOfSize:14];
    _headLabel.text = _model.title;
    _headLabel.textColor = UIColorFromHex(0x727171);
    [self addSubview:_headLabel];
    [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(HDAutoHeight(28));
        make.left.equalTo(self.mas_left).offset(HDAutoWidth(20));
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(HDAutoHeight(35)));
    }];
}

-(void)setModel:(PercentModel *)model{
    
//    if(_model == nil){
    
        _model = model;
        
        dataArr = model.nameArr;
    NSMutableArray *perArr = [NSMutableArray array];
    float total = _model.total;
    for (int i=0; i<_model.nameArr.count; i++) {
        float tem = [_model.amountArr[i]floatValue];
        float res = tem/total *100;
        NSString *str = [NSString stringWithFormat:@"%f",res];
        [perArr addObject:str];
    }
    _model.percentArr = perArr;
    
    
        percentArr = perArr;
        
        //    _headLabel.text = model.title;
        
        [self createFirstPie];
        [self creatLabel];
//    }
    
}





@end
