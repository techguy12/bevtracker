//
//  EditCostViewController.m
//  bevtracker
//
//  Created by William Curtis on 7/29/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import "EditCostViewController.h"

@interface EditCostViewController ()

@end

@implementation EditCostViewController

@synthesize selectedBeverage = _selectedBeverage;


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
    NSLog(@"Beverage: %@",self.selectedBeverage);
    
    self.costValue.keyboardType = UIKeyboardTypeDecimalPad;
    self.costValue.text = [self.selectedBeverage valueForKey:@"costUnit"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateCostClick:(id)sender {
    [self updateCost];
}

- (void) updateCost {
    //NSLog(@"Updating par value");
    
    NSString *searchURL = @"%@/updateCostValue?costUnit=%@&venueDrinkId=%@";
     NSString *updateURL = [NSString stringWithFormat:searchURL,APPURL,self.costValue.text,[self.selectedBeverage valueForKey:@"id"]];
    
    NSLog(@"updating par URL: %@",updateURL);
    
    //create NSURL
    NSURL *url = [NSURL URLWithString:updateURL];
    
    //create NSURLRequest
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    //NSLog(@"%@",response);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
