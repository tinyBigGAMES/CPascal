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

unit CPascal.CodeGen.Expressions;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  CPascal.Platform,
  CPascal.Lexer,
  CPascal.CodeGen,
  CPascal.AST,
  CPascal.AST.Expressions,
  CPascal.LLVM;

function GenerateExpression(const ACodeGen: TCPCodeGen; const AExpression: TCPExpressionNode): LLVMValueRef;
function GenerateIdentifier(const ACodeGen: TCPCodeGen; const AIdentifier: TCPIdentifierNode): LLVMValueRef;
function GenerateLiteral(const ACodeGen: TCPCodeGen; const ALiteral: TCPLiteralNode): LLVMValueRef;
function GenerateFunctionCall(const ACodeGen: TCPCodeGen; const ACall: TCPFunctionCallNode): LLVMValueRef;
function GenerateBinaryOperation(const ACodeGen: TCPCodeGen; const ABinary: TCPBinaryOperationNode): LLVMValueRef;
function GenerateUnaryOperation(const ACodeGen: TCPCodeGen; const AUnary: TCPUnaryOperationNode): LLVMValueRef;
function GenerateArrayAccess(const ACodeGen: TCPCodeGen; const AArrayAccess: TCPArrayAccessNode): LLVMValueRef;

implementation

{ Helper functions for type checking and promotion }
function CPIsIntegerType(const AType: LLVMTypeRef): Boolean;
begin
  Result := (AType <> nil) and (LLVMGetTypeKind(AType) = LLVMIntegerTypeKind);
end;

function CPIsFloatingPointType(const AType: LLVMTypeRef): Boolean;
var
  LTypeKind: LLVMTypeKind;
begin
  if AType = nil then
  begin
    Result := False;
    Exit;
  end;
  
  LTypeKind := LLVMGetTypeKind(AType);
  Result := (LTypeKind = LLVMFloatTypeKind) or (LTypeKind = LLVMDoubleTypeKind);
end;

function CPPromoteToCommonType(const ACodeGen: TCPCodeGen; const ALeftValue, ARightValue: LLVMValueRef; 
  out APromotedLeft, APromotedRight: LLVMValueRef): LLVMTypeRef;
var
  LLeftType: LLVMTypeRef;
  LRightType: LLVMTypeRef;
  LLeftIsInt: Boolean;
  LRightIsInt: Boolean;
  LLeftIsFloat: Boolean;
  LRightIsFloat: Boolean;
begin
  LLeftType := LLVMTypeOf(ALeftValue);
  LRightType := LLVMTypeOf(ARightValue);
  
  LLeftIsInt := CPIsIntegerType(LLeftType);
  LRightIsInt := CPIsIntegerType(LRightType);
  LLeftIsFloat := CPIsFloatingPointType(LLeftType);
  LRightIsFloat := CPIsFloatingPointType(LRightType);
  
  // If both are same type, no promotion needed
  if LLVMGetTypeKind(LLeftType) = LLVMGetTypeKind(LRightType) then
  begin
    APromotedLeft := ALeftValue;
    APromotedRight := ARightValue;
    Result := LLeftType; // Return either type (they're the same kind)
    Exit;
  end;
  
  // C-style promotion: if one is float and one is int, promote int to float
  if LLeftIsFloat and LRightIsInt then
  begin
    // Promote right (int) to left's float type
    APromotedLeft := ALeftValue;
    APromotedRight := LLVMBuildSIToFP(ACodeGen.Builder, ARightValue, LLeftType, CPAsUTF8('int_to_float'));
    Result := LLeftType;
  end
  else if LRightIsFloat and LLeftIsInt then
  begin
    // Promote left (int) to right's float type  
    APromotedLeft := LLVMBuildSIToFP(ACodeGen.Builder, ALeftValue, LRightType, CPAsUTF8('int_to_float'));
    APromotedRight := ARightValue;
    Result := LRightType;
  end
  else
  begin
    // No promotion possible or needed - return original values
    APromotedLeft := ALeftValue;
    APromotedRight := ARightValue;
    Result := LLeftType; // Default to left type
  end;
end;

{ Helper functions for parsing CPascal integer literals }

function BinToInt64(const ABin: string): Int64;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(ABin) do
  begin
    case ABin[I] of
      '0': Result := Result shl 1;
      '1': Result := (Result shl 1) or 1;
    else
      raise EConvertError.CreateFmt('Invalid binary digit: %s', [ABin[I]]);
    end;
  end;
end;

function OctToInt64(const AOct: string): Int64;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(AOct) do
  begin
    case AOct[I] of
      '0'..'7': Result := (Result shl 3) + (Ord(AOct[I]) - Ord('0'));
    else
      raise EConvertError.CreateFmt('Invalid octal digit: %s', [AOct[I]]);
    end;
  end;
end;

