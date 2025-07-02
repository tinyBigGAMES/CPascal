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

 https://github.com/tinyBigGAMES/CPascal

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

unit CPascal.IRGen;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.TypInfo,
  CPascal.Common,
  CPascal.AST,
  CPascal.LLVM,
  CPascal.Semantic,
  CPascal.Lexer;

type
  { The IR Generator class, responsible for converting the AST to LLVM IR. }
  TCPIRGenerator = class
  private
    FContext: LLVMContextRef;
    FModule: LLVMModuleRef;
    FBuilder: LLVMBuilderRef;
    FNamedValues: TDictionary<string, LLVMValueRef>;
    FSymbolTable: TCPSymbolTable;

    function IsUnsignedType(const AType: TTypeSymbol): Boolean;
    function IsIntegerType(const AType: TTypeSymbol): Boolean;
    function IsFloatType(const AType: TTypeSymbol): Boolean;
    function CreateTypeCast(const AValue: LLVMValueRef; const AFromType, AToType: TTypeSymbol): LLVMValueRef;

    procedure Visit(const ANode: TCPASTNode);
    function VisitExpression(const ANode: TExpressionNode): LLVMValueRef;

    procedure VisitProgramNode(const ANode: TProgramNode);
    procedure VisitVarSectionNode(const ANode: TVarSectionNode);
    procedure VisitCompoundStatementNode(const ANode: TCompoundStatementNode);
    procedure VisitAssignmentNode(const ANode: TAssignmentNode);
    procedure VisitIfStatementNode(const ANode: TIfStatementNode);
    procedure VisitWhileStatementNode(const ANode: TWhileStatementNode);
    procedure VisitRepeatStatementNode(const ANode: TRepeatStatementNode);
    procedure VisitForStatementNode(const ANode: TForStatementNode);

    function VisitBinaryOpNode(const ANode: TBinaryOpNode): LLVMValueRef;
    function VisitUnaryOpNode(const ANode: TUnaryOpNode): LLVMValueRef;
    function VisitIdentifierNode(const ANode: TIdentifierNode): LLVMValueRef;
    function VisitIntegerLiteralNode(const ANode: TIntegerLiteralNode): LLVMValueRef;
    function VisitRealLiteralNode(const ANode: TRealLiteralNode): LLVMValueRef;

    function GetLLVMType(const ATypeSymbol: TTypeSymbol): LLVMTypeRef;
    function GetExpressionType(const ANode: TExpressionNode): TTypeSymbol;
  public
    constructor Create(const ASymbolTable: TCPSymbolTable);
    destructor Destroy; override;

    procedure Generate(const ARootNode: TCPASTNode);
    function IRToString(): string;

    property Module: LLVMModuleRef read FModule;
  end;

implementation

{ TCPIRGenerator }

constructor TCPIRGenerator.Create(const ASymbolTable: TCPSymbolTable);
begin
  inherited Create();
  FNamedValues := TDictionary<string, LLVMValueRef>.Create;
  FSymbolTable := ASymbolTable;
  FContext := LLVMContextCreate();
  FBuilder := LLVMCreateBuilderInContext(FContext);
end;

destructor TCPIRGenerator.Destroy;
begin
  FNamedValues.Free;
  if Assigned(FBuilder) then
    LLVMDisposeBuilder(FBuilder);
  if Assigned(FModule) then
    LLVMDisposeModule(FModule);
  if Assigned(FContext) then
    LLVMContextDispose(FContext);
  inherited;
end;

function TCPIRGenerator.IsUnsignedType(const AType: TTypeSymbol): Boolean;
begin
  Result := Assigned(AType) and SameText(Copy(AType.Name, 1, 1), 'U');
end;

function TCPIRGenerator.IsIntegerType(const AType: TTypeSymbol): Boolean;
begin
  Result := Assigned(AType) and (SameText(Copy(AType.Name, 1, 3), 'INT') or
            SameText(Copy(AType.Name, 1, 4), 'UINT'));
end;

function TCPIRGenerator.IsFloatType(const AType: TTypeSymbol): Boolean;
begin
  Result := Assigned(AType) and (SameText(AType.Name, 'SINGLE') or SameText(AType.Name, 'DOUBLE'));
end;

function TCPIRGenerator.CreateTypeCast(const AValue: LLVMValueRef; const AFromType, AToType: TTypeSymbol): LLVMValueRef;
var
  LToLLVMType: LLVMTypeRef;
  LFromSize, LToSize: Cardinal;
