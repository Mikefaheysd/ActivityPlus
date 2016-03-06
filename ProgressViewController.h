//
//  ProgressViewController.h
//  #Goals
//
//  Created by Michael Fahey on 9/29/15.
//  Copyright © 2015 Michael Fahey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressViewController : UITableViewController <UITableViewDelegate>{
   
}
-(void)fillProgress;

@property (strong, nonatomic) IBOutlet UIProgressView *dailySteps;
@property (strong, nonatomic) IBOutlet UIProgressView *dailyFlights;
@property (strong, nonatomic) IBOutlet UIProgressView *dailyDistance;
@property (strong, nonatomic) IBOutlet UIProgressView *dailyCalories;

@property (strong, nonatomic) IBOutlet UIProgressView *weeklySteps;

@property (strong, nonatomic) IBOutlet UIProgressView *lifetimeWorkout;
@property (strong, nonatomic) IBOutlet UIProgressView *lifetimeSteps;
@property (strong, nonatomic) IBOutlet UIProgressView *lifetimeDistance;
@property (strong, nonatomic) IBOutlet UIProgressView *weightProgress;

@property (strong, nonatomic) IBOutlet UILabel *stepsLabel;
@property (strong, nonatomic) IBOutlet UILabel *dailyStepCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *dailyDistanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *dailyDistanceCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *dailyCaloriesLabel;
@property (strong, nonatomic) IBOutlet UILabel *dailyCaloriesCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *dailyFlightsLabel;
@property (strong, nonatomic) IBOutlet UILabel *dailyFlightsCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *lifetimeWorkoutsLabel;
@property (strong, nonatomic) IBOutlet UILabel *lifetimeWorkoutsCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *lifetimeWeightLabel;
@property (strong, nonatomic) IBOutlet UILabel *lifetimeWeightCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *weeklyStepsLabel;
@property (strong, nonatomic) IBOutlet UILabel *weeklyStepsCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *lifetimeStepsLabel;
@property (strong, nonatomic) IBOutlet UILabel *lifetimeStepsCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *lifetimeDistanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *lifetimeDistanceCountLabel;

- (IBAction)Refresh:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *stepLabelPercent;

@property (strong, nonatomic) IBOutlet UILabel *dailyCaloriesLabelPercent;

@property (strong, nonatomic) IBOutlet UILabel *dailyFlightLabelPercent;

@property (strong, nonatomic) IBOutlet UILabel *dailyDistanceLabelPercent;

@property (strong, nonatomic) IBOutlet UILabel *weeklyStepLabelPercent;

@property (strong, nonatomic) IBOutlet UILabel *lifetimeWorkoutLabelPercent;

@property (strong, nonatomic) IBOutlet UILabel *lifetimeStepLabelPercent;
@property (strong, nonatomic) IBOutlet UILabel *lifetimeDistanceLabelPercent;
@property (strong, nonatomic) IBOutlet UILabel *lifetimeWeightLabelPercent;

- (IBAction)pullToRefresh:(UIRefreshControl *)sender;




@end
