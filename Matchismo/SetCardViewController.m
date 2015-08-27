//
//  SetCardViewController.m
//  Matchismo
//
//  Created by Barak Yoresh on 8/20/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "SetCardViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardView.h"

@interface SetCardViewController()
@property (weak, nonatomic) IBOutlet UIButton *dealNMoreCardsButton;
@end

@implementation SetCardViewController


- (NSUInteger) matchCount{return 3;}

- (NSUInteger) cardCount {return 36;}

- (CGFloat) cardAspectRatio {return 3.0/4.0;}

- (Deck *) createDeck {
  return [[SetCardDeck alloc] initWithFeatureCount:4
                                   andPossibilites:3];
}

#define DEAL_MORE_CARDS_COUNT 3

typedef NS_ENUM(NSInteger, SetCardFeature) {
  setGameCount = 0,
  setGameShape,
  setGameColor,
  setGameShading
};

- (void) viewDidLoad {
  [super viewDidLoad];
  [self.dealNMoreCardsButton setTitle:[NSString stringWithFormat:@"Deal %d more cards",
                                       DEAL_MORE_CARDS_COUNT]
                             forState:UIControlStateNormal];
}

- (void) updateView:(UIView *)view ForCard:(Card *)card Completion:(void(^)(BOOL))completion {
  if (![view isKindOfClass:[SetCardView class]]) {
    if (completion) {
      completion(NO);
    }
      return;
  }
  
  SetCardView *setCardView = (SetCardView *) view;
  if (setCardView.fadedOut != card.isChosen) {
    setCardView.fadedOut = card.isChosen;
    if (completion) {
      completion(YES);
    }
  }
}


- (UIView *) viewForCard:(Card *)card inFrame:(CGRect)rect{
  if (![card isKindOfClass:[SetCard class]]) {
    return nil;
  }
  SetCard *setCard = (SetCard *)card;
  SetCardView *cardView = [[SetCardView alloc] initWithFrame:rect];
  cardView.count = [setCard.features[setGameCount] integerValue] + 1;
  cardView.color = [SetCardView validColors][[setCard.features[setGameColor] integerValue]];
  cardView.shading = [setCard.features[setGameShading] integerValue];
  cardView.shape = [setCard.features[setGameShape] integerValue];
  return cardView;
}

- (void) cardOnBoardCountChanged {
  self.dealNMoreCardsButton.enabled = (self.cardsOnBoard + DEAL_MORE_CARDS_COUNT <= self.cardCount);
}

- (IBAction)dealNMoreCards:(UIButton *)sender {
  for (int i = 0; i < DEAL_MORE_CARDS_COUNT; i++) {
    [self addNewCardFromDeckToBoard];
  }
}


@end