begin
  if (not Assigned(AFromType)) or (not Assigned(AToType)) or (AFromType = AToType) then
    Exit(AValue);

  LToLLVMType := GetLLVMType(AToType);

  if IsFloatType(AToType) and IsIntegerType(AFromType) then
  begin
    if IsUnsignedType(AFromType) then
      Result := LLVMBuildUIToFP(FBuilder, AValue, LToLLVMType, 'uinttoflt')
    else
      Result := LLVMBuildSIToFP(FBuilder, AValue, LToLLVMType, 'inttoflt');
  end
  else if IsFloatType(AToType) and IsFloatType(AFromType) then
  begin
    if SameText(AToType.Name, 'DOUBLE') and SameText(AFromType.Name, 'SINGLE') then
      Result := LLVMBuildFPExt(FBuilder, AValue, LToLLVMType, 'fpext')
    else
      Result := LLVMBuildFPTrunc(FBuilder, AValue, LToLLVMType, 'dtrunc');
  end
  else if IsIntegerType(AToType) and IsIntegerType(AFromType) then
  begin
    LFromSize := LLVMGetIntTypeWidth(LLVMTypeOf(AValue));
    LToSize := LLVMGetIntTypeWidth(LToLLVMType);

    if LFromSize > LToSize then
      Result := LLVMBuildTrunc(FBuilder, AValue, LToLLVMType, 'inttrunc')
    else if LFromSize < LToSize then
    begin
      if IsUnsignedType(AFromType) then
        Result := LLVMBuildZExt(FBuilder, AValue, LToLLVMType, 'zext')
      else
        Result := LLVMBuildSExt(FBuilder, AValue, LToLLVMType, 'sext');
    end
    else
      Result := AValue;
  end
  else
    raise Exception.CreateFmt('Unsupported type cast from %s to %s', [AFromType.Name, AToType.Name]);
end;

function TCPIRGenerator.GetLLVMType(const ATypeSymbol: TTypeSymbol): LLVMTypeRef;
begin
  if SameText(ATypeSymbol.Name, 'INT8') then
    Result := LLVMInt8TypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'UINT8') then
    Result := LLVMInt8TypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'INT16') then
    Result := LLVMInt16TypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'UINT16') then
    Result := LLVMInt16TypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'INT32') then
    Result := LLVMInt32TypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'UINT32') then
    Result := LLVMInt32TypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'INT64') then
    Result := LLVMInt64TypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'UINT64') then
    Result := LLVMInt64TypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'SINGLE') then
    Result := LLVMFloatTypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'DOUBLE') then
    Result := LLVMDoubleTypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'BOOLEAN') then
    Result := LLVMInt1TypeInContext(FContext)
  else
    raise Exception.Create('Unsupported type for LLVM IR generation: ' + ATypeSymbol.Name);
end;

procedure TCPIRGenerator.Generate(const ARootNode: TCPASTNode);
begin
  Visit(ARootNode);
end;

function TCPIRGenerator.IRToString(): string;
var
  LStr: PAnsiChar;
begin
  if not Assigned(FModule) then
    Exit('Error: LLVM Module not generated yet.');
  LStr := LLVMPrintModuleToString(FModule);
  try
    Result := string(LStr);
  finally
    if Assigned(LStr) then
      LLVMDisposeMessage(LStr);
  end;
end;

procedure TCPIRGenerator.Visit(const ANode: TCPASTNode);
begin
  if not Assigned(ANode) then
    Exit;

  if ANode is TProgramNode then
    VisitProgramNode(ANode as TProgramNode)
  else if ANode is TVarSectionNode then
    VisitVarSectionNode(ANode as TVarSectionNode)
  else if ANode is TCompoundStatementNode then
    VisitCompoundStatementNode(ANode as TCompoundStatementNode)
  else if ANode is TAssignmentNode then
    VisitAssignmentNode(ANode as TAssignmentNode)
  else if ANode is TIfStatementNode then
    VisitIfStatementNode(ANode as TIfStatementNode)
  else if ANode is TWhileStatementNode then
    VisitWhileStatementNode(ANode as TWhileStatementNode)
  else if ANode is TRepeatStatementNode then
    VisitRepeatStatementNode(ANode as TRepeatStatementNode)
  else if ANode is TForStatementNode then
    VisitForStatementNode(ANode as TForStatementNode)
  else
    raise Exception.Create('Unsupported AST node in IR Generator: ' + ANode.ClassName);
