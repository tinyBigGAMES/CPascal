# CPascal Complete Language BNF Grammar

**CPascal** - A systems programming language with Pascal syntax and C semantics, targeting LLVM with **full C ABI compatibility**.

**Core Design Principle**: Every CPascal construct maps directly to equivalent C constructs. All data types, function calls, and memory layouts are identical to C at the binary level. This ensures seamless interoperability with any C library without translation layers or bindings.

## Program Structure
```bnf
<compilation_unit> ::= <program> | <library> | <module>

<program> ::= <comment>* <compiler_directive>* <program_header> <import_clause>? <declarations> <compound_statement> "."

<library> ::= <comment>* <compiler_directive>* <library_header> <import_clause>? <declarations> <exports_clause>? "."

<module> ::= <comment>* <compiler_directive>* <module_header> <import_clause>? <declarations> "."

<program_header> ::= "program" <identifier> ";"

<library_header> ::= "library" <identifier> ";"

<module_header> ::= "module" <identifier> ";"

<import_clause> ::= "import" <qualified_identifier_list> ";"

<qualified_identifier_list> ::= <qualified_identifier> ("," <qualified_identifier>)*

<qualified_identifier> ::= <identifier> ("." <identifier>)*

<identifier_list> ::= <identifier> ("," <identifier>)*

<exports_clause> ::= "exports" <export_list> ";"

<export_list> ::= <qualified_identifier> ("," <qualified_identifier>)*
```

## Compiler Directives
```bnf
<compiler_directive> ::= "{$" <directive_name> <directive_params>? "}"

<directive_name> ::= "IFDEF" | "IFNDEF" | "ELSE" | "ENDIF" | "DEFINE" | "UNDEF"
                   | "LINK" | "LIBPATH" | "APPTYPE" | "MODULEPATH" | "EXEPATH" | "OBJPATH"

<directive_params> ::= <identifier> | <string> | <identifier_list>

<conditional_compilation> ::= <ifdef_block> | <ifndef_block>

<ifdef_block> ::= "{$IFDEF" <identifier> "}" <compilation_unit> ("{$ELSE}" <compilation_unit>)? "{$ENDIF}"

<ifndef_block> ::= "{$IFNDEF" <identifier> "}" <compilation_unit> ("{$ELSE}" <compilation_unit>)? "{$ENDIF}"
```

## Declarations
```bnf
<declarations> ::= (<const_section> | <type_section> | <var_section> | <function_declaration> | <label_section> | <compiler_directive>)*

<const_section> ::= ("public"? "const" | "const") <const_declaration>+

<const_declaration> ::= "public"? <identifier> "=" <constant_expression> ";"

<type_section> ::= ("public"? "type" | "type") <type_declaration>+

<type_declaration> ::= "public"? <identifier> "=" <type_definition> ";"
                     | "public"? <forward_declaration>

<forward_declaration> ::= <identifier> "=" "^" <identifier> ";"

<var_section> ::= ("public"? "var" | "var") <var_declaration>+

<var_declaration> ::= "public"? <identifier_list> ":" <qualified_type> ";"

<label_section> ::= "label" <identifier_list> ";"

<qualified_type> ::= <type_qualifier>* <type_definition>

<type_qualifier> ::= "const" | "volatile"
```

## Type System
```bnf
<type_definition> ::= <simple_type> | <pointer_type> | <array_type> | <record_type> | <union_type> | <function_type> | <enum_type>

<simple_type> ::= <identifier> | <subrange_type>

<pointer_type> ::= "^" <type_definition>

<array_type> ::= "array" "[" <index_range> "]" "of" <type_definition>

<record_type> ::= "packed"? "record" <field_list> "end"

<union_type> ::= "packed"? "union" <field_list> "end"

<enum_type> ::= "(" <enum_list> ")"

<enum_list> ::= <identifier> ("," <identifier>)*

<function_type> ::= "function" "(" <parameter_type_list>? ")" ":" <type_definition> <calling_convention>?
                  | "procedure" "(" <parameter_type_list>? ")" <calling_convention>?

<calling_convention> ::= "cdecl" | "stdcall" | "fastcall" | "register"

<parameter_type_list> ::= <parameter_type> (";" <parameter_type>)* ("," "...")?

<parameter_type> ::= ["const" | "var" | "out"] <qualified_type>

<field_list> ::= <field_declaration> (";" <field_declaration>)*

<field_declaration> ::= <identifier_list> ":" <qualified_type>

<index_range> ::= <constant_expression> ".." <constant_expression>

<subrange_type> ::= <constant_expression> ".." <constant_expression>
```

