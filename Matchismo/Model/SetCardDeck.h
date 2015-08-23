//
//  SetCardDeck.h
//  Matchismo
//
//  Created by Barak Yoresh on 8/20/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "Deck.h"

@interface SetCardDeck : Deck
@property (nonatomic, readonly) NSInteger possibilitiesInFeature;
@property (nonatomic, readonly) NSInteger featureCount;

- (instancetype) initWithFeatureCount:(NSInteger)count andPossibilites:(NSInteger)possibilites;
@end
