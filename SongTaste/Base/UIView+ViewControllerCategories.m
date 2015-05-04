//
//  UIView+ViewControllerCategories.m
//  SongTaste
//
//  Created by William on 15/5/3.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "UIView+ViewControllerCategories.h"

@implementation UIView (ViewControllerCategories)

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
         UIResponder *nextResponder = [next nextResponder];
         if ([nextResponder isKindOfClass:[UIViewController class]]) {
             return (UIViewController *)nextResponder;
         }
     }
     return nil;
}

@end
