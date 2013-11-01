//
//  BeverageViewController.h
//  bevtracker
//
//  Created by William Curtis on 7/10/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Beverages.h"
#import "LoginViewController.h"
#import "BeverageListViewController.h"
#import "EditCategoryViewController.h"
#import "EditDistributorViewController.h"
#import "EditParViewController.h"
#import "EditCostViewController.h"
#import "EditSizeViewController.h"

@interface BeverageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *beverageViewName;

@property (nonatomic,retain) NSDictionary *selectedBeverage;

@property (nonatomic,retain) NSDictionary *thisBeverage;

@property (weak, nonatomic) IBOutlet UIButton *categoryButton;

@property (weak, nonatomic) IBOutlet UIButton *sizeButton;

@property (weak, nonatomic) IBOutlet UIButton *costButton;

@property (weak, nonatomic) IBOutlet UIButton *distributorButton;

@property (weak, nonatomic) IBOutlet UIButton *parButton;

@property (weak, nonatomic) IBOutlet UILabel *onHandValue;

@property (weak, nonatomic) IBOutlet UISegmentedControl *addProductSegment;

@property (weak, nonatomic) IBOutlet UISegmentedControl *deleteProductSegment;

@property (nonatomic,strong) NSOperationQueue *operationQueue;

@end

