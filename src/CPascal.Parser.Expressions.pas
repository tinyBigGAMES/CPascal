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

unit CPascal.Parser.Expressions;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  CPascal.Exception,
  CPascal.Lexer,
  CPascal.Parser,
  CPascal.AST,
  CPascal.AST.Expressions;

function ParseExpression(const AParser: TCPParser): TCPExpressionNode;
function ParseLogicalOrExpression(const AParser: TCPParser): TCPExpressionNode;
function ParseLogicalAndExpression(const AParser: TCPParser): TCPExpressionNode;
function ParseEqualityExpression(const AParser: TCPParser): TCPExpressionNode;
function ParseRelationalExpression(const AParser: TCPParser): TCPExpressionNode;
function ParseAdditiveExpression(const AParser: TCPParser): TCPExpressionNode;
function ParseMultiplicativeExpression(const AParser: TCPParser): TCPExpressionNode;
function ParseUnaryExpression(const AParser: TCPParser): TCPExpressionNode;
function ParsePrimaryExpression(const AParser: TCPParser): TCPExpressionNode;
function ParseFunctionCall(const AParser: TCPParser; const AFunctionName: string; const ALocation: TCPSourceLocation): TCPFunctionCallNode;
function ParseExpressionList(const AParser: TCPParser): TCPASTNodeList;


implementation

function ParseExpression(const AParser: TCPParser): TCPExpressionNode;
begin
  Result := ParseLogicalOrExpression(AParser);
end;

function ParseLogicalOrExpression(const AParser: TCPParser): TCPExpressionNode;
var
  LLeft: TCPExpressionNode;
  LOperator: TCPTokenKind;
  LRight: TCPExpressionNode;
begin
  Result := ParseLogicalAndExpression(AParser);
  
  while AParser.CurrentToken.Kind = tkOr do
  begin
    LLeft := Result;
    LOperator := AParser.CurrentToken.Kind;
    AParser.AdvanceToken(); // Consume operator
    LRight := ParseLogicalAndExpression(AParser);
    Result := TCPBinaryOperationNode.Create(LLeft.Location, LOperator, LLeft, LRight);
  end;
end;

function ParseLogicalAndExpression(const AParser: TCPParser): TCPExpressionNode;
var
  LLeft: TCPExpressionNode;
  LOperator: TCPTokenKind;
  LRight: TCPExpressionNode;
begin
  Result := ParseEqualityExpression(AParser);
  
  while AParser.CurrentToken.Kind = tkAnd do
  begin
    LLeft := Result;
    LOperator := AParser.CurrentToken.Kind;
    AParser.AdvanceToken(); // Consume operator
    LRight := ParseEqualityExpression(AParser);
    Result := TCPBinaryOperationNode.Create(LLeft.Location, LOperator, LLeft, LRight);
  end;
end;

function ParseEqualityExpression(const AParser: TCPParser): TCPExpressionNode;
var
  LLeft: TCPExpressionNode;
  LOperator: TCPTokenKind;
  LRight: TCPExpressionNode;
begin
  Result := ParseRelationalExpression(AParser);
  
  while AParser.CurrentToken.Kind in [tkEqual, tkNotEqual] do
  begin
    LLeft := Result;
    LOperator := AParser.CurrentToken.Kind;
    AParser.AdvanceToken(); // Consume operator
    LRight := ParseRelationalExpression(AParser);
    Result := TCPBinaryOperationNode.Create(LLeft.Location, LOperator, LLeft, LRight);
  end;
end;

function ParseRelationalExpression(const AParser: TCPParser): TCPExpressionNode;
var
  LLeft: TCPExpressionNode;
  LOperator: TCPTokenKind;
  LRight: TCPExpressionNode;
