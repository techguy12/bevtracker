//
//  BeverageListViewController.h
//  bevtracker
//
//  Created by William Curtis on 7/10/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import "BeverageCell.h"
#import "Beverages.h"
#import "BeverageCategories.h"
#import "BeverageViewController.h"
#import "Venue.h"

@interface BeverageListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate>
    
@property NSMutableArray *beverageData; // Core Data returned results
@property (retain, nonatomic) NSArray *beverageList;

@property (retain, nonatomic) AppDelegate *delegate;

@property (retain, nonatomic) NSObject *beverage;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) UIActivityIndicatorView *activityView;

@property (weak, nonatomic) IBOutlet UISearchBar *beverageSearchBar;

@end
