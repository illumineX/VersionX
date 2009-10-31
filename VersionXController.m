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
// synthesize the accessor methods
@synthesize buildDate;
@synthesize buildUser;
@synthesize buildStyle;
@synthesize buildArchs;
@synthesize buildCount; 
@synthesize branch;
@synthesize commitTag;
@synthesize commitCount;
@synthesize commitShort;
@synthesize commitLong; 
@synthesize lifecycleFamily;
@synthesize lifecycleShort;
@synthesize lifecycleLong;
@synthesize versionShort;
@synthesize versionLong;
@synthesize commitStatus;
@synthesize commitStatusShort;
@synthesize commitStatusLong;


-(void)awakeFromNib {    

	// to easily wire up custom about panels
	/*
	[myFancyApplicationNameField setStringValue: [VersionXController fancyApplicationName] ];
	[myFancyFullVersionField setStringValue: [VersionXController fancyFullVersion] ];
	[myFancyMarketingVersionField setStringValue: [VersionXController fancyMarketingVersion] ];
	[myFancyBuildVersionField setStringValue: [VersionXController fancyBuildVersion] ];
	*/
	
	// display a constructed version string in the application main window
	// (primarily to demonstrate how to use this in a custom About panel)
	
	
	// Read the two version keys from the application's info.plist like this:
	
	// Apple documentation calls this the "Build Version" but the specifics are ambiguous 
	// The following are equivalent:  
	//		NSString* appleBuildVersion = VERSION_X_LONG;		// the macro
	//		NSString* appleBuildVersion = [self versionLong];   // the synthesized getter method
	//		NSString* appleBuildVersion = versionLong;			// the instance variable
	NSString* appleBuildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]; 
	
	// Apple documentation calls this the "Marketing Version" aka the "2.1" in "MyProduct 2.1"
	NSString* appleMarketingVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; 
	
#if DEBUG	
	// Now we can use the strings, like so...
	NSLog(@"Info.plist Build Version (long): %@", appleBuildVersion); // fetched from Info.plist
	NSLog(@"Info.plist Marketing Version (short): %@", appleMarketingVersion); // fetch from Info.plist
#endif

	
	return;
}

