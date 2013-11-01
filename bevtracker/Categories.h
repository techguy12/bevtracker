//
//  Categories.h
//  bevtracker
//
//  Created by William Curtis on 7/12/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Categories : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * parentId;

@end
