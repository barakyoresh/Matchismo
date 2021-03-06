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
- (Card *) cardAtIndex:(NSUInteger)index;
- (void) addCardFromDeck;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSUInteger numberToMatch;
@property (nonatomic, readonly) NSUInteger activeCardCount;


@end
