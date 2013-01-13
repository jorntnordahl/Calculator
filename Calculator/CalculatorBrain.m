//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Jorn Nordahl on 1/12/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "CalculatorBrain.h"
#import <math.h>

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end


@implementation CalculatorBrain

@synthesize programStack = _programStack;


#define radianperdegree (M_PI/180)

-(NSMutableArray *) programStack
{
    if (!_programStack)
    {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}


-(void) pushOperand:(double)operand
{
    NSNumber *newOperand = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:newOperand];
}


-(double) performOperation:(NSString *) operation
{
    [self.programStack addObject: operation];
    return [CalculatorBrain runProgram:self.programStack];
}


- (id) program
{
    return [self.programStack copy];
}

+ (NSString *) descriptionOfProgram:(id)program
{
    return @"return in assignment 2";
}

+ (double) popOperandOffStack:(NSMutableArray *) stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack)
    {
        [stack removeLastObject];
    }
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"])
        {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        }
        else if ([operation isEqualToString:@"*"])
        {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        }
        else if ([operation isEqualToString:@"-"])
        {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        }
        else if([operation isEqualToString:@"/"])
        {
            double divisor = [self popOperandOffStack:stack];
            if (divisor)
            {
                result = [self popOperandOffStack:stack] / divisor;
            }
        }
        else if ([operation isEqualToString:@"sin"])
        {
            result = sin([self popOperandOffStack:stack] * radianperdegree);
        }
        else if ([operation isEqualToString:@"cos"])
        {
            result = cos([self popOperandOffStack:stack] * radianperdegree);
        }
        else if ([operation isEqualToString:@"sqrt"])
        {
            result = sqrt([self popOperandOffStack:stack]);
        }
        else if ([operation isEqualToString:@"e"])
        {
            result = exp([self popOperandOffStack:stack]);
        }
        else if ([operation isEqualToString:@"log"])
        {
            result = log([self popOperandOffStack:stack]);
        }

    }
    
    
    
    return result;
}

+ (double) runProgram:(id)program
{
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    
    return [self popOperandOffStack:stack];
}


-(void) reset
{
    //[self.operandStack removeAllObjects];
}

@end
