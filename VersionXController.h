//
//  VersionXController.h
//  VersionX
//
//  Created by Gary W. Longsine on 10/25/09.
//  Copyright 2009 illumineX, inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VersionXController : NSObject {

	// to wire up the various bits to a form
	// if you want to use individual fields with a text field, 
	// simply change the IBOutlet type to NSTextField
    IBOutlet NSFormCell* buildDateField;
	IBOutlet NSFormCell* buildUserField;
	IBOutlet NSFormCell* buildStyleField;
	IBOutlet NSFormCell* buildArchsField;
    IBOutlet NSFormCell* buildCountField;
    IBOutlet NSFormCell* commitTagField;
    IBOutlet NSFormCell* commitCountField;
    IBOutlet NSFormCell* commitShortField;
    IBOutlet NSFormCell* commitLongField;
    IBOutlet NSFormCell* branchField;
    IBOutlet NSFormCell* lifecycleFamilyField;
    IBOutlet NSFormCell* lifecycleShortField;
    IBOutlet NSFormCell* lifecycleLongField;
    IBOutlet NSFormCell* versionShortField;
    IBOutlet NSFormCell* versionLongField;
    IBOutlet NSFormCell* commitStatusField;
    IBOutlet NSFormCell* commitStatusShortField;
    IBOutlet NSTextView* commitStatusLongView;
	
	// to wire up display of the Version Detail Sheet
    IBOutlet id versionDetailSheet;
    IBOutlet id mainWindow;
	
	// to easily wire up custom about panels
	IBOutlet NSWindow* customAboutPanel;
	IBOutlet NSTextField* fancyApplicationNameField;
	IBOutlet NSTextField* fancyFullVersionField;
	IBOutlet NSTextField* fancyMarketingVersionField;
	IBOutlet NSTextField* fancyBuildVersionField;
}


// In addition to the accessors for each bit bit of data from the repositories, 
//		we want a few methods to support easy integration with custom About panels
- (NSString *)fancyFullVersion; // don't customize this method (it's a convenience method which combines the other two)
- (NSString *)fancyMarketingVersion; // Customize this!
- (NSString *)fancyBuildVersion; // Customize this!

// Return the modified application name, if a non-Release build style
- (NSString *)fancyApplicationName;

// translate to fancy greek letters for display
- (NSString *)lifecycleFancyAbbreviation:lifecycleShort;

// front a Standard About Panel, with fancy version strings
- (IBAction)showAboutPanel:(id)sender; 

// front a Custom About Panel, with fancy version strings
- (IBAction)showCustomAboutPanel:(id)sender; 
- (IBAction)doneShowingCustomAboutPanel:(id)sender; 

// to populate the fieilds when the equivalent showCustomAboutPanel method is in an object other than VersionXController 
-(void) fancyPopulateMyFields;

// for the Version Detail Sheet
- (IBAction)showVersionDetailSheet:(id)sender;
- (IBAction)doneShowingVersionDetailSheet:(id)sender;


@property(readonly, copy) NSString* buildDate;
@property(readonly, copy) NSString* buildUser;
@property(readonly, copy) NSString* buildStyle;
@property(readonly, copy) NSString* buildArchs;
@property(readonly, copy) NSString* buildCount;
@property(readonly, copy) NSString* commitTag;
@property(readonly, copy) NSString* commitCount;
@property(readonly, copy) NSString* commitCountSinceTag;  // derived from commitTag, not it's own macro
@property(readonly, copy) NSString* commitShort;
@property(readonly, copy) NSString* commitLong;
@property(readonly, copy) NSString* branch;
@property(readonly, copy) NSString* lifecycleFamily;
@property(readonly, copy) NSString* lifecycleShort;
@property(readonly, copy) NSString* lifecycleLong;
@property(readonly, copy) NSString* versionShort;
@property(readonly, copy) NSString* versionLong;
@property(readonly, copy) NSString* commitStatus;
@property(readonly, copy) NSString* commitStatusShort;
@property(readonly, copy) NSString* commitStatusLong;


@end
