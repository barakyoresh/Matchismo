//
//  PlayingCard.m
//  Matchismo
//
//  Created by Barak Yoresh on 8/17/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *) contents
{
    
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *) rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}
+ (NSUInteger) maxRank
{
    return [[self rankStrings] count]-1;
}
- (void) setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}


@synthesize suit = _suit;
+ (NSArray *) validSuits
{
    return @[@"♠️", @"♣️", @"♥️", @"♦️"];
}
- (NSString *) suit
{
    return _suit ? _suit : @"?";
}
- (void) setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (int)match:(NSArray*) otherCards
{
    int score = 0;
    
    NSMutableArray *cards = [otherCards mutableCopy];
    [cards addObject:self];
    
    for (int i = 0; i < [cards count]; i++) {
        for (int j = i+1; j < [cards count]; j++) {
            if (((PlayingCard *)cards[i]).rank == ((PlayingCard *)cards[j]).rank) {
                score += 4;
            }
            if ([((PlayingCard *)cards[i]).suit isEqualToString:((PlayingCard *)cards[j]).suit]) {
                score += 1;
            }
        }
    }

    
    return score;
}



@end
