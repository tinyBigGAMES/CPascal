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

unit CPascal.CodeGen.Functions;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  CPascal.LLVM,
  CPascal.Exception,
  CPascal.Lexer,
  CPascal.CodeGen,
  CPascal.AST,
  CPascal.AST.Functions,
  CPascal.AST.Statements,
  CPascal.AST.Declarations,
  CPascal.AST.CompilationUnit;

function GenerateExternalFunction(const ACodeGen: TCPCodeGen; const AFunction: TCPFunctionDeclarationNode): LLVMValueRef;
function GenerateExternalVarargsFunction(const ACodeGen: TCPCodeGen; const AFunction: TCPFunctionDeclarationNode): LLVMValueRef;
function GenerateLocalFunctionSignature(const ACodeGen: TCPCodeGen; const AFunction: TCPFunctionDeclarationNode): LLVMValueRef;
function GenerateLocalFunctionImplementation(const ACodeGen: TCPCodeGen; const AFunction: TCPFunctionDeclarationNode): LLVMValueRef;
function GenerateMainFunction(const ACodeGen: TCPCodeGen; const ABody: TCPCompoundStatementNode): LLVMValueRef;
function GenerateMainFunctionWithVariables(const ACodeGen: TCPCodeGen; const AProgram: TCPProgramNode): LLVMValueRef;
function GenerateFunctionSignature(const ACodeGen: TCPCodeGen; const AFunction: TCPFunctionDeclarationNode): LLVMTypeRef;
function GenerateParameterTypes(const ACodeGen: TCPCodeGen; const AParameters: TCPASTNodeList): TArray<LLVMTypeRef>;
procedure GenerateVariableAllocations(const ACodeGen: TCPCodeGen; const ADeclarations: TCPASTNodeList);
procedure CPStoreFunctionParameterInfo(const ACodeGen: TCPCodeGen; const AFunction: TCPFunctionDeclarationNode);

implementation

uses
  CPascal.Platform,
  CPascal.CodeGen.Statements;

function GenerateExternalFunction(const ACodeGen: TCPCodeGen; const AFunction: TCPFunctionDeclarationNode): LLVMValueRef;
var
  LParameterTypes: TArray<LLVMTypeRef>;
  LFunctionType: LLVMTypeRef;
  LReturnType: LLVMTypeRef;
  LCallingConv: LLVMCallConv;
