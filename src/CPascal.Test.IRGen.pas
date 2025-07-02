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

unit CPascal.Test.IRGen;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  System.RegularExpressions,
  CPascal.Lexer,
  CPascal.Parser,
  CPascal.AST,
  CPascal.Semantic,
  CPascal.IRGen;

type
  [TestFixture]
  TTestIRGenerator = class
  public
    [Test]
    procedure TestSimpleAssignment();
    [Test]
    procedure TestSimpleExpression();
  end;

implementation

procedure TTestIRGenerator.TestSimpleAssignment;
var
  LLexer: TCPLexer;
  LParser: TCPParser;
  LAST: TCPASTNode;
  LAnalyzer: TCPSemanticAnalyzer;
  LIRGenerator: TCPIRGenerator;
  LIR: string;
begin
  // MODIFIED: Replaced 'Integer' with 'Int32'.
  LLexer := TCPLexer.Create('program Test; var a: Int32; begin a := 10; end.');
  LParser := TCPParser.Create(LLexer);
  LAST := LParser.Parse();
  LAnalyzer := TCPSemanticAnalyzer.Create();
  LAnalyzer.Check(LAST);
  LIRGenerator := TCPIRGenerator.Create(LAnalyzer.FSymbolTable);
  try
    LIRGenerator.Generate(LAST);
    LIR := LIRGenerator.IRToString();

    Assert.IsTrue(LIR.Contains('; ModuleID = ''Test'''), 'ModuleID is incorrect.');
    Assert.IsTrue(LIR.Contains('define i32 @main()'), 'Main function definition is missing.');
    Assert.IsTrue(TRegEx.IsMatch(LIR, '%a\s*=\s*alloca i32'), 'Allocation for variable "a" not found.');
    Assert.IsTrue(TRegEx.IsMatch(LIR, 'store i32 10, ptr %a'), 'Store instruction for assignment not found.');
    Assert.IsTrue(LIR.Contains('ret i32 0'), 'Main function should return 0.');
  finally
    LIRGenerator.Free;
    LAnalyzer.Free;
    LAST.Free;
    LParser.Free;
    LLexer.Free;
  end;
end;

procedure TTestIRGenerator.TestSimpleExpression;
var
  LLexer: TCPLexer;
  LParser: TCPParser;
  LAST: TCPASTNode;
  LAnalyzer: TCPSemanticAnalyzer;
  LIRGenerator: TCPIRGenerator;
  LIR: string;
begin
  // MODIFIED: Replaced 'Integer' with 'Int32'.
  LLexer := TCPLexer.Create('program Test; var a, b, c: Int32; begin a := b + c; end.');
  LParser := TCPParser.Create(LLexer);
  LAST := LParser.Parse();
  LAnalyzer := TCPSemanticAnalyzer.Create();
  LAnalyzer.Check(LAST);
  LIRGenerator := TCPIRGenerator.Create(LAnalyzer.FSymbolTable);
  try
    LIRGenerator.Generate(LAST);
    LIR := LIRGenerator.IRToString();

    Assert.IsTrue(TRegEx.IsMatch(LIR, '%b_val\w*\s*=\s*load i32, ptr %b'), 'Load for "b" is missing');
    Assert.IsTrue(TRegEx.IsMatch(LIR, '%c_val\w*\s*=\s*load i32, ptr %c'), 'Load for "c" is missing');
    Assert.IsTrue(TRegEx.IsMatch(LIR, '%addtmp\w*\s*=\s*add nsw i32 %b_val\w*, %c_val\w*'), 'Add instruction not found.');
    Assert.IsTrue(TRegEx.IsMatch(LIR, 'store i32 %addtmp\w*, ptr %a'), 'Store instruction for result not found.');
  finally
    LIRGenerator.Free;
    LAnalyzer.Free;
    LAST.Free;
    LParser.Free;
    LLexer.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestIRGenerator);

end.
