//
//  CustomCamera.m
//  Gaika_iPhone
//
//  Created by Josu Igoa on 30/05/13.
//  Copyright (c) 2013 Josu Igoa. All rights reserved.
//

#import "CustomCamera.h"

@implementation CustomCamera

-(void) dealloc
{
    [super dealloc];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
    // override the touches ended method
    // so tapping the screen will take a picture
    [self takePicture];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void) viewDidAppear: (BOOL)animated
{
    [super viewDidAppear:animated];
}

@end