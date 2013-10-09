//
//  AGPlotController.m
//  AllMine
//
//  Created by Allgoritm LLC on 10.12.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGCPTBarPlot.h"
#import "CPTLayer.h"

#import "AGPlotController.h"

#import "UIColor+AGExtensions.h"

#import "AGAppDelegate.h"
#import "AGRootController.h"

#import "NSDate+AGExtensions.h"
#import "UIView+AGExtensions.h"
#import "NSString+AGExtensions.h"

#import "Category+EntityWorker.h"
#import "AGPlotTableViewController.h"

#import "Account+EntityWorker.h"
#import "AGTools.h"

#import "AGStack.h"

#import "UILabel+AGExtensions.h"

#import "Currency.h"


#define kPlotPos    @"plotPos"
#define kPlotNeg    @"plotNeg"

#define kDoorAnimationTime  kSlideAnimationTime

//  class(struct) to push table stack
@interface AGPlotTableZoomedState : NSObject

@property(nonatomic, assign) double y;
@property(nonatomic, assign) CGPoint offset;

-(id)initWithY:(double)y offset:(CGPoint)offset;

@end

@implementation AGPlotTableZoomedState

-(id)initWithY:(double)y offset:(CGPoint)offset{
    self = [super init];
    if (self) {
        _y = y;
        _offset = offset;
    }
    return self;
}

@end

@interface AGPlotController ()

@property(nonatomic, assign) ReportItem reportItem;
@property(nonatomic, assign) ReportTypeX typeX;
@property(nonatomic, assign) ReportTypeY typeY;

@property(nonatomic, strong) NSDate* dtFrom;
@property(nonatomic, strong) NSDate* dtTo;

@property(nonatomic, strong) IBOutlet CPTGraphHostingView* graphHostingView;
@property(nonatomic, strong) IBOutlet UIImageView* ivPlot;
@property(nonatomic, strong) IBOutlet UIImageView* ivPlotDoorLeft;
@property(nonatomic, strong) IBOutlet UIImageView* ivPlotDoorRight;
@property(nonatomic, strong) IBOutlet UISegmentedControl* sgTop;
@property(nonatomic, strong) IBOutlet UIImageView* ivBackground;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property(nonatomic, strong) IBOutlet UILabel* lbPlotTitle;
@property(nonatomic, strong) IBOutlet UILabel* lbPercent;
@property(strong, nonatomic) IBOutlet UILabel *lbInfoSum;
@property (weak, nonatomic) IBOutlet UILabel *lbAverageSum;
@property (weak, nonatomic) IBOutlet UILabel *lbAverage;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;

@property(nonatomic, strong) AGPlotTableViewController* ptvcData;

@property(nonatomic, strong) IBOutlet UIActivityIndicatorView* activityIndicator;

@property(nonatomic, strong) NSArray* dataSource;

@property(nonatomic, assign) double barDistance;
@property(nonatomic, assign) double barWidth;

@property(nonatomic, assign) double plotPaddingLeft;
@property(nonatomic, assign) double plotPaddingRight;

@property(nonatomic, strong) Category* supercat;

//@property(nonatomic, assign) int plotLastZoomedInIndex;
//@property(nonatomic, assign) double plotTableLastZoomedInY;
//@property(nonatomic, assign) CGPoint plotTableLastZoomedInOffset;
@property(nonatomic, strong) AGStack* tableLastZoomedIn;
@property(nonatomic, strong) AGStack* plotLastZoomedIn;

@property(nonatomic, strong) UIColor* sgSelectionColor;

@property(nonatomic,assign) int index_BarSelected;
@property (weak, nonatomic) IBOutlet UILabel *lbCurrentPeriodInfo;

@end


