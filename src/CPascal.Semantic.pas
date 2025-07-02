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

unit CPascal.Semantic;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  CPascal.AST,
  CPascal.Lexer,
  CPascal.Common;

type
  { Forward Declarations }
  TCPSymbol = class;
  TTypeSymbol = class;
  TVariableSymbol = class;
  TParameterSymbol = class;
  TFunctionSymbol = class;
  TCPSymbolTable = class;
  TCPSemanticAnalyzer = class;

  { The kind of a symbol }
  TCPSymbolKind = (skUnknown, skBuiltinType, skVariable, skFunction, skProcedure, skParameter);

  { Base class for all symbols stored in the symbol table }
  TCPSymbol = class
  public
    Name: string;
    Kind: TCPSymbolKind;
    &Type: TTypeSymbol;
    constructor Create(const AName: string; const AKind: TCPSymbolKind); virtual;
    destructor Destroy; override;
  end;

  { Represents a type symbol }
  TTypeSymbol = class(TCPSymbol)
  end;

  { Represents a variable symbol }
  TVariableSymbol = class(TCPSymbol)
  public
  end;

  { Represents a parameter symbol }
  TParameterSymbol = class(TVariableSymbol)
  public
    Modifier: TParamModifier;
    constructor Create(const AName: string; const AKind: TCPSymbolKind); override;
  end;

  { Represents a function or procedure symbol }
  TFunctionSymbol = class(TCPSymbol)
  public
    ReturnType: TTypeSymbol;
    Parameters: TObjectList<TParameterSymbol>;
    CallingConvention: TCallingConvention; // MODIFIED
    IsExternal: Boolean;                  // MODIFIED
    constructor Create(const AName: string; const AKind: TCPSymbolKind); override;
    destructor Destroy; override;
  end;

  { Manages scopes and the symbols within them }
  TCPSymbolTable = class
  private
    FScopes: TStack<TDictionary<string, TCPSymbol>>;
    procedure InitBuiltins;
  public
    constructor Create();
    destructor Destroy; override;

    procedure EnterScope();
    procedure LeaveScope();

    function Declare(const ASymbol: TCPSymbol): Boolean;
    function Lookup(const AName: string; const ACurrentScopeOnly: Boolean = False): TCPSymbol;
  end;

  { The Semantic Analyzer class (implemented as a visitor) }
  TCPSemanticAnalyzer = class
  public
    FSymbolTable: TCPSymbolTable;
  private
    FWarnings: TList<TCPCompilerWarning>;
    FLoopDepth: Integer;
    FCurrentFunction: TFunctionSymbol;
    function GetBitWidth(const AType: TTypeSymbol): Integer;
    procedure AddWarning(const AMessage: string; const AToken: TCPToken);

    function IsIntegerType(const AType: TTypeSymbol): Boolean;
    function IsFloatType(const AType: TTypeSymbol): Boolean;
    function IsNumericType(const AType: TTypeSymbol): Boolean;
    function IsLValue(const ANode: TExpressionNode): Boolean;

    procedure Visit(const ANode: TCPASTNode);
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
    function VisitExpression(const ANode: TExpressionNode): TTypeSymbol;
    function VisitBinaryOpNode(const ANode: TBinaryOpNode): TTypeSymbol;
    function VisitUnaryOpNode(const ANode: TUnaryOpNode): TTypeSymbol;
    function VisitIdentifierNode(const ANode: TIdentifierNode): TTypeSymbol;
    function VisitFunctionCallNode(const ANode: TFunctionCallNode): TTypeSymbol;
    function VisitIntegerLiteralNode(const ANode: TIntegerLiteralNode): TTypeSymbol;
    function VisitRealLiteralNode(const ANode: TRealLiteralNode): TTypeSymbol;
  public
    constructor Create(const ASymbolTable: TCPSymbolTable);
    destructor Destroy; override;

    procedure Check(const ARootNode: TCPASTNode);
    property Warnings: TList<TCPCompilerWarning> read FWarnings;
  end;

implementation

{ TCPSymbol }
constructor TCPSymbol.Create(const AName: string; const AKind: TCPSymbolKind);
begin
  inherited Create();
  Self.Name := AName;
  Self.Kind := AKind;
  Self.&Type := nil;
end;

destructor TCPSymbol.Destroy;
begin
  inherited;
end;

{ TVariableSymbol }

