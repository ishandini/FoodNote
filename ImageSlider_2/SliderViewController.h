//
//  SliderViewController.h
//  ImageSlider_2
//
//  Created by Ishan .
//  Copyright (c) 2557 BE Ishan . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"


@interface SliderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UIView *bgColorView;
}

@property(strong,nonatomic)NSArray *listIdentifier;

@end