begin
  // Check Context
  if ACodeGen.Context = nil then
  begin
    ACodeGen.CodeGenError('Context is nil when generating external function: %s', [AFunction.FunctionName], AFunction.Location, 'Context check', 'Context state verification');
    Result := nil;
    Exit;
  end;

  // Check Module
  if ACodeGen.Module_ = nil then
  begin
    ACodeGen.CodeGenError('Module is nil when generating external function: %s', [AFunction.FunctionName], AFunction.Location, 'Module check', 'Module state verification');
    Result := nil;
    Exit;
  end;

  // Check function name
  if AFunction.FunctionName = '' then
  begin
    ACodeGen.CodeGenError('Function name is empty', [], AFunction.Location, 'Function name check', 'Function name validation');
    Result := nil;
    Exit;
  end;

  // Map return type
  if AFunction.ReturnType <> nil then
  begin
    LReturnType := ACodeGen.TypeMapper.MapCPascalTypeToLLVM(AFunction.ReturnType);
    if LReturnType = nil then
    begin
      ACodeGen.CodeGenError('Failed to map return type for external function: %s', [AFunction.FunctionName], AFunction.Location, 'TypeMapper.MapCPascalTypeToLLVM', 'ReturnType: ' + AFunction.ReturnType.TypeName);
      Result := nil;
      Exit;
    end;
  end
  else
    LReturnType := LLVMVoidTypeInContext(ACodeGen.Context); // Procedure

  if LReturnType = nil then
  begin
    ACodeGen.CodeGenError('Return type is nil after mapping for external function: %s', [AFunction.FunctionName], AFunction.Location, 'LLVMVoidTypeInContext', 'Context: ' + IntToStr(IntPtr(ACodeGen.Context)));
    Result := nil;
    Exit;
  end;

  // Map parameter types
  LParameterTypes := GenerateParameterTypes(ACodeGen, AFunction.Parameters);

  // Create LLVM function type (not varargs)
  if Length(LParameterTypes) > 0 then
  begin
    LFunctionType := LLVMFunctionType(
      LReturnType,
      @LParameterTypes[0],
      Length(LParameterTypes),
      0 // isVarArg = False
    );
  end
  else
  begin
    LFunctionType := LLVMFunctionType(
      LReturnType,
      nil,
      0,
      0 // isVarArg = False
    );
  end;

  if LFunctionType = nil then
  begin
    ACodeGen.CodeGenError('Failed to create function type for external function: %s', [AFunction.FunctionName], AFunction.Location, 'LLVMFunctionType', 'ReturnType: ' + IntToStr(IntPtr(LReturnType)) + ', ParamCount: ' + IntToStr(Length(LParameterTypes)));
    Result := nil;
    Exit;
  end;

  // Check if function already exists in module
  Result := LLVMGetNamedFunction(ACodeGen.Module_, PAnsiChar(UTF8String(AFunction.FunctionName)));
  if Result <> nil then
  begin
    ACodeGen.CodeGenError('External function already exists: %s', [AFunction.FunctionName], AFunction.Location, 'LLVMGetNamedFunction', 'Function: ' + AFunction.FunctionName + ' already exists in module - cannot add duplicate');
    Exit;
  end;

  // Add function declaration to module
  Result := LLVMAddFunction(ACodeGen.Module_, PAnsiChar(UTF8String(AFunction.FunctionName)), LFunctionType);
  if Result = nil then
  begin
    ACodeGen.CodeGenError('Failed to add external function: %s', [AFunction.FunctionName], AFunction.Location, 'LLVMAddFunction', 'Function: ' + AFunction.FunctionName + ', Type: external, Module: ' + IntToStr(IntPtr(ACodeGen.Module_)) + ', FunctionType: ' + IntToStr(IntPtr(LFunctionType)));
    Exit;
  end;

  // Set calling convention
  LCallingConv := ACodeGen.CallingConventionMapper.MapCallingConvention(AFunction.CallingConvention);
  LLVMSetFunctionCallConv(Result, LCallingConv);

  // Set external linkage
  LLVMSetLinkage(Result, LLVMExternalLinkage);

  // Store parameter metadata for function call resolution
  CPStoreFunctionParameterInfo(ACodeGen, AFunction);
  
  // Add to symbol table for function call resolution
  ACodeGen.SymbolTable.AddSymbol(AFunction.FunctionName, Result);
end;

function GenerateLocalFunctionSignature(const ACodeGen: TCPCodeGen; const AFunction: TCPFunctionDeclarationNode): LLVMValueRef;
var
  LFunctionType: LLVMTypeRef;
  LCallingConv: LLVMCallConv;
begin
  // Check if function has a body
  if AFunction.Body = nil then
  begin
    ACodeGen.CodeGenError('Local function must have a body: %s', [AFunction.FunctionName], AFunction.Location);
    Result := nil;
    Exit;
  end;

  // Create LLVM function type
  LFunctionType := GenerateFunctionSignature(ACodeGen, AFunction);
  if LFunctionType = nil then
  begin
    ACodeGen.CodeGenError('Failed to generate function signature for: %s', [AFunction.FunctionName], AFunction.Location, 'GenerateFunctionSignature', 'Function: ' + AFunction.FunctionName);
    Result := nil;
    Exit;
  end;

  // Add function declaration to module
  Result := LLVMAddFunction(ACodeGen.Module_, PAnsiChar(UTF8String(AFunction.FunctionName)), LFunctionType);
  if Result = nil then
  begin
    ACodeGen.CodeGenError('Failed to add local function signature: %s', [AFunction.FunctionName], AFunction.Location, 'LLVMAddFunction', 'Function: ' + AFunction.FunctionName + ', Type: local signature');
    Exit;
  end;

  // Set calling convention
  LCallingConv := ACodeGen.CallingConventionMapper.MapCallingConvention(AFunction.CallingConvention);
  LLVMSetFunctionCallConv(Result, LCallingConv);

  // Set internal linkage for local functions
  LLVMSetLinkage(Result, LLVMInternalLinkage);

  // Store parameter metadata for function call resolution
  CPStoreFunctionParameterInfo(ACodeGen, AFunction);
  
  // Add function to symbol table for call resolution
  ACodeGen.SymbolTable.AddSymbol(AFunction.FunctionName, Result);