function CPParseIntegerLiteral(const AValue: string; out AIsUnsigned: Boolean; out ASignedValue: Int64; out AUnsignedValue: UInt64): Boolean;
begin
  AIsUnsigned := False;
  Result := True;

  // First try as signed Int64
  try
    if Length(AValue) >= 3 then
    begin
      if (AValue[1] = '0') and CharInSet(AValue[2],['b', 'B']) then
        ASignedValue := BinToInt64(Copy(AValue, 3, MaxInt))
      else if (AValue[1] = '0') and CharInSet(AValue[2], ['x', 'X']) then
        ASignedValue := StrToInt64('$' + Copy(AValue, 3, MaxInt))
      else if (AValue[1] = '0') and CharInSet(AValue[2], ['o', 'O']) then
        ASignedValue := OctToInt64(Copy(AValue, 3, MaxInt))
      else if AValue[1] = '$' then
        ASignedValue := StrToInt64(AValue)
      else
        ASignedValue := StrToInt64(AValue);
    end
    else
      ASignedValue := StrToInt64(AValue);
  except
    // If Int64 fails, try UInt64
    AIsUnsigned := True;
    try
      AUnsignedValue := StrToUInt64(AValue);
    except
      Result := False; // Parse failed
    end;
  end;
end;

function GenerateExpression(const ACodeGen: TCPCodeGen; const AExpression: TCPExpressionNode): LLVMValueRef;
begin
  if AExpression = nil then
  begin
    Result := nil;
    Exit;
  end;

  case AExpression.NodeKind of
    nkIdentifier:
      Result := GenerateIdentifier(ACodeGen, TCPIdentifierNode(AExpression));

    nkIntegerLiteral, nkRealLiteral, nkStringLiteral, nkCharacterLiteral, nkBooleanLiteral, nkNilLiteral:
      Result := GenerateLiteral(ACodeGen, TCPLiteralNode(AExpression));

    nkFunctionCall:
      Result := GenerateFunctionCall(ACodeGen, TCPFunctionCallNode(AExpression));

    nkBinaryOperation:
      Result := GenerateBinaryOperation(ACodeGen, TCPBinaryOperationNode(AExpression));

    nkUnaryOperation:
      Result := GenerateUnaryOperation(ACodeGen, TCPUnaryOperationNode(AExpression));

    nkArrayAccess:
      Result := GenerateArrayAccess(ACodeGen, TCPArrayAccessNode(AExpression));

    // Other expression types not yet implemented
    nkTernaryOperation, nkFieldAccess, nkTypeCast, nkSizeOfExpression, nkTypeOfExpression, nkDereference, nkAddressOf:
    begin
      ACodeGen.CodeGenError('Expression type %s not yet implemented', [CPNodeKindToString(AExpression.NodeKind)], AExpression.Location);
      Result := nil;
    end;

  else
    ACodeGen.CodeGenError('Unexpected expression node kind: %s', [CPNodeKindToString(AExpression.NodeKind)], AExpression.Location);
    Result := nil;
  end;
end;

(*
function GenerateIdentifier(const ACodeGen: TCPCodeGen; const AIdentifier: TCPIdentifierNode): LLVMValueRef;
var
  LSymbol: LLVMValueRef;
  LValueKind: LLVMValueKind;
  LAllocatedType: LLVMTypeRef;
  LSymbolType: LLVMTypeRef;
begin
  if AIdentifier = nil then
  begin
    Result := nil;
    Exit;
  end;

  // Look up identifier in symbol table
  LSymbol := ACodeGen.SymbolTable.GetSymbol(AIdentifier.IdentifierName);
  if LSymbol = nil then
  begin
    ACodeGen.CodeGenError('Undefined identifier: %s', [AIdentifier.IdentifierName], AIdentifier.Location);
    Result := nil;
    Exit;
  end;
  
  // Determine if this is a variable (alloca) or function
  LValueKind := LLVMGetValueKind(LSymbol);
  
  if LValueKind = LLVMInstructionValueKind then
  begin
    // This is an alloca instruction (variable) - get the allocated type directly
    LAllocatedType := LLVMGetAllocatedType(LSymbol);
    
    // Load the value from the variable
    Result := LLVMBuildLoad2(ACodeGen.Builder, LAllocatedType, LSymbol, CPAsUTF8(AIdentifier.IdentifierName + '_load'));
    if Result = nil then
      ACodeGen.CodeGenError('Failed to load value from variable: %s', [AIdentifier.IdentifierName], AIdentifier.Location);
  end
  else
  begin
    // Check if this symbol is a pointer type (could be var/out parameter)
    LSymbolType := LLVMTypeOf(LSymbol);
    if (LSymbolType <> nil) and (LLVMGetTypeKind(LSymbolType) = LLVMPointerTypeKind) then
    begin
      // This is a pointer (likely var/out parameter) - need to dereference for expression use
      // For now, assume Int32 type (most common in our test cases)
      // TODO: Store actual pointed-to type information during parameter setup
      Result := LLVMBuildLoad2(ACodeGen.Builder, LLVMInt32TypeInContext(ACodeGen.Context), LSymbol, CPAsUTF8(AIdentifier.IdentifierName + '_load'));
      if Result = nil then
        Result := LSymbol; // Fallback to raw symbol if load fails
    end
    else
    begin
      // This is a function or other non-pointer symbol - return directly
      Result := LSymbol;
    end;
  end;
end;
*)

