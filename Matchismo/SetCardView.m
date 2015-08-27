//
//  SetCardView.m
//  Matchismo
//
//  Created by Barak Yoresh on 8/24/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "SetCardView.h"
@implementation SetCardView

#pragma mark - Properties
+ (NSUInteger) maxCount {return 3;};
+ (NSArray *) validColors { return @[[UIColor greenColor], [UIColor blueColor], [UIColor magentaColor]];}



- (void)setShape:(SetShape)shape
{
  _shape = shape;
  [self setNeedsDisplay];
}


- (void)setColor:(UIColor *)color
{
  if ([[SetCardView validColors] containsObject:color]) {
    _color = color;
    [self setNeedsDisplay];
  }
}


- (void)setShadung:(SetShading)shading
{
  _shading = shading;
  [self setNeedsDisplay];
}

- (void)setCount:(NSUInteger)count
{
  if (count <= [SetCardView maxCount] && count > 0) {
    _count = count;
    [self setNeedsDisplay];
  }
}

- (void)setFadedOut:(BOOL)fadedOut
{
  _fadedOut = fadedOut;
  [self setNeedsDisplay];
}


#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0
#define SHAPE_SCALE_FACTOR_WIDTH 0.8
#define SHAPE_SCALE_FACTOR_HEIGHT 0.25
#define SHAPE_STROKE_WIDTH_FACTOR 1.0/150.0
#define SHAPE_MARGIN_X_FACTOR 0.05
#define SHAPE_MARGIN_Y_FACTOR 0.1
#define STRIPE_TO_WIDTH_RATIO 0.005
#define SQUIGGLE_CORNER_X_OFFSET_FACTOR 1.0/5.0
#define SQUIGGLE_CORNER_Y_OFFSET_FACTOR 1.0/10.0
#define SQUIGGLE_CONTROL_POINT_OFFSET_FACTOR 1.0/7.0
#define FADED_OUT_ALPHA 0.5

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }
- (CGFloat)ovalRadius { return [self cornerRadius] * 2.0; }
- (CGFloat)shapeStrokeWidth { return self.bounds.size.height * SHAPE_STROKE_WIDTH_FACTOR; }

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  // Drawing code
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
  
  [roundedRect addClip];
  
  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);
  
  [[UIColor blackColor] setStroke];
  [roundedRect stroke];
  
  [self.color setStroke];
  for (NSValue *rectValue in [self rectsToDrawShapesIn]) {
    CGRect rect = [rectValue CGRectValue];
    [self drawSingleShapeInRect:rect];
  }
  
  self.alpha = self.isFadedOut ? FADED_OUT_ALPHA : 1;
}

- (NSArray *) rectsToDrawShapesIn {
  NSMutableArray *rects = [[NSMutableArray alloc] init];
  CGFloat unitWidth = self.frame.size.width * SHAPE_SCALE_FACTOR_WIDTH;
  CGFloat unitHeight = self.frame.size.height * SHAPE_SCALE_FACTOR_HEIGHT;
  CGFloat unitOriginX = (self.frame.size.width / 2.0) - (unitWidth / 2.0);
  CGFloat allUintsHeight = unitHeight * self.count;
  CGFloat allUnitsOriginY = (self.frame.size.height / 2.0) - (allUintsHeight / 2.0);
  for (int i = 0; i < self.count; i++) {
    CGRect rect = CGRectMake(unitOriginX, allUnitsOriginY + (unitHeight * i), unitWidth, unitHeight);
    [rects addObject:[NSValue valueWithCGRect:rect]];
  }
  return [rects copy];
}

- (void) drawSingleShapeInRect:(CGRect)rect{
  CGFloat marginX = rect.size.width * SHAPE_MARGIN_X_FACTOR;
  CGFloat marginY = rect.size.height * SHAPE_MARGIN_Y_FACTOR;
  rect = CGRectInset(rect, marginX, marginY);
  switch (self.shape) {
    case squiggle:
      [self drawSquiggleInRect:rect];
      break;
    case diamond:
      [self drawDiamondInRect:rect];
      break;
    case oval:
      [self drawOvalInRect:rect];
      break;
    default:
      break;
  }
}

- (void) drawOvalInRect:(CGRect)rect {
  UIBezierPath *oval = [UIBezierPath bezierPathWithRoundedRect:rect
                                                  cornerRadius:[self ovalRadius]];
  [oval setLineWidth:[self shapeStrokeWidth]];
  [oval stroke];
  [self fillSetShape:oval];
}