end;

function GenerateLocalFunctionImplementation(const ACodeGen: TCPCodeGen; const AFunction: TCPFunctionDeclarationNode): LLVMValueRef;
var
  LEntryBlock: LLVMBasicBlockRef;
  LParameter: TCPParameterNode;
  LParameterValue: LLVMValueRef;
  LParameterAlloca: LLVMValueRef;
  LParameterType: LLVMTypeRef;
  LIndex: Integer;
  LPreviousBlock: LLVMBasicBlockRef;
begin
  // Check if function has a body
  if AFunction.Body = nil then
  begin
    ACodeGen.CodeGenError('Local function must have a body: %s', [AFunction.FunctionName], AFunction.Location);
    Result := nil;
    Exit;
  end;

  // Get existing function from symbol table (signature was created in declaration phase)
  Result := ACodeGen.SymbolTable.GetSymbol(AFunction.FunctionName);
  if Result = nil then
  begin
    ACodeGen.CodeGenError('Local function signature not found: %s', [AFunction.FunctionName], AFunction.Location, 'SymbolTable.GetSymbol', 'Function signature must be generated before implementation');
    Exit;
  end;

  // Check if function already has basic blocks (already implemented)
  if LLVMGetFirstBasicBlock(Result) <> nil then
  begin
    ACodeGen.CodeGenError('Function already has implementation: %s', [AFunction.FunctionName], AFunction.Location, 'LLVMGetFirstBasicBlock', 'Function: ' + AFunction.FunctionName + ' already has basic blocks - cannot implement twice');
    Exit;
  end;

  // Save current builder position to restore later (only if builder is positioned)
  LPreviousBlock := LLVMGetInsertBlock(ACodeGen.Builder);
  // Note: LPreviousBlock can be nil during declaration processing - this is normal
  
  // Push local scope for function parameters and local symbols
  ACodeGen.SymbolTable.PushScope();
  try
    // Create entry basic block
    LEntryBlock := LLVMAppendBasicBlockInContext(ACodeGen.Context, Result, 'entry');
    if LEntryBlock = nil then
    begin
      ACodeGen.CodeGenError('Failed to create entry basic block for function: %s', [AFunction.FunctionName], AFunction.Location, 'LLVMAppendBasicBlockInContext', 'Function: ' + AFunction.FunctionName + ', Context: ' + IntToStr(IntPtr(ACodeGen.Context)));
      Exit;
    end;

    // Position builder in entry block
    if ACodeGen.Builder = nil then
    begin
      ACodeGen.CodeGenError('Builder is nil when positioning for function: %s', [AFunction.FunctionName], AFunction.Location, 'LLVMPositionBuilderAtEnd', 'Builder state check before positioning');
      Exit;
    end;
    LLVMPositionBuilderAtEnd(ACodeGen.Builder, LEntryBlock);
    
    // Verify builder positioning succeeded
    if LLVMGetInsertBlock(ACodeGen.Builder) = nil then
    begin
      ACodeGen.CodeGenError('Failed to position builder in entry block for function: %s', [AFunction.FunctionName], AFunction.Location, 'LLVMPositionBuilderAtEnd', 'Builder positioning verification failed');
      Exit;
    end;

    // Generate parameter allocations and store parameter values
    for LIndex := 0 to AFunction.ParameterCount - 1 do
    begin
      LParameter := AFunction.GetParameter(LIndex);
      if LParameter = nil then
      begin
        ACodeGen.CodeGenError('Parameter %d is nil in function: %s', [LIndex, AFunction.FunctionName], AFunction.Location, 'GetParameter', 'Parameter index: ' + IntToStr(LIndex));
        Continue;
      end;
      
      LParameterValue := LLVMGetParam(Result, LIndex);
      if LParameterValue = nil then
      begin
        ACodeGen.CodeGenError('Failed to get parameter %d (%s) for function: %s', [LIndex, LParameter.ParameterName, AFunction.FunctionName], AFunction.Location, 'LLVMGetParam', 'Parameter: ' + LParameter.ParameterName + ', Index: ' + IntToStr(LIndex));
        Continue;
      end;
      
      LParameterType := ACodeGen.TypeMapper.MapCPascalTypeToLLVM(LParameter.ParameterType);
      if LParameterType = nil then
      begin
        ACodeGen.CodeGenError('Failed to map parameter type for %s in function: %s', [LParameter.ParameterName, AFunction.FunctionName], AFunction.Location, 'TypeMapper.MapCPascalTypeToLLVM', 'Parameter: ' + LParameter.ParameterName + ', Type: ' + LParameter.ParameterType.TypeName);
        Continue;
      end;

      // Create alloca for parameter (to allow assignment)
      LParameterAlloca := LLVMBuildAlloca(ACodeGen.Builder, LParameterType, CPAsUTF8(LParameter.ParameterName));
      if LParameterAlloca = nil then
      begin
        ACodeGen.CodeGenError('Failed to allocate parameter: %s', [LParameter.ParameterName], AFunction.Location, 'LLVMBuildAlloca', 'Parameter: ' + LParameter.ParameterName + ', Function: ' + AFunction.FunctionName + ', Builder: ' + IntToStr(IntPtr(ACodeGen.Builder)) + ', Type: ' + IntToStr(IntPtr(LParameterType)));
        Continue;
      end;

      // Store parameter value into alloca
      if LLVMBuildStore(ACodeGen.Builder, LParameterValue, LParameterAlloca) = nil then
      begin
        ACodeGen.CodeGenError('Failed to store parameter value for: %s', [LParameter.ParameterName], AFunction.Location, 'LLVMBuildStore', 'Parameter: ' + LParameter.ParameterName + ', Value: ' + IntToStr(IntPtr(LParameterValue)) + ', Alloca: ' + IntToStr(IntPtr(LParameterAlloca)));
        Continue;
      end;

      // Add parameter to symbol table with type information
      ACodeGen.SymbolTable.AddSymbolWithType(LParameter.ParameterName, LParameterAlloca, LParameter.ParameterType.TypeName);
    end;

    // Generate local variable allocations
    GenerateVariableAllocations(ACodeGen, AFunction.LocalDeclarations);

    // Generate function body
    CPascal.CodeGen.Statements.GenerateCompoundStatement(ACodeGen, AFunction.Body);

    // Note: Return statements in the function body handle all exits
    // No automatic return generation needed
  finally
    // Only restore builder position if it was previously positioned
    if LPreviousBlock <> nil then
      LLVMPositionBuilderAtEnd(ACodeGen.Builder, LPreviousBlock);
    
    // Pop local scope - guaranteed cleanup even if exceptions occurred
    ACodeGen.SymbolTable.PopScope();
  end;

  // Function is already in symbol table from declaration phase
