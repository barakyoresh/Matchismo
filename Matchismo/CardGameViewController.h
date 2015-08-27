//
//  ViewController.h
//  Matchisma
//
//  Created by Barak Yoresh on 8/17/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"
#import "Card.h"

@interface CardGameViewController : UIViewController

- (void)addNewCardFromDeckToBoard;

- (void)updateUI;

@property (strong, nonatomic) CardMatchingGame *game;

@property (nonatomic) NSUInteger cardsOnBoard;


// abstract
- (Deck*)createDeck;

- (UIView *)viewForCard:(Card *)card inFrame:(CGRect)rect;

- (void)updateView:(UIView *)view ForCard:(Card *)card Completion:(void(^)(BOOL))completion;

- (void)cardOnBoardCountChanged;

@property (nonatomic)NSUInteger matchCount;

@property (nonatomic)NSUInteger cardCount;

@property (nonatomic)CGFloat cardAspectRatio;

@end