end;

// MODIFIED
function TCPIRGenerator.GetExpressionType(const ANode: TExpressionNode): TTypeSymbol;
var
  LSymbol: TCPSymbol;
  LLeftType, LRightType: TTypeSymbol;
begin
  if ANode is TIdentifierNode then
  begin
    LSymbol := FSymbolTable.Lookup(TIdentifierNode(ANode).Name);
    Result := LSymbol.&Type;
  end
  else if ANode is TIntegerLiteralNode then
  begin
    LSymbol := FSymbolTable.Lookup('INT32');
    Result := LSymbol as TTypeSymbol;
  end
  else if ANode is TRealLiteralNode then
  begin
    LSymbol := FSymbolTable.Lookup('DOUBLE');
    Result := LSymbol as TTypeSymbol;
  end
  else if ANode is TBinaryOpNode then
  begin
    case TBinaryOpNode(ANode).Operator of
      tkEqual, tkNotEqual, tkLessThan, tkLessEqual, tkGreaterThan, tkGreaterEqual, tkAnd:
        begin
          Result := FSymbolTable.Lookup('BOOLEAN') as TTypeSymbol;
        end;
    else
      // Type promotion rules for arithmetic
      LLeftType := GetExpressionType(TBinaryOpNode(ANode).Left);
      LRightType := GetExpressionType(TBinaryOpNode(ANode).Right);

      if IsFloatType(LLeftType) and IsFloatType(LRightType) then
      begin
        if SameText(LLeftType.Name, 'DOUBLE') or SameText(LRightType.Name, 'DOUBLE') then
          Result := FSymbolTable.Lookup('DOUBLE') as TTypeSymbol
        else
          Result := FSymbolTable.Lookup('SINGLE') as TTypeSymbol;
      end
      else if IsFloatType(LLeftType) and IsIntegerType(LRightType) then
        Result := LLeftType
      else if IsIntegerType(LLeftType) and IsFloatType(LRightType) then
        Result := LRightType
      else // Both are integers
        Result := LLeftType; // Default to left type, size promotion happens later
    end;
  end
  else if ANode is TUnaryOpNode then
  begin
    Result := GetExpressionType(TUnaryOpNode(ANode).Operand);
  end
  else
    raise Exception.Create('Cannot determine type for expression node in IR Generator: ' + ANode.ClassName);
end;

function TCPIRGenerator.VisitExpression(const ANode: TExpressionNode): LLVMValueRef;
begin
  if ANode is TBinaryOpNode then
    Result := VisitBinaryOpNode(ANode as TBinaryOpNode)
  else if ANode is TUnaryOpNode then
    Result := VisitUnaryOpNode(ANode as TUnaryOpNode)
  else if ANode is TIdentifierNode then
    Result := VisitIdentifierNode(ANode as TIdentifierNode)
  else if ANode is TIntegerLiteralNode then
    Result := VisitIntegerLiteralNode(ANode as TIntegerLiteralNode)
  else if ANode is TRealLiteralNode then
    Result := VisitRealLiteralNode(ANode as TRealLiteralNode)
  else
    raise Exception.Create('Unsupported expression node in IR Generator: ' + ANode.ClassName);
end;

procedure TCPIRGenerator.VisitProgramNode(const ANode: TProgramNode);
var
  LMainFuncType: LLVMTypeRef;
  LMainFunc: LLVMValueRef;
  LEntryBlock: LLVMBasicBlockRef;
  LDecl: TDeclarationNode;
begin
  FModule := LLVMModuleCreateWithNameInContext(PAnsiChar(AnsiString(ANode.ProgramName.Name)), FContext);
  LMainFuncType := LLVMFunctionType(LLVMInt32TypeInContext(FContext), nil, 0, Ord(False));
  LMainFunc := LLVMAddFunction(FModule, 'main', LMainFuncType);
  LLVMSetLinkage(LMainFunc, LLVMExternalLinkage);
  LEntryBlock := LLVMAppendBasicBlockInContext(FContext, LMainFunc, 'entry');
  LLVMPositionBuilderAtEnd(FBuilder, LEntryBlock);

  for LDecl in ANode.Declarations do
    Visit(LDecl);

  Visit(ANode.CompoundStatement);

  LLVMBuildRet(FBuilder, LLVMConstInt(LLVMInt32TypeInContext(FContext), 0, Ord(False)));
