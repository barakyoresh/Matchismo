//
//  Card.m
//  Matchisma
//
//  Created by Barak Yoresh on 8/17/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray*) otherCards
{
  int score = 0;
  
  for (Card * card in otherCards) {
    if ([card.contents isEqualToString:self.contents]) {
      score = 1;
    }
  }
  
  return score;
}

@end
