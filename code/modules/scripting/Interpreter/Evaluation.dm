/proc/isobject(x)
	return !(isnum(x) || istext(x))

/n_Interpreter/proc/Eval(node/expression/exp)
	if(istype(exp, /node/expression/FunctionCall))
		return RunFunction(exp)
	else if(istype(exp, /node/expression/operator_node))
		return EvalOperator(exp)
	else if(istype(exp, /node/expression/value/literal))
		var/node/expression/value/literal/lit=exp
		return lit.value
	else if(istype(exp, /node/expression/value/reference))
		var/node/expression/value/reference/ref=exp
		return ref.value
	else if(istype(exp, /node/expression/value/variable))
		var/node/expression/value/variable/v=exp
		if(!v.object)
			return Eval(GetVariable(v.id.id_name))
		else
			var/datum/D
			if(istype(v.object, /node/identifier))
				D=GetVariable(v.object:id_name)
			else
				D=v.object
			D=Eval(D)
			if(!isobject(D))
				return null
			if(!D.vars.Find(v.id.id_name))
				RaiseError(new/runtimeError/UndefinedVariable("[v.object.ToString()].[v.id.id_name]"))
				return null
			return Eval(D.vars[v.id.id_name])
	else if(istype(exp, /node/expression))
		RaiseError(new/runtimeError/UnknownInstruction())
	else
		return exp

/n_Interpreter/proc/EvalOperator(node/expression/operator_node/exp)
	if(istype(exp, /node/expression/operator_node/binary))
		var/node/expression/operator_node/binary/bin=exp
		switch(bin.type)
			if(/node/expression/operator_node/binary/Equal)
				return Equal(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/NotEqual)
				return NotEqual(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/Greater)
				return Greater(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/Less)
				return Less(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/GreaterOrEqual)
				return GreaterOrEqual(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/LessOrEqual)
				return LessOrEqual(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/LogicalAnd)
				return LogicalAnd(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/LogicalOr)
				return LogicalOr(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/LogicalXor)
				return LogicalXor(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/BitwiseAnd)
				return BitwiseAnd(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/BitwiseOr)
				return BitwiseOr(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/BitwiseXor)
				return BitwiseXor(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/Add)
				return Add(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/Subtract)
				return Subtract(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/Multiply)
				return Multiply(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/Divide)
				return Divide(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/Power)
				return Power(Eval(bin.exp), Eval(bin.exp2))
			if(/node/expression/operator_node/binary/Modulo)
				return Modulo(Eval(bin.exp), Eval(bin.exp2))
			else
				RaiseError(new/runtimeError/UnknownInstruction())
		return
	switch(exp.type)
		if(/node/expression/operator_node/unary/Minus)
			return Minus(Eval(exp.exp))
		if(/node/expression/operator_node/unary/LogicalNot)
			return LogicalNot(Eval(exp.exp))
		if(/node/expression/operator_node/unary/BitwiseNot)
			return BitwiseNot(Eval(exp.exp))
		if(/node/expression/operator_node/unary/group)
			return Eval(exp.exp)
		else
			RaiseError(new/runtimeError/UnknownInstruction())


//Binary//
	//Comparison operators
/n_Interpreter/proc/Equal(a, b) 			return a==b
/n_Interpreter/proc/NotEqual(a, b)			return a!=b //LogicalNot(Equal(a, b))
/n_Interpreter/proc/Greater(a, b)			return a>b
/n_Interpreter/proc/Less(a, b)				return a<b
/n_Interpreter/proc/GreaterOrEqual(a, b)	return a>=b
/n_Interpreter/proc/LessOrEqual(a, b)		return a<=b
	//Logical Operators
/n_Interpreter/proc/LogicalAnd(a, b)		return a&&b
/n_Interpreter/proc/LogicalOr(a, b)			return a||b
/n_Interpreter/proc/LogicalXor(a, b)		return (a||b) && !(a&&b)
	//Bitwise Operators
/n_Interpreter/proc/BitwiseAnd(a, b)		return a&b
/n_Interpreter/proc/BitwiseOr(a, b)			return a|b
/n_Interpreter/proc/BitwiseXor(a, b)		return a^b
	//Arithmetic Operators
/n_Interpreter/proc/Add(a, b)
	if(istext(a)&&!istext(b)) 		b="[b]"
	else if(istext(b)&&!istext(a))	a="[a]"
	if(isobject(a) && !isobject(b))
		RaiseError(new/runtimeError/TypeMismatch("+", a, b))
		return null
	else if(isobject(b) && !isobject(a))
		RaiseError(new/runtimeError/TypeMismatch("+", a, b))
		return null
	return a+b
/n_Interpreter/proc/Subtract(a, b)
	if(isobject(a) && !isobject(b))
		RaiseError(new/runtimeError/TypeMismatch("-", a, b))
		return null
	else if(isobject(b) && !isobject(a))
		RaiseError(new/runtimeError/TypeMismatch("-", a, b))
		return null
	return a-b
/n_Interpreter/proc/Divide(a, b)
	if(isobject(a) && !isobject(b))
		RaiseError(new/runtimeError/TypeMismatch("/", a, b))
		return null
	else if(isobject(b) && !isobject(a))
		RaiseError(new/runtimeError/TypeMismatch("/", a, b))
		return null
	if(b==0)
		RaiseError(new/runtimeError/DivisionByZero())
		return null
	return a/b
/n_Interpreter/proc/Multiply(a, b)
	if(isobject(a) && !isobject(b))
		RaiseError(new/runtimeError/TypeMismatch("*", a, b))
		return null
	else if(isobject(b) && !isobject(a))
		RaiseError(new/runtimeError/TypeMismatch("*", a, b))
		return null
	return a*b
/n_Interpreter/proc/Modulo(a, b)
	if(isobject(a) && !isobject(b))
		RaiseError(new/runtimeError/TypeMismatch("%", a, b))
		return null
	else if(isobject(b) && !isobject(a))
		RaiseError(new/runtimeError/TypeMismatch("%", a, b))
		return null
	return a%b
/n_Interpreter/proc/Power(a, b)
	if(isobject(a) && !isobject(b))
		RaiseError(new/runtimeError/TypeMismatch("**", a, b))
		return null
	else if(isobject(b) && !isobject(a))
		RaiseError(new/runtimeError/TypeMismatch("**", a, b))
		return null
	return a**b

//Unary//
/n_Interpreter/proc/Minus(a)				return -a
/n_Interpreter/proc/LogicalNot(a)			return !a
/n_Interpreter/proc/BitwiseNot(a)			return ~a
