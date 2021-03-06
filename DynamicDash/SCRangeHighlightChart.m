//
//  SCRangeHighlightChart.m
//  DynamicDash
//
//  Created by Sam Davies on 09/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCRangeHighlightChart.h"
#import "SCAnnotationAnimator.h"
#import "ShinobiRangeAnnotationManager.h"

@interface SCRangeHighlightChart () <SChartDatasource, ShinobiRangeAnnotationDelegate>

@property (nonatomic, strong) NSArray *datapoints;
@property (nonatomic, strong) SChartLineSeries *lineSeries;
@property (nonatomic, strong) ShinobiRangeAnnotationManager *rangeAnnotationManager;

@end

@implementation SCRangeHighlightChart


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self sharedInit];

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self  = [super initWithCoder:aDecoder];
    if(self) {
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit
{
    self.datasource = self;
    self.xAxis = [SChartDateTimeAxis new];
    self.yAxis = [SChartNumberAxis new];
    self.rangeAnnotationManager = [[ShinobiRangeAnnotationManager alloc] initWithChart:self minimumSpan:7*24*3600];
    self.rangeAnnotationManager.delegate = self;
    [self moveHighlightToDateRange:nil];
}

- (void)setData:(NSDictionary *)data
{
    NSMutableArray *dps = [NSMutableArray array];
    [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        SChartDataPoint *dp = [SChartDataPoint new];
        dp.xValue = key;
        dp.yValue = @([obj floatValue] / 1000.0);
        [dps addObject:dp];
    }];
    self.datapoints = [dps sortedArrayUsingComparator:^NSComparisonResult(SChartDataPoint *dp1, SChartDataPoint *dp2) {
        return [dp1.xValue compare:dp2.xValue];
    }];
}

- (void)applyColourTheme:(id<SCColourTheme>)theme
{
    self.backgroundColor = [UIColor clearColor];
    self.plotAreaBackgroundColor = [UIColor clearColor];
    self.canvasAreaBackgroundColor = [UIColor clearColor];
    self.lineSeries.style.lineColor = theme.midDarkColour;
    self.lineSeries.style.lineWidth = @4;
    self.xAxis.style.lineColor = theme.darkColour;
    self.xAxis.style.lineWidth = @2;
    self.xAxis.style.majorTickStyle.tickLabelOrientation = TickLabelOrientationHorizontal;
    self.yAxis.style.lineColor = theme.darkColour;
    self.yAxis.style.lineWidth = @2;
    self.xAxis.style.majorTickStyle.labelColor = theme.darkColour;
    self.yAxis.style.majorTickStyle.labelColor = theme.darkColour;
    
    self.rangeAnnotationManager.handleLineColor = theme.midDarkColour;
    self.rangeAnnotationManager.outerRangeColor = [theme.lightColour colorWithAlphaComponent:0.4];
    self.rangeAnnotationManager.innerRangeColor = [UIColor clearColor];
    
    self.titleLabel.backgroundColor = theme.midLightColour;
    
    [self redrawChart];
}

- (void)moveHighlightToDateRange:(SChartDateRange *)range
{
    [self.rangeAnnotationManager moveRangeSelectorToRange:range];
}

- (SChartLineSeries *)lineSeries
{
    if (!_lineSeries) {
        _lineSeries = [SChartLineSeries new];
    }
    return _lineSeries;
}

#pragma mark - SChartDatasource methods
- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart
{
    return 1;
}

- (SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index
{
    return self.lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex
{
    return [self.datapoints count];
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex
{
    return self.datapoints[dataIndex];
}

#pragma mark - ShinobiRangeAnnotationDelegate methods
- (void)rangeAnnotation:(ShinobiRangeAnnotationManager *)annotation
         didMoveToRange:(SChartRange *)range
     animationCompleted:(BOOL)completed
{
    if(completed) {
        if(self.rangeDelegate &&
           [self.rangeDelegate respondsToSelector:@selector(rangeHighlightChart:didSelectDateRange:)]) {
            // Need to convert the range :(
            SChartDateRange *dateRange = [[SChartDateRange alloc] initWithMinimum:range.minimum
                                                                       andMaximum:range.maximum];
            [self.rangeDelegate rangeHighlightChart:self didSelectDateRange:dateRange];
        }
    }
}

@end
