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
@property (nonatomic, strong) NSDictionary *testVariableValues;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize history;
@synthesize testVariableValues = _testVariableValues;



-(NSDictionary *) testVariableValues
{
    if (!_testVariableValues)
    {
        _testVariableValues = [[NSDictionary alloc] init];
    }
    return _testVariableValues;
}

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
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    [self updateProgramHistory];
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        [self enterPressed];
    }
    
    // push operation onto the stack:
    [self.brain pushOperation:[sender currentTitle]];
    
    // call method to run program, etc:
    [self runProgramAndUpdateDisplay];
}

-(void) runProgramAndUpdateDisplay
{
    // run current program:
    double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    
    // show result in the display:
    self.display.text = [NSString stringWithFormat:@"%.2f", result];
    
    // update program history:
    [self updateProgramHistory];
}

- (IBAction)piOperationPressed {
    
    // apply whatever is already entered:
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        [self enterPressed];
    }
    
    // push operation onto the stack:
    [self.brain pushOperation:@"π"];
    
    // push pI to the display:
    //self.display.text = [NSString stringWithFormat:@"%.2f", M_PI];
    //[self enterPressed];
    
    [self runProgramAndUpdateDisplay];
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


- (IBAction)posNegPressed {
    double currentValue = [self.display.text doubleValue];
    double newValue = currentValue * -1;
    self.display.text = [NSString stringWithFormat:@"%f", newValue];
}

- (void)viewDidLoad
{
    self.display.text = @"0";
    self.history.text = @"";
    self.variables.text = @"";
}

- (IBAction)testPressed:(UIButton *)sender {
    
}

-(void) updateProgramHistory
{
    self.history.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

// called when user presses r, a or b variable buttons:
- (IBAction)variablePressed:(UIButton *)sender {
    
    NSString *variable = [sender currentTitle];
    
    [self.brain pushVariableOperand:variable];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    [self updateProgramHistory];
}

@end