@implementation AGPlotController
int varTemp = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _reportItem = ReportItemWeek;
        _typeY = ReportTypeYIn;
        _typeX = ReportTypeXTime;
        _dtFrom = [[NSDate date] monthCurrent];
        _dtTo = [[NSDate date] monthNext];
        _dataSource = [NSMutableArray array];
        _index_BarSelected=-1;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [_sgTop setTitle:NSLocalizedString(@"PlotTopSegmentOut", @"") forSegmentAtIndex:0];
    [_sgTop setTitle:NSLocalizedString(@"PlotTopSegmentIn", @"") forSegmentAtIndex:1];
    [_sgTop setTitle:NSLocalizedString(@"PlotTopSegmentCap", @"") forSegmentAtIndex:2];
    [self.sgTop setBackgroundImage:[UIImage imageNamed:@"segment-plot-top"]
                          forState:UIControlStateNormal
                        barMetrics:UIBarMetricsDefault];
    [self.sgTop setBackgroundImage:[UIImage imageNamed:@"segment-plot-top-pressed"]
                          forState:UIControlStateSelected
                        barMetrics:UIBarMetricsDefault];
    _sgTop.selectedSegmentIndex = _typeY;
    [_sgTop addTarget:self
               action:@selector(sgTopSelectionChanged)
     forControlEvents:UIControlEventValueChanged];
    
    NSDictionary* dictTxtColorNormal = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                               [UIColor colorWithHex:kColorHexPlotSegmentText],UITextAttributeTextColor,
                                                                               [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                                               [NSValue valueWithUIOffset:UIOffsetMake(0, 1.0f)],UITextAttributeTextShadowOffset, [UIFont fontWithName:kFont1 size:17.0f], UITextAttributeFont,
                                                                               nil];
    NSDictionary* dictTxtColorSelected = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor colorWithHex:kColorHexWhite],UITextAttributeTextColor,
                                          [UIColor colorWithHex:kColorHexPlotSegmentSelected], UITextAttributeTextShadowColor,
                                          [NSValue valueWithUIOffset:UIOffsetMake(0, 1.0f)],UITextAttributeTextShadowOffset,
                                          nil];
    [_sgTop setTitleTextAttributes:dictTxtColorNormal
                          forState:UIControlStateNormal];
    [_sgTop setTitleTextAttributes:dictTxtColorSelected
                          forState:UIControlStateSelected];
    
    {// xib layout fix
        float dy = 10;
        CGRect frame = _sgTop.frame;
        frame.size.height += dy;
        _sgTop.frame = frame;
    }
    switch (_typeX) {
        case ReportTypeXTime:
            _timeButton.enabled = NO;
            _categoryButton.enabled = YES;
            break;
        default:
            _timeButton.enabled = YES;
            _categoryButton.enabled = NO;
            break;
    }
    
    //gestures
    _graphHostingView.userInteractionEnabled = YES;
    
    UISwipeGestureRecognizer* swipeRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureHandler:)];
    swipeRecognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_graphHostingView addGestureRecognizer:swipeRecognizerRight];
    
    UISwipeGestureRecognizer* swipeRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureHandler:)];
    swipeRecognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [_graphHostingView addGestureRecognizer:swipeRecognizerLeft];
    
    UIPinchGestureRecognizer* pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandler:)];
    [_graphHostingView addGestureRecognizer:pinchRecognizer];
    //    [self reloadData];
    
    [_activityIndicator addObserver:self
                         forKeyPath:@"alpha"
                            options:NSKeyValueObservingOptionNew
                            context:nil];
    _activityIndicator.alpha = 0.0f;
    [_activityIndicator startAnimating];
    
    _supercat = nil;
    
    _ptvcData = [[AGPlotTableViewController alloc] initWithFrame:CGRectMake(8, 90, 298, 320)];
    _ptvcData.parent = self;
    [_ptvcData.tableView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandler:)]];
    _ptvcData.delegate = self;
    _ptvcData.tableView.hidden = YES;
    [self.view addSubview:_ptvcData.tableView];
    
    _lbTitle.font = [UIFont fontWithName:kFont1NonBold size:16.0f];
    _lbTitle.textColor = [UIColor colorWithHex:kColorHexPlotDarkGrey];
    
    _lbPlotTitle.font = [UIFont fontWithName:kFont1 size:14.0f];
    _lbPlotTitle.textColor = [UIColor colorWithHex:kColorHexGray];
    
    _lbCurrentPeriodInfo.font = [UIFont fontWithName:kFont1 size:14.0f];
    _lbCurrentPeriodInfo.textColor = [UIColor colorWithHex:kColorHexGray];
        
    if (_account) {
        _timeButton.hidden = YES;
        _categoryButton.hidden = YES;
        _sgTop.hidden = YES;
        
        CGRect frame = _graphHostingView.frame;
        frame.origin.y = 30;
        _graphHostingView.frame = frame;
        
        frame = _ivPlot.frame;
        frame.origin.y = 30;
        _ivPlot.frame = frame;
        
        frame = _lbPlotTitle.frame;
        frame.origin.y = 20;
        frame.origin.x = 25;
        _lbPlotTitle.frame = frame;
        
        frame = _lbAverage.frame;
        frame.origin.y -= 40;
        _lbAverage.frame = frame;
        
        frame = _lbAverageSum.frame;
        frame.origin.y -= 40;
        _lbAverageSum.frame = frame;
        
        frame = _lbInfoSum.frame;
        frame.origin.y -= 40;
        _lbInfoSum.frame = frame;
        
        frame = _lbCurrentPeriodInfo.frame;
        frame.origin.y = 20;
        frame.origin.x = 25;
        _lbCurrentPeriodInfo.frame = frame;
        
        self.navigationItem.title = _account.title;
        self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    }
    
    _plotLastZoomedIn = [[AGStack alloc] init];
    _tableLastZoomedIn = [[AGStack alloc] init];
    
    _lbPercent.hidden=YES;
    float distance=17;

    _lbPercent.font=[UIFont fontWithName:kFont1 size:13.0f];
    _lbPercent.textColor=[UIColor colorWithHex:0xCFCFCE];
    CGRect rect=CGRectMake(12, 18, _graphHostingView.frame.size.width-distance, 100);
    _lbPercent.frame=rect;
    
    
    self.sgSelectionColor = [UIColor colorWithHex:kColorHexPlotSegmentSelected];
    
    self.lbInfoSum.text = @"0";
    self.lbInfoSum.font = [UIFont fontWithName:kFont1 size:18.0f];
    
    self.lbAverage.font = [UIFont fontWithName:kFont1 size:12.0f];
    self.lbAverage.textColor = [UIColor colorWithHex:kColorHexDarkGray];
    self.lbAverage.text = NSLocalizedString(@"PlotAverageTitle", nil);
    
    self.lbAverageSum.font = [UIFont fontWithName:kFont1 size:18.0f];
    self.lbAverageSum.textColor = [UIColor colorWithHex:kColorHexPlotBrown];
    self.lbAverageSum.text = @"0";
    
    [self sgTopSelectionChanged];
    if (isIphoneRetina4) {
        CGRect frame = self.graphHostingView.frame;
        frame.size.height += 88;
        self.graphHostingView.frame = frame;
        
        frame = self.ivPlot.frame;
        frame.size.height += 88;
        self.ivPlot.frame = frame;
        
        frame = self.ivPlotDoorLeft.frame;
        frame.size.height += 88;
        self.ivPlot.frame = frame;
        
        frame = self.ivPlotDoorRight.frame;
        frame.size.height += 88;
        self.ivPlot.frame = frame;
        
        frame = self.ivBackground.frame;
        frame.size.height += 88;
        self.ivBackground.frame = frame;
        
        frame = self.ptvcData.tableView.frame;
        frame.size.height += 0;
        self.ptvcData.tableView.frame = frame;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    _supercat = nil;
    [_tableLastZoomedIn clear];
    [self reloadData];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - footer
- (IBAction)timeButtonPressed:(id)sender {
    _supercat = nil;
    [_tableLastZoomedIn clear];
    if (_timeButton.enabled) {
            _typeX = ReportTypeXTime;
    }
    _activityIndicator.alpha = 1.0f;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
    [self reloadData];
    _activityIndicator.alpha = 0.0f;
    if (_timeButton.enabled) {
        _graphHostingView.hidden = NO;
        _ptvcData.tableView.hidden = YES;
    }else{
        _graphHostingView.hidden = YES;
        _ptvcData.tableView.hidden = NO;
        _ptvcData.type = [self segmentIndex];
    }
    _timeButton.enabled = NO;
    _categoryButton.enabled = YES;
    _lbInfoSum.hidden = NO;
    
}

- (int)segmentIndex{
    switch (_sgTop.selectedSegmentIndex) {
        case 0:
            return 1;
            break;
        case 1:
            return 0;
            break;
        case 2:
            return 2;
            break;
        default:
            return nil;
            break;
    }
}
-(int)incomeTotal{
    if([_dtFrom compare:[NSDate today]] == NSOrderedDescending)
    {
        return 0;
    }
    
    int money = 0;
    User* usr = kUser;
    
    NSSet* accountSet = usr.accounts;
    
    for(Account * acc in accountSet){
        if(acc.type != [NSNumber numberWithInt:AccTypeCardCredit] && acc.group != [NSNumber numberWithInt:AccGroupDebts]){
            money+=[acc balance];
        }
    }
    
    double debt = 0.0;
    
    NSArray* accounts = [usr accountsByType: AccTypeCardCredit];
            
    for(Account* acc in accounts){
        debt += [acc balanceWithCurrency:acc.currency]-[acc creditLimitWithCurrency:acc.currency];
    }
    NSSet* debts = usr.accounts;
    for(Account* acc in debts){
        if (acc.group == [NSNumber numberWithInt:AccGroupDebts] && acc.type != [NSNumber numberWithInt:AccTypeCardCredit]){
            debt+=[acc balance];
        }
    }
    
    if(debt<0)
        debt*=-1;
    
    return money - debt;
}


- (IBAction)categoryButtonPressed:(id)sender {
    _supercat = nil;
    [_tableLastZoomedIn clear];
    if (_categoryButton.enabled) {
        if ([self segmentIndex] == ReportTypeYCapital){
            _typeX = ReportTypeXAccounts;
        }else{
            _typeX = ReportTypeXCategories;
        }
    }
    _activityIndicator.alpha = 1.0f;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
    [self reloadData];
    _activityIndicator.alpha = 0.0f;
    if (_categoryButton.enabled) {
        _graphHostingView.hidden = YES;
        _ptvcData.tableView.hidden = NO;
        _ptvcData.type = [self segmentIndex];
    }else{
        _graphHostingView.hidden = NO;
        _ptvcData.tableView.hidden = YES;
    }
    
    
    _timeButton.enabled = YES;
    _categoryButton.enabled = NO;
    _lbInfoSum.hidden = YES;
    
}

#pragma mark - KVO
- (void) observeValueForKeyPath:(NSString*) keyPath
                       ofObject:(id) object
                         change:(NSDictionary*) change
                        context:(void*) context {
    if ([keyPath isEqualToString:@"alpha"]) {
        (kRoot).view.userInteractionEnabled = [[change valueForKey:NSKeyValueChangeNewKey] floatValue] == 1.0f ? NO : YES;
    }
}

#pragma mark - reload data
-(void) reloadData{
    _dataSource = [(kUser) reportWithItem:_reportItem
                                    typeY:[self segmentIndex]
                                    typeX:_typeX
                                     from:_dtFrom
                                       to:_dtTo
                            supercategory:_supercat
                                  account:_account];
    
    [self reloadPlotTitle];
    if (_typeX == ReportTypeXTime) {
        _graphHostingView.hostedGraph = [self drawPlot];
    }else{
        [_ptvcData reloadData:_dataSource];
    }
    float distance=17;
    if(_typeY == ReportTypeYCapital)
        distance = 23;
    CGRect rect=CGRectMake(12, 18, _graphHostingView.frame.size.width-distance, 100);
    _lbPercent.frame=rect;
    [self reloadInfoTitles];
}

- (int) averageSum{
    int sum = 0;
    int count = 0;
    
    for (int i=0; i<[_dataSource count]; i++) {
        if([[[_dataSource objectAtIndex:i] objectForKey:kReportFieldSum] intValue]!=0){
            sum+=[[[_dataSource objectAtIndex:i] objectForKey:kReportFieldSum] intValue];
            count++;
        }
    }
    if(count>0)
        return sum/count;
    else
        return sum;
}

- (int) totalSum{
    int sum = 0;
    
    for (int i=0; i<[_dataSource count]; i++) {
        sum+=[[[_dataSource objectAtIndex:i] objectForKey:kReportFieldSum] intValue];
    }
    return sum;
}

#pragma mark - swipe
-(void)swipeGestureHandler:(UISwipeGestureRecognizer*)swipeRecognizer{
    if (_typeX != ReportTypeXTime) return;
    [self notBarPressed];
    _activityIndicator.alpha = 1.0f;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
    
    //    _hostingViewOld.hostedGraph = [self drawPlotWithIdentifier:kPlotOld];
    _ivPlot.image = _graphHostingView.hostedGraph.imageOfLayer;
    CGRect frame = _graphHostingView.frame;
    frame.origin.y -= 1;
    _ivPlot.frame = frame;
    
    CGRect graphFrame = _graphHostingView.frame;
    CGRect ivPlotFrame = _ivPlot.frame;
    switch (swipeRecognizer.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            switch (_reportItem) {
                case ReportItemMonth:
                    _dtFrom = _dtFrom.halfYearNext;
                    _dtTo = _dtTo.halfYearNext;
                    break;
                case ReportItemWeek:
                    _dtFrom = _dtFrom.monthNext;
                    _dtTo = _dtTo.monthNext;
                    break;
                default:
                    _dtFrom = _dtFrom.weekNext;
                    _dtTo = _dtTo.weekNext;
                    break;
            }
            graphFrame.origin.x += graphFrame.size.width;
            ivPlotFrame.origin.x -= ivPlotFrame.size.width;
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            switch (_reportItem) {
                case ReportItemMonth:
                    _dtFrom = _dtFrom.halfYearPrevious;
                    _dtTo = _dtTo.halfYearPrevious;
                    break;
                case ReportItemWeek:
                    _dtFrom = _dtFrom.monthPrevious;
                    _dtTo = _dtTo.monthPrevious;
                    break;
                default:
                    _dtFrom = _dtFrom.weekPrevious;
                    _dtTo = _dtTo.weekPrevious;
                    break;
            }
            graphFrame.origin.x -= graphFrame.size.width;
            ivPlotFrame.origin.x += ivPlotFrame.size.width;
            break;
            
        default:
            break;
    }
    
    _graphHostingView.frame = graphFrame;
    
    _lbCurrentPeriodInfo.hidden = YES;
    [self reloadData];
    
    [_graphHostingView slideToPoint:CGPointMake(_ivPlot.frame.origin.x, _ivPlot.frame.origin.y+1)];
    [_ivPlot slideToPoint:CGPointMake(ivPlotFrame.origin.x, ivPlotFrame.origin.y)];
    
    _activityIndicator.alpha = 0.0f;
}

#pragma mark - pinch
- (void) pinchGestureHandler:(UIPinchGestureRecognizer*)pinchRecognizer{
    if (pinchRecognizer.state != UIGestureRecognizerStateEnded) return;
    if (pinchRecognizer.scale >= 1.0f) return;
    [self notBarPressed];
    if (_typeX == ReportTypeXTime){
        
        if (_reportItem == ReportItemMonth) return;
        
        _activityIndicator.alpha = 1.0f;
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
        
        [self pinchGestureHandlerTimePlot];
        
    }else if (_typeX == ReportTypeXCategories){
        
        if (_supercat == nil) return;
        
        _activityIndicator.alpha = 1.0f;
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
        
        [self pinchGestureHandlerCategory];
    }
}
- (void) pinchGestureHandlerTimePlot{
    _reportItem--;
    if (_reportItem == ReportItemMonth) {
        _dtFrom = _dtFrom.halfYearCurrent;
        _dtTo = _dtFrom.halfYearNext;
    }else{
        _dtFrom = _dtFrom.monthCurrent;
        _dtTo = _dtFrom.monthNext;
    }
    
    _ivPlot.image = _graphHostingView.hostedGraph.imageOfLayer;
    _ivPlot.frame = _graphHostingView.frame;
    CGRect frame = _graphHostingView.frame;
    frame.origin.x -= frame.size.width;
    _graphHostingView.frame = frame;
    [self reloadData];
    
    UIImage* img = _graphHostingView.hostedGraph.imageOfLayer;
    
    double scale = [[UIScreen mainScreen] scale];
    double x = _plotLastZoomedIn.popDouble;
    _ivPlotDoorLeft.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(0, 0, x * scale, img.size.height * scale))];
    _ivPlotDoorRight.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(x * scale, 0, (320-x) * scale, img.size.height * scale))];
    
    frame = _ivPlot.frame;
    frame.origin.x = 0;
    frame.size.width = 0;
    _ivPlotDoorLeft.frame = frame;
    
    frame = _ivPlot.frame;
    frame.origin.x = 320;
    frame.size.width = 0;
    _ivPlotDoorRight.frame = frame;
    
    [UIView animateWithDuration:kDoorAnimationTime
                     animations:^{
                         CGRect frame = _ivPlot.frame;
                         frame.origin.x = x;
                         frame.size.width = 0;
                         _ivPlot.frame = frame;
                         
                         frame = _ivPlotDoorLeft.frame;
                         frame.size.width = x;
                         _ivPlotDoorLeft.frame = frame;
                         
                         frame = _ivPlotDoorRight.frame;
                         frame.origin.x = x;
                         frame.size.width = 320-x;
                         _ivPlotDoorRight.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         CGRect frame = _graphHostingView.frame;
                         frame.origin.x += frame.size.width;
                         _graphHostingView.frame = frame;
                         
                         frame = _ivPlot.frame;
                         frame.origin.x = 0 - frame.size.width;
                         _ivPlot.frame = frame;
                         
                         frame = _ivPlotDoorLeft.frame;
                         frame.origin.x -= frame.size.width;
                         _ivPlotDoorLeft.frame = frame;
                         
                         frame = _ivPlotDoorRight.frame;
                         frame.origin.x += frame.size.width;
                         _ivPlotDoorRight.frame = frame;
                         
                         _activityIndicator.alpha = 0.0f;
                     }];
}

