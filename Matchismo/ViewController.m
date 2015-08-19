//
//  ViewController.m
//  Matchisma
//
//  Created by Barak Yoresh on 8/17/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "ViewController.h"
#import "Card.h"
#import "Deck.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface ViewController ()
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *gameMessage;
@property (nonatomic) NSUInteger matchCount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchCountSegmentedControl;
@end

@implementation ViewController

- (CardMatchingGame *) game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:30 usingDeck:self.deck andMatching:self.matchCount];
    return _game;
}

- (Deck *) deck
{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (NSUInteger) matchCount
{
    if (!_matchCount) _matchCount = 2;
    return _matchCount;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
  [self.matchCountSegmentedControl setEnabled:NO];
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        [cardButton setEnabled:!card.isMatched];
        [self.score setText: [NSString stringWithFormat:@"Score: %ld", self.game.score]];
        [self.gameMessage setText: self.game.gameMessage];
    }
}

- (void) clearUI
{
  for (UIButton *cardButton in self.cardButtons) {
    Card *card = nil;
    [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
    [cardButton setEnabled:!card.isMatched];
    [self.score setText: [NSString stringWithFormat:@"Score: %d", 0]];
    [self.gameMessage setText: @""];
  }

}

- (IBAction)restartGameButton:(UIButton *)sender
{
  [self.matchCountSegmentedControl setEnabled:YES];
  [self clearUI];
  self.deck = nil;
  self.game = nil;
}

- (IBAction)matchCountValueChanged:(UISegmentedControl *)sender
{
  //this is extremely hard coded, but then again the entire widget should be game dependent and
  //thats not in the exercise's instructions.
  self.matchCount = sender.selectedSegmentIndex + 2;
}


- (NSString *) titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *) backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
