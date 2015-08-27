//
//  ViewController.m
//  Matchisma
//
//  Created by Barak Yoresh on 8/17/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "CardGameViewController.h"
#import "MovesHistoryViewController.h"
#import "InsetGrid.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UIView *gameBoard;
@property (strong, nonatomic) InsetGrid *gameBoardGrid;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (nonatomic) BOOL boardInitiated;
@end

@implementation CardGameViewController

#define CARD_INSET_RATIO 1.0/25.0
#define CARD_ANIMATION_DURATION 0.1
#define CARD_CREATION_ORIGIN_X 0
#define CARD_CREATION_ORIGIN_Y 0


- (CardMatchingGame *)game
{
  if (!_game) {
  _game = [[CardMatchingGame alloc] initWithCardCount:self.cardCount
                                                        usingDeck:[self createDeck]
                                                        andMatching:self.matchCount];
  }
  return _game;
}

- (CGPoint)offScreenPoint { return CGPointMake(self.view.bounds.size.width * 2,
                                                -self.view.bounds.size.height); }

- (NSUInteger)cardsOnBoard {
  return [[self.gameBoard subviews] count];
}

- (NSMutableArray *)cardViews {
  if (!_cardViews) _cardViews = [[NSMutableArray alloc] init];
  return _cardViews;
}

