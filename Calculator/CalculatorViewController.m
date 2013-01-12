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
@synthesize history;


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
    NSString *currentDisplayText = self.display.text;
    
    if (userIsInTheMiddleOfEnteringANumber)
    {
        NSString *newDisplayText = [currentDisplayText stringByAppendingString:digit];
    
        [self.display setText:newDisplayText];
    }
    else
    {
        if ([digit isEqualToString:@"0"])
        {
            // if user is pressing tons of leading zeros, do zilch
        }
        else
        {
            [self.display setText:digit];
            userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
}

- (IBAction)enterPressed {
    [self addToHistory:self.display.text];
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        [self enterPressed];
    }
    
    NSString *operation = [sender currentTitle];
    [self addToHistory:operation];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%f", result];
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

- (IBAction)clearPressed {
    [self.brain reset];
    self.display.text = @"0";
    self.history.text = @"";
}

- (IBAction)backspacePressed {
    
    NSString *currentDisplayText = self.display.text;
    NSUInteger currentDisplayLength = currentDisplayText.length;
    if (currentDisplayLength > 0)
    {
        self.display.text = [currentDisplayText substringToIndex:(currentDisplayLength - 1)];
    }
}

-(void) addToHistory:(NSString *) value
{
    // handle Pi which is passed as 3.14 etc..:
    NSString *piAsString = [NSString stringWithFormat:@"%f", M_PI];
    if ([value isEqualToString: piAsString])
    {
        value = @"Pi";
    }
        
    // strip away the trailing = if we have one:
    NSString *currentDisplayText = self.history.text;
    NSUInteger currentDisplayLength = currentDisplayText.length;
    if (currentDisplayLength > 0)
    {
        currentDisplayText = [currentDisplayText substringToIndex:(currentDisplayLength - 2)];
    }
    
    // then add the trailing space:
    NSString *newDisplayText = [[currentDisplayText stringByAppendingString:@" "] stringByAppendingString: value];
    
    // add back in the trailing =
    self.history.text = [newDisplayText stringByAppendingString:@" ="];
}

- (IBAction)posNegPressed {
    double currentValue = [self.display.text doubleValue];
    double newValue = currentValue * -1;
    self.display.text = [NSString stringWithFormat:@"%f", newValue];
}

@end
