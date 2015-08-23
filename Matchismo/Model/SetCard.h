//
//  SetCard.h
//  Matchismo
//
//  Created by Barak Yoresh on 8/20/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card
@property (strong, nonatomic) NSArray *features;
@property (nonatomic, readonly) NSInteger featurePossibilites;
@property (nonatomic, readonly) NSInteger featureCount;

- (instancetype) initWithFeatureCount:(NSInteger)count andPossibilites:(NSInteger)possibilites;
@end