function GenerateIdentifier(const ACodeGen: TCPCodeGen; const AIdentifier: TCPIdentifierNode): LLVMValueRef;
var
  LSymbol: LLVMValueRef;
  LValueKind: LLVMValueKind;
  LAllocatedType: LLVMTypeRef;
  LSymbolType: LLVMTypeRef;
  LTypeName: string;
begin
  if AIdentifier = nil then
  begin
    Result := nil;
    Exit;
  end;

  // Look up identifier in symbol table
  LSymbol := ACodeGen.SymbolTable.GetSymbol(AIdentifier.IdentifierName);
  if LSymbol = nil then
  begin
    ACodeGen.CodeGenError('Undefined identifier: %s', [AIdentifier.IdentifierName], AIdentifier.Location);
    Result := nil;
    Exit;
  end;

  // Determine if this is a variable (alloca) or function
  LValueKind := LLVMGetValueKind(LSymbol);

  if LValueKind = LLVMInstructionValueKind then
  begin
    // This is an alloca instruction (variable) - get the allocated type directly
    LAllocatedType := LLVMGetAllocatedType(LSymbol);

    // Load the value from the variable
    Result := LLVMBuildLoad2(ACodeGen.Builder, LAllocatedType, LSymbol, CPAsUTF8(AIdentifier.IdentifierName + '_load'));
    if Result = nil then
      ACodeGen.CodeGenError('Failed to load value from variable: %s', [AIdentifier.IdentifierName], AIdentifier.Location);
  end
  else
  begin
    // Check if this symbol is a pointer type (could be var/out parameter)
    LSymbolType := LLVMTypeOf(LSymbol);
    if (LSymbolType <> nil) and (LLVMGetTypeKind(LSymbolType) = LLVMPointerTypeKind) then
    begin
      // This is a pointer (likely var/out parameter) - need to dereference for expression use
      // Get the actual pointed-to type from symbol table
      LTypeName := ACodeGen.SymbolTable.GetSymbolType(AIdentifier.IdentifierName);
      if LTypeName <> '' then
      begin
        // Get the element type for this pointer type
        LAllocatedType := ACodeGen.TypeMapper.GetPointerElementType(LTypeName);
        if LAllocatedType <> nil then
          Result := LLVMBuildLoad2(ACodeGen.Builder, LAllocatedType, LSymbol, CPAsUTF8(AIdentifier.IdentifierName + '_load'))
        else
          Result := LLVMBuildLoad2(ACodeGen.Builder, LLVMInt32TypeInContext(ACodeGen.Context), LSymbol, CPAsUTF8(AIdentifier.IdentifierName + '_load'));
      end
      else
        Result := LLVMBuildLoad2(ACodeGen.Builder, LLVMInt32TypeInContext(ACodeGen.Context), LSymbol, CPAsUTF8(AIdentifier.IdentifierName + '_load'));

      if Result = nil then
        Result := LSymbol; // Fallback to raw symbol if load fails
    end
    else
    begin
      // This is a function or other non-pointer symbol - return directly
      Result := LSymbol;
    end;
  end;
end;

function GenerateLiteral(const ACodeGen: TCPCodeGen; const ALiteral: TCPLiteralNode): LLVMValueRef;
var
  LValue: string;
  LIntValue: Int64;
  LRealValue: Double;
  LStringType: LLVMTypeRef;
  LStringGlobal: LLVMValueRef;
  LStringContentPtr: Pointer;
  LGlobalNamePtr: Pointer;
  LUtf8Length: Integer;
  LIsUnsigned: Boolean;
  LSignedValue: Int64;
  LUnsignedValue: UInt64;
