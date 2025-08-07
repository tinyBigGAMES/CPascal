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

unit CPascal.CodeGen.Declarations;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  CPascal.LLVM,
  CPascal.Platform,
  CPascal.Lexer,
  CPascal.CodeGen,
  CPascal.AST,
  CPascal.AST.Declarations,
  CPascal.AST.Functions;

procedure GenerateDeclarations(const ACodeGen: TCPCodeGen; const ADeclarations: TCPASTNodeList);
procedure GenerateLocalFunctionDeclarations(const ACodeGen: TCPCodeGen; const ADeclarations: TCPASTNodeList);
procedure GenerateLocalFunctionImplementations(const ACodeGen: TCPCodeGen; const ADeclarations: TCPASTNodeList);
function GenerateConstDeclaration(const ACodeGen: TCPCodeGen; const AConst: TCPASTNode): LLVMValueRef;
function GenerateTypeDeclaration(const ACodeGen: TCPCodeGen; const AType: TCPASTNode): LLVMTypeRef;
function GenerateVarDeclaration(const ACodeGen: TCPCodeGen; const AVar: TCPASTNode): LLVMValueRef;

implementation

uses
  CPascal.CodeGen.Functions,
  CPascal.CodeGen.Statements,
  CPascal.CodeGen.Types;

procedure GenerateDeclarations(const ACodeGen: TCPCodeGen; const ADeclarations: TCPASTNodeList);
var
  LIndex: Integer;
  LDeclaration: TCPASTNode;
  LFunction: TCPFunctionDeclarationNode;
begin
  if ADeclarations = nil then
    Exit; // No declarations to process

  for LIndex := 0 to ADeclarations.Count - 1 do
  begin
    LDeclaration := ADeclarations[LIndex];
    if LDeclaration = nil then
      Continue;

    case LDeclaration.NodeKind of
      nkFunctionDeclaration, nkExternalFunction:
      begin
        LFunction := TCPFunctionDeclarationNode(LDeclaration);
        if LFunction.IsExternal then
        begin
          if LFunction.IsVarArgs then
            GenerateExternalVarargsFunction(ACodeGen, LFunction)
          else
            GenerateExternalFunction(ACodeGen, LFunction);
        end
        else
        begin
          // Skip local functions during first phase - they need builder positioned
          // They will be generated later in GenerateProgram
        end;
      end;

      nkConstDeclaration:
        GenerateConstDeclaration(ACodeGen, LDeclaration);

      nkTypeDeclaration:
        GenerateTypeDeclaration(ACodeGen, LDeclaration);

      nkVarDeclaration:
        GenerateVarDeclaration(ACodeGen, LDeclaration);

    else
      ACodeGen.CodeGenError('Unexpected declaration node kind: %s', [CPNodeKindToString(LDeclaration.NodeKind)], LDeclaration.Location);
    end;
  end;
end;

function GenerateConstDeclaration(const ACodeGen: TCPCodeGen; const AConst: TCPASTNode): LLVMValueRef;
begin
  // Const declaration generation not yet implemented
  ACodeGen.CodeGenError('Const declaration generation not yet implemented', [], AConst.Location);
  Result := nil;
end;

function GenerateTypeDeclaration(const ACodeGen: TCPCodeGen; const AType: TCPASTNode): LLVMTypeRef;
var
  LTypeDecl: TCPTypeDeclarationNode;
  LLLVMType: LLVMTypeRef;
  LBaseType: LLVMTypeRef;
begin
  if AType.NodeKind <> nkTypeDeclaration then
  begin
    ACodeGen.CodeGenError('Expected type declaration node, got %s', [CPNodeKindToString(AType.NodeKind)], AType.Location);
    Result := nil;
    Exit;
  end;

  LTypeDecl := TCPTypeDeclarationNode(AType);
  
  // Check if it's a pointer type
  if LTypeDecl.TypeDefinition.IsPointer then
  begin
    // Get the base type that this points to
    LBaseType := ACodeGen.TypeMapper.MapTypeNameToLLVM(LTypeDecl.TypeDefinition.TypeName);
    if LBaseType = nil then
    begin
      ACodeGen.CodeGenError('Unknown base type for pointer: %s', [LTypeDecl.TypeDefinition.TypeName], AType.Location);
      Result := nil;
      Exit;
    end;
    
    // Create pointer type
    LLLVMType := LLVMPointerType(LBaseType, 0);
    
    // Register the pointer type with its element type
    ACodeGen.TypeMapper.RegisterPointerType(LTypeDecl.TypeName, LBaseType);
  end
  else
  begin
    // For non-pointer types, check if it's a complex type or simple type
    if LTypeDecl.TypeDefinition.NodeKind = nkSimpleType then
      LLLVMType := ACodeGen.TypeMapper.MapTypeNameToLLVM(LTypeDecl.TypeDefinition.TypeName)
    else
      LLLVMType := CreateComplexType(ACodeGen, LTypeDecl.TypeDefinition);
  end;
  
  if LLLVMType = nil then
  begin
    ACodeGen.CodeGenError('Failed to resolve type: %s', [LTypeDecl.TypeDefinition.TypeName], AType.Location);
    Result := nil;
    Exit;
  end;
  
  // Register the type alias in the type mapper
  ACodeGen.TypeMapper.RegisterTypeAlias(LTypeDecl.TypeName, LLLVMType);
  
  // Add to symbol table as a type symbol
  ACodeGen.SymbolTable.AddTypeSymbol(LTypeDecl.TypeName);
  
  Result := LLLVMType;
