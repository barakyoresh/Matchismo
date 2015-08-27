//
//  InsetGrid.h
//  Matchismo
//
//  Created by Barak Yoresh on 8/25/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "Grid.h"

// override to course's grid makeing grid frames have small margins for aesthetic purposes
@interface InsetGrid : Grid

- (CGSize)insetCellSize;

@property (nonatomic) CGFloat insetValueX;

@property (nonatomic) CGFloat insetValueY;

@end
