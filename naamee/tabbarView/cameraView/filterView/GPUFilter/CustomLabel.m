//
//  CustomLabel.m
//  AONE
//
//  Created by Ajit on 16/01/16.
//  Copyright (c) 2016 Michael AOne. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 5, 0, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