- (void) drawDiamondInRect:(CGRect)rect {
  [self.color setStroke];
  
  UIBezierPath *diamond = [[UIBezierPath alloc] init];
  [diamond moveToPoint:CGPointMake(rect.origin.x + (rect.size.width/2.0), rect.origin.y)];
  [diamond addLineToPoint:CGPointMake(rect.origin.x + rect.size.width,
                                      rect.origin.y + (rect.size.height/2))];
  [diamond addLineToPoint:CGPointMake(rect.origin.x + (rect.size.width/2.0),
                                      rect.origin.y + rect.size.height)];
  [diamond addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y + (rect.size.height/2))];
  [diamond closePath];
  
  [diamond setLineWidth:[self shapeStrokeWidth]];
  [diamond stroke];
  [self fillSetShape:diamond];
}

- (void) drawSquiggleInRect:(CGRect)rect {
  UIBezierPath *squiggle = [[UIBezierPath alloc] init];
  CGFloat controlOffset = rect.size.width * SQUIGGLE_CONTROL_POINT_OFFSET_FACTOR;
  CGFloat cornerXOffset = rect.size.width * SQUIGGLE_CORNER_X_OFFSET_FACTOR;
  CGFloat cornerYOffset = rect.size.height * SQUIGGLE_CORNER_Y_OFFSET_FACTOR;
  CGPoint corner0 = CGPointMake(rect.origin.x + cornerXOffset, rect.origin.y + cornerYOffset);
  CGPoint corner1 = CGPointMake(rect.origin.x + rect.size.width - cornerXOffset,
                                rect.origin.y + cornerYOffset);
  CGPoint corner2 = CGPointMake(rect.origin.x + rect.size.width - cornerXOffset,
                                rect.origin.y + rect.size.height - cornerYOffset);
  CGPoint corner3 = CGPointMake(rect.origin.x + cornerXOffset,
                                rect.origin.y + rect.size.height - cornerYOffset);
  
  [squiggle moveToPoint:corner0];
  [squiggle addCurveToPoint:corner1
              controlPoint1:CGPointMake(corner0.x + controlOffset, corner0.y - controlOffset)
              controlPoint2:CGPointMake(corner1.x - controlOffset, corner1.y + controlOffset)];
  [squiggle addCurveToPoint:corner2
              controlPoint1:CGPointMake(corner1.x + controlOffset, corner1.y - controlOffset)
              controlPoint2:CGPointMake(corner2.x + controlOffset, corner2.y - controlOffset)];
  [squiggle addCurveToPoint:corner3
              controlPoint1:CGPointMake(corner2.x - controlOffset, corner2.y + controlOffset)
              controlPoint2:CGPointMake(corner3.x + controlOffset, corner3.y - controlOffset)];
  [squiggle addCurveToPoint:corner0
              controlPoint1:CGPointMake(corner3.x - controlOffset, corner3.y + controlOffset)
              controlPoint2:CGPointMake(corner0.x - controlOffset, corner0.y + controlOffset)];
  [squiggle closePath];
  
  [squiggle setLineWidth:[self shapeStrokeWidth]];
  [squiggle stroke];
  [self fillSetShape:squiggle];

}


- (void) fillSetShape:(UIBezierPath *)bezierPath {
  [self.color setFill];
  switch (self.shading) {
    case solid:
      [bezierPath fill];
      break;
    case striped:
      [self fillSetShape:bezierPath
         withStripeWidth:(bezierPath.bounds.size.width * STRIPE_TO_WIDTH_RATIO)
       andStripeDistance:(bezierPath.bounds.size.width * STRIPE_TO_WIDTH_RATIO * 4)];
      break;
    case none:
    default:
      break;
  }
}

// have I officially learned categories this would have been a category method of UIBezierPath
- (void) fillSetShape:(UIBezierPath *)bezierPath
     withStripeWidth:(CGFloat)stripeWidth
    andStripeDistance:(CGFloat)stripeDistance{
  CGContextSaveGState(UIGraphicsGetCurrentContext());
  
  [bezierPath addClip];
  
  [self.color setStroke];
  UIBezierPath *stripes = [[UIBezierPath alloc] init];
  for (CGFloat deltaX = 0.0; deltaX <= bezierPath.bounds.size.width; deltaX += stripeDistance) {
    [stripes moveToPoint:CGPointMake(bezierPath.bounds.origin.x + deltaX,
                                     bezierPath.bounds.origin.y)];
    [stripes addLineToPoint:CGPointMake(bezierPath.bounds.origin.x + deltaX,
                                        bezierPath.bounds.origin.y + bezierPath.bounds.size.height)];
  }
  
  [stripes setLineWidth:stripeWidth];
  [stripes stroke];
  
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}



#pragma mark - Initialization

- (void)setup
{
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
  [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  [self setup];
  return self;
}

@end

