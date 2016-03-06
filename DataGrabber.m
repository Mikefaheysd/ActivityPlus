//
//  DataGrabber.m
//  #Goals
//
//  Created by Michael Fahey on 9/29/15.
//  Copyright © 2015 Michael Fahey. All rights reserved.
//

#import "DataGrabber.h"

@implementation DataGrabber


- (id)initWithTitle{
    _healthStore =[[HKHealthStore alloc] init];
    return self;
}

- (void)fetchWeightWithCompletionHandler:(void (^)(double, NSError *))completionHandler {
    NSLog(@"in most recent weight");
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:weightType predicate:nil limit:1 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (!results) {
            return;
        }
        HKQuantitySample *quantitySample = results.firstObject;
        
        HKQuantity *quantity = quantitySample.quantity;
        double test = [quantity doubleValueForUnit:[HKUnit poundUnit]];
        
        NSNumber *difference = [NSNumber numberWithFloat:(/*[weight floatValue]*/168 - test)];
        double newWeight = [difference intValue];
        if (completionHandler) {
            completionHandler(newWeight, error);
        }
    }];
    [self.healthStore executeQuery:query];
    
}

- (void)fetchDailyStepsWithCompletionHandler:(void (^)(double, NSError *))completionHandler {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        if (completionHandler && error) {
            completionHandler(0.0f, error);
            return;
        }
        
        double totalDailySteps = [result.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
        NSLog(@"%f",totalDailySteps);
        if (completionHandler) {
            completionHandler(totalDailySteps, error);
        }
    }];
    
    [self.healthStore executeQuery:query];
}

- (void)fetchDailyFlightsWithCompletionHandler:(void (^)(double, NSError *))completionHandler{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];

    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        if (completionHandler && error) {
            completionHandler(0.0f, error);
            return;
        }
        
        double totalDailyFlights = [result.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
        NSLog(@"%f",totalDailyFlights);
        if (completionHandler) {
            completionHandler(totalDailyFlights, error);
        }
    }];
    
    [self.healthStore executeQuery:query];
}

- (void)fetchDailyDistanceWithCompletionHandler:(void (^)(double, NSError *))completionHandler{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
 
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        if (!result) {
            NSLog(@"dailyDistance fail");
            return;
        }
        double totalDistance = [result.sumQuantity doubleValueForUnit:[HKUnit mileUnit]];
        NSLog(@"%f",totalDistance);
        if (completionHandler) {
            completionHandler(totalDistance, error);
        }
    }];
    
    [self.healthStore executeQuery:query];
    
}
- (void)fetchDailyCaloriesWithCompletionHandler:(void (^)(double, NSError *))completionHandler{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];

    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        if (!result) {
            NSLog(@"fail");
            return;
        }
        double totalCalories = [result.sumQuantity doubleValueForUnit:[HKUnit calorieUnit]];
        totalCalories = (totalCalories)/1000;
        
        NSLog(@"%f total calories",totalCalories);
        if (completionHandler) {
            completionHandler(totalCalories, error);
        }
    }];
    
    [self.healthStore executeQuery:query];
}

- (void)fetchWeeklyStepsWithCompletionHandler:(void (^)(double, NSError *))completionHandler{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    interval.day = 7;
    
    // Set the anchor date to Monday at 3:00 a.m.
    NSDateComponents *anchorComponents =
    [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth |
     NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    NSInteger offset = (7 + anchorComponents.weekday - 2) % 7;
    anchorComponents.day -= offset;
    anchorComponents.hour = 0;
    anchorComponents.minute = 0;
    anchorComponents.second = 0;
    
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:7 toDate:anchorDate options:0];
    NSLog(@"%@",endDate);
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:anchorDate endDate:endDate options:HKQueryOptionStrictStartDate];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        if (!result) {
            NSLog(@"fail");
            return;
        }
        double totalCalories = [result.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
        
        NSLog(@"%f total calories",totalCalories);
        if (completionHandler) {
            completionHandler(totalCalories, error);
        }
    }];
    
    [self.healthStore executeQuery:query];
    
}

- (void)fetchLifetimeWorkoutsWithCompletionHandler:(void (^)(double, NSError *))completionHandler{
    HKWorkoutType *workouttype = [HKWorkoutType workoutType];
    
    HKSampleQuery *query =
    [[HKSampleQuery alloc]
     initWithSampleType:workouttype
     predicate:nil
     limit:0
     sortDescriptors:nil
     resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
         if (results == nil) {
             // Perform proper error handling here...
             NSLog(@"*** An error occurred while adding a sample to "
                   @"the workout: %@ ***",
                   error.localizedDescription);
         }
         double totalWorkoutTime = 0;
         // process the detailed samples...
         for(HKWorkout *quantitySample in results)
         {
             totalWorkoutTime += [quantitySample duration];
         }
         
         totalWorkoutTime = (totalWorkoutTime/3600);
         NSLog(@"total workout time in hours %f",totalWorkoutTime);
         
         if (completionHandler) {
             completionHandler(totalWorkoutTime, error);
         }
     }];
    [self.healthStore executeQuery:query];


}
- (void)fetchLifetimeStepsWithCompletionHandler:(void (^)(double, NSError *))completionHandler{
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:nil options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        if (!result) {
            NSLog(@"fail");
            return;
        }
        double totalSteps = [result.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
        
        NSLog(@"%f total lifetime steps",totalSteps);
        if (completionHandler) {
            completionHandler(totalSteps, error);
        }
    }];
    [self.healthStore executeQuery:query];

}

- (void)fetchLifetimeDistanceWithCompletionHandler:(void (^)(double, NSError *))completionHandler{
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:nil options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        if (!result) {
            NSLog(@"fail");
            return;
        }
        double totalDistance = [result.sumQuantity doubleValueForUnit:[HKUnit mileUnit]];
        
        NSLog(@"%f total lifetime distance",totalDistance);
        
        if (completionHandler) {
            completionHandler(totalDistance, error);
        }
    }];
    [self.healthStore executeQuery:query];

}
@end