end;

procedure TCPIRGenerator.VisitVarSectionNode(const ANode: TVarSectionNode);
var
  LDeclNode: TVarDeclNode;
  LIdentNode: TIdentifierNode;
  LTypeSymbol: TTypeSymbol;
  LLVMType: LLVMTypeRef;
  LSymbolLookupResult: TCPSymbol;
  LAlloca: LLVMValueRef;
begin
  for LDeclNode in ANode.Declarations do
  begin
    LSymbolLookupResult := FSymbolTable.Lookup(TTypeNameNode(LDeclNode.TypeSpec).Identifier.Name);
    LTypeSymbol := LSymbolLookupResult as TTypeSymbol;
    LLVMType := GetLLVMType(LTypeSymbol);

    for LIdentNode in LDeclNode.Identifiers do
    begin
      LAlloca := LLVMBuildAlloca(FBuilder, LLVMType, PAnsiChar(AnsiString(LIdentNode.Name)));
      FNamedValues.Add(LIdentNode.Name.ToUpper, LAlloca);
    end;
  end;
end;

procedure TCPIRGenerator.VisitCompoundStatementNode(const ANode: TCompoundStatementNode);
var
  LStmt: TStatementNode;
begin
  for LStmt in ANode.Statements do
    Visit(LStmt);
end;

procedure TCPIRGenerator.VisitAssignmentNode(const ANode: TAssignmentNode);
var
  LExprValue, LVarPtr, LCastedValue: LLVMValueRef;
  LVarName: string;
  LVarType, LExprType: TTypeSymbol;
begin
  LVarName := TIdentifierNode(ANode.Variable).Name;
  if not FNamedValues.TryGetValue(LVarName.ToUpper, LVarPtr) then
    raise Exception.Create('Code generation error: Unknown variable ' + LVarName);

  LExprValue := VisitExpression(ANode.Expression);
  LExprType := GetExpressionType(ANode.Expression);
  LVarType := GetExpressionType(ANode.Variable);

  LCastedValue := CreateTypeCast(LExprValue, LExprType, LVarType);
  LLVMBuildStore(FBuilder, LCastedValue, LVarPtr);
end;

procedure TCPIRGenerator.VisitIfStatementNode(const ANode: TIfStatementNode);
var
  LCondValue, LFunction: LLVMValueRef;
  LThenBlock, LElseBlock, LMergeBlock: LLVMBasicBlockRef;
begin
  LCondValue := VisitExpression(ANode.Condition);
  LFunction := LLVMGetBasicBlockParent(LLVMGetInsertBlock(FBuilder));

  LThenBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'then');
  LMergeBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'ifcont');

  if Assigned(ANode.ElseStatement) then
  begin
    LElseBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'else');
    LLVMBuildCondBr(FBuilder, LCondValue, LThenBlock, LElseBlock);
  end
  else
  begin
    LElseBlock := LMergeBlock;
    LLVMBuildCondBr(FBuilder, LCondValue, LThenBlock, LElseBlock);
  end;

  LLVMPositionBuilderAtEnd(FBuilder, LThenBlock);
  Visit(ANode.ThenStatement);
  LLVMBuildBr(FBuilder, LMergeBlock);

  if Assigned(ANode.ElseStatement) then
  begin
    LLVMPositionBuilderAtEnd(FBuilder, LElseBlock);
    Visit(ANode.ElseStatement);
    LLVMBuildBr(FBuilder, LMergeBlock);
  end;

  LLVMPositionBuilderAtEnd(FBuilder, LMergeBlock);
end;

procedure TCPIRGenerator.VisitWhileStatementNode(const ANode: TWhileStatementNode);
var
  LFunction: LLVMValueRef;
  LLoopHeaderBlock, LLoopBodyBlock, LAfterLoopBlock: LLVMBasicBlockRef;
  LCondValue: LLVMValueRef;
begin
  LFunction := LLVMGetBasicBlockParent(LLVMGetInsertBlock(FBuilder));

  LLoopHeaderBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'loop.header');
  LLoopBodyBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'loop.body');
  LAfterLoopBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'loop.after');

  LLVMBuildBr(FBuilder, LLoopHeaderBlock);

  LLVMPositionBuilderAtEnd(FBuilder, LLoopHeaderBlock);
  LCondValue := VisitExpression(ANode.Condition);
  LLVMBuildCondBr(FBuilder, LCondValue, LLoopBodyBlock, LAfterLoopBlock);

  LLVMPositionBuilderAtEnd(FBuilder, LLoopBodyBlock);
  Visit(ANode.Body);
  LLVMBuildBr(FBuilder, LLoopHeaderBlock);

  LLVMPositionBuilderAtEnd(FBuilder, LAfterLoopBlock);