end;

function GenerateExternalVarargsFunction(const ACodeGen: TCPCodeGen; const AFunction: TCPFunctionDeclarationNode): LLVMValueRef;
var
  LParameterTypes: TArray<LLVMTypeRef>;
  LFunctionType: LLVMTypeRef;
  LReturnType: LLVMTypeRef;
  LCallingConv: LLVMCallConv;
begin
  // Check Context
  if ACodeGen.Context = nil then
  begin
    ACodeGen.CodeGenError('Context is nil when generating external varargs function: %s', [AFunction.FunctionName], AFunction.Location, 'Context check', 'Context state verification');
    Result := nil;
    Exit;
  end;

  // Check Module
  if ACodeGen.Module_ = nil then
  begin
    ACodeGen.CodeGenError('Module is nil when generating external varargs function: %s', [AFunction.FunctionName], AFunction.Location, 'Module check', 'Module state verification');
    Result := nil;
    Exit;
  end;

  // Check function name
  if AFunction.FunctionName = '' then
  begin
    ACodeGen.CodeGenError('Function name is empty', [], AFunction.Location, 'Function name check', 'Function name validation');
    Result := nil;
    Exit;
  end;

  // Map return type
  if AFunction.ReturnType <> nil then
  begin
    LReturnType := ACodeGen.TypeMapper.MapCPascalTypeToLLVM(AFunction.ReturnType);
    if LReturnType = nil then
    begin
      ACodeGen.CodeGenError('Failed to map return type for external varargs function: %s', [AFunction.FunctionName], AFunction.Location, 'TypeMapper.MapCPascalTypeToLLVM', 'ReturnType: ' + AFunction.ReturnType.TypeName);
      Result := nil;
      Exit;
    end;
  end
  else
    LReturnType := LLVMVoidTypeInContext(ACodeGen.Context); // Procedure

  if LReturnType = nil then
  begin
    ACodeGen.CodeGenError('Return type is nil after mapping for external varargs function: %s', [AFunction.FunctionName], AFunction.Location, 'LLVMVoidTypeInContext', 'Context: ' + IntToStr(IntPtr(ACodeGen.Context)));
    Result := nil;
    Exit;
  end;

  // Map parameter types (excluding varargs)
  LParameterTypes := GenerateParameterTypes(ACodeGen, AFunction.Parameters);

  // Create LLVM function type WITH varargs support
  if Length(LParameterTypes) > 0 then
  begin
    LFunctionType := LLVMFunctionType(
      LReturnType,
      @LParameterTypes[0],
      Length(LParameterTypes),
      1 // isVarArg = True - CRITICAL for external varargs like printf
    );
  end
  else
  begin
    LFunctionType := LLVMFunctionType(
      LReturnType,
      nil,
      0,
      1 // isVarArg = True
    );
  end;

  if LFunctionType = nil then
  begin
    ACodeGen.CodeGenError('Failed to create varargs function type for: %s', [AFunction.FunctionName], AFunction.Location, 'LLVMFunctionType', 'ReturnType: ' + IntToStr(IntPtr(LReturnType)) + ', ParamCount: ' + IntToStr(Length(LParameterTypes)));
    Result := nil;
    Exit;
  end;

  // Check if function already exists in module
  Result := LLVMGetNamedFunction(ACodeGen.Module_, PAnsiChar(UTF8String(AFunction.FunctionName)));
  if Result <> nil then
  begin
    ACodeGen.CodeGenError('External varargs function already exists: %s', [AFunction.FunctionName], AFunction.Location, 'LLVMGetNamedFunction', 'Function: ' + AFunction.FunctionName + ' already exists in module - cannot add duplicate');
    Exit;
  end;

  // Add function declaration to module
  Result := LLVMAddFunction(ACodeGen.Module_, PAnsiChar(UTF8String(AFunction.FunctionName)), LFunctionType);
  if Result = nil then
  begin
    ACodeGen.CodeGenError('Failed to add external varargs function: %s', [AFunction.FunctionName], AFunction.Location, 'LLVMAddFunction', 'Function: ' + AFunction.FunctionName + ', Type: external varargs, Module: ' + IntToStr(IntPtr(ACodeGen.Module_)) + ', FunctionType: ' + IntToStr(IntPtr(LFunctionType)));
    Exit;
  end;

  // Set calling convention
  LCallingConv := ACodeGen.CallingConventionMapper.MapCallingConvention(AFunction.CallingConvention);
  LLVMSetFunctionCallConv(Result, LCallingConv);

  // Set external linkage
  LLVMSetLinkage(Result, LLVMExternalLinkage);

  // Store parameter metadata for function call resolution
  CPStoreFunctionParameterInfo(ACodeGen, AFunction);
  
  // Add to symbol table for function call resolution
  ACodeGen.SymbolTable.AddSymbol(AFunction.FunctionName, Result);
