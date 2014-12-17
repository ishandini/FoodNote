//
//  ViewController.m
//  ImageSlider_2
//
//  Created by Ishan  on 12/3/2557 BE.
//  Copyright (c) 2557 BE Ishan . All rights reserved.
//

#import "ViewController.h"
#import "News.h"
#import "DetailsViewController.h"
#import "CDActivityIndicatorView.h"


@interface ViewController (){
    int slide;
    NSArray *arrImagesUrl;
    NSMutableArray *newsArray;
     

}
@property (weak, nonatomic) IBOutlet UIImageView *photoViewer;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;

@end

@implementation ViewController{

    PullToRefreshView *pull;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    newsArray=[[NSMutableArray alloc] init];
    slide=0;
    [self customSetup];
    [self changeImage];
   [self pullToRefresh];
    [self loadNews];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foregroundRefresh:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
     
    
    
    //     [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    
    
    
    
    //........towards right Gesture recogniser for swiping.....//
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeImageBack)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    [self.photoViewer addGestureRecognizer:rightRecognizer];
    
    
    //........towards left Gesture recogniser for swiping.....//
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftRecognizer setNumberOfTouchesRequired:1];
    [self.photoViewer addGestureRecognizer:leftRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)changeImage {
    
    slide++;
    if(slide>5){
        slide=1;
    }
    
    NSString *imgName=[NSString stringWithFormat:@"image0%i.jpg",slide];
    UIImage *img=[UIImage imageNamed:imgName];
    
    
    [UIView transitionWithView:self.view
                      duration:1.75f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.photoViewer.image=img;
                    }
                    completion:nil];
    self.lblTitle.text=imgName;
    self.pageController.currentPage=slide-1;
    
    
}


- (void)changeImageBack {
    
    slide--;
    if(slide<1){
        slide=5;
    }
    
    NSString *imgName=[NSString stringWithFormat:@"image0%i.jpg",slide];
    UIImage *img=[UIImage imageNamed:imgName];
    
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.photoViewer.image=img;
                    }
                    completion:nil];
    self.lblTitle.text=imgName;
    self.pageController.currentPage=slide-1;
    
    
}
- (IBAction)imgGoLeft:(id)sender {
    [self changeImageBack];
}
- (IBAction)imgGoRight:(id)sender {
    [self changeImage];
    
}

#pragma mark-slider setup

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}


#pragma mark state preservation / restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}


- (void)applicationFinishedRestoringState
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Call whatever function you need to visually restore
    [self customSetup];
}

#pragma mark-pull to refresh
-(void)pullToRefresh{

    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [pull setDelegate:self];
    [self.tableView addSubview:pull];
}



- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    [self performSelectorInBackground:@selector(reloadTableData) withObject:nil];
}

-(void) reloadTableData
{
    [self.tableView reloadData];
    [pull finishedLoading];
}

-(void)foregroundRefresh:(NSNotification *)notification
{
    self.tableView.contentOffset = CGPointMake(0, -65);
    [pull setState:PullToRefreshViewStateLoading];
    [self performSelectorInBackground:@selector(reloadTableData) withObject:nil];
}


#pragma mark-load data from internet

-(BOOL)hasInternet{

    Reachability *networkReachbility=[Reachability reachabilityForInternetConnection];
   NetworkStatus status= [networkReachbility currentReachabilityStatus];
    if(status==NotReachable){
        return NO;
    }
    else{
        return YES;
    }
}

-(void)loadNews{

    if ([self hasInternet]) {
        
        CDActivityIndicatorView * activityIndicatorView = [[CDActivityIndicatorView alloc] initWithImage:[UIImage imageNamed:@"custom_spinner.png"]];
        
        activityIndicatorView.center = CGPointMake(160, 360);
        
        [self.view addSubview:activityIndicatorView];
        
        [activityIndicatorView startAnimating];
        
        
        NSURL *url=[NSURL URLWithString:@"http://harasaratravels.com/assets/wpmobileesana"];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSError *err=nil;
            
            NSDictionary *jsonData=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            
            
            if(jsonData!=nil){
                for (NSDictionary *news in jsonData) {
                    NSString *postTitle = [news objectForKey:@"post_title"];
                    NSString *postContent =  [news objectForKey:@"post_content"];
                    
                    
                    
                    NSString *postDescription = [news objectForKey:@"post_description"] ;
                    
                    News *n=[News newsWithIndex:[news objectForKey:@"id"]];
                    n.title= postTitle;
                    n.date=[news objectForKey:@"post_date"]  ;
                    n.content=postContent ;
                    n.des=postDescription;
                    
                    if([news objectForKey:@"simg"]!=nil){
                        n.thumbUrl=[news objectForKey:@"simg"];
                    }
                    
                    [newsArray addObject:n];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[self tableView] reloadData];
                    [activityIndicatorView stopAnimating];
                });
                
            }else{
                [activityIndicatorView stopAnimating];
                
              
            }
            
        }];
    
    }else{
    
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"Network Error" contentText:@"Please check internet connection" leftButtonTitle:nil rightButtonTitle:@"Ok"];
         [alert show];
          
        
    }
   
    
}

#pragma mark- tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    News *news=[newsArray objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text=news.title;
    cell.detailTextLabel.text=news.content;
    cell.imageView.image=[UIImage imageNamed:@"newsLogo.png"];
    if(news.thumb==nil){
        
        dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            NSURL *url=[NSURL URLWithString:news.thumbUrl];
            NSData *imgData=[NSData dataWithContentsOfURL:url];
            
            if(imgData!=nil){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *img=[UIImage imageWithData:imgData];
                    cell.imageView.image=img;
                    [cell setNeedsLayout];
                    news.thumb=img;
                });
            }
            
            
        });
    }else{
        cell.imageView.image=news.thumb;
        
    }
     
    
    return  cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.imageView.frame = (CGRect){{0.0f, 0.0f}, 44, 44};
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.height / 2.0f;
}


#pragma mark-go to details

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showDetail"]){
        NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
        News *n=[newsArray objectAtIndex:indexPath.row];
        UINavigationController *navigationController=[segue destinationViewController];
        
        DetailsViewController *de=(DetailsViewController *)navigationController.topViewController;
        de.news=n;
    }
    
    
    
    
}

@end
