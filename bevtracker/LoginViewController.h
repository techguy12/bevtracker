//
//  LoginViewController.h
//  bevtracker
//
//  Created by William Curtis on 7/10/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewController.h"
#import "AppDelegate.h"
#import "Venue.h"

@interface LoginViewController : UIViewController <NSURLConnectionDataDelegate>


@property (weak, nonatomic) IBOutlet UITextField *loginVenue;

@property (weak, nonatomic) IBOutlet UITextField *loginEmail;
@property (weak, nonatomic) IBOutlet UITextField *loginPassword;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;

@property (weak, nonatomic) AppDelegate *delegate;

@property (weak, nonatomic) IBOutlet UIButton *loginButtonClicked;



@end