end;

function GenerateMainFunction(const ACodeGen: TCPCodeGen; const ABody: TCPCompoundStatementNode): LLVMValueRef;
var
  LMainType: LLVMTypeRef;
  LMainBasicBlock: LLVMBasicBlockRef;
  LReturnValue: LLVMValueRef;
  LLocation: TCPSourceLocation;
begin
  Result := nil;
  if ABody = nil then
  begin
    LLocation := TCPSourceLocation.Create('<main>', 0, 0);
    ACodeGen.CodeGenError('Cannot generate main function with nil body', [], LLocation);
    Exit;
  end;

  // Create main function type: int main(void)
  LMainType := LLVMFunctionType(LLVMInt32TypeInContext(ACodeGen.Context), nil, 0, 0);

  // Add main function to module
  Result := LLVMAddFunction(ACodeGen.Module_, 'main', LMainType);
  if Result = nil then
  begin
    LLocation := TCPSourceLocation.Create('<main>', 0, 0);
    ACodeGen.CodeGenError('Failed to create main function', [], LLocation);
  end;

  // Create entry basic block
  LMainBasicBlock := LLVMAppendBasicBlockInContext(ACodeGen.Context, Result, 'entry');
  LLVMPositionBuilderAtEnd(ACodeGen.Builder, LMainBasicBlock);

  // Generate compound statement body
  CPascal.CodeGen.Statements.GenerateCompoundStatement(ACodeGen, ABody);

  // Return 0 (success) - main function always returns int
  LReturnValue := LLVMConstInt(LLVMInt32TypeInContext(ACodeGen.Context), 0, 0);
  LLVMBuildRet(ACodeGen.Builder, LReturnValue);

  // Add main to symbol table
  ACodeGen.SymbolTable.AddSymbol('main', Result);