end;

function GenerateVarDeclaration(const ACodeGen: TCPCodeGen; const AVar: TCPASTNode): LLVMValueRef;
begin
  // Variable declarations are processed during main function generation
  // after the basic block is created. No LLVM instructions generated here.
  Result := nil;
end;

procedure GenerateLocalFunctionDeclarations(const ACodeGen: TCPCodeGen; const ADeclarations: TCPASTNodeList);
var
  LIndex: Integer;
  LDeclaration: TCPASTNode;
  LFunction: TCPFunctionDeclarationNode;
  LFunctionValue: LLVMValueRef;
begin
  if ADeclarations = nil then
    Exit;

  // Generate only local function declarations (signatures, no bodies)
  for LIndex := 0 to ADeclarations.Count - 1 do
  begin
    LDeclaration := ADeclarations[LIndex];
    if LDeclaration = nil then
      Continue;

    if LDeclaration.NodeKind in [nkFunctionDeclaration, nkExternalFunction] then
    begin
      LFunction := TCPFunctionDeclarationNode(LDeclaration);
      if not LFunction.IsExternal then
      begin
        // Generate local function signature only
        LFunctionValue := GenerateLocalFunctionSignature(ACodeGen, LFunction);
        if LFunctionValue = nil then
        begin
          ACodeGen.CodeGenError('Failed to generate local function signature: %s', [LFunction.FunctionName], LFunction.Location, 'GenerateLocalFunctionSignature', 'Function: ' + LFunction.FunctionName);
          Continue;
        end;
      end;
    end;
  end;
end;

procedure GenerateLocalFunctionImplementations(const ACodeGen: TCPCodeGen; const ADeclarations: TCPASTNodeList);
var
  LIndex: Integer;
  LDeclaration: TCPASTNode;
  LFunction: TCPFunctionDeclarationNode;
  LFunctionValue: LLVMValueRef;
  LEntryBlock: LLVMBasicBlockRef;
  LParameter: TCPParameterNode;
  LParameterValue: LLVMValueRef;
  LParameterAlloca: LLVMValueRef;
  LParameterType: LLVMTypeRef;
  LParamIndex: Integer;
  LPreviousBlock: LLVMBasicBlockRef;
