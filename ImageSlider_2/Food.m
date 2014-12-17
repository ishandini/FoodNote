//
//  Food.m
//  ImageSlider_2
//
//  Created by Ishan  on 12/4/2557 BE.
//  Copyright (c) 2557 BE Ishan . All rights reserved.
//

#import "Food.h"


@implementation Food

@dynamic body;
@dynamic date;
@dynamic location;
@dynamic image;
@dynamic mood;

-(NSString *)sectionName{
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:self.date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy"];
    
    return [formatter stringFromDate:date];
    
}

@end
