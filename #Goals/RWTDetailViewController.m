//
//  RWTDetailViewController.m
//  ScaryBugs
//
//  Created by Jorge Jordán Arenas on 04/02/14.
//
//

#import "RWTDetailViewController.h"

@interface RWTDetailViewController ()
- (void)configureView;
@end

@implementation RWTDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
//    if (_titleItem != newDetailItem) {
//        _titleItem = newDetailItem;
//        
//        // Update the view.
//        [self configureView];
//    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    self.title = @"Details";
    if (self.titleItem) {
        self.titleField.text = self.titleItem;
        self.descriptionView.text = self.descriptionItem;
        
        if ([self.canEarnMultipleTimesItem isEqual:@1])
        {
            self.timesEarned.text = [NSString stringWithFormat:@"You have earned this %@ times!",self.timesEarnedItem];
        }
        else if([self.canEarnMultipleTimesItem isEqual:@0] && [self.timesEarnedItem isEqualToString:@"0"])
        {
            self.timesEarned.text = @"You have not earned this achievement yet!";
        }
        else
        {
            self.timesEarned.text = @"You have earned this achievement!";
        }
        self.imageView.image = self.fullImageItem;
        if (![self.lastTimeEarnedItem isEqualToString:@""]) {
        self.lastTimeEarnedField.text = [NSString stringWithFormat:@"Earned on: %@",self.lastTimeEarnedItem];
        }
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
