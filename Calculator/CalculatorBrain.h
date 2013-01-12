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
-(double) performOperation:(NSString *) operation;
-(void) reset;

@end
