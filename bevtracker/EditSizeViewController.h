//
//  EditSizeViewController.h
//  bevtracker
//
//  Created by William Curtis on 7/26/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface EditSizeViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *sizePicker;

@property (weak, nonatomic) IBOutlet UITextField *editSizeTextValue;

@property (weak, nonatomic) NSDictionary *selectedBeverage;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end
