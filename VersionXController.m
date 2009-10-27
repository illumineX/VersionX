//
//  VersionXController.m
//  VersionX
//
//  Created by Gary W. Longsine on 10/25/09.
//  Copyright 2009 illumineX, inc.. All rights reserved.
//

#import "VersionXController.h"
#import "VersionX-revision.h"  // this is the build-time generated revision info header

/*!
    @class		VersionXController
    @abstract   Controller for version information, gathered automatically at build time.
    @discussion  The VersionXController class initially provides a simple demonstration 
					which works with the standard Mac OS X "About Panel" for a Cocoa 
					Application project.  

				To release a new version, add a git tag using a simple naming convention:
 
 % git tag -a v0.0.1 -m ":Product Family:Life Cycle Stage:LCS: Any additional message or comment... " 
 
	Product Family
	This is a marketing or code name "Snow Leopeord" or "Cairo"
	
	Life Cycle Stage:LCS
	This is a name for which stage of the lifecycle the build falls into, 
	followed by a short abbreviation for it.
		Development:x
		Experimental:x
		Alpha:a
		Beta:b
		Release Candidate:RCS
		General Availability:GA
 
		Stable:s
		Unstable:u
 
					v1.2.3
				then build. The system will handle more or fewer digits, such as v1.2, or
				v1.2.3.4, or for example, in a reasonable way.
 
				The components of the versioning system include:
				- A build target with a Run Script to generate a prefix header,
					using information gathered from the revision control system 
					at build time.
				- Build settings including placeholders for the preprocessor 
				- VersionX-revision.h file (generated at build time)

 
				It works by importing macro definitions from 
					the generated file VersionX-revision.h, which in turn is created
					by a Run Script in a Build Target.  The application main build target
					must include the VersionX build target, and also have this file 
					identified in it's build settings, and have the preprocessor for
					the Info.plist turned on. 

	@todo		This class should be extended to provide methods which allow you to 
					ask for version information, rather than including the header file.
					This strategy would allow for easier integration into applications 
					which use custom About panels.
 
*/


@implementation VersionXController
/*!
    @method     lifecycleFancyAbbreviation:
    @abstract   Receive a VERSION_X_LIFECYCLE_SHORT string and send back the fancy greek letter representing the lifecycle stage
    @discussion VersionX provides support for the concept of software lifecycle. By following a 
	simple convention for tagging a release, you can automatically generate version numbers
	in your about panel which include lifecycle stage information, such as:
 
		Safari 4.1 α37			<-- alpha 37
		Safari 4.1 β1			<-- beta 1
		iChat 3.2 δ88			<-- delta / sigma signifying unstable/stable
		
 
 Although there exist a great many variations on the concept, and a mindboggling array 
  of different release practices, there are two comonly used conventions for the
  stages of software lifecycle.  
 
	Stable / Unstable
	Experimental / Alpha / Beta / Release Candidate / General Availability 
 
 The VersionXController will translate from ascii symbols representing 
  the lifecycle stages in the tag message, into fancy greek symbols suitable for display 
  in your Application's About Panel.

		xversionlifecyclestage  should be one of: 
			UNSET						?		λ  // Lambda - In formal language theory and computer science, the empty string.
			Development/Experimental	DEV	/	χ
			Alpha/Unstable				a	/	α  
			Beta/Stable					b	/	β
			Release Candiate			RC
			Release to Manufacturing	RTM
			General Availability		GA

			Stable						s		σ	Sigma  (signifies "quality")
			Unstable					u		δ	Delta (signifies "change")

	@todo:  the labels for life cycle stages should be enforced by the tool chain
			probably via a command line tool conceptually similar to agvtool, and accompanying GUI
*/
- (NSString *)lifecycleFancyAbbreviation:(NSString *)lifecycleShort {
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSString *lambda = @"λ";
	
	// if the Life Cycle abbreviation is either "UNSET" or blank, should hand back Lamda @"λ"

	if (([lifecycleShort length] == 0) || (lifecycleShort == @"UNSET")) {
		return lambda;
	}
	// if the Life Cycle abbreviation appears in our table as a key, hand back the fancy greek letter value

	else if(lifecycleShort){ 		
		NSMutableDictionary* fancyStages  = [[[NSMutableDictionary alloc] init] autorelease];
		[fancyStages addEntriesFromDictionary:[[[NSDictionary alloc] initWithObjectsAndKeys: 
											@"λ", @"?", // unknown (how to indicate a Lambda at tag time)
											@"χ", @"x", // experimental
											@"χ", @"dev", // experimental
											@"χ", @"devel", // experimental
											@"α", @"a", // alpha
											@"β", @"b", // beta
											@"χ", @"X", // experimental
											@"α", @"A", // alpha
											@"β", @"B", // beta
											
											// open-source-style stable / unsable branches 
											@"δ", @"u", // unstable
											@"σ", @"s", // stable
											@"Δ", @"U", // Unstable
											@"Σ", @"S", // Stable 
											
											// Easer eggs, loosely justified on the basis of an alpha/mu/omega concept for stage names)
											@"μ", @"moo", // Μμ (for sra, and pohl, for different reasons)
											@"Μ", @"MOO", // Μμ
											@"ω", @"o",		// omega
											@"Ω", @"O",		// Omega
											nil] autorelease]]; 
		NSString* lifecycleShortFancy = [fancyStages objectForKey: lifecycleShort];
#if DEBUG
		NSLog(@"lifecycleFancyAbbreviation from: %@ to %@", lifecycleShort, lifecycleShortFancy);
#endif
		return lifecycleShortFancy;
	}
	else {
		// Customize this!
		// if the Life Cycle abbreviation arrived set to anything else at tag time, we have a choice to make.
		// or hand it back, unchanged (they might have their own convention)
		// return lifecycleShort;
		// set it to lambda to enforce use of a commonly recognized convention 
		[pool drain];
		return lambda;
	}
}

