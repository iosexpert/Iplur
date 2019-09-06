//
//  FilterCollectionViewCell.h
//  Photo Filter Effects
//
//  Created by Ajit on 16/02/16.
//
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

@interface FilterCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet CustomLabel *filterLabel;
@property (strong, nonatomic) IBOutlet UIImageView *filterImageView;
@end
