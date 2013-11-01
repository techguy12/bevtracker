//
//  AppDelegate.m
//  bevtracker
//
//  Created by William Curtis on 7/10/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize storeURL = _storeURL;
@synthesize venueData = _venueData;
@synthesize operationQueue = _operationQueue;
@synthesize isAuthenticated = _isAuthenticated;
@synthesize tabletLogin = _tabletLogin;
@synthesize venueId = _venueId;
@synthesize venueName = _venueName;
@synthesize currentBeverage = _currentBeverage;

@synthesize distributors = _distributors;

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.

    //if(![self checkAuthenticated]){
    if(YES){
        //NSLog(@"showing login screen");
        //[self showLoginScreen];
    }else{
        //[self startApplicationFlow];
    }
    
    if(!self.isAuthenticated){
        if([self checkAuthenticated]){
            [self loadDataSources];
        }
    }

    
    return YES;
}


- (void) showLoginScreen
{
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
    
    LoginViewController *loginViewController = (LoginViewController *)
        [mainStoryboard instantiateViewControllerWithIdentifier:@"loginView"];
    
    [self.window setRootViewController:loginViewController];
    
    [self.window makeKeyAndVisible];
}

- (void) loadDataSources
{
    NSLog(@"Loading data sources");
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    UIView *thisView = [[UIApplication sharedApplication] keyWindow];
    
    spinner.center = thisView.center;
	
	[spinner startAnimating];
	[[[UIApplication sharedApplication] keyWindow] addSubview:spinner];
    
    // Start your spinner animating
    [spinner startAnimating];
    
    // Create your dispatch queue
    dispatch_queue_t myNewQueue = dispatch_queue_create("my Queue", NULL);
    
    // Dispatch work to your queue
    dispatch_async(myNewQueue, ^{
        
        // Perform long activity here.
        [self fetchData];
        
        // Dispatch work back to the main queue for your UIKit changes
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // update your UI here from your changes.
            NSLog(@"Finished loading data sources");
            [spinner stopAnimating];
            
        });
    });
    
}

- (void) fetchData {
    NSLog(@"fetchData called");
    [self fetchBeveragesFromServer];
    [self fetchSizesFromServer];
    [self fetchCategoriesFromServer];
    [self fetchDistributorsFromServer];
}

- (void)startApplicationFlow{
    _managedObjectContext = [self managedObjectContext];    // Create a new NSOperationQueue instance.
    _operationQueue = [self operationQueue];
    
    // Create a new NSOperation object using the NSInvocationOperation subclass.
    // Tell it to run the counterTask method.
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(fetchBeveragesFromServer)
                                                                              object:nil];
    // Add the operation to the queue and let it to be executed.
    [_operationQueue addOperation:operation];
    // The same story as above, just tell here to execute the colorRotatorTask method.
    operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                     selector:@selector(colorRotatorTask)
                                                       object:nil];
    [_operationQueue addOperation:operation];
}


- (void)saveContext
{
    //NSLog(@"saveContext called");
    NSError *error = nil;
    if(_managedObjectContext != nil){
        if([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error] ){            
            //NSLog(@"Context saved.");
        }else{
            if(![_managedObjectContext hasChanges]){
                //NSLog(@"no changes to managed object context");
            }else{
                NSLog(@"Unresolved error: %@, %@", error, [error userInfo]);
                NSString *errMesg = [NSString stringWithFormat:@"Error deleting old credentials: %@ - %@",error,[error userInfo] ];
                [self displayError:errMesg];
                abort();
            }
        }
    }
}

- (void) displayError : (NSString *) errStr
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                        message:errStr
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

- (NSOperationQueue *)operationQueue
{
    if(_operationQueue != nil){
        return _operationQueue;
    }
    
    _operationQueue = [NSOperationQueue new];
    return _operationQueue;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if(_managedObjectContext != nil){
        //NSLog(@"Context exists, returning existing context");
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if(coordinator != nil){
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    //NSLog(@"Returning new context");
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if(_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"venueData" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"bevtracker.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                [NSNumber numberWithBool:YES],
                             NSInferMappingModelAutomaticallyOption,
                                nil
                            ];
    
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error: &error]){
        NSLog(@"Unresolved error adding persistent store coordinator %@, %@", error, [error userInfo]);
        abort();
    }
    
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    // Create local path for app data
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL) checkAuthenticated
{
    if(_isAuthenticated){
        return YES;
    }
    
    [self authenticate];
    
    return _isAuthenticated;
}

- (void) authenticate
{
    
    NSFetchRequest *fetch = [NSFetchRequest new];
    NSEntityDescription *login = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:self.managedObjectContext];
    [fetch setEntity:login];
    NSError *err = nil;
    
    NSArray *data = [self.managedObjectContext executeFetchRequest:fetch error:&err];
    
    _isAuthenticated = ([data count] > 0) ? YES : NO;

    if(_isAuthenticated){

        NSDictionary *thisVenue = [data objectAtIndex:0];
        self.tabletLogin = [thisVenue valueForKey:@"tabletLogin"];
        self.venueId = [thisVenue valueForKey:@"id"];
        self.venueName = [thisVenue valueForKey:@"name"];
        //NSLog(@"venue id is %@",_tabletLogin);
    }else{
        //NSLog(@"Application has no authentication.");
    }
}

