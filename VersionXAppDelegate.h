//
//  VersionXAppDelegate.h
//  VersionX
//
//  Created by Gary W. Longsine on 10/25/09.
//  Copyright 2009 illumineX, inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VersionXAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *__unsafe_unretained window;
}

@property (unsafe_unretained) IBOutlet NSWindow *window;

@end
