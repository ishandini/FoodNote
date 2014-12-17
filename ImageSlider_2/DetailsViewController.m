//
//  DetailsViewController.m
//  ImageSlider_2
//
//  Created by Ishan .
//  Copyright (c) 2557 BE Ishan . All rights reserved.
//

#import "DetailsViewController.h"

@implementation DetailsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    if(self.news!=nil){

        self.lblDate.text=self.news.date;
        self.lblTitle.text=self.news.title;

         [self.webView loadHTMLString:self.news.des baseURL:nil];
    }
}

- (void)viewDidUnload {
	[super viewDidUnload];
}


- (IBAction)backToList:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
 
@end
