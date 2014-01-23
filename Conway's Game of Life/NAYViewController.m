//
//  NAYViewController.m
//  Conway's Game of Life
//
//  Created by Jeff Schwab on 1/23/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYViewController.h"

@interface NAYViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *setupSwitch;
- (IBAction)createLife:(UISwitch *)sender;
@property (nonatomic) NSMutableArray *cells;
@property (nonatomic) NSTimer *lifeTimer;
@end

@implementation NAYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cells = [NSMutableArray new];
    
    UIView *gridContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 650, 650)];
    for (int row = 0; row < 25; row++) {
        for (int col = 0; col < 25; col++) {
            UIButton *cellButton = [[UIButton alloc] initWithFrame:CGRectMake(col*25+1, row*25+1, 23, 23)];
            cellButton.backgroundColor = [UIColor lightGrayColor];
            [self.cells addObject:cellButton];
            [gridContainer addSubview:cellButton];
            [cellButton addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    self.lifeTimer = [[NSTimer alloc] init];
    [self.view addSubview:gridContainer];
    gridContainer.center = self.view.center;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cellSelected:(UIButton *)sender
{
    NSLog(@"%i",[self.cells indexOfObject:sender]);
    if([sender.backgroundColor isEqual:[UIColor blackColor]])
    {
        sender.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
        sender.backgroundColor = [UIColor blackColor];
    }
    
}


- (IBAction)createLife:(UISwitch *)sender
{
    if (sender.isOn) {
        self.lifeTimer = [NSTimer scheduledTimerWithTimeInterval:.1
                                         target:self
                                        selector:@selector(checkLandscape)
                                       userInfo:nil repeats:YES];
    } else {
        [self.lifeTimer invalidate];
        for (UIButton *cell in self.cells) {
            [cell setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
    
}

- (void)checkLandscape
{
    _Bool cellsChanged[625];
    for (int i = 0; i < 625; i++) {
        cellsChanged[i] = false;
    }
    
    for (UIButton *currentCell in self.cells) {
        int cellIndex = [self.cells indexOfObject:currentCell];
        int nNW = cellIndex - 26;
        int nN = cellIndex - 25;
        int nNE = cellIndex - 24;
        int nW = cellIndex - 1;
        int nE = cellIndex + 1;
        int nSW = cellIndex + 24;
        int nS = cellIndex + 25;
        int nSE = cellIndex + 26;
        
        int neighbors[] = {nNW, nN, nNE, nW, nE, nSW, nS, nSE};
        
        int liveNeighbors = 0;
        
        if ([self.cells indexOfObject:currentCell] == 0) {
            int upperLeftNeighbors[] = {nS, nSE, nE};
            for (int i = 0; i < 3; i++) {
                UIButton *currentNeighbor = [self.cells objectAtIndex:upperLeftNeighbors[i]];
                if (currentNeighbor) {
                    //NSLog(@"%i", [self.cells indexOfObject:currentNeighbor]);
                    if ([currentNeighbor.backgroundColor isEqual:[UIColor blackColor]]) {
                        liveNeighbors++;
                    }
                }
            }
        } else if ([self.cells indexOfObject:currentCell] == 24) {
            int upperRightNeighbors[] = {nS, nW, nSW};
            for (int i = 0; i < 3; i++) {
                UIButton *currentNeighbor = [self.cells objectAtIndex:upperRightNeighbors[i]];
                if (currentNeighbor) {
                    //NSLog(@"%i", [self.cells indexOfObject:currentNeighbor]);
                    if ([currentNeighbor.backgroundColor isEqual:[UIColor blackColor]]) {
                        liveNeighbors++;
                    }
                }
            }
        } else if ([self.cells indexOfObject:currentCell] == 600) {
            int lowerLeftNeighbors[] = {nN, nE, nNE};
            for (int i = 0; i < 3; i++) {
                UIButton *currentNeighbor = [self.cells objectAtIndex:lowerLeftNeighbors[i]];
                if (currentNeighbor) {
                    //NSLog(@"%i", [self.cells indexOfObject:currentNeighbor]);
                    if ([currentNeighbor.backgroundColor isEqual:[UIColor blackColor]]) {
                        liveNeighbors++;
                    }
                }
            }
        } else if ([self.cells indexOfObject:currentCell] == 624) {
            int lowerRightNeighbors[] = {nNW, nN, nW};
            for (int i = 0; i < 3; i++) {
                UIButton *currentNeighbor = [self.cells objectAtIndex:lowerRightNeighbors[i]];
                if (currentNeighbor) {
                    //NSLog(@"%i", [self.cells indexOfObject:currentNeighbor]);
                    if ([currentNeighbor.backgroundColor isEqual:[UIColor blackColor]]) {
                        liveNeighbors++;
                    }
                }
            }
        } else if (([self.cells indexOfObject:currentCell] + 1) % 25 == 0) {
            int rightSideNeighbors[] = {nNW, nN, nW, nSW, nS};
            for (int i = 0; i < 5; i++) {
                UIButton *currentNeighbor = [self.cells objectAtIndex:rightSideNeighbors[i]];
                if (currentNeighbor) {
                    //NSLog(@"%i", [self.cells indexOfObject:currentNeighbor]);
                    if ([currentNeighbor.backgroundColor isEqual:[UIColor blackColor]]) {
                        liveNeighbors++;
                    }
                }
            }
        } else if ([self.cells indexOfObject:currentCell] % 25 == 0) {
            int leftSideNeighbors[] = {nN, nNE, nE, nS, nSE};
            for (int i = 0; i < 5; i++) {
                UIButton *currentNeighbor = [self.cells objectAtIndex:leftSideNeighbors[i]];
                if (currentNeighbor) {
                    //NSLog(@"%i", [self.cells indexOfObject:currentNeighbor]);
                    if ([currentNeighbor.backgroundColor isEqual:[UIColor blackColor]]) {
                        liveNeighbors++;
                    }
                }
            }
        } else if ([self.cells indexOfObject:currentCell] > 0 && [self.cells indexOfObject:currentCell] < 24) {
            int topNeighbors[] = {nW, nE, nSW, nS, nSE};
            for (int i = 0; i < 5; i++) {
                UIButton *currentNeighbor = [self.cells objectAtIndex:topNeighbors[i]];
                if (currentNeighbor) {
                    //NSLog(@"%i", [self.cells indexOfObject:currentNeighbor]);
                    if ([currentNeighbor.backgroundColor isEqual:[UIColor blackColor]]) {
                        liveNeighbors++;
                    }
                }
            }
        } else if ([self.cells indexOfObject:currentCell] > 600 && [self.cells indexOfObject:currentCell] < 624) {
            int bottomNeighbors[] = {nNW, nN, nNE, nW, nE};
            for (int i = 0; i < 5; i++) {
                UIButton *currentNeighbor = [self.cells objectAtIndex:bottomNeighbors[i]];
                if (currentNeighbor) {
                    if ([currentNeighbor.backgroundColor isEqual:[UIColor blackColor]]) {
                        liveNeighbors++;
                    }
                }
            }
        } else {
            for (int i = 0; i < 8; i++) {
                UIButton *currentNeighbor = [self.cells objectAtIndex:neighbors[i]];
                if (currentNeighbor) {
                    if ([currentNeighbor.backgroundColor isEqual:[UIColor blackColor]]) {
                        liveNeighbors++;
                    }
                }
            }
        }
    
        if ([currentCell.backgroundColor isEqual:[UIColor blackColor]]) { //live
            if (liveNeighbors == 0 || liveNeighbors == 1 || liveNeighbors > 3) {
                int currentIndex = [self.cells indexOfObject:currentCell];
                cellsChanged[currentIndex] = true;
            } else {
                int currentIndex = [self.cells indexOfObject:currentCell];
                cellsChanged[currentIndex] = false;
            }
        } else {  //dead
            if (liveNeighbors == 3) {
                int currentIndex = [self.cells indexOfObject:currentCell];
                cellsChanged[currentIndex] = true;
            }
        }
    }
    
    for (int i = 0; i < 625; i++) {
        if (cellsChanged[i]) {
            UIButton *changedCell = [self.cells objectAtIndex:i];
            if ([changedCell.backgroundColor isEqual:[UIColor blackColor]]) {
                //[[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [changedCell setBackgroundColor:[UIColor lightGrayColor]];
                    [changedCell setNeedsDisplay];
                //}];
            } else {
                //[[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [changedCell setBackgroundColor:[UIColor blackColor]];
                    [changedCell setNeedsDisplay];
                //}];
            }
        }
    }
}

@end
