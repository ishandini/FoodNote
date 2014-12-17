//
//  FoodListViewController.m
//  ImageSlider_2
//
//  Created by Ishan .
//  Copyright (c) 2557 BE Ishan . All rights reserved.
//

#import "FoodListViewController.h"
#import "CoreDataStack.h"
#import "Food.h"
#import "FoodCell.h"
#import "FoodDetailsViewController.h"


@interface FoodListViewController ()<NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property(strong,nonatomic)NSFetchedResultsController *fetchResultController;


@end

@implementation FoodListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    [self customSetup];
    [[self fetchResultController] performFetch:nil];
    [self addRefreshController];



}

- (void)viewDidUnload {
	[super viewDidUnload];

}

#pragma mark-refresh controller

-(void)addRefreshController{
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor=[UIColor colorWithRed:118.0/255 green:152.0/255 blue:184.0/255 alpha:1.0f];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    [refreshControl endRefreshing];
}

#pragma mark-load data

-(NSFetchRequest *)entryListFetchRequest{
    
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"Food"];
    fetchRequest.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    return fetchRequest;
    
}

-(NSFetchedResultsController *)fetchResultController{
    if(_fetchResultController!=nil){
        return _fetchResultController;
    }
    
    CoreDataStack *coreDataStack=[CoreDataStack defaultStack];
    
    _fetchResultController=[[NSFetchedResultsController alloc] initWithFetchRequest:[self entryListFetchRequest] managedObjectContext:[coreDataStack managedObjectContext] sectionNameKeyPath:@"sectionName" cacheName:nil];
    _fetchResultController.delegate=self;
    
    return _fetchResultController;
    
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo=[self.fetchResultController sections][section];
    return [sectionInfo numberOfObjects];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [[self.fetchResultController sections] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    id<NSFetchedResultsSectionInfo> sectionInfo=[self.fetchResultController sections][section];
    
    return [sectionInfo name];
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



#pragma mark - UITableViewDataSource Methods



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	FoodCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    Food *food=[self.fetchResultController objectAtIndexPath:indexPath];
    [cell configureCellForFood:food ];
 	return cell;
}


-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
            
    }
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
    }
    
}


#pragma mark-delete a row



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
    
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Food *entry=[self.fetchResultController objectAtIndexPath:indexPath];
    CoreDataStack *coreDataStack=[CoreDataStack defaultStack];
    [[coreDataStack managedObjectContext] deleteObject:entry];
    [coreDataStack saveContext];
}


#pragma mark- custom cell height

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Food *food=[self.fetchResultController objectAtIndexPath:indexPath];
    
    return [FoodCell heightyForEntry:food];
    
    
}



#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 
    if ([segue.identifier isEqualToString:@"editFood"]) {
        UITableViewCell *cell=sender;
        NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
        Food *food=[self.fetchResultController objectAtIndexPath:indexPath];
        
        UINavigationController *controller=segue.destinationViewController;
        FoodDetailsViewController *foodDetails=(FoodDetailsViewController *)controller.topViewController;
        foodDetails.oldFood=food;
        
    }
    
}

@end
