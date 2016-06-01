//
//  DropitBehavior.m
//  STFDemo-DropIt
//
//  Created by 刘大大 on 16/4/17.
//  Copyright © 2016年 GeniusLiu. All rights reserved.
//

#import "DropitBehavior.h"
@interface DropitBehavior()
@property(nonatomic,strong)UIGravityBehavior *gravity;
@property(nonatomic,strong)UICollisionBehavior *collision;
@property(nonatomic,strong)UIDynamicItemBehavior *animinationOptions;

@end
@implementation DropitBehavior

-(UIGravityBehavior *)gravity{
    if (_gravity==nil) {
        _gravity=[[UIGravityBehavior alloc]init];
    }
    return _gravity;
}
-(UICollisionBehavior *)collision{
    if (_collision==nil) {
        _collision=[[UICollisionBehavior alloc]init];
        _collision.translatesReferenceBoundsIntoBoundary=YES;
    }
    return _collision;
}
-(UIDynamicItemBehavior *)animinationOptions{
    if(_animinationOptions==nil){
        _animinationOptions=[[UIDynamicItemBehavior alloc]init];
        _animinationOptions.allowsRotation=NO;
    }
    return _animinationOptions;
}
-(void)addItem:(id<UIDynamicItem>)item{
    [self.gravity addItem:item];
    [self.collision addItem:item];
    [self.animinationOptions addItem:item];
}
-(void)removeItem:(id<UIDynamicItem>)item{
    [self.gravity removeItem:item];
    [self.collision removeItem:item];
    [self.animinationOptions removeItem:item];
}
-(instancetype)init{
    self=[super init];
    [self addChildBehavior:self.gravity];
    [self addChildBehavior:self.collision];
    [self addChildBehavior:self.animinationOptions];
    return self;
}
@end

