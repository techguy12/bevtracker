//
//  mainViewController.m
//  bevtracker
//
//  Created by William Curtis on 7/19/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import "mainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize isAuthenticated = _isAuthenticated;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"mainViewController init called");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Well, we're here");
    
	
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    
    _isAuthenticated = YES;
    
    if(_isAuthenticated){
        //[self showHomeScreen];
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        self.venueName.text = delegate.venueName;
        self.venueName.hidden = NO;
    }else{
        self.venueName.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showHomeScreen{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"homeScreen"];
    
    [vc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:vc animated:NO completion:nil];
}

- (IBAction)showInventory:(id)sender {
}

- (IBAction)showSettings:(id)sender {
}

- (IBAction)showHelp:(id)sender {
}

@end
