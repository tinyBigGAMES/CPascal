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

unit CPascal.Test.Parser;

interface

uses
  System.SysUtils,
  System.TypInfo,
  DUnitX.TestFramework,
  CPascal.Lexer,
  CPascal.Parser,
  CPascal.AST;

type
  [TestFixture]
  TTestParser = class
  public
    [Test]
    procedure TestEmptyProgram();
    [Test]
    procedure TestProgramWithVarDecl();
    [Test]
    procedure TestAssignmentStatement();
    [Test]
    procedure TestExpressionPrecedence();
  end;

implementation

procedure TTestParser.TestEmptyProgram;
var
  LLexer: TCPLexer;
  LParser: TCPParser;
  LAST: TCPASTNode;
begin
  LLexer := TCPLexer.Create('program Test; begin end.');
  LParser := TCPParser.Create(LLexer);
  try
    LAST := LParser.Parse();
    try
      Assert.IsTrue(LAST is TProgramNode, 'Root node should be TProgramNode');
      Assert.AreEqual('Test', TProgramNode(LAST).ProgramName.Name, 'Program name mismatch');
      Assert.AreEqual(0, Integer(TProgramNode(LAST).Declarations.Count), 'Should have no declarations');
      Assert.IsNotNull(TProgramNode(LAST).CompoundStatement, 'Body should not be nil');
      Assert.AreEqual(0, Integer(TProgramNode(LAST).CompoundStatement.Statements.Count), 'Body should have no statements');
    finally
      LAST.Free;
    end;
  finally
    LParser.Free;
    LLexer.Free;
  end;
end;

procedure TTestParser.TestProgramWithVarDecl;
var
  LLexer: TCPLexer;
  LParser: TCPParser;
  LAST: TCPASTNode;
  LVarSection: TVarSectionNode;
  LVarDecl: TVarDeclNode;
begin
  // MODIFIED: Replaced 'Integer' with 'Int32' in the test source code.
  LLexer := TCPLexer.Create('program Test; var x: Int32; begin end.');
  LParser := TCPParser.Create(LLexer);
  try
    LAST := LParser.Parse();
    try
      Assert.IsTrue(LAST is TProgramNode);
      Assert.AreEqual(1, Integer(TProgramNode(LAST).Declarations.Count));
      Assert.IsTrue(TProgramNode(LAST).Declarations[0] is TVarSectionNode);

      LVarSection := TProgramNode(LAST).Declarations[0] as TVarSectionNode;
      Assert.AreEqual(1, Integer(LVarSection.Declarations.Count));

      LVarDecl := LVarSection.Declarations[0];
      Assert.AreEqual(1, Integer(LVarDecl.Identifiers.Count));
      Assert.AreEqual('x', LVarDecl.Identifiers[0].Name);
      Assert.IsTrue(LVarDecl.TypeSpec is TTypeNameNode);
      // MODIFIED: Updated assertion to check for 'Int32' instead of 'Integer'.
      Assert.AreEqual('Int32', TTypeNameNode(LVarDecl.TypeSpec).Identifier.Name);
    finally
      LAST.Free;
    end;
  finally
    LParser.Free;
    LLexer.Free;
  end;
end;

procedure TTestParser.TestAssignmentStatement;
var
  LLexer: TCPLexer;
  LParser: TCPParser;
  LAST: TCPASTNode;
  LStatement: TStatementNode;
  LAssignment: TAssignmentNode;
begin
  LLexer := TCPLexer.Create('program Test; begin a := 10; end.');
  LParser := TCPParser.Create(LLexer);
  try
    LAST := LParser.Parse();
    try
      LStatement := TProgramNode(LAST).CompoundStatement.Statements[0];
      Assert.IsTrue(LStatement is TAssignmentNode, 'Statement should be an assignment');

      LAssignment := LStatement as TAssignmentNode;
      Assert.IsTrue(LAssignment.Variable is TIdentifierNode);
      Assert.AreEqual('a', TIdentifierNode(LAssignment.Variable).Name);
      Assert.IsTrue(LAssignment.Expression is TIntegerLiteralNode);
      Assert.AreEqual(10, Integer(TIntegerLiteralNode(LAssignment.Expression).Value));
    finally
      LAST.Free;
    end;
  finally
    LParser.Free;
    LLexer.Free;
  end;
end;

procedure TTestParser.TestExpressionPrecedence;
var
  LLexer: TCPLexer;
  LParser: TCPParser;
  LAST: TCPASTNode;
  LAssignment: TAssignmentNode;
  LRootExpr, LRightExpr: TBinaryOpNode;
begin
  LLexer := TCPLexer.Create('program Test; begin a := 5 + 2 * 3; end.');
  LParser := TCPParser.Create(LLexer);
  try
    LAST := LParser.Parse();
    try
      LAssignment := TProgramNode(LAST).CompoundStatement.Statements[0] as TAssignmentNode;
      Assert.IsTrue(LAssignment.Expression is TBinaryOpNode, 'Root of expression should be a binary op');

      LRootExpr := LAssignment.Expression as TBinaryOpNode;
      Assert.AreEqual(tkPlus, LRootExpr.Operator, 'Root operator should be +');
      Assert.IsTrue(LRootExpr.Left is TIntegerLiteralNode, 'Left operand should be an integer');

      Assert.IsTrue(LRootExpr.Right is TBinaryOpNode, 'Right operand should be a binary op for precedence');
      LRightExpr := LRootExpr.Right as TBinaryOpNode;
      Assert.AreEqual(tkAsterisk, LRightExpr.Operator, 'Sub-expression operator should be *');
    finally
      LAST.Free;
    end;
  finally
    LParser.Free;
    LLexer.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestParser);

end.
