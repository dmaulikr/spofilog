//
//  SBExercisesViewController.m
//  sportblog
//
//  Created by Marco Bullin on 09/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBWorkoutViewController.h"
#import "SBLeftRightTableViewCell.h"
#import "SBAddEntryTableViewCell.h"
#import "SBExerciseTableViewCell.h"
#import "SBEditWorkoutTableViewCell.h"
#import "SBExercisesViewController.h"
#import "SBSetsViewController.h"
#import "SBExerciseSet.h"
#import "UIViewController+Tutorial.h"

@interface SBWorkoutViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) bool isEditWorkoutDetails;
@end

@implementation SBWorkoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createDateFormatter];
    
    self.navigationItem.title = NSLocalizedString(@"Workout", nil);
    
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.hidesBackButton = YES;
    
    if (self.workout == nil) {
        self.workout = [[SBWorkout alloc] init];
        self.workout.date = [NSDate date];
    }
    
    [self startTapTutorialWithInfo:NSLocalizedString(@"Touch to edit workout", nil)
                           atPoint:CGPointMake(160, self.view.frame.size.height / 2 - 50)
              withFingerprintPoint:CGPointMake(50, 85)
              shouldHideBackground:NO];
    
    self.view.backgroundColor = [UIColor colorWithRed:140.0f/255.0f green:150.0f/255.0f blue:160.0f/255.0f alpha:1];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)createDateFormatter {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 1 || (indexPath.row == 2 && self.isEditWorkoutDetails)) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // standard -2 because of (workout and add exercise cell)
        int index = indexPath.row - 2;
        
        // decrement if edit workout cell is visible
        if (self.isEditWorkoutDetails) {
            index--;
        }
        
        [self.workout.realm beginWriteTransaction];
        [self.workout.exercises removeObjectAtIndex:index];
        [self.workout.realm commitWriteTransaction];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = [self.workout.exercises count] + 2;
    
    if (self.isEditWorkoutDetails) {
        count += 1;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"exerciseCell";
    
    if (indexPath.row == 0) {
        cellIdentifier = @"workoutCell";
        SBLeftRightTableViewCell *workoutCell = (SBLeftRightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (workoutCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBLeftRightTableViewCell" owner:self options:nil];
            workoutCell = [nib objectAtIndex:0];
        }
        
        workoutCell.leftLabel.text = self.workout.name ?: NSLocalizedString(@"Workout", nil);
        workoutCell.rightLabel.text = [self.dateFormatter stringFromDate:self.workout.date];
        workoutCell.leftLabel.textColor = [UIColor whiteColor];
        workoutCell.rightLabel.textColor = [UIColor whiteColor];
        
        workoutCell.backgroundColor = [UIColor clearColor];
        
        
        return workoutCell;
    }

    if (indexPath.row == 1 && self.isEditWorkoutDetails) {
        cellIdentifier = @"editWorkoutCell";
        
        SBEditWorkoutTableViewCell *editWorkoutCell = (SBEditWorkoutTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (editWorkoutCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBEditWorkoutTableViewCell" owner:self options:nil];
            editWorkoutCell = [nib objectAtIndex:0];
        }
        
        editWorkoutCell.workoutTextField.text = self.workout.name;
        editWorkoutCell.workoutTextField.placeholder = NSLocalizedString(@"Workout", nil);
        editWorkoutCell.workoutTextField.textColor = [UIColor whiteColor];
        editWorkoutCell.workoutTextField.layer.borderColor = [[UIColor whiteColor] CGColor];
        editWorkoutCell.workoutTextField.layer.borderWidth = 1.0;
        
        editWorkoutCell.datePicker.date = self.workout.date;
        editWorkoutCell.backgroundColor = [UIColor clearColor];
        
        return editWorkoutCell;
    }
    
    if ((indexPath.row == 1 && !self.isEditWorkoutDetails) || (indexPath.row == 2 && self.isEditWorkoutDetails)) {
        cellIdentifier = @"addExerciseCell";
        
        SBAddEntryTableViewCell *addExerciseCell = (SBAddEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (addExerciseCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBAddEntryTableViewCell" owner:self options:nil];
            addExerciseCell = [nib objectAtIndex:0];
        }
        
        addExerciseCell.addEntryLabel.text = NSLocalizedString(@"Add exercise", nil);
        addExerciseCell.backgroundColor = [UIColor clearColor];
        
        return addExerciseCell;
    }
    
    SBLeftRightTableViewCell *exerciseCell = (SBLeftRightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (exerciseCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBLeftRightTableViewCell" owner:self options:nil];
        exerciseCell = [nib objectAtIndex:0];
    }
    
    // standard -2 because of (workout and add exercise cell)
    int index = indexPath.row - 2;
    
    // decrement if edit workout cell is visible
    if (self.isEditWorkoutDetails) {
        index--;
    }
    
    SBExerciseSet *exercise = [self.workout.exercises objectAtIndex:index];
    
    exerciseCell.leftLabel.text = exercise.name;
    exerciseCell.rightLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d Sets", nil), [exercise.sets count]];
    exerciseCell.leftLabel.textColor = [UIColor whiteColor];
    exerciseCell.rightLabel.textColor = [UIColor whiteColor];
    
    exerciseCell.backgroundColor = [UIColor clearColor];
    
    return exerciseCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    // user touched on workout to edit name or date
    if (indexPath.row == 0) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row+1 inSection:section];
        
        NSArray *indexPaths = [NSArray arrayWithObject :newIndexPath];
        SBLeftRightTableViewCell *workoutCell = (SBLeftRightTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if (self.isEditWorkoutDetails) {
            self.isEditWorkoutDetails = NO;
            
            [workoutCell.leftLabel setTextColor:[UIColor blackColor]];
            [workoutCell.rightLabel setTextColor:[UIColor blackColor]];
            
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
        } else {
            self.isEditWorkoutDetails = YES;
            
            [workoutCell.leftLabel setTextColor:[UIColor redColor]];
            [workoutCell.rightLabel setTextColor:[UIColor redColor]];
            
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
        }
        
        return;
    }
    
    // user touched on add new exercise
    if ((indexPath.row == 1 && !self.isEditWorkoutDetails) || (indexPath.row == 2 && self.isEditWorkoutDetails)) {
        SBExercisesViewController *exercisesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SBExercisesViewController"];
        exercisesViewController.delegate = self;
        [self.navigationController pushViewController:exercisesViewController animated:YES];
        
        return;
    }
    
    // user touched on an exercise
    SBSetsViewController *setViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SBSetsViewController"];
    
    // standard -2 because of (workout and add exercise cell)
    int index = indexPath.row - 2;
    
    // decrement if edit workout cell is visible
    if (self.isEditWorkoutDetails) {
        index--;
    }
    
    SBExerciseSet *exercise = [self.workout.exercises objectAtIndex:index];
    setViewController.exercise = exercise;
    
    [self.navigationController pushViewController:setViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 && self.isEditWorkoutDetails) {
        UITableViewCell *editWorkoutCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return editWorkoutCell.frame.size.height;
    }
    
    return 44.0;
}

- (IBAction)onChangeWorkoutName:(id)sender {
    UITextField *textField = (UITextField *) sender;
    NSString *workoutName = textField.text;
    if ([workoutName isEqualToString:@""]) {
        workoutName = NSLocalizedString(@"Workout", nil);
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    SBLeftRightTableViewCell *workoutCell = (SBLeftRightTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    workoutCell.leftLabel.text = workoutName;
    
    [self.workout.realm beginWriteTransaction];
    self.workout.name = workoutName;
    [self.workout.realm commitWriteTransaction];
}

- (IBAction)onDateChanged:(UIDatePicker *)sender {
    [self.workout.realm beginWriteTransaction];
    self.workout.date = sender.date;
    [self.workout.realm commitWriteTransaction];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    SBLeftRightTableViewCell *workoutCell = (SBLeftRightTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    workoutCell.rightLabel.text = [self.dateFormatter stringFromDate:sender.date];
}

- (IBAction)onWorkoutCompleted:(id)sender {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    if (!self.workout.name) {
        self.workout.name = NSLocalizedString(@"Workout", nil);
    }
    
    [realm beginWriteTransaction];
    [realm addObject:self.workout];
    [realm commitWriteTransaction];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCancelWorkout:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addExercisesViewController:(SBExercisesViewController *)controller didSelectExercise:(SBExercise *) exercise {
    
    [self startTapTutorialWithInfo:NSLocalizedString(@"Touch to add or edit sets", nil)
                           atPoint:CGPointMake(160, self.view.frame.size.height / 2 + 50)
              withFingerprintPoint:CGPointMake(50, 180)
              shouldHideBackground:NO];
    
    SBExerciseSet *exerciseSet =  [[SBExerciseSet alloc] init];
    exerciseSet.name = exercise.name;
    exerciseSet.date = self.workout.date;
    
    [self.workout.realm beginWriteTransaction];
    [self.workout.exercises addObject:exerciseSet];
    [self.workout.realm commitWriteTransaction];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}

@end
