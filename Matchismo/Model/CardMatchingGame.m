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
@property (strong, nonatomic) NSMutableArray *cards; //of Card
@property (strong, nonatomic) Deck *deck;
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
    self.deck = deck;
    for (int i = 0; i < count; i++) {
      [self addCardFromDeck];
    }
  }
  
  return self;
}

- (void) addCardFromDeck {
  Card *card = [self.deck drawRandomCard];
  if (card) {
    [self.cards addObject:card];
  }
}

- (NSUInteger) activeCardCount {
  return [self.cards count];
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

- (Card *) cardAtIndex:(NSUInteger)index
{
  return [self.cards count] ? self.cards[index] : nil;
}

- (void) chooseCardAtIndex:(NSUInteger)index
{
  Card *card = [self cardAtIndex:index];
  
  
  if (card.isMatched) {
    return;
  }
  
  if (!card.isChosen) {
    card.chosen = YES;
    [self tryToMatch:card];
  } else {
    card.chosen = NO;
  }
}


- (void) tryToMatch:(Card *) card
{
  [self updateScore:(-COST_TO_CHOOSE)];
  
  NSArray *chosenCards = [self otherCurrentlyChosenCards:card];
  
  //if enough cards were chosen check for match
  if ([chosenCards count] + 1 == self.numberToMatch) {
    int matchScore = [card match:chosenCards];
    
    //cards matched
    if (matchScore) {
      [self updateScore:matchScore * MATCH_BONUS];
      
      for (Card *chosenCard in chosenCards) {
        chosenCard.matched = YES;
      }
      card.matched = YES;
    } else {
      [self updateScore:(-MISMATCH_PENALTY)];
      
      for (Card *chosenCard in chosenCards) {
        chosenCard.chosen = NO;
      }
      card.chosen = NO;
    }
  }
}

- (NSArray *) otherCurrentlyChosenCards:(Card *)card {
  NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
  for (Card *otherCard in self.cards) {
    if (otherCard.isChosen && !otherCard.isMatched && otherCard != card) {
      [chosenCards addObject:otherCard];
    }
  }
  return [chosenCards copy];
}

- (void) updateScore:(NSInteger) scoreDelta
{
  self.score += scoreDelta;
}

@end
