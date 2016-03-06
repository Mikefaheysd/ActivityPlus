//
//  RWTAppDelegate.m
//  ScaryBugs
//
//  Created by Jorge Jordán Arenas on 04/02/14.
//
//

#import "RWTAppDelegate.h"
#import "RWTMasterViewController.h"

@implementation RWTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

//    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
//    UITabBar *tabBar = tabBarController.tabBar;
//    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
//    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
//    
//    tabBarItem1.title = @"Achievements View";
//    tabBarItem2.title = @"Award View";
//    tabBarItem1.image =[UIImage imageNamed:@"dumbbell-7.png"];
//    tabBarItem2.image =[UIImage imageNamed:@"star-7.png"];
//    [self getHealthKitData];
    return YES;
    
}
-(void) getHealthKitData
{
    if ([HKHealthStore isHealthDataAvailable])
    {
        HKHealthStore *healthStore;
        healthStore = [[HKHealthStore alloc] init];
        // Add your HealthKit code here
        // Read date of birth, biological sex and step count etc
        NSSet *readObjectTypes  = [NSSet setWithObjects:
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed],
                                   [HKObjectType workoutType],
                                   nil];
        
        // Request access
        [healthStore requestAuthorizationToShareTypes:NULL
                                                 readTypes:readObjectTypes
                                                completion:^(BOOL success, NSError *error) {
                                                    if (success) {
                                                        NSLog(@"success");
//                                                        
//                                                        [healthStore enableBackgroundDeliveryForType:
//                                                         [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned]
//                                                                                                frequency:HKUpdateFrequencyImmediate withCompletion:^(BOOL success, NSError *error){}];
//                                                        [healthStore enableBackgroundDeliveryForType:
//                                                         [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount]
//                                                                                                frequency:HKUpdateFrequencyImmediate withCompletion:^(BOOL success, NSError *error){}];
//                                                        [healthStore enableBackgroundDeliveryForType:
//                                                         [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed]
//                                                                                                frequency:HKUpdateFrequencyImmediate withCompletion:^(BOOL success, NSError *error){}];
                                                        [healthStore enableBackgroundDeliveryForType:
                                                         [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass]
                                                                                                frequency:HKUpdateFrequencyImmediate withCompletion:^(BOOL success, NSError *error){
                                                                                                    HKQuery *query = [[HKObserverQuery alloc] initWithSampleType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass] predicate:nil updateHandler:
                                                                                                                                                                                                ^void(HKObserverQuery *query, HKObserverQueryCompletionHandler completionHandler, NSError *error)
                                                                                                                                                                                                {
                                                                                                                                                                                                    //If we don't call the completion handler right away, Apple gets mad. They'll try sending us the same notification here 3 times on a back-off algorithm.  The preferred method is we just call the completion handler.  Makes me wonder why they even HAVE a completionHandler if we're expected to just call it right away...
                                                                                                                                                                                                    if (completionHandler) {
                                                                                                                                                                                                        completionHandler();
                                                                                                                                                                                                    }
                                                                                                                                                                                                    
                                                                                                                                                                                                    NSLog(@"dfs");
                                                                                                                                                                                                }];
                                                                                                                                                                              [healthStore executeQuery:query];
}];
                                                                                                    
//                                                        [healthStore enableBackgroundDeliveryForType:
//                                                         [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning]
//                                                                                           frequency:HKUpdateFrequencyImmediate withCompletion:^(BOOL success, NSError *error){}];
//                                                        
//                                                        HKQuery *query = [[HKObserverQuery alloc] initWithSampleType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning] predicate:nil updateHandler:
//                                                                          ^void(HKObserverQuery *query, HKObserverQueryCompletionHandler completionHandler, NSError *error)
//                                                                          {
//                                                                              //If we don't call the completion handler right away, Apple gets mad. They'll try sending us the same notification here 3 times on a back-off algorithm.  The preferred method is we just call the completion handler.  Makes me wonder why they even HAVE a completionHandler if we're expected to just call it right away...
//                                                                              if (completionHandler) {
//                                                                                  completionHandler();
//                                                                              }
//                                                                              
//                                                                   
//                                                                          }];
//                                                        [healthStore executeQuery:query];
                                                    }
                                                }];
    }
    else
    {
        NSLog(@"unable to request access!");
    }
    return;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
