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

				To release a new version, add a git tag of the form: 
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
 
	@bugs		The Run Script which genreates the header files doesn't yet know
					how to parse the tag message (comment) field, so this class
					shows null strings for the Life Cycle values.
*/


@implementation VersionXController

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
	
	// Assemble the version strings we want to use for display in the About panel...

	// read the current application name from the dictionary...
	NSString* xversionappname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
	NSLog(@"VersionX App Name: %@", xversionappname);
	
	// Customize this!
	// assemble the "Marketing Version" e.g. "Safari 2.1"
	NSString *myApplicationVersion = [NSString stringWithFormat:@"%@ %@ %@%@", xversionappname, VERSION_X_SHORT, VERSION_X_LIFECYCLE_SHORT, VERSION_X_COMMIT_COUNT];
	
	// Customize this!
	// assemble the "Build Version" 
	NSString *myVersion = [NSString stringWithFormat:@"%@:%@ \"%@\"", VERSION_X_COMMIT_SHORT, VERSION_X_COMMIT_COUNT, VERSION_X_COMMIT_STATUS ];

	//	if(myVersion) { 
	//	[options  addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys: myAboutVersion, @"Version", nil]]; 
	//} 

	NSMutableDictionary* options  = [[NSMutableDictionary alloc] init];
	if(myVersion && myApplicationVersion){ 		
		[options addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys: 
					myApplicationVersion, @"ApplicationVersion",
					myVersion, @"Version", 
					nil]]; 
	}
	
	
#ifdef DEBUG
	// adding (DEBUG) after the app name in a Debug build, should be abstracted
	
	//then write it back, appending " (DEBUG)"
	NSString *xversionappnamedebug = [NSString stringWithFormat:@"%@ (DEBUG)", xversionappname];
	NSLog(@"VersionX App Name for build styles other than Release: %@", xversionappnamedebug);
	[options  addEntriesFromDictionary:[[NSDictionary alloc] initWithObjectsAndKeys: xversionappnamedebug, @"ApplicationName", nil]]; 
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


@end