- (void) pinchGestureHandlerCategory{
    if (_supercat != nil) {
        _activityIndicator.alpha = 1.0f;
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
        
        UIGraphicsBeginImageContextWithOptions(_ptvcData.tableView.contentSize, NO, 0.0);
        [_ptvcData.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        double scale = [[UIScreen mainScreen] scale];
        img = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(0, _ptvcData.tableView.contentOffset.y * scale, _ptvcData.tableView.contentSize.width * scale, _ptvcData.tableView.contentSize.height * scale))];
        
        _ivPlot.frame = _ptvcData.tableView.frame;
        _ivPlot.image = img;
        
        _supercat = _supercat.supercat;
        [self reloadData];
        AGPlotTableZoomedState* lastZoomedState = _tableLastZoomedIn.popObject;
        double y = lastZoomedState.y;
        _ptvcData.tableView.contentOffset = lastZoomedState.offset;
        
        UIGraphicsBeginImageContextWithOptions(_ptvcData.tableView.contentSize, NO, 0.0);
        [_ptvcData.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        img = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(0, _ptvcData.tableView.contentOffset.y * scale, _ptvcData.tableView.contentSize.width * scale, _ptvcData.tableView.contentSize.height * scale))];
        
        _ivPlotDoorLeft.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(0, 0, _ptvcData.tableView.contentSize.width * scale, y*scale))];
        _ivPlotDoorRight.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(0, y*scale, _ptvcData.tableView.contentSize.width*scale, (_ptvcData.tableView.frame.size.height - y)*scale))];
        
        CGRect frame = _ptvcData.tableView.frame;
        frame.size.height = 0;
        _ivPlotDoorLeft.frame = frame;
        
        frame = _ptvcData.tableView.frame;
        frame.origin.y += frame.size.height;
        frame.size.height = 0;
        _ivPlotDoorRight.frame = frame;
        
        _ptvcData.tableView.hidden = YES;
        
        [UIView animateWithDuration:kDoorAnimationTime
                         animations:^{
                             CGRect frame = _ivPlot.frame;
                             frame.origin.y += y;
                             frame.size.height = 0;
                             _ivPlot.frame = frame;
                             
                             frame = _ivPlotDoorLeft.frame;
                             frame.size.height = y;
                             _ivPlotDoorLeft.frame = frame;
                             
                             frame = _ivPlotDoorRight.frame;
                             frame.origin.y = _ptvcData.tableView.frame.origin.y + y;
                             frame.size.height = _ptvcData.tableView.frame.size.height - y;
                             _ivPlotDoorRight.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             CGRect frame = _ivPlot.frame;
                             frame.origin.x -= frame.size.width;
                             _ivPlot.frame = frame;
                             
                             frame = _ivPlotDoorLeft.frame;
                             frame.origin.x -= frame.size.width;
                             _ivPlotDoorLeft.frame = frame;
                             
                             frame = _ivPlotDoorRight.frame;
                             frame.origin.x -= frame.size.width;
                             _ivPlotDoorRight.frame = frame;
                             
                             _ptvcData.tableView.hidden = NO;
                             
                             _ptvcData.type = [self segmentIndex];
                             
                             _activityIndicator.alpha = 0.0f;
                         }];
    }
}