- (IBAction)showAboutPanel:(id)sender { 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// Read the two version keys from the application's info.plist like this:
	
	// Apple documentation calls this the "Build Version" but the specifics are ambiguous 
	// This should be equivalent to (and originally created by) the macro VERSION_X_LONG
	NSString* applebuildversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]; 
	
	// Apple documentation calls this the "Marketing Version" aka the "2.1" in "MyProduct 2.1"
	// This should be equivalent to (and originally created by) the macro VERSION_X_SHORT
	NSString* applemarketingversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; 
	
#if DEBUG
	
	// Now we can use the strings, like so...
	NSLog(@"Info.plist Build Version (long): %@", applebuildversion); // fetched from Info.plist
	NSLog(@"Info.plist Marketing Version (short): %@", applemarketingversion); // fetch from Info.plist
	
	
	// The macros are available to use in any class where you import "VersionX-revision.h" (as does the header file for this class).
	NSLog(@"VersionX Branch: %@", VERSION_X_BRANCH);
	NSLog(@"VersionX Commit Tag: %@", VERSION_X_COMMIT_TAG);
	NSLog(@"VersionX Commit Short: %@", VERSION_X_COMMIT_SHORT);
	NSLog(@"VersionX Commit Long: %@", VERSION_X_COMMIT_LONG);
	NSLog(@"VersionX Commit Count: %@", VERSION_X_COMMIT_COUNT);
	NSLog(@"VersionX Version Short: %@", VERSION_X_SHORT);
	NSLog(@"VersionX Version Long: %@", VERSION_X_LONG);
	NSLog(@"VersionX Build Count: %@", VERSION_X_BUILD_COUNT);
	
	// internal code name or cute marketing name for a branch - "Cute Fluffy Bunny" or "Snow Leopard"
	NSLog(@"VersionX Product Family (Code Name): %@", VERSION_X_FAMILY);
	NSLog(@"VersionX LifeCycle Stage: %@", VERSION_X_LIFECYCLE_LONG);
	NSLog(@"VersionX LifeCycle Stage Abbreviation: %@", VERSION_X_LIFECYCLE_SHORT);
	
	// Derive the lifecycle string you want to use, like this:
	NSLog(@"%@%@", VERSION_X_LIFECYCLE_SHORT, VERSION_X_COMMIT_COUNT);  // yeilds something like:  α42
	
	// was this build performed on a clean working copy ("Clean"), or do uncommitted changes exist ("Grungy")?
	NSLog(@"VersionX Commit Status: %@", VERSION_X_COMMIT_STATUS);
	NSLog(@"VersionX Commit Status Short: %@", VERSION_X_COMMIT_STATUS_SHORT);
	NSLog(@"VersionX Commit Status Long: %@", VERSION_X_COMMIT_STATUS_LONG);	
