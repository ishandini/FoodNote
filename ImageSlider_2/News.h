//
//  News.h
//  ImageSlider_2
//
//  Created by Ishan .
//  Copyright (c) 2557 BE Ishan . All rights reserved.
//

#import <UIKit/UIKit.h>
@interface News : NSObject

@property(strong,nonatomic)NSString *indexId;
@property(strong,nonatomic)NSString *title;
@property(strong,nonatomic)NSString *date;
@property(strong,nonatomic)NSString *content;
@property(strong,nonatomic)NSString *des;
@property(strong,nonatomic)NSString *thumbUrl;
@property(strong,nonatomic)UIImage *thumb;

-(id)initWithIndexId:(NSString *)indexId;

+(id)newsWithIndex:(NSString *)index;


@end
