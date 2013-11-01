//
//  mainViewController.h
//  bevtracker
//
//  Created by William Curtis on 7/19/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeverageListViewController.h"

@interface MainViewController : UIViewController{
    NSOperationQueue *operationQueue;
}

@property BOOL isAuthenticated;

@property (weak, nonatomic) IBOutlet UILabel *venueName;

@end
