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

unit CPascal.CodeGen.Types;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  CPascal.Lexer,
  CPascal.CodeGen,
  CPascal.AST,
  CPascal.AST.Types,
  CPascal.AST.Expressions,
  CPascal.LLVM;

function GeneratePointerType(const ACodeGen: TCPCodeGen; const APointer: TCPASTNode): LLVMTypeRef;
function GenerateArrayType(const ACodeGen: TCPCodeGen; const AArray: TCPASTNode): LLVMTypeRef;
function GenerateRecordType(const ACodeGen: TCPCodeGen; const ARecord: TCPASTNode): LLVMTypeRef;
function GenerateUnionType(const ACodeGen: TCPCodeGen; const AUnion: TCPASTNode): LLVMTypeRef;
function GenerateEnumType(const ACodeGen: TCPCodeGen; const AEnum: TCPASTNode): LLVMTypeRef;
function GenerateFunctionType(const ACodeGen: TCPCodeGen; const AFunc: TCPASTNode): LLVMTypeRef;
function GenerateSubrangeType(const ACodeGen: TCPCodeGen; const ASubrange: TCPASTNode): LLVMTypeRef;
function CreateComplexType(const ACodeGen: TCPCodeGen; const ATypeNode: TCPTypeNode): LLVMTypeRef;

implementation

function GeneratePointerType(const ACodeGen: TCPCodeGen; const APointer: TCPASTNode): LLVMTypeRef;
var
  LTypeNode: TCPTypeNode;
  LBaseType: LLVMTypeRef;
begin
  if APointer.NodeKind <> nkPointerType then
  begin
    ACodeGen.CodeGenError('Expected pointer type node, got %s', [CPNodeKindToString(APointer.NodeKind)], APointer.Location);
    Result := nil;
    Exit;
  end;

  LTypeNode := TCPTypeNode(APointer);
  
  // Get the base type
  LBaseType := ACodeGen.TypeMapper.MapTypeNameToLLVM(LTypeNode.TypeName);
  if LBaseType = nil then
  begin
    ACodeGen.CodeGenError('Unknown base type for pointer: %s', [LTypeNode.TypeName], APointer.Location);
    Result := nil;
    Exit;
  end;
  
  // Create LLVM pointer type
  Result := LLVMPointerType(LBaseType, 0);
end;

function GenerateArrayType(const ACodeGen: TCPCodeGen; const AArray: TCPASTNode): LLVMTypeRef;
var
  LArrayNode: TCPArrayTypeNode;
  LElementType: LLVMTypeRef;
  LStartValue: Integer;
  LEndValue: Integer;
  LArraySize: Cardinal;
  LStartLiteral: TCPLiteralNode;
  LEndLiteral: TCPLiteralNode;
begin
  if AArray.NodeKind <> nkArrayType then
  begin
    ACodeGen.CodeGenError('Expected array type node, got %s', [CPNodeKindToString(AArray.NodeKind)], AArray.Location);
    Result := nil;
    Exit;
  end;

  LArrayNode := TCPArrayTypeNode(AArray);
  
  // Get element type
  LElementType := CreateComplexType(ACodeGen, LArrayNode.ElementType);
  if LElementType = nil then
  begin
    ACodeGen.CodeGenError('Failed to generate element type for array', [], AArray.Location);
    Result := nil;
    Exit;
  end;
  
  // Extract start and end values from literal expressions
  // For now, we only support constant integer literals in array bounds
  if (LArrayNode.StartIndex.NodeKind <> nkIntegerLiteral) or 
     (LArrayNode.EndIndex.NodeKind <> nkIntegerLiteral) then
  begin
    ACodeGen.CodeGenError('Array bounds must be constant integer literals', [], AArray.Location);
    Result := nil;
    Exit;
  end;
  
  LStartLiteral := TCPLiteralNode(LArrayNode.StartIndex);
  LEndLiteral := TCPLiteralNode(LArrayNode.EndIndex);
  
  try
    LStartValue := StrToInt(LStartLiteral.LiteralValue);
    LEndValue := StrToInt(LEndLiteral.LiteralValue);
  except
    on E: EConvertError do
    begin
      ACodeGen.CodeGenError('Invalid integer literal in array bounds: %s', [E.Message], AArray.Location);
      Result := nil;
      Exit;
    end;
  end;
  
  // Calculate array size
  if LEndValue < LStartValue then
  begin
    ACodeGen.CodeGenError('Array end index (%d) must be >= start index (%d)', [LEndValue, LStartValue], AArray.Location);
    Result := nil;
    Exit;
  end;
  
  LArraySize := Cardinal(LEndValue - LStartValue + 1);
  
  // Create LLVM array type
  Result := LLVMArrayType(LElementType, LArraySize);
end;

function GenerateRecordType(const ACodeGen: TCPCodeGen; const ARecord: TCPASTNode): LLVMTypeRef;
begin
  // Record type generation not yet implemented
  ACodeGen.CodeGenError('Record type generation not yet implemented', [], ARecord.Location);
  Result := nil;
end;

function GenerateUnionType(const ACodeGen: TCPCodeGen; const AUnion: TCPASTNode): LLVMTypeRef;
begin
  // Union type generation not yet implemented
  ACodeGen.CodeGenError('Union type generation not yet implemented', [], AUnion.Location);
  Result := nil;
end;

function GenerateEnumType(const ACodeGen: TCPCodeGen; const AEnum: TCPASTNode): LLVMTypeRef;
begin
  // Enum type generation not yet implemented
  ACodeGen.CodeGenError('Enum type generation not yet implemented', [], AEnum.Location);
  Result := nil;
end;

function GenerateFunctionType(const ACodeGen: TCPCodeGen; const AFunc: TCPASTNode): LLVMTypeRef;
begin
  // Function type generation not yet implemented
  ACodeGen.CodeGenError('Function type generation not yet implemented', [], AFunc.Location);
  Result := nil;
end;

function GenerateSubrangeType(const ACodeGen: TCPCodeGen; const ASubrange: TCPASTNode): LLVMTypeRef;
begin
  // Subrange type generation not yet implemented
  ACodeGen.CodeGenError('Subrange type generation not yet implemented', [], ASubrange.Location);
  Result := nil;
end;

function CreateComplexType(const ACodeGen: TCPCodeGen; const ATypeNode: TCPTypeNode): LLVMTypeRef;
begin
  // Determine complex type and delegate to appropriate generator
  case ATypeNode.NodeKind of
    nkPointerType:
      Result := GeneratePointerType(ACodeGen, ATypeNode);
    
    nkArrayType:
      Result := GenerateArrayType(ACodeGen, ATypeNode);
    
    nkRecordType:
      Result := GenerateRecordType(ACodeGen, ATypeNode);
    
    nkFunctionType:
      Result := GenerateFunctionType(ACodeGen, ATypeNode);
    
    // For simple types, use the existing type mapper
    nkSimpleType:
      Result := ACodeGen.TypeMapper.MapCPascalTypeToLLVM(ATypeNode);
      
  else
    ACodeGen.CodeGenError('Unsupported type node kind: %s', [CPNodeKindToString(ATypeNode.NodeKind)], ATypeNode.Location);
    Result := nil;
  end;
end;

end.
