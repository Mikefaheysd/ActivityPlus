//
//  AppDelegate.m
//  #Goals
//
//  Created by Michael Fahey on 9/26/15.
//  Copyright © 2015 Michael Fahey. All rights reserved.
//

#import "AppDelegate.h"
#import "DataGrabber.h"
#import "ProgressViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    
    tabBarItem1.title = @"Progress";
    tabBarItem2.title = @"Achievements";
    tabBarItem1.image =[UIImage imageNamed:@"dumbbell-7.png"];
    tabBarItem2.image =[UIImage imageNamed:@"star-7.png"];
    tabBar.tintColor = [UIColor blackColor];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil]];
    }
    
    [self getHealthKitData];
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
        DataGrabber *grabber = [[DataGrabber alloc] initWithTitle];
        // Request access
        [healthStore requestAuthorizationToShareTypes:NULL
                                            readTypes:readObjectTypes
                                           completion:^(BOOL success, NSError *error) {
                                               if (success) {
                                                   NSLog(@"success");
                                                   [healthStore enableBackgroundDeliveryForType:
                                                        [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned]
                                                    frequency:HKUpdateFrequencyImmediate withCompletion:^(BOOL success, NSError *error){
                                                        
                                                        [grabber fetchDailyCaloriesWithCompletionHandler:^(double test, NSError *error) {
                                                            
                                                            NSLog(@"hereeeeeee");
                                                        }];
                                                    }];
                                               }
                                           }];
    }
    else
    {
        NSLog(@"unable to request access!");
    }
    return;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"entering background");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"entering background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"entering fore");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"entering active");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
