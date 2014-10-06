//
//  SBAddEntryViewModel.m
//  sportblog
//
//  Created by Bullin, Marco on 06.10.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBAddEntryViewModel.h"

@implementation SBAddEntryViewModel

- (instancetype)initWithExercises:(RLMArray *)exercises {
    self = [super init];
    
    if (self) {
        if ([exercises count] > 0) {
            _text = NSLocalizedString(@"Add another exercise", nil);
        } else {
            _text = NSLocalizedString(@"Add exercise", nil);
        }
        
        _backgroundColor = [UIColor actionCellColor];
    }
    
    return self;
}

@end