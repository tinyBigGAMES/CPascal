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

unit CPascal.Parser;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.TypInfo,
  CPascal.Lexer,
  CPascal.AST;

type
  { The Parser class, responsible for building the AST from tokens. }
  TCPParser = class
  private
    FLexer: TCPLexer;
    FCurrentToken: TCPToken;

    procedure Consume(const AKind: TCPTokenKind);
    procedure SyntaxError(const AMessage: string);

    { Parsing methods corresponding to BNF rules }
    function ParseIdentifier(): TIdentifierNode;
    {$HINTS OFF}
    function ParseTypeName(): TTypeNameNode;
    {$HINTS ON}
    function ParseTypeSpecifier(): TTypeSpecifierNode;
    function ParseVariableDeclaration(): TVarDeclNode;
    function ParseVarSection(): TVarSectionNode;
    function ParseDeclarations(): TObjectList<TDeclarationNode>;

    function ParseExpression(): TExpressionNode;
    function ParseLogicalAndExpression(): TExpressionNode;
    function ParseRelationalExpression(): TExpressionNode;
    function ParseAdditiveExpression(): TExpressionNode;
    function ParseTerm(): TExpressionNode;
    function ParseFactor(): TExpressionNode;
    function ParsePrimary(): TExpressionNode;

    function ParseStatement(): TStatementNode;
    function ParseStatementList(): TObjectList<TStatementNode>;
    function ParseAssignmentStatement(): TStatementNode;
    function ParseCompoundStatement(): TCompoundStatementNode;
    function ParseIfStatement(): TIfStatementNode;
    function ParseWhileStatement(): TWhileStatementNode;
    function ParseRepeatStatement(): TRepeatStatementNode;
    function ParseForStatement(): TForStatementNode;

    function ParseProgram(): TProgramNode;
    function ParseCompilationUnit(): TCPASTNode;

  public
    constructor Create(const ALexer: TCPLexer);
    destructor Destroy; override;

    function Parse(): TCPASTNode;
  end;

implementation

uses
  CPascal.Common; // MODIFIED

{ TCPParser }

constructor TCPParser.Create(const ALexer: TCPLexer);
begin
  inherited Create();
  FLexer := ALexer;
  FCurrentToken := FLexer.NextToken();
end;

destructor TCPParser.Destroy;
begin
  inherited;
end;

procedure TCPParser.SyntaxError(const AMessage: string);
begin
  raise ECPCompilerError.Create(Format('Syntax Error: %s', [AMessage]), FCurrentToken.Line, FCurrentToken.Column);
end;

procedure TCPParser.Consume(const AKind: TCPTokenKind);
begin
  if FCurrentToken.Kind = AKind then
    FCurrentToken := FLexer.NextToken()
  else
    SyntaxError(Format('Expected %s but found %s', [GetEnumName(TypeInfo(TCPTokenKind), Ord(AKind)), GetEnumName(TypeInfo(TCPTokenKind), Ord(FCurrentToken.Kind))]));
end;

function TCPParser.ParseIdentifier(): TIdentifierNode;
var
  LToken: TCPToken;
begin
  LToken := FCurrentToken;
  if LToken.Kind <> tkIdentifier then
    SyntaxError('Expected an identifier.');
  Result := TIdentifierNode.Create(LToken);
  Result.Name := LToken.Value;
  Consume(tkIdentifier);
end;

function TCPParser.ParseTypeName: TTypeNameNode;
var
  LIdentifierNode: TIdentifierNode;
begin
  LIdentifierNode := ParseIdentifier();
  Result := TTypeNameNode.Create(LIdentifierNode.Token, LIdentifierNode);
end;

function TCPParser.ParseTypeSpecifier: TTypeSpecifierNode;
const
  TypeTokens: set of TCPTokenKind = [
    tkIdentifier, tkSingle, tkDouble, tkBoolean, tkChar, tkPointer,
    tkInt8, tkUInt8, tkInt16, tkUInt16, tkInt32, tkUInt32, tkInt64, tkUInt64
  ];
var
  LIdentifierNode: TIdentifierNode;
  LToken: TCPToken;
begin
  LToken := FCurrentToken;
  if LToken.Kind in TypeTokens then
  begin
    LIdentifierNode := TIdentifierNode.Create(LToken);
    if LToken.Kind = tkIdentifier then
      LIdentifierNode.Name := LToken.Value
    else
      LIdentifierNode.Name := GetEnumName(TypeInfo(TCPTokenKind), Ord(LToken.Kind)).Substring(2);

    Result := TTypeNameNode.Create(LToken, LIdentifierNode);
    Consume(LToken.Kind);
  end
  else
  begin
    SyntaxError('Expected a type identifier.');
    Result := nil;
  end;
end;


function TCPParser.ParseVariableDeclaration: TVarDeclNode;
var
  LResult: TVarDeclNode;
  LIdentifierNode: TIdentifierNode;
