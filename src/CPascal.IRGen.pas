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
  TLoopContext = record
    HeaderBlock: LLVMBasicBlockRef;
    ExitBlock: LLVMBasicBlockRef;
  end;

  { The IR Generator class, responsible for converting the AST to LLVM IR. }
  TCPIRGenerator = class
  private
    FContext: LLVMContextRef;
    FModule: LLVMModuleRef;
    FBuilder: LLVMBuilderRef;
    FNamedValueScopes: TStack<TDictionary<string, LLVMValueRef>>;
    FSymbolTable: TCPSymbolTable;
    FLoopContextStack: TStack<TLoopContext>;
    FCurrentFunction: LLVMValueRef;
    FMainFunction: LLVMValueRef;

    procedure EnterScope();
    procedure LeaveScope();
    function FindNamedValue(const AName: string): LLVMValueRef;
    procedure AddNamedValue(const AName: string; AValue: LLVMValueRef);

    function GetBitWidth(const AType: TTypeSymbol): Integer;
    function IsUnsignedType(const AType: TTypeSymbol): Boolean;
    function IsIntegerType(const AType: TTypeSymbol): Boolean;
    function IsFloatType(const AType: TTypeSymbol): Boolean;
    function CreateTypeCast(const AValue: LLVMValueRef; const AFromType, AToType: TTypeSymbol; const AToken: TCPToken): LLVMValueRef;

    procedure Visit(const ANode: TCPASTNode);
    function VisitExpression(const ANode: TExpressionNode): LLVMValueRef;

    procedure VisitProgramNode(const ANode: TProgramNode);
    procedure VisitVarSectionNode(const ANode: TVarSectionNode);
    procedure VisitFunctionDeclNode(const ANode: TFunctionDeclNode);
    procedure VisitCompoundStatementNode(const ANode: TCompoundStatementNode);
    procedure VisitAssignmentNode(const ANode: TAssignmentNode);
    procedure VisitProcedureCallNode(const ANode: TProcedureCallNode);
    procedure VisitIfStatementNode(const ANode: TIfStatementNode);
    procedure VisitWhileStatementNode(const ANode: TWhileStatementNode);
    procedure VisitRepeatStatementNode(const ANode: TRepeatStatementNode);
    procedure VisitForStatementNode(const ANode: TForStatementNode);
    procedure VisitBreakStatementNode(const ANode: TBreakStatementNode);
    procedure VisitContinueStatementNode(const ANode: TContinueStatementNode);
    procedure VisitExitStatementNode(const ANode: TExitStatementNode);

    function VisitBinaryOpNode(const ANode: TBinaryOpNode): LLVMValueRef;
    function VisitUnaryOpNode(const ANode: TUnaryOpNode): LLVMValueRef;
    function VisitIdentifierNode(const ANode: TIdentifierNode): LLVMValueRef;
    function VisitFunctionCallNode(const ANode: TFunctionCallNode): LLVMValueRef;
    function VisitIntegerLiteralNode(const ANode: TIntegerLiteralNode): LLVMValueRef;
    function VisitRealLiteralNode(const ANode: TRealLiteralNode): LLVMValueRef;

    function GetLLVMType(const ATypeSymbol: TTypeSymbol; const AToken: TCPToken): LLVMTypeRef;
    function GetExpressionType(const ANode: TExpressionNode): TTypeSymbol;
    function GetPointerTo(const ANode: TExpressionNode): LLVMValueRef;
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
  FNamedValueScopes := TStack<TDictionary<string, LLVMValueRef>>.Create;
  FLoopContextStack := TStack<TLoopContext>.Create;
  FSymbolTable := ASymbolTable;
  FContext := LLVMContextCreate();
  FBuilder := LLVMCreateBuilderInContext(FContext);
  FCurrentFunction := nil;
  FMainFunction := nil;
end;

destructor TCPIRGenerator.Destroy;
begin
  while FNamedValueScopes.Count > 0 do
    LeaveScope();
  FNamedValueScopes.Free;
  FLoopContextStack.Free;
  if Assigned(FBuilder) then
    LLVMDisposeBuilder(FBuilder);
  if Assigned(FModule) then
    LLVMDisposeModule(FModule);
  if Assigned(FContext) then
    LLVMContextDispose(FContext);
  inherited;
end;

procedure TCPIRGenerator.EnterScope;
begin
  FNamedValueScopes.Push(TDictionary<string, LLVMValueRef>.Create);
  FSymbolTable.EnterScope();
end;

procedure TCPIRGenerator.LeaveScope;
var
  LOldScope: TDictionary<string, LLVMValueRef>;
begin
  LOldScope := FNamedValueScopes.Pop;
  LOldScope.Free;
  FSymbolTable.LeaveScope();
end;

function TCPIRGenerator.FindNamedValue(const AName: string): LLVMValueRef;
var
  LScope: TDictionary<string, LLVMValueRef>;
  LUpperName: string;
begin
  Result := nil;
  LUpperName := AName.ToUpper;
  for LScope in FNamedValueScopes do
  begin
    if LScope.TryGetValue(LUpperName, Result) then
      Exit;
  end;
end;

