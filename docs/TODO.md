Sounds good. Here is the updated `TODO.md` file with all tasks for **Phase 2: Procedures and Functions** marked as complete.

We are now ready to proceed.

```text
# CPascal Compiler - Full BNF Implementation TODO

This document outlines the features and implementation steps required to bring the CPascal compiler from its current state to 100% compliance with the `CPASCAL-BNF.md` specification.

Each feature is broken down by the compiler stage that needs modification.

## Phase 1: Foundational Control Structures

The goal of this phase is to implement the basic iterative constructs essential for most programs.

### 1.1 `while` Statement
-   **BNF:** `<while_statement> ::= "while" <expression> "do" <statement>`
-   **Tasks:**
    -   `[x]` **AST:** Create `TWhileStatementNode` in `CPascal.AST.pas`.
    -   `[x]` **Parser:** Implement `ParseWhileStatement` in `CPascal.Parser.pas`.
    -   `[x]` **Semantic:** Implement `VisitWhileStatement` in `CPascal.Semantic.pas` to ensure the condition is a boolean type.
    -   `[x]` **IRGen:** Implement `VisitWhileStatement` in `CPascal.IRGen.pas` to generate the correct control flow blocks (`br i1`, `br`).
    -   `[x]` **Tests:** Add tests to `CPascal.Test.Parser.pas` and `CPascal.Test.IRGen.pas`.

### 1.2 `repeat..until` Statement
-   **BNF:** `<repeat_statement> ::= "repeat" <statement_list> "until" <expression>`
-   **Tasks:**
    -   `[x]` **AST:** Create `TRepeatStatementNode`.
    -   `[x]` **Parser:** Implement `ParseRepeatStatement`.
    -   `[x]` **Semantic:** Implement `VisitRepeatStatement` to check the condition.
    -   `[x]` **IRGen:** Implement `VisitRepeatStatement` to generate the correct loop and conditional branch.
    -   `[x]` **Tests:** Add new unit tests.

### 1.3 `for` Statement
-   **BNF:** `<for_statement> ::= "for" <identifier> ":=" <expression> ("to" | "downto") <expression> "do" <statement>`
-   **Tasks:**
    -   `[x]` **AST:** Create `TForStatementNode` (including direction `to`/`downto`).
    -   `[x]` **Parser:** Implement `ParseForStatement`.
    -   `[x]` **Semantic:** Implement `VisitForStatement`. This is complex; it must declare the loop variable within the loop's scope and verify that start/end expressions are ordinal types.
    -   `[x]` **IRGen:** Implement `VisitForStatement` to generate the initialization, condition check, increment/decrement, and body blocks.
    -   `[x]` **Tests:** Add new unit tests.

### 1.4 Loop Control Statements
-   **BNF:** `<break_statement>`, `<continue_statement>`
-   **Tasks:**
    -   `[x]` **AST:** Create `TBreakStatementNode` and `TContinueStatementNode`.
    -   `[x]` **Parser:** Add logic to `ParseStatement` to recognize `break` and `continue`.
    -   `[x]` **Semantic:** The analyzer must verify that `break` and `continue` only appear inside a loop structure. This will require the analyzer to maintain a loop context stack.
    -   `[x]` **IRGen:** The generator must know the current loop's header and exit blocks to generate the correct `br` instructions.
    -   `[x]` **Tests:** Add tests for loops containing these statements.

## Phase 2: Procedures and Functions

This phase implements the ability to declare and call subroutines.

### 2.1 Basic Procedure & Function Declaration/Calls
-   **BNF:** `<function_declaration>`, `<procedure_call>`, `<function_call>`
-   **Tasks:**
    -   `[x]` **AST:** Create `TFunctionDeclNode`, `TProcedureCallNode`, and `TFunctionCallNode`. The function node needs to store parameters, return type, and the body.
    -   `[x]` **Parser:** Implement `ParseFunctionDeclaration` and update `ParseStatement` and `ParseFactor` to handle procedure/function calls.
    -   `[x]` **Semantic:** This is a major update.
        -   Implement nested scopes in the `TCPSymbolTable`.
        -   The analyzer must process function signatures and store `TFunctionSymbol`s.
        -   Implement `VisitFunctionDeclNode` to create a new scope, declare parameters, and analyze the body.
        -   Implement `VisitProcedureCallNode`/`VisitFunctionCallNode` to verify that the function exists and that the arguments match the parameter types and count.
    -   `[x]` **IRGen:** This is a major update.
        -   Implement `VisitFunctionDeclNode` to generate `define` blocks for each function in LLVM IR.
        -   Implement `VisitProcedureCallNode`/`VisitFunctionCallNode` to generate `call` instructions.
        -   Handle the `Result` variable for function return values.
    -   `[x]` **Tests:** Add extensive tests for declaring and calling functions and procedures.

### 2.2 Advanced Parameter Types
-   **BNF:** `["const" | "var" | "out"] <identifier_list> ":" <qualified_type>`
-   **Tasks:**
    -   `[x]` **AST:** Enhance `TParameterNode` to store the parameter passing mechanism (`const`, `var`, `out`).
    -   `[x]` **Parser:** Update `ParseParameterDeclaration` to handle these keywords.
    -   `[x]` **Semantic:** Update symbol table and call-site checking to handle pass-by-reference vs. pass-by-value semantics.
    -   `[x]` **IRGen:** `var`/`out` parameters must be handled as pointers (`byval` or `sret` attributes may be needed).
    -   `[x]` **Tests:** Add tests for all parameter kinds.

### 2.3 `external` Functions and Calling Conventions
-   **BNF:** `<external_function>`, `<calling_convention>`
-   **Tasks:**
    -   `[x]` **AST:** Enhance `TFunctionDeclNode` with flags for `external` and an enum for calling conventions (`cdecl`, `stdcall`, etc.).
    -   `[x]` **Parser:** Implement parsing for these attributes on function declarations.
    -   `[x]` **IRGen:** Set the appropriate LLVM calling convention on the function definition. For `external` functions, generate a declaration instead of a definition.
    -   `[x]` **Tests:** Add tests for declaring external functions with different calling conventions.

## Phase 3: Core Type System

This phase implements pointers, arrays, and records.

### 3.1 Pointer Types
-   **BNF:** `<pointer_type> ::= "^" <type_definition>`
-   **Tasks:**
    -   `[ ]` **AST:** Create `TPointerTypeNode`.
    -   `[ ]` **Parser:** Add logic to `ParseTypeDefinition` to recognize pointer syntax.
    -   `[ ]` **Semantic:** Add support for pointer types.
    -   `[ ]` **IRGen:** Represent pointer types using `LLVMPointerType`.
    -   `[ ]` **Expressions:** Implement `@` (address-of) and `^` (dereference) operators in the AST, parser, semantic analyzer, and IR generator (`load`, `store`, `getelementptr`).
    -   `[ ]` **Tests:** Add tests for pointer declaration, address-of, and dereferencing.

### 3.2 Array Types
-   **BNF:** `<array_type> ::= "array" "[" <index_range> "]" "of" <type_definition>`
-   **Tasks:**
    -   `[ ]` **AST:** Create `TArrayTypeNode`.
    -   `[ ]` **Parser:** Implement `ParseArrayType`.
    -   `[ ]` **Semantic:** Add support for array types.
    -   `[ ]` **IRGen:** Represent array types using `LLVMArrayType2`.
    -   `[ ]` **Expressions:** Implement array indexing (`variable[index]`) in all compiler stages. This will require `getelementptr` instructions in the IR generator.
    -   `[ ]` **Tests:** Add tests for array declaration and element access.

### 3.3 Record Types
-   **BNF:** `<record_type> ::= "packed"? "record" <field_list> "end"`
-   **Tasks:**
    -   `[ ]` **AST:** Create `TRecordTypeNode` and `TFieldDeclNode`.
    -   `[ ]` **Parser:** Implement `ParseRecordType`.
    -   `[ ]` **Semantic:** Add support for record types and their scopes.
    -   `[ ]` **IRGen:** Represent record types using `LLVMStructType`. Handle member access (`.`) using `getelementptr`.
    -   `[ ]` **Expressions:** Implement field access (`variable.field`) in all compiler stages.
    -   `[ ]` **Tests:** Add tests for record declaration and field access.

## Phase 4: Remaining Language Features

This phase covers remaining features required for full compliance.

### 4.1 `case` Statement
-   **BNF:** `<case_statement> ::= "case" <expression> "of" <case_list> ("else" <statement_list>)? "end"`
-   **Tasks:**
    -   `[ ]` **All Stages:** Implement nodes, parsing, semantic checks, and IR generation (`switch` instruction) for the `case` statement.
    -   `[ ]` **Tests:** Add comprehensive tests.

### 4.2 Other Type Definitions
-   **BNF:** `<union_type>`, `<enum_type>`, `<subrange_type>`
-   **Tasks:**
    -   `[ ]` **All Stages:** Implement support for union, enum, and subrange types. This will require significant work in the semantic analyzer to handle type equivalence and range checking.
    -   `[ ]` **Tests:** Add tests for each new type.

### 4.3 Advanced Expressions
-   **BNF:** Full operator precedence, `<ternary_expression>`, `<type_cast>`, `<sizeof_expression>`
-   **Tasks:**
    -   `[ ]` **Parser/IRGen:** Implement the full expression precedence tree (bitwise, logical operators).
    -   `[ ]` **All Stages:** Add support for the ternary operator, explicit type casting, and the `SizeOf` function.
    -   `[ ]` **Tests:** Add tests for all new expression forms.

### 4.4 Top-Level Constructs & Directives
-   **BNF:** `<library>`, `<module>`, `<import_clause>`, `<exports_clause>`, `<compiler_directive>`
-   **Tasks:**
    -   `[ ]` **All Stages:** Implement the logic to handle different compilation unit types and their associated import/export behavior.
    -   `[ ]` **Parser/Lexer:** Add support for parsing compiler directives `{$...}`.
    -   `[ ]` **Compiler:** The main compiler driver will need logic to act on the directives (e.g., conditional compilation).
    -   `[ ]` **Tests:** Add tests for libraries, modules, and directives.
```