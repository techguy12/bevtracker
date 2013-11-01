//
//  Distributors.h
//  bevtracker
//
//  Created by William Curtis on 7/12/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Distributors : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * salesName;
@property (nonatomic, retain) NSSet *beverage;
@end

@interface Distributors (CoreDataGeneratedAccessors)

- (void)addBeverageObject:(NSManagedObject *)value;
- (void)removeBeverageObject:(NSManagedObject *)value;
- (void)addBeverage:(NSSet *)values;
- (void)removeBeverage:(NSSet *)values;

@end
