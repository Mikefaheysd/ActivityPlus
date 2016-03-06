//
//  ComplicationController.m
//  Activity+ Extension
//
//  Created by Michael Fahey on 10/3/15.
//  Copyright © 2015 Michael Fahey. All rights reserved.
//

#import "ComplicationController.h"

@interface ComplicationController ()

@end

@implementation ComplicationController

#pragma mark - Timeline Configuration

- (void)getSupportedTimeTravelDirectionsForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimeTravelDirections directions))handler {
    handler(CLKComplicationTimeTravelDirectionForward|CLKComplicationTimeTravelDirectionBackward);
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    NSDate *now = [NSDate date];
    handler(now);
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [NSDateComponents new];
    components.minute = 30;
    components.hour = 10;
    NSDate *date = [calendar dateByAddingComponents:components toDate:now options:0];
    handler(date);
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    // Call the handler with the current timeline entry
    CLKComplicationTemplateModularLargeColumns *myComplicationTemplate = [[CLKComplicationTemplateModularLargeColumns alloc] init];
    //Steps
    myComplicationTemplate.row1Column1TextProvider = [CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
    //step count
    myComplicationTemplate.row1Column2TextProvider = [CLKSimpleTextProvider textProviderWithFormat:@"Loading..."];
    
    //cals
    myComplicationTemplate.row2Column1TextProvider = [CLKSimpleTextProvider textProviderWithFormat:@"Calories"];
    //cal count
    myComplicationTemplate.row2Column2TextProvider= [CLKSimpleTextProvider textProviderWithFormat:@"Loading..."];
    
    
    //dist
    myComplicationTemplate.row3Column1TextProvider =[CLKSimpleTextProvider textProviderWithFormat:@"Dist"];
    //dist count
    myComplicationTemplate.row3Column2TextProvider=[CLKSimpleTextProvider textProviderWithFormat:@"Loading..."];
    
    CLKComplicationTimelineEntry * entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate timelineAnimationGroup:NULL];
    
    handler(entry);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries prior to the given date
    CLKComplicationTemplateModularLargeColumns *myComplicationTemplate = [[CLKComplicationTemplateModularLargeColumns alloc] init];
    //Steps
    myComplicationTemplate.row1Column1TextProvider = [CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
    //step count
    myComplicationTemplate.row1Column2TextProvider = [CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
    
    //cals
    myComplicationTemplate.row2Column1TextProvider = [CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
    //cal count
    myComplicationTemplate.row2Column2TextProvider= [CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
    
    
    //dist
    myComplicationTemplate.row3Column1TextProvider =[CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
    //dist count
    myComplicationTemplate.row3Column2TextProvider=[CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
    
    CLKComplicationTimelineEntry * entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate timelineAnimationGroup:NULL];
    NSMutableArray *entries =nil;
    [entries addObject:entry ];
    handler(entries   );
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
    
    CLKComplicationTemplateModularLargeColumns *myComplicationTemplate = [[CLKComplicationTemplateModularLargeColumns alloc] init];
    //Steps
    myComplicationTemplate.row1Column1TextProvider = [CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
    //step count
    myComplicationTemplate.row1Column2TextProvider = [CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
    
    //cals
    myComplicationTemplate.row2Column1TextProvider = [CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
    //cal count
    myComplicationTemplate.row2Column2TextProvider= [CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
    
    
    //dist
    myComplicationTemplate.row3Column1TextProvider =[CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
    //dist count
    myComplicationTemplate.row3Column2TextProvider=[CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
    
    CLKComplicationTimelineEntry * entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate timelineAnimationGroup:NULL];
    NSMutableArray *entries =nil;
    [entries addObject:entry ];
    handler(entries);
}

#pragma mark Update Scheduling

- (void)getNextRequestedUpdateDateWithHandler:(void(^)(NSDate * __nullable updateDate))handler {
    // Call the handler with the date when you would next like to be given the opportunity to update your complication content
    handler(nil);
}

#pragma mark - Placeholder Templates

- (void)getPlaceholderTemplateForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
//    CLKComplicationTemplate *temp = nil;
//    
//    switch (complication.family) {
//        case CLKComplicationFamilyModularLarge:
//        {
            NSLog(@"sdsd:");
            CLKComplicationTemplateModularLargeColumns *myComplicationTemplate = [[CLKComplicationTemplateModularLargeColumns alloc] init];
            //Steps
            myComplicationTemplate.row1Column1TextProvider = [CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
            //step count
            myComplicationTemplate.row1Column2TextProvider = [CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
            
            //cals
            myComplicationTemplate.row2Column1TextProvider = [CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
            //cal count
            myComplicationTemplate.row2Column2TextProvider= [CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
            
            
            //dist
            myComplicationTemplate.row3Column1TextProvider =[CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
            //dist count
            myComplicationTemplate.row3Column2TextProvider=[CLKSimpleTextProvider textProviderWithFormat:@"Steps"];
//            temp = myComplicationTemplate;
//        }
//        default:
//            break;
//    }
    handler(myComplicationTemplate);
    // This method will be called once per supported complication, and the results will be cached
    //handler(nil);
}

@end