begin
  Result := nil;

  if ALiteral = nil then
  begin
    Result := nil;
    Exit;
  end;

  LValue := ALiteral.LiteralValue;

  case ALiteral.NodeKind of
    nkIntegerLiteral:
    begin
      if CPParseIntegerLiteral(LValue, LIsUnsigned, LSignedValue, LUnsignedValue) then
      begin
        if LIsUnsigned then
          Result := LLVMConstInt(LLVMInt64TypeInContext(ACodeGen.Context), LUnsignedValue, 0)
        else
          Result := LLVMConstInt(LLVMInt64TypeInContext(ACodeGen.Context), UInt64(LSignedValue), 0);
      end
      else
        ACodeGen.CodeGenError('Invalid integer literal: %s', [LValue], ALiteral.Location);
    end;

    nkRealLiteral:
    begin
      try
        LRealValue := StrToFloat(LValue);
        // Use double for now - proper type inference needed later
        Result := LLVMConstReal(LLVMDoubleTypeInContext(ACodeGen.Context), LRealValue);
      except
        on E: Exception do
          ACodeGen.CodeGenError('Invalid real literal: %s (%s)', [LValue, E.Message], ALiteral.Location);
      end;
    end;

    nkStringLiteral:
    begin
      // Remove quotes from string literal
      if (Length(LValue) >= 2) and (LValue[1] = '"') and (LValue[Length(LValue)] = '"') then
        LValue := Copy(LValue, 2, Length(LValue) - 2);

      // Create string content pointer properly
      LStringContentPtr := CPAsUTF8(LValue);   //  LMarshaller.AsUTF8(LValue).ToPointer;
      LUtf8Length := Length(UTF8String(LValue));

      // Create global string constant - use proper LLVM string constant creation
      //LGlobalNamePtr := LMarshaller.AsUTF8('str_' + IntToStr(ACodeGen.GetNextStringId())).ToPointer;
      LGlobalNamePtr := CPAsUTF8('str_' + IntToStr(ACodeGen.GetNextStringId()));

      // Create the string constant with null terminator included
      LStringGlobal := LLVMConstStringInContext(ACodeGen.Context, LStringContentPtr, LUtf8Length, 0); // 0 = include null terminator
      LStringType := LLVMTypeOf(LStringGlobal);

      Result := LLVMAddGlobal(ACodeGen.Module_, LStringType, LGlobalNamePtr);
      LLVMSetInitializer(Result, LStringGlobal);
      LLVMSetGlobalConstant(Result, 1);
      LLVMSetLinkage(Result, LLVMPrivateLinkage);

      // Get pointer to first element for i8* compatibility
      Result := LLVMConstBitCast(Result, LLVMPointerType(LLVMInt8TypeInContext(ACodeGen.Context), 0));
    end;

    nkCharacterLiteral:
    begin
      // Character literal - support both BNF formats: "#" <digit>+ | "'" <printable_char> "'"
      if Length(LValue) = 0 then
      begin
        ACodeGen.CodeGenError('Empty character literal', [], ALiteral.Location);
      end
      else if (LValue[1] = '#') and (Length(LValue) >= 2) and (LValue[2] >= '0') and (LValue[2] <= '9') then
      begin
        // Hash notation: #72, #10, #13, etc.
        if Length(LValue) >= 2 then
        begin
          try
            LIntValue := StrToInt(Copy(LValue, 2, Length(LValue) - 1));
            if (LIntValue < 0) or (LIntValue > 255) then
              ACodeGen.CodeGenError('Character code %d out of range (0-255)', [LIntValue], ALiteral.Location)
            else
              Result := LLVMConstInt(LLVMInt8TypeInContext(ACodeGen.Context), LIntValue, 0);
          except
            on E: Exception do
              ACodeGen.CodeGenError('Invalid character literal: %s (%s)', [LValue, E.Message], ALiteral.Location);
          end;
        end
        else
          ACodeGen.CodeGenError('Invalid character literal format: %s', [LValue], ALiteral.Location);
      end
      else
      begin
        // Single-quoted format: 'H', 'e', etc.
        if Length(LValue) = 1 then
        begin
          // Single character - convert to ASCII value
          LIntValue := Ord(LValue[1]);
          Result := LLVMConstInt(LLVMInt8TypeInContext(ACodeGen.Context), LIntValue, 0);
        end
        else
          ACodeGen.CodeGenError('Single-quoted character literal must contain exactly one character: %s', [LValue], ALiteral.Location);
      end;
    end;

    nkBooleanLiteral:
    begin
      if SameText(LValue, 'true') then
        Result := LLVMConstInt(LLVMInt1TypeInContext(ACodeGen.Context), 1, 0)
      else if SameText(LValue, 'false') then
        Result := LLVMConstInt(LLVMInt1TypeInContext(ACodeGen.Context), 0, 0)
      else
        ACodeGen.CodeGenError('Invalid boolean literal: %s', [LValue], ALiteral.Location);
    end;

    nkNilLiteral:
    begin
      Result := LLVMConstNull(LLVMPointerType(LLVMInt8TypeInContext(ACodeGen.Context), 0));
    end;

  else
    ACodeGen.CodeGenError('Unexpected literal node kind: %s', [CPNodeKindToString(ALiteral.NodeKind)], ALiteral.Location);
    Result := nil;
  end;
end;

function GenerateFunctionCall(const ACodeGen: TCPCodeGen; const ACall: TCPFunctionCallNode): LLVMValueRef;
var
  LFunction: LLVMValueRef;
  LArguments: array of LLVMValueRef;
  LIndex: Integer;
  LArgument: TCPExpressionNode;
  LArgumentValue: LLVMValueRef;
  LArgumentType: LLVMTypeRef;
  LFunctionType: LLVMTypeRef;
  LReturnType: LLVMTypeRef;
  LIsVarArgs: Boolean;
  LIsVoidFunction: Boolean;
  LParameterFlags: TArray<Boolean>;
  LIsVarOutParameter: Boolean;
  LIdentifier: TCPIdentifierNode;
  LVariableSymbol: LLVMValueRef;
  LTypeWidth: Cardinal;
  LIsUnsignedSource: Boolean;
  LSymbolTypeName: string;
