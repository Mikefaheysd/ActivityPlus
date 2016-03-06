//
//  RWTMasterViewController.h
//  ScaryBugs
//
//  Created by Jorge Jordán Arenas on 04/02/14.
//
//

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>

@interface RWTMasterViewController : UITableViewController{
    int tempInt;
    NSNumber *temp;
}
-(void) checkAchievementStatus;
-(void)logWorkout;
- (void)mostRecentWeightSample;
-(void)weeklySteps;
-(void)dailySteps;
-(void)dailyDistance;
-(void)dailyFlights;
-(void)dailyCalories;
-(void)lifetimeSteps;
-(void)lifetimeDistance;

- (IBAction)Refresh:(id)sender;
- (IBAction)pullToRefresh:(UIRefreshControl *)sender;

@end