begin
  Result := ParseAdditiveExpression(AParser);
  
  while AParser.CurrentToken.Kind in [tkLessThan, tkLessEqual, tkGreaterThan, tkGreaterEqual] do
  begin
    LLeft := Result;
    LOperator := AParser.CurrentToken.Kind;
    AParser.AdvanceToken(); // Consume operator
    LRight := ParseAdditiveExpression(AParser);
    Result := TCPBinaryOperationNode.Create(LLeft.Location, LOperator, LLeft, LRight);
  end;
end;

function ParseAdditiveExpression(const AParser: TCPParser): TCPExpressionNode;
var
  LLeft: TCPExpressionNode;
  LOperator: TCPTokenKind;
  LRight: TCPExpressionNode;
begin
  Result := ParseMultiplicativeExpression(AParser);
  
  while AParser.CurrentToken.Kind in [tkPlus, tkMinus] do
  begin
    LLeft := Result;
    LOperator := AParser.CurrentToken.Kind;
    AParser.AdvanceToken(); // Consume operator
    LRight := ParseMultiplicativeExpression(AParser);
    Result := TCPBinaryOperationNode.Create(LLeft.Location, LOperator, LLeft, LRight);
  end;
end;

function ParseMultiplicativeExpression(const AParser: TCPParser): TCPExpressionNode;
var
  LLeft: TCPExpressionNode;
  LOperator: TCPTokenKind;
  LRight: TCPExpressionNode;
begin
  Result := ParseUnaryExpression(AParser);
  
  while AParser.CurrentToken.Kind in [tkMultiply, tkDivide, tkDiv, tkMod] do
  begin
    LLeft := Result;
    LOperator := AParser.CurrentToken.Kind;
    AParser.AdvanceToken(); // Consume operator
    LRight := ParseUnaryExpression(AParser);
    Result := TCPBinaryOperationNode.Create(LLeft.Location, LOperator, LLeft, LRight);
  end;
end;

function ParseUnaryExpression(const AParser: TCPParser): TCPExpressionNode;
var
  LOperator: TCPTokenKind;
  LLocation: TCPSourceLocation;
  LOperand: TCPExpressionNode;
begin
  // Handle prefix operators: +, -, not, @, *, ++, --
  if AParser.CurrentToken.Kind in [tkPlus, tkMinus, tkNot, tkAddressOf, tkDereference, tkIncrement, tkDecrement] then
  begin
    LOperator := AParser.CurrentToken.Kind;
    LLocation := AParser.CurrentToken.Location;
    AParser.AdvanceToken(); // Consume prefix operator
    LOperand := ParseUnaryExpression(AParser); // Recursive call for right associativity
    Result := TCPUnaryOperationNode.Create(LLocation, LOperator, LOperand);
  end
  else
  begin
    Result := ParsePrimaryExpression(AParser);
  end;
end;

function ParsePrimaryExpression(const AParser: TCPParser): TCPExpressionNode;
var
  LIdentifierName: string;
  LLiteralValue: string;
  LLocation: TCPSourceLocation;
  LOperand: TCPExpressionNode;
