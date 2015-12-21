//
//  ViewController.m
//  LPParallaxTableViewControllerSample
//
//  Created by litt1e-p on 15/12/21.
//  Copyright © 2015年 litt1e-p. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

static NSString *const kParallaxViewCellID = @"kMeViewCellID";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title                = @"ParallaxEffect";
    self.parallaxImage        = [UIImage imageNamed:@"me_header_bg"];
    self.parallaxHeaderHeight = 150.f;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kParallaxViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kParallaxViewCellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row - %ld", (long)indexPath.row];
    return cell;
}

@end
