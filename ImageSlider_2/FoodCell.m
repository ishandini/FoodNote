//
//  FoodCell.m
//  ImageSlider_2
//
//  Created by Ishan .
//  Copyright (c) 2557 BE Ishan . All rights reserved.
//

#import "FoodCell.h"
#import "Food.h"

@implementation FoodCell

-(void)configureCellForFood:(Food *)food{
    self.lblBody.text=food.body;
    
    
    NSDateFormatter *formateer=[[NSDateFormatter alloc] init];
    [formateer setDateFormat:@"hh:mm a"];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:food.date];
    self.lblDate.text=[formateer stringFromDate:date];
    
    if(food.image){
        self.mainImage.image=[UIImage imageWithData:food.image];
    }else{
        self.mainImage.image=[UIImage imageNamed:@"noImage"];
    }
    
    
    if(food.mood==FoodTasteMoodGood){
        self.moodImage.image=[UIImage imageNamed:@"icn_happy"];
        
    }else if (food.mood==FoodTasteMoodAverage){
        self.moodImage.image=[UIImage imageNamed:@"icn_average"];
        
    }else if (food.mood==FoodTasteMoodBad){
        self.moodImage.image=[UIImage imageNamed:@"icn_bad"];
        
    }
     if(food.location.length>0){
        self.lblLocation.text=food.location;
    }else{
        self.lblLocation.text=@"No Location";

    }
    
    CGSize itemSize = CGSizeMake(80, 80);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [self.mainImage.image drawInRect:imageRect];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.mainImage.layer.cornerRadius=CGRectGetWidth(self.mainImage.frame)/2.0f;
    
}


+(CGFloat)heightyForEntry:(Food *)food{
    
    const CGFloat topMargin=20.0f;
    const CGFloat bottomMargin=50.0f;
    const CGFloat minHeight=120.0f;
    
    UIFont *font=[UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGRect boundingBox=[food.body boundingRectWithSize:CGSizeMake(190, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil];
    
    return MAX(minHeight, CGRectGetHeight(boundingBox)+topMargin+bottomMargin);
    
}

@end