procedure TCPIRGenerator.AddNamedValue(const AName: string; AValue: LLVMValueRef);
begin
  FNamedValueScopes.Peek.Add(AName.ToUpper, AValue);
end;

function TCPIRGenerator.GetBitWidth(const AType: TTypeSymbol): Integer;
var
  LTypeName: string;
begin
  Result := 0;
  if not Assigned(AType) or not IsIntegerType(AType) then Exit;
  LTypeName := AType.Name.ToUpper;
  LTypeName := StringReplace(LTypeName, 'U', '', [rfReplaceAll]);
  LTypeName := StringReplace(LTypeName, 'INT', '', [rfReplaceAll]);
  Result := StrToIntDef(LTypeName, 0);
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

function TCPIRGenerator.CreateTypeCast(const AValue: LLVMValueRef; const AFromType, AToType: TTypeSymbol; const AToken: TCPToken): LLVMValueRef;
var
  LToLLVMType: LLVMTypeRef;
  LFromSize, LToSize: Cardinal;
begin
  if (not Assigned(AFromType)) or (not Assigned(AToType)) or (AFromType = AToType) then
    Exit(AValue);

  LToLLVMType := GetLLVMType(AToType, AToken);

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
    else if SameText(AToType.Name, 'SINGLE') and SameText(AFromType.Name, 'DOUBLE') then
      Result := LLVMBuildFPTrunc(FBuilder, AValue, LToLLVMType, 'dtrunc')
    else
      Result := AValue;
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
    raise ECPCompilerError.Create(Format('Unsupported type cast from %s to %s', [AFromType.Name, AToType.Name]), AToken.Line, AToken.Column);
end;

function TCPIRGenerator.GetLLVMType(const ATypeSymbol: TTypeSymbol; const AToken: TCPToken): LLVMTypeRef;
begin
  if not Assigned(ATypeSymbol) then
  begin
    Result := LLVMVoidTypeInContext(FContext);
    Exit;
  end;

  if SameText(ATypeSymbol.Name, 'INT8') or SameText(ATypeSymbol.Name, 'UINT8') then
    Result := LLVMInt8TypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'INT16') or SameText(ATypeSymbol.Name, 'UINT16') then
    Result := LLVMInt16TypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'INT32') or SameText(ATypeSymbol.Name, 'UINT32') then
    Result := LLVMInt32TypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'INT64') or SameText(ATypeSymbol.Name, 'UINT64') then
    Result := LLVMInt64TypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'SINGLE') then
    Result := LLVMFloatTypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'DOUBLE') then
    Result := LLVMDoubleTypeInContext(FContext)
  else if SameText(ATypeSymbol.Name, 'BOOLEAN') then
    Result := LLVMInt1TypeInContext(FContext)
  else
    raise ECPCompilerError.Create('Unsupported type for LLVM IR generation: ' + ATypeSymbol.Name, AToken.Line, AToken.Column);
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
  else if ANode is TFunctionDeclNode then
    VisitFunctionDeclNode(ANode as TFunctionDeclNode)
  else if ANode is TCompoundStatementNode then
    VisitCompoundStatementNode(ANode as TCompoundStatementNode)
  else if ANode is TAssignmentNode then
    VisitAssignmentNode(ANode as TAssignmentNode)
  else if ANode is TProcedureCallNode then
    VisitProcedureCallNode(ANode as TProcedureCallNode)
  else if ANode is TIfStatementNode then
    VisitIfStatementNode(ANode as TIfStatementNode)
  else if ANode is TWhileStatementNode then
    VisitWhileStatementNode(ANode as TWhileStatementNode)
  else if ANode is TRepeatStatementNode then
    VisitRepeatStatementNode(ANode as TRepeatStatementNode)
  else if ANode is TForStatementNode then
    VisitForStatementNode(ANode as TForStatementNode)
  else if ANode is TBreakStatementNode then
    VisitBreakStatementNode(ANode as TBreakStatementNode)
  else if ANode is TContinueStatementNode then
    VisitContinueStatementNode(ANode as TContinueStatementNode)
  else if ANode is TExitStatementNode then
    VisitExitStatementNode(ANode as TExitStatementNode)
  else
    raise ECPCompilerError.Create('Unsupported AST node in IR Generator: ' + ANode.ClassName, ANode.Token.Line, ANode.Token.Column);
end;

function TCPIRGenerator.GetExpressionType(const ANode: TExpressionNode): TTypeSymbol;
var
  LSymbol: TCPSymbol;
  LFuncSymbol: TFunctionSymbol;
  LLeftType, LRightType: TTypeSymbol;
