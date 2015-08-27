//
//  InsetGrid.m
//  Matchismo
//
//  Created by Barak Yoresh on 8/25/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "InsetGrid.h"

@implementation InsetGrid

// note that due to implementation desicions this is inconsistant with cell size, cell size is infact
// off by this object's inset values.
- (CGRect)frameOfCellAtRow:(NSUInteger)row inColumn:(NSUInteger)column {
  return CGRectInset([super frameOfCellAtRow:row inColumn:column], self.insetValueX, self.insetValueY);
}

- (CGSize)insetCellSize {
  CGSize superCellSize = [super cellSize];
  return CGSizeMake(superCellSize.width - self.insetValueX * 2,
                    superCellSize.height - self.insetValueY * 2);
}
@end
