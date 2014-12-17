//
//  News.m
//  ImageSlider_2
//
//  Created by Ishan .
//  Copyright (c) 2557 BE Ishan . All rights reserved.
//

#import "News.h"

@implementation News


-(id)initWithIndexId:(NSString *)index{

    self=[super init];
    if(self){
        [self setIndexId:index];
    
    }

    return self;
}

+(id)newsWithIndex:(NSString *)index{

    return [[self alloc]initWithIndexId:index];
}

@end
