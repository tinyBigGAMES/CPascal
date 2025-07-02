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

unit CPascal.AST;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  CPascal.Lexer;

type
  { Forward declarations for node types }
  TCPASTNode = class;
  TExpressionNode = class;
  TStatementNode = class;
  TDeclarationNode = class;
  TTypeSpecifierNode = class;
  TIdentifierNode = class;

  { NEW: Enum for 'for' loop direction }
  TForDirection = (fdTo, fdDownTo);

  { Base class for all AST nodes }
  TCPASTNode = class
  public
    Token: TCPToken;
    constructor Create(const AToken: TCPToken);
    destructor Destroy; override;
    function ToString: string; override; abstract;
  end;

  { Base class for all declaration nodes }
  TDeclarationNode = class(TCPASTNode)
  end;

  { Base class for all expression nodes }
  TExpressionNode = class(TCPASTNode)
  end;

  { Represents a literal integer value }
  TIntegerLiteralNode = class(TExpressionNode)
  public
    Value: Int64;
    function ToString: string; override;
  end;

  { Represents a literal real (floating-point) value }
  TRealLiteralNode = class(TExpressionNode)
  public
    Value: Double;
    function ToString: string; override;
  end;

  { Represents a literal string value }
  TStringLiteralNode = class(TExpressionNode)
  public
    Value: string;
    function ToString: string; override;
  end;

  { Represents an identifier (e.g., a variable or function name) }
  TIdentifierNode = class(TExpressionNode)
  public
    Name: string;
    function ToString: string; override;
  end;

  { Represents a binary operation (e.g., A + B) }
  TBinaryOpNode = class(TExpressionNode)
  public
    Left: TExpressionNode;
    Operator: TCPTokenKind;
    Right: TExpressionNode;
    constructor Create(const AToken: TCPToken; const ALeft, ARight: TExpressionNode);
    destructor Destroy; override;
    function ToString: string; override;
  end;

  { Represents a unary operation (e.g., -A) }
  TUnaryOpNode = class(TExpressionNode)
  public
    Operator: TCPTokenKind;
    Operand: TExpressionNode;
    constructor Create(const AToken: TCPToken; const AOperand: TExpressionNode);
    destructor Destroy; override;
    function ToString: string; override;
  end;

  { Represents a function call }
  TFunctionCallNode = class(TExpressionNode)
  public
    FunctionName: TIdentifierNode;
    Arguments: TObjectList<TExpressionNode>;
    constructor Create(const AToken: TCPToken; const AName: TIdentifierNode);
    destructor Destroy; override;
    function ToString: string; override;
  end;

  { Base class for all statement nodes }
  TStatementNode = class(TCPASTNode)
  end;

  { Represents a block of statements: begin ... end }
  TCompoundStatementNode = class(TStatementNode)
  public
    Statements: TObjectList<TStatementNode>;
    constructor Create(const AToken: TCPToken);
    destructor Destroy; override;
    function ToString: string; override;
  end;

  { Represents an assignment statement (e.g., X := Y) }
  TAssignmentNode = class(TStatementNode)
  public
    Variable: TExpressionNode;
    Expression: TExpressionNode;
    constructor Create(const AToken: TCPToken; const AVariable, AExpression: TExpressionNode);
    destructor Destroy; override;
    function ToString: string; override;
  end;

  { Represents an if-then-else statement }
  TIfStatementNode = class(TStatementNode)
  public
    Condition: TExpressionNode;
    ThenStatement: TStatementNode;
    ElseStatement: TStatementNode; // Can be nil
    constructor Create(const AToken: TCPToken; const ACondition: TExpressionNode; const AThenStmt: TStatementNode; const AElseStmt: TStatementNode);
    destructor Destroy; override;
    function ToString: string; override;
  end;

  { Represents a while-do statement }
  TWhileStatementNode = class(TStatementNode)
  public
    Condition: TExpressionNode;
    Body: TStatementNode;
    constructor Create(const AToken: TCPToken; const ACondition: TExpressionNode; const ABody: TStatementNode);
    destructor Destroy; override;
    function ToString: string; override;
  end;

  { Represents a repeat..until statement }
  TRepeatStatementNode = class(TStatementNode)
  public
    Statements: TObjectList<TStatementNode>;
    Condition: TExpressionNode;
    constructor Create(const AToken: TCPToken);
    destructor Destroy; override;
    function ToString: string; override;
  end;

  { NEW: Represents a for loop statement }
  TForStatementNode = class(TStatementNode)
  public
    LoopVariable: TIdentifierNode;
    StartValue: TExpressionNode;
    EndValue: TExpressionNode;
    Direction: TForDirection;
    Body: TStatementNode;
    constructor Create(const AToken: TCPToken; const ALoopVar: TIdentifierNode; const AStart, AEnd: TExpressionNode; const ADir: TForDirection; const ABody: TStatementNode);
    destructor Destroy; override;
    function ToString: string; override;
  end;

  { Represents a variable declaration }
  TVarDeclNode = class(TDeclarationNode)
  public
    Identifiers: TObjectList<TIdentifierNode>;
    TypeSpec: TTypeSpecifierNode;
    constructor Create(const AToken: TCPToken);
    destructor Destroy; override;
    function ToString: string; override;
  end;

  { Represents a section of variable declarations }
  TVarSectionNode = class(TDeclarationNode)
  public
    Declarations: TObjectList<TVarDeclNode>;
     constructor Create(const AToken: TCPToken);
    destructor Destroy; override;
    function ToString: string; override;
  end;

  { Base for type specifiers }
  TTypeSpecifierNode = class(TCPASTNode)
  end;

  { Represents a type specified by an identifier (e.g., Int32) }
  TTypeNameNode = class(TTypeSpecifierNode)
  public
    Identifier: TIdentifierNode;
    constructor Create(const AToken: TCPToken; const AIdentifier: TIdentifierNode);
    destructor Destroy; override;
    function ToString: string; override;
  end;

  { Represents the root of the program/module }
  TProgramNode = class(TDeclarationNode)
  public
    ProgramName: TIdentifierNode;
    Declarations: TObjectList<TDeclarationNode>;
    CompoundStatement: TCompoundStatementNode;
    constructor Create(const AToken: TCPToken; const AName: TIdentifierNode);
    destructor Destroy; override;
    function ToString: string; override;
  end;