{ TParameterSymbol }
constructor TParameterSymbol.Create(const AName: string; const AKind: TCPSymbolKind);
begin
  inherited Create(AName, skParameter);
end;

{ TFunctionSymbol }
constructor TFunctionSymbol.Create(const AName: string; const AKind: TCPSymbolKind);
begin
  inherited Create(AName, AKind);
  ReturnType := nil;
  Parameters := TObjectList<TParameterSymbol>.Create(True);
  CallingConvention := ccDefault;
  IsExternal := False;
end;

destructor TFunctionSymbol.Destroy;
begin
  Parameters.Free;
  inherited;
end;

{ TCPSymbolTable }
constructor TCPSymbolTable.Create;
begin
  inherited Create();
  FScopes := TStack<TDictionary<string, TCPSymbol>>.Create;
  InitBuiltins();
end;

destructor TCPSymbolTable.Destroy;
begin
  while FScopes.Count > 0 do
    LeaveScope();
  FScopes.Free;
  inherited;
end;

procedure TCPSymbolTable.InitBuiltins;
var
  LGlobalScope: TDictionary<string, TCPSymbol>;
begin
  LGlobalScope := TDictionary<string, TCPSymbol>.Create;
  FScopes.Push(LGlobalScope);
  Declare(TTypeSymbol.Create('INT8', skBuiltinType));
  Declare(TTypeSymbol.Create('UINT8', skBuiltinType));
  Declare(TTypeSymbol.Create('INT16', skBuiltinType));
  Declare(TTypeSymbol.Create('UINT16', skBuiltinType));
  Declare(TTypeSymbol.Create('INT32', skBuiltinType));
  Declare(TTypeSymbol.Create('UINT32', skBuiltinType));
  Declare(TTypeSymbol.Create('INT64', skBuiltinType));
  Declare(TTypeSymbol.Create('UINT64', skBuiltinType));
  Declare(TTypeSymbol.Create('SINGLE', skBuiltinType));
  Declare(TTypeSymbol.Create('DOUBLE', skBuiltinType));
  Declare(TTypeSymbol.Create('BOOLEAN', skBuiltinType));
  Declare(TTypeSymbol.Create('CHAR', skBuiltinType));
  Declare(TTypeSymbol.Create('POINTER', skBuiltinType));
end;

procedure TCPSymbolTable.EnterScope;
begin
  FScopes.Push(TDictionary<string, TCPSymbol>.Create);
end;

procedure TCPSymbolTable.LeaveScope;
var
  LOldScope: TDictionary<string, TCPSymbol>;
  LSymbol: TCPSymbol;
begin
  LOldScope := FScopes.Pop;
  for LSymbol in LOldScope.Values do
  begin
    if LSymbol.Kind <> skParameter then
      LSymbol.Free;
  end;
  LOldScope.Free;
end;

function TCPSymbolTable.Declare(const ASymbol: TCPSymbol): Boolean;
begin
  if Lookup(ASymbol.Name, True) <> nil then
    Result := False
  else
    Result := FScopes.Peek.TryAdd(ASymbol.Name.ToUpper, ASymbol);
end;

function TCPSymbolTable.Lookup(const AName: string; const ACurrentScopeOnly: Boolean): TCPSymbol;
var
  LUpperName: string;
  LScope: TDictionary<string, TCPSymbol>;
begin
  Result := nil;
  LUpperName := AName.ToUpper;

  if ACurrentScopeOnly then
  begin
    FScopes.Peek.TryGetValue(LUpperName, Result);
  end
  else
  begin
    for LScope in FScopes do
    begin
      if LScope.TryGetValue(LUpperName, Result) then
        Exit;
    end;
  end;
end;

{ TCPSemanticAnalyzer }

constructor TCPSemanticAnalyzer.Create(const ASymbolTable: TCPSymbolTable);
begin
  inherited Create();
  FSymbolTable := ASymbolTable;
  FWarnings := TList<TCPCompilerWarning>.Create();
  FLoopDepth := 0;
  FCurrentFunction := nil;
end;

destructor TCPSemanticAnalyzer.Destroy;
begin
  FWarnings.Free;
  inherited;
end;

procedure TCPSemanticAnalyzer.AddWarning(const AMessage: string; const AToken: TCPToken);
var
  LWarning: TCPCompilerWarning;
