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
@property(nonatomic, strong) IBOutlet UISegmentedControl* sgBottom;
@property(nonatomic, strong) IBOutlet UIImageView* ivBackground;
@property(nonatomic, strong) IBOutlet UILabel* lbPlotTitle;
@property(nonatomic, strong) IBOutlet UILabel* lbPercent;

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

@property(nonatomic, strong) UIView* footerView;
@property(nonatomic, strong) UILabel* lbTotal;
@property(nonatomic, strong) UILabel* lbSum;

@property(nonatomic, strong) UIColor* sgSelectionColor;

@property(nonatomic, strong) IBOutlet UILabel* lbBarInfo;
@property(nonatomic,assign) int index_BarSelected;


@end

@implementation AGPlotController

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
    _lbBarInfo.hidden=YES;
    // Do any additional setup after loading the view from its nib.    
    _sgTop.tintColor = [UIColor colorWithHex:kColorHexPlotSegment];
    [_sgTop setTitle:NSLocalizedString(@"PlotTopSegmentIn", @"") forSegmentAtIndex:0];
    [_sgTop setTitle:NSLocalizedString(@"PlotTopSegmentOut", @"") forSegmentAtIndex:1];
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

    NSDictionary* dictTxtColorNormal = [NSDictionary dictionaryWithObject:[UIColor colorWithHex:kColorHexPlotSegmentText] forKey:UITextAttributeTextColor];
    NSDictionary* dictTxtColorSelected = [NSDictionary dictionaryWithObject:[UIColor colorWithHex:kColorHexWhite] forKey:UITextAttributeTextColor];
    [_sgTop setTitleTextAttributes:dictTxtColorNormal
                          forState:UIControlStateNormal];
    [_sgTop setTitleTextAttributes:dictTxtColorSelected
                          forState:UIControlStateSelected];
    [_sgBottom setTitleTextAttributes:dictTxtColorNormal
                             forState:UIControlStateNormal];
    [_sgBottom setTitleTextAttributes:dictTxtColorSelected
                             forState:UIControlStateSelected];
    
    {// xib layout fix
        float dy = 10;
        CGRect frame = _sgTop.frame;
        frame.size.height += dy;
        _sgTop.frame = frame;
    }
    
    [self.sgBottom setBackgroundImage:[UIImage imageNamed:@"segment-plot-bottom"]
                             forState:UIControlStateNormal
                           barMetrics:UIBarMetricsDefault];
    [self.sgBottom setBackgroundImage:[UIImage imageNamed:@"segment-plot-bottom-pressed"]
                             forState:UIControlStateSelected
                           barMetrics:UIBarMetricsDefault];
    _sgBottom.tintColor = [UIColor colorWithHex:kColorHexPlotSegment];
    [_sgBottom setTitle:NSLocalizedString(@"PlotBottomSegmentTime", @"") forSegmentAtIndex:0];
    [self reloadBottomTitle];
    switch (_typeX) {
        case ReportTypeXTime:
            _sgBottom.selectedSegmentIndex = 0;
            break;
        default:
            _sgBottom.selectedSegmentIndex = 1;
            break;
    }
    [_sgBottom addTarget:self
               action:@selector(sgBottomSelectionChanged)
     forControlEvents:UIControlEventValueChanged];
    
    self.sgBottom.segmentedControlStyle = UISegmentedControlStyleBezeled;
    self.sgBottom.layer.borderWidth = 0;
    self.sgBottom.layer.cornerRadius = 1.0f;
    
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
    
    _ptvcData = [[AGPlotTableViewController alloc] initWithFrame:CGRectMake(0, 57, 320, 352)];
    _ptvcData.parent = self;
    [_ptvcData.tableView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandler:)]];
    _ptvcData.delegate = self;
    _ptvcData.tableView.hidden = YES;
    [self.view addSubview:_ptvcData.tableView];
    
    _lbPlotTitle.font = [UIFont fontWithName:kFont1 size:14.0f];
    _lbPlotTitle.textColor = [UIColor colorWithHex:kColorHexWhite];
    
    _lbBarInfo.font = [UIFont fontWithName:kFont1 size:14.0f];
    _lbBarInfo.textColor = [UIColor colorWithHex:kColorHexWhite];
    
    if (_account) {
        _sgBottom.hidden = YES;
        _sgTop.hidden = YES;
        
        CGRect frame = _graphHostingView.frame;
        frame.origin.y = 0;
        _graphHostingView.frame = frame;

        frame = _ivPlot.frame;
        frame.origin.y = 0;
        _ivPlot.frame = frame;
        
        frame = _lbPlotTitle.frame;
        frame.origin.y = 0;
        _lbPlotTitle.frame = frame;
        
        frame = _ivBackground.frame;
        frame.origin.y = 0;
        _ivBackground.frame = frame;

        self.navigationItem.title = _account.title;
        self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    }
    
    _plotLastZoomedIn = [[AGStack alloc] init];
    _tableLastZoomedIn = [[AGStack alloc] init];
    
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(6, 161, 300, 22)];
    self.footerView.backgroundColor = [UIColor clearColor];
    
    _lbPercent.hidden=YES;
    float distance=15;
    _lbPercent.font=[UIFont fontWithName:kFont1 size:14.0f];
    _lbPercent.textColor=[UIColor colorWithHex:kColorHexGray];
    CGRect rect=CGRectMake(0, 0, _graphHostingView.frame.size.width-distance, 100);
    _lbPercent.frame=rect;
    
    self.lbTotal = [[UILabel alloc] initWithFrame:self.footerView.frame];
    self.lbTotal.backgroundColor = [UIColor clearColor];
    self.lbTotal.textColor = [UIColor colorWithHex:kColorHexWhite];
    self.lbTotal.font = [UIFont fontWithName:kFont1 size:14.0f];
    self.lbTotal.text = NSLocalizedString(@"Total", @"");
    self.lbTotal.textAlignment = NSTextAlignmentLeft;
    [self.footerView addSubview:self.lbTotal];
    
    self.lbSum = [[UILabel alloc] initWithFrame:self.footerView.frame];
    self.lbSum.backgroundColor = [UIColor clearColor];
    self.lbSum.font = [UIFont fontWithName:kFont1 size:14.0f];
    self.lbSum.textColor = [UIColor colorWithHex:kColorHexWhite];
    [self.lbSum setTextFromNumber:0
                        asInteger:NO
                        withColor:self.lbSum.textColor];
    self.lbSum.textAlignment = NSTextAlignmentRight;
    [self.footerView addSubview:self.lbSum];
    [self.view addSubview:self.footerView];
    
    [self footerViewHide];
    
    self.sgSelectionColor = [UIColor colorWithHex:kColorHexPlotSegmentSelected];
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
        
        frame = self.footerView.frame;
        frame.origin.y += 88;
        self.footerView.frame = frame;
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
- (void) footerSetTotalSumAlignmentToRight:(BOOL)right{
    if (right) {
        self.lbSum.textAlignment = NSTextAlignmentRight;
        self.lbTotal.textAlignment = NSTextAlignmentLeft;
    }else{
        self.lbSum.textAlignment = NSTextAlignmentLeft;
        self.lbTotal.textAlignment = NSTextAlignmentRight;
    }
}