begin

  if ANode is TIdentifierNode then
  begin
    LSymbol := FSymbolTable.Lookup(TIdentifierNode(ANode).Name);
    if not Assigned(LSymbol) then
      raise ECPCompilerError.Create(Format('Undeclared identifier "%s" in IR Generator', [TIdentifierNode(ANode).Name]), ANode.Token.Line, ANode.Token.Column);
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
      tkEqual, tkNotEqual, tkLessThan, tkLessEqual, tkGreaterThan, tkGreaterEqual, tkAnd, tkOr:
        begin
          Result := FSymbolTable.Lookup('BOOLEAN') as TTypeSymbol;
        end;
    else
      LLeftType := GetExpressionType(TBinaryOpNode(ANode).Left);
      LRightType := GetExpressionType(TBinaryOpNode(ANode).Right);

      if IsFloatType(LLeftType) or IsFloatType(LRightType) then
      begin
        if (IsFloatType(LLeftType) and SameText(LLeftType.Name, 'DOUBLE')) or
           (IsFloatType(LRightType) and SameText(LRightType.Name, 'DOUBLE')) then
          Result := FSymbolTable.Lookup('DOUBLE') as TTypeSymbol
        else
          Result := FSymbolTable.Lookup('SINGLE') as TTypeSymbol;
      end
      else // Both are integers
      begin
          if GetBitWidth(LLeftType) > GetBitWidth(LRightType) then
            Result := LLeftType
          else
            Result := LRightType;
      end;
    end;
  end
  else if ANode is TUnaryOpNode then
  begin
    Result := GetExpressionType(TUnaryOpNode(ANode).Operand);
  end
  else if ANode is TFunctionCallNode then
  begin
    LSymbol := FSymbolTable.Lookup(TFunctionCallNode(ANode).FunctionName.Name);
    if not Assigned(LSymbol) then
      raise ECPCompilerError.Create(Format('Undeclared function "%s" in IR Generator', [TFunctionCallNode(ANode).FunctionName.Name]), ANode.Token.Line, ANode.Token.Column);

    LFuncSymbol := LSymbol as TFunctionSymbol;
    Result := LFuncSymbol.ReturnType;
  end
  else
    raise ECPCompilerError.Create('Cannot determine type for expression node in IR Generator: ' + ANode.ClassName, ANode.Token.Line, ANode.Token.Column);
end;

function TCPIRGenerator.VisitExpression(const ANode: TExpressionNode): LLVMValueRef;
begin
  if ANode is TBinaryOpNode then
    Result := VisitBinaryOpNode(ANode as TBinaryOpNode)
  else if ANode is TUnaryOpNode then
    Result := VisitUnaryOpNode(ANode as TUnaryOpNode)
  else if ANode is TIdentifierNode then
    Result := VisitIdentifierNode(ANode as TIdentifierNode)
  else if ANode is TFunctionCallNode then
    Result := VisitFunctionCallNode(ANode as TFunctionCallNode)
  else if ANode is TIntegerLiteralNode then
    Result := VisitIntegerLiteralNode(ANode as TIntegerLiteralNode)
  else if ANode is TRealLiteralNode then
    Result := VisitRealLiteralNode(ANode as TRealLiteralNode)
  else
    raise ECPCompilerError.Create('Unsupported expression node in IR Generator: ' + ANode.ClassName, ANode.Token.Line, ANode.Token.Column);
end;

procedure TCPIRGenerator.VisitProgramNode(const ANode: TProgramNode);
var
  LMainFuncType: LLVMTypeRef;
  LDecl: TDeclarationNode;
  LEntryBlock: LLVMBasicBlockRef;
begin
  FModule := LLVMModuleCreateWithNameInContext(PAnsiChar(AnsiString(ANode.ProgramName.Name)), FContext);

  EnterScope();
  try
    for LDecl in ANode.Declarations do
      Visit(LDecl);

    LMainFuncType := LLVMFunctionType(LLVMInt32TypeInContext(FContext), nil, 0, Ord(False));
    FMainFunction := LLVMAddFunction(FModule, 'main', LMainFuncType);
    LLVMSetLinkage(FMainFunction, LLVMExternalLinkage);
    LEntryBlock := LLVMAppendBasicBlockInContext(FContext, FMainFunction, 'entry');
    LLVMPositionBuilderAtEnd(FBuilder, LEntryBlock);

    FCurrentFunction := FMainFunction;
    Visit(ANode.CompoundStatement);

    if not Assigned(LLVMGetBasicBlockTerminator(LLVMGetInsertBlock(FBuilder))) then
      LLVMBuildRet(FBuilder, LLVMConstInt(LLVMInt32TypeInContext(FContext), 0, Ord(False)));

    FCurrentFunction := nil;
  finally
    LeaveScope();
  end;
end;

procedure TCPIRGenerator.VisitVarSectionNode(const ANode: TVarSectionNode);
var
  LDeclNode: TVarDeclNode;
  LIdentNode: TIdentifierNode;
  LTypeSymbol: TTypeSymbol;
  LLVMType: LLVMTypeRef;
  LSymbolLookupResult: TCPSymbol;
  LAlloca: LLVMValueRef;
  LIsGlobal: Boolean;
  LNewVarSymbol: TVariableSymbol;
