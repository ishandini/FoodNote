//
//  DetailsViewController.h
//  ImageSlider_2
//
//  Created by Ishan .
//  Copyright (c) 2557 BE Ishan . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
@interface DetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property(strong,nonatomic)News *news;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

- (IBAction)backToList:(id)sender;

 
@end
