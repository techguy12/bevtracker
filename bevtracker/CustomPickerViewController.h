//
//  CustomPickerViewController.h
//  bevtracker
//
//  Created by William Curtis on 7/24/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	UIPickerView* picker;
}

@end
