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

unit CPascal.Lexer;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type
  { All possible token kinds, including keywords, symbols, literals, and control tokens. }
  TCPTokenKind = (
    // Control Tokens
    tkUnknown,
    tkEndOfFile,

    // Identifiers and Literals
    tkIdentifier,
    tkInteger, // This is for integer literals like '123'
    tkReal,
    tkString,
    tkCharacter,

    // Keywords
    tkProgram, tkLibrary, tkModule,
    tkImport, tkExports,
    tkConst, tkType, tkVar, tkLabel,
    tkFunction, tkProcedure,
    tkRecord, tkUnion, tkPacked, tkEnum,
    tkArray, tkOf,
    tkBegin, tkEnd,
    tkIf, tkThen, tkElse,
    tkCase,

    tkFor, tkTo, tkDownto, tkDo,
    tkWhile, tkRepeat, tkUntil,
    tkGoto,
    tkAsm,
    tkInline, tkExternal,
    tkPublic,
    tkCdecl, tkStdcall, tkFastcall, tkRegister,

    // NEW: Standard Type Keywords from BNF
    tkInt8, tkUInt8, tkInt16, tkUInt16, tkInt32, tkUInt32, tkInt64, tkUInt64,
    tkSingle, tkDouble, tkBoolean, tkChar, tkPointer, tkNativeInt, tkNativeUInt, tkPChar,

    // Operators and Symbols
    tkPlus, tkMinus, tkAsterisk, tkSlash,
    tkAssign, tkPlusAssign, tkMinusAssign, tkMulAssign, tkDivAssign,
    tkEqual, tkNotEqual, tkLessThan, tkLessEqual, tkGreaterThan, tkGreaterEqual,
    tkLParen, tkRParen, tkLBracket, tkRBracket,
    tkDot, tkComma, tkColon, tkSemicolon,
    tkCaret, tkAt, tkEllipsis,
    tkAmpersand, tkPipe,
    tkInc, tkDec,

    // Bitwise Operators
    tkAnd, tkOr, tkXor, tkNot, tkShl, tkShr,

    // Other Keywords
    tkDiv, tkMod,
    tkNil,
    tkTrue, tkFalse,
    tkSizeOf, tkTypeOf,
    tkBreak, tkContinue, tkExit,
    tkConstRef, tkVarRef, tkOut,
    tkVolatile,
    tkResult
  );

  { Represents a single token scanned from the source. }
  TCPToken = record
    Kind: TCPTokenKind;
    Value: string;
    Line: Integer;
    Column: Integer;
  end;

  { The Lexer class, responsible for tokenizing a source string. }
  TCPLexer = class
  private
    FSource: string;
    FSourceIndex: Integer;
    FCurrentChar: Char;
    FLine: Integer;
    FColumn: Integer;
    FKeywords: TDictionary<string, TCPTokenKind>;

    procedure Advance();
    function Peek(): Char;

    procedure SkipWhitespace();
    procedure SkipComment();

    function ReadIdentifier(): TCPToken;
    function ReadNumber(): TCPToken;
    function ReadHexNumber(): TCPToken;
    function ReadString(): TCPToken;
    function ReadCharacter(): TCPToken;

    function CreateToken(AKind: TCPTokenKind; AValue: string): TCPToken;
  public
    constructor Create(const ASource: string);
    destructor Destroy; override;

    function NextToken(): TCPToken;
  end;

implementation

uses
  System.TypInfo;

{ TCPLexer }

constructor TCPLexer.Create(const ASource: string);
begin
  inherited Create();
  FSource := ASource;
  FSourceIndex := 0;
  FLine := 1;
  FColumn := 1;
  FKeywords := TDictionary<string, TCPTokenKind>.Create;

  // Standard Keywords
  FKeywords.Add('PROGRAM', tkProgram);
  FKeywords.Add('VAR', tkVar);
  FKeywords.Add('BEGIN', tkBegin);
  FKeywords.Add('END', tkEnd);
  FKeywords.Add('IF', tkIf);
  FKeywords.Add('THEN', tkThen);
  FKeywords.Add('ELSE', tkElse);
  FKeywords.Add('FOR', tkFor);
  FKeywords.Add('TO', tkTo);
  FKeywords.Add('DOWNTO', tkDownto);
  FKeywords.Add('DO', tkDo);
  FKeywords.Add('WHILE', tkWhile);
  FKeywords.Add('REPEAT', tkRepeat);
  FKeywords.Add('UNTIL', tkUntil);
  FKeywords.Add('AND', tkAnd);
  FKeywords.Add('TRUE', tkTrue);
  FKeywords.Add('FALSE', tkFalse);

  // Type Keywords
  FKeywords.Add('INT8', tkInt8);
  FKeywords.Add('UINT8', tkUInt8);
  FKeywords.Add('INT16', tkInt16);
  FKeywords.Add('UINT16', tkUInt16);
  FKeywords.Add('INT32', tkInt32);
  FKeywords.Add('UINT32', tkUInt32);
  FKeywords.Add('INT64', tkInt64);
  FKeywords.Add('UINT64', tkUInt64);
  FKeywords.Add('SINGLE', tkSingle);
  FKeywords.Add('DOUBLE', tkDouble);
  FKeywords.Add('BOOLEAN', tkBoolean);
  FKeywords.Add('CHAR', tkChar);
  FKeywords.Add('POINTER', tkPointer);

  if Length(FSource) > 0 then
    FCurrentChar := FSource[1]
  else
    FCurrentChar := #0;