#pragma mark - segments
-(void)sgTopSelectionChanged{
    _supercat = nil;
    _typeY = [self segmentIndex];
    _lbCurrentPeriodInfo.hidden = YES;
    if (!_timeButton.enabled) {
        _graphHostingView.hidden = NO;
        _ptvcData.tableView.hidden = YES;
        _typeX = ReportTypeXTime;
    }else{
        _graphHostingView.hidden = YES;
        _ptvcData.tableView.hidden = NO;
        
        _ptvcData.type = [self segmentIndex];
        if([self segmentIndex] == ReportTypeYCapital){
            _typeX = ReportTypeXAccounts;
        }else{
            _typeX = ReportTypeXCategories;
        }
    }
    
    _index_BarSelected = -1;
    //[self sgBottomSelectionChanged];
    [self reloadData];
}

- (void) reloadInfoTitles{
    if(_index_BarSelected==-1)
    {
        Currency* mainCurrency = (kUser).currencyMain;
        NSString* averageLabel = [[NSString alloc] init];
        NSMutableAttributedString* string = [[NSMutableAttributedString alloc] init];
        if (ReportTypeXCategories == _typeX || _typeX == ReportTypeXAccounts){
            averageLabel = NSLocalizedString(@"PlotCategoriesAverage", nil);
                if(_typeX == ReportTypeXAccounts){
                averageLabel = [NSString stringWithFormat:@"%@ %d %@",  NSLocalizedString(@"PlotCategoriesAll", nil), [NSDate today].dateComponents.day, _dtFrom.monthTitleShort];
            }else
                averageLabel = [NSString stringWithFormat:@"%@ %d-%d %@", averageLabel, _dtFrom.dateComponents.day,[NSDate today].dateComponents.day, _dtFrom.monthTitleShort];
            _lbAverage.text = averageLabel;
            string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d %@",[self totalSum], mainCurrency.title]];
            [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont1 size:17.0f] range:NSMakeRange(0, [[NSString stringWithFormat:@"%d ",[self totalSum] ]length ])];
            [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont1 size:11.0f] range:NSMakeRange([[NSString stringWithFormat:@"%d ",[self totalSum] ]length ], [mainCurrency.title length])];
            
            _lbPlotTitle.textAlignment = NSTextAlignmentLeft;
            //_lbAverage.textAlignment = NSTextAlignmentCenter;
        }else{
            _lbAverage.text = NSLocalizedString(@"PlotAverageTitle", nil);
            string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d %@",[self averageSum], mainCurrency.title]];
            [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont1 size:17.0f] range:NSMakeRange(0, [[NSString stringWithFormat:@"%d ",[self averageSum] ]length ])];
            [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont1 size:11.0f] range:NSMakeRange([[NSString stringWithFormat:@"%d ",[self averageSum] ]length ], [mainCurrency.title length])];
            
            _lbPlotTitle.textAlignment = NSTextAlignmentLeft;
            //_lbAverage.textAlignment = NSTextAlignmentRight;
        }
        self.lbAverageSum.attributedText = string;
        self.lbAverageSum.textAlignment = NSTextAlignmentLeft;
        if(_typeY == ReportTypeYCapital){
            self.lbInfoSum.text = [NSString stringWithFormat:@"%d", [self incomeTotal]];
        }else{
            self.lbInfoSum.text = [NSString stringWithFormat:@"%d",[self totalSum]];
        }
        if(_sgTop.selectedSegmentIndex==0)
            self.lbInfoSum.textColor = [UIColor colorWithHex:kColorHexOrange2];
        else
            self.lbInfoSum.textColor = [UIColor colorWithHex:kColorHexGreen];
        
        if(_typeY == ReportTypeYOut)
        {
            _lbTitle.text = NSLocalizedString(@"PlotTitleOut", nil);
        }
        else
        {
            _lbTitle.text = @"";
        }
    }
}

