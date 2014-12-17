//
//  FoodCell.h
//  ImageSlider_2
//
//  Created by Ishan .
//  Copyright (c) 2557 BE Ishan . All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class Food;
@interface FoodCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UITextView *lblBody;
@property (weak, nonatomic) IBOutlet UIImageView *moodImage;


-(void)configureCellForFood:(Food *)food;
+(CGFloat)heightyForEntry:(Food *)food;

@end