begin
  if ACall = nil then
  begin
    Result := nil;
    Exit;
  end;

  // Look up function in symbol table
  LFunction := ACodeGen.SymbolTable.GetSymbol(ACall.FunctionName);
  if LFunction = nil then
  begin
    ACodeGen.CodeGenError('Undefined function: %s', [ACall.FunctionName], ACall.Location);
    Result := nil;
    Exit;
  end;

  // Get function type to check return type and varargs
  LFunctionType := LLVMGlobalGetValueType(LFunction);
  LReturnType := LLVMGetReturnType(LFunctionType);
  LIsVarArgs := LLVMIsFunctionVarArg(LFunctionType) <> 0;
  LIsVoidFunction := LLVMGetTypeKind(LReturnType) = LLVMVoidTypeKind;

  // Get parameter metadata to know which parameters are var/out
  LParameterFlags := ACodeGen.CPGetFunctionParameterInfo(ACall.FunctionName);

  // Generate arguments
  SetLength(LArguments, ACall.ArgumentCount);
  for LIndex := 0 to ACall.ArgumentCount - 1 do
  begin
    LArgument := ACall.GetArgument(LIndex);

    // Check if this parameter is var/out (pass by reference)
    LIsVarOutParameter := (LIndex < Length(LParameterFlags)) and LParameterFlags[LIndex];

    if LIsVarOutParameter and (LArgument.NodeKind = nkIdentifier) then
    begin
      // For var/out parameters that are identifiers, pass the variable address directly
      LIdentifier := TCPIdentifierNode(LArgument);
      LVariableSymbol := ACodeGen.SymbolTable.GetSymbol(LIdentifier.IdentifierName);
      if LVariableSymbol = nil then
      begin
        ACodeGen.CodeGenError('Undefined variable for var/out parameter: %s', [LIdentifier.IdentifierName], LArgument.Location);
        Result := nil;
        Exit;
      end;
      LArgumentValue := LVariableSymbol; // Pass address directly (no load)
    end
    else
    begin
      // For const parameters or non-identifier expressions, use normal value generation
      LArgumentValue := GenerateExpression(ACodeGen, LArgument);
      if LArgumentValue = nil then
      begin
        ACodeGen.CodeGenError('Failed to generate argument %d for function %s', [LIndex, ACall.FunctionName], ACall.Location);
        Result := nil;
        Exit;
      end;
    end;

    // For varargs functions, promote small integer types according to C calling convention
    if LIsVarArgs then
    begin
      LArgumentType := LLVMTypeOf(LArgumentValue);

      // Promote small integer types to i32 for varargs functions
      if LLVMGetTypeKind(LArgumentType) = LLVMIntegerTypeKind then
      begin
        LTypeWidth := LLVMGetIntTypeWidth(LArgumentType);
        if LTypeWidth < 32 then
        begin
          if LTypeWidth = 1 then
            // Zero-extend i1 (Boolean) to i32
            LArgumentValue := LLVMBuildZExt(ACodeGen.Builder, LArgumentValue, LLVMInt32TypeInContext(ACodeGen.Context), CPAsUTF8('bool_promote'))
          else
          begin
            // For i8/i16, check if source is unsigned type
            LIsUnsignedSource := False;
            if (LArgument.NodeKind = nkIdentifier) then
            begin
              LIdentifier := TCPIdentifierNode(LArgument);
              LSymbolTypeName := ACodeGen.SymbolTable.GetSymbolType(LIdentifier.IdentifierName);
              LIsUnsignedSource := (LSymbolTypeName = 'UInt8') or (LSymbolTypeName = 'UInt16');
            end;

            if LIsUnsignedSource then
              // Zero-extend for unsigned types
              LArgumentValue := LLVMBuildZExt(ACodeGen.Builder, LArgumentValue, LLVMInt32TypeInContext(ACodeGen.Context), CPAsUTF8('uint_promote'))
            else
              // Sign-extend for signed types
              LArgumentValue := LLVMBuildSExt(ACodeGen.Builder, LArgumentValue, LLVMInt32TypeInContext(ACodeGen.Context), CPAsUTF8('int_promote'));
          end;
        end;
      end
      // Promote float to double for varargs functions (C calling convention)
      else if LLVMGetTypeKind(LArgumentType) = LLVMFloatTypeKind then
      begin
        // Promote float to double for varargs (C calling convention)
        LArgumentValue := LLVMBuildFPExt(ACodeGen.Builder, LArgumentValue, LLVMDoubleTypeInContext(ACodeGen.Context), CPAsUTF8('float_to_double'));
      end;
    end;

    LArguments[LIndex] := LArgumentValue;
  end;

  // Validate builder state before function call
  if ACodeGen.Builder = nil then
  begin
    ACodeGen.CodeGenError('LLVM builder is nil when generating function call: %s', [ACall.FunctionName], ACall.Location, 'Builder validation', 'Builder state check');
    Result := nil;
    Exit;
  end;

  if LLVMGetInsertBlock(ACodeGen.Builder) = nil then
  begin
    ACodeGen.CodeGenError('LLVM builder not positioned when generating function call: %s', [ACall.FunctionName], ACall.Location, 'LLVMGetInsertBlock', 'Builder must be positioned before function calls');
    Result := nil;
    Exit;
  end;

  // Create function call instruction - void functions don't get result variable names
  if Length(LArguments) > 0 then
  begin
    if LIsVoidFunction then
      // Fix: Pass empty string instead of nil for void function calls
      Result := LLVMBuildCall2(ACodeGen.Builder, LFunctionType, LFunction, @LArguments[0], Length(LArguments), CPAsUTF8(''))
    else
      Result := LLVMBuildCall2(ACodeGen.Builder, LFunctionType, LFunction, @LArguments[0], Length(LArguments), CPAsUTF8('call'));
  end
  else
  begin
    if LIsVoidFunction then
      // Fix: Pass empty string instead of nil for void function calls
      Result := LLVMBuildCall2(ACodeGen.Builder, LFunctionType, LFunction, nil, 0, CPAsUTF8(''))
    else
      Result := LLVMBuildCall2(ACodeGen.Builder, LFunctionType, LFunction, nil, 0, CPAsUTF8('call'));
  end;

  if Result = nil then
  begin
    ACodeGen.CodeGenError('Failed to generate call to function: %s', [ACall.FunctionName], ACall.Location, 'LLVMBuildCall2', 'Function: ' + ACall.FunctionName + ', Args: ' + IntToStr(Length(LArguments)) + ', Builder: ' + IntToStr(IntPtr(ACodeGen.Builder)));
    Exit;
  end;
