

@interface SBSet : RLMObject
@property NSString *setId;
@property int number;
@property float weight;
@property int repetitions;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<SBSet>
RLM_ARRAY_TYPE(SBSet)
