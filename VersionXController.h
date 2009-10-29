//
//  VersionXController.h
//  VersionX
//
//  Created by Gary W. Longsine on 10/25/09.
//  Copyright 2009 illumineX, inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VersionXController : NSObject {
	IBOutlet NSFormCell* myVersionField; // this isn't one of the macros, it's the constructed Build Version
    IBOutlet NSFormCell* branchField;
    IBOutlet NSFormCell* commitTagField;
    IBOutlet NSFormCell* commitCountField;
    IBOutlet NSFormCell* commitShortField;
    IBOutlet NSFormCell* commitLongField;
    IBOutlet NSFormCell* versionShortField;
    IBOutlet NSFormCell* versionLongField;
    IBOutlet NSFormCell* buildCountField;
    IBOutlet NSFormCell* buildDateField;
    IBOutlet NSFormCell* lifecycleFamilyField;
    IBOutlet NSFormCell* lifecycleShortField;
    IBOutlet NSFormCell* lifecycleLongField;
    IBOutlet NSFormCell* commitStatusField;
    IBOutlet NSFormCell* commitStatusShortField;
    IBOutlet NSTextView* commitStatusLongView;
	
	// to wire up display of the Version Detail Sheet
    IBOutlet id versionDetailSheet;
    IBOutlet id mainWindow;
	
}


// In addition to the accessors for each bit bit of data from the repositories, 
//		we want a few methods to support easy integration with custom About panels
- (NSString *)vxFullVersion; // don't customize this method
- (NSString *)vxMarketingVersion; // Customize this!
- (NSString *)vxBuildVersion; // Customize this!

// This method translates to fancy greek letters for display
- (NSString *)lifecycleFancyAbbreviation:lifecycleShort;

- (IBAction)showAboutPanel:(id)sender; 

// for the Version Detail Sheet
- (IBAction)showVersionDetailSheet:(id)sender;
- (IBAction)doneShowingVersionDetailSheet:(id)sender;


@property(readonly, copy) NSString* branch;
@property(readonly, copy) NSString* commitTag;
@property(readonly, copy) NSString* commitCount;
@property(readonly, copy) NSString* commitShort;
@property(readonly, copy) NSString* commitLong;
@property(readonly, copy) NSString* versionShort;
@property(readonly, copy) NSString* versionLong;
@property(readonly, copy) NSString* buildCount;
@property(readonly, copy) NSString* buildDate;
@property(readonly, copy) NSString* lifecycleFamily;
@property(readonly, copy) NSString* lifecycleShort;
@property(readonly, copy) NSString* lifecycleLong;
@property(readonly, copy) NSString* commitStatus;
@property(readonly, copy) NSString* commitStatusShort;
@property(readonly, copy) NSString* commitStatusLong;


@end
