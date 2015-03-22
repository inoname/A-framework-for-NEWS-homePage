//
//  ViewController.m
//  新闻首页
//
//  Created by kouliang on 15/1/31.
//  Copyright (c) 2015年 kouliang. All rights reserved.
//

#import "ViewController.h"
#import "KLLabel.h"
#import "KLNewsController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *titlesScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentsScrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0.添加子控制器
    [self setupChildVces];
    
    // 1.添加顶部的所有标题
    [self setupTitles];
    
    // 2.添加默认控制器
    UIViewController *firstVc = [self.childViewControllers firstObject];
    firstVc.view.frame = self.contentsScrollView.bounds;
    [self.contentsScrollView addSubview:firstVc.view];
    
    // 2.1设置默认控制器的label
    KLLabel *firstLb=self.titlesScrollView.subviews[0];
    [firstLb adjust:1];
    
    // 3.设置内容size
#warning 现在计算屏幕宽度不能用 self.contentsScrollView.bounds
    CGFloat contentsContentW = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.contentsScrollView.contentSize = CGSizeMake(contentsContentW, 0);
    
    
    //4.设置代理
    self.contentsScrollView.delegate=self;
}

/**
 *  添加子控制器
 */
- (void)setupChildVces
{
    KLNewsController *vc01 = [[KLNewsController alloc] init];
    vc01.title = @"栏目首页";
    [self addChildViewController:vc01];
    
    KLNewsController *vc02 = [[KLNewsController alloc] init];
    vc02.title = @"新闻";
    [self addChildViewController:vc02];
    
    KLNewsController *vc03 = [[KLNewsController alloc] init];
    vc03.title = @"活动";
    [self addChildViewController:vc03];
    
    KLNewsController *vc04 = [[KLNewsController alloc] init];
    vc04.title = @"通知";
    [self addChildViewController:vc04];
    
    KLNewsController *vc05 = [[KLNewsController alloc] init];
    vc05.title = @"教务";
    [self addChildViewController:vc05];
    
    KLNewsController *vc06 = [[KLNewsController alloc] init];
    vc06.title = @"社会";
    [self addChildViewController:vc06];
    
    KLNewsController *vc07 = [[KLNewsController alloc] init];
    vc07.title = @"教育";
    [self addChildViewController:vc07];
}

/**
 *  添加顶部的所有标题
 */
- (void)setupTitles
{
    // 初始化标题
    NSUInteger count = self.childViewControllers.count;
    CGFloat labelW = 80;
    
#warning 之前的自动布局中已经将titlesScrollView的height设为94，所以才设置labelY=0，labelH=30
    
    CGFloat labelH = 30;
    CGFloat labelY = 0;
    for (NSUInteger i = 0; i < count; ++i) {
        // 创建label
        KLLabel *label = [[KLLabel alloc] init];
        label.tag = i;
        [self.titlesScrollView addSubview:label];
        
        // 设置frame
        CGFloat labelX = i * labelW;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        // 设置文字
        UIViewController *vc = self.childViewControllers[i];
        label.text = vc.title;
        
        // 监听点击
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    }
    
    // 设置scrollView的内容大小
    CGFloat titlesContentW = count * labelW;
    self.titlesScrollView.contentSize = CGSizeMake(titlesContentW, 0);
}

/**
 *  监听label的点击
 */
- (void)labelClick:(UITapGestureRecognizer *)recognizer
{
    // 获得被点击的label
    KLLabel *label = (KLLabel *)recognizer.view;
    
    // 计算x方向上的偏移量
    CGFloat offsetX = label.tag * self.contentsScrollView.frame.size.width;
    
    // 设置偏移量
    CGPoint offset = CGPointMake(offsetX, self.contentsScrollView.contentOffset.y);
    [self.contentsScrollView setContentOffset:offset animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
/**
 *  在scrollView动画结束时调用(添加子控制器的view到self.contentsScrollView)
 *  self.contentsScrollView == scrollView
 *  用户手动触发的动画结束，不会调用这个方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得当前需要显示的子控制器的索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
#pragma mark 滚动标题栏（self.titlesScrollView）
    KLLabel *label = self.titlesScrollView.subviews[index];
    CGFloat titlesW = self.titlesScrollView.frame.size.width;
    CGFloat offsetX = label.center.x - titlesW * 0.5;
    // 最大的偏移量
    CGFloat maxOffsetX = self.titlesScrollView.contentSize.width - titlesW;
    if (offsetX < 0) {
        offsetX = 0;
    } else if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
#warning scrollView在有导航栏的情况下contentOffset为(0,-64)
    CGPoint offset = CGPointMake(offsetX, self.titlesScrollView.contentOffset.y);
    [self.titlesScrollView setContentOffset:offset animated:YES];
  
#pragma mark 恢复当前label除外的label
    [self.titlesScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx!=index) {
            [(KLLabel *)obj adjust:0];
        }
    }];
    
    UIViewController *vc = self.childViewControllers[index];
    // 如果子控制器的view已经在上面，就直接返回
    if (vc.view.superview) return;
    
    // 添加
    CGFloat vcW = scrollView.frame.size.width;
    CGFloat vcH = scrollView.frame.size.height;
    CGFloat vcX = index * vcW;
    CGFloat vcY = 0;
    vc.view.frame = CGRectMake(vcX, vcY, vcW, vcH);
    
    [scrollView addSubview:vc.view];
}

/**
 *  当scrollView停止滚动时调用这个方法（用户手动触发的动画停止，会调用这个方法）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/**
 *  滚动过程中一直调用
 *
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat value = self.contentsScrollView.contentOffset.x / self.contentsScrollView.bounds.size.width;
    NSUInteger oneIndex = (NSUInteger)value;
    NSUInteger twoIndex = oneIndex + 1;
    CGFloat twoPercent = value - oneIndex;
    CGFloat onePercent = 1 - twoPercent;
    
    //边界处理
    if (value<0) {
        onePercent=1+value;
        twoPercent=0;
    }
    
    KLLabel *oneLabel=self.titlesScrollView.subviews[oneIndex];
    [oneLabel adjust:onePercent];
    
    //边界处理
    if (twoIndex<self.titlesScrollView.subviews.count) {
        KLLabel *twoLabel=self.titlesScrollView.subviews[twoIndex];
        [twoLabel adjust:twoPercent];
    }
}

@end