begin
  LResult := TVarDeclNode.Create(FCurrentToken);
  LIdentifierNode := ParseIdentifier();
  LResult.Identifiers.Add(LIdentifierNode);

  while FCurrentToken.Kind = tkComma do
  begin
    Consume(tkComma);
    LIdentifierNode := ParseIdentifier();
    LResult.Identifiers.Add(LIdentifierNode);
  end;

  Consume(tkColon);
  LResult.TypeSpec := ParseTypeSpecifier();
  Result := LResult;
end;

function TCPParser.ParseVarSection: TVarSectionNode;
var
  LResult: TVarSectionNode;
begin
  LResult := TVarSectionNode.Create(FCurrentToken);
  Consume(tkVar);
  while FCurrentToken.Kind = tkIdentifier do
  begin
    LResult.Declarations.Add(ParseVariableDeclaration());
    Consume(tkSemicolon);
  end;
  Result := LResult;
end;

function TCPParser.ParseDeclarations: TObjectList<TDeclarationNode>;
begin
  Result := TObjectList<TDeclarationNode>.Create(True);
  while FCurrentToken.Kind = tkVar do
  begin
    Result.Add(ParseVarSection());
  end;
end;

function TCPParser.ParsePrimary: TExpressionNode;
var
  LNode: TExpressionNode;
begin
  case FCurrentToken.Kind of
    tkInteger:
      begin
        LNode := TIntegerLiteralNode.Create(FCurrentToken);
        TIntegerLiteralNode(LNode).Value := StrToInt64(FCurrentToken.Value);
        Consume(tkInteger);
      end;
    tkReal:
      begin
        LNode := TRealLiteralNode.Create(FCurrentToken);
        TRealLiteralNode(LNode).Value := StrToFloat(FCurrentToken.Value);
        Consume(tkReal);
      end;
    tkIdentifier:
      begin
        LNode := ParseIdentifier();
      end;
    tkLParen:
      begin
        Consume(tkLParen);
        LNode := ParseExpression();
        Consume(tkRParen);
      end;
  else
    SyntaxError('Unexpected token in expression');
    LNode := nil;
  end;
  Result := LNode;
end;

function TCPParser.ParseFactor: TExpressionNode;
var
  LToken: TCPToken;
  LNode: TExpressionNode;
begin
  LToken := FCurrentToken;
  if (LToken.Kind = tkPlus) or (LToken.Kind = tkMinus) then
  begin
    Consume(LToken.Kind);
    LNode := TUnaryOpNode.Create(LToken, ParseFactor());
    Result := LNode;
  end
  else
    Result := ParsePrimary();
end;

function TCPParser.ParseTerm: TExpressionNode;
var
  LNode: TExpressionNode;
  LToken: TCPToken;
begin
  LNode := ParseFactor();
  while (FCurrentToken.Kind = tkAsterisk) or (FCurrentToken.Kind = tkSlash) do
  begin
    LToken := FCurrentToken;
    Consume(LToken.Kind);
    LNode := TBinaryOpNode.Create(LToken, LNode, ParseFactor());
  end;
  Result := LNode;
end;

function TCPParser.ParseAdditiveExpression: TExpressionNode;
var
  LNode: TExpressionNode;
  LToken: TCPToken;
begin
  LNode := ParseTerm();
  while (FCurrentToken.Kind = tkPlus) or (FCurrentToken.Kind = tkMinus) do
  begin
    LToken := FCurrentToken;
    Consume(LToken.Kind);
    LNode := TBinaryOpNode.Create(LToken, LNode, ParseTerm());
  end;
  Result := LNode;
end;

function TCPParser.ParseRelationalExpression: TExpressionNode;
var
  LNode: TExpressionNode;
  LToken: TCPToken;
begin
  LNode := ParseAdditiveExpression();
  while FCurrentToken.Kind in [tkEqual, tkNotEqual, tkLessThan, tkLessEqual, tkGreaterThan, tkGreaterEqual] do
  begin
    LToken := FCurrentToken;
    Consume(LToken.Kind);
    LNode := TBinaryOpNode.Create(LToken, LNode, ParseAdditiveExpression());
  end;
  Result := LNode;
end;

function TCPParser.ParseLogicalAndExpression: TExpressionNode;
var
  LNode: TExpressionNode;
  LToken: TCPToken;
begin
  LNode := ParseRelationalExpression();
  while FCurrentToken.Kind = tkAnd do
  begin
    LToken := FCurrentToken;
    Consume(tkAnd);
    LNode := TBinaryOpNode.Create(LToken, LNode, ParseRelationalExpression());
  end;
  Result := LNode;
end;

function TCPParser.ParseExpression: TExpressionNode;
begin
  Result := ParseLogicalAndExpression();
end;

function TCPParser.ParseAssignmentStatement: TStatementNode;
var
  LVarNode: TExpressionNode;
  LExprNode: TExpressionNode;
  LToken: TCPToken;
begin
  LVarNode := ParseIdentifier();
  LToken := FCurrentToken;
  Consume(tkAssign);
  LExprNode := ParseExpression();
  Result := TAssignmentNode.Create(LToken, LVarNode, LExprNode);
end;