implementation

uses
  System.TypInfo;

{ TCPASTNode }
constructor TCPASTNode.Create(const AToken: TCPToken);
begin
  inherited Create();
  Self.Token := AToken;
end;

destructor TCPASTNode.Destroy;
begin
  inherited;
end;

{ TIntegerLiteralNode }
function TIntegerLiteralNode.ToString: string;
begin
  Result := Format('TIntegerLiteralNode(Value: %d)', [Value]);
end;

{ TRealLiteralNode }
function TRealLiteralNode.ToString: string;
begin
  Result := Format('TRealLiteralNode(Value: %f)', [Value]);
end;

{ TStringLiteralNode }
function TStringLiteralNode.ToString: string;
begin
  Result := Format('TStringLiteralNode(Value: "%s")', [Value]);
end;

{ TIdentifierNode }
function TIdentifierNode.ToString: string;
begin
  Result := Format('TIdentifierNode(Name: %s)', [Name]);
end;

{ TBinaryOpNode }
constructor TBinaryOpNode.Create(const AToken: TCPToken; const ALeft, ARight: TExpressionNode);
begin
  inherited Create(AToken);
  Self.Left := ALeft;
  Self.Operator := AToken.Kind;
  Self.Right := ARight;
end;

destructor TBinaryOpNode.Destroy;
begin
  Left.Free;
  Right.Free;
  inherited;
end;

function TBinaryOpNode.ToString: string;
var
  LOpStr: string;
begin
  LOpStr := GetEnumName(TypeInfo(TCPTokenKind), Ord(Operator));
  Result := Format('TBinaryOpNode(Op: %s, Left: %s, Right: %s)', [LOpStr, Left.ToString(), Right.ToString()]);
end;

{ TUnaryOpNode }
constructor TUnaryOpNode.Create(const AToken: TCPToken; const AOperand: TExpressionNode);
begin
  inherited Create(AToken);
  Self.Operator := AToken.Kind;
  Self.Operand := AOperand;
end;

destructor TUnaryOpNode.Destroy;
begin
  Operand.Free;
  inherited;
end;

function TUnaryOpNode.ToString: string;
var
  LOpStr: string;
begin
  LOpStr := GetEnumName(TypeInfo(TCPTokenKind), Ord(Operator));
  Result := Format('TUnaryOpNode(Op: %s, Operand: %s)', [LOpStr, Operand.ToString()]);
end;

{ TFunctionCallNode }
constructor TFunctionCallNode.Create(const AToken: TCPToken; const AName: TIdentifierNode);
begin
  inherited Create(AToken);
  FunctionName := AName;
  Arguments := TObjectList<TExpressionNode>.Create(True);
end;

destructor TFunctionCallNode.Destroy;
begin
  FunctionName.Free;
  Arguments.Free;
  inherited;
end;

function TFunctionCallNode.ToString: string;
begin
  Result := Format('TFunctionCallNode(Name: %s, Args: %d)', [FunctionName.Name, Arguments.Count]);
end;

{ TCompoundStatementNode }
constructor TCompoundStatementNode.Create(const AToken: TCPToken);
begin
  inherited Create(AToken);
  Statements := TObjectList<TStatementNode>.Create(True);
end;

destructor TCompoundStatementNode.Destroy;
begin
  Statements.Free;
  inherited;
end;

function TCompoundStatementNode.ToString: string;
begin
  Result := Format('TCompoundStatementNode(Statements: %d)', [Statements.Count]);
end;

{ TAssignmentNode }
constructor TAssignmentNode.Create(const AToken: TCPToken; const AVariable, AExpression: TExpressionNode);
begin
  inherited Create(AToken);
  Variable := AVariable;
  Expression := AExpression;
end;

destructor TAssignmentNode.Destroy;
begin
  Variable.Free;
  Expression.Free;
  inherited;
end;

