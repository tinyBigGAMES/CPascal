# CPascal BNF Test Suite - Complete Specifications
**147 Test Files Ordered by Incremental Complexity**

## Overview
This test suite provides comprehensive coverage of all 147 BNF rules in the CPascal language grammar. Each test builds upon features from previous tests, following an incremental complexity approach.

## Test Organization

### Level 1: Lexical Foundation (Tests 002-029) - 28 tests
Basic tokens, literals, and lexical elements that form the vocabulary of CPascal.

### Level 2: Program Structure & Basic Declarations (Tests 030-045) - 16 tests  
Simple programs, basic type and variable declarations.

### Level 3: Basic Expressions & Variables (Tests 046-060) - 15 tests
Basic data manipulation and simple expressions.

### Level 4: Complete Expression Hierarchy (Tests 061-075) - 15 tests
Full expression precedence and operator combinations.

### Level 5: Basic Statements (Tests 076-095) - 20 tests
Program flow control and basic statements.

### Level 6: Complex Types (Tests 096-115) - 20 tests
Advanced data structures like records, unions, arrays.

### Level 7: Functions & Procedures (Tests 116-135) - 20 tests
Callable constructs and function declarations.

### Level 8: Advanced Program Structure (Tests 136-148) - 13 tests
Modules, libraries, and compilation control.

## Test File Format
Each test file follows this pattern:
```pascal
// XXX_TestName.cpas
// BNF Rules: <rule1>, <rule2>, <rule3>
program TestName;

function printf(format: PChar, ...): Int32; cdecl; external "msvcrt.dll";

// Test-specific declarations

begin
  // Test code with printf validation output
end.
```

## Complete Test List

