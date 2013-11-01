//
//  EditSizeViewController.m
//  bevtracker
//
//  Created by William Curtis on 7/26/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import "EditSizeViewController.h"

@interface EditSizeViewController (){
    NSUInteger dcount;
}

@end

@implementation EditSizeViewController

@synthesize editSizeTextValue = _editSizeTextValue;

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
    NSLog(@"Selected beverage: %@",self.selectedBeverage);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"viewDidAppear called");
    
    if (delegate.sizes.count > 0)
    {
        [self.sizePicker selectRow:0 inComponent:0 animated:YES];
    }
}

-(void)keyboardWillShow:(NSNotification *)note {
    NSLog(@"keyboardWillShow");
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self addNewBeverageSize];
    return YES;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //NSLog(@"didSelectRow called");
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
    NSLog(@"Getting item at index %u",row);
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSString *returnStr = @"";
    
    if (pickerView == self.sizePicker && delegate.sizes.count > 0)
    {
        NSLog(@"setting returnStr for size");
        returnStr = [[delegate.sizes objectAtIndex:row] objectForKey:@"name"];
    }else{
        returnStr = @"";
    }
    
    return returnStr;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (pickerView == self.sizePicker)
    {
        dcount = [delegate.sizes count];
        
        if(dcount){
            self.sizePicker.hidden = NO;
            self.selectButton.hidden = NO;
            return [delegate.sizes count];
        }else{
            self.sizePicker.hidden = YES;
            self.selectButton.hidden = YES;
        }
    }
    
    return 1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSString *)escape:(NSString *)text
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (__bridge CFStringRef)text, NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8);
}

- (IBAction)updateBeverageSizeClick:(id)sender {
    [self updateBeverageSize];
}

- (void)addNewBeverageSize {
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSString *searchURL = @"%@/addSize?venueId=%@&name=%@&venueDrinkId=%@";
    NSString *newName = [self escape:self.editSizeTextValue.text];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:searchURL,APPURL,delegate.venueId,newName,[self.selectedBeverage valueForKey:@"id"]]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSLog(@"addNewBeverageSize URL: %@",url);
    
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    NSLog(@"%@",response);
    
    [delegate fetchSizesFromServer];
    [self.sizePicker reloadAllComponents];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateBeverageSize {
    

    NSLog(@"Updating size");
    NSInteger row;
    NSString *pickedSize;
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    
    row = [self.sizePicker selectedRowInComponent:0];
    NSLog(@"Sizes is %@",delegate.sizes);
    NSLog(@"Row is %u",row);
    
    pickedSize = [delegate.sizes objectAtIndex:row];
    
    NSString *searchURL = @"%@/updateBeverageSize?sizeId=%@&venueDrinkId=%@";
    
    //create NSURL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:searchURL,APPURL,[pickedSize valueForKey:@"id"],[self.selectedBeverage valueForKey:@"id"]]];
    
    NSLog(@"updateBeverageSize URL: %@",url);
    
    //create NSURLRequest
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    //NSLog(@"%@",response);
    [self.sizePicker reloadAllComponents];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