end;

function GenerateMainFunctionWithVariables(const ACodeGen: TCPCodeGen; const AProgram: TCPProgramNode): LLVMValueRef;
var
  LMainType: LLVMTypeRef;
  LMainBasicBlock: LLVMBasicBlockRef;
  LReturnValue: LLVMValueRef;
  LLocation: TCPSourceLocation;
begin
  Result := nil;
  if AProgram.MainBody = nil then
  begin
    LLocation := TCPSourceLocation.Create('<main>', 0, 0);
    ACodeGen.CodeGenError('Cannot generate main function with nil body', [], LLocation);
    Exit;
  end;

  // Create main function type: int main(void)
  LMainType := LLVMFunctionType(LLVMInt32TypeInContext(ACodeGen.Context), nil, 0, 0);

  // Add main function to module
  Result := LLVMAddFunction(ACodeGen.Module_, 'main', LMainType);
  if Result = nil then
  begin
    LLocation := TCPSourceLocation.Create('<main>', 0, 0);
    ACodeGen.CodeGenError('Failed to create main function', [], LLocation);
  end;

  // Create entry basic block and position builder
  LMainBasicBlock := LLVMAppendBasicBlockInContext(ACodeGen.Context, Result, 'entry');
  LLVMPositionBuilderAtEnd(ACodeGen.Builder, LMainBasicBlock);

  // Now generate variable allocations (after builder is positioned)
  GenerateVariableAllocations(ACodeGen, AProgram.Declarations);

  // Generate compound statement body
  CPascal.CodeGen.Statements.GenerateCompoundStatement(ACodeGen, AProgram.MainBody);

  // Return 0 (success) - main function always returns int
  LReturnValue := LLVMConstInt(LLVMInt32TypeInContext(ACodeGen.Context), 0, 0);
  LLVMBuildRet(ACodeGen.Builder, LReturnValue);

  // Add main to symbol table
  ACodeGen.SymbolTable.AddSymbol('main', Result);
end;

function GenerateFunctionSignature(const ACodeGen: TCPCodeGen; const AFunction: TCPFunctionDeclarationNode): LLVMTypeRef;
var
  LParameterTypes: TArray<LLVMTypeRef>;
  LReturnType: LLVMTypeRef;
