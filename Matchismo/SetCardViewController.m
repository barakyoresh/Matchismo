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

@interface SetCardViewController ()

@end

@implementation SetCardViewController

- (NSUInteger) matchCount{return 3;}

- (NSUInteger) cardCount {return 36;}

- (Deck *) createDeck {
  return [[SetCardDeck alloc] initWithFeatureCount:4 andPossibilites:3];
}

typedef NS_ENUM(NSInteger, _name) {
  setGameNumber,
  setGameShape,
  setGameColor,
  setGameShading
};

+ (NSArray *) setGameSahpes {
  return @[@"▲", @"●", @"■"];
}

+ (NSArray *) setGameColors {
  return @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]];
}

+ (NSArray *) setGameShadings {
  return @[@1.0, @0.3, @0.0];
}


- (NSString *) shapeForIndex:(NSUInteger)index {
  if (index > 2) {
    return @"?";
  }
  
  return [SetCardViewController setGameSahpes][index];
}

- (UIColor *) colorForIndex:(NSUInteger)index {
  if (index > 2) {
    return [UIColor blackColor];
  }
  
  return [SetCardViewController setGameColors][index];
}

- (CGFloat) shadingForIndex:(NSUInteger)index {
  if (index > 2) {
    return 1.0;
  }
  
  return [[SetCardViewController setGameShadings][index] floatValue];
}

- (NSDictionary *) nameForCardStringAttributesByColor:(UIColor *)color andShading:(CGFloat)shade {
  return @{NSForegroundColorAttributeName : [color colorWithAlphaComponent:shade],
           NSStrokeColorAttributeName : color,
           NSStrokeWidthAttributeName : @-5};
}

- (NSAttributedString *) nameForCard:(Card *)card {
  if (![card isKindOfClass:[SetCard class]]) {
    return [[NSAttributedString alloc] initWithString:@""];
  }
  
  NSArray *cardFeatures = ((SetCard *) card).features;
  
  NSString *nameString = @"";
  for (int i = 0; i <= [cardFeatures[setGameNumber] integerValue]; i++) { // number
    // shape
    nameString = [nameString stringByAppendingString:
                  [self shapeForIndex:[cardFeatures[setGameShape] integerValue]]];
  }
  
  //color and shading
  UIColor *color = [self colorForIndex:[cardFeatures[setGameColor] integerValue]];
  CGFloat shading = [self shadingForIndex:[cardFeatures[setGameShading] integerValue]];
  NSDictionary *cardAttributes = [self nameForCardStringAttributesByColor:color
                                                               andShading:shading];
  
  
  NSAttributedString *name = [[NSAttributedString alloc] initWithString:nameString
                                                             attributes:cardAttributes];
  
  return name;
}

- (NSAttributedString *) titleForCard:(Card *)card {
  return card.isMatched ? [[NSAttributedString alloc] initWithString:@""] : [self nameForCard:card];
}

- (UIImage *) backgroundImageForCard:(Card *)card {
  if (card.isMatched) {
    return [UIImage imageNamed:@"cardback"];
  }
  
  UIImage *image = [UIImage imageNamed:@"cardfront"];
  return card.isChosen ? [self imageByApplyingAlpha:image withAlpha:0.5] : image;
}


// Daniel - This is code from the web - what are the guidelines with this kind of thing?
// Code from web:
// http://stackoverflow.com/questions/5084845/how-to-set-the-opacity-alpha-of-a-uiimage
- (UIImage *)imageByApplyingAlpha:(UIImage *) image withAlpha:(CGFloat) alpha {
  UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
  
  CGContextScaleCTM(ctx, 1, -1);
  CGContextTranslateCTM(ctx, 0, -area.size.height);
  
  CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
  
  CGContextSetAlpha(ctx, alpha);
  
  CGContextDrawImage(ctx, area, image.CGImage);
  
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return newImage;
}

@end
