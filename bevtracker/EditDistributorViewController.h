//
//  EditDistributorViewController.h
//  bevtracker
//
//  Created by William Curtis on 7/26/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface EditDistributorViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *distributorPicker;

@property (weak, nonatomic) IBOutlet UITextField *editDistributorTextValue;

@property (weak, nonatomic) IBOutlet UIButton *setBeverageButton;

@property (weak, nonatomic) NSDictionary *selectedBeverage;

- (NSString *)escape:(NSString *)text;

@end
