//
//  SliderViewController.m
//  ImageSlider_2
//
//  Created by Ishan .
//  Copyright (c) 2557 BE Ishan . All rights reserved.
//

#import "SliderViewController.h"

@implementation SliderViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.listIdentifier=@[@"foodList",@"news",@"ctr3",@"ctr4"];
    
    bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:83.0f/255.0f blue:83.0f/255.0f alpha:1.0f];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}


#pragma mark-table data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableViewa{
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"Cell";
    cellIdentifier= [self.listIdentifier objectAtIndex:indexPath.row];
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
    
    
}

@end