## Functions and Procedures
```bnf
<function_declaration> ::= "public"? <function_header> <function_modifiers>? ";" <function_body>
                         | "public"? <external_function>
                         | "public"? <inline_function>
                         | "public"? <varargs_function>
                         | "public"? <external_varargs_function>

<function_header> ::= "function" <identifier> "(" <parameter_list>? ")" ":" <type_definition>
                    | "procedure" <identifier> "(" <parameter_list>? ")"

<function_modifiers> ::= <calling_convention> | "inline" 
                       | <calling_convention> ";" "inline"
                       | "inline" ";" <calling_convention>

<function_body> ::= <declarations> <compound_statement>

<parameter_list> ::= <parameter_declaration> (";" <parameter_declaration>)*

<parameter_declaration> ::= ["const" | "var" | "out"] <identifier_list> ":" <qualified_type>

<external_function> ::= <function_header> ";" <calling_convention>? ";" "external" <string>? ";"
                      | <function_header> ";" "external" <string>? ";" <calling_convention>? ";"


<inline_function> ::= <function_header> <calling_convention>? "inline" ";" <function_body>
                    | <function_header> "inline" <calling_convention>? ";" <function_body>

<varargs_function> ::= "function" <identifier> "(" <parameter_list> "," "..." ")" ":" <type_definition> ";" <calling_convention>? ";"
                     | "procedure" <identifier> "(" <parameter_list> "," "..." ")" ";" <calling_convention>? ";"

<external_varargs_function> ::= "function" <identifier> "(" <parameter_list> "," "..." ")" ":" <type_definition> ";" <calling_convention>? ";" "external" <string>? ";"
                              | "function" <identifier> "(" <parameter_list> "," "..." ")" ":" <type_definition> ";" "external" <string>? ";" <calling_convention>? ";"
                              | "procedure" <identifier> "(" <parameter_list> "," "..." ")" ";" <calling_convention>? ";" "external" <string>? ";"
                              | "procedure" <identifier> "(" <parameter_list> "," "..." ")" ";" "external" <string>? ";" <calling_convention>? ";"

```

## Statements
```bnf
<compound_statement> ::= "begin" <statement_list> "end"

<statement_list> ::= <statement> (";" <statement>)*

<statement> ::= <simple_statement> | <structured_statement>

<simple_statement> ::= <assignment_statement> | <procedure_call> | <goto_statement> | <label_statement> 
                     | <empty_statement> | <inline_assembly> | <break_statement> | <continue_statement> | <exit_statement>

<structured_statement> ::= <compound_statement> | <if_statement> | <case_statement> | <while_statement> 
                         | <for_statement> | <repeat_statement>

<assignment_statement> ::= <variable_list> ":=" <expression_list>
                         | <variable> "+=" <expression>
                         | <variable> "-=" <expression>
                         | <variable> "*=" <expression>
                         | <variable> "/=" <expression>
                         | <variable> "and=" <expression>
                         | <variable> "or=" <expression>
                         | <variable> "xor=" <expression>
                         | <variable> "shl=" <expression>
                         | <variable> "shr=" <expression>

<variable_list> ::= <variable> ("," <variable>)*

<procedure_call> ::= <identifier> "(" <expression_list>? ")"
                   | <variable> "(" <expression_list>? ")"

<inline_assembly> ::= "asm" <assembly_block> "end"

<assembly_block> ::= <assembly_line>*

<assembly_line> ::= <string> ";" | <assembly_constraint> ";"

<assembly_constraint> ::= <string> ":" <output_operands> ":" <input_operands> ":" <clobbered_registers>

<output_operands> ::= <operand> ("," <operand>)*

<input_operands> ::= <operand> ("," <operand>)*

<clobbered_registers> ::= <string> ("," <string>)*

<operand> ::= <string> "(" <expression> ")"

<break_statement> ::= "break" ";"

<continue_statement> ::= "continue" ";"

<exit_statement> ::= "exit" ("(" <expression> ")")? ";"

<if_statement> ::= "if" <expression> "then" <statement> ("else" <statement>)?

<case_statement> ::= "case" <expression> "of" <case_list> ("else" <statement_list>)? "end"

<case_list> ::= <case_label_list> ":" <statement> (";" <case_label_list> ":" <statement>)*

<case_label_list> ::= <constant_expression> ("," <constant_expression>)*

<while_statement> ::= "while" <expression> "do" <statement>

<for_statement> ::= "for" <identifier> ":=" <expression> ("to" | "downto") <expression> "do" <statement>

<repeat_statement> ::= "repeat" <statement_list> "until" <expression>

<goto_statement> ::= "goto" <identifier> ";"

<label_statement> ::= <identifier> ":"

<empty_statement> ::= 
```

