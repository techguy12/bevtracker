//
//  EditParViewController.h
//  bevtracker
//
//  Created by William Curtis on 7/29/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface EditParViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *parValue;

@property (weak, nonatomic) NSDictionary *selectedBeverage;

@end
