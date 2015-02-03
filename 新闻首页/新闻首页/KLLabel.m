//
//  KLLabel.m
//  新闻首页
//
//  Created by kouliang on 15/1/31.
//  Copyright (c) 2015年 kouliang. All rights reserved.
//


#warning 做文字渐变效果时的注意点
// 1.文字大小在改变时会在整数间进行跳跃，如果通过改变文字大小来实现动画效果，会有文字抖动。
// 2.可以考虑通过transform属性来改变文字大小。任何控件的transform都是围绕着中心点进行的
// 3.在scrollViewDidScroll方法中取得的contentOffset值是不连续的，这可能会造成跨越多个label进行文字渐变时，中间的label调整时percent不能取到0，所以文字颜色和大小不能恢复到原来的状态。解决方法为在滚动结束后统一设置其他label的[adjust:0];

#import "KLLabel.h"

static const CGFloat NormalSize = 10.0f;
static const CGFloat SelectSize = 25.0f;
#define NormalFont [UIFont systemFontOfSize:NormalSize]
#define SelectedFont [UIFont systemFontOfSize:SelectSize]

#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@implementation KLLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:20.0];
        self.userInteractionEnabled = YES;
        
        [self adjust:0];
    }
    return self;
}

- (void)adjust:(CGFloat)percent
{
    // 调整文字大小
//    CGFloat size = NormalSize + (SelectSize - NormalSize) * percent;
//    self.font = [UIFont systemFontOfSize:size];
    
    // 调整颜色
    self.textColor=Color(255*percent, 0, 0);
    
    // 大小渐变
    CGFloat minWhScale = 0.6; // [0.7, 1.0]
    CGFloat whScale = minWhScale + percent * (1 - minWhScale);
    self.transform = CGAffineTransformMakeScale(whScale, whScale);
}

@end
