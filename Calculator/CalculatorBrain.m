//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Jorn Nordahl on 1/12/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "CalculatorBrain.h"
#import <math.h>

#define radianperdegree (M_PI/180)

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;



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

-(void) pushOperation:(NSString *) operation
{
    [self.programStack addObject: operation];
}

- (id) program
{
    return [self.programStack copy];
}

+ (NSString *) descriptionOfProgram:(id)program
{
    // make a copy of the stack so we don't modify the real stack:
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }

    // look on everything in the stack untill there is no more:
    NSMutableString *description = [[NSMutableString alloc]init];
    if (stack)
    {
        while (stack.count > 0) {
            NSString *temp = [CalculatorBrain descriptionOfTopOfStack:stack];
            if ([CalculatorBrain isStringWrappedInParents:temp])
            {
                temp = [[temp substringFromIndex:1] substringToIndex:(temp.length - 2)];
            }
            
            [description appendString:temp]; // [CalculatorBrain descriptionOfTopOfStack:stack]];
            if (stack.count >0)
            {
                [description appendString:@", "];
            }
        }
    }
    
    if ([CalculatorBrain isStringWrappedInParents:description])
    {
        return [[description substringFromIndex:1] substringToIndex:(description.length - 2)];
    }
    
    return description;
}



// return a string
+(NSString *) descriptionOfTopOfStack:(NSMutableArray *) stack
{
    NSString *description;
    
    if (stack)
    {
        id topOfStack = [stack lastObject];
        if (topOfStack)
        {
            [stack removeLastObject];
        }
        
        if ([topOfStack isKindOfClass:[NSNumber class]])
        {
            // this is number, just return the description for it:
            return [NSString stringWithFormat:@"%.0f", [topOfStack doubleValue]];
        }
        else if ([topOfStack isKindOfClass:[NSString class]])
        {
            // this is an operation or a variable, figure out which it is:
            NSString *stringObj = topOfStack;
            if ([CalculatorBrain isOperation: stringObj])
            {
                // we have an operation:
                NSString *operation = stringObj;
                
                if ([CalculatorBrain isOperationZero:operation])
                {
                    return [NSString stringWithFormat:@"%@", operation];
                }
                else if ([CalculatorBrain isOperationOne:operation])
                {
                    NSString *operand1 = [CalculatorBrain descriptionOfTopOfStack:stack];
                    if ([CalculatorBrain isStringWrappedInParents:operand1])
                    {
                        return [NSString stringWithFormat:@"%@%@", operation, operand1];
                    }
                    else
                    {
                        return [NSString stringWithFormat:@"%@(%@)", operation, operand1];
                    }
                }
                else if ([CalculatorBrain isOperationTwo:operation])
                {
                    NSString *operand1 = [CalculatorBrain descriptionOfTopOfStack:stack];
                    NSString *operand2 = [CalculatorBrain descriptionOfTopOfStack:stack];
                    
                    return [NSString stringWithFormat:@"(%@ %@ %@)", operand2, operation, operand1];
                }
            }
            else
            {
                // we have a variable:
                //NSString *variable = stringObj;
                
                return @"TODO: VARIABLE";
            }
        }
    }
    
    return description;
}

+(BOOL) isStringWrappedInParents:(NSString *) value
{
    return ([value hasPrefix:@"("] && [value hasSuffix:@")"]);
}

+(BOOL) isOperationZero:(NSString *) operation
{
    if ([operation isEqualToString:@"Pi"])
    {
        return YES;
    }
    return NO;
}

+(BOOL) isOperationOne:(NSString *) operation
{
    if ([operation isEqualToString:@"sin"] ||
        [operation isEqualToString:@"cos"] ||
        [operation isEqualToString:@"sqrt"] ||
        [operation isEqualToString:@"log"] ||
        [operation isEqualToString:@"e"]
        )
    {
        return YES;
    }
    return NO;
}

+(BOOL) isOperationTwo:(NSString *) operation
{
    if ([operation isEqualToString:@"+"] ||
        [operation isEqualToString:@"-"] ||
        [operation isEqualToString:@"*"] ||
        [operation isEqualToString:@"/"])
    {
        return YES;
    }
    return NO;
}

+(BOOL) isOperation:(NSString *) operation
{
    if ([operation isEqualToString:@"+"] ||
        [operation isEqualToString:@"-"] ||
        [operation isEqualToString:@"*"] ||
        [operation isEqualToString:@"/"] ||
        [operation isEqualToString:@"sin"] ||
        [operation isEqualToString:@"cos"] ||
        [operation isEqualToString:@"sqrt"] ||
        [operation isEqualToString:@"log"] ||
        [operation isEqualToString:@"e"]
        )
    {
        return YES;
    }
    return NO;
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

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *) variableValues
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
    [self.programStack removeAllObjects];
}

/*
*/ 
+ (NSSet *) variablesUsedInProgram:(id) program
{
    NSSet *variables = [[NSSet alloc] init];
    
    return variables;
}

@end
