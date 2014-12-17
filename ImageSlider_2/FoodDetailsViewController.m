//
//  FoodDetailsViewController.m
//  ImageSlider_2
//
//  Created by Ishan .
//  Copyright (c) 2557 BE Ishan . All rights reserved.
//

#import "FoodDetailsViewController.h"
#import "CoreDataStack.h"
#import "Food.h"

@implementation FoodDetailsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    
    NSDate *date;
    
    if(_oldFood!=nil){
        self.txtBody.text=self.oldFood.body;
        self.pickedMood=self.oldFood.mood;
        self.pickedImage=[UIImage imageWithData:self.oldFood.image];
        date=[NSDate dateWithTimeIntervalSince1970:self.oldFood.date];
     
    }else{
        self.pickedMood=FoodTasteMoodGood;
        date=[NSDate date];
        [self loadLocation];
    }
    
    
    
    self.imgButton.layer.cornerRadius=CGRectGetWidth(self.imgButton.frame)/2.0f;

    NSDateFormatter *formattter=[[NSDateFormatter alloc] init];
    [formattter setDateFormat:@"EEEE, MMMM d"];
    self.lblDate.text=[formattter stringFromDate:date];
    
    
    self.txtBody.inputAccessoryView=self.accesoryView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.txtBody becomeFirstResponder];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

-(void)dismissSelf{
    [self.view endEditing:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissSelf];
}

- (IBAction)donePressed:(id)sender {
    if(_oldFood==nil){
     [self enterFood];
    }else{
        [self updateFood];
    }
   
    [self dismissSelf];

}

#pragma  mark-load location

-(void)loadLocation{
    self.locationManager=[[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy=1000;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
     [self.locationManager stopUpdatingLocation];
    CLLocation *location=[locations firstObject];
    CLGeocoder *geoCoder=[[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placeMark=[placemarks firstObject];
        self.location=[placeMark name];
    }];
}

#pragma  mark-mood
-(void)setPickedMood:(enum FoodTasteMood)pickedMood{

    _pickedMood=pickedMood;
    
    self.badButton.alpha=0.5f;
    self.tasteButton.alpha=0.5f;
    self.deliciousButton.alpha=0.5f;
    
    switch (pickedMood) {
        case FoodTasteMoodGood:
            self.deliciousButton.alpha=1.0f;
            break;
            
        case FoodTasteMoodAverage:
            self.tasteButton.alpha=1.0f;
            break;
            
        case FoodTasteMoodBad:
            self.badButton.alpha=1.0f;
            break;
          
    }
    
}

#pragma mark-enter food

-(void)enterFood{
         if(![self.txtBody.text isEqual:@""]){
             CoreDataStack *coreDataStack=[CoreDataStack defaultStack];
            Food *food=[NSEntityDescription insertNewObjectForEntityForName:@"Food" inManagedObjectContext:[coreDataStack managedObjectContext]];
            food.body=self.txtBody.text;
            food.date=[[NSDate date] timeIntervalSince1970];
             food.image=UIImageJPEGRepresentation(self.pickedImage, 0.75f);
             food.mood=self.pickedMood;
             food.location=self.location;
            [coreDataStack saveContext];
        }
  }

-(void)updateFood{
    self.oldFood.body=self.txtBody.text;
    self.oldFood.image=UIImageJPEGRepresentation(self.pickedImage, 0.75f);
    self.oldFood.mood=self.pickedMood;
    CoreDataStack *coreDataStack=[CoreDataStack defaultStack];
    [coreDataStack saveContext];
}

- (IBAction)badPress:(id)sender {
    self.pickedMood=FoodTasteMoodBad;
}

- (IBAction)tastePress:(id)sender {
    self.pickedMood=FoodTasteMoodAverage;

}

- (IBAction)deliciousPress:(id)sender {
    self.pickedMood=FoodTasteMoodGood;

}

#pragma mark-Action sheet
-(void)promtForSource{

    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Roll", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(buttonIndex!=actionSheet.cancelButtonIndex){
    
        if(buttonIndex==actionSheet.firstOtherButtonIndex){
            [self promtForCamera];
        }else{
            [self promtForPhotoRoll];
        }
    }
}

-(void)promtForCamera{

    UIImagePickerController *controller=[[UIImagePickerController alloc] init];
    controller.sourceType=UIImagePickerControllerSourceTypeCamera;
    controller.delegate=self;
    [self presentViewController:controller animated:YES completion:nil];

}

-(void)promtForPhotoRoll{
    
    UIImagePickerController *controller=[[UIImagePickerController alloc] init];
    controller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate=self;
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    UIImage *img=info[UIImagePickerControllerOriginalImage];
    self.pickedImage=img;

    [self dismissViewControllerAnimated:YES completion:nil];
 }

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)imgButtonPress:(id)sender {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self promtForSource];
    }else{
          [self promtForPhotoRoll];
    }
}

-(void)setPickedImage:(UIImage *)pickedImage{
    _pickedImage=pickedImage;
    if(pickedImage==nil){
     [self.imgButton setImage:[UIImage imageNamed:@"noImage"] forState:UIControlStateNormal];
    }else{
    [self.imgButton setImage:self.pickedImage forState:UIControlStateNormal];
    }
}


@end
