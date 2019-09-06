//
//  FiltersViewController.h
//  Naamee
//
//  Created by Saurav on 17/02/16.
//  Copyright © 2016 Saurav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shareViewController.h"

@interface FiltersViewController : UIViewController
{
    NSArray *filtersArray;
    NSIndexPath *selectedIndexPath;
    UIImage *thumbnailImage;
    NSMutableDictionary *storedThumbnails;
}

@property (strong, nonatomic) IBOutlet UIImageView *imagePreview;

@property BOOL isCommenting;

@property (strong, nonatomic) UIImage *capturedImage;
@property (strong, nonatomic) NSDictionary *details;
@property (strong, nonatomic) IBOutlet UIView *topview;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UICollectionView *filtersCollectionView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

- (IBAction)back:(id)sender;
- (IBAction)moveForward:(id)sender;
- (IBAction)cropImage:(id)sender;

@end
