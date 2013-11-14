//
//  AppDelegate.h
//  CocoaRaffle
//
//  Created by Renaud Boisjoly on 2013-11-12.
//  Copyright (c) 2013 Lagente. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic,strong) NSMutableArray *allPlayers;
@property (nonatomic,strong) NSMutableArray *remainingPlayers;
@property (nonatomic,strong) NSMutableArray *allWinners;

@property (nonatomic,strong) NSMutableArray *allPrizes;
@property (nonatomic,strong) NSMutableArray *remainingPrizes;
@property (nonatomic,strong) NSArray *allMarqueeImages;



@property (weak) IBOutlet NSTextField *participants;
@property (weak) IBOutlet NSTextField *bigTitle;
@property (weak) IBOutlet NSImageView *marqueeImageView;
@property (weak) IBOutlet NSTextField *winnerField;
@property (weak) IBOutlet NSImageView *prizeImageView;
@property (weak) IBOutlet NSImageView *noComicSansImageView;
@property (weak) IBOutlet NSButton *hostHeadImage;
@property (weak) IBOutlet NSTextField *prizesLeftField;


- (IBAction)loadParticipantsList:(id)sender;
- (IBAction)killComicSans:(id)sender;
- (IBAction)nextPrize:(id)sender;
- (IBAction)drawWinner:(id)sender;

@end