end;

procedure TCPIRGenerator.VisitRepeatStatementNode(const ANode: TRepeatStatementNode);
var
  LFunction: LLVMValueRef;
  LLoopBodyBlock, LAfterLoopBlock: LLVMBasicBlockRef;
  LCondValue: LLVMValueRef;
  LStmt: TStatementNode;
begin
  LFunction := LLVMGetBasicBlockParent(LLVMGetInsertBlock(FBuilder));

  LLoopBodyBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'loop.body');
  LAfterLoopBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'loop.after');

  LLVMBuildBr(FBuilder, LLoopBodyBlock);

  LLVMPositionBuilderAtEnd(FBuilder, LLoopBodyBlock);

  for LStmt in ANode.Statements do
    Visit(LStmt);

  LCondValue := VisitExpression(ANode.Condition);
  LLVMBuildCondBr(FBuilder, LCondValue, LAfterLoopBlock, LLoopBodyBlock);

  LLVMPositionBuilderAtEnd(FBuilder, LAfterLoopBlock);
end;

procedure TCPIRGenerator.VisitForStatementNode(const ANode: TForStatementNode);
var
  LFunction: LLVMValueRef;
  LLoopCondBlock, LLoopBodyBlock, LLoopIncBlock, LAfterLoopBlock: LLVMBasicBlockRef;
  LStartVal, LEndVal, LLoopVarPtr, LIncDecVal, LStepVal, LCond: LLVMValueRef;
  LComparePred: LLVMIntPredicate;
begin
  LFunction := LLVMGetBasicBlockParent(LLVMGetInsertBlock(FBuilder));

  if not FNamedValues.TryGetValue(ANode.LoopVariable.Name.ToUpper, LLoopVarPtr) then
    raise Exception.Create('IRGen Error: FOR loop variable not found: ' + ANode.LoopVariable.Name);

  LStartVal := VisitExpression(ANode.StartValue);
  LLVMBuildStore(FBuilder, LStartVal, LLoopVarPtr);

  LLoopCondBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'for.cond');
  LLoopBodyBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'for.body');
  LLoopIncBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'for.inc');
  LAfterLoopBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'for.after');

  LLVMBuildBr(FBuilder, LLoopCondBlock);

  LLVMPositionBuilderAtEnd(FBuilder, LLoopCondBlock);
  LEndVal := VisitExpression(ANode.EndValue);
  if IsUnsignedType(GetExpressionType(ANode.LoopVariable)) then
  begin
    if ANode.Direction = fdTo then LComparePred := LLVMIntULE else LComparePred := LLVMIntUGE;
  end
  else
  begin
    if ANode.Direction = fdTo then LComparePred := LLVMIntSLE else LComparePred := LLVMIntSGE;
  end;
  LCond := LLVMBuildICmp(FBuilder, LComparePred, VisitIdentifierNode(ANode.LoopVariable), LEndVal, 'forcond');
  LLVMBuildCondBr(FBuilder, LCond, LLoopBodyBlock, LAfterLoopBlock);

  LLVMPositionBuilderAtEnd(FBuilder, LLoopBodyBlock);
  Visit(ANode.Body);
  LLVMBuildBr(FBuilder, LLoopIncBlock);

  LLVMPositionBuilderAtEnd(FBuilder, LLoopIncBlock);
  LStepVal := LLVMConstInt(GetLLVMType(GetExpressionType(ANode.LoopVariable)), 1, Ord(True));
  if ANode.Direction = fdTo then
    LIncDecVal := LLVMBuildNSWAdd(FBuilder, VisitIdentifierNode(ANode.LoopVariable), LStepVal, 'nextvar')
  else
    LIncDecVal := LLVMBuildNSWSub(FBuilder, VisitIdentifierNode(ANode.LoopVariable), LStepVal, 'nextvar');
  LLVMBuildStore(FBuilder, LIncDecVal, LLoopVarPtr);
  LLVMBuildBr(FBuilder, LLoopCondBlock);

  LLVMPositionBuilderAtEnd(FBuilder, LAfterLoopBlock);
end;