- (void)fetchDistributorsFromServer
{
    NSLog(@"fetchDistributorsFromServer called");

    [self checkAuthenticated];
    
    NSString *searchURL = @"%@/getDistributors?tabletLogin=%@";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:searchURL,APPURL,self.tabletLogin]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSLog(@"%@",url);
    
    //start async connection
    NSOperationQueue *q = [self operationQueue];
    
    [NSURLConnection sendAsynchronousRequest:request queue:q completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        //NSLog(@"Data returned from server!");
        if(!error)
        {
            NSError *err = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            self.distributors = [[json objectForKey:@"distributors"] copy];
        }
     }];
}

- (void) fetchSizesFromServer
{
    NSLog(@"fetchSizesFromServer called");

    [self checkAuthenticated];
    
    NSString *searchURL = @"%@/getSizes?tabletLogin=%@";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:searchURL,APPURL,self.tabletLogin]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    //start async connection
    NSOperationQueue *q = [self operationQueue];
    
    [NSURLConnection sendAsynchronousRequest:request queue:q completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        //NSLog(@"Data returned from server!");
        if(!error)
        {
            NSError *err = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            self.sizes = [[json objectForKey:@"sizes"] copy];
        }
    }];
}

- (void)fetchCategoriesFromServer
{
    NSLog(@"fetchCategoriesFromServer called");
    
    [self checkAuthenticated];
    
    NSString *searchURL = @"%@/getCategories?tabletLogin=%@";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:searchURL,APPURL,self.tabletLogin]];
    
    NSLog(@"%@",url);
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    //start async connection
    NSOperationQueue *q = [self operationQueue];
    
    [NSURLConnection sendAsynchronousRequest:request queue:q completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(!error)
        {
            NSError *err = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            self.categories = [[json objectForKey:@"categories"] copy];
            NSLog(@"fetchData categories: %@",self.categories);
        }
    }];
}

- (void)fetchBeveragesFromServer
{
    //NSLog(@"fetchBeveragesFromServer called");
    
    [self checkAuthenticated];
    [self deleteBeverages];
    
    NSString *searchURL = @"%@/getBeverageList?tabletLogin=%@";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:searchURL,APPURL,self.tabletLogin]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSLog(@"%@",url);
    
    //start async connection
    NSOperationQueue *q = [self operationQueue];

    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    UIView *thisView = [[UIApplication sharedApplication] keyWindow];
    
    spinner.center = thisView.center;
	
	[spinner startAnimating];
	[[[UIApplication sharedApplication] keyWindow] addSubview:spinner];
    
    // Start your spinner animating
    [spinner startAnimating];
    
    // Create your dispatch queue
    dispatch_queue_t myNewQueue = dispatch_queue_create("my Queue", NULL);
    
    // Dispatch work to your queue
    dispatch_async(myNewQueue, ^{
    
        [NSURLConnection sendAsynchronousRequest:request queue:q completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if(!error)
            {
                NSLog(@"*** JSON Data returned from server!");

                NSError *err = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                _searchResults = [[json objectForKey:@"beverages"] copy];
                self.venueData = (NSMutableDictionary *) json;
                
                NSLog(@"class of venueData: %@",[self.venueData class]);
                /*
                NSManagedObjectContext *context = [self managedObjectContext];
                
                for(id beverage in _searchResults){
                    // Save the beverage information
                 
                    Beverages *beverageEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Beverages" inManagedObjectContext:context];
                    
                    NSNumber *beverageId = [(NSDictionary *)beverage objectForKey:@"id"];
                    [beverageEntity setValue:[NSNumber numberWithInt:[beverageId intValue]] forKey:@"id"];
                    
                    NSString *beverageName = [(NSDictionary *)beverage objectForKey:@"name"];
                    beverageEntity.name = beverageName;
                    
                    NSString *beverageType = [(NSDictionary *)beverage objectForKey:@"type"];
                    beverageEntity.type = beverageType;
                    
                    NSString *beverageVintage = NULL_TO_NIL([(NSDictionary *)beverage objectForKey:@"vintage"]);
                    beverageEntity.vintage = (beverageVintage) ? beverageVintage : @"";
                    
                    NSString *beverageVarietal = [(NSDictionary *)beverage objectForKey:@"varietal"];
                    beverageEntity.varietal = beverageVarietal;
                    
                    [self saveContext];
                }
                 */
            
            /*
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self setLoadingView];
                [self getBeveragesFromCoreData];
                [self removeLoadingView];
            }];
            */
            
            }
        }];
        
        // Dispatch work back to the main queue for your UIKit changes
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // update your UI here from your changes.
            //NSLog(@"Finished loading data sources");
            [spinner stopAnimating];
            
        });
    });

    
    //NSLog(@"Beverages loaded from server.");
    
}


- (void)deleteBeverages{
    //NSLog(@"Deleting old beverages");
    
    // Delete previous venue information
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest * oldBeverages = [NSFetchRequest new];
    [oldBeverages setEntity:[NSEntityDescription entityForName:@"Beverages" inManagedObjectContext:context]];
    [oldBeverages setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * beverages = [context executeFetchRequest:oldBeverages error:&error];
    
    for (NSManagedObject * beverage in beverages) {
        [context deleteObject:beverage];
    }
    NSError *saveError = nil;
    [context save:&saveError];
    
    NSLog(@"Deletions complete");
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end