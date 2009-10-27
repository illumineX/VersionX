//
//  VersionXController.h
//  VersionX
//
//  Created by Gary W. Longsine on 10/25/09.
//  Copyright 2009 illumineX, inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VersionXController : NSObject {
	IBOutlet NSFormCell	*myVersionField; // this isn't one of the macros, it's the constructed Build Version
	IBOutlet NSFormCell *branchField;
	IBOutlet NSFormCell *commitTagField;
	IBOutlet NSFormCell *commitCountField;
	IBOutlet NSFormCell *commitShortField;
	IBOutlet NSFormCell *commitLongField;
	IBOutlet NSFormCell *versionShortField;
	IBOutlet NSFormCell *versionLongField;
	IBOutlet NSFormCell *buildCountField;
	IBOutlet NSFormCell *buildDateField;
	IBOutlet NSFormCell *lifecycleFamilyField;
	IBOutlet NSFormCell *lifecycleShortField;
	IBOutlet NSFormCell *lifecycleLongField;
	IBOutlet NSFormCell *commitStatusField;
	IBOutlet NSFormCell *commitStatusShortField;
	IBOutlet NSTextView *commitStatusLongView;
	
	// to wire up display of the Version Detail Sheet
    IBOutlet id versionDetailSheet;
    IBOutlet id mainWindow;
	
}
- (NSString *)lifecycleFancyAbbreviation:(NSString *)lifecycleShort;
- (IBAction)showAboutPanel:(id)sender; 

// for the Version Detail Sheet
- (IBAction)showVersionDetailSheet:(id)sender;
- (IBAction)doneShowingVersionDetailSheet:(id)sender;

@end