begin
  LWarning.Message := AMessage;
  LWarning.Line := AToken.Line;
  LWarning.Column := AToken.Column;
  FWarnings.Add(LWarning);
end;

function TCPSemanticAnalyzer.GetBitWidth(const AType: TTypeSymbol): Integer;
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

function TCPSemanticAnalyzer.IsFloatType(const AType: TTypeSymbol): Boolean;
begin
  Result := Assigned(AType) and (SameText(AType.Name, 'SINGLE') or SameText(AType.Name, 'DOUBLE'));
end;

function TCPSemanticAnalyzer.IsIntegerType(const AType: TTypeSymbol): Boolean;
begin
  Result := Assigned(AType) and (SameText(Copy(AType.Name, 1, 3), 'INT') or
            SameText(Copy(AType.Name, 1, 4), 'UINT'));
end;

function TCPSemanticAnalyzer.IsNumericType(const AType: TTypeSymbol): Boolean;
begin
  Result := IsIntegerType(AType) or IsFloatType(AType);
end;

function TCPSemanticAnalyzer.IsLValue(const ANode: TExpressionNode): Boolean;
begin
  Result := ANode is TIdentifierNode;
end;

procedure TCPSemanticAnalyzer.Check(const ARootNode: TCPASTNode);
begin
  Visit(ARootNode);
end;

procedure TCPSemanticAnalyzer.Visit(const ANode: TCPASTNode);
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
    raise ECPCompilerError.Create('Unsupported AST node: ' + ANode.ClassName, ANode.Token.Line, ANode.Token.Column);
end;

procedure TCPSemanticAnalyzer.VisitProgramNode(const ANode: TProgramNode);
var
  LDecl: TDeclarationNode;
begin
  FSymbolTable.EnterScope();

  for LDecl in ANode.Declarations do
    Visit(LDecl);

  Visit(ANode.CompoundStatement);
end;

procedure TCPSemanticAnalyzer.VisitVarSectionNode(const ANode: TVarSectionNode);
var
  LDeclNode: TVarDeclNode;
  LIdentNode: TIdentifierNode;
  LTypeSymbol: TTypeSymbol;
  LSymbolLookupResult: TCPSymbol;
  LVarSymbol: TVariableSymbol;
begin
  for LDeclNode in ANode.Declarations do
  begin
    LSymbolLookupResult := FSymbolTable.Lookup(TTypeNameNode(LDeclNode.TypeSpec).Identifier.Name);
    if not Assigned(LSymbolLookupResult) then
      raise ECPCompilerError.Create(Format('Type "%s" not found', [TTypeNameNode(LDeclNode.TypeSpec).Identifier.Name]), LDeclNode.Token.Line, LDeclNode.Token.Column);
    if not (LSymbolLookupResult is TTypeSymbol) then
      raise ECPCompilerError.Create(Format('Symbol "%s" is not a type', [TTypeNameNode(LDeclNode.TypeSpec).Identifier.Name]), LDeclNode.Token.Line, LDeclNode.Token.Column);
    LTypeSymbol := LSymbolLookupResult as TTypeSymbol;

    for LIdentNode in LDeclNode.Identifiers do
    begin
      LVarSymbol := TVariableSymbol.Create(LIdentNode.Name, skVariable);
      LVarSymbol.&Type := LTypeSymbol;
      if not FSymbolTable.Declare(LVarSymbol) then
        raise ECPCompilerError.Create(Format('Duplicate identifier in same scope: %s', [LIdentNode.Name]), LIdentNode.Token.Line, LIdentNode.Token.Column);
    end;
  end;
end;

procedure TCPSemanticAnalyzer.VisitFunctionDeclNode(const ANode: TFunctionDeclNode);
var
  LFuncSymbol: TFunctionSymbol;
  LKind: TCPSymbolKind;
  LDecl: TDeclarationNode;
  LResultVar: TVariableSymbol;
  LParamNode: TParameterNode;
  LParamIdent: TIdentifierNode;
  LParamSymbol: TParameterSymbol;
  LParamType: TTypeSymbol;
