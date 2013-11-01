//
//  BeverageEditViewController.h
//  bevtracker
//
//  Created by William Curtis on 7/23/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Beverages.h"





#import "EditCategoryViewController.h"
#import "EditDistributorViewController.h"
#import "EditSizeViewController.h"


@interface BeverageEditViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic, retain) Beverages *beverage;

@end
