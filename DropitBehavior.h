//
//  DropitBehavior.h
//  STFDemo-DropIt
//
//  Created by 刘大大 on 16/4/17.
//  Copyright © 2016年 GeniusLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropitBehavior : UIDynamicBehavior
-(void)addItem:(id<UIDynamicItem>)item;
-(void)removeItem:(id<UIDynamicItem>)item;
@end
