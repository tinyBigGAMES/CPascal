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

unit CPascal.Parser;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  CPascal.Exception,
  CPascal.Lexer,
  CPascal.AST,
  CPascal.AST.CompilationUnit,
  CPascal.CodeGen.SymbolTable; // NEW: For parse-time symbol tracking

type

  { TCPParser }
  TCPParser = class
  private
    FLexer: TCPLexer;
    FCurrentToken: TCPToken;
    FPeekToken: TCPToken;
    FHasPeeked: Boolean;
    FSymbolTable: TCPSymbolTable; // NEW: Parse-time symbol table for validation

  public
    constructor Create(const ALexer: TCPLexer);
    destructor Destroy(); override;

    procedure AdvanceToken();
    function  PeekNextToken(): TCPToken;
    function  MatchToken(const AExpectedKind: TCPTokenKind): Boolean;
    function  ConsumeToken(const AExpectedKind: TCPTokenKind): TCPToken;
    function  ConsumeTokenWithValue(const AExpectedKind: TCPTokenKind; const AExpectedValue: string): TCPToken;
    procedure ParseError(const AMessage: string; const AArgs: array of const);
    procedure UnexpectedToken(const AExpected: string);
    function  TokenKindToCallingConvention(const ATokenKind: TCPTokenKind): TCPCallingConvention;
    function  Parse(): TCPCompilationUnitNode;

    property CurrentToken: TCPToken read FCurrentToken;
    property SymbolTable: TCPSymbolTable read FSymbolTable; // NEW: Expose symbol table
  end;

implementation

uses
  CPascal.Parser.CompilationUnit;


{ TCPParser }
constructor TCPParser.Create(const ALexer: TCPLexer);
begin
  inherited Create;
  FLexer := ALexer;
  FHasPeeked := False;
  FSymbolTable := TCPSymbolTable.Create; // NEW: Create parse-time symbol table

  // Initialize with first token
  AdvanceToken();
end;

destructor TCPParser.Destroy();
begin
  FSymbolTable.Free; // NEW: Free symbol table
  inherited;
end;

procedure TCPParser.AdvanceToken();
begin
  if FHasPeeked then
  begin
    FCurrentToken := FPeekToken;
    FHasPeeked := False;
  end
  else
  begin
    FCurrentToken := FLexer.GetNextToken();
  end;
end;

function TCPParser.PeekNextToken(): TCPToken;
begin
  if not FHasPeeked then
  begin
    FPeekToken := FLexer.GetNextToken();
    FHasPeeked := True;
  end;
  Result := FPeekToken;
end;

function TCPParser.MatchToken(const AExpectedKind: TCPTokenKind): Boolean;
begin
  Result := FCurrentToken.Kind = AExpectedKind;
end;

function TCPParser.ConsumeToken(const AExpectedKind: TCPTokenKind): TCPToken;
begin
  if FCurrentToken.Kind = AExpectedKind then
  begin
    Result := FCurrentToken;
    AdvanceToken();
  end
  else
  begin
    UnexpectedToken(CPTokenKindToString(AExpectedKind));
    Result := FCurrentToken; // Return current token as fallback
  end;
end;

function TCPParser.ConsumeTokenWithValue(const AExpectedKind: TCPTokenKind; const AExpectedValue: string): TCPToken;
begin
  if (FCurrentToken.Kind = AExpectedKind) and (FCurrentToken.Value = AExpectedValue) then
  begin
    Result := FCurrentToken;
    AdvanceToken();
  end
  else
  begin
    UnexpectedToken(Format('%s "%s"', [CPTokenKindToString(AExpectedKind), AExpectedValue]));
    Result := FCurrentToken; // Return current token as fallback
  end;
end;

procedure TCPParser.ParseError(const AMessage: string; const AArgs: array of const);
begin
  raise ECPException.Create(
    AMessage,
    AArgs,
    FLexer.FileName,
    FCurrentToken.Location.Line,
    FCurrentToken.Location.Column
  );
end;

procedure TCPParser.UnexpectedToken(const AExpected: string);
begin
  ParseError('Expected %s, but found %s "%s"', [AExpected, CPTokenKindToString(FCurrentToken.Kind), FCurrentToken.Value]);
end;

function TCPParser.TokenKindToCallingConvention(const ATokenKind: TCPTokenKind): TCPCallingConvention;
begin
  case ATokenKind of
    tkCdecl: Result := ccCdecl;
    tkStdcall: Result := ccStdcall;
    tkFastcall: Result := ccFastcall;
    tkRegister: Result := ccRegister;
  else
    Result := ccDefault;
  end;
end;

function TCPParser.Parse(): TCPCompilationUnitNode;
begin
  // Parse according to BNF: <compilation_unit> ::= <program> | <library> | <module>
  Result := ParseCompilationUnit(Self);
end;

end.
