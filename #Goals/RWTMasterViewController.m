//
//  RWTMasterViewController.m
//  ScaryBugs
//
//  Created by Jorge Jordán Arenas on 04/02/14.
//
//

#import "RWTMasterViewController.h"
#import "RWTDetailViewController.h"

@interface RWTMasterViewController ()
{
    NSArray *tableData;
    NSArray *descriptionData;
    NSArray *canEarnMultipleTimes;
    NSArray *images;
    NSString *path;
    NSMutableArray *timesEarned;
    NSMutableArray *lastTimeEarned;
    NSMutableDictionary *dict;
    NSNumber *weight;
    NSString *currentDate;
}

@property (strong,nonatomic) HKHealthStore *healthStore;

@end

@implementation RWTMasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.healthStore = [[HKHealthStore alloc] init];
    self.title = @"Achievements";
    
    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *formatter = threadDict[@"someUniqueKey"];
    if (!formatter)
    {
        //create the formatter
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        
        //cache the formatter
        threadDict[@"someUniqueKey"] = formatter;
    }
    
    NSDate *now = [NSDate date];
    
    currentDate = [formatter stringFromDate:now];
    
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    path = [documentsDirectory stringByAppendingPathComponent:@"Achievements.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSLog(@"wrote to path");
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Achievements" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }

    // Load the file content and read the data into arrays
    dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    tableData = [dict objectForKey:@"Achievements"];
    descriptionData = [dict objectForKey:@"Description"];
    timesEarned = [dict objectForKey:@"TimesEarned"];
    canEarnMultipleTimes = [dict objectForKey:@"CanEarnMultipleTimes"];
    images = [dict objectForKey:@"Images"];
    lastTimeEarned = [dict objectForKey:@"LastTimeEarned"];
    weight = [dict objectForKey:@"Weight"];
    
    [self mostRecentWeightSample];
    [self logWorkout];
    [self weeklySteps];
    [self startTimedTask];
    [self dailyCalories];
    [self dailyFlights];
    [self dailySteps];
    [self dailyDistance];
    [self lifetimeSteps];
    [self lifetimeDistance];
    [self yesterdayCalories];
}

- (IBAction)Refresh:(id)sender{
    NSLog(@"refresh");
    [self performBackgroundTask];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing the TableView"];
    //set the date and time of refreshing
    NSDateFormatter *formattedDate = [[NSDateFormatter alloc]init];
    [formattedDate setDateFormat:@"MMM d, h:mm a"];
    NSString *lastupdated = [NSString stringWithFormat:@"Last Updated on %@",[formattedDate stringFromDate:[NSDate date]]];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:lastupdated];
}

- (IBAction)pullToRefresh:(UIRefreshControl *)sender {
    [self performBackgroundTask];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing the TableView"];
    //set the date and time of refreshing
    NSDateFormatter *formattedDate = [[NSDateFormatter alloc]init];
    [formattedDate setDateFormat:@"MMM d, h:mm a"];
    NSString *lastupdated = [NSString stringWithFormat:@"Last Updated on %@",[formattedDate stringFromDate:[NSDate date]]];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:lastupdated];
    [sender endRefreshing];
}

- (void)startTimedTask
{
   [NSTimer scheduledTimerWithTimeInterval:1800 target:self selector:@selector(performBackgroundTask) userInfo:nil repeats:YES];
}

- (void)performBackgroundTask
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Do background work
        NSLog(@"30 minutes");
         [self mostRecentWeightSample];
         [self logWorkout];
         [self weeklySteps];
         [self startTimedTask];
         [self dailyCalories];
         [self dailyFlights];
         [self dailySteps];
         [self dailyDistance];
         [self lifetimeSteps];
         [self lifetimeDistance];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update UI
            [self.tableView reloadData];
        });
    });
}