begin
  if ANode.IsProcedure then
    LKind := skProcedure
  else
    LKind := skFunction;

  LFuncSymbol := TFunctionSymbol.Create(ANode.Name.Name, LKind);
  LFuncSymbol.IsExternal := ANode.IsExternal;
  LFuncSymbol.CallingConvention := ANode.CallingConvention;

  for LParamNode in ANode.Parameters do
  begin
    LParamType := FSymbolTable.Lookup(TTypeNameNode(LParamNode.TypeSpec).Identifier.Name) as TTypeSymbol;
    if not Assigned(LParamType) then
      raise ECPCompilerError.Create('Unknown parameter type ' + TTypeNameNode(LParamNode.TypeSpec).Identifier.Name, LParamNode.TypeSpec.Token.Line, LParamNode.TypeSpec.Token.Column);

    for LParamIdent in LParamNode.Identifiers do
    begin
      LParamSymbol := TParameterSymbol.Create(LParamIdent.Name, skParameter);
      LParamSymbol.Modifier := LParamNode.Modifier;
      LParamSymbol.&Type := LParamType;
      LFuncSymbol.Parameters.Add(LParamSymbol);
    end;
  end;

  if not ANode.IsProcedure then
  begin
    LFuncSymbol.ReturnType := FSymbolTable.Lookup(TTypeNameNode(ANode.ReturnType).Identifier.Name) as TTypeSymbol;
    if not Assigned(LFuncSymbol.ReturnType) then
       raise ECPCompilerError.Create('Unknown return type ' + TTypeNameNode(ANode.ReturnType).Identifier.Name, ANode.ReturnType.Token.Line, ANode.ReturnType.Token.Column);
  end;

  if not FSymbolTable.Declare(LFuncSymbol) then
    raise ECPCompilerError.Create('Duplicate identifier: ' + ANode.Name.Name, ANode.Name.Token.Line, ANode.Name.Token.Column);

  // An external function does not have a body to analyze
  if ANode.IsExternal then
    Exit;

  FCurrentFunction := LFuncSymbol;
  FSymbolTable.EnterScope();
  try
    for LParamSymbol in LFuncSymbol.Parameters do
    begin
      if not FSymbolTable.Declare(LParamSymbol) then
        raise ECPCompilerError.Create('Duplicate parameter name: ' + LParamSymbol.Name, ANode.Name.Token.Line, ANode.Name.Token.Column);
    end;

    if not ANode.IsProcedure then
    begin
      LResultVar := TVariableSymbol.Create('Result', skVariable);
      LResultVar.&Type := LFuncSymbol.ReturnType;
      FSymbolTable.Declare(LResultVar);
    end;

    for LDecl in ANode.Declarations do
      Visit(LDecl);

    Visit(ANode.Body);
  finally
    FSymbolTable.LeaveScope();
    FCurrentFunction := nil;
  end;
end;

procedure TCPSemanticAnalyzer.VisitCompoundStatementNode(const ANode: TCompoundStatementNode);
var
  LStmt: TStatementNode;
begin
  for LStmt in ANode.Statements do
    Visit(LStmt);
end;

procedure TCPSemanticAnalyzer.VisitAssignmentNode(const ANode: TAssignmentNode);
var
  LVarType, LExprType: TTypeSymbol;
  LIsValid: Boolean;
  LVarIdent: TIdentifierNode;
  LSymbol: TCPSymbol;
begin
  if not (ANode.Variable is TIdentifierNode) then
    raise ECPCompilerError.Create('Assignment target must be a variable or function result', ANode.Token.Line, ANode.Token.Column);

  LVarIdent := ANode.Variable as TIdentifierNode;

  LSymbol := FSymbolTable.Lookup(LVarIdent.Name);
  if (LSymbol is TParameterSymbol) and (TParameterSymbol(LSymbol).Modifier = pmConst) then
    raise ECPCompilerError.Create(Format('Cannot assign to a const parameter "%s"', [LVarIdent.Name]), ANode.Token.Line, ANode.Token.Column);

  LVarType := VisitExpression(ANode.Variable);
  LExprType := VisitExpression(ANode.Expression);

  if SameText(LVarIdent.Name, 'Result') then
  begin
    if not Assigned(FCurrentFunction) then
      raise ECPCompilerError.Create('Assignment to "Result" is only valid inside a function', ANode.Token.Line, ANode.Token.Column);
    if FCurrentFunction.Kind = skProcedure then
      raise ECPCompilerError.Create('"Result" is not valid in a procedure', ANode.Token.Line, ANode.Token.Column);
  end;

  LIsValid := LVarType = LExprType;

  if not LIsValid then
  begin
    if IsIntegerType(LVarType) and IsIntegerType(LExprType) then
    begin
      LIsValid := True;
      if GetBitWidth(LExprType) > GetBitWidth(LVarType) then
        AddWarning(Format('Possible data loss assigning %s to %s', [LExprType.Name, LVarType.Name]), ANode.Token);
    end
    else if IsFloatType(LVarType) and IsFloatType(LExprType) then
    begin
      LIsValid := True;
      if SameText(LVarType.Name, 'SINGLE') and SameText(LExprType.Name, 'DOUBLE') then
        AddWarning('Possible data loss assigning DOUBLE to SINGLE', ANode.Token);
    end
    else if IsFloatType(LVarType) and IsIntegerType(LExprType) then
    begin
      LIsValid := True;
    end;
  end;

  if not LIsValid then
    raise ECPCompilerError.Create(Format('Type mismatch: Cannot assign %s to %s', [LExprType.Name, LVarType.Name]), ANode.Token.Line, ANode.Token.Column);
