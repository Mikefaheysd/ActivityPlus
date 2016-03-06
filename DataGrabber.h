//
//  DataGrabber.h
//  #Goals
//
//  Created by Michael Fahey on 9/29/15.
//  Copyright © 2015 Michael Fahey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
@interface DataGrabber : NSObject
@property (strong,nonatomic) HKHealthStore *healthStore;

- (id)initWithTitle;

- (void)fetchDailyStepsWithCompletionHandler:(void (^)(double, NSError *))completionHandler;
- (void)fetchDailyFlightsWithCompletionHandler:(void (^)(double, NSError *))completionHandler;
- (void)fetchDailyDistanceWithCompletionHandler:(void (^)(double, NSError *))completionHandler;
- (void)fetchDailyCaloriesWithCompletionHandler:(void (^)(double, NSError *))completionHandler;

- (void)fetchWeeklyStepsWithCompletionHandler:(void (^)(double, NSError *))completionHandler;

- (void)fetchLifetimeWorkoutsWithCompletionHandler:(void (^)(double, NSError *))completionHandler;
- (void)fetchLifetimeStepsWithCompletionHandler:(void (^)(double, NSError *))completionHandler;
- (void)fetchLifetimeDistanceWithCompletionHandler:(void (^)(double, NSError *))completionHandler;

- (void)fetchWeightWithCompletionHandler:(void (^)(double, NSError *))completionHandler;

@end
