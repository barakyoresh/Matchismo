//
//  MovesHistoryViewController.m
//  Matchismo
//
//  Created by Barak Yoresh on 8/20/15.
//  Copyright (c) 2015 Barak Yoresh. All rights reserved.
//

#import "MovesHistoryViewController.h"

@interface MovesHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *body;
@end

@implementation MovesHistoryViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  //concat history log
  NSMutableAttributedString *history = [[NSMutableAttributedString alloc] initWithString:@""];
  for (NSAttributedString* moveEntry in self.moveHistory) {
    [history appendAttributedString:moveEntry];
    [history appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" ]];
  }
  [self.body setAttributedText:history];
}


@end
