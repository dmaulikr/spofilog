#import "SBSetInteractor.h"

@implementation SBSetInteractor

- (void)deleteSet:(SBSet *)set fromExerciseSet:(SBExerciseSet *)exercise AtIndex:(int)index {
    [exercise.realm beginWriteTransaction];
    [exercise.sets removeObjectAtIndex:index];
    [RLMRealm.defaultRealm deleteObject:set];
    [exercise.realm commitWriteTransaction];
}

- (SBSet *)createSetDependingOnSet:(SBSet *)set {
    SBSet *newSet = [SBSet new];
    newSet.number = set.number + 1;
    newSet.weight = set.weight;
    newSet.repetitions = set.repetitions;
    
    return newSet;
}

- (SBSet *)createSetWithNumber:(int)number weight:(float)weight andRepetitions:(int)repetitions {
    SBSet *set = [SBSet new];
    set.number = number;
    set.weight = weight;
    set.repetitions = repetitions;
    
    return set;
}

- (void)updateSet:(SBSet *)set withNumber:(int)number {
    [RLMRealm.defaultRealm beginWriteTransaction];
    set.number = number;
    [RLMRealm.defaultRealm commitWriteTransaction];
}

- (void)updateSet:(SBSet *)set withWeight:(float)weight {
    [RLMRealm.defaultRealm beginWriteTransaction];
    set.weight = weight;
    [RLMRealm.defaultRealm commitWriteTransaction];
}

- (void)updateSet:(SBSet *)set withRepetitions:(int)repetitions {
    [RLMRealm.defaultRealm beginWriteTransaction];
    set.repetitions = repetitions;
    [RLMRealm.defaultRealm commitWriteTransaction];
}

@end
