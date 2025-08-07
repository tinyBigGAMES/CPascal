{===============================================================================

                         ▒▓▓██████▓▒▒
                     ▒▓███████████████▓
                   ▒█████████▓▓▓████████▒ ▒▓▓▒
                  ▓██████▒         ▓██▓  ▓████▓▒▓▓
                 ▓█████▒               ▓███████████
                 █████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███▓    ▓███▓
                ▓████████████████████████      █████▒
                ▓████▓   ██▒     ▓█▓ ████     ▓████▓
                ▒█████   ▓        ▓▒ █████████████▓
                 ██████              █████████████▓
                  ██████▒            ████▒████  ▒
                   ▓███████▓▒▒▒▒▒▓█▓ ████  ▒▒
                     ▓█████████████▓ ███▓
                       ▒▓██████████▓ ▒▒
                            ▒▒▒▒▒

     ▒▓▓▓▒▒   ▓▓▓▓▓▓▒▒                                             ™
   ███▓▒▓███▒ ███▓▓▓███                                         ██▒
  ███     ▒▓▓ ██▓    ██▓ ▓█████▓  ▒█████▓   ▓█████▓   ▓█████▓   ██▒
 ▒██▒         ██▓▒▒▒▓██▒▒▓▓   ██▓ ██▓  ▒▒▒ ██▓   ▓█▓  ▓▓   ▓██  ██▒
  ██▓         ███▓▓▓▓▒  ▒▓██▓███▓ ▒▓████▓  ██▒       ▒▓███████  ██▒
  ▒██▓▒ ▒▓██▓ ██▓       ██▓  ▒██▓ ▓▓   ▓██ ▓██▒  ▓█▓ ███   ███  ██▒
    ▒▓████▓   ██▒        ▓███▓▓█▒ ▒▓████▓   ▒▓███▓▒   ▓███▓▒█▓  ██▒
                    Better C with Pascal Syntax

 Copyright © 2025-present tinyBigGAMES™ LLC
 All Rights Reserved.

 https://cpascal.org

 BSD 3-Clause License

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the copyright holder nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
===============================================================================}

unit CPascal.CodeGen.Statements;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  CPascal.LLVM,
  CPascal.Platform,
  CPascal.Exception,
  CPascal.Lexer,
  CPascal.CodeGen,
  CPascal.AST,
  CPascal.AST.Statements,
  CPascal.AST.Expressions;

procedure GenerateStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
procedure GenerateCompoundStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPCompoundStatementNode);
procedure GenerateExpressionStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
procedure GenerateAssignmentStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
function GenerateArrayElementPointer(const ACodeGen: TCPCodeGen; const AArrayAccess: TCPArrayAccessNode): LLVMValueRef;
procedure GenerateIfStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
procedure GenerateWhileStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
procedure GenerateForStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
procedure GenerateCaseStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
procedure GenerateBreakStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
procedure GenerateContinueStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
procedure GenerateReturnStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
procedure EnsureBasicBlockHasTerminator(const ACodeGen: TCPCodeGen; const ALocation: TCPSourceLocation);

implementation

uses
  CPascal.CodeGen.Expressions;

// Helper function to generate pointer to array element for assignment
function GenerateArrayElementPointer(const ACodeGen: TCPCodeGen; const AArrayAccess: TCPArrayAccessNode): LLVMValueRef;
var
  LIndexValue: LLVMValueRef;
  LArrayIdentifier: TCPIdentifierNode;
  LArraySymbol: LLVMValueRef;
  LArrayType: LLVMTypeRef;
  LIndices: array[0..1] of LLVMValueRef;
begin
  if AArrayAccess = nil then
  begin
    Result := nil;
    Exit;
  end;
  
  // Get the array variable (should be an identifier)
  if AArrayAccess.ArrayExpression.NodeKind <> nkIdentifier then
  begin
    ACodeGen.CodeGenError('Array access only supported on identifier expressions', [], AArrayAccess.Location);
    Result := nil;
    Exit;
  end;
  
  LArrayIdentifier := TCPIdentifierNode(AArrayAccess.ArrayExpression);
  LArraySymbol := ACodeGen.SymbolTable.GetSymbol(LArrayIdentifier.IdentifierName);
  if LArraySymbol = nil then
  begin
    ACodeGen.CodeGenError('Undefined array variable: %s', [LArrayIdentifier.IdentifierName], AArrayAccess.Location);
    Result := nil;
    Exit;
  end;
  
  // Generate index expression
  LIndexValue := GenerateExpression(ACodeGen, AArrayAccess.IndexExpression);
  if LIndexValue = nil then
  begin
    ACodeGen.CodeGenError('Failed to generate array index expression', [], AArrayAccess.Location);
    Result := nil;
    Exit;
  end;
  
  // Get array type information
  LArrayType := LLVMGetAllocatedType(LArraySymbol);
  if LLVMGetTypeKind(LArrayType) <> LLVMArrayTypeKind then
  begin
    ACodeGen.CodeGenError('Variable is not an array type: %s', [LArrayIdentifier.IdentifierName], AArrayAccess.Location);
    Result := nil;
    Exit;
  end;
  
  // Create GEP indices: [0, index] for array access
  // First index (0) to get past the alloca pointer
  // Second index is the actual array index
  LIndices[0] := LLVMConstInt(LLVMInt32TypeInContext(ACodeGen.Context), 0, 0);
  LIndices[1] := LIndexValue;
  
  // Generate GEP (Get Element Pointer) instruction - returns pointer to element
  Result := LLVMBuildGEP2(ACodeGen.Builder, LArrayType, LArraySymbol, @LIndices[0], 2, CPAsUTF8('arrayptr'));
  if Result = nil then
    ACodeGen.CodeGenError('Failed to generate array element pointer', [], AArrayAccess.Location);
