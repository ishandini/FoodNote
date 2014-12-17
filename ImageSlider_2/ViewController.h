//
//  ViewController.h
//  ImageSlider_2
//
//  Created by Ishan  on 12/3/2557 BE.
//  Copyright (c) 2557 BE Ishan . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"
#import "SWRevealViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "DXAlertView.h"

    
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullToRefreshViewDelegate>


@end

