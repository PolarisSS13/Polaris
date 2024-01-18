//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/*
	File: Binary Operators
*/
/*
	Class: binary
	Represents a binary operator in the AST. A binary operator takes two operands (ie x and y) and returns a value.
*/
/node/expression/operator_node/binary
	var/node/expression/exp2

////////// Comparison Operators //////////
/*
	Class: Equal
	Returns true if x = y.
*/
//
/node/expression/operator_node/binary/Equal
	precedence=OOP_EQUAL

/*
	Class: NotEqual
	Returns true if x and y aren't equal.
*/
//
/node/expression/operator_node/binary/NotEqual
	precedence=OOP_EQUAL

/*
	Class: Greater
	Returns true if x > y.
*/
//
/node/expression/operator_node/binary/Greater
	precedence=OOP_COMPARE

/*
	Class: Less
	Returns true if x < y.
*/
//
/node/expression/operator_node/binary/Less
	precedence=OOP_COMPARE

/*
	Class: GreaterOrEqual
	Returns true if x >= y.
*/
//
/node/expression/operator_node/binary/GreaterOrEqual
	precedence=OOP_COMPARE

/*
	Class: LessOrEqual
	Returns true if x <= y.
*/
//
/node/expression/operator_node/binary/LessOrEqual
	precedence=OOP_COMPARE


////////// Logical Operators //////////

/*
	Class: LogicalAnd
	Returns true if x and y are true.
*/
//
/node/expression/operator_node/binary/LogicalAnd
	precedence=OOP_AND

/*
	Class: LogicalOr
	Returns true if x, y, or both are true.
*/
//
/node/expression/operator_node/binary/LogicalOr
	precedence=OOP_OR

/*
	Class: LogicalXor
	Returns true if either x or y but not both are true.
*/
//
/node/expression/operator_node/binary/LogicalXor					//Not implemented in nS
	precedence=OOP_OR


////////// Bitwise Operators //////////

/*
	Class: BitwiseAnd
	Performs a bitwise and operation.

	Example:
	011 & 110 = 010
*/
//
/node/expression/operator_node/binary/BitwiseAnd
	precedence=OOP_BIT

/*
	Class: BitwiseOr
	Performs a bitwise or operation.

	Example:
	011 | 110 = 111
*/
//
/node/expression/operator_node/binary/BitwiseOr
	precedence=OOP_BIT

/*
	Class: BitwiseXor
	Performs a bitwise exclusive or operation.

	Example:
	011 xor 110 = 101
*/
//
/node/expression/operator_node/binary/BitwiseXor
	precedence=OOP_BIT


////////// Arithmetic Operators //////////

/*
	Class: Add
	Returns the sum of x and y.
*/
//
/node/expression/operator_node/binary/Add
	precedence=OOP_ADD

/*
	Class: Subtract
	Returns the difference of x and y.
*/
//
/node/expression/operator_node/binary/Subtract
	precedence=OOP_ADD

/*
	Class: Multiply
	Returns the product of x and y.
*/
//
/node/expression/operator_node/binary/Multiply
	precedence=OOP_MULTIPLY

/*
	Class: Divide
	Returns the quotient of x and y.
*/
//
/node/expression/operator_node/binary/Divide
	precedence=OOP_MULTIPLY

/*
	Class: Power
	Returns x raised to the power of y.
*/
//
/node/expression/operator_node/binary/Power
	precedence=OOP_POW

/*
	Class: Modulo
	Returns the remainder of x / y.
*/
//
/node/expression/operator_node/binary/Modulo
	precedence=OOP_MULTIPLY