end;

function GenerateBinaryOperation(const ACodeGen: TCPCodeGen; const ABinary: TCPBinaryOperationNode): LLVMValueRef;
var
  LLeftValue: LLVMValueRef;
  LRightValue: LLVMValueRef;
  LPromotedLeft: LLVMValueRef;
  LPromotedRight: LLVMValueRef;
  LCommonType: LLVMTypeRef;
  LIsFloatingPoint: Boolean;
begin
  if ABinary = nil then
  begin
    Result := nil;
    Exit;
  end;
  
  // Validate builder state
  if ACodeGen.Builder = nil then
  begin
    ACodeGen.CodeGenError('LLVM builder is nil when generating binary operation', [], ABinary.Location, 'Builder validation', 'Builder state check');
    Result := nil;
    Exit;
  end;
  
  if LLVMGetInsertBlock(ACodeGen.Builder) = nil then
  begin
    ACodeGen.CodeGenError('LLVM builder not positioned when generating binary operation', [], ABinary.Location, 'LLVMGetInsertBlock', 'Builder must be positioned before binary operations');
    Result := nil;
    Exit;
  end;

  // Generate operands
  LLeftValue := GenerateExpression(ACodeGen, ABinary.LeftOperand);
  if LLeftValue = nil then
  begin
    ACodeGen.CodeGenError('Failed to generate left operand for binary operation', [], ABinary.Location, 'GenerateExpression', 'Left operand: ' + CPNodeKindToString(ABinary.LeftOperand.NodeKind));
    Result := nil;
    Exit;
  end;

  LRightValue := GenerateExpression(ACodeGen, ABinary.RightOperand);
  if LRightValue = nil then
  begin
    ACodeGen.CodeGenError('Failed to generate right operand for binary operation', [], ABinary.Location, 'GenerateExpression', 'Right operand: ' + CPNodeKindToString(ABinary.RightOperand.NodeKind));
    Result := nil;
    Exit;
  end;

  // Promote operands to common type for arithmetic operations
  LCommonType := CPPromoteToCommonType(ACodeGen, LLeftValue, LRightValue, LPromotedLeft, LPromotedRight);
  LIsFloatingPoint := CPIsFloatingPointType(LCommonType);

  // Generate operation based on operator type and result type
  case ABinary.Operator of
    tkPlus:
    begin
      if LIsFloatingPoint then
        Result := LLVMBuildFAdd(ACodeGen.Builder, LPromotedLeft, LPromotedRight, CPAsUTF8('fadd'))
      else
        Result := LLVMBuildAdd(ACodeGen.Builder, LPromotedLeft, LPromotedRight, CPAsUTF8('add'));
    end;
      
    tkMinus:
    begin
      if LIsFloatingPoint then
        Result := LLVMBuildFSub(ACodeGen.Builder, LPromotedLeft, LPromotedRight, CPAsUTF8('fsub'))
      else
        Result := LLVMBuildSub(ACodeGen.Builder, LPromotedLeft, LPromotedRight, CPAsUTF8('sub'));
    end;
      
    tkMultiply:
    begin
      if LIsFloatingPoint then
        Result := LLVMBuildFMul(ACodeGen.Builder, LPromotedLeft, LPromotedRight, CPAsUTF8('fmul'))
      else
        Result := LLVMBuildMul(ACodeGen.Builder, LPromotedLeft, LPromotedRight, CPAsUTF8('mul'));
    end;
      
    tkDivide, tkDiv:
    begin
      if LIsFloatingPoint then
        Result := LLVMBuildFDiv(ACodeGen.Builder, LPromotedLeft, LPromotedRight, CPAsUTF8('fdiv'))
      else
        Result := LLVMBuildSDiv(ACodeGen.Builder, LPromotedLeft, LPromotedRight, CPAsUTF8('div'));
    end;
      
    tkMod:
    begin
      if LIsFloatingPoint then
        Result := LLVMBuildFRem(ACodeGen.Builder, LPromotedLeft, LPromotedRight, CPAsUTF8('frem'))
      else
        Result := LLVMBuildSRem(ACodeGen.Builder, LPromotedLeft, LPromotedRight, CPAsUTF8('mod'));
    end;
      
    // Equality operators
    tkEqual:
    begin
      if LIsFloatingPoint then
        Result := LLVMBuildFCmp(ACodeGen.Builder, LLVMRealOEQ, LPromotedLeft, LPromotedRight, CPAsUTF8('feq'))
      else
        Result := LLVMBuildICmp(ACodeGen.Builder, LLVMIntEQ, LPromotedLeft, LPromotedRight, CPAsUTF8('eq'));
    end;
      
    tkNotEqual:
    begin
      if LIsFloatingPoint then
        Result := LLVMBuildFCmp(ACodeGen.Builder, LLVMRealONE, LPromotedLeft, LPromotedRight, CPAsUTF8('fne'))
      else
        Result := LLVMBuildICmp(ACodeGen.Builder, LLVMIntNE, LPromotedLeft, LPromotedRight, CPAsUTF8('ne'));
    end;
      
    // Relational operators
    tkLessThan:
    begin
      if LIsFloatingPoint then
        Result := LLVMBuildFCmp(ACodeGen.Builder, LLVMRealOLT, LPromotedLeft, LPromotedRight, CPAsUTF8('flt'))
      else
        Result := LLVMBuildICmp(ACodeGen.Builder, LLVMIntSLT, LPromotedLeft, LPromotedRight, CPAsUTF8('lt'));
    end;
      
    tkLessEqual:
    begin
      if LIsFloatingPoint then
        Result := LLVMBuildFCmp(ACodeGen.Builder, LLVMRealOLE, LPromotedLeft, LPromotedRight, CPAsUTF8('fle'))
      else
        Result := LLVMBuildICmp(ACodeGen.Builder, LLVMIntSLE, LPromotedLeft, LPromotedRight, CPAsUTF8('le'));
    end;
      
    tkGreaterThan:
    begin
      if LIsFloatingPoint then
        Result := LLVMBuildFCmp(ACodeGen.Builder, LLVMRealOGT, LPromotedLeft, LPromotedRight, CPAsUTF8('fgt'))
      else
        Result := LLVMBuildICmp(ACodeGen.Builder, LLVMIntSGT, LPromotedLeft, LPromotedRight, CPAsUTF8('gt'));
    end;
      
    tkGreaterEqual:
    begin
      if LIsFloatingPoint then
        Result := LLVMBuildFCmp(ACodeGen.Builder, LLVMRealOGE, LPromotedLeft, LPromotedRight, CPAsUTF8('fge'))
      else
        Result := LLVMBuildICmp(ACodeGen.Builder, LLVMIntSGE, LPromotedLeft, LPromotedRight, CPAsUTF8('ge'));
    end;
      
    // Logical operators (no promotion needed - work on original values)
    tkAnd:
      Result := LLVMBuildAnd(ACodeGen.Builder, LLeftValue, LRightValue, CPAsUTF8('and'));
      
    tkOr:
      Result := LLVMBuildOr(ACodeGen.Builder, LLeftValue, LRightValue, CPAsUTF8('or'));
      
  else
    ACodeGen.CodeGenError('Unsupported binary operator: %s', [CPTokenKindToString(ABinary.Operator)], ABinary.Location);
    Result := nil;
  end;

  if Result = nil then
    ACodeGen.CodeGenError('Failed to generate binary operation instruction', [], ABinary.Location);
