//
//  LocationManager.m
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 19.11.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation LocationManager

static LocationManager *sharedInstance = nil;

+ (LocationManager *)sharedInstance
{
    @synchronized(self)
    {
        if(!sharedInstance)
        {
            sharedInstance = [[LocationManager alloc] init];
        }
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.delegate = self;
        
        [_locationManager startUpdatingLocation];
        
        _location = CLLocationCoordinate2DMake(0, 0);
        _accuracy = 0;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _location = newLocation.coordinate;
    _accuracy = newLocation.horizontalAccuracy;
}

@end
