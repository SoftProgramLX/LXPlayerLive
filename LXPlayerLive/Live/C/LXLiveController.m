//
//  LXLiveController.m
//  LXLiveDemo
//
//  Created by 李旭 on 16/10/12.
//  Copyright © 2016年 lixu. All rights reserved.
//

#import "LXLiveController.h"
#import "LFLivePreview.h"

@interface LXLiveController ()
{
    LFLivePreview *livePreview;
}
@end

@implementation LXLiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    livePreview = [[LFLivePreview alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:livePreview];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [livePreview removeFromSuperview];
    livePreview = nil;
    [super viewDidDisappear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
