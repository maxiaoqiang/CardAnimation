//
//  DragCardView.m
//  CardAnimation
//
//  Created by 深圳市泥巴装网络科技有限公司 on 16/9/26.
//  Copyright © 2016年 马晓强. All rights reserved.
//

#import "DragCardView.h"
#import "CardHeader.h"

#define ACTION_MARGIN_RIGHT lengthFit(150)
#define ACTION_MARGIN_LefT lengthFit(150)
#define ACTION_VELOCITY 400
#define SCALE_STRENGTH 4
#define SCALE_MAX 0.93
#define ROTATION_MAX 1
#define ROTATION_STRENGTH lengthFit(414)
#define BUTTON_WIDTH lengthFit(40)

@interface DragCardView(){
    CGFloat xFromCenter;
    CGFloat yFromCenter;
    
}

@property (nonatomic, strong) UILabel *namelabel;
@end

@implementation DragCardView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(beingDragged:)];
        [self addGestureRecognizer:self.panGesture];
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.layer.cornerRadius = 4;
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
        
        self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.headerImageView.backgroundColor = [UIColor lightGrayColor];
        self.headerImageView.userInteractionEnabled = YES;
        [bgView addSubview:self.headerImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self.headerImageView addGestureRecognizer:tap];
        
        self.namelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.width + 10, self.frame.size.width - 40, 20)];
        self.namelabel.font = [UIFont systemFontOfSize:16];
        self.namelabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [bgView addSubview:self.namelabel];
        
        UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.width + 30, self.frame.size.width - 40, 20)];
        alertLabel.font = [UIFont systemFontOfSize:12];
        alertLabel.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1];
        alertLabel.text = @"其它,10km";
        [bgView addSubview:alertLabel];
        
        self.layer.allowsEdgeAntialiasing = YES;
        bgView.layer.allowsEdgeAntialiasing = YES;
        self.headerImageView.layer.allowsEdgeAntialiasing = YES;
        
    }
    return self;
    
}

-(void)tapGesture:(UITapGestureRecognizer *)sender{
    if (!self.canPan) {
        return;
    }
    NSLog(@"tap");
}

-(void)layoutSubviews{
    self.namelabel.text = [NSString stringWithFormat:@"郑爽 %@号",self.infoDict[@"number"]];
    self.headerImageView.image = [UIImage imageNamed:self.infoDict[@"image"]];
}

#pragma mark-拖动手势
-(void)beingDragged:(UITapGestureRecognizer *)gesture{
    if (!self.canPan) {
        return;
    }
    xFromCenter = [gesture locationInView:self].x;
    yFromCenter = [gesture locationInView:self].y;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
        
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat rotationStrength = MIN(xFromCenter/ROTATION_STRENGTH, ROTATION_MAX);
            CGFloat rotationAngel = (CGFloat)(ROTATION_ANGLE * rotationStrength);
            CGFloat scale = MAX(1- fabs(rotationStrength)/SCALE_STRENGTH, SCALE_MAX);
            self.center = CGPointMake(self.originalCenter.x + xFromCenter, self.originalCenter.y + yFromCenter);
            
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.transform = scaleTransform;
        
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            
        }
            break;
        default:
            break;
    }

    
    
    
    
    
}




@end
