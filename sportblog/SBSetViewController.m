//
//  SBSetViewController.m
//  sportblog
//
//  Created by Marco Bullin on 13/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBSetViewController.h"
#import "SBLeftRightCell.h"
#import "UIColor+SBColor.h"

@interface SBSetViewController ()

@property (nonatomic) bool isEditSet;
@property (nonatomic) bool isEditWeight;
@property (nonatomic) bool isEditRepetitions;

@end

@implementation SBSetViewController
UIPickerView *picker;
UIView *changeView;
UIView *overlayView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.navigationItem.hidesBackButton = YES;
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone:)];
        
        self.navigationItem.rightBarButtonItem = doneButton;
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelSet:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.number = self.currentSet.number;
    self.weight = self.currentSet.weight;
    self.repetitions = self.currentSet.repetitions;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.backgroundColor = [UIColor tableViewColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    
    SBLeftRightCell *cell = (SBLeftRightCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBLeftRightCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor actionCellColor];
    cell.leftLabel.textColor = [UIColor whiteColor];
    cell.rightLabel.textColor = [UIColor whiteColor];
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // set cell
    if (indexPath.row == 0) {
        cell.leftLabel.text = NSLocalizedString(@"Set", nil);
        cell.rightLabel.text = [NSString stringWithFormat:@"%d", self.number];
        
        return cell;
    }
    
    // weight cell
    if (indexPath.row == 1) {
        cell.leftLabel.text = NSLocalizedString(@"Weight", nil);
        cell.rightLabel.text = [NSString stringWithFormat:@"%.01fkg", self.weight];
        return cell;
    }

    // repetition cell
    cell.leftLabel.text = NSLocalizedString(@"Repetitions", nil);
    cell.rightLabel.text = [NSString stringWithFormat:@"%d", self.repetitions];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    changeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height, self.tableView.frame.size.width, 280)];
    changeView.backgroundColor = [UIColor whiteColor];
    
    if (overlayView == nil) {
        overlayView = [UIView new];
        overlayView.frame = self.tableView.frame;
        overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }

    [self.view addSubview:overlayView];
    [self.view addSubview:changeView];
    
    picker = [[UIPickerView alloc] init];
    picker.frame = CGRectMake(0, 44, 320, 162);
    picker.showsSelectionIndicator = YES;
    picker.dataSource = self;
    picker.delegate = self;
    
    if (indexPath.row == 0) {
        self.isEditSet = YES;
        self.isEditWeight = NO;
        self.isEditRepetitions = NO;
        [picker selectRow:self.number-1 inComponent:0 animated:NO];
        [changeView addSubview:[self createToolbar:NSLocalizedString(@"Set", nil)]];
    }
    
    if (indexPath.row == 1) {
        self.isEditSet = NO;
        self.isEditWeight = YES;
        self.isEditRepetitions = NO;
        
        NSString *str= [NSString stringWithFormat:@"%.01f", self.weight];
        NSArray *arr = [str componentsSeparatedByString:@"."];
        int first=[[arr firstObject] intValue];
        int last=[[arr lastObject] intValue];
        
        [picker selectRow:first inComponent:0 animated:NO];
        [picker selectRow:last inComponent:2 animated:NO];
        
       [changeView addSubview:[self createToolbar:NSLocalizedString(@"Weight", nil)]];
    }
    
    if (indexPath.row == 2) {
        self.isEditSet = NO;
        self.isEditWeight = NO;
        self.isEditRepetitions = YES;
        [picker selectRow:self.repetitions inComponent:0 animated:NO];
        [changeView addSubview:[self createToolbar:NSLocalizedString(@"Repetitions", nil)]];
    }
    
    [changeView addSubview:picker];
    
    [UIView animateWithDuration:0.5 animations:^{
        changeView.frame = CGRectMake(0, self.tableView.frame.size.height - changeView.frame.size.height,self.tableView.frame.size.width, 280);
    }];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.isEditSet || self.isEditRepetitions) {
        return 99;
    }
    
    if (component == 0) {
        return 300;
    }
    
    if (component == 1 || component == 3) {
        return 1;
    }
    
    return 10;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.isEditSet) {
        return 1;
    }
    
    if (self.isEditRepetitions) {
        return 1;
    }
    
    return 4;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (self.isEditWeight) {
        if (component == 0 || component == 2) {
            return [NSString stringWithFormat:@"%d", (int)row];
        }
        
        if (component == 1) {
            return [NSString stringWithFormat:@","];
        }
        
        if (component == 3) {
            return [NSString stringWithFormat:@"kg"];
        }
    }
    
    if (self.isEditSet) {
        return [NSString stringWithFormat:@"%d", (int)row + 1];
    }
    
    return [NSString stringWithFormat:@"%d", (int)row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.isEditSet || self.isEditRepetitions) {
        return 150.0;
    }
    
    if (component == 0) {
        return 50.0;
    }
    
    if (component == 1) {
        return 20.0;
    }
    
    if (component == 2) {
        return 30.0;
    }
    
    return 40.0;
}

- (UIView *)createToolbar:(NSString *)titleString {
    UIToolbar *inputAccessoryView = [[UIToolbar alloc] init];
    inputAccessoryView.translucent = NO;
    inputAccessoryView.barTintColor = [UIColor actionCellColor];
    inputAccessoryView.tintColor = [UIColor whiteColor];
    inputAccessoryView.barStyle = UIBarStyleDefault;
    inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [inputAccessoryView sizeToFit];
    
    CGRect frame = inputAccessoryView.frame;
    frame.size.height = 44.0f;
    inputAccessoryView.frame = frame;
        
    UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 11.0f, 100, 21.0f)];
    [titleLabel setText:titleString];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
        
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:cancelBtn,flexibleSpaceLeft,title,flexibleSpaceLeft, doneBtn, nil];
    [inputAccessoryView setItems:array];
        
    return inputAccessoryView;
}

- (void)done:(id)sender {
    
    if (self.isEditSet) {
        self.number = [picker selectedRowInComponent:0] + 1;
    }
    
    if (self.isEditWeight) {
        self.weight = [[NSString stringWithFormat:@"%d.%d", [picker selectedRowInComponent:0], [picker selectedRowInComponent:2]] floatValue];
    }
    
    if (self.isEditRepetitions) {
        self.repetitions = [picker selectedRowInComponent:0];
    }
    
    [self.tableView reloadData];
    
    [UIView animateWithDuration:.5 animations:^{
        changeView.frame = CGRectMake(0, self.tableView.frame.size.height, self.tableView.frame.size.width, 280);
    } completion:^(BOOL finished) {
        [overlayView removeFromSuperview];
        [changeView removeFromSuperview];
    }];
}
    
- (void)cancel:(id)sender {

    [UIView animateWithDuration:.5 animations:^{
        changeView.frame = CGRectMake(0, self.tableView.frame.size.height, self.tableView.frame.size.width, 280);
    } completion:^(BOOL finished) {
        [overlayView removeFromSuperview];
        [changeView removeFromSuperview];
    }];
}

- (void)onDone:(id)sender {
    if (!self.currentSet) {
        SBSet *set = [[SBSet alloc] init];
        set.number = self.number;
        set.weight = self.weight;
        set.repetitions = self.repetitions;
        
        [self.delegate addSetViewController:self didCreatedNewSet:set];
    } else {
        [self.currentSet.realm beginWriteTransaction];
        self.currentSet.number = self.number;
        self.currentSet.weight = self.weight;
        self.currentSet.repetitions = self.repetitions;
        [self.currentSet.realm commitWriteTransaction];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onCancelSet:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

@end