begin
  // Map return type
  if AFunction.ReturnType <> nil then
    LReturnType := ACodeGen.TypeMapper.MapCPascalTypeToLLVM(AFunction.ReturnType)
  else
    LReturnType := LLVMVoidTypeInContext(ACodeGen.Context); // Procedure

  // Map parameter types
  LParameterTypes := GenerateParameterTypes(ACodeGen, AFunction.Parameters);

  // Create LLVM function type
  if Length(LParameterTypes) > 0 then
    Result := LLVMFunctionType(
      LReturnType,
      @LParameterTypes[0],
      Length(LParameterTypes),
      Ord(AFunction.IsVarArgs) // Convert boolean to integer
    )
  else
    Result := LLVMFunctionType(
      LReturnType,
      nil,
      0,
      Ord(AFunction.IsVarArgs) // Convert boolean to integer
    );
end;

function GenerateParameterTypes(const ACodeGen: TCPCodeGen; const AParameters: TCPASTNodeList): TArray<LLVMTypeRef>;
var
  LIndex: Integer;
  LParameter: TCPParameterNode;
  LParameterType: LLVMTypeRef;
  LBaseType: LLVMTypeRef;
begin
  if (AParameters = nil) or (AParameters.Count = 0) then
  begin
    SetLength(Result, 0);
    Exit;
  end;

  // Check CodeGen context
  if ACodeGen = nil then
  begin
    raise ECPException.Create('CodeGen is nil in GenerateParameterTypes', [], '', 0, 0);
  end;

  if ACodeGen.TypeMapper = nil then
  begin
    raise ECPException.Create('TypeMapper is nil in GenerateParameterTypes', [], '', 0, 0);
  end;

  SetLength(Result, AParameters.Count);
  for LIndex := 0 to AParameters.Count - 1 do
  begin
    if AParameters[LIndex] = nil then
    begin
      raise ECPException.Create('Parameter %d is nil in GenerateParameterTypes', [LIndex], '', 0, 0);
    end;
    
    LParameter := TCPParameterNode(AParameters[LIndex]);
    if LParameter.ParameterType = nil then
    begin
      raise ECPException.Create('Parameter type is nil for parameter %d (%s)', [LIndex, LParameter.ParameterName], '', 0, 0);
    end;
    
    // Get base type
    LBaseType := ACodeGen.TypeMapper.MapCPascalTypeToLLVM(LParameter.ParameterType);
    if LBaseType = nil then
    begin
      raise ECPException.Create('Failed to map parameter type for %s (index %d)', [LParameter.ParameterName, LIndex], '', 0, 0);
    end;
    
    // Apply parameter modifiers:
    // - const parameters: pass by value (use base type)
    // - var parameters: pass by reference (use pointer type)
    // - out parameters: pass by reference (use pointer type)
    if LParameter.IsVar or LParameter.IsOut then
    begin
      // Pass by reference - use pointer type
      LParameterType := LLVMPointerType(LBaseType, 0);
    end
    else
    begin
      // Pass by value (const parameters or no modifier)
      LParameterType := LBaseType;
    end;
    
    Result[LIndex] := LParameterType;
  end;
end;

procedure GenerateVariableAllocations(const ACodeGen: TCPCodeGen; const ADeclarations: TCPASTNodeList);
var
  LIndex: Integer;
  LDeclaration: TCPASTNode;
  LVarDeclaration: TCPVarDeclarationNode;
  LVariableType: LLVMTypeRef;
  LVarIndex: Integer;
  LVariableName: string;
  LAllocaInst: LLVMValueRef;
