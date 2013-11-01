//
//  ViewController.m
//  bevtracker
//
//  Created by William Curtis on 7/10/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController {
}

- (void)viewDidLoad
{
    NSLog(@"ViewController loaded");
    [super viewDidLoad];
	    
}

- (void)viewDidAppear:(BOOL)animated
{
    isAuthenticated = YES;
    
    
    // If not logged in, set the view to the login
    
    if(!isAuthenticated)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                     bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginView"];
        
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    }else{
        
        //[self showBeverageList];
        
    }
}



- (void) showHomeScreen{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"beverageListView"];
    
    [vc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:vc animated:YES completion:nil];    
}

- (void) showBeverageList{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"beverageListView"];
    
    [vc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
