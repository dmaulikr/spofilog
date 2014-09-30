//
//  SBExercisesViewController.h
//  sportblog
//
//  Created by Marco Bullin on 09/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBWorkout.h"
#import "SBExercisesViewController.h"

@interface SBWorkoutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SBExerciseViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SBWorkout *workout;

@end
