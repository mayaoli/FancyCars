Source code: https://github.com/yaolima/FancyCars
* myFancyCars.xcworkspace to open the project
* system diagram in document folder 
* service rewrite in document folder
* API response samples in document folder
* videos recording in document folder

Assume:
1) the API services always return the response in JSON format 
- (if want to support xml, string format just add different parser)
- In Constants.swift, please look for 
	static let BASE_URL = "https://www.google.ca" //"https://fancycars.ca"
  I hacked the service base url with Google url, and created service rewrite in proxy for testing. You may would like to use the rewrite exported (attached separately) to play around the app.

2) the requirement only need this iOS app support iPhone, not iPad 
- (in case needed, improve layout xib/storyboard)

3) support iOS 9.0+ only, not below
- (usage of iOS below 9.0, the percentage is very low)

4) don't need to support rotation 
- (in case required, just little more effort on constraints)

5) Accessibility & Globalization are not critical items in scope for this project
- (had some places consider accessibility and globalization, but not every where)

6) Unit or UI test cases are not needed
- (stubbed the placeholder for later on)

7) In case the image URL is broken, just display a dummy carousel

Some highlights in my project:
1) Modularized code in MVC pattern, with base classes for extension 
2) Events are data driven, business logic is handled by presenter layer, service calls in interactor layer
3) Check availability call is divided into size configurable chunks (10 at a time as per user scrolling), for a better performance
4) Data communicating between classes is in model entity
5) Created BaseService class, inherited by subclasses (like CarServices) to reduce redundancy 
6) Categorized code/resources(files), in their own proper groups
7) Functional UITableViewCell is defined separately for flexibility (ex. CarListViewCell), could have other cells like empty/error etc.
8) Error and message handling are centralized in one place, for better code management
9) Implemented SwiftLint ensure no code warning (pod libraries exclusive), clean project
and there is more ...

Project plan:
day 1 - plan, system diagram, build base frameworks
day 2 - implement functionalities
day 3 - testing and bug fixing
day 4 - video recording, documentation