end;

procedure GenerateStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
begin
  if AStatement = nil then
    Exit; // No statement to generate

  case AStatement.NodeKind of
    nkCompoundStatement:
      GenerateCompoundStatement(ACodeGen, TCPCompoundStatementNode(AStatement));

    nkFunctionCall:
      GenerateExpressionStatement(ACodeGen, AStatement);

    nkAssignmentStatement:
      GenerateAssignmentStatement(ACodeGen, AStatement);

    nkIfStatement:
      GenerateIfStatement(ACodeGen, AStatement);

    nkWhileStatement:
      GenerateWhileStatement(ACodeGen, AStatement);

    nkForStatement:
      GenerateForStatement(ACodeGen, AStatement);

    nkCaseStatement:
      GenerateCaseStatement(ACodeGen, AStatement);

    nkBreakStatement:
      GenerateBreakStatement(ACodeGen, AStatement);

    nkContinueStatement:
      GenerateContinueStatement(ACodeGen, AStatement);

    nkReturnStatement:
      GenerateReturnStatement(ACodeGen, AStatement);

    // Other statement types not yet implemented
    nkGotoStatement, nkLabelStatement:
    begin
      ACodeGen.CodeGenError('Statement type %s not yet implemented', [CPNodeKindToString(AStatement.NodeKind)], AStatement.Location);
    end;

  else
    ACodeGen.CodeGenError('Unexpected statement node kind: %s', [CPNodeKindToString(AStatement.NodeKind)], AStatement.Location);
  end;
end;

procedure GenerateCompoundStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPCompoundStatementNode);
var
  LIndex: Integer;
  LStatement: TCPStatementNode;
begin
  if AStatement = nil then
    Exit; // No compound statement to generate

  // Generate each statement in the compound statement
  for LIndex := 0 to AStatement.StatementCount - 1 do
  begin
    LStatement := AStatement.GetStatement(LIndex);
    GenerateStatement(ACodeGen, LStatement);
  end;
end;

procedure GenerateExpressionStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
var
  LExpression: TCPExpressionNode;
  //LCallResult: LLVMValueRef;
begin
  if (AStatement = nil) or (AStatement.ChildCount = 0) then
    Exit; // No expression to generate

  // Get the expression from the statement's first child
  LExpression := TCPExpressionNode(AStatement.GetChild(0));
  if LExpression = nil then
  begin
    ACodeGen.CodeGenError('Expression statement has nil child expression', [], AStatement.Location);
    Exit;
  end;

  // Only generate expressions that have side effects (like function calls)
  // Don't execute pure value expressions as statements
  case LExpression.NodeKind of
    nkFunctionCall:
    begin
      // Function calls have side effects, so execute them
      {LCallResult :=} GenerateExpression(ACodeGen, LExpression);
      // Result is used for the call instruction, but we don't need to store it
    end;
    
    // Other expression types that might have side effects can be added here
    
  else
    // Pure value expressions (literals, identifiers, etc.) should not be executed as statements
    ACodeGen.CodeGenError('Expression of type %s cannot be used as a statement', [CPNodeKindToString(LExpression.NodeKind)], LExpression.Location);
  end;
end;

procedure GenerateAssignmentStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
var
  LAssignmentStatement: TCPAssignmentStatementNode;
  LVariableExpression: TCPExpressionNode;
  LValueExpression: TCPExpressionNode;
  LVariableIdentifier: TCPIdentifierNode;
  LArrayIdentifier: TCPIdentifierNode;
  LVariableAlloca: LLVMValueRef;
  LValueResult: LLVMValueRef;
  LCurrentValue: LLVMValueRef;
  LVariableType: LLVMTypeRef;
  //LStringLiteral: TCPLiteralNode;
  //LStringValue: string;
  //LIntValue: Int64;
  //LBinaryOp: TCPBinaryOperationNode;
  LIndex: Integer;
  LNeedsStringToCharConversion: Boolean;
  LStringPointer: LLVMValueRef;
  LArrayAccess: TCPArrayAccessNode;
  LArraySymbol: LLVMValueRef;
  LArrayType: LLVMTypeRef;
  LElementType: LLVMTypeRef;
  LVarIdentifier: TCPIdentifierNode;
  LVarSymbol: LLVMValueRef;
  LVarType: LLVMTypeRef;
  LTargetWidth: Cardinal;
  LValueWidth: Cardinal;
