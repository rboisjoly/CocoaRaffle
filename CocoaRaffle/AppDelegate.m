//
//  AppDelegate.m
//  CocoaRaffle
//
//  Created by Renaud Boisjoly on 2013-11-12.
//  Copyright (c) 2013 Lagente. All rights reserved
//

#import "AppDelegate.h"
#import "LSPlayer.h"
#import "LSPrize.h"
#import <QuartzCore/QuartzCore.h>
#include <stdlib.h>

#define ARC4RANDOM_MAX      0x100000000


@interface AppDelegate ()
{
    int _whichMarqueeImage;
    int _randomCount;

}
@property (nonatomic,strong) LSPlayer *currentWinner;
@property (nonatomic,strong) LSPrize *currentPrize;

@property (nonatomic,strong) NSMutableArray *allPlayers;
@property (nonatomic,strong) NSMutableArray *remainingPlayers;
@property (nonatomic,strong) NSMutableArray *allWinners;

@property (nonatomic,strong) NSMutableArray *allPrizes;
@property (nonatomic,strong) NSMutableArray *remainingPrizes;
@property (nonatomic,strong) NSArray *allMarqueeImages;


@end
@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    self.window.backgroundColor = [NSColor whiteColor];
    _whichMarqueeImage = 0;
    
    //Build marquee images
    [self buildMarquee];
    [self startMarquee];
    
    //Create prizes:
    [self.participants setStringValue: NSLocalizedString(@"Standing by",@"Standing by message")];
    [self.winnerField setStringValue:NSLocalizedString(@"And the winner is…",@"String before a name is drawn")];
    [self createPrizes];
    [self.prizesLeftField setStringValue:[NSString stringWithFormat:NSLocalizedString(@"Prizes remaining: %lu",@"Prizes remaining strinag"),(unsigned long)[self.remainingPrizes count]]];

    
    //Create a CAAnim
    CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [fullRotation setFromValue:[NSNumber numberWithFloat:0]];
    [fullRotation setToValue:[NSNumber numberWithFloat:((10*M_PI)/180)]];
    [fullRotation setDuration:0.6];
    fullRotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.hostHeadImage setWantsLayer:YES];
    fullRotation.repeatCount = HUGE_VALF;
    fullRotation.autoreverses = YES;
    
    [[self.hostHeadImage layer] addAnimation:fullRotation forKey:@"transform.rotation"];

    
    self.allWinners = [NSMutableArray array];
}

-(void)startMarquee {
  [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateMarquee) userInfo:nil repeats:YES];

}

-(void)updateMarquee {
    
    [self.marqueeImageView setImage:[self.allMarqueeImages objectAtIndex:_whichMarqueeImage]];
    _whichMarqueeImage ++;
    if (_whichMarqueeImage > 2) _whichMarqueeImage = 0;
}

//Method for reading participants
-(void)createParticipantsFromFile {
    
	NSString *filePath = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop/CocoaHeadsMontralNov12Raffle.csv"]];

    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    NSError *theError;
    NSString* fileContents = [NSString stringWithContentsOfURL:fileURL encoding:NSISOLatin1StringEncoding error:&theError];
    
    NSLog(@"Error: %@",[theError localizedDescription]);

    NSArray* rows = [fileContents componentsSeparatedByString:@"\n"];
    for (NSString *thisRow in rows) {
        if ([rows indexOfObject:thisRow] > 0) {
            
            //Create a person
            NSArray *columns = [thisRow componentsSeparatedByString:@","];
            if ([columns count] > 1) {
                LSPlayer *thisPlayer = [[LSPlayer alloc] init];
                
                thisPlayer.name = [NSString stringWithFormat:@"%@ %@",[columns objectAtIndex:4],[columns objectAtIndex:5]];
                thisPlayer.email = [columns objectAtIndex:6];
                [self.allPlayers addObject:thisPlayer];
            }
    }
        //NSLog(@"Created players: %@",self.allPlayers);
        self.remainingPlayers = [self.allPlayers mutableCopy];
        [self.participants setStringValue:[NSString stringWithFormat:NSLocalizedString(@"Loaded %lu participants",@"Participants loaded string"),(unsigned long)[self.allPlayers count]]];
    }
}

-(void)buildMarquee {
    NSImage *image1 = [NSImage imageNamed:@"marquee_1"];

    NSImage *image2 = [NSImage imageNamed:@"marquee_2"];

    NSImage *image3 = [NSImage imageNamed:@"marquee_3"];
    
    self.allMarqueeImages = [NSArray arrayWithObjects:image1,image2,image3, nil];
    
}