end;

procedure TCPSemanticAnalyzer.VisitProcedureCallNode(const ANode: TProcedureCallNode);
var
  LSymbol: TCPSymbol;
  LFuncSymbol: TFunctionSymbol;
  LArgNode: TExpressionNode;
  LParamSymbol: TParameterSymbol;
  I: Integer;
begin
  LSymbol := FSymbolTable.Lookup(ANode.ProcName.Name);
  if not Assigned(LSymbol) then
    raise ECPCompilerError.Create(Format('Undeclared identifier: "%s"', [ANode.ProcName.Name]), ANode.Token.Line, ANode.Token.Column);

  if LSymbol.Kind <> skProcedure then
    raise ECPCompilerError.Create(Format('"%s" is not a procedure', [ANode.ProcName.Name]), ANode.Token.Line, ANode.Token.Column);

  LFuncSymbol := LSymbol as TFunctionSymbol;
  if LFuncSymbol.Parameters.Count <> ANode.Arguments.Count then
    raise ECPCompilerError.Create(Format('Incorrect number of arguments for "%s"', [ANode.ProcName.Name]), ANode.Token.Line, ANode.Token.Column);

  for I := 0 to ANode.Arguments.Count - 1 do
  begin
    LArgNode := ANode.Arguments[I];
    LParamSymbol := LFuncSymbol.Parameters[I];
    if (LParamSymbol.Modifier = pmVar) and not IsLValue(LArgNode) then
      raise ECPCompilerError.Create(Format('Argument %d must be a variable for VAR parameter "%s"', [I + 1, LParamSymbol.Name]), LArgNode.Token.Line, LArgNode.Token.Column);
  end;
end;

procedure TCPSemanticAnalyzer.VisitIfStatementNode(const ANode: TIfStatementNode);
var
  LConditionType: TTypeSymbol;
begin
  LConditionType := VisitExpression(ANode.Condition);
  if not SameText(LConditionType.Name, 'BOOLEAN') then
    raise ECPCompilerError.Create('IF condition must be a Boolean expression', ANode.Condition.Token.Line, ANode.Condition.Token.Column);

  Visit(ANode.ThenStatement);
  if Assigned(ANode.ElseStatement) then
    Visit(ANode.ElseStatement);
end;

procedure TCPSemanticAnalyzer.VisitWhileStatementNode(const ANode: TWhileStatementNode);
var
  LConditionType: TTypeSymbol;
begin
  LConditionType := VisitExpression(ANode.Condition);
  if not SameText(LConditionType.Name, 'BOOLEAN') then
    raise ECPCompilerError.Create('WHILE condition must be a Boolean expression', ANode.Condition.Token.Line, ANode.Condition.Token.Column);

  Inc(FLoopDepth);
  try
    Visit(ANode.Body);
  finally
    Dec(FLoopDepth);
  end;
end;

procedure TCPSemanticAnalyzer.VisitRepeatStatementNode(const ANode: TRepeatStatementNode);
var
  LConditionType: TTypeSymbol;
  LStmt: TStatementNode;
begin
  Inc(FLoopDepth);
  try
    for LStmt in ANode.Statements do
      Visit(LStmt);
  finally
    Dec(FLoopDepth);
  end;

  LConditionType := VisitExpression(ANode.Condition);
  if not SameText(LConditionType.Name, 'BOOLEAN') then
    raise ECPCompilerError.Create('UNTIL condition must be a Boolean expression', ANode.Condition.Token.Line, ANode.Condition.Token.Column);
