//
//  SMHeadedListAppDelegate.h
//  SMHeadedList
//
//  Created by Stuart Moore on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMHeadedListViewController;

@interface SMHeadedListAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SMHeadedListViewController *viewController;

@end