- (IBAction)loadParticipantsList:(id)sender {
    [self createParticipantsFromFile];
}

- (IBAction)killComicSans:(id)sender {
    //Do what it takes to change the font
    NSFont *betterFont = [NSFont fontWithName:@"Curlz MT" size:50];
    self.bigTitle.font = betterFont;
    [self.noComicSansImageView setHidden:YES];
}

- (IBAction)nextPrize:(id)sender {
    LSPrize *thisPrize = [self.remainingPrizes firstObject];
    self.prizeImageView.image = thisPrize.icon;
    [self.winnerField setStringValue:NSLocalizedString(@"And the winner is…",@"String before a name is drawn")];
    
}

- (IBAction)drawWinner:(id)sender {
    if ([self.allPlayers count] == 0) {
        NSLog(@"NO PLAYERS, should display an alert here, or simply try to load players from the file");
    } else {
    
        //Pick a prize winner randomly
        NSUInteger countPlayers = [self.remainingPlayers count] ;
        int r = arc4random_uniform((int)countPlayers);
        self.currentWinner = [self.remainingPlayers objectAtIndex:r];
        //NSLog(@"winner: %@",[self.allPlayers objectAtIndex:r]);
    
    //Display winner
        _randomCount = (int)self.allPlayers.count -1;
        [self displayNextRandomPlayer];
        
    //Change string
    
    //store in prefs
        
    }
}

-(void)displayWinner {
    self.currentPrize = [self.remainingPrizes firstObject];
    [self.remainingPrizes removeObjectAtIndex:0];
    [self.winnerField setStringValue:self.currentWinner.name];
    
    
    [self.allWinners addObject:@{@"winnerName:":self.currentWinner.name,
                                 @"winnerEmail":self.currentWinner.email,
                                 @"prize":self.currentPrize.name}];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask,
                                                              YES) objectAtIndex:0];
    NSString *plistPath = [rootPath
                           stringByAppendingPathComponent:@"Winners.plist"];
    //NSLog(@"Winners: %@",self.allWinners);
    if ([self.allWinners writeToFile:plistPath atomically:YES]) {
        NSLog(@"Winners written to file");
    } else {
        NSLog(@"Not written");
    }
    
    [self.remainingPlayers removeObject:self.currentWinner];
    [self.prizesLeftField setStringValue:[NSString stringWithFormat:NSLocalizedString(@"Prizes remaining: %lu",@"Prizes remaining strinag"),(unsigned long)[self.remainingPrizes count]]];

    
}

-(void)displayNextRandomPlayer {
    //get the next name and set the string, then call the ended draw

    if (_randomCount == 0) {
        [self displayWinner];
    } else {
        [self.winnerField setStringValue:[(LSPlayer *)[self.allPlayers objectAtIndex:_randomCount] name]];
        _randomCount--;
        [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(displayNextRandomPlayer) userInfo:nil repeats:NO];
    }
}

-(void)createPrizes {
    NSArray *allPrizeDefss = [@[@{@"name":@"PinPoint", @"image":@"pp.png"},
                                @{@"name":@"PinPoint", @"image":@"pp.png"},
                                @{@"name":@"PinPoint", @"image":@"pp.png"},
                                @{@"name":@"PinPoint Pro", @"image":@"pppro.png"},
                                @{@"name":@"PinPoint Pro", @"image":@"pppro.png"},
                                @{@"name":@"PinPoint Pro", @"image":@"pppro.png"},
                                @{@"name":@"Spark Inspector", @"image":@"spark.png"},
                                @{@"name":@"Reveal", @"image":@"reveal.png"}] mutableCopy];

    for (NSDictionary *thisDef in allPrizeDefss) {
        LSPrize *thisPrize = [[LSPrize alloc] init];
        thisPrize.name = [thisDef objectForKey:@"name"];
        thisPrize.icon = [NSImage imageNamed:[thisDef objectForKey:@"image"]];
        [self.allPrizes addObject:thisPrize];
    }
    //NSLog(@"Created prizes: %@",self.allPrizes);
    self.remainingPrizes = [self.allPrizes mutableCopy];
}


#pragma mark - lazy getters

-(NSMutableArray *)allPlayers {
    if (!_allPlayers) {
        _allPlayers = [[NSMutableArray alloc] init];
    }
    return _allPlayers;
}

-(NSMutableArray *)allPrizes {
    if (!_allPrizes) {
        _allPrizes = [[NSMutableArray alloc] init];
    }
    return _allPrizes;
}
@end
