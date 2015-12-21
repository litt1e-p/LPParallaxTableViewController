//
//  LPParallaxTableViewController.m
//
//  Created by litt1e-p on 15/12/18.
//  Copyright © 2015年 litt1e-p. All rights reserved.
//

#import "LPParallaxTableViewController.h"

@interface LPParallaxTableViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIImageView *parallaxImageView;
@property (strong, nonatomic) MASConstraint *parallaxHeaderHeightConstraint;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableViewHeaderContainer;

@end

@implementation LPParallaxTableViewController

@synthesize parallaxHeaderHeight = _parallaxHeaderHeight;
@synthesize parallaxImage = _parallaxImage;

static CGFloat const kParallaxHeaderHeight = 200;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpParallaxHeader];
}

- (void)setUpTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom);
    }];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor clearColor];
    
    CGRect headerFrame         = CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), self.parallaxHeaderHeight);
    UIView *header             = [[UIView alloc] initWithFrame:headerFrame];
    header.autoresizingMask    = UIViewAutoresizingFlexibleWidth;
    header.backgroundColor     = [UIColor clearColor];
    _tableView.tableHeaderView = header;
    _tableViewHeaderContainer  = header;
}

- (void)setUpParallaxHeader
{
    _parallaxImageView             = [UIImageView new];
    [self.view insertSubview:_parallaxImageView belowSubview:_tableView];
    _parallaxImageView.contentMode = UIViewContentModeScaleAspectFill;
    _parallaxImageView.image       = self.parallaxImage;
    [_parallaxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        _parallaxHeaderHeightConstraint = make.height.equalTo(@(self.parallaxHeaderHeight));
    }];
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - kvo observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset = ((NSValue *)change[NSKeyValueChangeNewKey]).CGPointValue;
        _parallaxHeaderHeightConstraint.equalTo(contentOffset.y < 0 ? @(self.parallaxHeaderHeight - contentOffset.y) : @(self.parallaxHeaderHeight));
    }
}

- (void)dealloc
{
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - parallaxHeaderHeight
- (CGFloat)parallaxHeaderHeight
{
    return _parallaxHeaderHeight ? : kParallaxHeaderHeight;
}

- (void)setParallaxHeaderHeight:(CGFloat)parallaxHeaderHeight
{
    _parallaxHeaderHeight = parallaxHeaderHeight;
    CGRect headerFrame = self.tableView.tableHeaderView.frame;
    _tableViewHeaderContainer.frame = (CGRect){headerFrame.origin, {CGRectGetWidth(headerFrame), parallaxHeaderHeight}};
    _tableView.tableHeaderView = _tableViewHeaderContainer;
}

- (UIImage *)parallaxImage
{
    return _parallaxImage ? : [self imageWithColor:[UIColor lightGrayColor]];
}

- (void)setParallaxImage:(UIImage *)parallaxImage
{
    _parallaxImage           = parallaxImage;
    _parallaxImageView.image = parallaxImage;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

#pragma mark - imageWithColor
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGSize imageSize = CGSizeMake(1, 1);
    CGRect rect = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
