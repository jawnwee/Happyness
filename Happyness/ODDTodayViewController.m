//
//  ODDTodayViewController.m
//  Happyness
//
//  Created by John Lee on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDTodayViewController.h"
#import "ODDTodayNoteView.h"
#import "ODDHappyness.h"
#import "ODDNote.h"
#import "ODDHappynessEntry.h"
#import "ODDHappynessEntryStore.h"

@interface ODDTodayViewController () <UIScrollViewDelegate>
@property (nonatomic) BOOL hasBeenClickedToday;
@property (strong, nonatomic) NSArray *happynessObjects;
@property (strong, nonatomic) ODDTodayNoteView *noteView;
@property (strong, nonatomic) UIView *noteContainerView;
@property (strong, nonatomic) UIButton *clearAllButton;
@property (strong, nonatomic) ODDNote *note;

@end

@implementation ODDTodayViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize grayView = _grayView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage *todaySelected = [UIImage imageNamed:@"TodayTabSelected60.png"];
        UIImage *todayUnselected = [UIImage imageNamed:@"TodayTabUnselected60.png"];
        todaySelected = [todaySelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        todayUnselected = [todayUnselected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *todayTabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:todayUnselected selectedImage:todaySelected];
        self.tabBarItem = todayTabBarItem;
         // I'm not sure if init/loading will incorrectly toggbecause things should only init once right? I'm declaring this explicity as a reminder to resolve this issue later
        _hasBeenClickedToday = NO;
        _note = [[ODDNote alloc] initWithNote:nil];

        // Change testing 'submit' method
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(submit) 
                                                     name:UIApplicationSignificantTimeChangeNotification 
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];

		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpTodayView];
    [self setUpNoteView];

    if (self.hasBeenClickedToday == NO) {
        // every 24 hours, grayView should be back at the initial frame position
        self.grayView.backgroundColor = [UIColor grayColor];
    }
}

// Helper method for setting up Today
- (void)setUpTodayView {
    ODDHappyness *verySadObject = [[ODDHappyness alloc] initWithFace:5];
    ODDHappyness *sadObject = [[ODDHappyness alloc] initWithFace:4];
    ODDHappyness *soSoObject = [[ODDHappyness alloc] initWithFace:3];
    ODDHappyness *happyObject = [[ODDHappyness alloc] initWithFace:2];
    ODDHappyness *veryHappyObject = [[ODDHappyness alloc] initWithFace:1];

    self.happynessObjects = [NSArray arrayWithObjects:veryHappyObject, happyObject, soSoObject,
                                 sadObject, verySadObject, nil];

    for (int i = 0; i < self.happynessObjects.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;

        ODDHappyness *temp = [self.happynessObjects objectAtIndex:i];
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        subview.backgroundColor = temp.color;

        UIImageView *imageSubView = [[UIImageView alloc] initWithImage:temp.face];
        CGPoint newCenter = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 49);
        imageSubView.center = newCenter;

        [self.scrollView addSubview:subview];
        [subview addSubview:imageSubView];
    }

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.happynessObjects.count,
                                         self.scrollView.frame.size.height);

    // Set up initial happyness view to show
    CGRect initialFrame;
    initialFrame.size = CGSizeMake(self.scrollView.frame.size.width, 
                                   self.scrollView.frame.size.height);
    initialFrame.origin.x = self.scrollView.frame.size.width * 2;
    initialFrame.origin.y = 0;
    [self.scrollView scrollRectToVisible:initialFrame animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update the page control to display correct view when scrolling
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Note

- (IBAction)addNote:(id)sender {
    [self.noteView becomeFirstResponder];
}

/* Still need to make sure note view slides down every new day */
- (void)setUpNoteView {
    self.noteContainerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  -self.view.frame.size.height, 
                                                                  320,
                                                                  self.view.frame.size.height)];
    self.noteContainerView.backgroundColor = [UIColor clearColor];
    self.noteView = [[ODDTodayNoteView alloc] initWithFrame:CGRectMake(0,
                                                                   self.view.frame.size.height - 34,
                                                                   270,
                                                                   40)];
    self.noteView.delegate = self;


    self.clearAllButton = [[UIButton alloc] initWithFrame:CGRectMake(270,
                                                                self.view.frame.size.height - 34, 
                                                                50, 
                                                                 34)];
    self.clearAllButton.backgroundColor = [UIColor lightGrayColor];
    self.clearAllButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.clearAllButton setTitle:@"X" forState:UIControlStateNormal];
    [self.clearAllButton addTarget:self action:@selector(clearButtonSelected) forControlEvents:UIControlEventTouchUpInside];

    /* entryBackground; edit these lines for back
     UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
     UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
     UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
     entryImageView.frame = CGRectMake(5, 0, 248, 40);
     entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
     */

    /* messageEntryBackground
     UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
     UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
     UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
     imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
     imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
     */

    [self.view addSubview:self.noteContainerView];
    //[containerView addSubview:imageView];
    [self.noteContainerView addSubview:self.noteView];
    [self.noteContainerView addSubview:self.clearAllButton];
    //[containerView addSubview:entryImageView];

    /* Replace image with custom CLEAR ALL
     UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
     UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
     */

    /*Replace doneBtn with a clearAll button
     UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
     doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
     [doneBtn setTitle:@"Done" forState:UIControlStateNormal];

     [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
     doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
     doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];

     [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
     [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
     [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
     [containerView addSubview:doneBtn];
     */
    self.noteContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)keyboardWillShow:(NSNotification *)note {
    // get keyboard size and location
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];

	// get a rect for the textView frame
	CGRect containerFrame = self.noteContainerView.frame;
    // Matt: play with height values to make textView move upon keyboard showing
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + 
                                                              self.noteContainerView.frame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];

	// set views with new info
	self.noteContainerView.frame = containerFrame;


	// commit animations
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)note {
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

	// get a rect for the textView frame
	CGRect containerFrame = self.noteContainerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height + containerFrame.size.height;

	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];

	// set views with new info
	self.noteContainerView.frame = containerFrame;

	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    float diff = (growingTextView.frame.size.height - height);

	CGRect r = self.noteContainerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.noteContainerView.frame = r;

    CGRect clearR = self.clearAllButton.frame;
    clearR.size.height -= diff;
    self.clearAllButton.frame = clearR;
}