-(void)reloadPlotTitle{
    _lbPercent.hidden=YES;
    
    if([self segmentIndex] == ReportTypeYCapital){
        _lbPercent.text = @"%";
        _lbPercent.textColor = [UIColor colorWithHex:0xCFCFCE];
    }else
        _lbPercent.text = @"СУММА     %";
    varTemp = 0;
    switch ([self segmentIndex]) {
        case ReportTypeYIn:
            if (_typeX!=ReportTypeXTime)
            {
                _lbPercent.hidden=NO;
            }
            break;
        case ReportTypeYOut:
            if (_typeX!=ReportTypeXTime) {
                _lbPercent.hidden=NO;
            }
        default:
            if (_typeX!=ReportTypeXTime) {
                _lbPercent.hidden=NO;
            }
            break;
    }
    
    switch (_typeX) {
        case ReportTypeXCategories:
            if (_supercat != nil) {
                NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _supercat.title]];
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:kColorHexPlotDarkBlue] range:NSMakeRange(0, [_supercat.title length])];
                _lbPlotTitle.attributedText = string;
            }else{
                _lbPlotTitle.text = @"";
            }
            break;
            
        case ReportTypeXAccounts:
            _lbPlotTitle.text = @"";
            break;
            
        default:
            switch (_reportItem) {
                case ReportItemDay:{
                    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", _dtFrom.weekCurrent.weekMonthTitleForDay]];
                    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:kColorHexPlotDarkGrey] range:NSMakeRange(0, [_dtFrom.weekCurrent.weekMonthTitleForDay length]-4)];
                    _lbPlotTitle.attributedText = string;
                    break;
                }
                case ReportItemWeek:{
                    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:_dtFrom.dateTitleMonthYear];
                    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:kColorHexPlotDarkGrey] range:NSMakeRange(0, [_dtFrom.dateTitleMonthYear length]-5)];
                    _lbPlotTitle.attributedText = string;
                    break;
                }
                default:{
                    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@-%@ %d",[_dtFrom monthTitleShort], [[_dtTo monthPrevious] monthTitleShort],_dtFrom.dateComponents.year]];
                    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:kColorHexPlotDarkGrey] range:NSMakeRange(0, [[_dtFrom monthTitleShort] length]+[[_dtTo monthTitleShort] length]+1)];
                    _lbPlotTitle.attributedText = string;
                    break;
                }
            }
            break;
    }
}