end;

function GenerateUnaryOperation(const ACodeGen: TCPCodeGen; const AUnary: TCPUnaryOperationNode): LLVMValueRef;
var
  LOperandValue: LLVMValueRef;
  LIdentifier: TCPIdentifierNode;
  LVariableSymbol: LLVMValueRef;
  LElementType: LLVMTypeRef;
  LTypeName: string;
begin
  if AUnary = nil then
  begin
    Result := nil;
    Exit;
  end;
  
  // Validate builder state
  if ACodeGen.Builder = nil then
  begin
    ACodeGen.CodeGenError('LLVM builder is nil when generating unary operation', [], AUnary.Location, 'Builder validation', 'Builder state check');
    Result := nil;
    Exit;
  end;
  
  if LLVMGetInsertBlock(ACodeGen.Builder) = nil then
  begin
    ACodeGen.CodeGenError('LLVM builder not positioned when generating unary operation', [], AUnary.Location, 'LLVMGetInsertBlock', 'Builder must be positioned before unary operations');
    Result := nil;
    Exit;
  end;

  // Handle different unary operators
  case AUnary.Operator of
    tkPlus:
    begin
      // Unary plus operator - return operand value unchanged
      LOperandValue := GenerateExpression(ACodeGen, AUnary.Operand);
      if LOperandValue = nil then
      begin
        ACodeGen.CodeGenError('Failed to generate operand for unary plus', [], AUnary.Location);
        Result := nil;
        Exit;
      end;
      
      // Unary plus is a no-op - just return the operand value
      Result := LOperandValue;
    end;
    
    tkAddressOf:
    begin
      // Address-of operator - return pointer to variable
      if AUnary.Operand.NodeKind = nkIdentifier then
      begin
        LIdentifier := TCPIdentifierNode(AUnary.Operand);
        LVariableSymbol := ACodeGen.SymbolTable.GetSymbol(LIdentifier.IdentifierName);
        if LVariableSymbol = nil then
        begin
          ACodeGen.CodeGenError('Undefined variable for address-of: %s', [LIdentifier.IdentifierName], AUnary.Location);
          Result := nil;
          Exit;
        end;
        
        // Return the variable pointer directly (don't load)
        Result := LVariableSymbol;
      end
      else
      begin
        ACodeGen.CodeGenError('Address-of operator can only be applied to variables', [], AUnary.Location);
        Result := nil;
      end;
    end;
    
    tkDereference:
    begin
      // Dereference operator - load value from pointer
      LOperandValue := GenerateExpression(ACodeGen, AUnary.Operand);
      if LOperandValue = nil then
      begin
        ACodeGen.CodeGenError('Failed to generate operand for dereference', [], AUnary.Location);
        Result := nil;
        Exit;
      end;
      
      // Determine the type to load based on the pointer type
      LElementType := nil;
      
      // If operand is an identifier, look up its type
      if AUnary.Operand.NodeKind = nkIdentifier then
      begin
        LIdentifier := TCPIdentifierNode(AUnary.Operand);
        LTypeName := ACodeGen.SymbolTable.GetSymbolType(LIdentifier.IdentifierName);
        
        if LTypeName <> '' then
        begin
          // Get the element type for this pointer type
          LElementType := ACodeGen.TypeMapper.GetPointerElementType(LTypeName);
        end;
      end;
      
      // Fallback to Int32 if type not found
      if LElementType = nil then
        LElementType := LLVMInt32TypeInContext(ACodeGen.Context);
      
      // Load value from the pointer with the correct type
      Result := LLVMBuildLoad2(ACodeGen.Builder, LElementType, LOperandValue, CPAsUTF8('deref'));
    end;
    
    tkNot:
    begin
      // Logical NOT operator
      LOperandValue := GenerateExpression(ACodeGen, AUnary.Operand);
      if LOperandValue = nil then
      begin
        ACodeGen.CodeGenError('Failed to generate operand for NOT operation', [], AUnary.Location);
        Result := nil;
        Exit;
      end;
      
      Result := LLVMBuildNot(ACodeGen.Builder, LOperandValue, CPAsUTF8('not'));
    end;
    
    tkMinus:
    begin
      // Unary minus operator
      LOperandValue := GenerateExpression(ACodeGen, AUnary.Operand);
      if LOperandValue = nil then
      begin
        ACodeGen.CodeGenError('Failed to generate operand for unary minus', [], AUnary.Location);
        Result := nil;
        Exit;
      end;
      
      Result := LLVMBuildNeg(ACodeGen.Builder, LOperandValue, CPAsUTF8('neg'));
    end;
    
  else
    ACodeGen.CodeGenError('Unsupported unary operator: %s', [CPTokenKindToString(AUnary.Operator)], AUnary.Location);
    Result := nil;
  end;