- (void)viewDidLoad {
  self.gameBoard.backgroundColor = nil;
  self.gameBoard.opaque = NO;
  self.gameBoard.clipsToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated {
  if (!self.boardInitiated) {
    [self initGameGridWithCells:self.cardCount
                 andAspectRatio:self.cardAspectRatio];
    [self addAllCardsToBoard];
    self.boardInitiated = YES;
  }
}

- (void)initGameGridWithCells:(NSUInteger) cellCount andAspectRatio:(CGFloat) ratio {
  self.gameBoardGrid = [[InsetGrid alloc] init];
  self.gameBoardGrid.size = self.gameBoard.frame.size;
  self.gameBoardGrid.cellAspectRatio = ratio;
  self.gameBoardGrid.minimumNumberOfCells = cellCount;
  self.gameBoardGrid.insetValueX = self.gameBoardGrid.cellSize.width * CARD_INSET_RATIO;
  self.gameBoardGrid.insetValueY = self.gameBoardGrid.cellSize.height  * CARD_INSET_RATIO;
  if (!self.gameBoardGrid.inputsAreValid) {
    self.gameBoardGrid = nil;
  }
}

- (void)addNewCardFromDeckToBoard {
  NSUInteger currentIndex = self.game.activeCardCount;
  [self.game addCardFromDeck];
  if (currentIndex != self.game.activeCardCount) {
    [self addCardViewToBoard:[self createCardViewForCard:[self.game cardAtIndex:currentIndex]]];
    [self moveActiveUnmatchedCardsToMinimalGrid]; //TODO: this is a very specific place for this to be
  }
}

- (void)addCardViewToBoard:(UIView *)cardView {
  [self.gameBoard addSubview:cardView];
  [self.cardViews addObject:cardView];
  [self cardOnBoardCountChanged];
}

- (void)removeCardViewFromBoard:(UIView *)cardView {
  [cardView removeFromSuperview];
  [self cardOnBoardCountChanged];
}

- (UIView *)createCardViewForCard:(Card *)card {
  CGRect originScreenRect = CGRectMake(CARD_CREATION_ORIGIN_X,
                                    CARD_CREATION_ORIGIN_Y,
                                    self.gameBoardGrid.insetCellSize.width,
                                    self.gameBoardGrid.insetCellSize.height);
  UIView *cardView = [self viewForCard:card
                               inFrame:originScreenRect];
  UITapGestureRecognizer *tapRecognizer =
  [[UITapGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(handleTapCard:)];
  [cardView addGestureRecognizer:tapRecognizer];
  return cardView;
}

- (NSUInteger)gridRowByIndex:(NSUInteger)index {
  return (index / self.gameBoardGrid.columnCount);
}

- (NSUInteger)gridColumnByIndex:(NSUInteger)index {
  return (index % self.gameBoardGrid.columnCount);

}

- (CGPoint)gridCellCenterAtIndex:(NSUInteger)index {
  return [self.gameBoardGrid centerOfCellAtRow:[self gridRowByIndex:index]
                                      inColumn:[self gridColumnByIndex:index]];
}

- (void)addAllCardsToBoard {
  for (int i = 0; i < self.game.activeCardCount; i++) {
    Card *card = [self.game cardAtIndex:i];
    [self addCardViewToBoard:[self createCardViewForCard:card]];
  }
  [self moveActiveUnmatchedCardsToMinimalGrid];
}


- (void)removeMatchedCardsFromBoard {
  __weak CardGameViewController *weakSelf = self;
  for (UIView *cardView in [self activeCardViewsWithCorrespondingCardMatched:YES]) {
    [UIView animateWithDuration:1.0
                     animations:^{
                       cardView.center = [weakSelf offScreenPoint];
                     }
                     completion:^(BOOL finished){
                       [weakSelf removeCardViewFromBoard:cardView];
                     }];
  }
}


- (NSArray *)activeCardViews {
  NSMutableArray *activeCardViews = [[NSMutableArray alloc] init];
  for (int i = 0; i < self.game.activeCardCount; i++) {
    if ([[self.gameBoard subviews] containsObject:self.cardViews[i]]) {
      [activeCardViews addObject:self.cardViews[i]];
    }
  }
  return [activeCardViews copy];
}

- (Card *)cardByCardView:(UIView *)cardView {
  return [self.game cardAtIndex:[self.cardViews indexOfObject:cardView]];
}

- (NSArray *)activeCardViewsWithCorrespondingCardMatched:(BOOL)matched {
  NSMutableArray *matchedActiveCardViews = [[NSMutableArray alloc] init];
  for (UIView *activeCardView in [self activeCardViews]) {
    if ([self cardByCardView:activeCardView].isMatched == matched) {
      [matchedActiveCardViews addObject:activeCardView];
    }
  }
  return [matchedActiveCardViews copy];
}

- (void)moveActiveUnmatchedCardsToMinimalGrid {
  int index = 0;
  for (UIView *cardView in [self activeCardViewsWithCorrespondingCardMatched:NO]) {
      [UIView animateWithDuration:CARD_ANIMATION_DURATION
                            delay:(index * (CARD_ANIMATION_DURATION / 10))
                          options:UIViewAnimationOptionCurveLinear
                       animations:^{
                         cardView.center = [self gridCellCenterAtIndex:index];
                       }
                       completion:nil];
      index++;
  }
}

- (void)clearUI
{
  for (UIView *cardView in [self.cardViews copy]) {
    [cardView removeFromSuperview];
    [self.cardViews removeObject:cardView];
  }
  [self.score setText: [NSString stringWithFormat:@"Score: %d", 0]];
}

- (void)updateUI {
  __weak id weakSelf = self;
  for (UIView *activeCardView in [self activeCardViews]) {
    [self updateView:activeCardView
             ForCard:[weakSelf cardByCardView:activeCardView]
          Completion:^(BOOL finished) {
            if (finished) {
              [weakSelf removeMatchedCardsFromBoard];
              [weakSelf moveActiveUnmatchedCardsToMinimalGrid];
            }
          }];
  }
  [self.score setText: [NSString stringWithFormat:@"Score: %ld", self.game.score]];
}


- (IBAction)restartGameButton:(UIButton *)sender
{
  [self clearUI];
  self.game = nil;
  [self addAllCardsToBoard];
  [self updateUI];
}

- (void)handleTapCard:(UITapGestureRecognizer *)tapGestureRecognizer {
  NSUInteger cardViewIndex = [self.cardViews indexOfObject:[tapGestureRecognizer view]];
  [self.game chooseCardAtIndex:cardViewIndex];
  [self updateUI];
}

#pragma abstract

- (Deck *)createDeck {
  return nil;
}


- (void)updateView:(UIView *)view ForCard:(Card *)card Completion:(void (^)(BOOL))completion {
}


- (UIView *)viewForCard:(Card *)card inFrame:(CGRect)rect {
  return nil;
}

-(void)cardOnBoardCountChanged { }


@end
