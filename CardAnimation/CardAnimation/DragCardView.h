//
//  DragCardView.h
//  CardAnimation
//
//  Created by 深圳市泥巴装网络科技有限公司 on 16/9/26.
//  Copyright © 2016年 马晓强. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ROTATION_ANGLE M_PI/8
#define CLICK_ANIMATION_TIME 0.5
#define RESET_ANIMATION_TIME 0.3

@class DragCardView;
@protocol DragCardViewDelegate <NSObject>

-(void)swipCard:(DragCardView *)cardView Direction:(BOOL)isRight;
-(void)moveCards:(CGFloat)distance;
-(void)moveBackCards;
-(void)adjustOtherCards;

@end


@interface DragCardView : UIView

@property (nonatomic, weak) id<DragCardViewDelegate> delegate;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGAffineTransform originalTransform;
@property (nonatomic, assign) CGPoint originalPoint;
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) BOOL canPan;
@property (nonatomic, strong) NSDictionary *infoDict;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, strong) UIButton *yesButton;


-(void)leftButtonClickAction;
-(void)rightButtonClickAction;











@end