begin
  if ADeclarations = nil then
    Exit;
    
  // Check CodeGen context
  if ACodeGen = nil then
  begin
    raise ECPException.Create('CodeGen is nil in GenerateVariableAllocations', [], '', 0, 0);
  end;
  
  if ACodeGen.Builder = nil then
  begin
    raise ECPException.Create('Builder is nil in GenerateVariableAllocations', [], '', 0, 0);
  end;
  
  if ACodeGen.TypeMapper = nil then
  begin
    raise ECPException.Create('TypeMapper is nil in GenerateVariableAllocations', [], '', 0, 0);
  end;
  
  if ACodeGen.SymbolTable = nil then
  begin
    raise ECPException.Create('SymbolTable is nil in GenerateVariableAllocations', [], '', 0, 0);
  end;
    
  // Process each declaration looking for variable declarations
  for LIndex := 0 to ADeclarations.Count - 1 do
  begin
    LDeclaration := ADeclarations[LIndex];
    if (LDeclaration <> nil) and (LDeclaration.NodeKind = nkVarDeclaration) then
    begin
      LVarDeclaration := TCPVarDeclarationNode(LDeclaration);
      if LVarDeclaration = nil then
      begin
        ACodeGen.CodeGenError('Variable declaration is nil at index %d', [LIndex], LDeclaration.Location, 'TCPVarDeclarationNode cast', 'Declaration index: ' + IntToStr(LIndex));
        Continue;
      end;
      
      if LVarDeclaration.VariableType = nil then
      begin
        ACodeGen.CodeGenError('Variable type is nil for declaration at index %d', [LIndex], LDeclaration.Location, 'VariableType check', 'Declaration index: ' + IntToStr(LIndex));
        Continue;
      end;
      
      // Map CPascal type to LLVM type
      LVariableType := ACodeGen.TypeMapper.MapCPascalTypeToLLVM(LVarDeclaration.VariableType);
      if LVariableType = nil then
      begin
        ACodeGen.CodeGenError('Failed to map variable type: %s', [LVarDeclaration.VariableType.TypeName], LDeclaration.Location, 'TypeMapper.MapCPascalTypeToLLVM', 'Type: ' + LVarDeclaration.VariableType.TypeName);
        Continue;
      end;
      
      // Generate alloca instruction for each variable in the declaration
      for LVarIndex := 0 to LVarDeclaration.VariableNameCount - 1 do
      begin
        LVariableName := LVarDeclaration.GetVariableName(LVarIndex);
        if LVariableName = '' then
        begin
          ACodeGen.CodeGenError('Variable name is empty at index %d', [LVarIndex], LDeclaration.Location, 'GetVariableName', 'Variable index: ' + IntToStr(LVarIndex));
          Continue;
        end;
        
        // Check for duplicate variable names
        if ACodeGen.SymbolTable.HasSymbol(LVariableName) then
        begin
          ACodeGen.CodeGenError('Variable already declared: %s', [LVariableName], LDeclaration.Location, 'SymbolTable.HasSymbol', 'Variable: ' + LVariableName);
          Continue;
        end;
        
        // Create alloca instruction for stack allocation
        LAllocaInst := LLVMBuildAlloca(ACodeGen.Builder, LVariableType, CPAsUTF8(LVariableName));
        if LAllocaInst = nil then
        begin
          ACodeGen.CodeGenError('Failed to generate alloca instruction for variable: %s', [LVariableName], LDeclaration.Location, 'LLVMBuildAlloca', 'Variable: ' + LVariableName + ', Type: ' + LVarDeclaration.VariableType.TypeName + ', Builder: ' + IntToStr(IntPtr(ACodeGen.Builder)) + ', LLVMType: ' + IntToStr(IntPtr(LVariableType)));
          Continue;
        end;
        
        // Add variable to symbol table with type information
        ACodeGen.SymbolTable.AddSymbolWithType(LVariableName, LAllocaInst, LVarDeclaration.VariableType.TypeName);
      end;
    end;
  end;
end;

// Helper procedure to store function parameter metadata
procedure CPStoreFunctionParameterInfo(const ACodeGen: TCPCodeGen; const AFunction: TCPFunctionDeclarationNode);
var
  LParameterFlags: TArray<Boolean>;
  LIndex: Integer;
  LParameter: TCPParameterNode;
begin
  if (AFunction = nil) or (ACodeGen = nil) then
    Exit;
    
  // Build parameter modifier flags array
  SetLength(LParameterFlags, AFunction.ParameterCount);
  for LIndex := 0 to AFunction.ParameterCount - 1 do
  begin
    LParameter := AFunction.GetParameter(LIndex);
    if LParameter <> nil then
      LParameterFlags[LIndex] := LParameter.IsVar or LParameter.IsOut
    else
      LParameterFlags[LIndex] := False; // Default to const (pass by value)
  end;
  
  // Store the parameter metadata
  ACodeGen.CPStoreFunctionParameterInfo(AFunction.FunctionName, LParameterFlags);
end;

end.