begin
  if not (AStatement is TCPAssignmentStatementNode) then
  begin
    ACodeGen.CodeGenError('Invalid assignment statement node type', [], AStatement.Location);
    Exit;
  end;
  
  LAssignmentStatement := TCPAssignmentStatementNode(AStatement);
  
  // Validate equal variable and expression counts for basic assignment
  if (LAssignmentStatement.AssignmentOperator = tkAssign) and 
     (LAssignmentStatement.VariableCount <> LAssignmentStatement.ExpressionCount) then
  begin
    ACodeGen.CodeGenError('Variable count (%d) must equal expression count (%d)', [LAssignmentStatement.VariableCount, LAssignmentStatement.ExpressionCount], AStatement.Location);
    Exit;
  end;
  
  // Compound assignment operators only support single variable
  if (LAssignmentStatement.AssignmentOperator <> tkAssign) and 
     ((LAssignmentStatement.VariableCount <> 1) or (LAssignmentStatement.ExpressionCount <> 1)) then
  begin
    ACodeGen.CodeGenError('Compound assignment operators only support single variable assignments', [], AStatement.Location);
    Exit;
  end;
  
  // Generate assignment for each variable/expression pair
  for LIndex := 0 to LAssignmentStatement.VariableCount - 1 do
  begin
    // Initialize for this iteration
    LVariableIdentifier := nil;
    
    // Get the variable (LHS)
    LVariableExpression := TCPExpressionNode(LAssignmentStatement.GetVariable(LIndex));
    
    // Check if this is a dereferenced pointer assignment (LPtr^ := value)
    if (LVariableExpression is TCPUnaryOperationNode) and 
       (TCPUnaryOperationNode(LVariableExpression).Operator = tkDereference) then
    begin
      // Handle pointer dereference on LHS
      // Get the pointer expression
      LVariableExpression := TCPUnaryOperationNode(LVariableExpression).Operand;
      if not (LVariableExpression is TCPIdentifierNode) then
      begin
        ACodeGen.CodeGenError('Complex pointer dereference not yet implemented', [], AStatement.Location);
        Exit;
      end;
      
      LVariableIdentifier := TCPIdentifierNode(LVariableExpression);
      
      // Look up pointer variable in symbol table
      LVariableAlloca := ACodeGen.SymbolTable.GetSymbol(LVariableIdentifier.IdentifierName);
      if LVariableAlloca = nil then
      begin
        ACodeGen.CodeGenError('Undefined pointer variable: %s', [LVariableIdentifier.IdentifierName], AStatement.Location);
        Exit;
      end;
      
      // Load the pointer value (the address it points to)
      LVariableType := LLVMGetAllocatedType(LVariableAlloca);
      LVariableAlloca := LLVMBuildLoad2(ACodeGen.Builder, LVariableType, LVariableAlloca, 
        CPAsUTF8(LVariableIdentifier.IdentifierName + '_ptr'));
      // Now LVariableAlloca contains the address to store to
    end
    else if LVariableExpression is TCPArrayAccessNode then
    begin
      // Handle array access assignment (LArray[index] := value)
      LVariableAlloca := GenerateArrayElementPointer(ACodeGen, TCPArrayAccessNode(LVariableExpression));
      if LVariableAlloca = nil then
      begin
        ACodeGen.CodeGenError('Failed to generate array element pointer for assignment', [], AStatement.Location);
        Exit;
      end;
      // LVariableAlloca now contains the pointer to the array element
    end
    else if LVariableExpression is TCPIdentifierNode then
    begin
      // Simple identifier assignment
      LVariableIdentifier := TCPIdentifierNode(LVariableExpression);
      
      // Look up variable in symbol table
      LVariableAlloca := ACodeGen.SymbolTable.GetSymbol(LVariableIdentifier.IdentifierName);
      if LVariableAlloca = nil then
      begin
        ACodeGen.CodeGenError('Undefined variable: %s', [LVariableIdentifier.IdentifierName], AStatement.Location);
        Exit;
      end;
    end
    else
    begin
      ACodeGen.CodeGenError('Invalid left-hand side in assignment: %s', [CPNodeKindToString(LVariableExpression.NodeKind)], AStatement.Location);
      Exit;
    end;
    
    // Generate the value expression (RHS)
    LValueExpression := TCPExpressionNode(LAssignmentStatement.GetExpression(LIndex));
    
    // Check if we need to convert string literal to character
    LNeedsStringToCharConversion := False;
    
    if (LValueExpression is TCPLiteralNode) and 
       (TCPLiteralNode(LValueExpression).NodeKind = nkStringLiteral) then
    begin
      // Check if target is character type
      if LVariableExpression is TCPArrayAccessNode then
      begin
        // Array access - check if it's a character array
        LArrayAccess := TCPArrayAccessNode(LVariableExpression);
        if (LArrayAccess.ArrayExpression.NodeKind = nkIdentifier) then
        begin
          LArrayIdentifier := TCPIdentifierNode(LArrayAccess.ArrayExpression);
          LArraySymbol := ACodeGen.SymbolTable.GetSymbol(LArrayIdentifier.IdentifierName);
          if LArraySymbol <> nil then
          begin
            LArrayType := LLVMGetAllocatedType(LArraySymbol);
            if LLVMGetTypeKind(LArrayType) = LLVMArrayTypeKind then
            begin
              LElementType := LLVMGetElementType(LArrayType);
              if (LLVMGetTypeKind(LElementType) = LLVMIntegerTypeKind) and 
                 (LLVMGetIntTypeWidth(LElementType) = 8) then
              begin
                LNeedsStringToCharConversion := True;
              end;
            end;
          end;
        end;
      end
      else if LVariableExpression is TCPIdentifierNode then
      begin
        // Simple variable - check if it's char type
        LVarIdentifier := TCPIdentifierNode(LVariableExpression);
        LVarSymbol := ACodeGen.SymbolTable.GetSymbol(LVarIdentifier.IdentifierName);
        if LVarSymbol <> nil then
        begin
          LVarType := LLVMGetAllocatedType(LVarSymbol);
          if (LLVMGetTypeKind(LVarType) = LLVMIntegerTypeKind) and 
             (LLVMGetIntTypeWidth(LVarType) = 8) then
          begin
            LNeedsStringToCharConversion := True;
          end;
        end;
      end;
    end;
    
    if LNeedsStringToCharConversion then
    begin
      // Generate string literal first
      LStringPointer := GenerateExpression(ACodeGen, LValueExpression);
      if LStringPointer = nil then
      begin
        ACodeGen.CodeGenError('Failed to generate string literal for character conversion', [], AStatement.Location);
        Exit;
      end;
      
      // Extract first character: *string_ptr
      LValueResult := LLVMBuildLoad2(ACodeGen.Builder, LLVMInt8TypeInContext(ACodeGen.Context), 
                                      LStringPointer, CPAsUTF8('str_to_char'));
      if LValueResult = nil then
      begin
        ACodeGen.CodeGenError('Failed to extract first character from string literal', [], AStatement.Location);
        Exit;
      end;
    end
    else
    begin
      // Normal expression generation
      LValueResult := GenerateExpression(ACodeGen, LValueExpression);
    end;
    if LValueResult = nil then
    begin
      ACodeGen.CodeGenError('Failed to generate expression for assignment', [], AStatement.Location);
      Exit;
    end;
    
    // Handle different assignment operators
    case LAssignmentStatement.AssignmentOperator of
      tkAssign:
      begin
        // Simple assignment: var := expr

        // Handle type conversion if needed - truncate i64 literals to target variable type
        if LVariableIdentifier <> nil then  // Only for simple variable assignment
        begin
          LVariableType := LLVMGetAllocatedType(LVariableAlloca);
          if (LVariableType <> nil) and
             (LLVMGetTypeKind(LVariableType) = LLVMIntegerTypeKind) and
             (LLVMGetTypeKind(LLVMTypeOf(LValueResult)) = LLVMIntegerTypeKind) then
          begin
            LTargetWidth := LLVMGetIntTypeWidth(LVariableType);
            LValueWidth := LLVMGetIntTypeWidth(LLVMTypeOf(LValueResult));

            if LValueWidth > LTargetWidth then
            begin
              // Truncate the value to target type
              LValueResult := LLVMBuildTrunc(ACodeGen.Builder, LValueResult, LVariableType, CPAsUTF8('trunc_assign'));
            end;
          end;

          // Handle float/double conversion too
          if (LLVMGetTypeKind(LVariableType) = LLVMFloatTypeKind) and
             (LLVMGetTypeKind(LLVMTypeOf(LValueResult)) = LLVMDoubleTypeKind) then
          begin
            // Truncate double to float
            LValueResult := LLVMBuildFPTrunc(ACodeGen.Builder, LValueResult, LVariableType, CPAsUTF8('float_trunc'));
          end;
        end;

        if LLVMBuildStore(ACodeGen.Builder, LValueResult, LVariableAlloca) = nil then
        begin
          if LVariableIdentifier <> nil then
            ACodeGen.CodeGenError('Failed to generate store instruction for variable: %s', [LVariableIdentifier.IdentifierName], AStatement.Location)
          else
            ACodeGen.CodeGenError('Failed to generate store instruction', [], AStatement.Location);
          Exit;
        end;
      end;
      
      tkPlusAssign, tkMinusAssign, tkMultiplyAssign, tkDivideAssign:
      begin
        // Compound assignment: var op= expr  =>  var := var op expr
        // Only supported for simple identifiers currently
        if LVariableIdentifier = nil then
        begin
          ACodeGen.CodeGenError('Compound assignment operators only supported on simple variables', [], AStatement.Location);
          Exit;
        end;
        
        // Get variable type for load operation
        LVariableType := LLVMGetAllocatedType(LVariableAlloca);
        if LVariableType = nil then
        begin
          ACodeGen.CodeGenError('Failed to get variable type for compound assignment: %s', [LVariableIdentifier.IdentifierName], AStatement.Location);
          Exit;
        end;
        
        // Load current value of variable
        LCurrentValue := LLVMBuildLoad2(ACodeGen.Builder, LVariableType, LVariableAlloca, PAnsiChar(UTF8String(LVariableIdentifier.IdentifierName + '_current')));
        if LCurrentValue = nil then
        begin
          ACodeGen.CodeGenError('Failed to load current value for compound assignment: %s', [LVariableIdentifier.IdentifierName], AStatement.Location);
          Exit;
        end;
        
        // Generate binary operation
        case LAssignmentStatement.AssignmentOperator of
          tkPlusAssign:
            LValueResult := LLVMBuildAdd(ACodeGen.Builder, LCurrentValue, LValueResult, PAnsiChar(UTF8String(LVariableIdentifier.IdentifierName + '_add')));
          tkMinusAssign:
            LValueResult := LLVMBuildSub(ACodeGen.Builder, LCurrentValue, LValueResult, PAnsiChar(UTF8String(LVariableIdentifier.IdentifierName + '_sub')));
          tkMultiplyAssign:
            LValueResult := LLVMBuildMul(ACodeGen.Builder, LCurrentValue, LValueResult, PAnsiChar(UTF8String(LVariableIdentifier.IdentifierName + '_mul')));
          tkDivideAssign:
            LValueResult := LLVMBuildSDiv(ACodeGen.Builder, LCurrentValue, LValueResult, PAnsiChar(UTF8String(LVariableIdentifier.IdentifierName + '_div')));
        end;
        
        if LValueResult = nil then
        begin
          ACodeGen.CodeGenError('Failed to generate binary operation for compound assignment: %s', [LVariableIdentifier.IdentifierName], AStatement.Location);
          Exit;
        end;
        
        // Store result back to variable
        if LLVMBuildStore(ACodeGen.Builder, LValueResult, LVariableAlloca) = nil then
        begin
          if LVariableIdentifier <> nil then
            ACodeGen.CodeGenError('Failed to generate store instruction for compound assignment: %s', [LVariableIdentifier.IdentifierName], AStatement.Location)
          else
            ACodeGen.CodeGenError('Failed to generate store instruction for compound assignment', [], AStatement.Location);
          Exit;
        end;
      end;
      
    else
      ACodeGen.CodeGenError('Assignment operator %s not yet implemented', [CPTokenKindToString(LAssignmentStatement.AssignmentOperator)], AStatement.Location);
      Exit;
    end;
  end;
