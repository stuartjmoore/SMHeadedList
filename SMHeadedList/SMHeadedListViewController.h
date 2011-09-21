//
//  SMHeadedListViewController.h
//  SMHeadedList
//
//  Created by Stuart Moore on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SMHeaderCellView.h"

@interface SMHeadedListViewController : UITableViewController <UITableViewDelegate>
{
    BOOL direction;
    float threshold;
}

@property (nonatomic, retain) UITableView *headerTable;
@property (nonatomic, retain) UITableView *itemsTable;

@end
