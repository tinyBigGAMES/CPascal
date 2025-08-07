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

unit CPascal.Parser.Statements;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  CPascal.Exception,
  CPascal.Lexer,
  CPascal.Parser,
  CPascal.AST,
  CPascal.AST.Statements,
  CPascal.AST.Expressions;

function ParseCompoundStatement(const AParser: TCPParser): TCPCompoundStatementNode;
function ParseStatement(const AParser: TCPParser): TCPStatementNode;
function ParseAssignmentStatement(const AParser: TCPParser): TCPAssignmentStatementNode;
function ParseExpressionStatement(const AParser: TCPParser): TCPStatementNode;
function ParseIfStatement(const AParser: TCPParser): TCPIfStatementNode;
function ParseWhileStatement(const AParser: TCPParser): TCPWhileStatementNode;
function ParseForStatement(const AParser: TCPParser): TCPForStatementNode;
function ParseCaseStatement(const AParser: TCPParser): TCPCaseStatementNode;
function ParseReturnStatement(const AParser: TCPParser): TCPReturnStatementNode;
function IsAssignmentOperator(const ATokenKind: TCPTokenKind): Boolean;

implementation

uses
  CPascal.Parser.Expressions;

function IsAssignmentOperator(const ATokenKind: TCPTokenKind): Boolean;
begin
  Result := ATokenKind in [tkAssign, tkPlusAssign, tkMinusAssign, tkMultiplyAssign, 
                           tkDivideAssign, tkAndAssign, tkOrAssign, tkXorAssign, 
                           tkShlAssign, tkShrAssign];
end;

function ParseCompoundStatement(const AParser: TCPParser): TCPCompoundStatementNode;
var
  LStatement: TCPStatementNode;
begin
  // Parse: "begin" <statement_list> "end"
  Result := TCPCompoundStatementNode.Create(AParser.CurrentToken.Location);

  AParser.ConsumeToken(tkBegin);

  // Parse statements until 'end'
  while not AParser.MatchToken(tkEnd) and not AParser.MatchToken(tkEOF) do
  begin
    LStatement := ParseStatement(AParser);
    if Assigned(LStatement) then
      Result.AddStatement(LStatement);

    // Optional semicolon between statements
    if AParser.MatchToken(tkSemicolon) then
      AParser.AdvanceToken();
  end;

  AParser.ConsumeToken(tkEnd);
end;

function ParseAssignmentStatement(const AParser: TCPParser): TCPAssignmentStatementNode;
var
  LVariableExpression: TCPExpressionNode;
  LAssignmentOperator: TCPTokenKind;
  LValueExpression: TCPExpressionNode;
  //LArrayAccess: TCPArrayAccessNode;
  LStartLocation: TCPSourceLocation;
begin
  // Initialize Result to avoid access violations
  Result := nil;
  
  // Parse: <variable_list> <assignment_operator> <expression_list>
  // Supports multiple assignments: LVar1, LVar2 := 100, 200
  // Also supports pointer dereference: LPtr^ := 100
  // Also supports array access: LArray[index] := 100
  
  LStartLocation := AParser.CurrentToken.Location;
  
  // Parse variable list using expression parsing to handle complex lvalues
  repeat
    // Parse left-hand side expression (identifier, array access, pointer dereference)
    LVariableExpression := ParsePrimaryExpression(AParser);
    
    // Validate that this is a valid lvalue
    if not (LVariableExpression.NodeKind in [nkIdentifier, nkArrayAccess, nkUnaryOperation]) then
    begin
      AParser.ParseError('Invalid left-hand side in assignment statement', []);
    end;
    
    // For unary operations, ensure it's a dereference (valid lvalue)
    if (LVariableExpression.NodeKind = nkUnaryOperation) then
    begin
      if TCPUnaryOperationNode(LVariableExpression).Operator <> tkDereference then
      begin
        AParser.ParseError('Invalid left-hand side in assignment statement', []);
      end;
    end;
    
    // Create assignment node on first variable
    if not Assigned(Result) then
      Result := TCPAssignmentStatementNode.Create(LStartLocation, tkAssign); // Will be updated with actual operator
    
    Result.AddVariable(LVariableExpression);
    
    if AParser.MatchToken(tkComma) then
    begin
      AParser.AdvanceToken(); // Consume comma
      // Continue parsing next variable
    end
    else
      Break; // No more variables
  until False;
  
  // Parse assignment operator
  if not IsAssignmentOperator(AParser.CurrentToken.Kind) then
    AParser.UnexpectedToken('assignment operator');
  
  LAssignmentOperator := AParser.CurrentToken.Kind;
  // Update the assignment operator in the node
  Result.AssignmentOperator := LAssignmentOperator;
  AParser.AdvanceToken();
  
  // Parse expression list: expr1, expr2, expr3
  repeat
    LValueExpression := ParseExpression(AParser);
    Result.AddExpression(LValueExpression);
    
    if AParser.MatchToken(tkComma) then
    begin
      AParser.AdvanceToken(); // Consume comma
      // Continue parsing next expression
    end
    else
      Break; // No more expressions
  until False;