end;

procedure GenerateIfStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
var
  LIfStatement: TCPIfStatementNode;
  LConditionValue: LLVMValueRef;
  LCurrentFunction: LLVMValueRef;
  LCurrentBlock: LLVMBasicBlockRef;
  LThenBlock: LLVMBasicBlockRef;
  LElseBlock: LLVMBasicBlockRef;
  LMergeBlock: LLVMBasicBlockRef;
begin
  if not (AStatement is TCPIfStatementNode) then
  begin
    ACodeGen.CodeGenError('Invalid if statement node type', [], AStatement.Location);
    Exit;
  end;
  
  LIfStatement := TCPIfStatementNode(AStatement);
  
  // Get current function for basic block creation with safety checks
  LCurrentBlock := LLVMGetInsertBlock(ACodeGen.Builder);
  if LCurrentBlock = nil then
  begin
    ACodeGen.CodeGenError('LLVM builder not positioned in basic block when generating if statement', [], AStatement.Location, 'LLVMGetInsertBlock', 'Builder must be positioned before generating if statements');
    Exit;
  end;
  
  LCurrentFunction := LLVMGetBasicBlockParent(LCurrentBlock);
  if LCurrentFunction = nil then
  begin
    ACodeGen.CodeGenError('Failed to get parent function for if statement basic blocks', [], AStatement.Location, 'LLVMGetBasicBlockParent', 'Current block must have valid parent function');
    Exit;
  end;
  
  // Create basic blocks
  LThenBlock := LLVMAppendBasicBlock(LCurrentFunction, PAnsiChar(UTF8String('if_then')));
  if LThenBlock = nil then
  begin
    ACodeGen.CodeGenError('Failed to create if_then basic block', [], AStatement.Location, 'LLVMAppendBasicBlock', 'Function: ' + IntToStr(IntPtr(LCurrentFunction)));
    Exit;
  end;
  
  LMergeBlock := LLVMAppendBasicBlock(LCurrentFunction, PAnsiChar(UTF8String('if_merge')));
  if LMergeBlock = nil then
  begin
    ACodeGen.CodeGenError('Failed to create if_merge basic block', [], AStatement.Location, 'LLVMAppendBasicBlock', 'Function: ' + IntToStr(IntPtr(LCurrentFunction)));
    Exit;
  end;
  
  if LIfStatement.HasElseClause() then
  begin
    LElseBlock := LLVMAppendBasicBlock(LCurrentFunction, PAnsiChar(UTF8String('if_else')));
    if LElseBlock = nil then
    begin
      ACodeGen.CodeGenError('Failed to create if_else basic block', [], AStatement.Location, 'LLVMAppendBasicBlock', 'Function: ' + IntToStr(IntPtr(LCurrentFunction)));
      Exit;
    end;
  end
  else
    LElseBlock := LMergeBlock;
  
  // Generate condition expression
  LConditionValue := GenerateExpression(ACodeGen, LIfStatement.ConditionExpression);
  if LConditionValue = nil then
  begin
    ACodeGen.CodeGenError('Failed to generate if condition expression', [], AStatement.Location);
    Exit;
  end;
  
  // Create conditional branch
  if LLVMBuildCondBr(ACodeGen.Builder, LConditionValue, LThenBlock, LElseBlock) = nil then
  begin
    ACodeGen.CodeGenError('Failed to create conditional branch for if statement', [], AStatement.Location, 'LLVMBuildCondBr', 'Condition: ' + IntToStr(IntPtr(LConditionValue)) + ', Then: ' + IntToStr(IntPtr(LThenBlock)) + ', Else: ' + IntToStr(IntPtr(LElseBlock)));
    Exit;
  end;
  
  // Generate then block
  LLVMPositionBuilderAtEnd(ACodeGen.Builder, LThenBlock);
  GenerateStatement(ACodeGen, LIfStatement.ThenStatement);
  
  // Only add branch to merge if then block doesn't already have a terminator
  if LLVMGetBasicBlockTerminator(LLVMGetInsertBlock(ACodeGen.Builder)) = nil then
  begin
    if LLVMBuildBr(ACodeGen.Builder, LMergeBlock) = nil then
    begin
      ACodeGen.CodeGenError('Failed to create branch from then block to merge block', [], AStatement.Location, 'LLVMBuildBr', 'Then block: ' + IntToStr(IntPtr(LThenBlock)) + ', Merge: ' + IntToStr(IntPtr(LMergeBlock)));
      Exit;
    end;
  end;
  
  // Generate else block if present
  if LIfStatement.HasElseClause() then
  begin
    LLVMPositionBuilderAtEnd(ACodeGen.Builder, LElseBlock);
    GenerateStatement(ACodeGen, LIfStatement.ElseStatement);
    
    // Only add branch to merge if else block doesn't already have a terminator
    if LLVMGetBasicBlockTerminator(LLVMGetInsertBlock(ACodeGen.Builder)) = nil then
    begin
      if LLVMBuildBr(ACodeGen.Builder, LMergeBlock) = nil then
      begin
        ACodeGen.CodeGenError('Failed to create branch from else block to merge block', [], AStatement.Location, 'LLVMBuildBr', 'Else block: ' + IntToStr(IntPtr(LElseBlock)) + ', Merge: ' + IntToStr(IntPtr(LMergeBlock)));
        Exit;
      end;
    end;
  end;
  
  // Continue with merge block
  LLVMPositionBuilderAtEnd(ACodeGen.Builder, LMergeBlock);
