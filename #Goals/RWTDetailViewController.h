//
//  RWTDetailViewController.h
//  ScaryBugs
//
//  Created by Jorge Jordán Arenas on 04/02/14.
//
//

#import <UIKit/UIKit.h>

@interface RWTDetailViewController : UIViewController <UINavigationControllerDelegate>

@property (strong, nonatomic) NSString* titleItem;
@property (strong, nonatomic) NSString* descriptionItem;
@property (strong, nonatomic) NSString* timesEarnedItem;
@property (strong, nonatomic) UIImage* fullImageItem;
@property (strong, nonatomic) NSNumber* canEarnMultipleTimesItem;
@property (strong, nonatomic) NSString* lastTimeEarnedItem;

@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextField *timesEarned;
@property (strong, nonatomic) IBOutlet UITextView *descriptionView;
@property (strong, nonatomic) IBOutlet UITextField *lastTimeEarnedField;

@end
