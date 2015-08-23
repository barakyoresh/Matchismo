//
//  SetCard.m
//  Matchismo
//
//  Created by Barak Yoresh on 8/20/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "SetCard.h"

@interface SetCard()
@property (nonatomic, readwrite) NSInteger featurePossibilites;
@property (nonatomic, readwrite) NSInteger featureCount;
@end

@implementation SetCard

- (instancetype) init {
  return nil;
}

- (instancetype) initWithFeatureCount:(NSInteger)count andPossibilites:(NSInteger)possibilites {
  self = [super init];
  
  if (self) {
    self.featureCount = count;
    self.featurePossibilites = possibilites;
  }
  
  return self;
}


- (NSString *) contents
{
  return nil;
}

-(void) setFeatures: (NSArray *)features
{
  if ([features count] != self.featureCount) {
    for (int i = 0; i < self.featureCount; i++) {
      if (![features[i] isKindOfClass:[NSNumber class]] ||
          [features[i] integerValue] == self.featurePossibilites) {
        return;
      }
    }
  }
  _features = features;
}

- (int)match:(NSArray *)otherCards
{
  int score = 4;
  
  NSMutableArray *cards = [otherCards mutableCopy];
  [cards addObject:self];
  
  for (int i = 0; i < self.featureCount; i++)
  {
    NSMutableSet *featureSet = [[NSMutableSet alloc] init];
    for (SetCard *card in cards) {
      [featureSet addObject:card.features[i]];
    }
    if ([featureSet count] > 1 && [featureSet count] < [cards count]) {
      //mismatch
      return 0;
    }
  }
  
  return score;
}

@end