end;

procedure GenerateWhileStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
var
  LWhileStatement: TCPWhileStatementNode;
  LConditionValue: LLVMValueRef;
  LCurrentFunction: LLVMValueRef;
  LConditionBlock: LLVMBasicBlockRef;
  LLoopBodyBlock: LLVMBasicBlockRef;
  LMergeBlock: LLVMBasicBlockRef;
begin
  if not (AStatement is TCPWhileStatementNode) then
  begin
    ACodeGen.CodeGenError('Invalid while statement node type', [], AStatement.Location);
    Exit;
  end;
  
  LWhileStatement := TCPWhileStatementNode(AStatement);
  
  // Get current function for basic block creation
  LCurrentFunction := LLVMGetInsertBlock(ACodeGen.Builder);
  LCurrentFunction := LLVMGetBasicBlockParent(LCurrentFunction);
  
  // Create basic blocks
  LConditionBlock := LLVMAppendBasicBlock(LCurrentFunction, PAnsiChar(UTF8String('while_condition')));
  LLoopBodyBlock := LLVMAppendBasicBlock(LCurrentFunction, PAnsiChar(UTF8String('while_body')));
  LMergeBlock := LLVMAppendBasicBlock(LCurrentFunction, PAnsiChar(UTF8String('while_merge')));
  
  // Jump to condition block
  LLVMBuildBr(ACodeGen.Builder, LConditionBlock);
  
  // Generate condition block
  LLVMPositionBuilderAtEnd(ACodeGen.Builder, LConditionBlock);
  LConditionValue := GenerateExpression(ACodeGen, LWhileStatement.ConditionExpression);
  if LConditionValue = nil then
  begin
    ACodeGen.CodeGenError('Failed to generate while condition expression', [], AStatement.Location);
    Exit;
  end;
  
  // Create conditional branch
  LLVMBuildCondBr(ACodeGen.Builder, LConditionValue, LLoopBodyBlock, LMergeBlock);
  
  // Generate loop body block
  LLVMPositionBuilderAtEnd(ACodeGen.Builder, LLoopBodyBlock);
  GenerateStatement(ACodeGen, LWhileStatement.BodyStatement);
  
  // Only add branch back to condition if body doesn't already have a terminator
  if LLVMGetBasicBlockTerminator(LLVMGetInsertBlock(ACodeGen.Builder)) = nil then
  begin
    LLVMBuildBr(ACodeGen.Builder, LConditionBlock); // Loop back to condition
  end;
  
  // Continue with merge block
  LLVMPositionBuilderAtEnd(ACodeGen.Builder, LMergeBlock);