end;

function GenerateArrayAccess(const ACodeGen: TCPCodeGen; const AArrayAccess: TCPArrayAccessNode): LLVMValueRef;
var
  LArrayValue: LLVMValueRef;
  LIndexValue: LLVMValueRef;
  LArrayIdentifier: TCPIdentifierNode;
  LArraySymbol: LLVMValueRef;
  LArrayType: LLVMTypeRef;
  LElementType: LLVMTypeRef;
  LIndices: array[0..1] of LLVMValueRef;
begin
  if AArrayAccess = nil then
  begin
    Result := nil;
    Exit;
  end;
  
  // Validate builder state
  if ACodeGen.Builder = nil then
  begin
    ACodeGen.CodeGenError('LLVM builder is nil when generating array access', [], AArrayAccess.Location);
    Result := nil;
    Exit;
  end;
  
  if LLVMGetInsertBlock(ACodeGen.Builder) = nil then
  begin
    ACodeGen.CodeGenError('LLVM builder not positioned when generating array access', [], AArrayAccess.Location);
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
  
  LElementType := LLVMGetElementType(LArrayType);
  
  // Create GEP indices: [0, index] for array access
  // First index (0) to get past the alloca pointer
  // Second index is the actual array index
  LIndices[0] := LLVMConstInt(LLVMInt32TypeInContext(ACodeGen.Context), 0, 0);
  LIndices[1] := LIndexValue;
  
  // Generate GEP (Get Element Pointer) instruction
  LArrayValue := LLVMBuildGEP2(ACodeGen.Builder, LArrayType, LArraySymbol, @LIndices[0], 2, CPAsUTF8('arrayptr'));
  if LArrayValue = nil then
  begin
    ACodeGen.CodeGenError('Failed to generate array element pointer', [], AArrayAccess.Location);
    Result := nil;
    Exit;
  end;
  
  // Load the value from the array element
  Result := LLVMBuildLoad2(ACodeGen.Builder, LElementType, LArrayValue, CPAsUTF8('arrayload'));
  if Result = nil then
    ACodeGen.CodeGenError('Failed to load array element value', [], AArrayAccess.Location);
end;

end.