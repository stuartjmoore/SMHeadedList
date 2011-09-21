//
//  SMHeaderCellView.m
//  SMHeadedList
//
//  Created by Stuart Moore on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SMHeaderCellView.h"

@implementation SMHeaderCellView

@synthesize itemsTable = _itemsTable;

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    return [self.itemsTable hitTest:point withEvent:event];
}

@end
