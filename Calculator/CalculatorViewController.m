//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Jorn Nordahl on 1/12/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import <math.h>

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;


-(CalculatorBrain *) brain
{
    if (!_brain)
    {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}


- (IBAction)digitPressed:(UIButton *)sender {
   
    NSString *digit = sender.currentTitle;
    UILabel *myDisplay = self.display;
    NSString *currentDisplayText = myDisplay.text;
    if (userIsInTheMiddleOfEnteringANumber)
    {
        NSString *newDisplayText = [currentDisplayText stringByAppendingString:digit];
    
        [self.display setText:newDisplayText];
    }
    else
    {
        [self.display setText:digit];
        userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        [self enterPressed];
    }
    
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)piOperationPressed {
    
    // apply whatever is already entered:
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        [self enterPressed];
    }
    
    // push pI to the display:
    self.display.text = [NSString stringWithFormat:@"%f", M_PI];
    [self enterPressed];
}

- (IBAction)decimalPointPressed {
    
    UILabel *myDisplay = self.display;
    NSString *currentDisplayText = myDisplay.text;
    
    // check to see if the . has already been pressed:
    NSRange isRange = [currentDisplayText rangeOfString:@"."];
    if(isRange.location != NSNotFound) {
        // we found it - do nothing.
        return;
    }
    
    if (userIsInTheMiddleOfEnteringANumber)
    {
        NSString *newDisplayText = [currentDisplayText stringByAppendingString:@"."];
        [self.display setText:newDisplayText];
    }
    else
    {
        NSString *newDisplayText = @"0.";
        [self.display setText:newDisplayText];
        
        userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}

@end
