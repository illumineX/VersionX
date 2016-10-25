# VersionX #
*Revised: October 25, 2016*

This project builds under Xcode 7 and runs on Mac OS X 10.11 (El Capitan).  (It probably runs on Mac OS X 10.7 and later).

Documentation is presently hosted on the GitHub Wiki page for the project. 

[VersionX Documentation](https://github.com/illumineX/VersionX/wiki)

### Dependencies ###

When running in a shared memory context, such as a Screen Saver running in the OS X / macOS System Preference Pane, be sure to use an @compatibility_alias (see VersionXController.h for details).

### What is this repository for? ###

VersionX is a system which automatically gathers build version information at build time, and populates values which your app can use to know, display, and otherwise present consistent and reliable version information at run time.  For applications which are frequently updated, this can eliminate the human error occasionally introduced when a version is updated in one place, but not another. 

### How do I get set up? ###

* Open the project in Xcode and press the Build-and-Run button. The project includes a test application which demonstrates both standard and custom About panels. 

### Contribution guidelines ###

* Refactor into Swift
* Improve documentation in the source code for methods
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### Who do I talk to? ###

* Gary W. Longsine <gary@illumineX.com>
* Other illumineX developers <devel@illumineX.com>
