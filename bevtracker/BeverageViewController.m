//
//  BeverageViewController.m
//  bevtracker
//
//  Created by William Curtis on 7/10/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import "BeverageViewController.h"

@interface BeverageViewController ()

@end

@implementation BeverageViewController

@synthesize beverageViewName = _beverageViewName;
@synthesize selectedBeverage = _selectedBeverage;
@synthesize thisBeverage = _thisBeverage;

@synthesize categoryButton = _categoryButton;
@synthesize sizeButton = _sizeButton;
@synthesize costButton = _costButton;
@synthesize distributorButton = _distributorButton;
@synthesize parButton = _parButton;
@synthesize onHandValue = _onHandValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    // -- EDIT Added the allocation of a UIGestureRecognizer -- //

    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPreviousView:)];
    swipeRight.numberOfTouchesRequired = 1;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [self loadBeverage];
    
    [self setButtonText];

}

- (void) loadBeverage {
    
    NSString *venueDrinkId = [_selectedBeverage objectForKey:@"id"];
    
    NSString *searchURL = @"%@/getBeverage?venueDrinkId=%@";
    NSString *requestURL = [NSString stringWithFormat:searchURL,APPURL,venueDrinkId];
    NSURL *url = [NSURL URLWithString:requestURL];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&err];
    self.thisBeverage = [[json objectForKey:@"beverage"] copy];
}

- (void) setButtonText {
    
    _beverageViewName.text = [_thisBeverage objectForKey:@"name"];
    
    NSString *catName = ([[_thisBeverage objectForKey:@"category"] isKindOfClass:[NSNull class]]) ? @"Not set" :[_thisBeverage objectForKey:@"category"];
    
    [_categoryButton setTitle:catName forState:UIControlStateNormal];
    
    NSString *sizeName = ([[_thisBeverage objectForKey:@"size"] isKindOfClass:[NSNull class]]) ? @"Not set" :[_thisBeverage objectForKey:@"size"];
    
    [_sizeButton setTitle:sizeName forState:UIControlStateNormal];

    NSString *distName = ([[_thisBeverage objectForKey:@"distributor"] isKindOfClass:[NSNull class]]) ? @"Not set" :[_thisBeverage objectForKey:@"distributor"];
    
    [_distributorButton setTitle:distName forState:UIControlStateNormal];
    
    [_parButton setTitle:[_thisBeverage objectForKey:@"par"] forState:UIControlStateNormal];

    [_costButton setTitle:[_thisBeverage objectForKey:@"costUnit"] forState:UIControlStateNormal];

    _onHandValue.text = [_thisBeverage objectForKey:@"onHand"];

}



- (void)gotoPreviousView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"segueToEditCategory"])
    {
        EditCategoryViewController *vc = [segue destinationViewController];
        vc.selectedBeverage = self.thisBeverage;
    }else if([[segue identifier] isEqualToString:@"segueToEditDistributor"]){
        EditDistributorViewController *vc = [segue destinationViewController];
        vc.selectedBeverage = self.thisBeverage;
    }else if([[segue identifier] isEqualToString:@"segueToEditPar"]){
        EditParViewController *vc = [segue destinationViewController];
        vc.selectedBeverage = self.thisBeverage;
    }else if([[segue identifier] isEqualToString:@"segueToEditCost"]){
        EditCostViewController *vc = [segue destinationViewController];
        vc.selectedBeverage = self.thisBeverage;
    }else if([[segue identifier] isEqualToString:@"segueToEditSize"]){
        EditSizeViewController *vc = [segue destinationViewController];
        vc.selectedBeverage = self.thisBeverage;
    }else{
        NSLog(@"Segue not identified");
    }
    
    NSLog(@"Segue set");
    
}
- (IBAction)addProduct:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSString *addAmount = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
    addAmount = [addAmount stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSLog(@"addAmount: %@",addAmount);
    [self updateInventoryCount:[addAmount intValue]];
}

- (IBAction) deleteProduct:(id)sender {
    if([self.onHandValue.text isEqualToString:@"0"]){
        
        return;
    }
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSString *deleteAmount = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
    signed int myInt = [deleteAmount intValue];
    [self updateInventoryCount:myInt];
}

- (void) updateInventoryCount:(signed int)inventoryChange {
    NSString *beverageId = ([[_thisBeverage objectForKey:@"iBeverageId"] isKindOfClass:[NSNull class]]) ? @"" :[_thisBeverage objectForKey:@"iBeverageId"];
    
    NSString *venueDrinkId = [_thisBeverage objectForKey:@"id"];

    NSString *searchURL = @"%@/addProduct?beverageId=%@&venueDrinkId=%@&amtChange=%d";
    NSString *requestURL = [NSString stringWithFormat:searchURL,APPURL,beverageId,venueDrinkId,inventoryChange];
    NSURL *url = [NSURL URLWithString:requestURL];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSLog(@"Sending searchURL %@",url);
    
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&err];
    self.onHandValue.text = [[json objectForKey:@"onHand"] copy];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    [delegate.currentBeverage setValue:self.onHandValue.text forKey:@"onHand"];
}
@end