begin
  LIsGlobal := FNamedValueScopes.Count <= 1;

  for LDeclNode in ANode.Declarations do
  begin
    LSymbolLookupResult := FSymbolTable.Lookup(TTypeNameNode(LDeclNode.TypeSpec).Identifier.Name);
    if not Assigned(LSymbolLookupResult) then
      raise ECPCompilerError.Create('Type not found: ' + TTypeNameNode(LDeclNode.TypeSpec).Identifier.Name, LDeclNode.Token.Line, LDeclNode.Token.Column);
    LTypeSymbol := LSymbolLookupResult as TTypeSymbol;
    LLVMType := GetLLVMType(LTypeSymbol, LDeclNode.Token);

    for LIdentNode in LDeclNode.Identifiers do
    begin
      if LIsGlobal then
      begin
        LAlloca := LLVMAddGlobal(FModule, LLVMType, PAnsiChar(AnsiString(LIdentNode.Name)));
        LLVMSetInitializer(LAlloca, LLVMConstNull(LLVMType));
        LLVMSetLinkage(LAlloca, LLVMPrivateLinkage);
      end
      else
        LAlloca := LLVMBuildAlloca(FBuilder, LLVMType, PAnsiChar(AnsiString(LIdentNode.Name)));

      AddNamedValue(LIdentNode.Name, LAlloca);

      LNewVarSymbol := TVariableSymbol.Create(LIdentNode.Name, skVariable);
      LNewVarSymbol.&Type := LTypeSymbol;
      if not FSymbolTable.Declare(LNewVarSymbol) then
         raise ECPCompilerError.Create('Internal IRGen Error: Duplicate symbol found: ' + LIdentNode.Name, LIdentNode.Token.Line, LIdentNode.Token.Column);
    end;
  end;
end;

procedure TCPIRGenerator.VisitFunctionDeclNode(const ANode: TFunctionDeclNode);
var
  LFunc, LParamValue, LParamAlloca: LLVMValueRef;
  LFuncType: LLVMTypeRef;
  LFuncSymbol: TFunctionSymbol;
  LRetType: LLVMTypeRef;
  LEntryBlock: LLVMBasicBlockRef;
  LOldBuilderBlock: LLVMBasicBlockRef;
  LTerminator: LLVMValueRef;
  LResultAlloca, LLoadedResult: LLVMValueRef;
  LDecl: TDeclarationNode;
  LResultVar: TVariableSymbol;
  LParamTypes: array of LLVMTypeRef;
  LParamTypesPtr: PLLVMTypeRef;
  LParamIndex: Integer;
  LConvention: Cardinal;
begin
  LFuncSymbol := FSymbolTable.Lookup(ANode.Name.Name) as TFunctionSymbol;
  LRetType := GetLLVMType(LFuncSymbol.ReturnType, ANode.Name.Token);

  SetLength(LParamTypes, LFuncSymbol.Parameters.Count);
  for LParamIndex := 0 to LFuncSymbol.Parameters.Count - 1 do
  begin
    if LFuncSymbol.Parameters[LParamIndex].Modifier = pmVar then
      LParamTypes[LParamIndex] := LLVMPointerType(GetLLVMType(LFuncSymbol.Parameters[LParamIndex].&Type, ANode.Token), 0)
    else
      LParamTypes[LParamIndex] := GetLLVMType(LFuncSymbol.Parameters[LParamIndex].&Type, ANode.Token);
  end;

  if Length(LParamTypes) > 0 then
    LParamTypesPtr := @LParamTypes[0]
  else
    LParamTypesPtr := nil;

  LFuncType := LLVMFunctionType(LRetType, LParamTypesPtr, Length(LParamTypes), Ord(False));
  LFunc := LLVMAddFunction(FModule, PAnsiChar(AnsiString(ANode.Name.Name)), LFuncType);

  case ANode.CallingConvention of
    ccCdecl: LConvention := Ord(LLVMCCallConv);
    ccStdcall: LConvention := Ord(LLVMX86StdcallCallConv);
    ccFastcall: LConvention := Ord(LLVMFastCallConv);
    ccRegister: LConvention := Ord(LLVMAnyRegCallConv); // Using AnyReg as a stand-in for 'register'
    else LConvention := Ord(LLVMCCallConv);
  end;
  LLVMSetFunctionCallConv(LFunc, LConvention);

  if ANode.IsExternal then
    Exit;

  EnterScope();
  try
    FCurrentFunction := LFunc;
    LEntryBlock := LLVMAppendBasicBlockInContext(FContext, LFunc, 'entry');
    LOldBuilderBlock := LLVMGetInsertBlock(FBuilder);
    LLVMPositionBuilderAtEnd(FBuilder, LEntryBlock);

    for LParamIndex := 0 to LFuncSymbol.Parameters.Count - 1 do
    begin
      LParamValue := LLVMGetParam(LFunc, LParamIndex);
      LLVMSetValueName(LParamValue, PAnsiChar(AnsiString(LFuncSymbol.Parameters[LParamIndex].Name)));
      LParamAlloca := LLVMBuildAlloca(FBuilder, LParamTypes[LParamIndex], PAnsiChar(AnsiString(LFuncSymbol.Parameters[LParamIndex].Name + '_ptr')));
      LLVMBuildStore(FBuilder, LParamValue, LParamAlloca);
      AddNamedValue(LFuncSymbol.Parameters[LParamIndex].Name, LParamAlloca);
      FSymbolTable.Declare(LFuncSymbol.Parameters[LParamIndex]);
    end;

    if not ANode.IsProcedure then
    begin
      LResultAlloca := LLVMBuildAlloca(FBuilder, LRetType, 'result');
      AddNamedValue('Result', LResultAlloca);
      LResultVar := TVariableSymbol.Create('Result', skVariable);
      LResultVar.&Type := LFuncSymbol.ReturnType;
      FSymbolTable.Declare(LResultVar);
    end;

    for LDecl in ANode.Declarations do
      Visit(LDecl);

    Visit(ANode.Body);

    LTerminator := LLVMGetBasicBlockTerminator(LLVMGetInsertBlock(FBuilder));
    if not Assigned(LTerminator) then
    begin
      if ANode.IsProcedure then
        LLVMBuildRetVoid(FBuilder)
      else
      begin
        LResultAlloca := FindNamedValue('Result');
        LLoadedResult := LLVMBuildLoad2(FBuilder, LRetType, LResultAlloca, 'ret');
        LLVMBuildRet(FBuilder, LLoadedResult);
      end;
    end;

    if Assigned(LOldBuilderBlock) then
      LLVMPositionBuilderAtEnd(FBuilder, LOldBuilderBlock);

  finally
    LeaveScope();
    FCurrentFunction := nil;
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
  LVarSymbol: TCPSymbol;
