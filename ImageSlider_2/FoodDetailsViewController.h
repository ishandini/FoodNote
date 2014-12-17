//
//  FoodDetailsViewController.h
//  ImageSlider_2
//
//  Created by Ishan .
//  Copyright (c) 2557 BE Ishan . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"
#import <CoreLocation/CoreLocation.h>

@interface FoodDetailsViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate>
- (IBAction)cancelPressed:(id)sender;
- (IBAction)donePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *txtBody;
@property (weak, nonatomic) IBOutlet UIButton *imgButton;
 

@property(strong,nonatomic)Food* oldFood;
@property(nonatomic,assign) enum FoodTasteMood pickedMood;

@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *tasteButton;
@property (weak, nonatomic) IBOutlet UIButton *deliciousButton;

@property (strong, nonatomic) IBOutlet UIView *accesoryView;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property(strong,nonatomic)UIImage *pickedImage;

@property(strong,nonatomic)CLLocationManager *locationManager;
@property(strong,nonatomic)NSString *location;

@end