/* Dismiss keyboard upon pressing "Done" and impose 140 character limit */
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if ([text isEqualToString:@"\n"]) {
            [self.noteView resignFirstResponder];
    }
    return growingTextView.text.length + (text.length - range.length) <= 140;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (void)clearButtonSelected {
    self.noteView.text = @"";
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView {
    self.note.noteString = growingTextView.text;
    NSLog(@"Note contains string: %@", self.note.noteString);
}

/************** Submit Test **************/
/* Called every midnight by UIApplicationSignificantTimeChangeNotification */
- (IBAction)submit:(id)sender {
    NSDate *date = [NSDate date];
    ODDHappyness *happyness = [self.happynessObjects objectAtIndex:self.pageControl.currentPage];
    ODDHappynessEntry *entry = [[ODDHappynessEntry alloc] initWithHappyness:happyness 
                                                                       note:self.note 
                                                                   dateTime:date];
    [[ODDHappynessEntryStore sharedStore] addEntry:entry];

    // Reset note, grayView, and hasBeenClickedToday for the new day
    if (self.hasBeenClickedToday == YES) {
        CGRect grayViewStartFrame = self.grayView.frame;
        grayViewStartFrame.origin.y += grayViewStartFrame.size.height;
        self.grayView.frame = grayViewStartFrame;
        self.hasBeenClickedToday = NO;
    }
    self.note = [[ODDNote alloc] initWithNote:nil];
}


# pragma mark - Screen Transitions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.hasBeenClickedToday == NO) {
        CGRect slideUpFrame = self.grayView.frame;
        slideUpFrame.origin.y -= slideUpFrame.size.height;
        [UIView animateWithDuration:0.2
                         animations:^{
                                  self.grayView.frame = slideUpFrame;
                              }
                         completion:^(BOOL finished) {
                                     //[self.grayView removeFromSuperview]; // or use bringSubviewToFront: sendSubviewToBack for speed or hide it...so many options
                         }];
        self.hasBeenClickedToday = YES;
    }

    // Dismiss keyboard
    if ([self.noteView isFirstResponder]) {
        [self.noteView resignFirstResponder];
    }
}

@end
