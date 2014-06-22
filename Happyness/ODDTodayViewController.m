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

@interface ODDTodayViewController () <UIScrollViewDelegate>
@property (nonatomic) BOOL hasBeenClickedToday;
@property (nonatomic, strong) ODDTodayNoteView *noteView;
@property (nonatomic, strong) UIView *noteContainerView;
@property (nonatomic, strong) UIButton *clearAllButton;

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
        self.tabBarItem.title = @"Today";
         // I'm not sure if init/loading will incorrectly toggbecause things should only init once right? I'm declaring this explicity as a reminder to resolve this issue later
        _hasBeenClickedToday = NO;
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

    // If a happyness hasn't been added today, the screen will be gray
    if (_hasBeenClickedToday == NO) {
        // every 24 hours, grayView should be back at the initial frame position
        _grayView.backgroundColor = [UIColor grayColor];
    }
}

// Helper method for setting up Today
- (void)setUpTodayView {
    ODDHappyness *verySadObject = [[ODDHappyness alloc] initWithFace:1];
    ODDHappyness *sadObject = [[ODDHappyness alloc] initWithFace:2];
    ODDHappyness *soSoObject = [[ODDHappyness alloc] initWithFace:3];
    ODDHappyness *happyObject = [[ODDHappyness alloc] initWithFace:4];
    ODDHappyness *veryHappyObject = [[ODDHappyness alloc] initWithFace:5];

    NSArray *happynessObjects = [NSArray arrayWithObjects:verySadObject, sadObject, soSoObject,
                                 happyObject, veryHappyObject, nil];

    for (int i = 0; i < happynessObjects.count; i++) {
        CGRect frame;
        frame.origin.x = _scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _scrollView.frame.size;

        UIView *subview = [[UIView alloc] initWithFrame:frame];
        ODDHappyness *temp = [happynessObjects objectAtIndex:i];
        subview.backgroundColor = temp.color;

        [self.scrollView addSubview:subview];
    }

    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * happynessObjects.count,
                                         _scrollView.frame.size.height);

    // Set up initial happyness view to show
    CGRect initialFrame;
    initialFrame.size = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
    initialFrame.origin.x = _scrollView.frame.size.width * 2;
    initialFrame.origin.y = 0;
    [_scrollView scrollRectToVisible:initialFrame animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update the page control to display correct view when scrolling
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Note

- (IBAction)addNote:(id)sender {
    [_noteView becomeFirstResponder];
}

// Still need to make sure note view slides down every new day
- (void)setUpNoteView {
    _noteContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 
                                                                  -self.view.frame.size.height, 
                                                                  320,
                                                                  self.view.frame.size.height)];
    _noteContainerView.backgroundColor = [UIColor clearColor];
    _noteView = [[ODDTodayNoteView alloc] initWithFrame:CGRectMake(0, 
                                                                   self.view.frame.size.height - 34,
                                                                   270,
                                                                   40)];
    _noteView.delegate = self;


    _clearAllButton = [[UIButton alloc] initWithFrame:CGRectMake(270,
                                                                self.view.frame.size.height - 34, 
                                                                50, 
                                                                 34)];
    _clearAllButton.backgroundColor = [UIColor lightGrayColor];
    _clearAllButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [_clearAllButton setTitle:@"X" forState:UIControlStateNormal];
    [_clearAllButton addTarget:self action:@selector(clearButtonSelected) forControlEvents:UIControlEventTouchUpInside];

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

    [self.view addSubview:_noteContainerView];
    //[containerView addSubview:imageView];
    [_noteContainerView addSubview:_noteView];
    [_noteContainerView addSubview:_clearAllButton];
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
    _noteContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
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
	CGRect containerFrame = _noteContainerView.frame;
    // Matt: play with height values to make textView move upon keyboard showing
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + 
                                                              _noteContainerView.frame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];

	// set views with new info
	_noteContainerView.frame = containerFrame;


	// commit animations
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)note {
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

	// get a rect for the textView frame
	CGRect containerFrame = _noteContainerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height + containerFrame.size.height;

	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];

	// set views with new info
	_noteContainerView.frame = containerFrame;

	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    float diff = (growingTextView.frame.size.height - height);

	CGRect r = _noteContainerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	_noteContainerView.frame = r;

    CGRect clearR = _clearAllButton.frame;
    clearR.size.height -= diff;
    _clearAllButton.frame = clearR;
}

// Dismiss keyboard upon pressing "Done" and impose 140 character limit
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if ([text isEqualToString:@"\n"]) {
            [_noteView resignFirstResponder];
    }
    return growingTextView.text.length + (text.length - range.length) <= 140;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (void)clearButtonSelected {
    _noteView.text = @"";
}



# pragma mark - Screen Transitions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_hasBeenClickedToday == NO) {
        CGRect slideUpFrame = _grayView.frame;
        slideUpFrame.origin.y -= slideUpFrame.size.height;
        [UIView animateWithDuration:0.2
                         animations:^{
                                  _grayView.frame = slideUpFrame;
                              }
                         completion:^(BOOL finished) {
                                     [_grayView removeFromSuperview]; // or use bringSubviewToFront: sendSubviewToBack for speed or hide it...so many options
                         }];
        _hasBeenClickedToday = YES;
    }

    // Dismiss keyboard
    if ([_noteView isFirstResponder]) {
        [_noteView resignFirstResponder];
    }
}

@end
