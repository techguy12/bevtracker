//
//  BeverageCell.h
//  bevtracker
//
//  Created by William Curtis on 7/16/13.
//  Copyright (c) 2013 William Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeverageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *containerLabel;
@property (weak, nonatomic) IBOutlet UILabel *onHandLabel;

@end