-(id)init {
	// initialization  
	
	//	if (! (self = [super init])) return nil;
    if (![super init]) return nil;

	
	// set the instance variables from the macros for greater convenience in this controller
	buildDate = VERSION_X_BUILD_DATE ;
	buildUser = VERSION_X_BUILD_USER ;
	buildStyle = VERSION_X_BUILD_STYLE ;
	buildArchs = VERSION_X_BUILD_ARCHS ;
    buildCount =  VERSION_X_BUILD_COUNT ;
    commitTag =  VERSION_X_COMMIT_TAG ;
    commitCount =  VERSION_X_COMMIT_COUNT  ;
    commitShort = VERSION_X_COMMIT_SHORT  ;
    commitLong =   VERSION_X_COMMIT_LONG ;
	branch =  VERSION_X_BRANCH;
    lifecycleFamily =  VERSION_X_FAMILY ;
    lifecycleShort =  VERSION_X_LIFECYCLE_SHORT ;
    lifecycleLong = VERSION_X_LIFECYCLE_LONG ;
    versionShort = VERSION_X_SHORT ;
    versionLong =  VERSION_X_LONG ;
    commitStatus =  VERSION_X_COMMIT_STATUS ;
    commitStatusShort =  VERSION_X_COMMIT_SHORT ;
    commitStatusLong = VERSION_X_COMMIT_STATUS_LONG ;
	
	// to easily wire up custom about panels
	//myFancyApplicationName = [self fancyApplicationName];
	//myFancyFullVersion = [self fancyFullVersion];
	//myFancyMarketingVersion = [self fancyMarketingVersion];
	//myFancyBuildVersion = [self fancyBuildVersion];
	
	
#if DEBUG
		
	// The macros are available to use in any class where you import "VersionX-revision.h" (as does the header file for this class).
	NSLog(@"VersionX Build Date: %@", buildDate);
	NSLog(@"VersionX Build User: %@", buildUser);
	NSLog(@"VersionX Build Style: %@", buildStyle);
	NSLog(@"VersionX Build Archs: %@", buildArchs);
	NSLog(@"VersionX Build Count: %@", buildCount);
	NSLog(@"VersionX Commit Tag: %@", commitTag);
	NSLog(@"VersionX Commit Count: %@", commitCount);
	NSLog(@"VersionX Commit Short: %@", commitShort);
	NSLog(@"VersionX Commit Long: %@", commitLong);
	NSLog(@"VersionX Branch: %@", branch);
	
	// internal code name or cute marketing name for a branch - "Cute Fluffy Bunny" or "Snow Leopard"
	NSLog(@"VersionX Product Family (Code Name): %@", lifecycleFamily);
	NSLog(@"VersionX LifeCycle Stage: %@", lifecycleLong);
	NSLog(@"VersionX LifeCycle Stage Abbreviation: %@", lifecycleShort);

	// The Info.plist "Marketing Version" (shown by the Finder) 
	NSLog(@"VersionX Version Short (\"Marketing Version\" from Info.plist, used by Finder): %@", versionShort);
	
	// The Info.plist "Build Version" which is used between () by default in the Standard About Panel
	NSLog(@"VersionX Version Long (\"Build Version\" from Info.plist): (%@)", versionLong);

	// was this build performed on a clean working copy ("Clean"), or do uncommitted changes exist ("Grungy")?
	NSLog(@"VersionX Commit Status: %@", commitStatus);
	NSLog(@"VersionX Commit Status Short: %@", commitStatusShort);
	NSLog(@"VersionX Commit Status Long: %@", commitStatusLong);	

	// log the four fancy methods we derive
	//NSLog(@"My Fancy Vull Version: %@", myFancyBuildVersionView);
	//NSLog(@"My Fancy Application Name: @" myFancyApplicationName);
#endif
	
	return self;
}
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
- (NSString *)lifecycleFancyAbbreviation:(NSString *)myLifecycleShort {
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// if the Life Cycle abbreviation appears in our table as a key, hand back the fancy greek letter value

	if(myLifecycleShort){ 		
		
		NSMutableDictionary* fancyStages  = [[[NSMutableDictionary alloc] init] autorelease];
		[fancyStages addEntriesFromDictionary:[[[NSDictionary alloc] initWithObjectsAndKeys: 
											@"λ", @"?", // unknown (use a "?" to indicate a Lambda build, at tag time)
											@"λ", @"UNSET", // UNSET (short lifecycle field was blank in tag message at tag time, script turns this to UNSET)
											@"λ", @"", // A blank short lifecycle field probably shouldn't happen, but we set this to Lambda in case it does
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
											
											// common lifecycle stages that don't get translated to greek symbols
											@"RC", @"RC", // Release Candidate 
											@"GM", @"GM", // Golden Master
											@"RTM", @"RTM", // Release to Marketing / Manufacturing
											@"GA", @"GA", // General Availability
												// but which do get translated to upper case for nice display
											@"RC", @"rc", // Release Candidate
											@"GM", @"gm", // Golden Master
											@"RTM", @"rtm", // Release to Marketing / Manufacturing
											@"GA", @"ga", // General Availability
												
											// Easer eggs, loosely justified on the basis of an alpha/mu/omega concept for stage names)
											@"μ", @"moo", // Μμ (for sra, and pohl, for different reasons)
											@"Μ", @"MOO", // Μμ
											@"ω", @"o",		// omega
											@"Ω", @"O",		// Omega
											nil] autorelease]]; 
		NSString* lifecycleShortFancy = [fancyStages objectForKey: myLifecycleShort];
#if DEBUG
		NSLog(@"lifecycleFancyAbbreviation from: %@ to %@", myLifecycleShort, lifecycleShortFancy);
#endif
		//	[fancyStages release];
		return lifecycleShortFancy;
	}
	else {
		// Customize this!
		// if the Life Cycle abbreviation arrived set to anything else at tag time, we have a choice to make.
		//
		// Option A (the default behavior for the VersionX project)
		// Lambda is the "undefined" lifecycle stage, e.g. we don't know at tag time what stage it is
		// return lambda to enforce use of a commonly recognized convention
		// all of your short lifecycle codes must be in the translation table, above
		//
		NSString *lambda = @"λ";
		NSLog(@"lambda retain count: %x", [lambda retainCount]);
		[pool drain];
		return lambda;
		
		// Option B
		// ...Or, simply hand it back, unchanged 
		// (you might have your own convention and want anything else to pass through)
		//
		// [pool drain];
		// return lifecycleShort;

	}
}

