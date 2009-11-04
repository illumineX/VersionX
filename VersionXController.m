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
@synthesize commitCountSinceTag;  // derived from commitTag, not it's own macro
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
#if DEBUG
	NSLog(@"VersionXController awakeFromNib has been called."); 
#endif
	
	// to easily wire up custom about panels, regardless of context, 
	// we call init when VersionXController has been involked by awakeFromNib.
	[self init];
		
	return;
}

-(id)init {
	// initialization  
	
	//	if (! (self = [super init])) return nil;
    // if (![super init]) return nil;
	if (self = [super init]) {
			
	// set the instance variables from the macros for greater convenience in this controller
	buildDate = VERSION_X_BUILD_DATE ;
	buildUser = VERSION_X_BUILD_USER ;
	buildStyle = VERSION_X_BUILD_STYLE ;
	buildArchs = VERSION_X_BUILD_ARCHS ;
    buildCount =  VERSION_X_BUILD_COUNT ;
    commitTag =  VERSION_X_COMMIT_TAG ;
    commitCount =  VERSION_X_COMMIT_COUNT  ;
    
	// Commit Count Since Last Tag is derived from the tag (and might therefore be null, in which case we set it to 0)
	NSArray *split = [VERSION_X_COMMIT_TAG componentsSeparatedByString:@"-"];
		
	if ((split != nil) && ([split count] == 3)) {
		commitCountSinceTag = [split objectAtIndex:1];		
	}
	
	else {
		commitCountSinceTag = @"0";
	}
		
	commitShort = VERSION_X_COMMIT_SHORT  ;
    commitLong =   VERSION_X_COMMIT_LONG ;
	branch =  VERSION_X_BRANCH;
    lifecycleFamily =  VERSION_X_FAMILY ;
    lifecycleShort =  VERSION_X_LIFECYCLE_SHORT ;
    lifecycleLong = VERSION_X_LIFECYCLE_LONG ;
    versionShort = VERSION_X_SHORT ;
    versionLong =  VERSION_X_LONG ;
    commitStatus =  VERSION_X_COMMIT_STATUS ;
    commitStatusShort =  VERSION_X_COMMIT_STATUS_SHORT ;
    commitStatusLong = VERSION_X_COMMIT_STATUS_LONG ;
	
	// to easily wire up custom about panels
	[self fancyPopulateMyFields];
		
	
#if DEBUG
	NSLog(@"VersionX init method has been called.");
		
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

	// log the fancy methods we derive
	NSLog(@"Fancy Application Name: %@", [self fancyApplicationName]);
	NSLog(@"Fancy Marketing Version: %@", [self fancyMarketingVersion]);
	NSLog(@"Fancy Build Version: %@", [self fancyBuildVersion]);
	NSLog(@"Fancy Full Version: %@", [self fancyFullVersion]);	
	
#endif
	}

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
		[pool drain];
		return lambda;
		
		// Option B
		// ...Or, simply hand it back, unchanged 
		// (you might have your own convention and want anything undefined to pass through)
		//
		// [pool drain];
		// return lifecycleShort;

	}
}

/*!
    @method     - (IBAction)showAboutPanel:(id)sender
    @abstract   Constructs fancy version strings, fronts a Standard About Panel.
    @discussion Typically you won't need to modify this method.  
				If you want a Standard About Panel, with the default VersionX 
					version string construction behavior, invoke this method
					from the "About" menu item by making a connection in Interface Builder,
					and you won't need to modify anything. It passes a dictionary
					of options to the Standard About Panel.
*/
- (IBAction)showAboutPanel:(id)sender { 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// This method simply gathers the information from other places, and fronts a Standard About Panel.
	//
	// The standard About panel uses two bits of information to create the version string,
	
	//    plus one additional value, the Application Name.
	
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
	NSLog (@"The options dictionary for the Standard About Panel contains the following key pairs:\n");
	for ( NSString *key in options )
		NSLog (@"%@:\t\t\t%@", key, [options  objectForKey: key]);
#endif
	
	// [NSApp orderFrontStandardAboutPanelWithOptions:options ]; 	
	[[NSApplication sharedApplication] orderFrontStandardAboutPanelWithOptions:options];
	[pool drain];
	return;
} 

/*!
    @method     - (IBAction)showCustomAboutPanel:(id)sender
    @abstract   Simply fronts the simple Custom About Panel in the VersionX demo app.
    @discussion Customize this method (and an accompanying Interface Builder NIB/XIB file)
					if you want your Custom About Panel code to be managed inside the 
					VersionX Controller. 
				In most cases, you'll probably ignore this method, and not customize it.
					You can easily wire up your existing Custom About Panel to use VersionX,
					with minor modification to your pre-existing code for your Custom About Panel, 
					whereever that code happens to be resident.  
*/
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
    @method     - (IBAction) doneShowingCustomAboutPanel:(id)Sender
    @abstract   A template and place holder, likely to be needed by certain fancy Custom About Panels.
    @discussion Customize this method if your fancy Custom About Panel needs it.  Otherwise, ignore it.
				It appears that this method may be needed by certain Custom About Panels,
					so we include it here.  However, it's not required by the demonstration app's
					(very simple) Custom About Panel, so it does nothing. 
