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

unit CPascal.Test.Lexer;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  CPascal.Lexer;

type
  [TestFixture]
  TTestLexer = class
  public
    // Structural Keywords
    [Test]
    procedure Test_Program_Keyword();
    [Test]
    procedure Test_BeginEnd_Keywords();

    // Literals
    [Test]
    procedure Test_IntegerLiteral_Decimal();
    [Test]
    procedure Test_IntegerLiteral_Hex_DollarPrefix();
    [Test]
    procedure Test_IntegerLiteral_Hex_0xPrefix();

    // Operators
    [Test]
    procedure Test_Assignment_Operator();
    [Test]
    procedure Test_Arithmetic_Operators();

    [Test]
    procedure Test_Comparison_Operators;

    // Comments
    [Test]
    procedure Test_LineComment_IsSkipped();
    [Test]
    procedure Test_BraceComment_IsSkipped();
  end;

implementation

procedure TTestLexer.Test_Program_Keyword;
var
  LLexer: TCPLexer;
  LToken: TCPToken;
begin
  LLexer := TCPLexer.Create('program');
  try
    LToken := LLexer.NextToken();
    Assert.AreEqual(Ord(tkProgram), Ord(LToken.Kind));
    Assert.AreEqual('program', LToken.Value.ToLower);

    LToken := LLexer.NextToken();
    Assert.AreEqual(Ord(tkEndOfFile), Ord(LToken.Kind));
  finally
    LLexer.Free;
  end;
end;

procedure TTestLexer.Test_BeginEnd_Keywords;
var
  LLexer: TCPLexer;
begin
  LLexer := TCPLexer.Create('begin end');
  try
    Assert.AreEqual(Ord(tkBegin), Ord(LLexer.NextToken().Kind));
    Assert.AreEqual(Ord(tkEnd), Ord(LLexer.NextToken().Kind));
    Assert.AreEqual(Ord(tkEndOfFile), Ord(LLexer.NextToken().Kind));
  finally
    LLexer.Free;
  end;
end;

procedure TTestLexer.Test_IntegerLiteral_Decimal;
var
  LLexer: TCPLexer;
  LToken: TCPToken;
begin
  LLexer := TCPLexer.Create('12345');
  try
    LToken := LLexer.NextToken();
    Assert.AreEqual(Ord(tkInteger), Ord(LToken.Kind));
    Assert.AreEqual('12345', LToken.Value);

    LToken := LLexer.NextToken();
    Assert.AreEqual(Ord(tkEndOfFile), Ord(LToken.Kind));
  finally
    LLexer.Free;
  end;
end;

procedure TTestLexer.Test_IntegerLiteral_Hex_DollarPrefix;
var
  LLexer: TCPLexer;
  LToken: TCPToken;
begin
  LLexer := TCPLexer.Create('$FF');
  try
    LToken := LLexer.NextToken();
    Assert.AreEqual(Ord(tkInteger), Ord(LToken.Kind));
    Assert.AreEqual('$FF', LToken.Value);

    LToken := LLexer.NextToken();
    Assert.AreEqual(Ord(tkEndOfFile), Ord(LToken.Kind));
  finally
    LLexer.Free;
  end;
end;

procedure TTestLexer.Test_IntegerLiteral_Hex_0xPrefix;
var
  LLexer: TCPLexer;
  LToken: TCPToken;
begin
  LLexer := TCPLexer.Create('0xBEAD');
  try
    LToken := LLexer.NextToken();
    Assert.AreEqual(Ord(tkInteger), Ord(LToken.Kind));
    Assert.AreEqual('0xBEAD', LToken.Value);

    LToken := LLexer.NextToken();
    Assert.AreEqual(Ord(tkEndOfFile), Ord(LToken.Kind));
  finally
    LLexer.Free;
  end;
end;

procedure TTestLexer.Test_Assignment_Operator;
var
  LLexer: TCPLexer;
  LToken: TCPToken;
begin
  LLexer := TCPLexer.Create(':=');
  try
    LToken := LLexer.NextToken();
    Assert.AreEqual(Ord(tkAssign), Ord(LToken.Kind));
    Assert.AreEqual(':=', LToken.Value);

    LToken := LLexer.NextToken();
    Assert.AreEqual(Ord(tkEndOfFile), Ord(LToken.Kind));
  finally
    LLexer.Free;
  end;
end;

procedure TTestLexer.Test_Arithmetic_Operators;
var
  LLexer: TCPLexer;
begin
  LLexer := TCPLexer.Create('+ - *');
  try
    Assert.AreEqual(Ord(tkPlus), Ord(LLexer.NextToken().Kind));
    Assert.AreEqual(Ord(tkMinus), Ord(LLexer.NextToken().Kind));
    Assert.AreEqual(Ord(tkAsterisk), Ord(LLexer.NextToken().Kind));
    Assert.AreEqual(Ord(tkEndOfFile), Ord(LLexer.NextToken().Kind));
  finally
    LLexer.Free;
  end;
end;

procedure TTestLexer.Test_Comparison_Operators;
var
  LLexer: TCPLexer;
begin
  LLexer := TCPLexer.Create('= <>');
  try
    Assert.AreEqual(Ord(tkEqual), Ord(LLexer.NextToken().Kind));
    Assert.AreEqual(Ord(tkNotEqual), Ord(LLexer.NextToken().Kind));
    Assert.AreEqual(Ord(tkEndOfFile), Ord(LLexer.NextToken().Kind));
  finally
    LLexer.Free;
  end;
end;

procedure TTestLexer.Test_LineComment_IsSkipped;
var
  LLexer: TCPLexer;
  LToken: TCPToken;
begin
  LLexer := TCPLexer.Create('var // this is a comment');
  try
    LToken := LLexer.NextToken();
    Assert.AreEqual(Ord(tkVar), Ord(LToken.Kind));

    LToken := LLexer.NextToken();
    Assert.AreEqual(Ord(tkEndOfFile), Ord(LToken.Kind));
  finally
    LLexer.Free;
  end;
end;

procedure TTestLexer.Test_BraceComment_IsSkipped;
var
  LLexer: TCPLexer;
  LToken: TCPToken;
begin
  LLexer := TCPLexer.Create('{ a comment } var');
  try
    LToken := LLexer.NextToken();
    Assert.AreEqual(Ord(tkVar), Ord(LToken.Kind));

    LToken := LLexer.NextToken();
    Assert.AreEqual(Ord(tkEndOfFile), Ord(LToken.Kind));
  finally
    LLexer.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestLexer);

end.