## Expressions
```bnf
<expression> ::= <ternary_expression>

<ternary_expression> ::= <logical_or_expression> ("?" <expression> ":" <ternary_expression>)?

<logical_or_expression> ::= <logical_and_expression> ("or" <logical_and_expression>)*

<logical_and_expression> ::= <bitwise_or_expression> ("and" <bitwise_or_expression>)*

<bitwise_or_expression> ::= <bitwise_xor_expression> ("|" <bitwise_xor_expression>)*

<bitwise_xor_expression> ::= <bitwise_and_expression> ("xor" <bitwise_and_expression>)*

<bitwise_and_expression> ::= <equality_expression> ("&" <equality_expression>)*

<equality_expression> ::= <relational_expression> (<equality_operator> <relational_expression>)*

<relational_expression> ::= <shift_expression> (<relational_operator> <shift_expression>)*

<shift_expression> ::= <additive_expression> (<shift_operator> <additive_expression>)*

<additive_expression> ::= <multiplicative_expression> (<adding_operator> <multiplicative_expression>)*

<multiplicative_expression> ::= <unary_expression> (<multiplying_operator> <unary_expression>)*

<unary_expression> ::= <postfix_expression> | <prefix_operator> <unary_expression>

<postfix_expression> ::= <primary_expression> <postfix_operator>*

<primary_expression> ::= <variable> | <constant> | "(" <expression> ")" | <function_call> 
                       | <sizeof_expression> | <typeof_expression> | <address_of> | <type_cast>

<variable> ::= <identifier> <variable_suffix>*

<variable_suffix> ::= "[" <expression_list> "]" | "^" | "." <identifier>

<function_call> ::= <identifier> "(" <expression_list>? ")"
                  | <variable> "(" <expression_list>? ")"

<expression_list> ::= <expression> ("," <expression>)*

<sizeof_expression> ::= "SizeOf" "(" (<type_definition> | <expression>) ")"

<typeof_expression> ::= "TypeOf" "(" <expression> ")"

<address_of> ::= "@" <variable>

<type_cast> ::= <type_definition> "(" <expression> ")"

<constant> ::= <number> | <string> | <character> | <identifier> | "nil" | "true" | "false"

<constant_expression> ::= <expression>
```

## Operators
```bnf
<equality_operator> ::= "=" | "<>"

<relational_operator> ::= "<" | "<=" | ">" | ">="

<shift_operator> ::= "shl" | "shr"

<adding_operator> ::= "+" | "-"

<multiplying_operator> ::= "*" | "/" | "div" | "mod"

<prefix_operator> ::= "+" | "-" | "not" | "++" | "--" | "@" | "*"

<postfix_operator> ::= "++" | "--"
```