| Test # | File Name | Primary BNF Rule | Level |
|--------|-----------|------------------|-------|
| 002 | 002_Identifier.cpas | `<identifier>` | 1 |
| 003 | 003_DecimalInteger.cpas | `<decimal_integer>` | 1 |
| 004 | 004_HexadecimalInteger.cpas | `<hexadecimal_integer>` | 1 |
| 005 | 005_BinaryInteger.cpas | `<binary_integer>` | 1 |
| 006 | 006_OctalInteger.cpas | `<octal_integer>` | 1 |
| 007 | 007_Integer.cpas | `<integer>` | 1 |
| 008 | 008_Real.cpas | `<real>` | 1 |
| 009 | 009_Exponent.cpas | `<exponent>` | 1 |
| 010 | 010_Number.cpas | `<number>` | 1 |
| 011 | 011_String.cpas | `<string>` | 1 |
| 012 | 012_Character.cpas | `<character>` | 1 |
| 013 | 013_EscapeSequence.cpas | `<escape_sequence>` | 1 |
| 014 | 014_LineComment.cpas | `<line_comment>` | 1 |
| 015 | 015_BlockComment.cpas | `<block_comment>` | 1 |
| 016 | 016_BraceComment.cpas | `<brace_comment>` | 1 |
| 017 | 017_Comment.cpas | `<comment>` | 1 |
| 018 | 018_Letter.cpas | `<letter>` | 1 |
| 019 | 019_Digit.cpas | `<digit>` | 1 |
| 020 | 020_HexDigit.cpas | `<hex_digit>` | 1 |
| 021 | 021_BinaryDigit.cpas | `<binary_digit>` | 1 |
| 022 | 022_OctalDigit.cpas | `<octal_digit>` | 1 |
| 023 | 023_PrintableChar.cpas | `<printable_char>` | 1 |
| 024 | 024_AnyChar.cpas | `<any_char>` | 1 |
| 025 | 025_AnyCharExceptNewline.cpas | `<any_char_except_newline>` | 1 |
| 026 | 026_AnyCharExceptBrace.cpas | `<any_char_except_brace>` | 1 |
| 027 | 027_Newline.cpas | `<newline>` | 1 |
| 028 | 028_Sign.cpas | `<sign>` | 1 |
| 029 | 029_StandardType.cpas | `<standard_type>` | 1 |
| 030 | 030_ProgramHeader.cpas | `<program_header>` | 2 |
| 031 | 031_Program.cpas | `<program>` | 2 |
| 032 | 032_ConstantExpression.cpas | `<constant_expression>` | 2 |
| 033 | 033_Constant.cpas | `<constant>` | 2 |
| 034 | 034_ConstDeclaration.cpas | `<const_declaration>` | 2 |
| 035 | 035_ConstSection.cpas | `<const_section>` | 2 |
| 036 | 036_IdentifierList.cpas | `<identifier_list>` | 2 |
| 037 | 037_SimpleType.cpas | `<simple_type>` | 2 |
| 038 | 038_TypeDefinition.cpas | `<type_definition>` | 2 |
| 039 | 039_TypeDeclaration.cpas | `<type_declaration>` | 2 |
| 040 | 040_TypeSection.cpas | `<type_section>` | 2 |
| 041 | 041_QualifiedType.cpas | `<qualified_type>` | 2 |
| 042 | 042_TypeQualifier.cpas | `<type_qualifier>` | 2 |
| 043 | 043_VarDeclaration.cpas | `<var_declaration>` | 2 |
| 044 | 044_VarSection.cpas | `<var_section>` | 2 |
| 045 | 045_Declarations.cpas | `<declarations>` | 2 |
| 046 | 046_Variable.cpas | `<variable>` | 3 |
| 047 | 047_VariableSuffix.cpas | `<variable_suffix>` | 3 |
| 048 | 048_PrimaryExpression.cpas | `<primary_expression>` | 3 |
| 049 | 049_AddingOperator.cpas | `<adding_operator>` | 3 |
| 050 | 050_MultiplyingOperator.cpas | `<multiplying_operator>` | 3 |
| 051 | 051_MultiplicativeExpression.cpas | `<multiplicative_expression>` | 3 |
| 052 | 052_AdditiveExpression.cpas | `<additive_expression>` | 3 |
| 053 | 053_PrefixOperator.cpas | `<prefix_operator>` | 3 |
| 054 | 054_PostfixOperator.cpas | `<postfix_operator>` | 3 |
| 055 | 055_UnaryExpression.cpas | `<unary_expression>` | 3 |
| 056 | 056_PostfixExpression.cpas | `<postfix_expression>` | 3 |
| 057 | 057_ExpressionList.cpas | `<expression_list>` | 3 |
| 058 | 058_BuiltinFunction.cpas | `<builtin_function>` | 3 |
| 059 | 059_SizeofExpression.cpas | `<sizeof_expression>` | 3 |
| 060 | 060_TypeofExpression.cpas | `<typeof_expression>` | 3 |
| 061 | 061_RelationalOperator.cpas | `<relational_operator>` | 4 |
| 062 | 062_EqualityOperator.cpas | `<equality_operator>` | 4 |
| 063 | 063_ShiftOperator.cpas | `<shift_operator>` | 4 |
| 064 | 064_ShiftExpression.cpas | `<shift_expression>` | 4 |
| 065 | 065_RelationalExpression.cpas | `<relational_expression>` | 4 |
| 066 | 066_EqualityExpression.cpas | `<equality_expression>` | 4 |
| 067 | 067_BitwiseAndExpression.cpas | `<bitwise_and_expression>` | 4 |
| 068 | 068_BitwiseXorExpression.cpas | `<bitwise_xor_expression>` | 4 |
| 069 | 069_BitwiseOrExpression.cpas | `<bitwise_or_expression>` | 4 |
| 070 | 070_LogicalAndExpression.cpas | `<logical_and_expression>` | 4 |
| 071 | 071_LogicalOrExpression.cpas | `<logical_or_expression>` | 4 |
| 072 | 072_TernaryExpression.cpas | `<ternary_expression>` | 4 |
| 073 | 073_Expression.cpas | `<expression>` | 4 |
| 074 | 074_AddressOf.cpas | `<address_of>` | 4 |
| 075 | 075_TypeCast.cpas | `<type_cast>` | 4 |
| 076 | 076_EmptyStatement.cpas | `<empty_statement>` | 5 |
| 077 | 077_LabelStatement.cpas | `<label_statement>` | 5 |
| 078 | 078_GotoStatement.cpas | `<goto_statement>` | 5 |
| 079 | 079_LabelSection.cpas | `<label_section>` | 5 |
| 080 | 080_AssignmentStatement.cpas | `<assignment_statement>` | 5 |
| 081 | 081_VariableList.cpas | `<variable_list>` | 5 |
| 082 | 082_ReturnStatement.cpas | `<return_statement>` | 5 |
| 083 | 083_BreakStatement.cpas | `<break_statement>` | 5 |
| 084 | 084_ContinueStatement.cpas | `<continue_statement>` | 5 |
| 085 | 085_SimpleStatement.cpas | `<simple_statement>` | 5 |
| 086 | 086_CompoundStatement.cpas | `<compound_statement>` | 5 |
| 087 | 087_StatementList.cpas | `<statement_list>` | 5 |
| 088 | 088_IfStatement.cpas | `<if_statement>` | 5 |
| 089 | 089_CaseLabelList.cpas | `<case_label_list>` | 5 |
| 090 | 090_CaseList.cpas | `<case_list>` | 5 |
| 091 | 091_CaseStatement.cpas | `<case_statement>` | 5 |
| 092 | 092_WhileStatement.cpas | `<while_statement>` | 5 |
| 093 | 093_ForStatement.cpas | `<for_statement>` | 5 |
| 094 | 094_RepeatStatement.cpas | `<repeat_statement>` | 5 |
| 095 | 095_StructuredStatement.cpas | `<structured_statement>` | 5 |
| 096 | 096_SubrangeType.cpas | `<subrange_type>` | 6 |
| 097 | 097_IndexRange.cpas | `<index_range>` | 6 |
| 098 | 098_PointerType.cpas | `<pointer_type>` | 6 |
| 099 | 099_ArrayType.cpas | `<array_type>` | 6 |
| 100 | 100_EnumList.cpas | `<enum_list>` | 6 |
| 101 | 101_EnumType.cpas | `<enum_type>` | 6 |
| 102 | 102_FieldDeclaration.cpas | `<field_declaration>` | 6 |
| 103 | 103_FieldList.cpas | `<field_list>` | 6 |
| 104 | 104_RecordType.cpas | `<record_type>` | 6 |
| 105 | 105_UnionType.cpas | `<union_type>` | 6 |
| 106 | 106_CallingConvention.cpas | `<calling_convention>` | 6 |
| 107 | 107_ParameterType.cpas | `<parameter_type>` | 6 |
| 108 | 108_ParameterTypeList.cpas | `<parameter_type_list>` | 6 |
| 109 | 109_FunctionType.cpas | `<function_type>` | 6 |
| 110 | 110_ForwardDeclaration.cpas | `<forward_declaration>` | 6 |
| 111 | 111_Statement.cpas | `<statement>` | 6 |
| 112 | 112_FunctionCall.cpas | `<function_call>` | 6 |
| 113 | 113_ProcedureCall.cpas | `<procedure_call>` | 6 |
| 114 | 114_InlineAssembly.cpas | `<inline_assembly>` | 6 |
| 115 | 115_AssemblyBlock.cpas | `<assembly_block>` | 6 |
| 116 | 116_AssemblyLine.cpas | `<assembly_line>` | 7 |
| 117 | 117_AssemblyConstraint.cpas | `<assembly_constraint>` | 7 |
| 118 | 118_OutputOperands.cpas | `<output_operands>` | 7 |
| 119 | 119_InputOperands.cpas | `<input_operands>` | 7 |
| 120 | 120_ClobberedRegisters.cpas | `<clobbered_registers>` | 7 |
| 121 | 121_Operand.cpas | `<operand>` | 7 |
| 122 | 122_ParameterDeclaration.cpas | `<parameter_declaration>` | 7 |
| 123 | 123_ParameterList.cpas | `<parameter_list>` | 7 |
| 124 | 124_FunctionHeader.cpas | `<function_header>` | 7 |
| 125 | 125_FunctionBody.cpas | `<function_body>` | 7 |
| 126 | 126_FunctionModifiers.cpas | `<function_modifiers>` | 7 |
| 127 | 127_ExternalFunction.cpas | `<external_function>` | 7 |
| 128 | 128_InlineFunction.cpas | `<inline_function>` | 7 |
| 129 | 129_VarargsFunction.cpas | `<varargs_function>` | 7 |
| 130 | 130_ExternalVarargsFunction.cpas | `<external_varargs_function>` | 7 |
| 131 | 131_FunctionDeclaration.cpas | `<function_declaration>` | 7 |
| 132 | 132_LibraryHeader.cpas | `<library_header>` | 7 |
| 133 | 133_ModuleHeader.cpas | `<module_header>` | 7 |
| 134 | 134_QualifiedIdentifier.cpas | `<qualified_identifier>` | 7 |
| 135 | 135_QualifiedIdentifierList.cpas | `<qualified_identifier_list>` | 7 |
| 136 | 136_ImportClause.cpas | `<import_clause>` | 8 |
| 137 | 137_ExportList.cpas | `<export_list>` | 8 |
| 138 | 138_ExportsClause.cpas | `<exports_clause>` | 8 |
| 139 | 139_Library.cpas | `<library>` | 8 |
| 140 | 140_Module.cpas | `<module>` | 8 |
| 141 | 141_CompilationUnit.cpas | `<compilation_unit>` | 8 |
| 142 | 142_DirectiveParams.cpas | `<directive_params>` | 8 |
| 143 | 143_DirectiveName.cpas | `<directive_name>` | 8 |
| 144 | 144_CompilerDirective.cpas | `<compiler_directive>` | 8 |
| 145 | 145_IfdefBlock.cpas | `<ifdef_block>` | 8 |
| 146 | 146_IfndefBlock.cpas | `<ifndef_block>` | 8 |
| 147 | 147_ConditionalCompilation.cpas | `<conditional_compilation>` | 8 |
| 148 | 148_CompleteProgram.cpas | All rules integration | 8 |

## Notes
- Each test is designed to be a complete, compilable CPascal program
- Tests build incrementally - later tests use features validated in earlier tests  
- All tests include printf validation output to verify correct parsing and execution
- Tests focus on syntax validation (semantic errors will be tested separately)
