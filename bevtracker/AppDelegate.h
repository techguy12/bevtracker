//
//  AppDelegate.h
//  bevtracker
//
//  Created by William Curtis on 7/10/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Beverages.h"
#import "Distributors.h"
#import "Venue.h"
//#import "LoginViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

#define APPURL @"http://app.uncorkd.biz/inventory"
//#define APPURL @"http://98.206.138.220/inventory"

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSOperationQueue *operationQueue;
@property (nonatomic,retain,readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain,readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,retain,readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,retain,readonly) NSURL *storeURL;
@property (nonatomic,retain) NSMutableDictionary *venueData;
@property (nonatomic) BOOL isAuthenticated;
//@property (nonatomic, retain) NSArray *searchResults; // API returned results
@property (nonatomic, retain) NSMutableArray *searchResults; // API returned results

@property (nonatomic,strong) NSArray *distributors;
@property (nonatomic,strong) NSArray *categories;
@property (nonatomic,strong) NSArray *sizes;
@property (nonatomic,strong) NSArray *costUnits;
@property (nonatomic,strong) NSString *tabletLogin;
@property (nonatomic,strong) NSNumber *venueId;
@property (nonatomic,strong) NSString *venueName;
@property (nonatomic,strong) NSMutableData *currentBeverage;

- (void) fetchBeveragesFromServer;
- (void) fetchDistributorsFromServer;
- (void) fetchCategoriesFromServer;
- (void) fetchSizesFromServer;
- (void) authenticate;

- (void) saveContext;

- (NSManagedObjectContext *) managedObjectContext;
- (NSManagedObjectModel *) managedObjectModel;
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator;
- (NSURL *) applicationDocumentsDirectory;
- (void) startApplicationFlow;
- (void) displayError:(NSString *)errStr;
- (void) loadDataSources;


@end
