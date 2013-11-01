//
//  CustomPickerViewController.m
//  bevtracker
//
//  Created by William Curtis on 7/24/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import "CustomPickerViewController.h"

@interface CustomPickerViewController ()

@end

@implementation CustomPickerViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIPickerViewDelegate methods

- (NSString*)pickerView:(UIPickerView*)pv titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [NSString stringWithFormat:@"%d",row];
}

#pragma mark UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pv
{
	return 3;
}

- (NSInteger)pickerView:(UIPickerView*)pv numberOfRowsInComponent:(NSInteger)component
{
	return 10;
}

@end
