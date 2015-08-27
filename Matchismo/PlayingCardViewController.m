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
#import "PlayingCardView.h"

@interface PlayingCardViewController ()
@end
@implementation PlayingCardViewController

- (NSUInteger) matchCount{return 2;}

- (NSUInteger) cardCount {return 30;}

- (CGFloat) cardAspectRatio {return 2.0/3.0;}

- (Deck *) createDeck
{
  return [[PlayingCardDeck alloc] init];
}

- (void) updateView:(UIView *)view ForCard:(Card *)card Completion:(void(^)(BOOL))completion{
  if (![view isKindOfClass:[PlayingCardView class]] || ![card isKindOfClass:[PlayingCard class]]) {
    if (completion) {
      completion(NO);
    }
    return;
  }
  
  PlayingCard *playingCard = (PlayingCard *) card;
  PlayingCardView *playingCardView = (PlayingCardView *) view;
  
  if (playingCardView.faceUp != playingCard.isChosen) {
    [UIView transitionWithView:playingCardView
                      duration:0.1
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                      playingCardView.faceUp = playingCard.isChosen;
                    }
                    completion:completion];
  }
}


- (UIView *) viewForCard:(Card *)card inFrame:(CGRect)rect{
  if (![card isKindOfClass:[PlayingCard class]]) {
    return nil;
  }
  PlayingCard *playingCard = (PlayingCard *) card;
  PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:rect];
  cardView.rank = playingCard.rank;
  cardView.suit = playingCard.suit;
  cardView.faceUp = card.isChosen ? YES : NO;
  return cardView;
}

@end