end;

procedure GenerateForStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
var
  LForStatement: TCPForStatementNode;
  LControlVariable: LLVMValueRef;
  LStartValue: LLVMValueRef;
  LEndValue: LLVMValueRef;
  LCurrentFunction: LLVMValueRef;
  LConditionBlock: LLVMBasicBlockRef;
  LLoopBodyBlock: LLVMBasicBlockRef;
  LIncrementBlock: LLVMBasicBlockRef;
  LMergeBlock: LLVMBasicBlockRef;
  LConditionValue: LLVMValueRef;
  LCurrentValue: LLVMValueRef;
  LNextValue: LLVMValueRef;
  LVariableType: LLVMTypeRef;
  LOneConstant: LLVMValueRef;
begin
  if not (AStatement is TCPForStatementNode) then
  begin
    ACodeGen.CodeGenError('Invalid for statement node type', [], AStatement.Location);
    Exit;
  end;
  
  LForStatement := TCPForStatementNode(AStatement);
  
  // Look up control variable in symbol table
  LControlVariable := ACodeGen.SymbolTable.GetSymbol(LForStatement.ControlVariable);
  if LControlVariable = nil then
  begin
    ACodeGen.CodeGenError('Undefined control variable: %s', [LForStatement.ControlVariable], AStatement.Location);
    Exit;
  end;
  
  // Generate start and end expressions
  LStartValue := GenerateExpression(ACodeGen, LForStatement.StartExpression);
  if LStartValue = nil then
  begin
    ACodeGen.CodeGenError('Failed to generate for loop start expression', [], AStatement.Location);
    Exit;
  end;
  
  LEndValue := GenerateExpression(ACodeGen, LForStatement.EndExpression);
  if LEndValue = nil then
  begin
    ACodeGen.CodeGenError('Failed to generate for loop end expression', [], AStatement.Location);
    Exit;
  end;
  
  // Initialize control variable with start value
  if LLVMBuildStore(ACodeGen.Builder, LStartValue, LControlVariable) = nil then
  begin
    ACodeGen.CodeGenError('Failed to initialize for loop control variable: %s', [LForStatement.ControlVariable], AStatement.Location);
    Exit;
  end;
  
  // Get current function for basic block creation
  LCurrentFunction := LLVMGetInsertBlock(ACodeGen.Builder);
  LCurrentFunction := LLVMGetBasicBlockParent(LCurrentFunction);
  
  // Create basic blocks
  LConditionBlock := LLVMAppendBasicBlock(LCurrentFunction, PAnsiChar(UTF8String('for_condition')));
  LLoopBodyBlock := LLVMAppendBasicBlock(LCurrentFunction, PAnsiChar(UTF8String('for_body')));
  LIncrementBlock := LLVMAppendBasicBlock(LCurrentFunction, PAnsiChar(UTF8String('for_increment')));
  LMergeBlock := LLVMAppendBasicBlock(LCurrentFunction, PAnsiChar(UTF8String('for_merge')));
  
  // Jump to condition block
  LLVMBuildBr(ACodeGen.Builder, LConditionBlock);
  
  // Generate condition block
  LLVMPositionBuilderAtEnd(ACodeGen.Builder, LConditionBlock);
  
  // Load current value of control variable
  LVariableType := LLVMGetAllocatedType(LControlVariable);
  LCurrentValue := LLVMBuildLoad2(ACodeGen.Builder, LVariableType, LControlVariable, PAnsiChar(UTF8String(LForStatement.ControlVariable + '_current')));
  if LCurrentValue = nil then
  begin
    ACodeGen.CodeGenError('Failed to load for loop control variable: %s', [LForStatement.ControlVariable], AStatement.Location);
    Exit;
  end;
  
  // Generate condition check (control_var <= end_value for "to", control_var >= end_value for "downto")
  if LForStatement.IsDownto then
    LConditionValue := LLVMBuildICmp(ACodeGen.Builder, LLVMIntSGE, LCurrentValue, LEndValue, PAnsiChar(UTF8String('for_cond_downto')))
  else
    LConditionValue := LLVMBuildICmp(ACodeGen.Builder, LLVMIntSLE, LCurrentValue, LEndValue, PAnsiChar(UTF8String('for_cond_to')));
  
  if LConditionValue = nil then
  begin
    ACodeGen.CodeGenError('Failed to generate for loop condition', [], AStatement.Location);
    Exit;
  end;
  
  // Create conditional branch
  LLVMBuildCondBr(ACodeGen.Builder, LConditionValue, LLoopBodyBlock, LMergeBlock);
  
  // Generate loop body block
  LLVMPositionBuilderAtEnd(ACodeGen.Builder, LLoopBodyBlock);
  GenerateStatement(ACodeGen, LForStatement.BodyStatement);
  
  // Only add branch to increment if body doesn't already have a terminator
  if LLVMGetBasicBlockTerminator(LLVMGetInsertBlock(ACodeGen.Builder)) = nil then
  begin
    LLVMBuildBr(ACodeGen.Builder, LIncrementBlock);
  end;
  
  // Generate increment block
  LLVMPositionBuilderAtEnd(ACodeGen.Builder, LIncrementBlock);
  
  // Load current value again (might have been modified in loop body)
  LCurrentValue := LLVMBuildLoad2(ACodeGen.Builder, LVariableType, LControlVariable, PAnsiChar(UTF8String(LForStatement.ControlVariable + '_inc_current')));
  if LCurrentValue = nil then
  begin
    ACodeGen.CodeGenError('Failed to load control variable for increment: %s', [LForStatement.ControlVariable], AStatement.Location);
    Exit;
  end;
  
  // Create constant 1 for increment/decrement
  LOneConstant := LLVMConstInt(LVariableType, 1, 0);
  
  // Generate increment or decrement
  if LForStatement.IsDownto then
    LNextValue := LLVMBuildSub(ACodeGen.Builder, LCurrentValue, LOneConstant, PAnsiChar(UTF8String(LForStatement.ControlVariable + '_dec')))
  else
    LNextValue := LLVMBuildAdd(ACodeGen.Builder, LCurrentValue, LOneConstant, PAnsiChar(UTF8String(LForStatement.ControlVariable + '_inc')));
  
  if LNextValue = nil then
  begin
    ACodeGen.CodeGenError('Failed to generate for loop increment/decrement', [], AStatement.Location);
    Exit;
  end;
  
  // Store updated value back to control variable
  if LLVMBuildStore(ACodeGen.Builder, LNextValue, LControlVariable) = nil then
  begin
    ACodeGen.CodeGenError('Failed to store incremented control variable: %s', [LForStatement.ControlVariable], AStatement.Location);
    Exit;
  end;
  
  // Jump back to condition check
  LLVMBuildBr(ACodeGen.Builder, LConditionBlock);
  
  // Continue with merge block
  LLVMPositionBuilderAtEnd(ACodeGen.Builder, LMergeBlock);
