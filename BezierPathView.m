//
//  BezierPathView.m
//  STFDemo-DropIt
//
//  Created by 刘大大 on 16/4/18.
//  Copyright © 2016年 GeniusLiu. All rights reserved.
//

#import "BezierPathView.h"
@interface BezierPathView()

@end
@implementation BezierPathView
-(void)setPath:(UIBezierPath *)path{
    _path=path;
    
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect{
    
    
    [self.path stroke];
}
@end