begin
  LVarName := TIdentifierNode(ANode.Variable).Name;
  LVarPtr := FindNamedValue(LVarName);
  LVarSymbol := FSymbolTable.Lookup(LVarName);

  if not Assigned(LVarPtr) then
    raise ECPCompilerError.Create('Code generation error: Unknown variable ' + LVarName, ANode.Token.Line, ANode.Token.Column);

  LExprValue := VisitExpression(ANode.Expression);
  LExprType := GetExpressionType(ANode.Expression);
  LVarType := GetExpressionType(ANode.Variable);

  LCastedValue := CreateTypeCast(LExprValue, LExprType, LVarType, ANode.Expression.Token);

  if (LVarSymbol is TParameterSymbol) and (TParameterSymbol(LVarSymbol).Modifier = pmVar) then
  begin
    LVarPtr := LLVMBuildLoad2(FBuilder, LLVMPointerType(GetLLVMType(LVarType, ANode.Token), 0), LVarPtr, 'var_param_addr');
  end;
  LLVMBuildStore(FBuilder, LCastedValue, LVarPtr);
end;

function TCPIRGenerator.GetPointerTo(const ANode: TExpressionNode): LLVMValueRef;
var
  LIdent: TIdentifierNode;
  LVarPtr: LLVMValueRef;
  LSymbol: TCPSymbol;
begin
  if not (ANode is TIdentifierNode) then
    raise ECPCompilerError.Create('VAR parameter must be a variable', ANode.Token.Line, ANode.Token.Column);
  LIdent := ANode as TIdentifierNode;

  LSymbol := FSymbolTable.Lookup(LIdent.Name);
  LVarPtr := FindNamedValue(LIdent.Name);
  if not Assigned(LVarPtr) then
    raise ECPCompilerError.Create('Code generation error: Unknown variable ' + LIdent.Name, ANode.Token.Line, ANode.Token.Column);

  if (LSymbol is TParameterSymbol) and (TParameterSymbol(LSymbol).Modifier = pmVar) then
  begin
    Result := LLVMBuildLoad2(FBuilder, LLVMPointerType(GetLLVMType(LSymbol.&Type, ANode.Token), 0), LVarPtr, 'var_param_addr_passthrough');
  end
  else
    Result := LVarPtr;
end;

procedure TCPIRGenerator.VisitProcedureCallNode(const ANode: TProcedureCallNode);
var
  LFunc: LLVMValueRef;
  LFuncSymbol: TFunctionSymbol;
  LArgs: TArray<LLVMValueRef>;
  LArgsPtr: PLLVMValueRef;
  I: Integer;
begin
  LFunc := LLVMGetNamedFunction(FModule, PAnsiChar(AnsiString(ANode.ProcName.Name)));
  LFuncSymbol := FSymbolTable.Lookup(ANode.ProcName.Name) as TFunctionSymbol;

  SetLength(LArgs, ANode.Arguments.Count);
  for I := 0 to ANode.Arguments.Count - 1 do
  begin
    if LFuncSymbol.Parameters[I].Modifier = pmVar then
      LArgs[I] := GetPointerTo(ANode.Arguments[I])
    else
      LArgs[I] := VisitExpression(ANode.Arguments[I]);
  end;

  if Length(LArgs) > 0 then
    LArgsPtr := @LArgs[0]
  else
    LArgsPtr := nil;

  LLVMBuildCall2(FBuilder, LLVMGlobalGetValueType(LFunc), LFunc, LArgsPtr, Length(LArgs), '');
end;

procedure TCPIRGenerator.VisitIfStatementNode(const ANode: TIfStatementNode);
var
  LCondValue, LFunc: LLVMValueRef;
  LThenBlock, LElseBlock, LMergeBlock: LLVMBasicBlockRef;