end;

function ParseStatement(const AParser: TCPParser): TCPStatementNode;
var
  LLookaheadToken: TCPToken;
begin
  case AParser.CurrentToken.Kind of
    tkBegin:
      Result := ParseCompoundStatement(AParser);

    tkIf:
      Result := ParseIfStatement(AParser);

    tkWhile:
      Result := ParseWhileStatement(AParser);

    tkFor:
      Result := ParseForStatement(AParser);

    tkCase:
      Result := ParseCaseStatement(AParser);

    tkReturn:
      Result := ParseReturnStatement(AParser);

    tkIdentifier:
    begin
      // Use lookahead to distinguish assignment from expression statements
      LLookaheadToken := AParser.PeekNextToken();
      
      // Check if this is an assignment statement
      // Case 1: identifier followed directly by assignment operator (LVar := expr)
      // Case 2: identifier followed by comma (LVar1, LVar2 := expr1, expr2)
      // Case 3: identifier followed by dereference (LPtr^ := expr) - potential assignment
      // Case 4: identifier followed by array access (LArray[index] := expr) - potential assignment
      if IsAssignmentOperator(LLookaheadToken.Kind) or 
         (LLookaheadToken.Kind = tkComma) or
         (LLookaheadToken.Kind = tkDereference) or
         (LLookaheadToken.Kind = tkLeftBracket) then
        Result := ParseAssignmentStatement(AParser)
      else
        Result := ParseExpressionStatement(AParser);
    end;

    // Other statement types can be added here
    else
    begin
      AParser.ParseError('Unexpected token in statement: %s "%s"', [CPTokenKindToString(AParser.CurrentToken.Kind), AParser.CurrentToken.Value]);
      Result := nil;
    end;
  end;
end;

function ParseExpressionStatement(const AParser: TCPParser): TCPStatementNode;
var
  LExpression: TCPExpressionNode;
begin
  // Parse expression (function call, assignment, etc.)
  LExpression := ParseExpression(AParser);

  // For now, treat expression as a statement (works for function calls)
  Result := TCPStatementNode.Create(nkFunctionCall, LExpression.Location);
  Result.AddChild(LExpression);
end;

function ParseIfStatement(const AParser: TCPParser): TCPIfStatementNode;
var
  LCondition: TCPExpressionNode;
  LThenStatement: TCPStatementNode;
  LElseStatement: TCPStatementNode;
  LIfLocation: TCPSourceLocation;
begin
  // Parse: "if" <expression> "then" <statement> ("else" <statement>)?
  LIfLocation := AParser.CurrentToken.Location;
  AParser.ConsumeToken(tkIf);
  
  // Parse condition expression
  LCondition := ParseExpression(AParser);
  
  AParser.ConsumeToken(tkThen);
  
  // Parse then statement
  LThenStatement := ParseStatement(AParser);
  
  // Optional else clause
  LElseStatement := nil;
  if AParser.MatchToken(tkElse) then
  begin
    AParser.AdvanceToken(); // Consume 'else'
    LElseStatement := ParseStatement(AParser);
  end;
  
  Result := TCPIfStatementNode.Create(LIfLocation, LCondition, LThenStatement, LElseStatement);
end;

function ParseWhileStatement(const AParser: TCPParser): TCPWhileStatementNode;
var
  LCondition: TCPExpressionNode;
  LBodyStatement: TCPStatementNode;
  LWhileLocation: TCPSourceLocation;
begin
  // Parse: "while" <expression> "do" <statement>
  LWhileLocation := AParser.CurrentToken.Location;
  AParser.ConsumeToken(tkWhile);
  
  // Parse condition expression
  LCondition := ParseExpression(AParser);
  
  AParser.ConsumeToken(tkDo);
  
  // Parse body statement
  LBodyStatement := ParseStatement(AParser);
  
  Result := TCPWhileStatementNode.Create(LWhileLocation, LCondition, LBodyStatement);
end;

function ParseForStatement(const AParser: TCPParser): TCPForStatementNode;
var
  LControlVariable: string;
  LStartExpression: TCPExpressionNode;
  LEndExpression: TCPExpressionNode;
  LIsDownto: Boolean;
  LBodyStatement: TCPStatementNode;
  LForLocation: TCPSourceLocation;
