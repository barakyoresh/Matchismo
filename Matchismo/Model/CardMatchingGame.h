//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Barak Yoresh on 8/18/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject


- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *) deck;
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *) deck andMatching:(NSUInteger) matchCount;

- (void) chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSArray *lastMoveChosenCards;
@property (nonatomic, readonly) NSInteger lastMoveScore;
@property (nonatomic, readonly) BOOL lastMoveMatch;
@property (nonatomic, readonly) NSUInteger numberToMatch;


@end