begin
  LCondValue := VisitExpression(ANode.Condition);
  LFunc := LLVMGetBasicBlockParent(LLVMGetInsertBlock(FBuilder));

  LThenBlock := LLVMAppendBasicBlockInContext(FContext, LFunc, 'then');
  LMergeBlock := LLVMAppendBasicBlockInContext(FContext, LFunc, 'ifcont');

  if Assigned(ANode.ElseStatement) then
  begin
    LElseBlock := LLVMAppendBasicBlockInContext(FContext, LFunc, 'else');
    LLVMBuildCondBr(FBuilder, LCondValue, LThenBlock, LElseBlock);
  end
  else
  begin
    LElseBlock := LMergeBlock;
    LLVMBuildCondBr(FBuilder, LCondValue, LThenBlock, LElseBlock);
  end;

  LLVMPositionBuilderAtEnd(FBuilder, LThenBlock);
  Visit(ANode.ThenStatement);
  if not Assigned(LLVMGetBasicBlockTerminator(LLVMGetInsertBlock(FBuilder))) then
    LLVMBuildBr(FBuilder, LMergeBlock);

  if Assigned(ANode.ElseStatement) then
  begin
    LLVMPositionBuilderAtEnd(FBuilder, LElseBlock);
    Visit(ANode.ElseStatement);
    if not Assigned(LLVMGetBasicBlockTerminator(LLVMGetInsertBlock(FBuilder))) then
      LLVMBuildBr(FBuilder, LMergeBlock);
  end;

  LLVMPositionBuilderAtEnd(FBuilder, LMergeBlock);
end;

procedure TCPIRGenerator.VisitWhileStatementNode(const ANode: TWhileStatementNode);
var
  LFunction: LLVMValueRef;
  LLoopHeaderBlock, LLoopBodyBlock, LAfterLoopBlock: LLVMBasicBlockRef;
  LCondValue: LLVMValueRef;
  LLoopContext: TLoopContext;
begin
  LFunction := LLVMGetBasicBlockParent(LLVMGetInsertBlock(FBuilder));

  LLoopHeaderBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'loop.header');
  LLoopBodyBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'loop.body');
  LAfterLoopBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'loop.after');

  LLoopContext.HeaderBlock := LLoopHeaderBlock;
  LLoopContext.ExitBlock := LAfterLoopBlock;
  FLoopContextStack.Push(LLoopContext);

  LLVMBuildBr(FBuilder, LLoopHeaderBlock);

  LLVMPositionBuilderAtEnd(FBuilder, LLoopHeaderBlock);
  LCondValue := VisitExpression(ANode.Condition);
  LLVMBuildCondBr(FBuilder, LCondValue, LLoopBodyBlock, LAfterLoopBlock);

  LLVMPositionBuilderAtEnd(FBuilder, LLoopBodyBlock);
  Visit(ANode.Body);
  LLVMBuildBr(FBuilder, LLoopHeaderBlock);

  FLoopContextStack.Pop;
  LLVMPositionBuilderAtEnd(FBuilder, LAfterLoopBlock);
end;

procedure TCPIRGenerator.VisitRepeatStatementNode(const ANode: TRepeatStatementNode);
var
  LFunction: LLVMValueRef;
  LLoopBodyBlock, LLoopCondBlock, LAfterLoopBlock: LLVMBasicBlockRef;
  LCondValue: LLVMValueRef;
  LStmt: TStatementNode;
  LLoopContext: TLoopContext;
begin
  LFunction := LLVMGetBasicBlockParent(LLVMGetInsertBlock(FBuilder));

  LLoopBodyBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'repeat.body');
  LLoopCondBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'repeat.cond');
  LAfterLoopBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'repeat.after');

  LLoopContext.HeaderBlock := LLoopCondBlock;
  LLoopContext.ExitBlock := LAfterLoopBlock;
  FLoopContextStack.Push(LLoopContext);

  LLVMBuildBr(FBuilder, LLoopBodyBlock);

  LLVMPositionBuilderAtEnd(FBuilder, LLoopBodyBlock);
  for LStmt in ANode.Statements do
    Visit(LStmt);
  LLVMBuildBr(FBuilder, LLoopCondBlock);

  LLVMPositionBuilderAtEnd(FBuilder, LLoopCondBlock);
  LCondValue := VisitExpression(ANode.Condition);
  LLVMBuildCondBr(FBuilder, LCondValue, LAfterLoopBlock, LLoopBodyBlock);

  FLoopContextStack.Pop;
  LLVMPositionBuilderAtEnd(FBuilder, LAfterLoopBlock);
end;

procedure TCPIRGenerator.VisitForStatementNode(const ANode: TForStatementNode);
var
  LFunction: LLVMValueRef;
  LLoopCondBlock, LLoopBodyBlock, LLoopIncBlock, LAfterLoopBlock: LLVMBasicBlockRef;
  LStartVal, LEndVal, LLoopVarPtr, LIncDecVal, LStepVal, LCond: LLVMValueRef;
  LComparePred: LLVMIntPredicate;
  LLoopContext: TLoopContext;
