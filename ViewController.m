//
//  ViewController.m
//  STFDemo-DropIt
//
//  Created by 刘大大 on 16/4/17.
//  Copyright © 2016年 GeniusLiu. All rights reserved.
//

#import "ViewController.h"
#import "DropitBehavior.h"
#import "BezierPathView.h"
@interface ViewController ()<UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet BezierPathView *GameView;
@property(strong,nonatomic)UIDynamicAnimator *animator;
@property(nonatomic,strong)DropitBehavior *dropitBehavior;
@property(nonatomic,strong)UIAttachmentBehavior *attachment;
@property(nonatomic,strong)UIView *droppingView;
@end

@implementation ViewController
static const CGSize DROP_SIZE={40,40};
- (void)viewDidLoad {
    [super viewDidLoad];
     [self.GameView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Drop:)]];
    [self.GameView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)]];
    // Do any additional setup after loading the view, typically from a nib.
}


//当一行被占满时，将这一行方块炸飞
-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator{
    [self removeCompletedRows];
}
-(BOOL)removeCompletedRows{
    NSMutableArray *dropToRemove=[[NSMutableArray alloc]init];
    for (CGFloat y=self.GameView.bounds.size.height-DROP_SIZE.height/2; y>0; y-=DROP_SIZE.height) {
        BOOL rowIsComplete=YES;
        NSMutableArray *dropsFound=[[NSMutableArray alloc]init];
    for (CGFloat x=self.GameView.bounds.size.width-DROP_SIZE.height/2; x>0; x-=DROP_SIZE.width) {
        UIView *hitView=[self.GameView hitTest:CGPointMake(x, y) withEvent:NULL];
        if ([hitView superview]==self.GameView) {
            [dropsFound addObject:hitView];
        }else{
            rowIsComplete=NO;
            break;
        }
    }
        if (![dropsFound count]) break;
        if (rowIsComplete) {
            [dropToRemove addObjectsFromArray:dropsFound];
        }
    }
        if ([dropToRemove count]) {
            for (UIView *drop in dropToRemove) {
                [self.dropitBehavior removeItem:drop];
            }
            [self animateRemovingDrops:dropToRemove];
        }
    return NO;
}
-(void)animateRemovingDrops:(NSArray *)dropsToRemove{
    [UIView animateWithDuration:1.0 animations:^{
        for (UIView *drop in dropsToRemove) {
            int x=(arc4random()%(int)(self.GameView.bounds.size.width*5))-(int)self.GameView.bounds.size.width*2;
            int y=self.GameView.bounds.size.height;
            drop.center=CGPointMake(x, -y);
        }
    }completion:^(BOOL finished) {
        [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
}

//重绘getter方法，并把DropitBehavior类中所有动作加入动画中
-(DropitBehavior *)dropitBehavior{
    if (!_dropitBehavior) {
        _dropitBehavior=[[DropitBehavior alloc]init];
        [self.animator addBehavior:_dropitBehavior];
    }
    return _dropitBehavior;
}

//初始化动画
-(UIDynamicAnimator *)animator{
    if (! _animator) {
        _animator=[[UIDynamicAnimator alloc]initWithReferenceView:self.GameView];
        _animator.delegate=self;
    }
    return _animator;
}


//点击手势
-(void)Drop:(UITapGestureRecognizer *)GestureRecognizer{
    CGRect frame;
    frame.origin=CGPointZero;
    frame.size=DROP_SIZE;
    int x=(arc4random()%(int)self.GameView.frame.size.width)/DROP_SIZE.width;
    frame.origin.x=x*DROP_SIZE.width;
    UIView *dropView=[[UIView alloc]initWithFrame:frame];
    [dropView setBackgroundColor:[self randomcolor]];
    self.droppingView=dropView;
    [self.GameView addSubview:dropView];
    [self.dropitBehavior addItem:dropView];
}
//拖动方块手势
-(void)panGesture:(UIPanGestureRecognizer *)GestureRecognizer{
    CGPoint gesturePoint=[GestureRecognizer locationInView:self.GameView];
    if (GestureRecognizer.state==UIGestureRecognizerStateBegan) {
        [self attachDropingViewToPoint:gesturePoint];
    }else if (GestureRecognizer.state==UIGestureRecognizerStateChanged) {
        self.attachment.anchorPoint=gesturePoint;
    }else if (GestureRecognizer.state==UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachment];
        self.GameView.path=nil;
    }
}
-(void)attachDropingViewToPoint:(CGPoint )anchorPoint{
    if (self.droppingView) {
        self.attachment=[[UIAttachmentBehavior alloc]initWithItem:self.droppingView attachedToAnchor:anchorPoint];
        UIView *droppingView=self.droppingView;
        __weak ViewController *weakSelf=self;
        self.attachment.action=^{
            UIBezierPath *path=[[UIBezierPath alloc]init];
            [path moveToPoint:weakSelf.attachment.anchorPoint];
            [path addLineToPoint:droppingView.center];
            weakSelf.GameView.path=path;
            
        };
        self.droppingView=nil;
        [self.animator addBehavior:self.attachment];
    }
}
-(UIColor *)randomcolor{
    switch (arc4random()%8) {
        case 0:
            return [UIColor greenColor];
            break;
        case 1:
            return [UIColor blueColor ];
            break;
        case 2:
            return [UIColor orangeColor];
            break;
        case 3:
            return [UIColor redColor];
            break;
        case 4:
            return [UIColor purpleColor];
            break;
        case 5:
            return [UIColor grayColor];
            break;
        case 6:
            return [UIColor blackColor];
            break;
        case 7:
            return [UIColor magentaColor];
            break;
    }
    return [UIColor blackColor];
}
@end
