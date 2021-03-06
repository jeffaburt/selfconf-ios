//
//  SCUpdatingEventBaseViewController.h
//  SelfConference
//
//  Created by Jeff Burt on 5/19/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCEvent;

@interface SCUpdatingEventBaseViewController : UIViewController

@property (nonatomic) SCEvent *event;

/** Refreshes all data associated with '_event'. */
- (void)refreshEventData;

@end
