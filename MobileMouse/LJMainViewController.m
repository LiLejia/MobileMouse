//
//  LJMainViewController.m
//  MobileMouse
//
//  Created by Henry Lee on 12-9-28.
//  Copyright (c) 2012年 Henry Lee. All rights reserved.
//

#import "LJMainViewController.h"

@implementation LJMainViewController


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    server = [[Server alloc]initWithProtocol:@"mouse"];
    
    server.delegate = self;
    
    NSError *error = nil;
    
    [server start:&error];
    
    if(error){
        NSLog(@"start error occoured : %@",[error localizedDescription]);
    }
    
//    UIAccelerometer *accMeter = [UIAccelerometer sharedAccelerometer];
//    
//    accMeter.delegate = self;
//    
//    accMeter.updateInterval = 1/30;
    
    formerX = 0;
    
    formerY = 0;
    
    cmmanager = [[CMMotionManager alloc] init];
    
    cmmanager.accelerometerUpdateInterval = 0.05;
    
    [cmmanager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMAccelerometerData *latestAcc, NSError *error){
                                        
                                        NSString *pointInfo = [NSString stringWithFormat:@"%f,%f,%f|",latestAcc.acceleration.x,latestAcc.acceleration.y,0.5];
                                        
                                        NSError *sendError = nil;
                                        
                                        if([server sendData:[pointInfo dataUsingEncoding:NSUTF8StringEncoding] error:&sendError])
                                            NSLog(@"Send Successfully");
                                        else
                                            NSLog(@"send failed, because :%@",[error localizedDescription]);
                                    
                                    
                                    }];

}

#pragma mark - AcceleroMeter Delegate

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
    if(formerX==0){
        formerX = acceleration.x;
        formerY = acceleration.y;
    }
    
    double relativeX = [self relativeChange:formerX and:acceleration.x];
    double relativeY = [self relativeChange:formerY and:acceleration.y];
    
    
    if((relativeX>0.05&&relativeX<1)||
       (relativeY>0.05&&relativeY<1))
    {
    
    NSString *pointInfo = [NSString stringWithFormat:@"%f,%f,%f|",acceleration.x,acceleration.y,0.5];
    
    NSError *error = nil;
    
    if([server sendData:[pointInfo dataUsingEncoding:NSUTF8StringEncoding] error:&error])
        NSLog(@"Send Successfully");
    else
        NSLog(@"send failed, because :%@",[error localizedDescription]);
        
    }
}


#pragma mark - Private Method

- (void)sendData:(NSString *)sendingString{
    
    NSError *error = nil;
    
    if([server sendData:[sendingString dataUsingEncoding:NSUTF8StringEncoding] error:&error]){
        NSLog(@"Send successfully!");
    }else{
        NSLog(@"Send failed");
    }
    
    if(error){
        NSLog(@"sending error:%@",[error localizedDescription]);
    }
    
}

- (double)relativeChange:(float)former and:(float)now{
    return fabs((now-former)/former);
}

#pragma mark - Server Delegate
// called when data gets here from the remote side of the server
- (void)server:(Server *)server didAcceptData:(NSData *)data{
    NSLog(@"server didAcceptData");
}
// sent when both sides of the connection are ready to go
- (void)serverRemoteConnectionComplete:(Server *)server{
    NSLog(@"serverRemoteConnectionComplete");
}
// called when the server is finished stopping
- (void)serverStopped:(Server *)server{
    NSLog(@"serverStopped");
}
// called when something goes wrong in the starup
- (void)server:(Server *)server didNotStart:(NSDictionary *)errorDict{
    NSLog(@"server didNotStart");
}
// called when the connection to the remote side is lost
- (void)server:(Server *)server lostConnection:(NSDictionary *)errorDict{
    NSLog(@"server lostConnection");
}
// called when a new service comes on line
- (void)serviceAdded:(NSNetService *)service moreComing:(BOOL)more{
    NSLog(@"serviceAdded");
}
// called when a service goes off line
- (void)serviceRemoved:(NSNetService *)service moreComing:(BOOL)more{
    NSLog(@"serviceRemoved");
}






@end
