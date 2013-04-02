//
//  CANewReportDescriptionVC.m
//  CityApp
//
//  Created by Taylor McGann on 3/29/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CANewReportDescriptionVC.h"
#import "CANewReportVC.h"

#define MAXIMUM_CHARACTER_COUNT 200

@interface CANewReportDescriptionVC ()

@end

@implementation CANewReportDescriptionVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self fillTextViewWithDescription];
    [self updateCharacterCount];
}

- (void)fillTextViewWithDescription
{
    self.descriptionTextView.text = self.reportDescription;
}

- (BOOL)validData
{
    BOOL validData = YES;
    
    // Check character count
    if (self.descriptionTextView.text.length > MAXIMUM_CHARACTER_COUNT)
        validData = NO;
    
    return validData;
}

- (void)updateReportEntryData
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    NSUInteger previousViewControllerIndex = viewControllers.count - 2;
    CANewReportVC *newReportVC = (CANewReportVC *)[viewControllers objectAtIndex:previousViewControllerIndex];
    newReportVC.reportDescription = self.descriptionTextView.text;
}

- (void)updateCharacterCount
{
    NSInteger charactersRemaining = MAXIMUM_CHARACTER_COUNT - self.descriptionTextView.text.length;
    if (charactersRemaining < 0) {
        self.characterCountLabel.textColor = [UIColor colorWithRed:190.0f/255.0f green:17.0f/255.0f blue:17.0f/255.0f alpha:1.0f];
    } else {
        self.characterCountLabel.textColor = [UIColor darkTextColor];
    }
    self.characterCountLabel.text = [NSString stringWithFormat:@"%d", charactersRemaining];
}

- (IBAction)savePressed:(UIBarButtonItem *)sender
{
    if ([self validData]) {
        [self updateReportEntryData];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSString *title = @"Exceeds Character Limit";
        NSString *message = [NSString stringWithFormat:@"Your description must contain fewer than %d characters.", MAXIMUM_CHARACTER_COUNT];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateCharacterCount];
}

@end
