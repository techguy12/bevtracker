//
//  EditCategoryViewController.m
//  bevtracker
//
//  Created by William Curtis on 7/25/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import "EditCategoryViewController.h"

@interface EditCategoryViewController (){
    NSUInteger dcount;
}

@end

@implementation EditCategoryViewController

@synthesize categoryPicker = _categoryPicker;
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
    NSLog(@"EditCategoryViewController didLoad");
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];

    NSLog(@"Categories: %@",delegate.categories);
    
    //NSLog(@"Starting up with beverage %@",self.selectedBeverage);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (delegate.categories.count > 0)
    {
        [self.categoryPicker selectRow:0 inComponent:0 animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self addNewBeverageCategory:textField.text];
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
    
    //NSLog(@"Keyboard Height: %f Width: %f", kbSize.height, kbSize.width);
    
    // move the view up by 30 pts
    CGRect frame = self.view.frame;
    frame.origin.y = -kbSize.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

-(void)keyboardWillHide:(NSNotification *)note {
    NSLog(@"keyboardWillHide");
    // move the view back to the origin
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 300;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSString *returnStr = @"";
    if (pickerView == self.categoryPicker && delegate.categories.count > 0)
    {
        returnStr = [[delegate.categories objectAtIndex:row] objectForKey:@"name"];
    }else{
        returnStr = @"";
    }
    
    return returnStr;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];

    if (pickerView == self.categoryPicker)
    {
        dcount = [delegate.categories count];
        
        if(dcount){
            self.categoryPicker.hidden = NO;
            return [delegate.categories count];
        }else{
            self.categoryPicker.hidden = YES;
        }
    }
    
    return 1;
}

- (NSString *)escape:(NSString *)text
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (__bridge CFStringRef)text, NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)addNewBeverageCategory:(id)sender {

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSString *searchURL = @"%@/addCategory?venueId=%@&categoryName=%@&venueDrinkId=%@";
    NSString *newName = [self escape:self.editCategoryTextValue.text];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:searchURL,APPURL,delegate.venueId,newName,[self.selectedBeverage objectForKey:@"id"]]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSLog(@"url: %@",url);
    
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    [delegate fetchCategoriesFromServer];
    [self.categoryPicker reloadAllComponents];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)updateBeverageCategory:(id)sender {
    NSInteger row;
    NSString *pickedCategory;
    
    row = [self.categoryPicker selectedRowInComponent:0];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    pickedCategory = [delegate.categories objectAtIndex:row];
    
    NSString *searchURL = @"%@/updateBeverageCategory?categoryId=%@&venueDrinkId=%@";
    
    //create NSURL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:searchURL,APPURL,[pickedCategory valueForKey:@"id"],[self.selectedBeverage valueForKey:@"id"]]];
    
    //create NSURLRequest
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    [self.categoryPicker reloadAllComponents];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