#pragma mark - plot
- (CPTXYGraph*) drawPlot{
    // Create chart
	CPTXYGraph* chart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    chart.fill = nil;
    chart.plotAreaFrame.fill = nil;
    
	// Border
	chart.plotAreaFrame.borderLineStyle = nil;
	chart.plotAreaFrame.cornerRadius    = 0.0f;
    
	// Paddings
	chart.paddingLeft   = 0.0f;
	chart.paddingRight  = 0.0f;
	chart.paddingTop    = 0.0f;
	chart.paddingBottom = 0.0f;
    
    double yMax = [[_dataSource valueForKeyPath:[@"@max." stringByAppendingString:kReportFieldSum]] doubleValue];
    double yMin = [[_dataSource valueForKeyPath:[@"@min." stringByAppendingString:kReportFieldSum]] doubleValue];
    if (yMin > 0.0f) {
        yMin = 0.0f;
    }
    
    if(yMax==0 && yMin==0){
        varTemp = -1;
    }
    
    if (yMin < 0.0f && _sgTop.selectedSegmentIndex !=2) {
        double temp = yMax;
        varTemp = 1;
        yMax = yMin;
        yMin = temp;
    }
    
    NSString* strMax = [[NSString numberFormatterInteger:YES] stringFromNumber:[NSNumber numberWithDouble:yMax]];
    CGSize strMaxSize = [strMax sizeWithFont:[UIFont fontWithName:kFont1 size:20.0f]];
    NSString* strMin = [[NSString numberFormatterInteger:YES] stringFromNumber:[NSNumber numberWithDouble:yMin]];
    CGSize strMinSize = [strMin sizeWithFont:[UIFont fontWithName:kFont1 size:20.0f]];
    
    chart.plotAreaFrame.paddingLeft = MAX(strMaxSize.width, strMinSize.width) + ((CPTXYAxisSet*)chart.axisSet).yAxis.labelOffset;
    if ((yMin == yMax) && (yMax == 0.0f)) {
        chart.plotAreaFrame.paddingLeft = 0.0f;
    }
    if(varTemp==-1){
        chart.plotAreaFrame.paddingLeft = 50.0f;
    }
    chart.plotAreaFrame.paddingTop      = 20.0f;
    chart.plotAreaFrame.paddingRight    = 5.0f;
    chart.plotAreaFrame.paddingBottom   = 20.0f;
    
    _plotPaddingLeft = chart.plotAreaFrame.paddingLeft;
    _plotPaddingRight = chart.plotAreaFrame.paddingRight;
    // Add plot space for horizontal bar charts
    double yRange = abs(yMin) + abs(yMax + yMax/10);
	CPTXYPlotSpace* space = (CPTXYPlotSpace*) chart.defaultPlotSpace;
    if (varTemp == 1)
    {
        space.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin*(-1))
                                                    length:CPTDecimalFromFloat(yRange*(-1))];
        space.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f)
                                                    length:CPTDecimalFromFloat(100.0f)];
        
    }
    else if (varTemp == 0)
    {
        space.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin)
                                                    length:CPTDecimalFromFloat(yRange)];
        space.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f)
                                                    length:CPTDecimalFromFloat(100.0f)];
    }else
    {
        space.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin)
                                                    length:CPTDecimalFromFloat(6)];
        space.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f)
                                                    length:CPTDecimalFromFloat(100.0f)];
    }
    
    int n = _dataSource.count;
    _barDistance = 100.0f / (n * 3 + n+1);
    _barWidth = _barDistance * 3;
    
    // Setup axis
    CPTMutableLineStyle* majorLineStyle = [CPTMutableLineStyle lineStyle];
    majorLineStyle.lineWidth = 0.5;
    majorLineStyle.dashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:2], nil];
    majorLineStyle.patternPhase = 0.0f;
    majorLineStyle.lineColor = [CPTColor colorWithCGColor:[UIColor colorWithHex:kColorHexGray].CGColor];
    
    CPTMutableLineStyle* minorLineStyle = [CPTMutableLineStyle lineStyle];
    minorLineStyle.lineWidth = 0.5;
    minorLineStyle.dashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:2], nil];
    minorLineStyle.patternPhase = 0.0f;
    minorLineStyle.lineColor = [CPTColor colorWithCGColor:[UIColor colorWithHex:kColorHexGray].CGColor];
    
    CPTMutableTextStyle *lbTxtStyle = [[CPTMutableTextStyle alloc] init];
    lbTxtStyle.fontSize = 12;
    lbTxtStyle.fontName = kFont1;
    lbTxtStyle.color = [CPTColor colorWithCGColor:[UIColor colorWithHex:kColorHexPlotDarkGrey].CGColor];
    
    CPTXYAxis* y = ((CPTXYAxisSet*)chart.axisSet).yAxis;
	y.axisLineStyle = nil;
	y.majorTickLineStyle = nil;
    y.minorTickLineStyle = nil;
    y.majorGridLineStyle = majorLineStyle;
	y.minorGridLineStyle = minorLineStyle;
	y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0.0f);
    y.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
    y.labelFormatter = [NSString numberFormatterInteger:YES];
    y.labelTextStyle = lbTxtStyle;
    
    if(varTemp ==-1){
        NSNumberFormatter *newFormatter = [[NSNumberFormatter alloc] init];
        newFormatter.minimumIntegerDigits = 0;
        newFormatter.maximumIntegerDigits = 0;
        y.labelFormatter = newFormatter;
    }
    
    int interval = 1;
    float tmp = yRange;
    while (((float)(tmp /= 10)) > 2.2) {
        interval *= 10;
    }
    y.majorIntervalLength = [[NSNumber numberWithInt:interval] decimalValue];
    
	CPTXYAxis* x = ((CPTXYAxisSet*)chart.axisSet).xAxis;
    x.axisLineStyle = majorLineStyle;
    x.majorTickLineStyle = nil;
    x.minorTickLineStyle = nil;
    x.majorGridLineStyle = nil;
    x.minorGridLineStyle = nil;
    
	// Define custom labels for the data elements
	x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = lbTxtStyle;
    
    CGFloat diff = 0;
    if(yMin != 0)
    {
        diff = (_graphHostingView.frame.size.height - 45) * (ABS(yMin) / (ABS(yMin) + ABS(yMax)));
    }
    
    NSMutableArray* labels = [NSMutableArray arrayWithCapacity:[_dataSource count]];
    int counter = 1;
    for (int i = 0; i < [_dataSource count]; i++) {
        CPTAxisLabel* l= [[CPTAxisLabel alloc]init];
        if (_reportItem == ReportItemWeek) {
            if (_typeY == ReportTypeYCapital) {
                if(!(i%2)){
                l = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%dН",counter]
                                             textStyle:x.labelTextStyle];
                counter++;
                }
            }else{
            l = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%dН",i+1]
                                         textStyle:x.labelTextStyle];
            }
        }else{
            if (_typeY == ReportTypeYCapital) {
                if(!(i%2)){
                    l = [[CPTAxisLabel alloc] initWithText:[[_dataSource objectAtIndex:i] objectForKey:kReportFieldTitle]
                                                 textStyle:x.labelTextStyle];
                }
            }else{
            l = [[CPTAxisLabel alloc] initWithText:[[_dataSource objectAtIndex:i] objectForKey:kReportFieldTitle]
                                                       textStyle:x.labelTextStyle];
            }
        }
        l.tickLocation = [[NSNumber numberWithFloat:(i+0.5) * _barWidth + (i+1)*_barDistance] decimalValue];
        l.offset = x.labelOffset + diff;
        [labels addObject:l];
    }
	x.axisLabels = [NSSet setWithArray:labels];
    
    if(_typeY == ReportTypeYCapital)
    {
        _barWidth *= 2;
    }
    
    // bar plot
	AGCPTBarPlot* plot = [[AGCPTBarPlot alloc] init];
    plot.identifier = kPlotPos;
	plot.dataSource = self;
    plot.delegate = self;
	plot.barOffset  = CPTDecimalFromFloat(0.0f);
    plot.barWidth = [[NSNumber numberWithFloat:_barWidth] decimalValue];
    plot.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor colorWithHex:kColorHexPlotGreen].CGColor]];
    plot.lineStyle = nil;
	[chart addPlot:plot toPlotSpace:space];
    
    // bar plot negative
	AGCPTBarPlot* plotNegative = [[AGCPTBarPlot alloc] init];
    plotNegative.identifier = kPlotNeg;
	plotNegative.dataSource = self;
    plotNegative.delegate = self;
	plotNegative.barOffset  = CPTDecimalFromFloat(0.0f);
    if(_typeY == ReportTypeYCapital){
        switch (_reportItem) {
            case ReportItemMonth:
                plotNegative.barOffset = CPTDecimalFromFloat(-8.0f);
                break;
            case ReportItemWeek:
                plotNegative.barOffset = CPTDecimalFromFloat(-19.5f);
                break;
            case ReportItemDay:
                plotNegative.barOffset = CPTDecimalFromFloat(-14.0f);
                break;
            default:
                plotNegative.barOffset  = CPTDecimalFromFloat(0.0f);
                break;
        }
    }
    plotNegative.barWidth = [[NSNumber numberWithFloat:_barWidth] decimalValue];
    plotNegative.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor colorWithHex:kColorHexPlotOrange].CGColor]];
    plotNegative.lineStyle = nil;
	[chart addPlot:plotNegative toPlotSpace:space];

    return chart;
}