begin
  LFunction := LLVMGetBasicBlockParent(LLVMGetInsertBlock(FBuilder));

  LLoopVarPtr := FindNamedValue(ANode.LoopVariable.Name);
  if not Assigned(LLoopVarPtr) then
    raise ECPCompilerError.Create('IRGen Error: FOR loop variable not found: ' + ANode.LoopVariable.Name, ANode.Token.Line, ANode.Token.Column);

  LStartVal := VisitExpression(ANode.StartValue);
  LLVMBuildStore(FBuilder, LStartVal, LLoopVarPtr);

  LLoopCondBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'for.cond');
  LLoopBodyBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'for.body');
  LLoopIncBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'for.inc');
  LAfterLoopBlock := LLVMAppendBasicBlockInContext(FContext, LFunction, 'for.after');

  LLoopContext.HeaderBlock := LLoopIncBlock;
  LLoopContext.ExitBlock := LAfterLoopBlock;
  FLoopContextStack.Push(LLoopContext);

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
  LStepVal := LLVMConstInt(GetLLVMType(GetExpressionType(ANode.LoopVariable), ANode.LoopVariable.Token), 1, Ord(True));
  if ANode.Direction = fdTo then
    LIncDecVal := LLVMBuildNSWAdd(FBuilder, VisitIdentifierNode(ANode.LoopVariable), LStepVal, 'nextvar')
  else
    LIncDecVal := LLVMBuildNSWSub(FBuilder, VisitIdentifierNode(ANode.LoopVariable), LStepVal, 'nextvar');
  LLVMBuildStore(FBuilder, LIncDecVal, LLoopVarPtr);
  LLVMBuildBr(FBuilder, LLoopCondBlock);

  FLoopContextStack.Pop;
  LLVMPositionBuilderAtEnd(FBuilder, LAfterLoopBlock);
end;

procedure TCPIRGenerator.VisitBreakStatementNode(const ANode: TBreakStatementNode);
var
  LLoopContext: TLoopContext;
begin
  if FLoopContextStack.Count = 0 then
    raise ECPCompilerError.Create('Break statement outside of loop context.', ANode.Token.Line, ANode.Token.Column);
  LLoopContext := FLoopContextStack.Peek;
  LLVMBuildBr(FBuilder, LLoopContext.ExitBlock);
end;

procedure TCPIRGenerator.VisitContinueStatementNode(const ANode: TContinueStatementNode);
var
  LLoopContext: TLoopContext;
begin
  if FLoopContextStack.Count = 0 then
    raise ECPCompilerError.Create('Continue statement outside of loop context.', ANode.Token.Line, ANode.Token.Column);
  LLoopContext := FLoopContextStack.Peek;
  LLVMBuildBr(FBuilder, LLoopContext.HeaderBlock);
end;

procedure TCPIRGenerator.VisitExitStatementNode(const ANode: TExitStatementNode);
var
  LFuncSymbol: TFunctionSymbol;
  LResultAlloca, LLoadedResult: LLVMValueRef;
  LFuncName: PAnsiChar;
  LNameLen: NativeUInt;
begin
  if not Assigned(FCurrentFunction) then
  begin
    raise ECPCompilerError.Create('Exit statement outside of function or procedure', ANode.Token.Line, ANode.Token.Column);
  end;

  if FCurrentFunction = FMainFunction then
  begin
    LLVMBuildRet(FBuilder, LLVMConstInt(LLVMInt32TypeInContext(FContext), 0, Ord(False)));
    Exit;
  end;

  LFuncName := LLVMGetValueName2(FCurrentFunction, @LNameLen);
  LFuncSymbol := FSymbolTable.Lookup(string(LFuncName)) as TFunctionSymbol;

  if not Assigned(LFuncSymbol) then
    raise ECPCompilerError.Create('Internal IRGen Error: Could not find symbol for current function.', ANode.Token.Line, ANode.Token.Column);

  if LFuncSymbol.Kind = skProcedure then
  begin
    LLVMBuildRetVoid(FBuilder);
  end
  else
  begin
    LResultAlloca := FindNamedValue('Result');
    if not Assigned(LResultAlloca) then
      raise ECPCompilerError.Create('Internal IRGen Error: Could not find Result variable for function.', ANode.Token.Line, ANode.Token.Column);

    LLoadedResult := LLVMBuildLoad2(FBuilder, GetLLVMType(LFuncSymbol.ReturnType, ANode.Token), LResultAlloca, 'exit.ret');
    LLVMBuildRet(FBuilder, LLoadedResult);
  end;
end;

function TCPIRGenerator.VisitBinaryOpNode(const ANode: TBinaryOpNode): LLVMValueRef;
var
  LLeft, LRight, LPromotedLeft, LPromotedRight: LLVMValueRef;
  LResultType, LLeftType, LRightType, LCommonType: TTypeSymbol;
  LIsUnsigned, LIsFloat: Boolean;