*/
- (IBAction) doneShowingCustomAboutPanel:(id)Sender {
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
	NSString* xversionappname = [[[NSBundle bundleForClass: [self class]] infoDictionary] objectForKey:@"CFBundleName"];
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


/*!
    @method     - (NSString *)fancyMarketingVersion
    @abstract   Constructs a fancy Marketing Version and returns it in a string.
	@discussion Customize this method, if you want to display "Marketing Version" information differently from
					the default VersionX behavior.
 
				Suppose you want to do something which encodes a little more 
					information about your application version, like this:
 
					Safari 2.1 β42 (61f95c8:12 "Dirty")
				
				Which includes two components:
 
					Marketing Version:		Safari 2.1 β42 
					Build Version:			(61f95c8:12 "Dirty")
 
				Which says:
					Marketing version is:  Safari 2.1 (which you use the web site, in the ads, in the Finder, etc.)
					Beta 42 (shown in the About Panel)
					Git Commit at the HEAD of the working copy used to build the product: 61f95c8
					12 commits after the last version tag  (NOTE: this is the design intent, but the script might be sending us the full commit count)
					Commit status is "Dirty" because the build took place on a working copy with uncommitted changes.
 
*/
- (NSString *)fancyMarketingVersion {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// construct our marketing version and return it in a string 
	
	// translate the Life Cycle Abreviation into fancy greek for display 
	NSString *myLifeCycleAbreviation = [self lifecycleFancyAbbreviation: lifecycleShort];

	// don't display lifecycle stage for the final release, aka General Availability 
	// (show it only for lambda, alpha, beta, etc.)
	if ([myLifeCycleAbreviation isEqualToString: @"GA"] == YES) {
		NSString *myFancyMarketingVersion = [NSString stringWithFormat:@"Version %@", versionShort];	
		[myFancyMarketingVersion retain];
		[pool drain];
		return [myFancyMarketingVersion autorelease];

	}
	else {
		// Customize This!
		// now, construct the "Marketing Version" e.g. "Safari 2.1 β42"
		NSString *myFancyMarketingVersion = [NSString stringWithFormat:@"Version %@ %@%@", versionShort, myLifeCycleAbreviation, commitCountSinceTag];
		[myFancyMarketingVersion retain];
		[pool drain];
		return [myFancyMarketingVersion autorelease];
	}
}

/*!
	@method     - (NSString *)fancyBuildVersion
	@abstract   Constructs the fancy "Build Version", which is the part between the parens in "Version 4.0.3 (6531.9)"
	@discussion Customize this method if you want to display "Build Version" information differently from
					the default VersionX behavior.  
 */
- (NSString *)fancyBuildVersion {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	
	// for Release build styles, we don't display a "Clean" commitStatus...
	//		example:	(6f5071e:0)
	if (([buildStyle isEqualToString: @"Release"] == YES) && ([commitStatus isEqualToString: @"Clean"] == YES)) {
		NSString *myFancyBuildVersion = [NSString stringWithFormat:@"%@:%@", commitShort, commitCountSinceTag];
		[myFancyBuildVersion retain];
		[pool drain];
		return [myFancyBuildVersion autorelease];
	}
	else {
		// For any other build style, or if Grungy, we include the commitStatus...
		//	example:	(6f5071e:0 "Grungy")
		NSString *myFancyBuildVersion = [NSString stringWithFormat:@"%@:%@ \"%@\"", commitShort, commitCountSinceTag, commitStatus];
		[myFancyBuildVersion retain];
		[pool drain];
		return [myFancyBuildVersion autorelease];
	}
}

/*!
    @method     - (NSString *)fancyFullVersion
    @abstract   Constructs and returns full version string, such as:  "Safari 2.1 (6f5071e)"
    @discussion Typically you won't customize this method.  
				It constructs the full version string from the fancyMarketingVersion and fancyBuildVersion.
*/
- (NSString *)fancyFullVersion {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	// construct the full version and return it in a string
	//	by calling vxMarketingVersion and combining it with vxBuildVersion
	
	NSString *myFancyFullVersion = [NSString stringWithFormat:@"%@ (%@)", [self fancyMarketingVersion], [self fancyBuildVersion] ];
	
	[myFancyFullVersion retain];
	[pool drain];
	return [myFancyFullVersion autorelease];
}

/*!
    @method     -(void) fancyPopulateMyFields
    @abstract   Populates text fields which display the version strings in text fields.
    @discussion Typically you won't customize this method.  
				It's invoked from the init method, which in turn is invoked
					by our awakeFromNib, so that these fields are populated in the same way
					regardless of the running context of the VersionXController.
*/
-(void) fancyPopulateMyFields {
	
	// Typically you'll display the fancyApplicationName and fancyFullVersion fields,
	// and won't need to modify this method.
	[fancyApplicationNameField setStringValue: [self fancyApplicationName] ];
	[fancyFullVersionField setStringValue: [self fancyFullVersion] ];
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
