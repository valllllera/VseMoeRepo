//
//  AGPlotTableController.m
//  AllMine
//
//  Created by Allgoritm LLC on 14.12.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGPlotTableViewController.h"

#import "NSString+AGExtensions.h"
#import "Category+EntityWorker.h"

#import <QuartzCore/QuartzCore.h>
#import "UIColor+AGExtensions.h"

@interface AGPlotTableViewController ()
@property(nonatomic, strong) NSArray* data;

@property(nonatomic, assign) double sumMin;
@property(nonatomic, assign) double sumMax;
@property(nonatomic, assign) double sumRange;

@property (nonatomic, assign) double sumTotal;

@property(nonatomic, assign) double pointZeroX;
@property(nonatomic, assign) double dx;
@property(nonatomic, assign) AGPlotTableCellStyle cellStyle;

@end

@implementation AGPlotTableViewController

@synthesize type;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.tableView.frame = frame;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _cellStyle = AGPlotSigned;
}

#pragma mark - reload
- (void) reloadData:(NSArray*)data{
    _data = [NSArray arrayWithArray:[self sortData:data]];
    _sumMax = 0;
    _sumMin = 0;
    _sumTotal = 0;
    for (NSDictionary* dict in _data) {
        double sum = [[dict objectForKey:kReportFieldSum] doubleValue];
        if (sum > _sumMax) {
            _sumMax = sum;
        }
        if (sum < _sumMin) {
            _sumMin = sum;
        }
        _sumTotal += fabs(sum);
    }
    
    _cellStyle = AGPlotSigned;
    if ((_sumMax == 0) && (_sumMin < 0)) {
        _cellStyle = AGPlotUnSigned;
    }
    if ((_sumMin == 0) && (_sumMax >= 0)) {
        _cellStyle = AGPlotUnSigned;
    }
    
    if (self.cellStyle == AGPlotSigned) {
        if (self.sumMax > self.sumMin) {
            _sumRange = 2*abs(_sumMax);
            self.sumMin = -self.sumMax;
        }else{
            _sumRange = 2*abs(_sumMin);
            self.sumMax = -self.sumMin;
        }
    }else{
        _sumRange = abs(_sumMax) + abs(_sumMin);
    }
    double tmp = _sumRange*0.05f;
    _sumRange += tmp*2;
    _dx = self.tableView.frame.size.width / _sumRange;
    if (_cellStyle==AGPlotUnSigned) {
        _dx = (self.tableView.frame.size.width-100) / _sumRange;
    }
    _pointZeroX = _dx * (abs(_sumMin)+tmp);
    
    [self.tableView reloadData];
    [self drawBackground];
}

