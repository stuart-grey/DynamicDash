//
//  SCMultiAxisCategoryDataSource.h
//  DynamicDash
//
//  Created by Sam Davies on 07/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShinobiCharts/ShinobiChart.h>

@interface SCMultiAxisCategoryDataSource : NSObject

- (instancetype)initWithChart:(ShinobiChart *)chart categories:(NSArray *)categories;

@property (nonatomic, strong, readonly) ShinobiChart *chart;
@property (nonatomic, strong, readonly) NSArray *categories;
@property (nonatomic, strong, readonly) NSArray *yAxes;

@property (nonatomic, strong, readonly) SChartLineSeries *lineSeries;
@property (nonatomic, strong, readonly) SChartColumnSeries *columnSeries;

- (void)animateToValues:(NSArray *)values;
- (void)animateToValuesInDictionary:(NSDictionary *)dict;
- (void)applyThemeColours:(NSArray *)themeColours;

@end
