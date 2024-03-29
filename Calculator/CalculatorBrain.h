//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Jorn Nordahl on 1/12/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void) pushOperand:(double)operand;
-(void) pushVariableOperand:(NSString *) operand;
-(void) pushOperation:(NSString *) operation;

-(void) reset;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *) variableValues;
+ (NSSet *) variablesUsedInProgram:(id) program;

@end
