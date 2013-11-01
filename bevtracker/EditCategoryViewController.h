//
//  EditCategoryViewController.h
//  bevtracker
//
//  Created by William Curtis on 7/25/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface EditCategoryViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *editCategoryTextValue;

@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;


@property (weak, nonatomic) NSDictionary *selectedBeverage;

- (NSString *)escape:(NSString *)text;

@end
