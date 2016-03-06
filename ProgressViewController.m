//
//  ProgressViewController.m
//  #Goals
//
//  Created by Michael Fahey on 9/29/15.
//  Copyright © 2015 Michael Fahey. All rights reserved.
//

#import "ProgressViewController.h"
#import "DataGrabber.h"

@interface ProgressViewController ()

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //navController.navigationBar.barTintColor = [UIColor navigationColor];
    //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    self.tableView.backgroundColor = [UIColor grayColor];
    self.title = @"Progress";
    [self fillProgress];
    

}

-(void)fillProgress{
    DataGrabber *data = [[DataGrabber alloc] initWithTitle];

    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        
        [data fetchDailyStepsWithCompletionHandler:^(double totalDailySteps, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%f",totalDailySteps);
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:totalDailySteps]];
                if (totalDailySteps<=10000) {
                    [self.dailySteps setProgress:totalDailySteps/10000 animated:YES];
                    [self.dailyStepCountLabel setText:[NSString stringWithFormat:@"%@/10,000 steps",formatted]];
                    [self.stepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailySteps/10000*100]]]];
                }else if (totalDailySteps>10000 && totalDailySteps<=15000) {
                    [self.dailySteps setProgress:totalDailySteps/15000 animated:YES];
                    [self.dailyStepCountLabel setText:[NSString stringWithFormat:@"%@/15,000 steps",formatted]];
                    [self.stepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailySteps/15000*100]]]];
                }else if (totalDailySteps>15000 && totalDailySteps<=20000) {
                    [self.dailySteps setProgress:totalDailySteps/20000 animated:YES];
                    [self.dailyStepCountLabel setText:[NSString stringWithFormat:@"%@/20,000 steps",formatted]];
                    [self.stepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailySteps/20000*100]]]];
                }else if (totalDailySteps>20000 && totalDailySteps<=30000) {
                    [self.dailySteps setProgress:totalDailySteps/30000 animated:YES];
                    [self.dailyStepCountLabel setText:[NSString stringWithFormat:@"%@/30,000 steps",formatted]];
                    [self.stepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailySteps/30000*100]]]];
                }
                else if (totalDailySteps>30000) {
                    [self.dailySteps setProgress:1 animated:YES];
                    [self.dailyStepCountLabel setText:[NSString stringWithFormat:@"%@/30,000 steps",formatted]];
                    [self.stepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailySteps/30000*100]]]];
                }
            });
        }];

        [data fetchDailyFlightsWithCompletionHandler:^(double totalDailyFlights, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%f",totalDailyFlights);
                if (totalDailyFlights<=22) {
                    [self.dailyFlights setProgress:totalDailyFlights/22 animated:YES];
                    [self.dailyFlightsCountLabel setText:[NSString stringWithFormat:@"%.0f/22 flights",totalDailyFlights]];
                    [self.dailyFlightLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailyFlights/22*100]]]];
                }else if (totalDailyFlights>22 && totalDailyFlights<=45) {
                    [self.dailyFlights setProgress:totalDailyFlights/45 animated:YES];
                    [self.dailyFlightsCountLabel setText:[NSString stringWithFormat:@"%.0f/45 flights",totalDailyFlights]];
                    [self.dailyFlightLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailyFlights/45*100]]]];
                }else if (totalDailyFlights>45 && totalDailyFlights<=86) {
                    [self.dailyFlights setProgress:totalDailyFlights/86 animated:YES];
                    [self.dailyFlightsCountLabel setText:[NSString stringWithFormat:@"%.0f/86 flights",totalDailyFlights]];
                    [self.dailyFlightLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailyFlights/86*100]]]];
                }else if (totalDailyFlights>86 && totalDailyFlights<=160) {
                    [self.dailyFlights setProgress:totalDailyFlights/160 animated:YES];
                    [self.dailyFlightsCountLabel setText:[NSString stringWithFormat:@"%.0f/160 flights",totalDailyFlights]];
                    [self.dailyFlightLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailyFlights/160*100]]]];
                }else if (totalDailyFlights>160) {
                    [self.dailyFlights setProgress:1 animated:YES];
                    [self.dailyFlightsCountLabel setText:[NSString stringWithFormat:@"%.0f/160 flights",totalDailyFlights]];
                    [self.dailyFlightLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailyFlights/160*100]]]];
                }
            });
        }];

        [data fetchDailyCaloriesWithCompletionHandler:^(double totalDailyCalories, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%f",totalDailyCalories);
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:totalDailyCalories]];
                if (totalDailyCalories<=500) {
                    [self.dailyCalories setProgress:totalDailyCalories/500 animated:YES];
                    [self.dailyCaloriesCountLabel setText:[NSString stringWithFormat:@"%@/500 calories",formatted]];
                    [self.dailyCaloriesLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailyCalories/500*100]]]];
                }else if (totalDailyCalories>500 && totalDailyCalories<=1000) {
                    [self.dailyCalories setProgress:totalDailyCalories/1000 animated:YES];
                    [self.dailyCaloriesCountLabel setText:[NSString stringWithFormat:@"%@/1,000 calories",formatted]];
                     [self.dailyCaloriesLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailyCalories/1000*100]]]];
                }else if (totalDailyCalories>1000 && totalDailyCalories<=1500) {
                    [self.dailyCalories setProgress:totalDailyCalories/1500 animated:YES];
                    [self.dailyCaloriesCountLabel setText:[NSString stringWithFormat:@"%@/1,500 calories",formatted]];
                     [self.dailyCaloriesLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailyCalories/1500*100]]]];
                }else if (totalDailyCalories>1500 && totalDailyCalories<=2000) {
                    [self.dailyCalories setProgress:totalDailyCalories/2000 animated:YES];
                    [self.dailyCaloriesCountLabel setText:[NSString stringWithFormat:@"%@/2,000 calories",formatted]];
                     [self.dailyCaloriesLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailyCalories/2000*100]]]];
                }else if (totalDailyCalories>2000) {
                    [self.dailyCalories setProgress:1 animated:YES];
                    [self.dailyCaloriesCountLabel setText:[NSString stringWithFormat:@"%@/2,000 calories",formatted]];
                     [self.dailyCaloriesLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailyCalories/2000*100]]]];
                }
                
            });
        }];
        
        [data fetchDailyDistanceWithCompletionHandler:^(double totalDailyDistance, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%f",totalDailyDistance);
                if (totalDailyDistance<=13.1) {
                    [self.dailyDistance setProgress:totalDailyDistance/13.1 animated:YES];
                    [self.dailyDistanceCountLabel setText:[NSString stringWithFormat:@"%.2f/13.1 miles",totalDailyDistance]];
                     [self.dailyDistanceLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailyDistance/13.1*100]]]];
                }else if (totalDailyDistance>13.1 && totalDailyDistance<=26.2) {
                    [self.dailyDistance setProgress:totalDailyDistance/26.2 animated:YES];
                    [self.dailyDistanceCountLabel setText:[NSString stringWithFormat:@"%.2f/26.2 miles",totalDailyDistance]];
                    [self.dailyDistanceLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailyDistance/26.2*100]]]];
                }else if (totalDailyDistance>26.2) {
                    [self.dailyDistance setProgress:1 animated:YES];
                    [self.dailyDistanceCountLabel setText:[NSString stringWithFormat:@"%.2f/26.2 miles",totalDailyDistance]];
                    [self.dailyDistanceLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:totalDailyDistance/26.2*100]]]];
                }
                
            });
        }];

        [data fetchLifetimeStepsWithCompletionHandler:^(double lifetimeSteps, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%f lifetime steps",lifetimeSteps);
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeSteps]];
                if (lifetimeSteps<=500000) {
                    [self.lifetimeSteps setProgress:lifetimeSteps/500000 animated:YES];
                    [self.lifetimeStepsCountLabel setText:[NSString stringWithFormat:@"%@/500,000 steps",formatted]];
                       [self.lifetimeStepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeSteps/500000*100]]]];
                }else if (lifetimeSteps>500000 && lifetimeSteps<=1000000) {
                    [self.lifetimeSteps setProgress:lifetimeSteps/1000000 animated:YES];
                    [self.lifetimeStepsCountLabel setText:[NSString stringWithFormat:@"%@/1,000,000 steps",formatted]];
                    [self.lifetimeStepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeSteps/1000000*100]]]];
                }else if (lifetimeSteps>1000000 && lifetimeSteps<=5000000) {
                    [self.lifetimeSteps setProgress:lifetimeSteps/5000000 animated:YES];
                    [self.lifetimeStepsCountLabel setText:[NSString stringWithFormat:@"%@/5,000,000 steps",formatted]];
                    [self.lifetimeStepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeSteps/5000000*100]]]];
                }else if (lifetimeSteps>5000000 && lifetimeSteps<=10000000) {
                    [self.lifetimeSteps setProgress:lifetimeSteps/10000000 animated:YES];
                    [self.lifetimeStepsCountLabel setText:[NSString stringWithFormat:@"%@/10,000,000 steps",formatted]];
                    [self.lifetimeStepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeSteps/10000000*100]]]];
                }else if (lifetimeSteps>10000000) {
                    [self.lifetimeSteps setProgress:1 animated:YES];
                    [self.lifetimeStepsCountLabel setText:[NSString stringWithFormat:@"%@/10,000,000 steps",formatted]];
                    [self.lifetimeStepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeSteps/10000000*100]]]];
                }
            });
        }];
        
        [data fetchWeeklyStepsWithCompletionHandler:^(double weeklySteps, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%f weekly steps",weeklySteps);
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:weeklySteps]];
                if (weeklySteps<=50000) {
                    [self.weeklySteps setProgress:weeklySteps/50000 animated:YES];
                    [self.weeklyStepsCountLabel setText:[NSString stringWithFormat:@"%@/50,000 steps",formatted]];
                    [self.weeklyStepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:weeklySteps/50000*100]]]];
                }else if (weeklySteps>50000 && weeklySteps<=75000) {
                    [self.weeklySteps setProgress:weeklySteps/75000 animated:YES];
                    [self.weeklyStepsCountLabel setText:[NSString stringWithFormat:@"%@/75,000 steps",formatted]];
                    [self.weeklyStepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:weeklySteps/75000*100]]]];
                }else if (weeklySteps>75000 && weeklySteps<=100000) {
                    [self.weeklySteps setProgress:weeklySteps/100000 animated:YES];
                    [self.weeklyStepsCountLabel setText:[NSString stringWithFormat:@"%@/100,000 steps",formatted]];
                    [self.weeklyStepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:weeklySteps/100000*100]]]];
                }else if (weeklySteps>100000 && weeklySteps<=150000) {
                    [self.weeklySteps setProgress:weeklySteps/150000 animated:YES];
                    [self.weeklyStepsCountLabel setText:[NSString stringWithFormat:@"%@/150,000 steps",formatted]];
                    [self.weeklyStepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:weeklySteps/150000*100]]]];
                }else if (weeklySteps>150000 && weeklySteps<= 200000) {
                    [self.weeklySteps setProgress:weeklySteps/200000 animated:YES];
                    [self.weeklyStepsCountLabel setText:[NSString stringWithFormat:@"%@/200,000 steps",formatted]];
                    [self.weeklyStepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:weeklySteps/200000*100]]]];
                }else if (weeklySteps>200000) {
                    [self.weeklySteps setProgress:1 animated:YES];
                    [self.weeklyStepsCountLabel setText:[NSString stringWithFormat:@"%@/200,000 steps",formatted]];
                    [self.weeklyStepLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:weeklySteps/200000*100]]]];
                }

            });
        }];
        
        [data fetchLifetimeWorkoutsWithCompletionHandler:^(double lifetimeWorkouts, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%f workout",lifetimeWorkouts);
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithDouble:lifetimeWorkouts]];
                if (lifetimeWorkouts<=1) {
                    [self.lifetimeWorkout setProgress:lifetimeWorkouts/1 animated:YES];
                    [self.lifetimeWorkoutsCountLabel setText:[NSString stringWithFormat:@"%@/1 hour",formatted]];
                    [self.lifetimeWorkoutLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeWorkouts/1*100]]]];
                }else if (lifetimeWorkouts>1 && lifetimeWorkouts<=40) {
                    [self.lifetimeWorkout setProgress:lifetimeWorkouts/40 animated:YES];
                    [self.lifetimeWorkoutsCountLabel setText:[NSString stringWithFormat:@"%@/40 hours",formatted]];
                    [self.lifetimeWorkoutLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeWorkouts/40*100]]]];
                }else if (lifetimeWorkouts>40 && lifetimeWorkouts<=100) {
                    [self.lifetimeWorkout setProgress:lifetimeWorkouts/100 animated:YES];
                    [self.lifetimeWorkoutsCountLabel setText:[NSString stringWithFormat:@"%@/100 hours",formatted]];
                    [self.lifetimeWorkoutLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeWorkouts/100*100]]]];
                }else if (lifetimeWorkouts>100 && lifetimeWorkouts<=500) {
                    [self.lifetimeWorkout setProgress:lifetimeWorkouts/500 animated:YES];
                    [self.lifetimeWorkoutsCountLabel setText:[NSString stringWithFormat:@"%@/500 hours",formatted]];
                    [self.lifetimeWorkoutLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeWorkouts/500*100]]]];
                }else if (lifetimeWorkouts>500 && lifetimeWorkouts<=1000) {
                    [self.lifetimeWorkout setProgress:lifetimeWorkouts/1000 animated:YES];
                    [self.lifetimeWorkoutsCountLabel setText:[NSString stringWithFormat:@"%@/1,000 hours",formatted]];
                    [self.lifetimeWorkoutLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeWorkouts/1000*100]]]];
                }else if (lifetimeWorkouts>1000) {
                    [self.lifetimeWorkout setProgress:1 animated:YES];
                    [self.lifetimeWorkoutsCountLabel setText:[NSString stringWithFormat:@"%@/1,000 hours",formatted]];
                    [self.lifetimeWorkoutLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeWorkouts/1000*100]]]];
                }
            });
        }];
        
        [data fetchLifetimeDistanceWithCompletionHandler:^(double lifetimeDistance, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%f distance",lifetimeDistance);
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithDouble:lifetimeDistance]];
                if (lifetimeDistance<=100) {
                    [self.lifetimeDistance setProgress:lifetimeDistance/100 animated:YES];
                    [self.lifetimeDistanceCountLabel setText:[NSString stringWithFormat:@"%@/100 miles",formatted]];
                    [self.lifetimeDistanceLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeDistance/100*100]]]];
                }else if (lifetimeDistance>100 && lifetimeDistance<=500) {
                    [self.lifetimeDistance setProgress:lifetimeDistance/500 animated:YES];
                    [self.lifetimeDistanceCountLabel setText:[NSString stringWithFormat:@"%@/500 miles",formatted]];
                    [self.lifetimeDistanceLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeDistance/500*100]]]];
                }else if (lifetimeDistance>500 && lifetimeDistance<=1000) {
                    [self.lifetimeDistance setProgress:lifetimeDistance/1000 animated:YES];
                    [self.lifetimeDistanceCountLabel setText:[NSString stringWithFormat:@"%@/1,000 miles",formatted]];
                    [self.lifetimeDistanceLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeDistance/1000*100]]]];
                }else if (lifetimeDistance>1000 && lifetimeDistance<=5000) {
                    [self.lifetimeDistance setProgress:lifetimeDistance/5000 animated:YES];
                    [self.lifetimeDistanceCountLabel setText:[NSString stringWithFormat:@"%@/5,000 miles",formatted]];
                    [self.lifetimeDistanceLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeDistance/5000*100]]]];
                }else if (lifetimeDistance>5000 && lifetimeDistance<=10000) {
                    [self.lifetimeDistance setProgress:lifetimeDistance/10000 animated:YES];
                    [self.lifetimeDistanceCountLabel setText:[NSString stringWithFormat:@"%@/10,000 miles",formatted]];
                    [self.lifetimeDistanceLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeDistance/10000*100]]]];
                }else if (lifetimeDistance>10000) {
                    [self.lifetimeDistance setProgress:1 animated:YES];
                    [self.lifetimeDistanceCountLabel setText:[NSString stringWithFormat:@"%@/10,000 miles",formatted]];
                    [self.lifetimeDistanceLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:lifetimeDistance/10000*100]]]];
                }
            });
        }];
        
        [data fetchWeightWithCompletionHandler:^(double weight, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%f weight",weight);
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithDouble:weight]];
                if (weight<=1) {
                    if (weight<0) {
                        [self.weightProgress setProgress:0/1 animated:YES];
                        [self.lifetimeWeightCountLabel setText:[NSString stringWithFormat:@"0/1 pound"]];
                        [self.lifetimeWeightLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:weight/1*100]]]];
                    }else{
                        [self.weightProgress setProgress:weight/1 animated:YES];
                        [self.lifetimeWeightCountLabel setText:[NSString stringWithFormat:@"%@/1 pound",formatted]];
                        [self.lifetimeWeightLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:weight/1*100]]]];
                    }
                }else if (weight>1 && weight<=5) {
                    [self.weightProgress setProgress:weight/5 animated:YES];
                    [self.lifetimeWeightCountLabel setText:[NSString stringWithFormat:@"%@/5 pounds",formatted]];
                    [self.lifetimeWeightLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:weight/5*100]]]];
                }else if (weight>5 && weight<=10) {
                    [self.weightProgress setProgress:weight/10 animated:YES];
                    [self.lifetimeWeightCountLabel setText:[NSString stringWithFormat:@"%@/10 pounds",formatted]];
                    [self.lifetimeWeightLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:weight/10*100]]]];
                }else if (weight>10) {
                    [self.weightProgress setProgress:1 animated:YES];
                    [self.lifetimeWeightCountLabel setText:[NSString stringWithFormat:@"%@/10 pounds",formatted]];
                    [self.lifetimeWeightLabelPercent setText:[NSString stringWithFormat:@"%@ %%",[formatter stringFromNumber:[NSNumber numberWithInteger:weight/10*100]]]];
                }
            });
        }];
  });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Refresh:(id)sender {
    NSLog(@"refresh");
    [self fillProgress];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing the TableView"];
    //set the date and time of refreshing
    NSDateFormatter *formattedDate = [[NSDateFormatter alloc]init];
    [formattedDate setDateFormat:@"MMM d, h:mm a"];
    NSString *lastupdated = [NSString stringWithFormat:@"Last Updated on %@",[formattedDate stringFromDate:[NSDate date]]];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:lastupdated];
}

- (IBAction)pullToRefresh:(UIRefreshControl *)sender {
    [self fillProgress];
    //set the title while refreshing
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing the TableView"];
    //set the date and time of refreshing
    NSDateFormatter *formattedDate = [[NSDateFormatter alloc]init];
    [formattedDate setDateFormat:@"MMM d, h:mm a"];
    NSString *lastupdated = [NSString stringWithFormat:@"Last Updated on %@",[formattedDate stringFromDate:[NSDate date]]];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:lastupdated];
    //end the refreshing
    [sender endRefreshing];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