#pragma mark - CPTPlotDataSource



- (NSUInteger) numberOfRecordsForPlot:(CPTPlot*) plot {
    return [_dataSource count];
}

- (NSNumber*) numberForPlot:(CPTPlot*) plot
                      field:(NSUInteger) field
                recordIndex:(NSUInteger) index {
    NSNumber* num = nil;
    
    switch (field) {
        case CPTBarPlotFieldBarLocation:
            num = [NSNumber numberWithDouble: (index+0.5)*_barWidth + (index+1)*_barDistance];
            if(_typeY == ReportTypeYCapital)
            {
                num = [NSNumber numberWithDouble:num.doubleValue / 1.75];
            }
            break;
        case CPTBarPlotFieldBarTip:
            if ([plot.identifier isEqual:kPlotPos]) {
                num = [[_dataSource objectAtIndex:index] objectForKey:kReportFieldSum];
                if (num.doubleValue < 0) {
                    num = [NSNumber numberWithDouble:0.0f];
                }
            }else{
                num = [[_dataSource objectAtIndex:index] objectForKey:kReportFieldSum];
                if (num.doubleValue >= 0) {
                    num = [NSNumber numberWithDouble:0.0f];
                }
            }
            break;
    }
    
    return num;
}



#pragma mark - CPTBarPlotDelegate methods

- (void) barPlot:(AGCPTBarPlot *)plot barLongPressedAtRecordIndex:(NSUInteger)index
{
    _index_BarSelected=-1;
    _lbPlotTitle.hidden=NO;
    _lbCurrentPeriodInfo.hidden = YES;
    if (_typeX != ReportTypeXTime) return;
    if (_reportItem == ReportItemDay) return;
    [self notBarPressed];
    _activityIndicator.alpha = 1.0f;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
    
    _reportItem++;
    NSDate* dt = [[_dataSource objectAtIndex:index] objectForKey:kReportFieldObject];
    if (_reportItem == ReportItemWeek) {
        _dtFrom = dt.monthCurrent;
        _dtTo = _dtFrom.monthNext;
    }else{
        _dtFrom = dt.weekCurrent;
        _dtTo = _dtFrom.weekNext;
    }
    UIImage* img = _graphHostingView.hostedGraph.imageOfLayer;
    
    double x = [self numberForPlot:nil
                             field:CPTBarPlotFieldBarLocation
                       recordIndex:index].doubleValue;
    x = x * (320.0f - _plotPaddingLeft - _plotPaddingRight)/100.0f + _plotPaddingLeft;
    [_plotLastZoomedIn pushDouble:x];
    
    double scale = [[UIScreen mainScreen] scale];
    _ivPlotDoorLeft.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(0, 0, x * scale, img.size.height * scale))];
    _ivPlotDoorRight.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(x * scale, 0, (320-x) * scale, img.size.height * scale))];
    
    CGRect frame = _graphHostingView.frame;
    frame.size.width = x;
    _ivPlotDoorLeft.frame = frame;
    
    frame = _graphHostingView.frame;
    frame.origin.x = x;
    frame.size.width = 320-x;
    _ivPlotDoorRight.frame = frame;
    
    [self reloadData];
    _ivPlot.image = _graphHostingView.hostedGraph.imageOfLayer;
    frame = _graphHostingView.frame;
    frame.origin.x = x;
    frame.size.width = 0;
    _ivPlot.frame = frame;
    
    frame = _graphHostingView.frame;
    frame.origin.x -= frame.size.width;
    _graphHostingView.frame = frame;
    
    [UIView animateWithDuration:kDoorAnimationTime
                     animations:^{
                         CGRect frame = _ivPlot.frame;
                         frame.origin.x = 0;
                         frame.size.width = 320;
                         _ivPlot.frame = frame;
                         
                         frame = _ivPlotDoorLeft.frame;
                         frame.size.width = 0;
                         _ivPlotDoorLeft.frame = frame;
                         
                         frame = _ivPlotDoorRight.frame;
                         frame.origin.x = 320;
                         frame.size.width = 0;
                         _ivPlotDoorRight.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         CGRect frame = _graphHostingView.frame;
                         frame.origin.x += frame.size.width;
                         _graphHostingView.frame = frame;
                         
                         frame = _ivPlot.frame;
                         frame.origin.x -= frame.size.width;
                         _ivPlot.frame = frame;
                         
                         _activityIndicator.alpha = 0.0f;
                     }];
}

