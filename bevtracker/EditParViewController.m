//
//  EditParViewController.m
//  bevtracker
//
//  Created by William Curtis on 7/29/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import "EditParViewController.h"

@interface EditParViewController ()

@end

@implementation EditParViewController

@synthesize selectedBeverage = _selectedBeverage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear, beverage: %@",self.selectedBeverage);
    self.parValue.text = [self.selectedBeverage valueForKey:@"par"];
    self.parValue.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)escape:(NSString *)text
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (__bridge CFStringRef)text, NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self fetchUpdateParValue];
    return YES;
}


- (IBAction)updateParValue:(id)sender {
    [self fetchUpdateParValue];
}

- (void) fetchUpdateParValue {
    //NSLog(@"Updating par value");
    
    NSString *searchURL = @"%@/updateParValue?par=%@&venueDrinkId=%@";
    
    //NSLog(@"form par value: %@",self.parValue.text);
    
    NSString *updateURL = [NSString stringWithFormat:searchURL,APPURL,self.parValue.text,[self.selectedBeverage valueForKey:@"id"]];

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
