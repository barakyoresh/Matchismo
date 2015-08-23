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

@interface ViewController : UIViewController

@property (strong, nonatomic) CardMatchingGame *game;

//abstract
@property (nonatomic) NSUInteger matchCount;
@property (nonatomic) NSUInteger cardCount;
-(Deck*) createDeck;

@end