- (IBAction)showAboutPanel:(id)sender { 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// Do NOT customize this!
	// customize the methods whose names begin with "fancy".
	//
	// This method simply gathers the information from other places, and fronts a Standard About Panel.
	//
	// The standard About panel uses two bits of information to create the version string.
	//
	// Suppose you want to do something which encodes a little more information, like this:
	//		Safari 2.1 β42 (61f95c8:12 "Dirty")
	//		Which says:
	//			Marketing version is:  Safari 2.1 (on the web site, in the ads, in the Finder, etc.)
	//			Beta 42 
	//			Git Commit at the HEAD of the working copy used to build the product: 61f95c8
	//			12 commits after the last version tag // this is the design intent, but the script might be sending us the full commit count
	//			Commit status is "Dirty" because the build took place on a working copy with uncommitted changes.
	
	NSString *myApplicationName = [self fancyApplicationName];
	NSString *myVersion = [self fancyBuildVersion];
	NSString *myApplicationVersion = [self fancyMarketingVersion];

	// construct the options dictionary for the Standard About Panel
	NSMutableDictionary* options  = [[[NSMutableDictionary alloc] init] autorelease];
	if(myVersion && myApplicationVersion && myApplicationName){ 		
		[options addEntriesFromDictionary:[[[NSDictionary alloc] initWithObjectsAndKeys:
					myApplicationName, @"ApplicationName",
					myApplicationVersion, @"ApplicationVersion",
					myVersion, @"Version", 
					nil] autorelease]]; 
	}
	
#if DEBUG
	// print all key-value pairs from the dictionary
	NSLog (@"The dictionary for the About panel contains the following key pairs:\n");
	for ( NSString *key in options )
		NSLog (@"%@:\t\t\t%@", key, [options  objectForKey: key]);
#endif
	
	// [NSApp orderFrontStandardAboutPanelWithOptions:options ]; 	
	[[NSApplication sharedApplication] orderFrontStandardAboutPanelWithOptions:options];
	[pool drain];
	return;
} 

- (IBAction)showCustomAboutPanel:(id)sender {
	
	if ( !customAboutPanel )
		[NSBundle loadNibNamed:@"CustomAboutPanel" owner:self];
	
	// to easily wire up custom about panels
	[fancyApplicationNameField setStringValue: [self fancyApplicationName] ];
	[fancyFullVersionField setStringValue: [self fancyFullVersion] ];
	
    [customAboutPanel makeKeyAndOrderFront:nil];
	
	return;
}

/*!
    @method     - (IBAction)showVersionDetailSheet:(id)Sender
    @abstract   Display the full set of version related macros on a sheet.
    @discussion IBOutlets were declared in the VersionXController.h,
					which we can use here to display the full set of information which
					was collected at build time.  
*/
- (IBAction)showVersionDetailSheet:(id)Sender {

	// show our fancy versions
	[fancyApplicationNameField setStringValue: [self fancyApplicationName] ];
	[fancyFullVersionField setStringValue: [self fancyFullVersion] ];
	[fancyMarketingVersionField setStringValue: [self fancyMarketingVersion] ];
	[fancyBuildVersionField setStringValue: [self fancyBuildVersion] ];

	// and show the values we get from the repository which we use to construct them
	[branchField setStringValue: branch];
	[commitTagField setStringValue: commitTag];
	[commitCountField setStringValue: commitCount];
	[commitShortField setStringValue: commitShort];
	[commitLongField setStringValue: commitLong];
	[versionShortField setStringValue: versionShort];
	[versionLongField setStringValue: versionLong];
	[buildDateField setStringValue: buildDate];
	[buildUserField setStringValue: buildUser];
	[buildStyleField setStringValue: buildStyle];
	[buildArchsField setStringValue: buildArchs];
	[buildCountField setStringValue: buildCount];
	[lifecycleLongField setStringValue: lifecycleLong];
	[lifecycleShortField setStringValue: lifecycleShort];
	[lifecycleFamilyField setStringValue: lifecycleFamily];
	[commitStatusField setStringValue: commitStatus];
	[commitStatusShortField setStringValue: commitStatusShort];
	[commitStatusLongView insertText: commitStatusLong];
	
	// display the values on the sheet
	[NSApp beginSheet:versionDetailSheet modalForWindow:mainWindow
        modalDelegate:self didEndSelector:NULL contextInfo:nil];
}
// Hide the Version Detail Sheet
- (IBAction)doneShowingVersionDetailSheet:(id)sender {
	[versionDetailSheet orderOut:nil];
    [NSApp endSheet:versionDetailSheet];
}