begin
  if ADeclarations = nil then
    Exit;

  // Generate only local function implementations (bodies)
  for LIndex := 0 to ADeclarations.Count - 1 do
  begin
    LDeclaration := ADeclarations[LIndex];
    if LDeclaration = nil then
      Continue;

    if LDeclaration.NodeKind in [nkFunctionDeclaration, nkExternalFunction] then
    begin
      LFunction := TCPFunctionDeclarationNode(LDeclaration);
      if not LFunction.IsExternal then
      begin
        // Get existing function from symbol table (signature was created earlier)
        LFunctionValue := ACodeGen.SymbolTable.GetSymbol(LFunction.FunctionName);
        if LFunctionValue = nil then
        begin
          ACodeGen.CodeGenError('Local function signature not found: %s', [LFunction.FunctionName], LFunction.Location, 'SymbolTable.GetSymbol', 'Function signature must be generated before implementation');
          Continue;
        end;

        // Check if function has a body
        if LFunction.Body = nil then
        begin
          ACodeGen.CodeGenError('Local function must have a body: %s', [LFunction.FunctionName], LFunction.Location);
          Continue;
        end;

        // Check if function already has basic blocks (already implemented)
        if LLVMGetFirstBasicBlock(LFunctionValue) <> nil then
        begin
          ACodeGen.CodeGenError('Function already has implementation: %s', [LFunction.FunctionName], LFunction.Location, 'LLVMGetFirstBasicBlock', 'Function: ' + LFunction.FunctionName + ' already has basic blocks - cannot implement twice');
          Continue;
        end;

        // Save current builder position to restore later
        LPreviousBlock := LLVMGetInsertBlock(ACodeGen.Builder);
        if LPreviousBlock = nil then
        begin
          ACodeGen.CodeGenError('LLVM builder not positioned when generating local function: %s', [LFunction.FunctionName], LFunction.Location, 'LLVMGetInsertBlock', 'Builder must be positioned before generating function bodies');
          Continue;
        end;

        // Push local scope for function parameters and local symbols
        ACodeGen.SymbolTable.PushScope();
        try
          // Create entry basic block
          LEntryBlock := LLVMAppendBasicBlockInContext(ACodeGen.Context, LFunctionValue, 'entry');
          if LEntryBlock = nil then
          begin
            ACodeGen.CodeGenError('Failed to create entry basic block for function: %s', [LFunction.FunctionName], LFunction.Location, 'LLVMAppendBasicBlockInContext', 'Function: ' + LFunction.FunctionName);
            Continue;
          end;

          LLVMPositionBuilderAtEnd(ACodeGen.Builder, LEntryBlock);

          // Generate parameter allocations and store parameter values
          for LParamIndex := 0 to LFunction.ParameterCount - 1 do
          begin
            LParameter := LFunction.GetParameter(LParamIndex);
            if LParameter = nil then
              Continue;
              
            LParameterValue := LLVMGetParam(LFunctionValue, LParamIndex);
            if LParameterValue = nil then
              Continue;
              
            LParameterType := ACodeGen.TypeMapper.MapCPascalTypeToLLVM(LParameter.ParameterType);
            if LParameterType = nil then
              Continue;

            if LParameter.IsVar or LParameter.IsOut then
            begin
            // var/out parameters are already pointers - use them directly
            ACodeGen.SymbolTable.AddSymbolWithType(LParameter.ParameterName, LParameterValue, LParameter.ParameterType.TypeName);
            end
            else
            begin
            // const parameters need allocation for local access
            LParameterAlloca := LLVMBuildAlloca(ACodeGen.Builder, LParameterType, CPAsUTF8(LParameter.ParameterName));
            if LParameterAlloca = nil then
            Continue;

            // Store parameter value into alloca
            LLVMBuildStore(ACodeGen.Builder, LParameterValue, LParameterAlloca);

            // Add parameter to symbol table with type information
            ACodeGen.SymbolTable.AddSymbolWithType(LParameter.ParameterName, LParameterAlloca, LParameter.ParameterType.TypeName);
            end;
          end;

          // Generate local variable allocations
          GenerateVariableAllocations(ACodeGen, LFunction.LocalDeclarations);

          // Generate function body (includes return statements)
          CPascal.CodeGen.Statements.GenerateCompoundStatement(ACodeGen, LFunction.Body);

          // Add automatic terminator if current basic block doesn't have one
          if LLVMGetInsertBlock(ACodeGen.Builder) <> nil then
          begin
            // Check if current basic block has a terminator
            if LLVMGetBasicBlockTerminator(LLVMGetInsertBlock(ACodeGen.Builder)) = nil then
            begin
              // No terminator - add automatic return
              if LFunction.ReturnType = nil then
              begin
                // Procedure - return void
                LLVMBuildRetVoid(ACodeGen.Builder);
              end
              else
              begin
                // Function - return default value for type
                LParameterType := ACodeGen.TypeMapper.MapCPascalTypeToLLVM(LFunction.ReturnType);
                if LParameterType <> nil then
                begin
                  if LParameterType = LLVMInt32TypeInContext(ACodeGen.Context) then
                    LParameterValue := LLVMConstInt(LParameterType, 0, 0)
                  else if LParameterType = LLVMInt1TypeInContext(ACodeGen.Context) then
                    LParameterValue := LLVMConstInt(LParameterType, 0, 0)
                  else
                    LParameterValue := LLVMConstNull(LParameterType);
                  
                  LLVMBuildRet(ACodeGen.Builder, LParameterValue);
                end
                else
                begin
                  // Fallback to void return
                  LLVMBuildRetVoid(ACodeGen.Builder);
                end;
              end;
            end;
          end;
        finally
          // Restore builder position and pop scope
          LLVMPositionBuilderAtEnd(ACodeGen.Builder, LPreviousBlock);
          ACodeGen.SymbolTable.PopScope();
        end;
      end;
    end;
  end;
end;

end.
