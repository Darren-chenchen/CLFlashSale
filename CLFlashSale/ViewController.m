//
//  ViewController.m
//  CLFlashSale
//
//  Created by darren on 16/8/26.
//  Copyright © 2016年 shanku. All rights reserved.
//

#import "ViewController.h"
#import "flashSaleView.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 从1970年到2016-8-26 12:55:00的时间（秒）使用时记得把这个时间设置现在之后的时间，服务器返回一个2016-8-26 19:55:00格式的结束时间就好
    NSString *string = @"2016-8-27 13:26:00";
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [fmt dateFromString:string];
    NSTimeInterval a2=[date timeIntervalSince1970];
    NSString *timeString2 = [NSString stringWithFormat:@"%.0f", a2];
    
    // 创建倒计时的控件  ： 该控制只支持24小时之内的倒计时
    flashSaleView *flashView = [[flashSaleView alloc] initWithFrame:CGRectMake(100, 100, 130, 15) andEndTimer:timeString2];
    [self.view addSubview:flashView];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(100, 120, 200, 20)];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = [UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1];
    lable.text = [NSString stringWithFormat:@"%@ 结束",string];
    [self.view addSubview:lable];
}
- (IBAction)clickBtn:(id)sender {
    SecondViewController *secVC = [[SecondViewController alloc] init];
    [self presentViewController:secVC animated:YES completion:nil];
}

@end