end;

destructor TCPLexer.Destroy;
begin
  FKeywords.Free;
  inherited Destroy;
end;

procedure TCPLexer.Advance();
begin
  if FCurrentChar = #10 then
  begin
    Inc(FLine);
    FColumn := 1;
  end
  else
  begin
    Inc(FColumn);
  end;

  Inc(FSourceIndex);
  if FSourceIndex >= Length(FSource) then
    FCurrentChar := #0
  else
    FCurrentChar := FSource[FSourceIndex + 1];
end;

function TCPLexer.Peek(): Char;
begin
  if (FSourceIndex + 1) < Length(FSource) then
    Result := FSource[FSourceIndex + 2]
  else
    Result := #0;
end;

procedure TCPLexer.SkipWhitespace();
begin
  while (FCurrentChar <> #0) and (CharInSet(FCurrentChar, [' ', #9, #10, #13, #$0B, #$0C])) do
  begin
    Advance();
  end;
end;

procedure TCPLexer.SkipComment();
begin
  if (FCurrentChar = '/') and (Peek() = '/') then
  begin
    while (FCurrentChar <> #0) and (FCurrentChar <> #10) do
      Advance();
    Exit;
  end;

  if FCurrentChar = '{' then
  begin
    Advance();
    while (FCurrentChar <> #0) and (FCurrentChar <> '}') do
      Advance();
    if FCurrentChar <> #0 then Advance();
    Exit;
  end;
end;

function TCPLexer.CreateToken(AKind: TCPTokenKind; AValue: string): TCPToken;
begin
  Result.Kind := AKind;
  Result.Value := AValue;
  Result.Line := FLine;
  Result.Column := FColumn;
end;

function TCPLexer.ReadIdentifier(): TCPToken;
var
  LStartCol: Integer;
  LIdent: string;
  LTokenKind: TCPTokenKind;
begin
  LStartCol := FColumn;
  LIdent := '';
  while (FCurrentChar <> #0) and (CharInSet(FCurrentChar,  ['a'..'z', 'A'..'Z', '0'..'9', '_'])) do
  begin
    LIdent := LIdent + FCurrentChar;
    Advance();
  end;

  Result := CreateToken(tkIdentifier, LIdent);
  Result.Column := LStartCol;

  if FKeywords.TryGetValue(LIdent.ToUpper, LTokenKind) then
  begin
    Result.Kind := LTokenKind;
  end;
end;

function TCPLexer.ReadNumber(): TCPToken;
var
  LStartCol: Integer;
  LNumberStr: string;
  LIsReal: Boolean;
begin
  LStartCol := FColumn;
  LNumberStr := '';
  LIsReal := False;

  if (FCurrentChar = '0') and (UpCase(Peek()) = 'X') then
  begin
    LNumberStr := '0x';
    Advance(); // consume '0'
    Advance(); // consume 'x'
    while (FCurrentChar <> #0) and (CharInSet(UpCase(FCurrentChar), ['0'..'9', 'A'..'F'])) do
    begin
        LNumberStr := LNumberStr + FCurrentChar;
        Advance();
    end;
    Result := CreateToken(tkInteger, LNumberStr);
    Result.Column := LStartCol;
    Exit;
  end;

  while CharInSet(FCurrentChar, ['0'..'9']) do
  begin
    LNumberStr := LNumberStr + FCurrentChar;
    Advance();
  end;

  if (FCurrentChar = '.') and (Peek() <> '.') then
  begin
    LIsReal := True;
    LNumberStr := LNumberStr + FCurrentChar;
    Advance();
    while CharInSet(FCurrentChar, ['0'..'9']) do
    begin
      LNumberStr := LNumberStr + FCurrentChar;
      Advance();
    end;
  end;

  if UpCase(FCurrentChar) = 'E' then
  begin
    LIsReal := True;
    LNumberStr := LNumberStr + FCurrentChar;
    Advance();
    if (FCurrentChar = '+') or (FCurrentChar = '-') then
    begin
      LNumberStr := LNumberStr + FCurrentChar;
      Advance();
    end;
    while CharInSet(FCurrentChar, ['0'..'9']) do
    begin
      LNumberStr := LNumberStr + FCurrentChar;
      Advance();
    end;
  end;

  if LIsReal then
    Result := CreateToken(tkReal, LNumberStr)
  else
    Result := CreateToken(tkInteger, LNumberStr);

  Result.Column := LStartCol;
end;

function TCPLexer.ReadHexNumber(): TCPToken;
var
  LStartCol: Integer;
  LHexStr: string;
begin
  LStartCol := FColumn;
  LHexStr := '$';
  Advance(); // consume '$'

  while (FCurrentChar <> #0) and (CharInSet(UpCase(FCurrentChar), ['0'..'9', 'A'..'F'])) do
  begin
    LHexStr := LHexStr + FCurrentChar;
    Advance();
  end;

  Result := CreateToken(tkInteger, LHexStr);
  Result.Column := LStartCol;
end;

function TCPLexer.ReadString(): TCPToken;
var
  LStartCol: Integer;
  LStr: string;
begin
  LStartCol := FColumn;
  Advance();
  LStr := '';
  while (FCurrentChar <> #0) and (FCurrentChar <> '"') do
  begin
    LStr := LStr + FCurrentChar;
    Advance();
  end;
  Advance();
  Result := CreateToken(tkString, LStr);
  Result.Column := LStartCol;
end;

function TCPLexer.ReadCharacter(): TCPToken;
var
  LStartCol: Integer;
  LNumStr: string;
begin
  LStartCol := FColumn;
  Advance();
  LNumStr := '';
  while CharInSet(FCurrentChar, ['0'..'9']) do
  begin
    LNumStr := LNumStr + FCurrentChar;
    Advance();
  end;
  Result := CreateToken(tkCharacter, LNumStr);
  Result.Column := LStartCol;
end;

function TCPLexer.NextToken(): TCPToken;
begin
  while FCurrentChar <> #0 do
  begin
    SkipWhitespace();

    if FCurrentChar = #0 then break;

    if ((FCurrentChar = '/') and ((Peek() = '/') or (Peek() = '*'))) or (FCurrentChar = '{') then
    begin
      SkipComment();
      Continue;
    end;

    if CharInSet(FCurrentChar, ['a'..'z', 'A'..'Z', '_']) then Exit(ReadIdentifier());
    if CharInSet(FCurrentChar, ['0'..'9']) then Exit(ReadNumber());
    if FCurrentChar = '$' then Exit(ReadHexNumber());
    if FCurrentChar = '"' then Exit(ReadString());
    if FCurrentChar = '#' then Exit(ReadCharacter());

    Result := CreateToken(tkUnknown, FCurrentChar);
    Result.Column := FColumn;

    case FCurrentChar of
      '+': begin Advance(); Result.Value := '+'; Result.Kind := tkPlus; end;
      '-': begin Advance(); Result.Value := '-'; Result.Kind := tkMinus; end;
      '*': begin Advance(); Result.Value := '*'; Result.Kind := tkAsterisk; end;
      '/': begin Advance(); Result.Value := '/'; Result.Kind := tkSlash; end;
      ':': begin Advance(); if FCurrentChar = '=' then begin Advance(); Result.Value := ':='; Result.Kind := tkAssign; end else begin Result.Value := ':'; Result.Kind := tkColon; end; end;
      '=': begin Advance(); Result.Value := '='; Result.Kind := tkEqual; end;
      '<': begin Advance(); if FCurrentChar = '>' then begin Advance(); Result.Value := '<>'; Result.Kind := tkNotEqual; end else if FCurrentChar = '=' then begin Advance(); Result.Value := '<='; Result.Kind := tkLessEqual; end else begin Result.Value := '<'; Result.Kind := tkLessThan; end; end;
      '>': begin Advance(); if FCurrentChar = '=' then begin Advance(); Result.Value := '>='; Result.Kind := tkGreaterEqual; end else begin Result.Value := '>'; Result.Kind := tkGreaterThan; end; end;
      '(': begin Advance(); Result.Value := '('; Result.Kind := tkLParen; end;
      ')': begin Advance(); Result.Value := ')'; Result.Kind := tkRParen; end;
      '[': begin Advance(); Result.Value := '['; Result.Kind := tkLBracket; end;
      ']': begin Advance(); Result.Value := ']'; Result.Kind := tkRBracket; end;
      '.': begin Advance(); Result.Value := '.'; Result.Kind := tkDot; end;
      ',': begin Advance(); Result.Value := ','; Result.Kind := tkComma; end;
      ';': begin Advance(); Result.Value := ';'; Result.Kind := tkSemicolon; end;
      '^': begin Advance(); Result.Value := '^'; Result.Kind := tkCaret; end;
      '@': begin Advance(); Result.Value := '@'; Result.Kind := tkAt; end;
    else
      Advance();
    end;
    Exit(Result);
  end;

  Result := CreateToken(tkEndOfFile, '');
  Result.Column := FColumn;
end;

end.
