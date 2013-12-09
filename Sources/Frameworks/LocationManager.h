//
//  LocationManager.h
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 19.11.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

+ (LocationManager *)sharedInstance;

@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, assign) int accuracy;

@end