## Lexical Elements
```bnf
<identifier> ::= <letter> (<letter> | <digit>)*

<number> ::= <integer> | <real>

<integer> ::= <decimal_integer> | <hexadecimal_integer> | <binary_integer> | <octal_integer>

<decimal_integer> ::= <digit>+

<hexadecimal_integer> ::= "0x" <hex_digit>+ | "$" <hex_digit>+

<binary_integer> ::= "0b" <binary_digit>+

<octal_integer> ::= "0o" <octal_digit>+

<real> ::= <digit>+ "." <digit>+ (<exponent>)?
         | <digit>+ <exponent>

<exponent> ::= ("E" | "e") <sign>? <digit>+

<string> ::= '"' <dstring_char>* '"'

<dstring_char> ::= <printable_char> | <escape_sequence>

<character> ::= "#" <digit>+

<escape_sequence> ::= "\" ("n" | "t" | "r" | "b" | "f" | "a" | "v" | "\" | "'" | '"' | "0")
                    | "\" <octal_digit>{1,3}
                    | "\x" <hex_digit>{1,2}
                    | "\u" <hex_digit>{4}
                    | "\U" <hex_digit>{8}

<comment> ::= <line_comment> | <block_comment> | <brace_comment>

<line_comment> ::= "//" <any_char_except_newline>* <newline>

<block_comment> ::= "/*" <any_char>* "*/"

<brace_comment> ::= "{" <any_char_except_brace>* "}"

<letter> ::= "a".."z" | "A".."Z" | "_"

<digit> ::= "0".."9"

<hex_digit> ::= <digit> | "a".."f" | "A".."F"

<binary_digit> ::= "0" | "1"

<octal_digit> ::= "0".."7"

<printable_char> ::= <any_printable_ascii_character>

<any_char> ::= <any_character>

<any_char_except_newline> ::= <any_character_except_newline>

<any_char_except_brace> ::= <any_character_except_closing_brace>

<newline> ::= "\n" | "\r\n" | "\r"

<sign> ::= "+" | "-"
```

## Built-in Functions and Variables (C Compatible)
```bnf
<builtin_function> ::= "SizeOf" | "GetMem" | "FreeMem" | "Inc" | "Dec"

<builtin_variable> ::= "Result"
```

## Standard Types (C ABI Compatible Only)
```bnf
<standard_type> ::= "Int8" | "UInt8" | "Int16" | "UInt16" | "Int32" | "UInt32" | "Int64" | "UInt64"
                  | "Single" | "Double" | "Boolean" | "Char" | "Pointer" | "NativeInt" | "NativeUInt"
                  | "PChar"
```

## C ABI Type Mapping
```
CPascal Type    C Equivalent    Size    Alignment
============    ============    ====    =========
Int8            int8_t          1       1
UInt8           uint8_t         1       1
Int16           int16_t         2       2
UInt16          uint16_t        2       2
Int32           int32_t         4       4
UInt32          uint32_t        4       4
Int64           int64_t         8       8
UInt64          uint64_t        8       8
Single          float           4       4
Double          double          8       8
Boolean         bool            1       1
Char            char            1       1
Pointer         void*           8/4     8/4
NativeInt       intptr_t        8/4     8/4
NativeUInt      uintptr_t       8/4     8/4
PChar           char*           8/4     8/4

Records map to C structs with identical layout and alignment.
Arrays map to C arrays with identical memory layout.
Function pointers use C calling conventions by default.
```

## 🆕 External VarArgs Functions (Added for Phase 1A)

The `<external_varargs_function>` rule enables essential C library integration by combining external function declarations with variadic arguments. This allows direct integration with functions like `printf`, `scanf`, and other C runtime functions that require variable argument lists.

**Examples:**
```pascal
// Standard C runtime functions
function printf(format: PChar, ...): Int32 cdecl external 'msvcrt.dll';
procedure fprintf(stream: Pointer; format: PChar, ...): cdecl external 'msvcrt.dll';  
function scanf(format: PChar, ...): Int32 cdecl external 'msvcrt.dll';

// Custom varargs functions from external libraries
function MyLogger(level: Int32; format: PChar, ...): Boolean stdcall external 'mylib.dll';
```

This addition maintains full BNF compliance while enabling the essential external function capabilities required for real-world C library integration.
