//
//  BeverageCategories.h
//  bevtracker
//
//  Created by William Curtis on 7/12/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeverageCategories;

@interface BeverageCategories : NSManagedObject

@property (nonatomic, retain) NSManagedObject *beverage;
@property (nonatomic, retain) BeverageCategories *beverageCategory;

@end
