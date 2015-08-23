//
//  PlayingCardViewController.m
//  Matchismo
//
//  Created by Barak Yoresh on 8/19/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface PlayingCardViewController ()
@end
@implementation PlayingCardViewController

- (NSUInteger) matchCount{return 2;}

- (NSUInteger) cardCount {return 30;}


- (Deck *) createDeck
{
  return [[PlayingCardDeck alloc] init];
}


@end