-(CPTFill *)barFillForBarPlot:(AGCPTBarPlot *)barPlot recordIndex:(NSUInteger)index
{
    CPTFill* fill;
    
    if (_index_BarSelected==index)
    {
        /*fill=[CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor colorWithHex:kColorHexPlotSelectGreen].CGColor]];*/
        if (varTemp == 0)
        {
            if([barPlot.identifier isEqual: kPlotNeg]){
                fill = [CPTFill fillWithImage:[CPTImage imageForPNGFile:[[NSBundle mainBundle] pathForResource:@"Column-plot-kapital-Less-month-press" ofType:@"png"]]];
            }else{
                fill = [CPTFill fillWithImage:[CPTImage imageForPNGFile:[[NSBundle mainBundle] pathForResource:@"Column-plot-profit-month-pressed" ofType:@"png"]]];
            }
            
        }
        else
        {
            
            fill = [CPTFill fillWithImage:[CPTImage imageForPNGFile:[[NSBundle mainBundle] pathForResource:@"Column-plot-Less-month-pressed" ofType:@"png"]]];
        }
        
        return  fill;
    }
    else
    {
        /*fill=[CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor colorWithHex:kColorHexPlotGreen].CGColor]];*/
        if(varTemp == 0){
            
            if([barPlot.identifier isEqual: kPlotNeg]){
                fill = [CPTFill fillWithImage:[CPTImage imageForPNGFile:[[NSBundle mainBundle] pathForResource:@"Column-plot-kapital-Less-month" ofType:@"png"]]];
            }else{
                fill = [CPTFill fillWithImage:[CPTImage imageForPNGFile:[[NSBundle mainBundle] pathForResource:@"Column-plot-profit-month" ofType:@"png"]]];
            }
            
        }else{
            fill = [CPTFill fillWithImage:[CPTImage imageForPNGFile:[[NSBundle mainBundle] pathForResource:@"Column-plot-Less-month" ofType:@"png"]]];
        }
        return  fill;
    }
    
}
- (void) barPlot:(AGCPTBarPlot *)plot barShortPressedAtRecordIndex:(NSUInteger)index{
    
    NSNumber* num = [[_dataSource objectAtIndex:index] objectForKey:kReportFieldSum];
    if (num.doubleValue == 0) {
        [self notBarPressed];
        return;
    }
    
    _lbPlotTitle.hidden=YES;
    _index_BarSelected=index;
    NSDate* dt = [[_dataSource objectAtIndex:index] objectForKey:kReportFieldObject];
    
    int i_sum=round(num.doubleValue);
    
    _lbCurrentPeriodInfo.hidden = NO;
    _lbCurrentPeriodInfo.textAlignment = NSTextAlignmentLeft;
    
    switch (_reportItem) {
        case ReportItemDay:{
            NSString *year = dt.dateTitleMonthYear;
            year = [year substringFromIndex:[year length]-2];
            NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", dt.dateTitleDayMonthShort, year]];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:kColorHexPlotDarkGrey] range:NSMakeRange(0, [dt.dateTitleDayMonthShort length])];
            
            _lbCurrentPeriodInfo.attributedText = string;
            break;
        }
        case ReportItemWeek:{
            NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", dt.weekMonthTitle, dt.monthTitleShort]];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:kColorHexPlotDarkGrey] range:NSMakeRange(0, [dt.weekMonthTitle length])];
            
            _lbCurrentPeriodInfo.attributedText = string;
            break;
        }
        default:{
            NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", dt.dateTitleMonthYear]];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:kColorHexPlotDarkGrey] range:NSMakeRange(0, [dt.dateTitleMonthYear length]-3)];
            
            _lbCurrentPeriodInfo.attributedText = string;

            break;
        }
    }

    _lbInfoSum.text = [NSString stringWithFormat:@"%i",i_sum ];
    
    Currency* mainCurrency = (kUser).currencyMain;
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"0 %@", mainCurrency.title]];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont1 size:18.0f] range:NSMakeRange(0, 1)];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont1 size:12.0f] range:NSMakeRange(1, 1+[mainCurrency.title length])];
    
    _lbAverageSum.attributedText = string;
    [self reloadData];
    
    
}

- (void) notBarPressed{
    _index_BarSelected = -1;
    _lbPlotTitle.hidden = NO;
    _lbCurrentPeriodInfo.hidden = YES;
    [self reloadData];
}

#pragma mark - AGPlotTableViewCellDelegate
-(void)agplotTableViewCellSelectedBarWithObject:(id)object barCenterY:(double)barCenterY{
    if (_typeX == ReportTypeXCategories) {
        Category* cat = object;
        if ([cat.subcats count] > 0) {
            _activityIndicator.alpha = 1.0f;
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
            
            _supercat = cat;
            
            UIGraphicsBeginImageContextWithOptions(_ptvcData.tableView.contentSize, NO, 0.0);
            [_ptvcData.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            double scale = [[UIScreen mainScreen] scale];
            img = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(0, _ptvcData.tableView.contentOffset.y*scale, _ptvcData.tableView.contentSize.width*scale, _ptvcData.tableView.contentSize.height*scale))];
            
            double y = barCenterY - _ptvcData.tableView.contentOffset.y;
            [_tableLastZoomedIn pushObject:[[AGPlotTableZoomedState alloc] initWithY:y offset:_ptvcData.tableView.contentOffset]];
            
            _ivPlotDoorLeft.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(0, 0, _ptvcData.tableView.frame.size.width*scale, y*scale))];
            _ivPlotDoorRight.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(0, y*scale, _ptvcData.tableView.frame.size.width*scale, (_ptvcData.tableView.frame.size.height - y)*scale))];
            
            CGRect frame = _ptvcData.tableView.frame;
            frame.origin.y += y;
            frame.size.height = 0;
            _ivPlot.frame = frame;
            
            frame = _ptvcData.tableView.frame;
            frame.size.height = y;
            _ivPlotDoorLeft.frame = frame;
            
            frame = _ptvcData.tableView.frame;
            frame.origin.y += y;
            frame.size.height -= y;
            _ivPlotDoorRight.frame = frame;
            
            [self reloadData];
            
            UIGraphicsBeginImageContextWithOptions(_ptvcData.tableView.contentSize, NO, 0.0);
            [_ptvcData.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
            img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            _ivPlot.image = img;
            _ptvcData.tableView.hidden = YES;
            
            [UIView animateWithDuration:kDoorAnimationTime
                             animations:^{
                                 CGRect frame = _ptvcData.tableView.frame;
                                 _ivPlot.frame = frame;
                                 
                                 frame = _ptvcData.tableView.frame;
                                 frame.size.height = 0;
                                 _ivPlotDoorLeft.frame = frame;
                                 
                                 frame = _ptvcData.tableView.frame;
                                 frame.origin.y = _ptvcData.tableView.frame.origin.y + _ptvcData.tableView.frame.size.height;
                                 frame.size.height = 0;
                                 _ivPlotDoorRight.frame = frame;
                             }
                             completion:^(BOOL finished) {
                                 CGRect frame = _ivPlot.frame;
                                 frame.origin.x -= frame.size.width;
                                 _ivPlot.frame = frame;
                                 
                                 _ptvcData.tableView.hidden = NO;
                                 
                                 _ptvcData.type = [self segmentIndex];
                                 
                                 _activityIndicator.alpha = 0.0f;
                             }];
        }
    }
}


@end
