//
//  ViewController.h
//  bevtracker
//
//  Created by William Curtis on 7/10/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LoginViewController.h"
#import "BeverageListViewController.h"
#import "Beverages.h"

@interface ViewController : UIViewController{
    NSNumber *venueId;
    NSString *venueName;
    BOOL isAuthenticated;
    Beverages *beverage;
}


@end