begin
  Result := nil;

  LLeft := VisitExpression(ANode.Left);
  LRight := VisitExpression(ANode.Right);
  LLeftType := GetExpressionType(ANode.Left);
  LRightType := GetExpressionType(ANode.Right);
  LResultType := GetExpressionType(ANode);

  LIsFloat := IsFloatType(LLeftType) or IsFloatType(LRightType);

  if LIsFloat then
  begin
      if (IsFloatType(LLeftType) and SameText(LLeftType.Name, 'DOUBLE')) or
         (IsFloatType(LRightType) and SameText(LRightType.Name, 'DOUBLE')) then
          LCommonType := FSymbolTable.Lookup('DOUBLE') as TTypeSymbol
      else
          LCommonType := FSymbolTable.Lookup('SINGLE') as TTypeSymbol;
  end
  else
  begin
      if GetBitWidth(LLeftType) > GetBitWidth(LRightType) then
        LCommonType := LLeftType
      else
        LCommonType := LRightType;
  end;

  LPromotedLeft := CreateTypeCast(LLeft, LLeftType, LCommonType, ANode.Left.Token);
  LPromotedRight := CreateTypeCast(LRight, LRightType, LCommonType, ANode.Right.Token);

  case ANode.Operator of
    tkEqual, tkNotEqual, tkLessThan, tkLessEqual, tkGreaterThan, tkGreaterEqual:
    begin
      if LIsFloat then
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
      LPromotedLeft := CreateTypeCast(LLeft, LLeftType, LResultType, ANode.Left.Token);
      LPromotedRight := CreateTypeCast(LRight, LRightType, LResultType, ANode.Right.Token);

      if ANode.Operator in [tkAnd, tkOr] then
      begin
        if ANode.Operator = tkAnd then
          Result := LLVMBuildAnd(FBuilder, LPromotedLeft, LPromotedRight, 'andtmp')
        else
          Result := LLVMBuildOr(FBuilder, LPromotedLeft, LPromotedRight, 'ortmp');
      end
      else if IsFloatType(LResultType) then
      begin
        case ANode.Operator of
          tkPlus: Result := LLVMBuildFAdd(FBuilder, LPromotedLeft, LPromotedRight, 'faddtmp');
          tkMinus: Result := LLVMBuildFSub(FBuilder, LPromotedLeft, LPromotedRight, 'fsubtmp');
          tkAsterisk: Result := LLVMBuildFMul(FBuilder, LPromotedLeft, LPromotedRight, 'fmultmp');
          tkSlash: Result := LLVMBuildFDiv(FBuilder, LPromotedLeft, LPromotedRight, 'fdivtmp');
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
    raise ECPCompilerError.Create('Unsupported unary operator in IR Generation.', ANode.Token.Line, ANode.Token.Column);
  end;
end;

function TCPIRGenerator.VisitIdentifierNode(const ANode: TIdentifierNode): LLVMValueRef;
var
  LVarPtr, LLVMType: LLVMTypeRef;
  LTypeSymbol: TTypeSymbol;
  LSymbol: TCPSymbol;
begin
  LVarPtr := FindNamedValue(ANode.Name);
  LSymbol := FSymbolTable.Lookup(ANode.Name);

  if not Assigned(LVarPtr) then
    raise ECPCompilerError.Create('Code generation error: Unknown variable ' + ANode.Name, ANode.Token.Line, ANode.Token.Column);

  LTypeSymbol := GetExpressionType(ANode);
  LLVMType := GetLLVMType(LTypeSymbol, ANode.Token);

  if (LSymbol is TParameterSymbol) and (TParameterSymbol(LSymbol).Modifier = pmVar) then
  begin
    LVarPtr := LLVMBuildLoad2(FBuilder, LLVMPointerType(LLVMType, 0), LVarPtr, PAnsiChar(AnsiString(ANode.Name + '_addr')));
    Result := LLVMBuildLoad2(FBuilder, LLVMType, LVarPtr, PAnsiChar(AnsiString(ANode.Name + '_val')));
  end
  else
    Result := LLVMBuildLoad2(FBuilder, LLVMType, LVarPtr, PAnsiChar(AnsiString(ANode.Name + '_val')));
end;

function TCPIRGenerator.VisitFunctionCallNode(const ANode: TFunctionCallNode): LLVMValueRef;
var
  LFunc: LLVMValueRef;
  LFuncSymbol: TFunctionSymbol;
  LArgs: TArray<LLVMValueRef>;
  LArgsPtr: PLLVMValueRef;
  I: Integer;
begin
  LFunc := LLVMGetNamedFunction(FModule, PAnsiChar(AnsiString(ANode.FunctionName.Name)));
  LFuncSymbol := FSymbolTable.Lookup(ANode.FunctionName.Name) as TFunctionSymbol;

  SetLength(LArgs, ANode.Arguments.Count);
  for I := 0 to ANode.Arguments.Count - 1 do
  begin
    if LFuncSymbol.Parameters[I].Modifier = pmVar then
      LArgs[I] := GetPointerTo(ANode.Arguments[I])
    else
      LArgs[I] := VisitExpression(ANode.Arguments[I]);
  end;

  if Length(LArgs) > 0 then
    LArgsPtr := @LArgs[0]
  else
    LArgsPtr := nil;

  Result := LLVMBuildCall2(FBuilder, LLVMGlobalGetValueType(LFunc), LFunc, LArgsPtr, Length(LArgs), PAnsiChar(AnsiString(ANode.FunctionName.Name + '_call')));
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
