//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Barak Yoresh on 8/18/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSString *gameMessage;
@property (nonatomic, strong) NSMutableArray *cards; //of Card
@property (nonatomic, readwrite) NSUInteger numberToMatch;
@end

@implementation CardMatchingGame

static const int MATCH_BONUS = 4;
static const int MISMATCH_PENALTY = 2;
static const int COST_TO_CHOOSE = 1;


- (NSUInteger) numberToMatch
{
    return _numberToMatch < 2 ? 2 : _numberToMatch; //can't match less than two cards
}

- (NSMutableArray *) cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype) initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *) deck andMatching:(NSUInteger) matchCount
{
  self = [self initWithCardCount:count usingDeck:deck];
  
  if (self) {
    self.numberToMatch = matchCount;
  }
  
  return self;
}

- (instancetype) init
{
    return nil;
}

- (NSString *) gameMessage
{
    if (!_gameMessage) _gameMessage = @"";
    return _gameMessage;
}

- (Card *) cardAtIndex:(NSUInteger)index
{
    return [self.cards count] ? self.cards[index] : nil;
}

- (void) chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            // get chosen cards array
            NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [chosenCards addObject:otherCard];
                }
            }
            
            // for any choice, a penalty is given
            card.chosen = YES;
            self.score -= COST_TO_CHOOSE;
            self.gameMessage = [NSString stringWithFormat:@"%@ Chosen! %d %@ penalty", card.contents, COST_TO_CHOOSE, COST_TO_CHOOSE == 1 ? @"point" : @"points"];
            
            // check for matching
            if ([chosenCards count] + 1 >= self.numberToMatch) {
                int matchScore = [card match:chosenCards];
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    self.gameMessage = @"Matched ";
                    for (Card *chosenCard in chosenCards) {
                        chosenCard.matched = YES;
                        self.gameMessage = [self.gameMessage stringByAppendingFormat:@"%@ ", chosenCard.contents];
                    }
                    card.matched = YES;
                    self.gameMessage = [self.gameMessage stringByAppendingFormat:@"and %@ for %d %@!", card.contents, matchScore * MATCH_BONUS, matchScore * MATCH_BONUS == 1 ? @"point" : @"points"];
                } else {
                    self.score -= MISMATCH_PENALTY;
                    self.gameMessage = @"";
                    for (Card *chosenCard in chosenCards) {
                        self.gameMessage = [self.gameMessage stringByAppendingFormat:@"%@ ", chosenCard.contents];
                        chosenCard.chosen = NO;
                    }
                    card.chosen = NO;
                    self.gameMessage = [self.gameMessage stringByAppendingFormat:@"and %@ Don't match! %d %@ penalty", card.contents, MISMATCH_PENALTY, MISMATCH_PENALTY == 1 ? @"point" : @"points"];
                }
            }
        }
    }
}

@end
