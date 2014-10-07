//
//  SBExercisesViewController.h
//  sportblog
//
//  Created by Marco Bullin on 09/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBExercise.h"
#import "GAITrackedViewController.h"

@class SBExercisesViewController;

@protocol SBExerciseViewControllerDelegate <NSObject>
- (void)addExercisesViewController:(SBExercisesViewController *)controller didSelectExercise:(SBExercise *) exercise;
@end

@interface SBExercisesViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id <SBExerciseViewControllerDelegate> delegate;

@end
