//
//  RWTCollectionViewController.m
//  ScaryBugs
//
//  Created by Michael Fahey on 9/13/15.
//
//

#import "RWTCollectionViewController.h"
#import "RWTDetailViewController.h"

@interface RWTCollectionViewController (){
    NSArray *medalPhotos;
    NSString *path;
    NSMutableDictionary *dict;
    NSArray *tableData;
    NSArray *descriptionData;
    NSArray *canEarnMultipleTimes;
    NSArray *images;
    NSMutableArray *timesEarned;
    NSMutableArray *lastTimeEarned;

}


@end

@implementation RWTCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Achievements View";
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    //self.title = @"Achievements";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    
    path = [documentsDirectory stringByAppendingPathComponent:@"Achievements.plist"]; //3
    //dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];

    // Load the file content and read the data into arrays
    dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    tableData = [dict objectForKey:@"Achievements"];
    descriptionData = [dict objectForKey:@"Description"];
    timesEarned = [dict objectForKey:@"TimesEarned"];
    canEarnMultipleTimes = [dict objectForKey:@"CanEarnMultipleTimes"];
    images = [dict objectForKey:@"Images"];
    lastTimeEarned = [dict objectForKey:@"LastTimeEarned"];

    
   
    medalPhotos = [dict objectForKey:@"Images"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    RWTDetailViewController *detailController = [segue destinationViewController];
    NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
    detailController.titleItem = [tableData objectAtIndex:selectedIndexPath.item];
    detailController.descriptionItem = [descriptionData objectAtIndex:selectedIndexPath.item];
    detailController.timesEarnedItem = [NSString stringWithFormat:@"%@",[timesEarned objectAtIndex:selectedIndexPath.item]];
    detailController.canEarnMultipleTimesItem =[canEarnMultipleTimes objectAtIndex:selectedIndexPath.item];
    detailController.fullImageItem = [UIImage imageNamed:[images objectAtIndex:selectedIndexPath.item]];
    detailController.lastTimeEarnedItem = [lastTimeEarned objectAtIndex:selectedIndexPath.item];

}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return medalPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
    static NSString *identifier = @"viewCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = [UIImage imageNamed:[medalPhotos objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];

    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
