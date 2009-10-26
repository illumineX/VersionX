//
//  VersionXController.h
//  VersionX
//
//  Created by Gary W. Longsine on 10/25/09.
//  Copyright 2009 illumineX, inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VersionXController : NSObject {
}
- (NSString *)lifecycleFancyAbbreviation:(NSString *)lifecycleShort;
- (IBAction)showAboutPanel:(id)sender; 
@end