begin
  // Parse: "for" <identifier> ":=" <expression> ("to" | "downto") <expression> "do" <statement>
  LForLocation := AParser.CurrentToken.Location;
  AParser.ConsumeToken(tkFor);
  
  // Parse control variable identifier
  if not AParser.MatchToken(tkIdentifier) then
    AParser.UnexpectedToken('control variable identifier');
  
  LControlVariable := AParser.CurrentToken.Value;
  AParser.AdvanceToken();
  
  // Parse := assignment
  AParser.ConsumeToken(tkAssign);
  
  // Parse start expression
  LStartExpression := ParseExpression(AParser);
  
  // Parse direction: "to" or "downto"
  LIsDownto := False;
  if AParser.MatchToken(tkTo) then
  begin
    LIsDownto := False;
    AParser.AdvanceToken();
  end
  else if AParser.MatchToken(tkDownto) then
  begin
    LIsDownto := True;
    AParser.AdvanceToken();
  end
  else
    AParser.UnexpectedToken('"to" or "downto"');
  
  // Parse end expression
  LEndExpression := ParseExpression(AParser);
  
  // Parse "do" keyword
  AParser.ConsumeToken(tkDo);
  
  // Parse body statement
  LBodyStatement := ParseStatement(AParser);
  
  Result := TCPForStatementNode.Create(LForLocation, LControlVariable, LStartExpression, 
                                        LEndExpression, LIsDownto, LBodyStatement);
end;

function ParseCaseStatement(const AParser: TCPParser): TCPCaseStatementNode;
var
  LCaseExpression: TCPExpressionNode;
  LCaseBranch: TCPCaseBranch;
  LCaseLabel: TCPExpressionNode;
  LBranchStatement: TCPStatementNode;
  LElseStatement: TCPStatementNode;
  LCaseLocation: TCPSourceLocation;
begin
  // Parse: "case" <expression> "of" <case_list> ("else" <statement_list>)? "end"
  LCaseLocation := AParser.CurrentToken.Location;
  AParser.ConsumeToken(tkCase);
  
  // Parse case expression
  LCaseExpression := ParseExpression(AParser);
  
  AParser.ConsumeToken(tkOf);
  
  // Create case statement node
  Result := TCPCaseStatementNode.Create(LCaseLocation, LCaseExpression);
  
  try
    // Parse case branches until 'else' or 'end'
    while not AParser.MatchToken(tkElse) and not AParser.MatchToken(tkEnd) and not AParser.MatchToken(tkEOF) do
    begin
      // Create new branch
      LCaseBranch := TCPCaseBranch.Create();
      
      // Parse case label list: constant_expression (, constant_expression)*
      repeat
        LCaseLabel := ParseExpression(AParser); // Parse constant expression (case label)
        LCaseBranch.AddLabel(LCaseLabel);
        
        // Check for more labels (comma-separated)
        if AParser.MatchToken(tkComma) then
        begin
          AParser.AdvanceToken(); // Consume comma
          // Continue parsing next label
        end
        else
          Break; // No more labels
      until False;
      
      // Parse colon and statement
      AParser.ConsumeToken(tkColon);
      LBranchStatement := ParseStatement(AParser);
      
      // Set the statement for this branch
      LCaseBranch.SetStatement(LBranchStatement);
      
      // Add branch to case statement
      Result.AddBranch(LCaseBranch);
      
      // Optional semicolon between case branches  
      if AParser.MatchToken(tkSemicolon) then
        AParser.AdvanceToken();
    end;
    
    // Optional else clause
    if AParser.MatchToken(tkElse) then
    begin
      AParser.AdvanceToken(); // Consume 'else'
      LElseStatement := ParseStatement(AParser);
      
      // Optional semicolon after else statement (before 'end')
      if AParser.MatchToken(tkSemicolon) then
        AParser.AdvanceToken();
      
      // Store the else statement
      Result.SetElseStatement(LElseStatement);
    end;
    
    AParser.ConsumeToken(tkEnd);
    
  except
    Result.Free;
    raise;
  end;
end;

function ParseReturnStatement(const AParser: TCPParser): TCPReturnStatementNode;
var
  LReturnExpression: TCPExpressionNode;
  LReturnLocation: TCPSourceLocation;
begin
  // Parse: "return" <expression>? ";"
  LReturnLocation := AParser.CurrentToken.Location;
  AParser.ConsumeToken(tkReturn);
  
  // Optional return expression (for functions)
  LReturnExpression := nil;
  if not AParser.MatchToken(tkSemicolon) then
  begin
    // Parse return value expression
    LReturnExpression := ParseExpression(AParser);
  end;
  
  Result := TCPReturnStatementNode.Create(LReturnLocation, LReturnExpression);
end;

end.
