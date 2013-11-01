//
//  EditDistributorViewController.m
//  bevtracker
//
//  Created by William Curtis on 7/26/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import "EditDistributorViewController.h"

@interface EditDistributorViewController (){
    NSUInteger dcount;
}

@end

@implementation EditDistributorViewController

@synthesize distributorPicker = _distributorPicker;
@synthesize selectedBeverage = _selectedBeverage;
@synthesize setBeverageButton = _setBeverageButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"Initting EditDistributorViewController");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    NSLog(@"Selected beverage: %@",self.selectedBeverage);
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad EditDistributorViewController");
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"viewDidAppear called");
    
    if (delegate.distributors.count > 0)
    {
        [self.distributorPicker selectRow:0 inComponent:0 animated:YES];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"didSelectRow called");
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 300;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self addNewBeverageDistributor:textField.text];
    return YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)keyboardWillShow:(NSNotification *)note {
    //NSLog(@"keyboardWillShow");
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect frame = self.view.frame;
    frame.origin.y = -kbSize.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

-(void)keyboardWillHide:(NSNotification *)note {
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

- (NSString *)escape:(NSString *)text
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (__bridge CFStringRef)text, NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8);
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"Getting item at index %u",row);
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSString *returnStr = @"";
    
    if (pickerView == self.distributorPicker && delegate.distributors.count > 0)
    {
        NSLog(@"setting returnStr for distributor");
        returnStr = [[delegate.distributors objectAtIndex:row] objectForKey:@"name"];
    }else{
        returnStr = @"";
    }
    
    return returnStr;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (pickerView == self.distributorPicker)
    {
        dcount = [delegate.distributors count];
        
        if(dcount){
            self.distributorPicker.hidden = NO;
            self.setBeverageButton.hidden = NO;
            return [delegate.distributors count];
        }else{
            self.distributorPicker.hidden = YES;
            self.setBeverageButton.hidden = YES;
        }
    }
    
    return 1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)addNewBeverageDistributor:(id)sender {
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSString *searchURL = @"%@/addDistributor?venueId=%@&distributorName=%@&venueDrinkId=%@";
    NSString *newName = [self escape:self.editDistributorTextValue.text];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:searchURL,APPURL,delegate.venueId,newName,[self.selectedBeverage objectForKey:@"id"]]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    NSLog(@"%@",url);
    [delegate fetchDistributorsFromServer];
    [self.distributorPicker reloadAllComponents];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateBeverageDistributor:(id)sender {
    NSLog(@"Updating distributor");
    NSInteger row;
    NSString *pickedDistributor;

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    
    row = [self.distributorPicker selectedRowInComponent:0];
    NSLog(@"Distributors is %@",delegate.distributors);
    NSLog(@"Row is %u",row);

    pickedDistributor = [delegate.distributors objectAtIndex:row];
    
    NSString *searchURL = @"%@/updateBeverageDistributor?distributorId=%@&venueDrinkId=%@";

    //create NSURL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:searchURL,APPURL,[pickedDistributor valueForKey:@"id"],[self.selectedBeverage valueForKey:@"id"]]];

    NSLog(@"updateBeverageDistbitutor URL: %@",url);
    
    //create NSURLRequest
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    NSLog(@"%@",response);
    [delegate fetchDistributorsFromServer];
    [self.distributorPicker reloadAllComponents];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
