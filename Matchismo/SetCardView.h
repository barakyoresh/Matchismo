//
//  SetCardView.h
//  Matchismo
//
//  Created by Barak Yoresh on 8/24/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

typedef NS_ENUM(NSInteger, SetShape) {
  diamond,
  squiggle,
  oval
};

typedef NS_ENUM(NSInteger, SetShading) {
  solid,
  striped,
  none
};

// list of valid colors for set cards
+ (NSArray *)validColors;

// maximum allowed ammount shapes for set card
+ (NSUInteger)maxCount;

// sets this card's shape
@property (nonatomic) SetShape shape;

// sets this card's color
@property (nonatomic) UIColor *color;

// sets this card's shading
@property (nonatomic) SetShading shading;

// sets the ammount of shapes for this card
@property (nonatomic) NSUInteger count;

// toggles whether this card's transperacy is at 0.5 or 1
@property (nonatomic, getter=isFadedOut) BOOL fadedOut;






@end