- (NSString *)fancyApplicationName {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	// to construct the Application Name, for non-Release build styles, we append the build style: (Debug)

	// first we read the current application name from the application's Info.plist dictionary...
	NSString* xversionappname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
#if DEBUG
	NSLog(@"VersionX App Name: %@", xversionappname);
#endif
	// for Release build styles, we simply return the name, unmodified
	if ([buildStyle isEqualToString: @"Release"] == YES) {
		[pool drain];
		return xversionappname;
	}
	else {
		// For any other build style, we write it back, appending the build style:  " (Debug)"
		// But first we convert the build style to upper case for display
		NSString *buildStyleUpperCase = [buildStyle uppercaseString];
		NSString *xversionappnameother = [NSString stringWithFormat:@"%@ (%@)", xversionappname, buildStyleUpperCase];
#if DEBUG
		NSLog(@"VersionX App Name for build styles other than Release: %@", xversionappnameother);
#endif		

		[xversionappnameother retain];
		[pool drain];
		return [xversionappnameother autorelease];
	}
}
- (NSString *)fancyBuildVersion {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
		// Customize this!
	// construct the "Build Version" e.g. (61f95c8:12 "Dirty")
	NSString *myFancyBuildVersion = [NSString stringWithFormat:@"%@:%@ \"%@\"", commitShort, buildCount, commitStatus];

	[myFancyBuildVersion retain];
	[pool drain];
	return [myFancyBuildVersion autorelease];
}

- (NSString *)fancyMarketingVersion {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	// NSString *myFancyMarketingVersion = [[NSString alloc] init];
	
	// construct our marketing version and return it in a string 
	
	
	// read the current application name from the application's Info.plist dictionary...
	NSString *xversionappname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
	NSLog(@"VersionX App Name: %@", xversionappname);
		
	// translate the Life Cycle Abreviation into fancy greek for display 
	NSString *myLifeCycleAbreviation = [self lifecycleFancyAbbreviation: lifecycleShort];
	NSLog(@"VersionX Life Cycle Abreviation: %@", myLifeCycleAbreviation);

	// don't display lifecycle stage for the final release, aka General Availability 
	// (show it only for lambda, alpha, beta, etc.)
	if ([myLifeCycleAbreviation isEqualToString: @"GA"] == YES) {
		NSString *myFancyMarketingVersion = [NSString stringWithFormat:@"%@ %@", xversionappname, versionShort];	
		[myFancyMarketingVersion retain];
		[pool drain];
		return [myFancyMarketingVersion autorelease];

	}
	else {
		// Customize This!
		// now, construct the "Marketing Version" e.g. "Safari 2.1 β42"
		NSString *myFancyMarketingVersion = [NSString stringWithFormat:@"%@ %@ %@%@", xversionappname, versionShort, myLifeCycleAbreviation, commitCount];
		[myFancyMarketingVersion retain];
		[pool drain];
		return [myFancyMarketingVersion autorelease];
	}
}

- (NSString *)fancyFullVersion {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	// construct the full version and return it in a string
	//	by calling vxMarketingVersion and combining it with vxBuildVersion
	
	NSString *myFancyFullVersion = [NSString stringWithFormat:@"%@ (%@)", [self fancyMarketingVersion], [self fancyBuildVersion] ];
	
	[myFancyFullVersion retain];
	[pool drain];
	return [myFancyFullVersion autorelease];
}

- (void) dealloc
{
    [branch release];
    [commitTag release];
    [commitCount release];
    [commitShort release];
    [commitLong release];
    [versionShort release];
    [versionLong release];
    [buildCount release];
    [buildDate release];
    [lifecycleFamily release];
    [lifecycleShort release];
    [lifecycleLong release];
    [commitStatus release];
    [commitStatusShort release];
    [commitStatusLong release];
    [super dealloc];
}

@end
