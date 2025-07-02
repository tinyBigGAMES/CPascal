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

unit CPascal.Test.Semantic;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  CPascal.Common,
  CPascal.Lexer,
  CPascal.Parser,
  CPascal.AST,
  CPascal.Semantic;

type
  [TestFixture]
  TTestSemanticAnalyzer = class
  public
    [Test]
    procedure TestValidAssignment();
    [Test]
    procedure TestUndeclaredIdentifier();
    [Test]
    procedure TestTypeMismatch();
    [Test]
    procedure TestDuplicateIdentifier();
  end;

implementation

procedure TTestSemanticAnalyzer.TestValidAssignment;
var
  LLexer: TCPLexer;
  LParser: TCPParser;
  LAST: TCPASTNode;
  LAnalyzer: TCPSemanticAnalyzer;
  LSymbolTable: TCPSymbolTable;
begin
  LLexer := TCPLexer.Create('program Test; var a: Int32; begin a := 10; end.');
  LParser := TCPParser.Create(LLexer);
  LAST := LParser.Parse();
  LSymbolTable := TCPSymbolTable.Create();
  LAnalyzer := TCPSemanticAnalyzer.Create(LSymbolTable);
  try
    LAnalyzer.Check(LAST);
    Assert.Pass('Valid code analyzed without exceptions.');
  finally
    LAnalyzer.Free;
    LSymbolTable.Free;
    LAST.Free;
    LParser.Free;
    LLexer.Free;
  end;
end;

procedure TTestSemanticAnalyzer.TestUndeclaredIdentifier;
var
  LLexer: TCPLexer;
  LParser: TCPParser;
  LAST: TCPASTNode;
  LAnalyzer: TCPSemanticAnalyzer;
  LSymbolTable: TCPSymbolTable;
begin
  Assert.WillRaise(
    procedure
    begin
      LLexer := TCPLexer.Create('program Test; begin a := 10; end.');
      LParser := TCPParser.Create(LLexer);
      LAST := LParser.Parse();
      LSymbolTable := TCPSymbolTable.Create();
      LAnalyzer := TCPSemanticAnalyzer.Create(LSymbolTable);
      try
        LAnalyzer.Check(LAST);
      finally
        LAnalyzer.Free;
        LSymbolTable.Free;
        LAST.Free;
        LParser.Free;
        LLexer.Free;
      end;
    end,
    ECPCompilerError, 'Undeclared identifier "a"');
end;

procedure TTestSemanticAnalyzer.TestTypeMismatch;
var
  LLexer: TCPLexer;
  LParser: TCPParser;
  LAST: TCPASTNode;
  LAnalyzer: TCPSemanticAnalyzer;
  LSymbolTable: TCPSymbolTable;
begin
  Assert.WillRaise(
    procedure
    begin
      LLexer := TCPLexer.Create('program Test; var a: Int32; b: Double; begin a := b; end.');
      LParser := TCPParser.Create(LLexer);
      LAST := LParser.Parse();
      LSymbolTable := TCPSymbolTable.Create();
      LAnalyzer := TCPSemanticAnalyzer.Create(LSymbolTable);
      try
        LAnalyzer.Check(LAST);
      finally
        LAnalyzer.Free;
        LSymbolTable.Free;
        LAST.Free;
        LParser.Free;
        LLexer.Free;
      end;
    end,
    ECPCompilerError, 'Type mismatch: Cannot assign DOUBLE to INT32');
end;

procedure TTestSemanticAnalyzer.TestDuplicateIdentifier;
var
  LLexer: TCPLexer;
  LParser: TCPParser;
  LAST: TCPASTNode;
  LAnalyzer: TCPSemanticAnalyzer;
  LSymbolTable: TCPSymbolTable;
begin
  Assert.WillRaise(
    procedure
    begin
      LLexer := TCPLexer.Create('program Test; var a: Int32; a: Double; begin end.');
      LParser := TCPParser.Create(LLexer);
      LAST := LParser.Parse();
      LSymbolTable := TCPSymbolTable.Create();
      LAnalyzer := TCPSemanticAnalyzer.Create(LSymbolTable);
      try
        LAnalyzer.Check(LAST);
      finally
        LAnalyzer.Free;
        LSymbolTable.Free;
        LAST.Free;
        LParser.Free;
        LLexer.Free;
      end;
    end,
    ECPCompilerError, 'Duplicate identifier in same scope: a');
end;

initialization
  TDUnitX.RegisterTestFixture(TTestSemanticAnalyzer);

end.
