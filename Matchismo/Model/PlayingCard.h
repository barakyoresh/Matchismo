//
//  PlayingCard.h
//  Matchismo
//
//  Created by Barak Yoresh on 8/17/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *) validSuits;
+ (NSUInteger) maxRank;

@end