end;

procedure GenerateCaseStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
var
  LCaseStatement: TCPCaseStatementNode;
  LCaseValue: LLVMValueRef;
  LCurrentFunction: LLVMValueRef;
  LDefaultBlock: LLVMBasicBlockRef;
  LMergeBlock: LLVMBasicBlockRef;
  LSwitchInst: LLVMValueRef;
  LBranchIndex: Integer;
  LCaseBranch: TCPCaseBranch;
  LBranchBlock: LLVMBasicBlockRef;
  LLabelIndex: Integer;
  LCaseLabel: TCPExpressionNode;
  LLabelValue: LLVMValueRef;
  LBranchName: string;
begin
  if not (AStatement is TCPCaseStatementNode) then
  begin
    ACodeGen.CodeGenError('Invalid case statement node type', [], AStatement.Location);
    Exit;
  end;
  
  LCaseStatement := TCPCaseStatementNode(AStatement);
  
  // Generate case expression
  LCaseValue := GenerateExpression(ACodeGen, LCaseStatement.CaseExpression);
  if LCaseValue = nil then
  begin
    ACodeGen.CodeGenError('Failed to generate case expression', [], AStatement.Location);
    Exit;
  end;
  
  // Get current function for basic block creation
  LCurrentFunction := LLVMGetInsertBlock(ACodeGen.Builder);
  LCurrentFunction := LLVMGetBasicBlockParent(LCurrentFunction);
  
  // Create merge block (where all branches converge)
  LMergeBlock := LLVMAppendBasicBlock(LCurrentFunction, PAnsiChar(UTF8String('case_merge')));
  
  // Create default block (for else clause or unmatched cases)
  if LCaseStatement.HasElseClause() then
    LDefaultBlock := LLVMAppendBasicBlock(LCurrentFunction, PAnsiChar(UTF8String('case_else')))
  else
    LDefaultBlock := LMergeBlock; // No else clause, default goes to merge
  
  // Create switch instruction
  LSwitchInst := LLVMBuildSwitch(ACodeGen.Builder, LCaseValue, LDefaultBlock, LCaseStatement.BranchCount());
  if LSwitchInst = nil then
  begin
    ACodeGen.CodeGenError('Failed to create switch instruction', [], AStatement.Location);
    Exit;
  end;
  
  // Generate each case branch
  for LBranchIndex := 0 to LCaseStatement.BranchCount() - 1 do
  begin
    LCaseBranch := LCaseStatement.GetBranch(LBranchIndex);
    if LCaseBranch = nil then
      Continue;
    
    // Create basic block for this branch
    LBranchName := Format('case_branch_%d', [LBranchIndex]);
    LBranchBlock := LLVMAppendBasicBlock(LCurrentFunction, PAnsiChar(UTF8String(LBranchName)));
    
    // Add all labels for this branch to the switch instruction
    for LLabelIndex := 0 to LCaseBranch.LabelCount() - 1 do
    begin
      LCaseLabel := LCaseBranch.GetLabel(LLabelIndex);
      if LCaseLabel <> nil then
      begin
        LLabelValue := GenerateExpression(ACodeGen, LCaseLabel);
        if LLabelValue <> nil then
        begin
          // Add case to switch instruction
          LLVMAddCase(LSwitchInst, LLabelValue, LBranchBlock);
        end
        else
        begin
          ACodeGen.CodeGenError('Failed to generate case label expression', [], LCaseLabel.Location);
          Exit;
        end;
      end;
    end;
    
    // Generate the branch statement  
    LLVMPositionBuilderAtEnd(ACodeGen.Builder, LBranchBlock);
    GenerateStatement(ACodeGen, LCaseBranch.Statement);
    
    // Only add branch to merge if branch doesn't already have a terminator
    if LLVMGetBasicBlockTerminator(LLVMGetInsertBlock(ACodeGen.Builder)) = nil then
    begin
      LLVMBuildBr(ACodeGen.Builder, LMergeBlock);
    end;
  end;
  
  // Generate else clause if present
  if LCaseStatement.HasElseClause() then
  begin
    LLVMPositionBuilderAtEnd(ACodeGen.Builder, LDefaultBlock);
    GenerateStatement(ACodeGen, LCaseStatement.ElseStatement);
    
    // Only add branch to merge if else doesn't already have a terminator
    if LLVMGetBasicBlockTerminator(LLVMGetInsertBlock(ACodeGen.Builder)) = nil then
    begin
      LLVMBuildBr(ACodeGen.Builder, LMergeBlock);
    end;
  end;
  
  // Continue with merge block
  LLVMPositionBuilderAtEnd(ACodeGen.Builder, LMergeBlock);