- (void) footerSetTotalSumFromNumber:(double)num{
    [self.lbSum setTextFromNumber:num
                        asInteger:NO
                        withColor:self.lbSum.textColor];
}

- (void) footerViewHide{
    self.footerView.hidden = YES;
}

- (void) footerViewShow{
    self.footerView.hidden = NO;
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
                                    typeY:_typeY
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
}

#pragma mark - swipe
-(void)swipeGestureHandler:(UISwipeGestureRecognizer*)swipeRecognizer{
    if (_typeX != ReportTypeXTime) return;    

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
    [self reloadData];
    
    [_graphHostingView slideToPoint:CGPointMake(_ivPlot.frame.origin.x, _ivPlot.frame.origin.y+1)];
    [_ivPlot slideToPoint:CGPointMake(ivPlotFrame.origin.x, ivPlotFrame.origin.y)];

    _activityIndicator.alpha = 0.0f;
}

#pragma mark - pinch
- (void) pinchGestureHandler:(UIPinchGestureRecognizer*)pinchRecognizer{
    if (pinchRecognizer.state != UIGestureRecognizerStateEnded) return;
    if (pinchRecognizer.scale >= 1.0f) return;
    
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
                             
                             _activityIndicator.alpha = 0.0f;
                         }];        
    }
}

