//
//  BeverageEditViewController.m
//  bevtracker
//
//  Created by William Curtis on 7/23/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import "BeverageEditViewController.h"

@interface BeverageEditViewController ()

@end

@implementation BeverageEditViewController

@synthesize dataArray;

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
    NSLog(@"BeverageEditViewController.h did load");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)editBeverageUpdateButtonClicked:(id)sender {
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    /*
    BeverageViewController *destination = [segue destinationViewController];
    destination.selectedBeverage = (NSDictionary *) beverage;
    */
    
    NSLog(@"Sender is %@",sender);
    
}

@end
