//
//  LJAppDelegate.h
//  MobileMouse
//
//  Created by Henry Lee on 12-9-28.
//  Copyright (c) 2012年 Henry Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJMainViewController.h"

@interface LJAppDelegate : UIResponder <UIApplicationDelegate>{

    LJMainViewController *mainViewController;

}

@property (strong, nonatomic) UIWindow *window;

@end