function TCPParser.ParseIfStatement: TIfStatementNode;
var
  LCondition: TExpressionNode;
  LThenStmt: TStatementNode;
  LElseStmt: TStatementNode;
  LToken: TCPToken;
begin
  LToken := FCurrentToken;
  Consume(tkIf);
  LCondition := ParseExpression();
  Consume(tkThen);
  LThenStmt := ParseStatement();
  LElseStmt := nil;
  if FCurrentToken.Kind = tkElse then
  begin
    Consume(tkElse);
    LElseStmt := ParseStatement();
  end;
  Result := TIfStatementNode.Create(LToken, LCondition, LThenStmt, LElseStmt);
end;

function TCPParser.ParseWhileStatement: TWhileStatementNode;
var
  LCondition: TExpressionNode;
  LBody: TStatementNode;
  LToken: TCPToken;
begin
  LToken := FCurrentToken;
  Consume(tkWhile);
  LCondition := ParseExpression();
  Consume(tkDo);
  LBody := ParseStatement();
  Result := TWhileStatementNode.Create(LToken, LCondition, LBody);
end;

function TCPParser.ParseRepeatStatement: TRepeatStatementNode;
var
  LNode: TRepeatStatementNode;
begin
  LNode := TRepeatStatementNode.Create(FCurrentToken);
  Consume(tkRepeat);
  LNode.Statements.AddRange(ParseStatementList());
  Consume(tkUntil);
  LNode.Condition := ParseExpression();
  Result := LNode;
end;

function TCPParser.ParseForStatement: TForStatementNode;
var
  LLoopVar: TIdentifierNode;
  LStart, LEnd: TExpressionNode;
  LBody: TStatementNode;
  LDir: TForDirection;
  LToken: TCPToken;
begin
  LToken := FCurrentToken;
  Consume(tkFor);
  LLoopVar := ParseIdentifier();
  Consume(tkAssign);
  LStart := ParseExpression();

  if FCurrentToken.Kind = tkTo then
    LDir := fdTo
  else if FCurrentToken.Kind = tkDownto then
  begin
    LDir := fdDownTo;
  end
  else
  begin
    SyntaxError('Expected "to" or "downto" in for loop.');
    LDir := fdTo;
  end;
  Consume(FCurrentToken.Kind);

  LEnd := ParseExpression();
  Consume(tkDo);
  LBody := ParseStatement();

  Result := TForStatementNode.Create(LToken, LLoopVar, LStart, LEnd, LDir, LBody);
end;

function TCPParser.ParseStatement: TStatementNode;
begin
  case FCurrentToken.Kind of
    tkBegin: Result := ParseCompoundStatement();
    tkIdentifier: Result := ParseAssignmentStatement();
    tkIf: Result := ParseIfStatement();
    tkWhile: Result := ParseWhileStatement();
    tkRepeat: Result := ParseRepeatStatement();
    tkFor: Result := ParseForStatement();
  else
    Result := nil;
  end;
end;

function TCPParser.ParseStatementList: TObjectList<TStatementNode>;
var
  LStatement: TStatementNode;
begin
  Result := TObjectList<TStatementNode>.Create(True);

  LStatement := ParseStatement();
  if Assigned(LStatement) then
    Result.Add(LStatement);

  while FCurrentToken.Kind = tkSemicolon do
  begin
    Consume(tkSemicolon);
    if FCurrentToken.Kind in [tkEnd, tkUntil] then
      break;

    LStatement := ParseStatement();
    if Assigned(LStatement) then
      Result.Add(LStatement);
  end;
end;

function TCPParser.ParseCompoundStatement: TCompoundStatementNode;
begin
  Result := TCompoundStatementNode.Create(FCurrentToken);
  Consume(tkBegin);
  Result.Statements.AddRange(ParseStatementList());
  Consume(tkEnd);
end;

function TCPParser.ParseProgram: TProgramNode;
var
  LProgramName: TIdentifierNode;
  LDeclarations: TObjectList<TDeclarationNode>;
  LCompoundStmt: TCompoundStatementNode;
  LToken: TCPToken;
begin
  LToken := FCurrentToken;
  Consume(tkProgram);
  LProgramName := ParseIdentifier();
  Consume(tkSemicolon);

  LDeclarations := ParseDeclarations();
  LCompoundStmt := ParseCompoundStatement();
  Consume(tkDot);

  Result := TProgramNode.Create(LToken, LProgramName);
  Result.Declarations.AddRange(LDeclarations);
  Result.CompoundStatement := LCompoundStmt;
end;

function TCPParser.ParseCompilationUnit: TCPASTNode;
begin
  if FCurrentToken.Kind = tkProgram then
    Result := ParseProgram()
  else
  begin
    SyntaxError('Expected "program" keyword.');
    Result := nil;
  end;
end;

function TCPParser.Parse: TCPASTNode;
var
  LRootNode: TCPASTNode;
begin
  LRootNode := ParseCompilationUnit();
  if FCurrentToken.Kind <> tkEndOfFile then
    SyntaxError('Expected end of file.');
  Result := LRootNode;
end;

end.