- (NSArray *)sortData:(NSArray *)data
{
    return [data sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        
        if(self.cellStyle == AGPlotUnSigned)
        {
            if(ABS([[obj1 objectForKey:kReportFieldSum] doubleValue]) > ABS([[obj2 objectForKey:kReportFieldSum] doubleValue]))
            {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }
        else
        {
            if([[obj1 objectForKey:kReportFieldSum] doubleValue] > [[obj2 objectForKey:kReportFieldSum] doubleValue])
            {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }
        
    }];
}

- (void) drawBackground{
    //    UIGraphicsBeginImageContext(self.tableView.frame.size);
    CGRect frame = self.tableView.frame;
    double scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContext(CGSizeMake(frame.size.width * scale, frame.size.height * scale));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    double interval = 1;
    float tmp = _sumRange;
    while (((float)(tmp /= 10)) > 2.2) {
        interval *= 10;
    }
    interval *= _dx;
    
    if (context != nil) {
        CGContextSetStrokeColorWithColor(context, [[UIColor colorWithHex:kColorHexWhite] CGColor]);
        CGFloat dashes[] = {2,1};
        CGContextSetLineDash(context, 0.0, dashes, 2);
        CGContextSetLineWidth(context, 0.5);
        
        CGRect rect = self.tableView.frame;
        //        double yTop = 10;
        //        double yBottom = rect.size.height - 10;
        double yTop = 0;
        double yBottom = rect.size.height;
        double xLeft = 0;
        double xRight=0;
        if (_cellStyle==AGPlotSigned) {
            xRight= rect.size.width;
        }
        else
        {
            xRight= rect.size.width - 100;
        }
        
        CGContextMoveToPoint(context, _pointZeroX * scale, yTop * scale);
        if(IS_IOS7)
        {
            if(!isnan(_pointZeroX))
            {
                CGContextAddLineToPoint(context, _pointZeroX * scale, yBottom * scale);
            }
        }
        else
        {
            CGContextAddLineToPoint(context, _pointZeroX * scale, yBottom * scale);
        }
        double x = _pointZeroX + interval;
        while (x < xRight) {
            CGContextMoveToPoint(context, x * scale, yTop * scale);
            CGContextAddLineToPoint(context, x * scale, yBottom * scale);
            x += interval;
        }
        x = _pointZeroX - interval;
        while (x > xLeft) {
            CGContextMoveToPoint(context, x * scale, yTop * scale);
            CGContextAddLineToPoint(context, x * scale, yBottom * scale);
            x -= interval;
        }
        CGContextStrokePath(context);
        
        CGContextSetStrokeColorWithColor(context, [[UIColor colorWithHex:kColorHexGray] CGColor]);
        x = _pointZeroX + interval/2;
        while (x < xRight) {
            CGContextMoveToPoint(context, x * scale, yTop * scale);
            CGContextAddLineToPoint(context, x * scale, yBottom * scale);
            x += interval;
        }
        x = _pointZeroX - interval/2;
        while (x > xLeft) {
            CGContextMoveToPoint(context, x * scale, yTop * scale);
            CGContextAddLineToPoint(context, x * scale, yBottom * scale);
            x -= interval;
        }
        
        CGContextStrokePath(context);
        
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage: UIGraphicsGetImageFromCurrentImageContext()];
    }
    
    UIGraphicsEndImageContext();
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"plotCell";
    AGPlotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AGPlotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGRect frame = cell.frame;
        frame.size.height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        cell.frame = frame;
        cell.delegate = _delegate;
    }
    
    NSDictionary* dict = [_data objectAtIndex:indexPath.row];
    
    double heightForRow = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    
    double sum = [[dict objectForKey:kReportFieldSum] doubleValue];
    
    if (AGPlotUnSigned) {
        sum=abs(sum);
    }
    
    double width = abs(sum) * _dx;
    double x = sum > 0 ? _pointZeroX : _pointZeroX - 180;
    double y = heightForRow*0.05;
    //double height = heightForRow - y*2;
    
    if(type == ReportTypeYCapital){
        width = width/2;
        if(sum<0)
            x = _pointZeroX-width;
    }
    int percent = (self.sumTotal == 0) ? 0 : (int)round((fabs(sum)/self.sumTotal*100));
    NSString* left = [dict objectForKey:kReportFieldTitle];
    NSString* right = [[NSString numberFormatterInteger:YES] stringFromNumber:[NSNumber numberWithDouble:sum]];
    [cell changeStateWithBarRect:CGRectMake(x,
                                            y,
                                            width,
                                            31)
                       titleLeft:left
                      titleRight:right
                         percent:percent
                            sign:sum>=0 ? 1:-1
                          object:[dict objectForKey:kReportFieldObject]
                           style:_cellStyle];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*double height = tableView.frame.size.height;
     int num = [self tableView:tableView numberOfRowsInSection:indexPath.section];
     if (height > 44.0f*num) {
     self.tableView.scrollEnabled = NO;
     return height / num;
     }*/
    self.tableView.scrollEnabled = YES;
    return 40.0f;
}



//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(6, 0, 300, 22)];
//    footerView.backgroundColor = [UIColor clearColor];
//
//    UILabel* lbTotal = [[UILabel alloc] initWithFrame:footerView.frame];
//    lbTotal.backgroundColor = [UIColor clearColor];
//    lbTotal.textColor = [UIColor colorWithHex:kColorHexWhite];
//    lbTotal.font = [UIFont fontWithName:kFont1 size:14.0f];
//    lbTotal.text = NSLocalizedString(@"Total", @"");
//    lbTotal.textAlignment = NSTextAlignmentLeft;
//    [footerView addSubview:lbTotal];
//
//    UILabel* lbSum = [[UILabel alloc] initWithFrame:footerView.frame];
//    lbSum.backgroundColor = [UIColor clearColor];
//    lbSum.textColor = [UIColor colorWithHex:kColorHexWhite];
//    lbSum.font = [UIFont fontWithName:kFont1 size:14.0f];
//    lbSum.text = [NSString stringWithFormat:@"%.2f", self.sumTotal];
//    lbSum.textAlignment = NSTextAlignmentRight;
//    [footerView addSubview:lbSum];
//
//    UIView* finalView = [[UIView alloc] initWithFrame:CGRectZero];
//    [finalView addSubview:footerView];
//    return finalView;
//}

@end
