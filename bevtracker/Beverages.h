//
//  Beverages.h
//  bevtracker
//
//  Created by William Curtis on 7/12/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeverageCategories, Distributors;

@interface Beverages : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * varietal;
@property (nonatomic, retain) NSString * vintage;
@property (nonatomic, retain) Distributors *distributor;
@property (nonatomic, retain) BeverageCategories *beverageCategory;

@end
