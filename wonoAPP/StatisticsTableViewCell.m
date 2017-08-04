//
//  StatisticsTableViewCell.m
//  wonoAPP
//
//  Created by IF on 2017/7/21.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "StatisticsTableViewCell.h"
#import "Charts/Charts.h"


@interface StatisticsTableViewCell()<ChartViewDelegate>

@property (nonatomic,strong) UILabel *headLabel;
@property (strong, nonatomic) PieChartView *chartView;

@end


@implementation StatisticsTableViewCell{
    NSArray *dataArr;
    NSArray *percentArr;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        percentArr = [NSArray arrayWithObjects:[NSNumber numberWithDouble:20.0],[NSNumber numberWithDouble:30.0],[NSNumber numberWithDouble:40.0],[NSNumber numberWithDouble:10.0], nil];
        dataArr = [NSArray arrayWithObjects:@"土豆",@"黄瓜",@"西红柿",@"白菜", nil];
        [self createFirstPie];
        [self creatLabel];
    }
    return self;
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
    
    [self setDataCount:4 range:100];
    
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
        [values addObject:[[PieChartDataEntry alloc] initWithValue:real label:dataArr[i]]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@""];
    //    election results
    dataSet.sliceSpace = 2.0;
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
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

-(void)creatLabel{
    _headLabel = [[UILabel alloc]init];
    _headLabel.font = [UIFont systemFontOfSize:14];
    _headLabel.text = @"占地面积：320亩";
    _headLabel.textColor = UIColorFromHex(0x727171);
    [self addSubview:_headLabel];
    [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(HDAutoHeight(28));
        make.left.equalTo(self.mas_left).offset(HDAutoWidth(20));
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(HDAutoHeight(35)));
    }];
}


@end