begin
  case AParser.CurrentToken.Kind of
    tkIdentifier:
    begin
      LIdentifierName := AParser.CurrentToken.Value;
      Result := TCPIdentifierNode.Create(AParser.CurrentToken.Location, LIdentifierName);
      AParser.AdvanceToken();

      // Check if this is a function call
      if AParser.MatchToken(tkLeftParen) then
      begin
        Result.Free; // Free the identifier node
        Result := ParseFunctionCall(AParser, LIdentifierName, AParser.CurrentToken.Location);
      end
      // Check for array access [index]
      else if AParser.MatchToken(tkLeftBracket) then
      begin
        LLocation := AParser.CurrentToken.Location;
        AParser.AdvanceToken(); // Consume '['
        LOperand := ParseExpression(AParser); // Parse index expression
        AParser.ConsumeToken(tkRightBracket); // Consume ']'
        
        // Create array access node (Result is the array expression, LOperand is the index)
        Result := TCPArrayAccessNode.Create(LLocation, Result, LOperand);
      end
      // Check for pointer dereference (postfix ^)
      else if AParser.MatchToken(tkDereference) then
      begin
        LLocation := AParser.CurrentToken.Location;
        AParser.AdvanceToken(); // Consume '^'
        LOperand := Result;
        Result := TCPUnaryOperationNode.Create(LLocation, tkDereference, LOperand);
      end;
    end;

    tkIntegerLiteral:
    begin
      LLiteralValue := AParser.CurrentToken.Value;
      Result := TCPLiteralNode.Create(nkIntegerLiteral, AParser.CurrentToken.Location, LLiteralValue);
      AParser.AdvanceToken();
    end;

    tkRealLiteral:
    begin
      LLiteralValue := AParser.CurrentToken.Value;
      Result := TCPLiteralNode.Create(nkRealLiteral, AParser.CurrentToken.Location, LLiteralValue);
      AParser.AdvanceToken();
    end;

    tkStringLiteral:
    begin
      LLiteralValue := AParser.CurrentToken.Value;
      Result := TCPLiteralNode.Create(nkStringLiteral, AParser.CurrentToken.Location, LLiteralValue);
      AParser.AdvanceToken();
    end;

    tkCharacterLiteral:
    begin
      LLiteralValue := AParser.CurrentToken.Value;
      Result := TCPLiteralNode.Create(nkCharacterLiteral, AParser.CurrentToken.Location, LLiteralValue);
      AParser.AdvanceToken();
    end;

    tkTrue, tkFalse:
    begin
      LLiteralValue := AParser.CurrentToken.Value;
      Result := TCPLiteralNode.Create(nkBooleanLiteral, AParser.CurrentToken.Location, LLiteralValue);
      AParser.AdvanceToken();
    end;

    tkNil:
    begin
      LLiteralValue := AParser.CurrentToken.Value;
      Result := TCPLiteralNode.Create(nkNilLiteral, AParser.CurrentToken.Location, LLiteralValue);
      AParser.AdvanceToken();
    end;

    tkLeftParen:
    begin
      AParser.AdvanceToken(); // Consume '('
      Result := ParseExpression(AParser); // Parse sub-expression
      AParser.ConsumeToken(tkRightParen); // Consume ')'
    end;

  else
    AParser.UnexpectedToken('expression');
    Result := nil;
  end;
end;

function ParseFunctionCall(const AParser: TCPParser; const AFunctionName: string; const ALocation: TCPSourceLocation): TCPFunctionCallNode;
var
  LArguments: TCPASTNodeList;
  LArgument: TCPExpressionNode;
  LIndex: Integer;
begin
  // Parse: <identifier> "(" <expression_list>? ")"
  Result := TCPFunctionCallNode.Create(ALocation, AFunctionName);

  AParser.ConsumeToken(tkLeftParen);

  // Parse argument list
  if not AParser.MatchToken(tkRightParen) then
  begin
    LArguments := ParseExpressionList(AParser);

    // Add arguments to function call
    for LIndex := 0 to LArguments.Count - 1 do
    begin
      LArgument := TCPExpressionNode(LArguments[LIndex]);
      Result.AddArgument(LArgument);
    end;

    LArguments.Free; // Free the temporary list (not the nodes, they're owned by Result)
  end;

  AParser.ConsumeToken(tkRightParen);
end;

function ParseExpressionList(const AParser: TCPParser): TCPASTNodeList;
var
  LExpression: TCPExpressionNode;
begin
  Result := TCPASTNodeList.Create(False); // Don't own objects, they'll be owned by the function call

  // Parse first expression
  LExpression := ParseExpression(AParser);
  Result.Add(LExpression);

  // Parse additional expressions
  while AParser.MatchToken(tkComma) do
  begin
    AParser.AdvanceToken(); // Consume comma
    LExpression := ParseExpression(AParser);
    Result.Add(LExpression);
  end;
end;

end.
