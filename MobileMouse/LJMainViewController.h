//
//  LJMainViewController.h
//  MobileMouse
//
//  Created by Henry Lee on 12-9-28.
//  Copyright (c) 2012年 Henry Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
#import <CoreMotion/CoreMotion.h>


@interface LJMainViewController : UIViewController<UIAccelerometerDelegate,ServerDelegate>{
    
    Server *server;
    
    float formerX;
    
    float formerY;
    
    CMMotionManager *cmmanager;
}
@end
