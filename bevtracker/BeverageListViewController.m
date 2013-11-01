//
//  BeverageListViewController.m
//  bevtracker
//
//  Created by William Curtis on 7/10/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import "BeverageListViewController.h"

@interface BeverageListViewController ()

@end

@implementation BeverageListViewController

@synthesize beverageData = _beverageData;
@synthesize activityView = _activityView;

- (id)initWithStyle:(UITableViewStyle)style
{
    //self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad called for BeverageListViewController");

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
        [self performSelector:@selector(getBeveragesFromCoreData)];
        dispatch_async(dispatch_get_main_queue(),
            ^{
                [self.tableView reloadData];
            });
        });
}

-(void)viewWillAppear:(BOOL)animated
{
}

-(void)setLoadingView{
    NSLog(@"setLoadingView");
    _activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    _activityView.tag = 999;
    
    _activityView.center=self.view.center;

    [_activityView startAnimating];

    [self.view addSubview:_activityView];
}

-(void)removeLoadingView{
    NSLog(@"removing activityview");
    [_activityView removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated
{
    //[self removeLoadingView];
}

- (void) loadBeverages{
    
    //[self setLoadingView];
    //[self getBeveragesFromCoreData];
    /*
     AppDelegate *delegate = [[UIApplication sharedApplication] delegate];

    // Create a new NSOperationQueue instance.
    NSOperationQueue *operationQueue = [delegate operationQueue];
    
    // Create a new NSOperation object using the NSInvocationOperation subclass.
    // Tell it to run the getBeveragesFromCoreData method.
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(getBeveragesFromCoreData)
                                                                              object:nil];
    // Add the operation to the queue and let it to be executed.
    [operationQueue addOperation:operation];
    
    operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(removeLoadingView)
                                                                              object:nil];
    // Add the operation to the queue and let it to be executed.
    [operationQueue addOperation:operation];
    */
    
//    dispatch_queue_t beverageQueue = dispatch_queue_create("Beverage Queue",NULL);
//    
//    dispatch_sync(beverageQueue, ^{
//        [self getBeveragesFromCoreData];
//        [self.tableView reloadData];
//        [self removeLoadingView];
//    });

}

- (void) getBeveragesFromCoreData{
    NSLog(@"getBeveragesFromCoreData called");

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    _beverageData = [[delegate.venueData objectForKey:@"beverages"] copy];
    
    NSLog(@"Beverages fetched successfully");
}

- (void) getBeveragesFromJSON{
    NSLog(@"getBeveragesFromJSON called");

    
}

- (void) reloadTable{
    NSLog(@"reloading table");
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    //NSLog(@"%lu rows returned",(unsigned long)_beverageData.count);
    return _beverageData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRowAtIndexPath called ");
    
    static NSString *CellIdentifier = @"beverageCell";
    
    NSDictionary *myBeverage = [_beverageData objectAtIndex:indexPath.row];

    //NSLog(@"myBeverage: %@",myBeverage);
    
    BeverageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSString *beverageName = [myBeverage objectForKey:@"name"];
    
    NSData *nameData = [beverageName dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *asciiName = [[NSString alloc] initWithData:nameData encoding:NSUTF8StringEncoding];
    
    NSString *vintage = [myBeverage objectForKey:@"vintage"];
    
    NSString *varietal = [myBeverage objectForKey:@"varietal"];
    
    NSData *varietalData = [varietal dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *varietalName = [[NSString alloc] initWithData:varietalData encoding:NSUTF8StringEncoding];
    
    NSString *type = [myBeverage objectForKey:@"type"];
    
    NSRange sub = [asciiName rangeOfString:varietalName];
    
    beverageName = (sub.length == 0) ? [NSString stringWithFormat:@"%@ - %@",beverageName,varietal] : beverageName;
    
    vintage = ([vintage isEqual: [NSNull null]] || ![type isEqual: @"wine"]) ? @"" : [NSString stringWithFormat:@"%@ ",vintage];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@%@",vintage,beverageName];
    
    cell.onHandLabel.text = [myBeverage objectForKey:@"onHand"];
    
    NSString *container = [myBeverage objectForKey:@"size"];
    cell.containerLabel.text = ([container isEqual: [NSNull null]]) ? @"" : [NSString stringWithFormat:@"%@ ",container];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITableViewCell *cell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    self.beverage = [_beverageData objectAtIndex:indexPath.row];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.currentBeverage = [_beverageData objectAtIndex:indexPath.row];
    
    BeverageViewController *destination = [segue destinationViewController];
    destination.selectedBeverage = (NSDictionary *) self.beverage;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
}

@end
