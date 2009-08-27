#import "ComposeTweetViewControllerTest.h"
#import "ComposeTweetViewController.h"
#import "TwitterConnectionProtocol.h"
#import "AgileTwitterAppDelegate.h"
#import <OCMock/OCMock.h>

@implementation ComposeTweetViewControllerTest

- (void)setUp
{
	viewController = [[ComposeTweetViewController alloc] init];
}

- (void)tearDown
{
	[viewController release];
}

- (void)testViewControllerSetsTextViewToFirstResponder
{
	OCMockObject *textView = [OCMockObject niceMockForClass:[UITextView class]];
	viewController.textView = (UITextView *)textView;
	
	[[textView expect] becomeFirstResponder];
	
	[viewController viewDidAppear:NO];
	
	[textView verify];
}

- (void)testSendButtonSendsTweet
{
	viewController.textView = [[[UITextView alloc] init] autorelease];
	viewController.textView.text = @"This is my tweet";
	
	OCMockObject *twitterConnection = [OCMockObject mockForProtocol:@protocol(TwitterConnectionProtocol)];
	viewController.twitterConnection = (NSObject<TwitterConnectionProtocol> *)twitterConnection;
	
	[[twitterConnection expect] tweet:@"This is my tweet"];
	
	[viewController tweet];
	
	[twitterConnection verify];
}

- (void)testSendButtonClearsText
{
	viewController.textView = [[[UITextView alloc] init] autorelease];
	viewController.textView.text = @"This is my tweet";
	
	OCMockObject *twitterConnection = [OCMockObject niceMockForProtocol:@protocol(TwitterConnectionProtocol)];
	viewController.twitterConnection = (NSObject<TwitterConnectionProtocol> *)twitterConnection;
	
	[viewController tweet];
	
	STAssertEqualStrings(@"", viewController.textView.text, nil);
}

- (void)testSendButtonTellsDelegateDoneComposing
{
	OCMockObject *appDelegate = [OCMockObject niceMockForClass:[AgileTwitterAppDelegate class]];
	viewController.appDelegate = (AgileTwitterAppDelegate *)appDelegate;
	
	[[appDelegate expect] doneComposing];
	
	[viewController tweet];
	
	[appDelegate verify];
}
	

@end