#pragma mark - segments
-(void)sgTopSelectionChanged{
    _typeY = _sgTop.selectedSegmentIndex;
    [self reloadBottomTitle];
    [self sgBottomSelectionChanged];
//    [self reloadData];
}
-(void)sgBottomSelectionChanged{
    _supercat = nil;
    [_tableLastZoomedIn clear];
    if (_sgBottom.selectedSegmentIndex == 0) {
        _typeX = ReportTypeXTime;
        [self footerViewHide];
    }else if (_typeY == ReportTypeYCapital){
        _typeX = ReportTypeXAccounts;
        [self footerViewShow];
    }else{
        _typeX = ReportTypeXCategories;
        [self footerViewShow];
    }
    _activityIndicator.alpha = 1.0f;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
    [self reloadData];
    _activityIndicator.alpha = 0.0f;
    if (_sgBottom.selectedSegmentIndex == 0) {
        _graphHostingView.hidden = NO;
        _ptvcData.tableView.hidden = YES;
    }else{
        _graphHostingView.hidden = YES;
        _ptvcData.tableView.hidden = NO;
    }
}
-(void)reloadBottomTitle{
    if (_typeY == ReportTypeYCapital) {
        [_sgBottom setTitle:NSLocalizedString(@"PlotBottomSegmentAccount", @"") forSegmentAtIndex:1];
    }else{
        [_sgBottom setTitle:NSLocalizedString(@"PlotBottomSegmentCategory", @"") forSegmentAtIndex:1];
    }
}
-(void)reloadPlotTitle{
    _lbPercent.hidden=YES;
    switch (_typeY) {
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
            break;
    }
    
    switch (_typeX) {
        case ReportTypeXCategories:
            if (_supercat != nil) {
                _lbPlotTitle.text = _supercat.title;
            }else{
                _lbPlotTitle.text = @"";
            }
            break;
            
        case ReportTypeXAccounts:
            _lbPlotTitle.text = @"";
            break;
            
        default:
            switch (_reportItem) {
                case ReportItemDay:
                    _lbPlotTitle.text = [NSString stringWithFormat:@"%@ ", _dtFrom.weekCurrent.weekMonthTitleForDay];
                    break;

                case ReportItemWeek:
                    _lbPlotTitle.text = _dtFrom.dateTitleMonthYear;
                    break;
                    
                default:
                    _lbPlotTitle.text = [NSString stringWithFormat:@"%d", _dtFrom.dateComponents.year];
                    break;
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
    
    NSString* strMax = [[NSString numberFormatterInteger:YES] stringFromNumber:[NSNumber numberWithDouble:yMax]];
    CGSize strMaxSize = [strMax sizeWithFont:[UIFont fontWithName:kFont1 size:20.0f]];
    NSString* strMin = [[NSString numberFormatterInteger:YES] stringFromNumber:[NSNumber numberWithDouble:yMin]];
    CGSize strMinSize = [strMin sizeWithFont:[UIFont fontWithName:kFont1 size:20.0f]];
    
    chart.plotAreaFrame.paddingLeft = MAX(strMaxSize.width, strMinSize.width) + ((CPTXYAxisSet*)chart.axisSet).yAxis.labelOffset;
    if ((yMin == yMax) && (yMax == 0.0f)) {
        chart.plotAreaFrame.paddingLeft = 0.0f;
    }
    chart.plotAreaFrame.paddingTop      = 20.0f;
    chart.plotAreaFrame.paddingRight    = 5.0f;
    chart.plotAreaFrame.paddingBottom   = 20.0f;
    
    _plotPaddingLeft = chart.plotAreaFrame.paddingLeft;
    _plotPaddingRight = chart.plotAreaFrame.paddingRight;
    
    // Add plot space for horizontal bar charts
    double yRange = abs(yMin) + abs(yMax + yMax/10);
	CPTXYPlotSpace* space = (CPTXYPlotSpace*) chart.defaultPlotSpace;
	space.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin)
                                                length:CPTDecimalFromFloat(yRange)];
    space.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f)
                                                length:CPTDecimalFromFloat(100.0f)];
    
    int n = _dataSource.count;
    _barDistance = 100.0f / (n * 3 + n+1);
    _barWidth = _barDistance * 3;
    
    // Setup axis
    CPTMutableLineStyle* majorLineStyle = [CPTMutableLineStyle lineStyle];
    majorLineStyle.lineWidth = 0.5;
    majorLineStyle.dashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:2], nil];
    majorLineStyle.patternPhase = 0.0f;
    majorLineStyle.lineColor = [CPTColor colorWithCGColor:[UIColor colorWithHex:kColorHexWhite].CGColor];
    
    CPTMutableLineStyle* minorLineStyle = [CPTMutableLineStyle lineStyle];
    minorLineStyle.lineWidth = 0.5;
    minorLineStyle.dashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:2], nil];
    minorLineStyle.patternPhase = 0.0f;
    minorLineStyle.lineColor = [CPTColor colorWithCGColor:[UIColor colorWithHex:kColorHexGray].CGColor];

    CPTMutableTextStyle *lbTxtStyle = [[CPTMutableTextStyle alloc] init];
    lbTxtStyle.fontSize = 14;
    lbTxtStyle.fontName = kFont1;
    lbTxtStyle.color = [CPTColor colorWithCGColor:[UIColor colorWithHex:kColorHexWhite].CGColor];
    
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
    
    NSMutableArray* labels = [NSMutableArray arrayWithCapacity:[_dataSource count]];
    for (int i = 0; i < [_dataSource count]; i++) {
        CPTAxisLabel* l = [[CPTAxisLabel alloc] initWithText:[[_dataSource objectAtIndex:i] objectForKey:kReportFieldTitle]
                                                   textStyle:x.labelTextStyle];
        l.tickLocation = [[NSNumber numberWithFloat:(i+0.5) * _barWidth + (i+1)*_barDistance] decimalValue];
        l.offset = x.labelOffset;
        [labels addObject:l];
    }
	x.axisLabels = [NSSet setWithArray:labels];
    
    // bar plot
	AGCPTBarPlot* plot =
    [AGCPTBarPlot tubularBarPlotWithColor:[CPTColor colorWithCGColor:[UIColor colorWithHex:kColorHexPlotGreen].CGColor]
                         horizontalBars:NO];
    plot.identifier = kPlotPos;
	plot.dataSource = self;
    plot.delegate = self;
	plot.barOffset  = CPTDecimalFromFloat(0.0f);
    plot.barWidth = [[NSNumber numberWithFloat:_barWidth] decimalValue];
    plot.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor colorWithHex:kColorHexPlotGreen].CGColor]];
    plot.lineStyle = nil;
	[chart addPlot:plot toPlotSpace:space];

    // bar plot negative
	AGCPTBarPlot* plotNegative =
    [AGCPTBarPlot tubularBarPlotWithColor:[CPTColor colorWithCGColor:[UIColor colorWithHex:kColorHexPlotGreen].CGColor]
                         horizontalBars:NO];
    
    plotNegative.identifier = kPlotNeg;
	plotNegative.dataSource = self;
    plotNegative.delegate = self;
	plotNegative.barOffset  = CPTDecimalFromFloat(0.0f);
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
     NSNumber* num = [[_dataSource objectAtIndex:index] objectForKey:kReportFieldSum];
    if (num.doubleValue == 0) return;
    
    _lbBarInfo.hidden=NO;
    _lbPlotTitle.hidden=YES;
    _index_BarSelected=index;
    NSDate* dt = [[_dataSource objectAtIndex:index] objectForKey:kReportFieldObject];
   
    NSString* st_weekTitle;
    st_weekTitle=dt.weekMonthTitle;
    NSString* st_monthTitle;
    st_monthTitle=dt.monthTitleShort;
    int i_sum=round(num.doubleValue);
    NSString *lb_string = [NSString stringWithFormat:@"%@ %@ %i" ,
                              st_weekTitle,st_monthTitle, i_sum];
 
    _lbBarInfo.text=lb_string;
     [self reloadData];
    
    
}

-(CPTFill *)barFillForBarPlot:(AGCPTBarPlot *)barPlot recordIndex:(NSUInteger)index
{
    CPTFill* fill;

    if (_index_BarSelected==index)
    {
   fill=[CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor colorWithHex:kColorHexPlotSelectGreen].CGColor]];
        return  fill;
    }
    else
    {
        fill=[CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor colorWithHex:kColorHexPlotGreen].CGColor]];
        return  fill;
    }
    
}
- (void) barPlot:(AGCPTBarPlot *)plot barShortPressedAtRecordIndex:(NSUInteger)index{
    _index_BarSelected=-1;
    _lbBarInfo.hidden=YES;
    _lbPlotTitle.hidden=NO;
    if (_typeX != ReportTypeXTime) return;
    if (_reportItem == ReportItemDay) return;

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
                                 
                                 _activityIndicator.alpha = 0.0f;
                             }];
        }
    }
}


@end