// REWRITTEN
function TCPIRGenerator.VisitBinaryOpNode(const ANode: TBinaryOpNode): LLVMValueRef;
var
  LLeft, LRight, LPromotedLeft, LPromotedRight: LLVMValueRef;
  LResultType, LLeftType, LRightType, LCommonType: TTypeSymbol;
  LIsUnsigned: Boolean;
begin
  // MODIFIED: Initialize Result to nil to satisfy the compiler.
  Result := nil;

  LLeft := VisitExpression(ANode.Left);
  LRight := VisitExpression(ANode.Right);
  LLeftType := GetExpressionType(ANode.Left);
  LRightType := GetExpressionType(ANode.Right);
  LResultType := GetExpressionType(ANode);

  case ANode.Operator of
    tkEqual, tkNotEqual, tkLessThan, tkLessEqual, tkGreaterThan, tkGreaterEqual:
    begin
      if IsFloatType(LLeftType) or IsFloatType(LRightType) then
      begin
        if SameText(LLeftType.Name, 'DOUBLE') or SameText(LRightType.Name, 'DOUBLE') then
          LCommonType := FSymbolTable.Lookup('DOUBLE') as TTypeSymbol
        else
          LCommonType := FSymbolTable.Lookup('SINGLE') as TTypeSymbol;
      end
      else
        LCommonType := LLeftType;

      LPromotedLeft := CreateTypeCast(LLeft, LLeftType, LCommonType);
      LPromotedRight := CreateTypeCast(LRight, LRightType, LCommonType);

      if IsFloatType(LCommonType) then
      begin
        case ANode.Operator of
          tkEqual: Result := LLVMBuildFCmp(FBuilder, LLVMRealOEQ, LPromotedLeft, LPromotedRight, 'feqtmp');
          tkNotEqual: Result := LLVMBuildFCmp(FBuilder, LLVMRealONE, LPromotedLeft, LPromotedRight, 'fnetmp');
          tkLessThan: Result := LLVMBuildFCmp(FBuilder, LLVMRealOLT, LPromotedLeft, LPromotedRight, 'flttmp');
          tkLessEqual: Result := LLVMBuildFCmp(FBuilder, LLVMRealOLE, LPromotedLeft, LPromotedRight, 'fletmp');
          tkGreaterThan: Result := LLVMBuildFCmp(FBuilder, LLVMRealOGT, LPromotedLeft, LPromotedRight, 'fgttmp');
          tkGreaterEqual: Result := LLVMBuildFCmp(FBuilder, LLVMRealOGE, LPromotedLeft, LPromotedRight, 'fgetmp');
        end;
      end
      else // Integer comparison
      begin
        LIsUnsigned := IsUnsignedType(LCommonType);
        case ANode.Operator of
          tkEqual: Result := LLVMBuildICmp(FBuilder, LLVMIntEQ, LPromotedLeft, LPromotedRight, 'eqtmp');
          tkNotEqual: Result := LLVMBuildICmp(FBuilder, LLVMIntNE, LPromotedLeft, LPromotedRight, 'netmp');
          tkLessThan: if LIsUnsigned then Result := LLVMBuildICmp(FBuilder, LLVMIntULT, LPromotedLeft, LPromotedRight, 'lttmp') else Result := LLVMBuildICmp(FBuilder, LLVMIntSLT, LPromotedLeft, LPromotedRight, 'lttmp');
          tkLessEqual: if LIsUnsigned then Result := LLVMBuildICmp(FBuilder, LLVMIntULE, LPromotedLeft, LPromotedRight, 'letmp') else Result := LLVMBuildICmp(FBuilder, LLVMIntSLE, LPromotedLeft, LPromotedRight, 'letmp');
          tkGreaterThan: if LIsUnsigned then Result := LLVMBuildICmp(FBuilder, LLVMIntUGT, LPromotedLeft, LPromotedRight, 'gttmp') else Result := LLVMBuildICmp(FBuilder, LLVMIntSGT, LPromotedLeft, LPromotedRight, 'gttmp');
          tkGreaterEqual: if LIsUnsigned then Result := LLVMBuildICmp(FBuilder, LLVMIntUGE, LPromotedLeft, LPromotedRight, 'getmp') else Result := LLVMBuildICmp(FBuilder, LLVMIntSGE, LPromotedLeft, LPromotedRight, 'getmp');
        end;
      end;
    end;
  else // Arithmetic or Logical
    begin
      LPromotedLeft := CreateTypeCast(LLeft, LLeftType, LResultType);
      LPromotedRight := CreateTypeCast(LRight, LRightType, LResultType);

      if ANode.Operator = tkAnd then
      begin
        Result := LLVMBuildAnd(FBuilder, LPromotedLeft, LPromotedRight, 'andtmp');
      end
      else if IsFloatType(LResultType) then
      begin
        case ANode.Operator of
          tkPlus: Result := LLVMBuildFAdd(FBuilder, LPromotedLeft, LPromotedRight, 'faddtmp');
          tkMinus: Result := LLVMBuildFSub(FBuilder, LPromotedLeft, LPromotedRight, 'fsubtmp');
          tkAsterisk: Result := LLVMBuildFMul(FBuilder, LPromotedLeft, LPromotedRight, 'fmultmp');
          tkSlash: Result := LLVMBuildFDiv(FBuilder, LPromotedLeft, LPromotedRight, 'fdivtmp');
        // MODIFIED: Added else block for robustness
        else
          raise ECPCompilerError.Create('Unsupported binary operator for floats: ' + ANode.Token.Value, ANode.Token.Line, ANode.Token.Column);
        end;
      end
      else // Integer arithmetic
      begin
        LIsUnsigned := IsUnsignedType(LResultType);
        case ANode.Operator of
          tkPlus: Result := LLVMBuildNSWAdd(FBuilder, LPromotedLeft, LPromotedRight, 'addtmp');
          tkMinus: Result := LLVMBuildNSWSub(FBuilder, LPromotedLeft, LPromotedRight, 'subtmp');
          tkAsterisk: Result := LLVMBuildNSWMul(FBuilder, LPromotedLeft, LPromotedRight, 'multmp');
          tkSlash: if LIsUnsigned then Result := LLVMBuildUDiv(FBuilder, LPromotedLeft, LPromotedRight, 'udivtmp')
                   else Result := LLVMBuildSDiv(FBuilder, LPromotedLeft, LPromotedRight, 'sdivtmp');
        // MODIFIED: Added else block for robustness
        else
          raise ECPCompilerError.Create('Unsupported binary operator for integers: ' + ANode.Token.Value, ANode.Token.Line, ANode.Token.Column);
        end;
      end;
    end;
  end;
