//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Barak Yoresh on 8/20/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardDeck()
@property (nonatomic, readwrite) NSInteger featurePossibilites;
@property (nonatomic, readwrite) NSInteger featureCount;
@end

@implementation SetCardDeck

- (instancetype)init
{
  return nil;
}

- (instancetype) initWithFeatureCount:(NSInteger)count andPossibilites:(NSInteger)possibilites {
  self = [super init];
  
  if (self) {
    self.featureCount = count;
    self.featurePossibilites = possibilites;
    [self recursivlyAddAllPermutationsToDeckForFeatures:[[NSArray alloc] init]];
  }
  return self;
}


- (void) recursivlyAddAllPermutationsToDeckForFeatures:(NSArray *) features
{
  // stop condition - feature array is in the correct length
  if ([features count] >= self.featureCount) {
    SetCard *card = [[SetCard alloc] initWithFeatureCount:self.featureCount
                                          andPossibilites:self.featurePossibilites];
    card.features = features;
    [self addCard:card];
    return;
  }
  
  // iterate current feature and call recursivly
  for (int i = 0; i < self.featurePossibilites; i++) {
    NSMutableArray *currentFeatures = [features mutableCopy];
    [currentFeatures addObject:[NSNumber numberWithInt:i]];
    [self recursivlyAddAllPermutationsToDeckForFeatures:currentFeatures];
    
  }
  return;
}


@end