end;

procedure GenerateBreakStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
begin
  // Break statement generation not yet implemented
  ACodeGen.CodeGenError('Break statement generation not yet implemented', [], AStatement.Location);
end;

procedure GenerateContinueStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
begin
  // Continue statement generation not yet implemented
  ACodeGen.CodeGenError('Continue statement generation not yet implemented', [], AStatement.Location);
end;

procedure EnsureBasicBlockHasTerminator(const ACodeGen: TCPCodeGen; const ALocation: TCPSourceLocation);
var
  LCurrentBlock: LLVMBasicBlockRef;
begin
  // Check if we have a valid basic block and builder
  if ACodeGen.Builder = nil then
    Exit;
    
  LCurrentBlock := LLVMGetInsertBlock(ACodeGen.Builder);
  if LCurrentBlock = nil then
    Exit;
    
  // Check if current basic block has a terminator
  if LLVMGetBasicBlockTerminator(LCurrentBlock) = nil then
  begin
    // No terminator - add unreachable instruction for merge blocks
    // that should never be reached (due to returns in branches)
    if LLVMBuildUnreachable(ACodeGen.Builder) = nil then
    begin
      ACodeGen.CodeGenError('Failed to generate unreachable terminator for basic block', [], ALocation, 'LLVMBuildUnreachable', 'Block has no terminator and no predecessors');
    end;
  end;
end;

procedure GenerateReturnStatement(const ACodeGen: TCPCodeGen; const AStatement: TCPStatementNode);
var
  LReturnStatement: TCPReturnStatementNode;
  LReturnValue: LLVMValueRef;
begin
  if not (AStatement is TCPReturnStatementNode) then
  begin
    ACodeGen.CodeGenError('Invalid return statement node type', [], AStatement.Location);
    Exit;
  end;
  
  // Validate builder state
  if ACodeGen.Builder = nil then
  begin
    ACodeGen.CodeGenError('LLVM builder is nil when generating return statement', [], AStatement.Location, 'Builder validation', 'Builder state check');
    Exit;
  end;
  
  if LLVMGetInsertBlock(ACodeGen.Builder) = nil then
  begin
    ACodeGen.CodeGenError('LLVM builder not positioned when generating return statement', [], AStatement.Location, 'LLVMGetInsertBlock', 'Builder must be positioned before return statements');
    Exit;
  end;
  
  LReturnStatement := TCPReturnStatementNode(AStatement);
  
  if LReturnStatement.HasReturnValue() then
  begin
    // Function return with value: return expr;
    LReturnValue := GenerateExpression(ACodeGen, LReturnStatement.ReturnExpression);
    if LReturnValue = nil then
    begin
      ACodeGen.CodeGenError('Failed to generate return expression', [], AStatement.Location);
      Exit;
    end;
    
    if LLVMBuildRet(ACodeGen.Builder, LReturnValue) = nil then
    begin
      ACodeGen.CodeGenError('Failed to generate return instruction', [], AStatement.Location);
      Exit;
    end;
  end
  else
  begin
    // Procedure return (void): return;
    if LLVMBuildRetVoid(ACodeGen.Builder) = nil then
    begin
      ACodeGen.CodeGenError('Failed to generate void return instruction', [], AStatement.Location);
      Exit;
    end;
  end;
end;

end.