end;

procedure TCPSemanticAnalyzer.VisitForStatementNode(const ANode: TForStatementNode);
var
  LLoopVarSymbol: TCPSymbol;
  LStartType, LEndType: TTypeSymbol;
begin
  LLoopVarSymbol := FSymbolTable.Lookup(ANode.LoopVariable.Name);
  if not Assigned(LLoopVarSymbol) then
    raise ECPCompilerError.Create(Format('FOR loop control variable "%s" must be declared in an enclosing scope', [ANode.LoopVariable.Name]), ANode.LoopVariable.Token.Line, ANode.LoopVariable.Token.Column);

  if not IsIntegerType(LLoopVarSymbol.&Type) then
    raise ECPCompilerError.Create(Format('FOR loop control variable "%s" must be an integer type', [ANode.LoopVariable.Name]), ANode.LoopVariable.Token.Line, ANode.LoopVariable.Token.Column);

  LStartType := VisitExpression(ANode.StartValue);
  LEndType := VisitExpression(ANode.EndValue);

  if not IsIntegerType(LStartType) or not IsIntegerType(LEndType) then
    raise ECPCompilerError.Create('FOR loop bounds must be Integer expressions', ANode.Token.Line, ANode.Token.Column);

  Inc(FLoopDepth);
  try
    Visit(ANode.Body);
  finally
    Dec(FLoopDepth);
  end;
end;

procedure TCPSemanticAnalyzer.VisitBreakStatementNode(const ANode: TBreakStatementNode);
begin
  if FLoopDepth <= 0 then
    raise ECPCompilerError.Create('Break statement not allowed outside of a loop', ANode.Token.Line, ANode.Token.Column);
end;

procedure TCPSemanticAnalyzer.VisitContinueStatementNode(const ANode: TContinueStatementNode);
begin
  if FLoopDepth <= 0 then
    raise ECPCompilerError.Create('Continue statement not allowed outside of a loop', ANode.Token.Line, ANode.Token.Column);
end;

procedure TCPSemanticAnalyzer.VisitExitStatementNode(const ANode: TExitStatementNode);
begin
  if not Assigned(FCurrentFunction) then
    raise ECPCompilerError.Create('Exit statement not allowed outside of a function or procedure', ANode.Token.Line, ANode.Token.Column);
end;


function TCPSemanticAnalyzer.VisitExpression(const ANode: TExpressionNode): TTypeSymbol;
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
    raise ECPCompilerError.Create('Unsupported expression node: ' + ANode.ClassName, ANode.Token.Line, ANode.Token.Column);
end;


function TCPSemanticAnalyzer.VisitBinaryOpNode(const ANode: TBinaryOpNode): TTypeSymbol;
var
  LLeftType, LRightType: TTypeSymbol;
  LBooleanSymbol: TCPSymbol;
begin
  LLeftType := VisitExpression(ANode.Left);
  LRightType := VisitExpression(ANode.Right);

  case ANode.Operator of
    tkAnd, tkOr:
      begin
        if not SameText(LLeftType.Name, 'BOOLEAN') or not SameText(LRightType.Name, 'BOOLEAN') then
          raise ECPCompilerError.Create('Both operands for AND/OR must be Boolean', ANode.Token.Line, ANode.Token.Column);
        Result := LLeftType;
      end;
    tkEqual, tkNotEqual, tkLessThan, tkLessEqual, tkGreaterThan, tkGreaterEqual:
    begin
      if (not IsNumericType(LLeftType)) or (not IsNumericType(LRightType)) then
        raise ECPCompilerError.Create('Relational operators can only be used on numeric types', ANode.Token.Line, ANode.Token.Column);
      LBooleanSymbol := FSymbolTable.Lookup('BOOLEAN');
      if not Assigned(LBooleanSymbol) then
        raise ECPCompilerError.Create('Internal Error: Boolean type not found.', ANode.Token.Line, ANode.Token.Column);
      Result := LBooleanSymbol as TTypeSymbol;
    end;
    tkPlus, tkMinus, tkAsterisk, tkSlash:
    begin
      if (not IsNumericType(LLeftType)) or (not IsNumericType(LRightType)) then
        raise ECPCompilerError.Create('Arithmetic operators can only be used on numeric types', ANode.Token.Line, ANode.Token.Column);

      if IsFloatType(LLeftType) or IsFloatType(LRightType) then
      begin
        if SameText(LLeftType.Name, 'DOUBLE') or SameText(LRightType.Name, 'DOUBLE') then
          Result := FSymbolTable.Lookup('DOUBLE') as TTypeSymbol
        else
          Result := FSymbolTable.Lookup('SINGLE') as TTypeSymbol;
      end
      else if IsIntegerType(LLeftType) and IsIntegerType(LRightType) then
      begin
        if GetBitWidth(LLeftType) >= GetBitWidth(LRightType) then
          Result := LLeftType
        else
          Result := LRightType;
      end
      else
      begin
        raise ECPCompilerError.Create('Internal Error: Could not determine result type for arithmetic operation.', ANode.Token.Line, ANode.Token.Column);
      end;
    end
  else
    raise ECPCompilerError.Create('Unsupported binary operator', ANode.Token.Line, ANode.Token.Column);
  end;
