
//  Motion.m


#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "Motion.h"

@implementation Motion

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (id) init {
  self = [super init];
  NSLog(@"Device Motion");

  if (self) {
    self->_motionManager = [[CMMotionManager alloc] init];
    //Motion
    if([self->_motionManager isDeviceMotionAvailable])
    {
      NSLog(@"Device motion available");
      /* Start the device motion sensor if it is not active already */
      if([self->_motionManager isDeviceMotionActive] == NO)
      {
        NSLog(@"Device motion active");
      } else {
        NSLog(@"Device motion not active");
      }
    }
    else
    {
      NSLog(@"Device motion not available!");
    }
  }
  return self;
}

RCT_EXPORT_METHOD(setUpdateInterval:(double) interval) {
  NSLog(@"setUpdateInterval: %f", interval);
  double intervalInSeconds = interval / 1000;

  [self->_motionManager setDeviceMotionUpdateInterval:intervalInSeconds];
}

RCT_EXPORT_METHOD(getUpdateInterval:(RCTResponseSenderBlock) cb) {
  double interval = self->_motionManager.deviceMotionUpdateInterval;
  NSLog(@"getUpdateInterval: %f", interval);
  cb(@[[NSNull null], [NSNumber numberWithDouble:interval]]);
}

RCT_EXPORT_METHOD(getData:(RCTResponseSenderBlock) cb) {
  double gravityX = self->_motionManager.deviceMotion.gravity.x;
  double gravityY = self->_motionManager.deviceMotion.gravity.y;
  double gravityZ = self->_motionManager.deviceMotion.gravity.z;

  double userX = self->_motionManager.deviceMotion.userAcceleration.x;
  double userY = self->_motionManager.deviceMotion.userAcceleration.y;
  double userZ = self->_motionManager.deviceMotion.userAcceleration.z;

  double rotationX = self->_motionManager.deviceMotion.rotationRate.x;
  double rotationY = self->_motionManager.deviceMotion.rotationRate.y;
  double rotationZ = self->_motionManager.deviceMotion.rotationRate.z;

  double timestamp = self->_motionManager.deviceMotion.timestamp;

  NSLog(@"getData: %f, %f, %f, %f, %f, %f, %f, %f, %f, %f", gravityX, gravityY, gravityZ, userX, userY, userZ, rotationX, rotationY, rotationZ, timestamp);

  cb(@[[NSNull null], @{
         @"gravity" : @{
             @"x" : [NSNumber numberWithDouble:gravityX],
             @"y" : [NSNumber numberWithDouble:gravityY],
             @"z" : [NSNumber numberWithDouble:gravityZ]
             },
         @"user" : @{
             @"x" : [NSNumber numberWithDouble:userX],
             @"y" : [NSNumber numberWithDouble:userY],
             @"z" : [NSNumber numberWithDouble:userZ]
             },
         @"rotation" : @{
             @"x" : [NSNumber numberWithDouble:rotationX],
             @"y" : [NSNumber numberWithDouble:rotationY],
             @"z" : [NSNumber numberWithDouble:rotationZ]
             },
         @"timestamp" : [NSNumber numberWithDouble:timestamp]
         }]
     );
}

RCT_EXPORT_METHOD(startUpdates) {
  NSLog(@"startUpdates");
  [self->_motionManager startDeviceMotionUpdates];

  /* Receive the device motion data on this block */
  [self->_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                             withHandler:^(CMDeviceMotion *deviceMotionData, NSError *error)
   {
     double gravityX = deviceMotionData.gravity.x;
     double gravityY = deviceMotionData.gravity.y;
     double gravityZ = deviceMotionData.gravity.z;

     double userX = deviceMotionData.userAcceleration.x;
     double userY = deviceMotionData.userAcceleration.y;
     double userZ = deviceMotionData.userAcceleration.z;

     double rotationX = deviceMotionData.rotationRate.x;
     double rotationY = deviceMotionData.rotationRate.y;
     double rotationZ = deviceMotionData.rotationRate.z;

     double timestamp = deviceMotionData.timestamp;
     NSLog(@"startDeviceMotionUpdates: %f, %f, %f, %f, %f, %f, %f, %f, %f, %f", gravityX, gravityY, gravityZ, userX, userY, userZ, rotationX, rotationY, rotationZ, timestamp);

     [self.bridge.eventDispatcher sendDeviceEventWithName:@"Motion" body:@{
                                                                           @"gravity" : @{
                                                                               @"x" : [NSNumber numberWithDouble:gravityX],
                                                                               @"y" : [NSNumber numberWithDouble:gravityY],
                                                                               @"z" : [NSNumber numberWithDouble:gravityZ]
                                                                               },
                                                                           @"user" : @{
                                                                               @"x" : [NSNumber numberWithDouble:userX],
                                                                               @"y" : [NSNumber numberWithDouble:userY],
                                                                               @"z" : [NSNumber numberWithDouble:userZ]
                                                                               },
                                                                           @"rotation" : @{
                                                                               @"x" : [NSNumber numberWithDouble:rotationX],
                                                                               @"y" : [NSNumber numberWithDouble:rotationY],
                                                                               @"z" : [NSNumber numberWithDouble:rotationZ]
                                                                               },
                                                                           @"timestamp" : [NSNumber numberWithDouble:timestamp]
                                                                           }];
   }];

}

RCT_EXPORT_METHOD(stopUpdates) {
  NSLog(@"stopUpdates");
  [self->_motionManager stopDeviceMotionUpdates];
}

@end