function TAssignmentNode.ToString: string;
begin
  Result := Format('TAssignmentNode(Var: %s, Expr: %s)', [Variable.ToString(), Expression.ToString()]);
end;

{ TIfStatementNode }
constructor TIfStatementNode.Create(const AToken: TCPToken; const ACondition: TExpressionNode; const AThenStmt, AElseStmt: TStatementNode);
begin
  inherited Create(AToken);
  Condition := ACondition;
  ThenStatement := AThenStmt;
  ElseStatement := AElseStmt;
end;

destructor TIfStatementNode.Destroy;
begin
  Condition.Free;
  ThenStatement.Free;
  if Assigned(ElseStatement) then
    ElseStatement.Free;
  inherited;
end;

function TIfStatementNode.ToString: string;
var
  LHasElse: string;
begin
  if Assigned(ElseStatement) then
    LHasElse := 'True'
  else
    LHasElse := 'False';
  Result := Format('TIfStatementNode(Condition: %s, HasElse: %s)', [Condition.ToString(), LHasElse]);
end;

{ TWhileStatementNode }
constructor TWhileStatementNode.Create(const AToken: TCPToken; const ACondition: TExpressionNode; const ABody: TStatementNode);
begin
  inherited Create(AToken);
  Condition := ACondition;
  Body := ABody;
end;

destructor TWhileStatementNode.Destroy;
begin
  Condition.Free;
  Body.Free;
  inherited;
end;

function TWhileStatementNode.ToString: string;
begin
  Result := Format('TWhileStatementNode(Condition: %s)', [Condition.ToString()]);
end;

{ TRepeatStatementNode }
constructor TRepeatStatementNode.Create(const AToken: TCPToken);
begin
  inherited Create(AToken);
  Statements := TObjectList<TStatementNode>.Create(True);
  Condition := nil;
end;

destructor TRepeatStatementNode.Destroy;
begin
  Statements.Free;
  if Assigned(Condition) then
    Condition.Free;
  inherited;
end;

function TRepeatStatementNode.ToString: string;
begin
  Result := Format('TRepeatStatementNode(Statements: %d, Condition: %s)',
    [Statements.Count, Condition.ToString()]);
end;

{ TForStatementNode }
constructor TForStatementNode.Create(const AToken: TCPToken; const ALoopVar: TIdentifierNode; const AStart, AEnd: TExpressionNode; const ADir: TForDirection; const ABody: TStatementNode);
begin
  inherited Create(AToken);
  LoopVariable := ALoopVar;
  StartValue := AStart;
  EndValue := AEnd;
  Direction := ADir;
  Body := ABody;
end;

destructor TForStatementNode.Destroy;
begin
  LoopVariable.Free;
  StartValue.Free;
  EndValue.Free;
  Body.Free;
  inherited;
end;

function TForStatementNode.ToString: string;
var
  LDirStr: string;
begin
  if Direction = fdTo then
    LDirStr := 'to'
  else
    LDirStr := 'downto';
  Result := Format('TForStatementNode(Var: %s, Dir: %s)', [LoopVariable.Name, LDirStr]);
end;

{ TVarDeclNode }
constructor TVarDeclNode.Create(const AToken: TCPToken);
begin
  inherited Create(AToken);
  Identifiers := TObjectList<TIdentifierNode>.Create(True);
end;

destructor TVarDeclNode.Destroy;
begin
  Identifiers.Free;
  TypeSpec.Free;
  inherited;
end;

function TVarDeclNode.ToString: string;
begin
  Result := Format('TVarDeclNode(Count: %d, Type: %s)', [Identifiers.Count, TypeSpec.ToString()]);
end;

{ TVarSectionNode }
constructor TVarSectionNode.Create(const AToken: TCPToken);
begin
  inherited Create(AToken);
  Declarations := TObjectList<TVarDeclNode>.Create(True);
end;

destructor TVarSectionNode.Destroy;
begin
  Declarations.Free;
  inherited;
end;

function TVarSectionNode.ToString: string;
begin
  Result := Format('TVarSectionNode(Declarations: %d)', [Declarations.Count]);
end;

{ TTypeNameNode }
constructor TTypeNameNode.Create(const AToken: TCPToken; const AIdentifier: TIdentifierNode);
begin
  inherited Create(AToken);
  Identifier := AIdentifier;
end;

destructor TTypeNameNode.Destroy;
begin
  Identifier.Free;
  inherited;
end;

function TTypeNameNode.ToString: string;
begin
  Result := Format('TTypeNameNode(Name: %s)', [Identifier.Name]);
end;

{ TProgramNode }
constructor TProgramNode.Create(const AToken: TCPToken; const AName: TIdentifierNode);
begin
  inherited Create(AToken);
  ProgramName := AName;
  Declarations := TObjectList<TDeclarationNode>.Create(True);
  CompoundStatement := nil;
end;

destructor TProgramNode.Destroy;
begin
  ProgramName.Free;
  Declarations.Free;
  if Assigned(CompoundStatement) then
    CompoundStatement.Free;
  inherited;
end;

function TProgramNode.ToString: string;
begin
  Result := Format('TProgramNode(Name: %s)', [ProgramName.Name]);
end;

end.
