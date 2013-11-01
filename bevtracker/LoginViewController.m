//
//  LoginViewController.m
//  bevtracker
//
//  Created by William Curtis on 7/10/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "mainViewController.h"

@implementation LoginViewController
{
    NSArray *loginReply;
}

@synthesize loginVenue = _loginVenue;
@synthesize connection = _connection;
@synthesize receivedData = _receivedData;
@synthesize delegate = _delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"Init'ing LoginViewController");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self verifyCredentials];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self authenticate];
    [textField resignFirstResponder];
    return YES;
}

- (void)selectionWillChange:(id <UITextInput>)textInput
{
    
}

- (NSString *)escape:(NSString *)text
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (__bridge CFStringRef)text, NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8);
}

- (void)authenticate{
    NSString *searchURL = @"%@/authenticate?loginVenue=%@&loginEmail=%@&loginPassword=%@";
    
    //create NSURL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:searchURL,APPURL,[self escape:self.loginVenue.text],self.loginEmail.text,self.loginPassword.text]];
    
    //create NSURLRequest
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    //start async connection
    NSOperationQueue *q = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request queue:q completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(!error)
        {
            NSError *err = nil;
            NSDictionary *jsonReply = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];

            loginReply = [[jsonReply objectForKey:@"venue"] copy];
                        
            BOOL errorStatus = [[jsonReply objectForKey:@"errors"] boolValue];

            if(errorStatus){
                // Login failed, display an alert
                NSString *errorCode = [[jsonReply objectForKey:@"error_code"] copy];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                                    message:errorCode
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                          otherButtonTitles:@"OK", nil];
                [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            }else{
                
                // Get our working environment
                
                AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                NSManagedObjectContext *context = delegate.managedObjectContext;
               
                // Delete previous venue information
                
                NSFetchRequest * previousVenues = [[NSFetchRequest alloc] init];
                [previousVenues setEntity:[NSEntityDescription entityForName:@"Venue" inManagedObjectContext:context]];
                [previousVenues setIncludesPropertyValues:NO]; //only fetch the managedObjectID
                
                NSError * error = nil;
                NSArray * venues = [context executeFetchRequest:previousVenues error:&error];
                                
                for (NSManagedObject * venue in venues) {
                    [context deleteObject:venue];
                }
                [delegate saveContext];
                
                delegate.isAuthenticated = NO;

                // Save the venue information

                NSLog(@"Saving new venue information");

                Venue *venueEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Venue" inManagedObjectContext:context];
                
                NSString *venueName = [(NSDictionary *)loginReply objectForKey:@"name"];
                NSNumber *venueId = [(NSDictionary *)loginReply objectForKey:@"id"];
                NSString *tabletLogin = [(NSDictionary *)loginReply objectForKey:@"tablet_login"];

                [venueEntity setValue:[NSNumber numberWithInt:[venueId intValue]] forKey:@"id"];
                venueEntity.name = venueName;
                venueEntity.tabletLogin = tabletLogin;
                
                [delegate saveContext];
                [delegate authenticate];

                [delegate loadDataSources];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];

}

- (void) verifyCredentials
{
    NSLog(@"verifyCredentials called, checking cached authentication.");
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetch = [NSFetchRequest new];
    NSEntityDescription *login = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:delegate.managedObjectContext];
    [fetch setEntity:login];
    NSError *err = nil;
    
    NSArray *data = [delegate.managedObjectContext executeFetchRequest:fetch error:&err];
    
    if(err){
        NSLog(@"Error getting credentials: %@ %@",err,[err userInfo]);
        abort();
    }
    
    if([data count] > 0){
        NSDictionary *thisVenue = [data objectAtIndex:0];
        self.loginVenue.text = [thisVenue valueForKey:@"tabletLogin"];
    }else{
        self.loginVenue.text = @"Please log in under settings.";
    }
}

@end
