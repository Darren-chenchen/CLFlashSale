//
//  flashSaleView.m
//  CLFlashSale
//
//  Created by darren on 16/8/26.
//  Copyright © 2016年 shanku. All rights reserved.
//

#define TimerFont [UIFont systemFontOfSize:12]

#import "flashSaleView.h"

@interface flashSaleView()
{
    NSUInteger expiresTime;
    NSUInteger nowTime;
    NSDate *date1970;
    NSDateFormatter *dateFormatter;
    NSInteger aDay;
}
/**小时*/
@property (nonatomic,strong) UIButton *hourBtn;
/**分钟*/
@property (nonatomic,strong) UIButton *minuteBtn;
/**秒*/
@property (nonatomic,strong) UIButton *secondBtn;

/**:*/
@property (nonatomic,strong) UIButton *mBtn1;
@property (nonatomic,strong) UIButton *mBtn2;
@end

@implementation flashSaleView
- (UIButton *)hourBtn
{
    if (_hourBtn == nil) {
        _hourBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hourBtn.frame = CGRectMake(0, 0, 20, self.frame.size.height);
        _hourBtn.backgroundColor = [UIColor blackColor];
        _hourBtn.titleLabel.font = TimerFont;
    }
    return _hourBtn;
}
- (UIButton *)mBtn1
{
    if (_mBtn1 == nil) {
        _mBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _mBtn1.frame = CGRectMake(CGRectGetMaxX(_hourBtn.frame), -1, 10, _hourBtn.frame.size.height);
        _mBtn1.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_mBtn1 setTitle:@":" forState:UIControlStateNormal];
        [_mBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _mBtn1;
}

- (UIButton *)minuteBtn
{
    if (_minuteBtn == nil) {
        _minuteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _minuteBtn.frame = CGRectMake(CGRectGetMaxX(_mBtn1.frame),0 , 20, _hourBtn.frame.size.height);
        _minuteBtn.titleLabel.font = TimerFont;
        _minuteBtn.backgroundColor = [UIColor blackColor];
    }
    return _minuteBtn;
}
- (UIButton *)mBtn2
{
    if (_mBtn2 == nil) {
        _mBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _mBtn2.frame = CGRectMake(CGRectGetMaxX(_minuteBtn.frame), -1, 10, _hourBtn.frame.size.height);
        _mBtn2.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_mBtn2 setTitle:@":" forState:UIControlStateNormal];
        [_mBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _mBtn2;
}
- (UIButton *)secondBtn
{
    if (_secondBtn == nil) {
        _secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _secondBtn.frame = CGRectMake(CGRectGetMaxX(_mBtn2.frame), 0, 20,_hourBtn.frame.size.height);
        _secondBtn.backgroundColor = [UIColor blackColor];
        _secondBtn.titleLabel.font = TimerFont;

    }
    return _secondBtn;
}
- (instancetype)initWithFrame:(CGRect)frame andEndTimer:(NSString *)endTimer
{
    if (self == [super initWithFrame:frame]) {
        
        date1970 = [NSDate dateWithTimeIntervalSince1970:0];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH mm ss"];
        aDay = 86399;
        expiresTime = 0;
        nowTime = 0;
        
        // 从1970年到现在的时间（秒）
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval second =[dat timeIntervalSince1970];
        NSString *starTimer = [NSString stringWithFormat:@"%.0f", second];

        [self addSubview:self.hourBtn];
        [self addSubview:self.mBtn1];
        [self addSubview:self.minuteBtn];
        [self addSubview:self.mBtn2];
        [self addSubview:self.secondBtn];
        
        expiresTime = endTimer.longLongValue;
        nowTime = starTimer.longLongValue;
        
        __block NSUInteger timeout= expiresTime; //倒计时时间
        NSString *curStr = [self homeLimitTimeString];
        [self labelValueHandler:curStr];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=starTimer.longLongValue){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }else{
                NSString *curStr1 = [self homeLimitTimeString];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self labelValueHandler:curStr1];
                });
                
                timeout--;
            }
        });
        dispatch_resume(_timer);

    }
    return self;
}
-(NSString*)homeLimitTimeString{
    
    NSTimeInterval timeActualValue;
    if (expiresTime<nowTime) {
        return @"00 00 00";
    }
    NSTimeInterval diffTime  = expiresTime - nowTime;
//    NSLog(@"%ld",(expiresTime - nowTime)/3600/24);   /// 这里可以设置天数
    timeActualValue = diffTime;
    nowTime++;

    NSDate *curDate = [date1970 dateByAddingTimeInterval:timeActualValue];
    NSTimeZone *zone =  [NSTimeZone timeZoneWithAbbreviation:@"GMT-0800"];
    NSInteger interval = [zone secondsFromGMTForDate: curDate];
    NSDate *localeDate = [curDate  dateByAddingTimeInterval: interval];
    NSString *destDateString = [dateFormatter stringFromDate:localeDate];
    
    return destDateString;
}
-(void)labelValueHandler:(NSString*)text{
    NSArray *titleArr = [text componentsSeparatedByString:@" "];
    [self.hourBtn setTitle:titleArr[0] forState:UIControlStateNormal];
    [self.minuteBtn setTitle:titleArr[1] forState:UIControlStateNormal];
    [self.secondBtn setTitle:titleArr[2] forState:UIControlStateNormal];
}
@end