end;

function TCPIRGenerator.VisitUnaryOpNode(const ANode: TUnaryOpNode): LLVMValueRef;
var
  LOperandValue: LLVMValueRef;
  LOperandType: TTypeSymbol;
begin
  LOperandValue := VisitExpression(ANode.Operand);
  LOperandType := GetExpressionType(ANode.Operand);
  case ANode.Operator of
    tkMinus:
      begin
        if IsFloatType(LOperandType) then
          Result := LLVMBuildFNeg(FBuilder, LOperandValue, 'fnegtmp')
        else
          Result := LLVMBuildNSWNeg(FBuilder, LOperandValue, 'negtmp');
      end;
    tkPlus: Result := LOperandValue;
  else
    raise Exception.Create('Unsupported unary operator in IR Generation.');
  end;
end;

function TCPIRGenerator.VisitIdentifierNode(const ANode: TIdentifierNode): LLVMValueRef;
var
  LVarPtr, LLVMType: LLVMTypeRef;
  LTypeSymbol: TTypeSymbol;
begin
  if not FNamedValues.TryGetValue(ANode.Name.ToUpper, LVarPtr) then
    raise Exception.Create('Code generation error: Unknown variable ' + ANode.Name);
  LTypeSymbol := GetExpressionType(ANode);
  LLVMType := GetLLVMType(LTypeSymbol);
  Result := LLVMBuildLoad2(FBuilder, LLVMType, LVarPtr, PAnsiChar(AnsiString(ANode.Name + '_val')));
end;

function TCPIRGenerator.VisitIntegerLiteralNode(const ANode: TIntegerLiteralNode): LLVMValueRef;
var
  LType: LLVMTypeRef;
begin
  LType := LLVMInt32TypeInContext(FContext);
  Result := LLVMConstInt(LType, ANode.Value, Ord(True));
end;

function TCPIRGenerator.VisitRealLiteralNode(const ANode: TRealLiteralNode): LLVMValueRef;
var
  LType: LLVMTypeRef;
begin
  LType := LLVMDoubleTypeInContext(FContext);
  Result := LLVMConstReal(LType, ANode.Value);
end;

end.
