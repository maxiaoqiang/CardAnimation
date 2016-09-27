//
//  ViewController.m
//  CardAnimation
//
//  Created by 深圳市泥巴装网络科技有限公司 on 16/9/26.
//  Copyright © 2016年 马晓强. All rights reserved.
//

#import "ViewController.h"
#import "DragCardView.h"
#import "CardHeader.h"

#define CARD_NUM 5
#define MIN_INFO_NUM 10
#define CARD_SCALE 0.95

@interface ViewController ()<DragCardViewDelegate>

@property (nonatomic, strong) NSMutableArray *allCards;

@property (nonatomic, assign) CGPoint lastCardCenter;
@property (nonatomic, assign) CGAffineTransform lastCardTTransform;
@property (nonatomic, strong) NSMutableArray *sourceObject;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *disLikeBtn;

@property (nonatomic, assign) BOOL flag;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡片";
    self.allCards = [NSMutableArray array];
    self.sourceObject = [NSMutableArray array];
    self.page = 0;
    
}

#pragma mark--添加控件
-(void)addControls{
    UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [reloadBtn setTitle:@"重置" forState:UIControlStateNormal];
    reloadBtn.frame = CGRectMake(self.view.center.x - 25, self.view.frame.size.height - 60, 50, 30);
    [reloadBtn addTarget:self action:@selector(refreshAllCards) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadBtn];
    
    self.disLikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.disLikeBtn.frame = CGRectMake(lengthFit(80), CARD_HEIGHT + lengthFit(100), 60, 60);
    [self.disLikeBtn setImage:[UIImage imageNamed:@"dislikeBtn"] forState:UIControlStateNormal];
    [self.disLikeBtn addTarget:self action:@selector(leftButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.disLikeBtn];
    
    
    self.likeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    self.likeBtn.frame = CGRectMake(self.view.frame.size.width - lengthFit(80) - 60, CARD_HEIGHT + lengthFit(100), 60, 60);
    [self.likeBtn setImage:[UIImage imageNamed:@"likeBtn"] forState:UIControlStateNormal];
    [self.likeBtn addTarget:self action:@selector(rightButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.likeBtn];
}

#pragma mark--刷新所有卡片
-(void)refreshAllCards{
    self.sourceObject = [@[] mutableCopy];
    self.page = 0;
    for (int i = 0; i <_allCards.count; i ++) {
        DragCardView *card = self.allCards[i];
        CGPoint finishPoint = CGPointMake(-CARD_WIDTH, 2 * PAN_DISTANCE + card.frame.origin.y);
       [UIView animateKeyframesWithDuration:0.5 delay:0.06 * i options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
           card.center = finishPoint;
           card.transform = CGAffineTransformMakeRotation(-ROTATION_ANGLE);
       } completion:^(BOOL finished) {
           
           card.yesButton.transform = CGAffineTransformMakeScale(1, 1);
           card.transform = CGAffineTransformMakeRotation(ROTATION_ANGLE);
           card.hidden = YES;
           card.center = CGPointMake([[UIScreen mainScreen] bounds].size.width + CARD_WIDTH, self.view.center.y);
           if (i == _allCards.count - 1) {
               [self requestSourceData:YES];
           }
       }];
        
        
    }
}

#pragma mark--请求数据
-(void)requestSourceData:(BOOL)needLoad{
        /** 在此添加网络数据请求代码 */
    NSMutableArray *objectArray = [@[] mutableCopy];
    for (int i = 1; i <= 10; i ++) {
        [objectArray addObject:@{@"number":[NSString stringWithFormat:@"%ld",self.page * 10 + i],@"image":[NSString stringWithFormat:@"%d.jpeg",i]}];
    }
    [self.sourceObject addObjectsFromArray:objectArray];
    self.page ++;
    
    //如果只是补充数据则不需要重新load卡片，而若是刷新卡片组则需要重新load
    if (needLoad) {
        [self loadAllCards];
    }
    
}
#pragma mark--重新加载卡片
-(void)loadAllCards{
    for (int i = 0; i < self.allCards.count; i ++) {
        DragCardView *draggableView = self.allCards[i];
        if ([self.sourceObject firstObject]) {
            draggableView.infoDict = [self.sourceObject firstObject];
            [self.sourceObject removeObjectAtIndex:0];
            [draggableView layoutSubviews];
            draggableView.hidden = NO;
        }else{
            draggableView.hidden = YES;//如果没有数据则隐藏卡片
        }
    }
    
    for (int i = 0; i < _allCards.count; i ++) {
        DragCardView *draggableView = self.allCards[i];
        CGPoint finishPoint = CGPointMake(self.view.center.x, CARD_HEIGHT/2 + 40);
        [UIView animateKeyframesWithDuration:0.5 delay:0.06 * i options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            draggableView.center = finishPoint;
            draggableView.transform = CGAffineTransformMakeRotation(0);
            if (i >0&&i <CARD_WIDTH - 1) {
                DragCardView *preDraggableView = [_allCards objectAtIndex:i - 1];
                draggableView.transform = CGAffineTransformScale(draggableView.transform, pow(CARD_SCALE, i), pow(CARD_SCALE, i));
                CGRect frame = draggableView.frame;
                frame.origin.y = preDraggableView.frame.origin.y + (preDraggableView.frame.size.height - frame.size.height) + 10 * pow(0.7, i);
                draggableView.frame = frame;
                
            }else if (i==CARD_NUM - 1){
                DragCardView *preDraggableView = [_allCards objectAtIndex:i -1];
                draggableView.transform = preDraggableView.transform;
                draggableView.frame = preDraggableView.frame;
                
            }
            
            draggableView.originalCenter = draggableView.center;
            draggableView.originalTransform = draggableView.transform;
            
            if (i==CARD_NUM - 1) {
                self.lastCardCenter = draggableView.center;
                self.lastCardTTransform = draggableView.transform;
            }
            
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    
}

#pragma mark--首次添加卡片
-(void)addCards{
    for (int i = 0; i < CARD_NUM; i ++) {
        DragCardView *draggableView = [[DragCardView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width + CARD_WIDTH, self.view.center.y - CARD_HEIGHT/2, CARD_WIDTH, CARD_HEIGHT)];
        if (i > 0 && i <CARD_NUM - 1) {
            draggableView.transform = CGAffineTransformScale(draggableView.transform, pow(CARD_SCALE, i), pow(CARD_SCALE, i));
        }else if (i==CARD_NUM -1){
            draggableView.transform = CGAffineTransformScale(draggableView.transform, pow(CARD_SCALE, i-1), pow(CARD_SCALE, i-1));
        }
        draggableView.transform = CGAffineTransformMakeRotation(ROTATION_ANGLE);
        draggableView.delegate = self;
        [_allCards addObject:draggableView];
        if (i==0) {
            draggableView.canPan = YES;
        }else{
            draggableView.canPan = NO;
        }
        
    }
    for (int i = (int)CARD_NUM - 1; i >=0; i--) {
        [self.view addSubview:_allCards[i]];
    }
    
}

#pragma mark--滑动后续操作
-(void)swipCard:(DragCardView *)cardView Direction:(BOOL)isRight{
    if (isRight) {
        
    }
}


#pragma nark--like
-(void)like:(NSDictionary *)userInfo{
        /** 在此添加“喜欢”的后续操作 */
    NSLog(@"like:%@",userInfo[@"number"]);
}

#pragma mark--dislike
-(void)unlike:(NSDictionary *)userInfo{
        /** 在此添加“不喜欢”的后续操作 */
    NSLog(@"unlike:%@",userInfo[@"number"]);
}






@end
