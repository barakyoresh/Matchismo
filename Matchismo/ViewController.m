//
//  ViewController.m
//  Matchisma
//
//  Created by Barak Yoresh on 8/17/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "ViewController.h"
#import "MovesHistoryViewController.h"
#import "Card.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *gameMessage;
@property (strong, nonatomic) NSMutableArray *moveHistory;
@property (strong , nonatomic) NSAttributedString *lastMoveMessage;
@end

@implementation ViewController

- (CardMatchingGame *) game
{
  if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardCount usingDeck:[self createDeck] andMatching:self.matchCount];
  return _game;
}

- (Deck *) createDeck
{
  return nil;
}

- (void) viewDidLoad
{
  [super viewDidLoad];
  [self updateUI];
}

- (NSArray *) moveHistory
{
  if (!_moveHistory) _moveHistory = [[NSMutableArray alloc] init];
  return _moveHistory;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
  NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
  [self.game chooseCardAtIndex:cardIndex];
  self.lastMoveMessage = [self renderLastMoveMessage];
  if ([[self.lastMoveMessage string] length]) [self.moveHistory addObject:[self renderLastMoveMessage]];
  [self updateUI];
}


- (void)updateUI
{
  for (UIButton *cardButton in self.cardButtons) {
    NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
    Card *card = [self.game cardAtIndex:cardIndex];
    [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
    [cardButton setEnabled:!card.isMatched];
    [self.score setText: [NSString stringWithFormat:@"Score: %ld", self.game.score]];
    [self.gameMessage setAttributedText: self.lastMoveMessage];
  }
}


- (void) clearUI
{
  for (UIButton *cardButton in self.cardButtons) {
    Card *card = nil;
    [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
    [cardButton setEnabled:!card.isMatched];
  }
  
  [self.score setText: [NSString stringWithFormat:@"Score: %d", 0]];
  self.lastMoveMessage = nil;
  [self.gameMessage setAttributedText: [[NSAttributedString alloc] initWithString: @""]];
}


- (NSAttributedString *)renderLastMoveMessage
{
  NSArray *chosenCards = self.game.lastMoveChosenCards;
  
  NSMutableAttributedString *message = [[NSMutableAttributedString alloc] init];
  NSString *scoreInfo = @"";
  
  if ([chosenCards count]) {
    if ([chosenCards count] == self.game.numberToMatch) {
      for (Card *card in chosenCards) {
        [message appendAttributedString:[self nameForCard:card]];
        [message appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
      }
      scoreInfo = [scoreInfo stringByAppendingFormat:@"%@Match for",
                   self.game.lastMoveMatch ? @"" : @"Don't "];
    } else {
      [message appendAttributedString:[self nameForCard:(Card *)[self.game.lastMoveChosenCards
                                                                 lastObject]]];
      scoreInfo = [scoreInfo stringByAppendingString:@" chosen,"];
    }
    
    scoreInfo = [scoreInfo stringByAppendingFormat:@" %ld points%@!",
                 self.game.lastMoveScore, (self.game.lastMoveScore > 0 ? @"" : @" penalty")];
    
    [message appendAttributedString:[[NSAttributedString alloc] initWithString:scoreInfo]];
  }
  return message;
}



- (IBAction)restartGameButton:(UIButton *)sender
{
  [self clearUI];
  self.moveHistory = nil;
  self.game = nil;
  [self updateUI];
}

- (NSAttributedString *) nameForCard:(Card *)card
{
  return [[NSAttributedString alloc] initWithString:card.contents];
}

- (NSAttributedString *) titleForCard:(Card *)card
{
  return card.isChosen ? [self nameForCard:card] : [[NSAttributedString alloc] initWithString:@""];
}

- (UIImage *) backgroundImageForCard:(Card *)card
{
  return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"ShowMoveHistory"])
  {
    MovesHistoryViewController *vc = [segue destinationViewController];
    vc.moveHistory = self.moveHistory;
  }
}


@end
