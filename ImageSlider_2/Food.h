//
//  Food.h
//  ImageSlider_2
//
//  Created by Ishan  on 12/4/2557 BE.
//  Copyright (c) 2557 BE Ishan . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ENUM(int16_t, FoodTasteMood){
    FoodTasteMoodGood=0,
    FoodTasteMoodAverage=1,
    FoodTasteMoodBad=2
};

@interface Food : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic) NSTimeInterval date;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSData * image;
@property (nonatomic) int16_t mood;

@property(nonatomic,readonly)NSString *sectionName;

@end