-(void) checkAchievementStatus{
    NSLog(@"in checker");
    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *formatter = threadDict[@"someUniqueKey"];
    if (!formatter)
    {
        //create the formatter
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        
        //cache the formatter
        threadDict[@"someUniqueKey"] = formatter;
    }
    
    [self mostRecentWeightSample];
//    [self logWorkout];
//    [self weeklySteps];
//    [self startTimedTask];
//    [self dailyCalories];
//    [self dailyFlights];
//    [self dailySteps];
//    [self dailyDistance];
//    [self lifetimeSteps];
//    [self lifetimeDistance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"MyBasicCell"];
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    if ([timesEarned [indexPath.row] intValue] > 0)
    {
        //NSLog(@"earned")  ;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
       // NSLog(@"not yet earned");
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


-(void)didMoveToParentViewController:(UIViewController *)parent
{
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RWTDetailViewController *detailController = segue.destinationViewController;
    
    detailController.titleItem = [tableData objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    detailController.descriptionItem = [descriptionData objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    detailController.timesEarnedItem = [NSString stringWithFormat:@"%@",[timesEarned objectAtIndex:self.tableView.indexPathForSelectedRow.row]];
    detailController.canEarnMultipleTimesItem =[canEarnMultipleTimes objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    detailController.fullImageItem = [UIImage imageNamed:[images objectAtIndex:self.tableView.indexPathForSelectedRow.row]];
    detailController.lastTimeEarnedItem = [lastTimeEarned objectAtIndex:self.tableView.indexPathForSelectedRow.row];
}

/*Workout, Weight, Daily, Weekly, Lifetime check */
-(void)logWorkout
{
    NSLog(@"in logworkout");
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
         
         //1 hour workout complete
         if (totalWorkoutTime >= 1 && [timesEarned[30] isEqual:@0]) {
             [timesEarned replaceObjectAtIndex:30 withObject:[NSNumber numberWithInt:1]];
             [lastTimeEarned replaceObjectAtIndex:30 withObject:currentDate];

             dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
             
             // write back to file
             [dict writeToFile:path atomically:YES];
         }
         //40 hour workout complete
         if (totalWorkoutTime >= 40 && [timesEarned[31] isEqual:@0]) {
             [timesEarned replaceObjectAtIndex:31 withObject:[NSNumber numberWithInt:1]];
             [lastTimeEarned replaceObjectAtIndex:31 withObject:currentDate];

             dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
             
             // write back to file
             [dict writeToFile:path atomically:YES];
         }
         //100 hour workout complete
         if (totalWorkoutTime >= 100 && [timesEarned[32] isEqual:@0]) {
             [timesEarned replaceObjectAtIndex:32 withObject:[NSNumber numberWithInt:1]];
             [lastTimeEarned replaceObjectAtIndex:32 withObject:currentDate];

             dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
             
             // write back to file
             [dict writeToFile:path atomically:YES];
         }
         //500 hour workout complete
         if (totalWorkoutTime >= 500 && [timesEarned[33] isEqual:@0]) {
             [timesEarned replaceObjectAtIndex:33 withObject:[NSNumber numberWithInt:1]];
             [lastTimeEarned replaceObjectAtIndex:33 withObject:currentDate];

             dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
             
             // write back to file
             [dict writeToFile:path atomically:YES];
         }
         //1000 hour workout complete
         if (totalWorkoutTime >= 1000 && [timesEarned[34] isEqual:@0]) {
             [timesEarned replaceObjectAtIndex:34 withObject:[NSNumber numberWithInt:1]];
             [lastTimeEarned replaceObjectAtIndex:34 withObject:currentDate];

             dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
             
             // write back to file
             [dict writeToFile:path atomically:YES];
         }
         
     }];
    
    [self.healthStore executeQuery:query];
}

- (void)mostRecentWeightSample
{
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
        
        NSNumber *difference = [NSNumber numberWithFloat:([weight floatValue] - test)];
        int newWeight = [difference intValue];
        
        //lose a pound
        if(newWeight >= 1 && [timesEarned[14] isEqual:@0]){
            [timesEarned replaceObjectAtIndex:14 withObject:[NSNumber numberWithInt:1]];
            [lastTimeEarned replaceObjectAtIndex:14 withObject:currentDate];

            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        
        //lose five pounds
        if(newWeight >=5 && [timesEarned[15] isEqual:@0]){
            [timesEarned replaceObjectAtIndex:15 withObject:[NSNumber numberWithInt:1]];
            [lastTimeEarned replaceObjectAtIndex:15 withObject:currentDate];

            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        
        //lose 10 pounds
        if(newWeight >=10 && [timesEarned[16] isEqual:@0]){
            [timesEarned replaceObjectAtIndex:16 withObject:[NSNumber numberWithInt:1]];
            
            [lastTimeEarned replaceObjectAtIndex:16 withObject:currentDate];
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        
    }];
    
    [self.healthStore executeQuery:query];
}

-(void)dailySteps
{
    NSLog(@"in daily steps");
//    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
//    NSDateFormatter *formatter = threadDict[@"someUniqueKey"];
//    if (!formatter)
//    {
//        //create the formatter
//        formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy/MM/dd"];
//        
//        //cache the formatter
//        threadDict[@"someUniqueKey"] = formatter;
//    }
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
//    NSString *currentDate = [formatter stringFromDate:startDate];
//    
//    NSLog(@"%@",currentDate);
    
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        if (!result) {
            NSLog(@"fail");
            return;
        }
        int value = 0;
        double totalSteps = [result.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
        
        
        NSLog(@"%f total steps",totalSteps);
        
        //10k daily steps complete
        if (totalSteps >= 10000 && ![lastTimeEarned[0] isEqualToString:currentDate]) {
            value = [timesEarned[0] intValue];
            
            [timesEarned replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:value+1]];
            [lastTimeEarned replaceObjectAtIndex:0 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //15k daily steps complete
        if (totalSteps >= 15000 && ![lastTimeEarned[1] isEqualToString:currentDate]) {
            value = [timesEarned[1] intValue];
            
            [timesEarned replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:value+1]];
            [lastTimeEarned replaceObjectAtIndex:1 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //20k daily steps complete
        if (totalSteps >= 20000 && ![lastTimeEarned[2] isEqualToString:currentDate]) {
            value = [timesEarned[2] intValue];
            
            [timesEarned replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:value+1]];
            [lastTimeEarned replaceObjectAtIndex:2 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //30k flights complete
        if (totalSteps >= 30000 && ![lastTimeEarned[3] isEqualToString:currentDate]) {
            value = [timesEarned[3] intValue];
            
            [timesEarned replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:value+1]];
            [lastTimeEarned replaceObjectAtIndex:3 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        
        
    }];
    
    [self.healthStore executeQuery:query];
    
}

-(void)weeklySteps
{
    NSLog(@"in weekly steps");
//    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
//    NSDateFormatter *formatter = threadDict[@"someUniqueKey"];
//    if (!formatter)
//    {
//        //create the formatter
//        formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy/MM/dd"];
//        
//        //cache the formatter
//        threadDict[@"someUniqueKey"] = formatter;
//    }
  
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
    
//    NSLog(@"anchor %@",anchorDate);
//    
//    NSString *currentDate = [formatter stringFromDate:anchorDate];
//    NSLog(@"current date %@", currentDate);
    
    HKQuantityType *quantityType =
    [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    // Create the query
    HKStatisticsCollectionQuery *query =
    [[HKStatisticsCollectionQuery alloc]
     initWithQuantityType:quantityType
     quantitySamplePredicate:nil
     options:HKStatisticsOptionCumulativeSum
     anchorDate:anchorDate
     intervalComponents:interval];
    
    // Set the results handler
    query.initialResultsHandler =
    ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        
        if (error) {
            // Perform proper error handling here
            NSLog(@"*** An error occurred while calculating the statistics: %@ ***",
                  error.localizedDescription);
        }

        [results
         enumerateStatisticsFromDate:anchorDate
         toDate:anchorDate
         withBlock:^(HKStatistics *result, BOOL *stop) {
             
             HKQuantity *quantity = result.sumQuantity;
             double weeklyStepCount = [quantity doubleValueForUnit:[HKUnit countUnit]];
             
             NSLog(@"%f weekly steps",weeklyStepCount);
             int value = 0;
             
             //50k weekly complete
             if (weeklyStepCount >= 50000 && ![lastTimeEarned[4] isEqualToString:currentDate]) {
                 value = [timesEarned[4] intValue];
                 
                 [timesEarned replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:value+1]];
                 [lastTimeEarned replaceObjectAtIndex:4 withObject:currentDate];
                 
                 dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
                 
                 // write back to file
                 [dict writeToFile:path atomically:YES];
             }
             //75k weekly complete
             if (weeklyStepCount >= 75000 && ![lastTimeEarned[5] isEqualToString:currentDate]) {
                 value = [timesEarned[5] intValue];
                 
                 [timesEarned replaceObjectAtIndex:5 withObject:[NSNumber numberWithInt:value+1]];
                 [lastTimeEarned replaceObjectAtIndex:5 withObject:currentDate];

                 dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
                 
                 // write back to file
                 [dict writeToFile:path atomically:YES];
             }
             //100k weekly complete
             if (weeklyStepCount >= 100000 && ![lastTimeEarned[6] isEqualToString:currentDate]) {
                 value = [timesEarned[6] intValue];
                 
                 [timesEarned replaceObjectAtIndex:6 withObject:[NSNumber numberWithInt:value+1]];
                 [lastTimeEarned replaceObjectAtIndex:6 withObject:currentDate];

                 dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
                 
                 // write back to file
                 [dict writeToFile:path atomically:YES];
             }
             //150k weekly complete
             if (weeklyStepCount >= 150000 && ![lastTimeEarned[7] isEqualToString:currentDate]) {
                 value = [timesEarned[7] intValue];
                 
                 [timesEarned replaceObjectAtIndex:7 withObject:[NSNumber numberWithInt:value+1]];
                 [lastTimeEarned replaceObjectAtIndex:7 withObject:currentDate];

                 dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
                 
                 // write back to file
                 [dict writeToFile:path atomically:YES];
             }
             //200k weekly complete
             if (weeklyStepCount >= 200000 && ![lastTimeEarned[8] isEqualToString:currentDate]) {
                 value = [timesEarned[8] intValue];
                 
                 [timesEarned replaceObjectAtIndex:8 withObject:[NSNumber numberWithInt:value+1]];
                 [lastTimeEarned replaceObjectAtIndex:8 withObject:currentDate];

                 dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
                 
                 // write back to file
                 [dict writeToFile:path atomically:YES];
             }

             
         }];
    };
    
    [self.healthStore executeQuery:query];
}

-(void)lifetimeSteps
{
    NSLog(@"in lifetime steps");
//    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
//    NSDateFormatter *formatter = threadDict[@"someUniqueKey"];
//    if (!formatter)
//    {
//        //create the formatter
//        formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy/MM/dd"];
//        
//        //cache the formatter
//        threadDict[@"someUniqueKey"] = formatter;
//    }
    
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    NSDate *now = [NSDate date];
//    
//    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
//    
//    NSDate *startDate = [calendar dateFromComponents:components];
//    
//    NSString *currentDate = [formatter stringFromDate:startDate];
//    
//    NSLog(@"%@",currentDate);
    
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];

    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:nil options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        if (!result) {
            NSLog(@"fail");
            return;
        }
        double totalSteps = [result.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
        
        NSLog(@"%f total lifetime steps",totalSteps);
        
        //500k lifetime steps complete
        if (totalSteps >= 500000 && [timesEarned[9] isEqual:@0]) {
            
            [timesEarned replaceObjectAtIndex:9 withObject:[NSNumber numberWithInt:1]];
            [lastTimeEarned replaceObjectAtIndex:9 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //1mil lifetime steps complete
        if (totalSteps >= 1000000 && [timesEarned[10] isEqual:@0]) {
            
            [timesEarned replaceObjectAtIndex:10 withObject:[NSNumber numberWithInt:1]];
            [lastTimeEarned replaceObjectAtIndex:10 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //5mil lifetime steps complete
        if (totalSteps >= 5000000 && [timesEarned[11] isEqual:@0]) {
            
            [timesEarned replaceObjectAtIndex:11 withObject:[NSNumber numberWithInt:1]];
            [lastTimeEarned replaceObjectAtIndex:11 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //10 mil lifetime steps complete
        if (totalSteps >= 10000000 && [timesEarned[12] isEqual:@0]) {
            
            [timesEarned replaceObjectAtIndex:12 withObject:[NSNumber numberWithInt:1]];
            [lastTimeEarned replaceObjectAtIndex:12 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //babysteps lifetime steps complete
        if (totalSteps >= 1 && [timesEarned[13] isEqual:@0]) {
            
            [timesEarned replaceObjectAtIndex:13 withObject:[NSNumber numberWithInt:1]];
            [lastTimeEarned replaceObjectAtIndex:13 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }

    }];
    
    [self.healthStore executeQuery:query];
    
}

-(void)dailyCalories
{
    NSLog(@"in daily calories");

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
//    NSString *currentDate = [formatter stringFromDate:startDate];
//
//    NSLog(@"%@",currentDate);
    
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        if (!result) {
            NSLog(@"fail");
            return;
        }
        int value = 0;
        double totalCalories = [result.sumQuantity doubleValueForUnit:[HKUnit calorieUnit]];
        totalCalories = (totalCalories)/1000;
        
        NSLog(@"%f total calories",totalCalories);
        //500 calories complete
        if (totalCalories >= 500 && ![lastTimeEarned[26] isEqualToString:currentDate]) {
            value = [timesEarned[26] intValue];
            
            [timesEarned replaceObjectAtIndex:26 withObject:[NSNumber numberWithInt:value+1]];
            [lastTimeEarned replaceObjectAtIndex:26 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //1000 calories complete
        if (totalCalories >= 1000 && ![lastTimeEarned[27] isEqualToString:currentDate]) {
            value = [timesEarned[27] intValue];
            
            [timesEarned replaceObjectAtIndex:27 withObject:[NSNumber numberWithInt:value+1]];
            [lastTimeEarned replaceObjectAtIndex:27 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //1500 calories complete
        if (totalCalories >= 1500 && ![lastTimeEarned[28] isEqualToString:currentDate]) {
            value = [timesEarned[28] intValue];
            
            [timesEarned replaceObjectAtIndex:28 withObject:[NSNumber numberWithInt:value+1]];
            [lastTimeEarned replaceObjectAtIndex:28 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //2000 calories complete
        if (totalCalories >= 2000 && ![lastTimeEarned[29] isEqualToString:currentDate]) {
            value = [timesEarned[29] intValue];
            
            [timesEarned replaceObjectAtIndex:29 withObject:[NSNumber numberWithInt:value+1]];
            [lastTimeEarned replaceObjectAtIndex:29 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        
    }];
    
    [self.healthStore executeQuery:query];
  
}
-(void)yesterdayCalories
{
    NSLog(@"in yesterday calories");
    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *formatter = threadDict[@"someUniqueKey"];
    if (!formatter)
    {
        //create the formatter
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        
        //cache the formatter
        threadDict[@"someUniqueKey"] = formatter;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    
    
    NSDate *endDate = [calendar dateFromComponents:components];//[calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSDate *startDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:endDate options:0];
    
//    NSString *yesterdayDate = [formatter stringFromDate:startDate];
//    NSString *currentDate = [formatter stringFromDate:endDate];
    //

//    NSLog(@"%@",yesterdayDate);
//    NSLog(@"%@",currentDate);
    
    
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        if (!result) {
            NSLog(@"fail");
            return;
        }
        int value=0;
        double totalCalories = [result.sumQuantity doubleValueForUnit:[HKUnit calorieUnit]];
        totalCalories = (totalCalories)/1000;
        
        NSLog(@"%f total calories yesterday",totalCalories);
        
    //quitter complete
    if (totalCalories == 0 && ![lastTimeEarned[25] isEqualToString:currentDate]) {
        value = [timesEarned[25] intValue];
        
        [timesEarned replaceObjectAtIndex:25 withObject:[NSNumber numberWithInt:value+1]];
        [lastTimeEarned replaceObjectAtIndex:25 withObject:currentDate];
        
        dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
        
        // write back to file
        [dict writeToFile:path atomically:YES];
    }
    }];
    
    [self.healthStore executeQuery:query];

}

-(void)dailyFlights
{
    NSLog(@"in daily flights");

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
//    NSString *currentDate = [formatter stringFromDate:startDate];
//    
//    NSLog(@"%@",currentDate);
//    
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        if (!result) {
            NSLog(@"fail");
            return;
        }
        int value = 0;
        double totalFlights = [result.sumQuantity doubleValueForUnit:[HKUnit countUnit]];

        
        NSLog(@"%f total flights",totalFlights);
        
        //22 flights complete
        if (totalFlights >= 22 && ![lastTimeEarned[35] isEqualToString:currentDate]) {
            value = [timesEarned[35] intValue];
            
            [timesEarned replaceObjectAtIndex:35 withObject:[NSNumber numberWithInt:value+1]];
            [lastTimeEarned replaceObjectAtIndex:35 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //45 flights complete
        if (totalFlights >= 45 && ![lastTimeEarned[36] isEqualToString:currentDate]) {
            value = [timesEarned[36] intValue];
            
            [timesEarned replaceObjectAtIndex:36 withObject:[NSNumber numberWithInt:value+1]];
            [lastTimeEarned replaceObjectAtIndex:36 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //86 flights complete
        if (totalFlights >= 86 && ![lastTimeEarned[37] isEqualToString:currentDate]) {
            value = [timesEarned[37] intValue];
            
            [timesEarned replaceObjectAtIndex:37 withObject:[NSNumber numberWithInt:value+1]];
            [lastTimeEarned replaceObjectAtIndex:37 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //160 flights complete
        if (totalFlights >= 160 && ![lastTimeEarned[38] isEqualToString:currentDate]) {
            value = [timesEarned[38] intValue];
            
            [timesEarned replaceObjectAtIndex:38 withObject:[NSNumber numberWithInt:value+1]];
            [lastTimeEarned replaceObjectAtIndex:38 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }

        
    }];
    
    [self.healthStore executeQuery:query];
    
}

-(void)dailyDistance
{
    NSLog(@"in daily distance");
//    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
//    NSDateFormatter *formatter = threadDict[@"someUniqueKey"];
//    if (!formatter)
//    {
//        //create the formatter
//        formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy/MM/dd"];
//        
//        //cache the formatter
//        threadDict[@"someUniqueKey"] = formatter;
//    }
//    
//    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
//    NSString *currentDate = [formatter stringFromDate:startDate];
//    
//    NSLog(@"%@",currentDate);
    
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        if (!result) {
            NSLog(@"dailyDistance fail");
            return;
        }
        int value = 0;
        double totalDistance = [result.sumQuantity doubleValueForUnit:[HKUnit mileUnit]];
        
        
        NSLog(@"%f total distance",totalDistance);
        
        //13.1 daily distance complete
        if (totalDistance >= 13.1 && ![lastTimeEarned[17] isEqualToString:currentDate]) {
            value = [timesEarned[17] intValue];
            
            [timesEarned replaceObjectAtIndex:17 withObject:[NSNumber numberWithInt:value+1]];
            [lastTimeEarned replaceObjectAtIndex:17 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //26.2 daily distance complete
        if (totalDistance >= 26.2 && ![lastTimeEarned[18] isEqualToString:currentDate]) {
            value = [timesEarned[18] intValue];
            
            [timesEarned replaceObjectAtIndex:18 withObject:[NSNumber numberWithInt:value+1]];
            [lastTimeEarned replaceObjectAtIndex:18 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }

    }];
    
    [self.healthStore executeQuery:query];
    
}

-(void)lifetimeDistance
{
    NSLog(@"in lifetime distance");
//    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
//    NSDateFormatter *formatter = threadDict[@"someUniqueKey"];
//    if (!formatter)
//    {
//        //create the formatter
//        formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy/MM/dd"];
//        
//        //cache the formatter
//        threadDict[@"someUniqueKey"] = formatter;
//    }
//    
//    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    NSDate *now = [NSDate date];
//
//    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
//    
//    NSDate *startDate = [calendar dateFromComponents:components];
//    
//    NSString *currentDate = [formatter stringFromDate:startDate];
//    
//    NSLog(@"%@",currentDate);
//    
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:nil options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        if (!result) {
            NSLog(@"fail");
            return;
        }
        double totalDistance = [result.sumQuantity doubleValueForUnit:[HKUnit mileUnit]];
        
        NSLog(@"%f total lifetime distance",totalDistance);
        
        //100 lifetime distance complete
        if (totalDistance >= 100 && [timesEarned[19] isEqual:@0]) {
            
            [timesEarned replaceObjectAtIndex:19 withObject:[NSNumber numberWithInt:1]];
            [lastTimeEarned replaceObjectAtIndex:19 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //500 lifetime steps complete
        if (totalDistance >= 500 && [timesEarned[20] isEqual:@0]) {
            
            [timesEarned replaceObjectAtIndex:20 withObject:[NSNumber numberWithInt:1]];
            [lastTimeEarned replaceObjectAtIndex:20 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //1000 lifetime distance complete
        if (totalDistance >= 1000 && [timesEarned[21] isEqual:@0]) {
            
            [timesEarned replaceObjectAtIndex:21 withObject:[NSNumber numberWithInt:1]];
            [lastTimeEarned replaceObjectAtIndex:21 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //5000 lifetime distance complete
        if (totalDistance >= 5000 && [timesEarned[22] isEqual:@0]) {
            
            [timesEarned replaceObjectAtIndex:22 withObject:[NSNumber numberWithInt:1]];
            [lastTimeEarned replaceObjectAtIndex:22 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //10000 lifetime distance complete
        if (totalDistance >= 10000 && [timesEarned[23] isEqual:@0]) {
            
            [timesEarned replaceObjectAtIndex:23 withObject:[NSNumber numberWithInt:1]];
            [lastTimeEarned replaceObjectAtIndex:23 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        //50000 lifetime distance complete
        if (totalDistance >= 50000 && [timesEarned[24] isEqual:@0]) {
            
            [timesEarned replaceObjectAtIndex:24 withObject:[NSNumber numberWithInt:1]];
            [lastTimeEarned replaceObjectAtIndex:24 withObject:currentDate];
            
            dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tableData,descriptionData,timesEarned,canEarnMultipleTimes,images,lastTimeEarned,nil] forKeys:[NSArray arrayWithObjects:@"Achievements",@"Description",@"TimesEarned",@"CanEarnMultipleTimes",@"Images",@"LastTimeEarned",nil]];
            
            // write back to file
            [dict writeToFile:path atomically:YES];
        }
        
    }];
    
    [self.healthStore executeQuery:query];
    
}
@end