#endif

	// translate the Life Cycle Abreviation into fancy greek for display 
	NSString* myLifeCycleAbreviation = [self lifecycleFancyAbbreviation:VERSION_X_LIFECYCLE_SHORT];
	
	// Assemble the version strings we want to use for display in the About panel...

	// read the current application name from the dictionary...
	NSString* xversionappname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
	NSLog(@"VersionX App Name: %@", xversionappname);
	
	// Customize this!
	// assemble the "Marketing Version" e.g. "Safari 2.1 β42"
	NSString *myApplicationVersion = [NSString stringWithFormat:@"%@ %@ %@%@", xversionappname, VERSION_X_SHORT, myLifeCycleAbreviation, VERSION_X_COMMIT_COUNT];
	
	// Customize this!
	// assemble the "Build Version" e.g. (61f95c8:12 "Dirty")
	NSString *myVersion = [NSString stringWithFormat:@"%@:%@ \"%@\"", VERSION_X_COMMIT_SHORT, VERSION_X_COMMIT_COUNT, VERSION_X_COMMIT_STATUS ];

	//	if(myVersion) { 
	//	[options  addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys: myAboutVersion, @"Version", nil]]; 
	//} 

	NSMutableDictionary* options  = [[[NSMutableDictionary alloc] init] autorelease];
	if(myVersion && myApplicationVersion){ 		
		[options addEntriesFromDictionary:[[[NSDictionary alloc] initWithObjectsAndKeys: 
					myApplicationVersion, @"ApplicationVersion",
					myVersion, @"Version", 
					nil] autorelease]]; 
	}
	
	
#ifdef DEBUG
	// adding (DEBUG) after the app name in a Debug build, should be abstracted
	
	//then write it back, appending " (DEBUG)"
	NSString *xversionappnamedebug = [NSString stringWithFormat:@"%@ (DEBUG)", xversionappname];
	NSLog(@"VersionX App Name for build styles other than Release: %@", xversionappnamedebug);
	[options  addEntriesFromDictionary:[[[NSDictionary alloc] initWithObjectsAndKeys: xversionappnamedebug, @"ApplicationName", nil] autorelease]]; 
#endif 
	
#if DEBUG
	// print all key-value pairs from the dictionary
	NSLog (@"The dictionary for the About panel contains the following key pairs:\n");
	for ( NSString *key in options )
		NSLog (@"%@\t\t%@", key, [options  objectForKey: key]);
#endif
	
	
	// [NSApp orderFrontStandardAboutPanelWithOptions:options ]; 	
	[[NSApplication sharedApplication] orderFrontStandardAboutPanelWithOptions:options];
	[pool drain];
	return;
} 

/*!
    @method     - (IBAction)showVersionDetailSheet:(id)Sender
    @abstract   Display the full set of version information on a sheet.
    @discussion IBOutlets were declared in the VersionXController.h,
					which we can use here to display the full set of information which
					was collected at build time.  
*/
- (IBAction)showVersionDetailSheet:(id)Sender {
	[myVersionField setStringValue: @"Not Yet Implemented"];
	[branchField setStringValue: VERSION_X_BRANCH];
	[commitTagField setStringValue: VERSION_X_COMMIT_TAG];
	[commitCountField setStringValue: VERSION_X_COMMIT_COUNT];
	[commitShortField setStringValue: VERSION_X_COMMIT_SHORT];
	[commitLongField setStringValue: VERSION_X_COMMIT_LONG];
	[versionShortField setStringValue: VERSION_X_SHORT];
	[versionLongField setStringValue: VERSION_X_LONG];
	[buildDateField setStringValue: VERSION_X_BUILD_DATE];
	[buildCountField setStringValue: VERSION_X_BUILD_COUNT];
	[lifecycleLongField setStringValue: VERSION_X_LIFECYCLE_LONG];
	[lifecycleShortField setStringValue: VERSION_X_LIFECYCLE_SHORT];
	[lifecycleFamilyField setStringValue: VERSION_X_FAMILY];
	[commitStatusField setStringValue: VERSION_X_COMMIT_STATUS];
	[commitStatusShortField setStringValue: VERSION_X_COMMIT_STATUS_SHORT];
	[commitStatusLongView insertText: VERSION_X_COMMIT_STATUS_LONG];
	
	// display the values on the sheet
	[NSApp beginSheet:versionDetailSheet modalForWindow:mainWindow
        modalDelegate:self didEndSelector:NULL contextInfo:nil];

}
// Hide the Version Detail Sheet
- (IBAction)doneShowingVersionDetailSheet:(id)sender {
	[versionDetailSheet orderOut:nil];
    [NSApp endSheet:versionDetailSheet];

}
@end