end;

function TCPSemanticAnalyzer.VisitUnaryOpNode(const ANode: TUnaryOpNode): TTypeSymbol;
begin
  Result := VisitExpression(ANode.Operand);
  if not IsNumericType(Result) then
    raise ECPCompilerError.Create('Unary +/- can only be used on numeric types', ANode.Token.Line, ANode.Token.Column);
end;

function TCPSemanticAnalyzer.VisitIdentifierNode(const ANode: TIdentifierNode): TTypeSymbol;
var
  LSymbol: TCPSymbol;
begin
  LSymbol := FSymbolTable.Lookup(ANode.Name);
  if not Assigned(LSymbol) then
    raise ECPCompilerError.Create(Format('Undeclared identifier "%s"', [ANode.Name]), ANode.Token.Line, ANode.Token.Column);
  if not(LSymbol.Kind in [skVariable, skParameter]) then
    raise ECPCompilerError.Create(Format('"%s" is not a variable or parameter', [ANode.Name]), ANode.Token.Line, ANode.Token.Column);

  Result := LSymbol.&Type;
end;

function TCPSemanticAnalyzer.VisitFunctionCallNode(const ANode: TFunctionCallNode): TTypeSymbol;
var
  LSymbol: TCPSymbol;
  LFuncSymbol: TFunctionSymbol;
  LArgNode: TExpressionNode;
  LParamSymbol: TParameterSymbol;
  I: Integer;
begin
  LSymbol := FSymbolTable.Lookup(ANode.FunctionName.Name);
  if not Assigned(LSymbol) then
    raise ECPCompilerError.Create(Format('Undeclared identifier: "%s"', [ANode.FunctionName.Name]), ANode.Token.Line, ANode.Token.Column);

  if LSymbol.Kind <> skFunction then
    raise ECPCompilerError.Create(Format('"%s" is not a function', [ANode.FunctionName.Name]), ANode.Token.Line, ANode.Token.Column);

  LFuncSymbol := LSymbol as TFunctionSymbol;

  if LFuncSymbol.Parameters.Count <> ANode.Arguments.Count then
    raise ECPCompilerError.Create(Format('Incorrect number of arguments for "%s"', [ANode.FunctionName.Name]), ANode.Token.Line, ANode.Token.Column);

  for I := 0 to ANode.Arguments.Count - 1 do
  begin
    LArgNode := ANode.Arguments[I];
    LParamSymbol := LFuncSymbol.Parameters[I];
    if (LParamSymbol.Modifier = pmVar) and not IsLValue(LArgNode) then
      raise ECPCompilerError.Create(Format('Argument %d must be a variable for VAR parameter "%s"', [I + 1, LParamSymbol.Name]), LArgNode.Token.Line, LArgNode.Token.Column);
  end;

  Result := LFuncSymbol.ReturnType;
end;

function TCPSemanticAnalyzer.VisitIntegerLiteralNode(const ANode: TIntegerLiteralNode): TTypeSymbol;
var
  LSymbol: TCPSymbol;
begin
  LSymbol := FSymbolTable.Lookup('INT32');
  Result := LSymbol as TTypeSymbol;
end;

function TCPSemanticAnalyzer.VisitRealLiteralNode(const ANode: TRealLiteralNode): TTypeSymbol;
var
  LSymbol: TCPSymbol;
begin
  LSymbol := FSymbolTable.Lookup('DOUBLE');
  Result := LSymbol as TTypeSymbol;
end;

end.
