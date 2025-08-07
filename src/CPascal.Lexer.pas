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

unit CPascal.Lexer;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  System.Character,
  CPascal.Exception;

type
  { TCPTokenKind - All token types from CPascal BNF specification }
  TCPTokenKind = (
    // Special tokens
    tkEOF,
    tkInvalid,
    
    // Literals
    tkIdentifier,
    tkIntegerLiteral,
    tkRealLiteral,
    tkStringLiteral,
    tkCharacterLiteral,
    
    // Keywords - Program structure
    tkProgram,
    tkLibrary,
    tkModule,
    tkImport,
    tkExports,
    
    // Keywords - Declarations
    tkConst,
    tkType,
    tkVar,
    tkFunction,
    tkProcedure,
    tkLabel,
    
    // Keywords - Visibility and modifiers
    tkPublic,
    tkExternal,
    tkInline,
    tkPacked,
    
    // Keywords - Parameter modifiers
    tkOut,
    
    // Keywords - Calling conventions
    tkCdecl,
    tkStdcall,
    tkFastcall,
    tkRegister,
    
    // Keywords - Type definitions
    tkRecord,
    tkUnion,
    tkArray,
    tkOf,
    
    // Keywords - Control structures
    tkBegin,
    tkEnd,
    tkIf,
    tkThen,
    tkElse,
    tkCase,
    tkWhile,
    tkDo,
    tkFor,
    tkTo,
    tkDownto,
    tkRepeat,
    tkUntil,
    tkGoto,
    tkBreak,
    tkContinue,
    tkReturn,
    
    // Keywords - Inline assembly
    tkAsm,
    
    // Keywords - Literals and constants
    tkNil,
    tkTrue,
    tkFalse,
    
    // Keywords - Operators (word-based)
    tkAnd,
    tkOr,
    tkXor,
    tkNot,
    tkDiv,
    tkMod,
    tkShl,
    tkShr,
    
    // Keywords - Built-in functions
    tkSizeOf,
    tkTypeOf,
    
    // Operators - Arithmetic
    tkPlus,           // +
    tkMinus,          // -
    tkMultiply,       // *
    tkDivide,         // /
    
    // Operators - Assignment
    tkAssign,         // :=
    tkPlusAssign,     // +=
    tkMinusAssign,    // -=
    tkMultiplyAssign, // *=
    tkDivideAssign,   // /=
    tkAndAssign,      // and=
    tkOrAssign,       // or=
    tkXorAssign,      // xor=
    tkShlAssign,      // shl=
    tkShrAssign,      // shr=
    
    // Operators - Comparison
    tkEqual,          // =
    tkNotEqual,       // <>
    tkLessThan,       // <
    tkLessEqual,      // <=
    tkGreaterThan,    // >
    tkGreaterEqual,   // >=
    
    // Operators - Bitwise
    tkBitwiseAnd,     // &
    tkBitwiseOr,      // |
    
    // Operators - Unary/Postfix
    tkIncrement,      // ++
    tkDecrement,      // --
    tkAddressOf,      // @
    tkDereference,    // ^
    
    // Operators - Ternary
    tkQuestion,       // ?
    tkColon,          // :
    
    // Delimiters
    tkLeftParen,      // (
    tkRightParen,     // )
    tkLeftBracket,    // [
    tkRightBracket,   // ]
    tkLeftBrace,      // {
    tkRightBrace,     // }
    tkSemicolon,      // ;
    tkComma,          // ,
    tkDot,            // .
    tkEllipsis,       // ...
    
    // Compiler directives
    tkDirective       // {$...}
  );



  { TCPToken - Individual lexical token }
  TCPToken = record
    Kind: TCPTokenKind;
    Value: string;
    Location: TCPSourceLocation;
  end;

  { TCPLexer - CPascal lexical analyzer }
  TCPLexer = class
  private
    FSource: string;
    FPosition: Integer;
    FLine: Integer;
    FColumn: Integer;
    FStartPosition: Integer;
    FStartLine: Integer;
    FStartColumn: Integer;
    FCurrentChar: Char;
    FFileName: string;

    // Character navigation
    procedure AdvanceChar();
    function PeekChar(const AOffset: Integer = 1): Char;
    function IsAtEnd(): Boolean;

    // Token creation and positioning
    function CreateToken(const AKind: TCPTokenKind; const AValue: string = ''): TCPToken;
    function CreateLocation(): TCPSourceLocation;
    procedure MarkTokenStart();

    // Character classification
    function IsLetter(const AChar: Char): Boolean;
    function IsDigit(const AChar: Char): Boolean;
    function IsHexDigit(const AChar: Char): Boolean;
    function IsBinaryDigit(const AChar: Char): Boolean;
    function IsOctalDigit(const AChar: Char): Boolean;
    function IsAlphaNumeric(const AChar: Char): Boolean;
    function IsWhitespace(const AChar: Char): Boolean;

    // Token scanning methods
    function ScanIdentifierOrKeyword(): TCPToken;
    function ScanNumber(): TCPToken;
    function ScanString(): TCPToken;
    function ScanCharacter(): TCPToken;
    function ScanSingleQuotedCharacter(): TCPToken;
    function ScanLineComment(): TCPToken;
    function ScanBlockComment(): TCPToken;
    function ScanBraceComment(): TCPToken;
    function ScanDirective(): TCPToken;

    // Number scanning helpers
    function ScanDecimalInteger(): string;
    function ScanHexadecimalInteger(): string;
    function ScanBinaryInteger(): string;
    function ScanOctalInteger(): string;
    function ScanRealNumber(const AIntegerPart: string): string;
    function ScanExponent(): string;

    // String/character scanning helpers
    function ProcessEscapeSequence(): Char;
    function ProcessStringContent(): string;

    // Keyword recognition
    function GetKeywordTokenKind(const AIdentifier: string): TCPTokenKind;

    // Multi-character operator scanning
    function ScanOperator(): TCPToken;

    // Whitespace and newline handling
    procedure SkipWhitespace();
    procedure HandleNewline();

    // Error reporting
    procedure LexicalError(const AMessage: string; const AArgs: array of const);

  public
    constructor Create(const ASource: string; const AFileName: string = '<source>');

    function GetNextToken(): TCPToken;
    function PeekNextToken(): TCPToken;

    property FileName: string read FFileName;
    property CurrentLine: Integer read FLine;
    property CurrentColumn: Integer read FColumn;
    property CurrentPosition: Integer read FPosition;
  end;

function CPTokenKindToString(const ATokenKind: TCPTokenKind): string;
function CPCreateSourceLocation(const ALine: Integer; const AColumn: Integer; const APosition: Integer): TCPSourceLocation;

implementation

const
  // CPascal keywords lookup table - all keywords from BNF specification
  CPKeywords: array[0..54] of record
    Keyword: string;
    TokenKind: TCPTokenKind;
  end = (
    (Keyword: 'and'; TokenKind: tkAnd),
    (Keyword: 'array'; TokenKind: tkArray),
    (Keyword: 'asm'; TokenKind: tkAsm),
    (Keyword: 'begin'; TokenKind: tkBegin),
    (Keyword: 'break'; TokenKind: tkBreak),
    (Keyword: 'case'; TokenKind: tkCase),
    (Keyword: 'cdecl'; TokenKind: tkCdecl),
    (Keyword: 'const'; TokenKind: tkConst),
    (Keyword: 'continue'; TokenKind: tkContinue),
    (Keyword: 'div'; TokenKind: tkDiv),
    (Keyword: 'do'; TokenKind: tkDo),
    (Keyword: 'downto'; TokenKind: tkDownto),
    (Keyword: 'else'; TokenKind: tkElse),
    (Keyword: 'end'; TokenKind: tkEnd),
    (Keyword: 'return'; TokenKind: tkReturn),
    (Keyword: 'exports'; TokenKind: tkExports),
    (Keyword: 'external'; TokenKind: tkExternal),
    (Keyword: 'false'; TokenKind: tkFalse),
    (Keyword: 'fastcall'; TokenKind: tkFastcall),
    (Keyword: 'for'; TokenKind: tkFor),
    (Keyword: 'function'; TokenKind: tkFunction),
    (Keyword: 'goto'; TokenKind: tkGoto),
    (Keyword: 'if'; TokenKind: tkIf),
    (Keyword: 'import'; TokenKind: tkImport),
    (Keyword: 'inline'; TokenKind: tkInline),
    (Keyword: 'label'; TokenKind: tkLabel),
    (Keyword: 'library'; TokenKind: tkLibrary),
    (Keyword: 'mod'; TokenKind: tkMod),
    (Keyword: 'module'; TokenKind: tkModule),
    (Keyword: 'nil'; TokenKind: tkNil),
    (Keyword: 'not'; TokenKind: tkNot),
    (Keyword: 'of'; TokenKind: tkOf),
    (Keyword: 'or'; TokenKind: tkOr),
    (Keyword: 'out'; TokenKind: tkOut),
    (Keyword: 'packed'; TokenKind: tkPacked),
    (Keyword: 'procedure'; TokenKind: tkProcedure),
    (Keyword: 'program'; TokenKind: tkProgram),
    (Keyword: 'public'; TokenKind: tkPublic),
    (Keyword: 'record'; TokenKind: tkRecord),
    (Keyword: 'register'; TokenKind: tkRegister),
    (Keyword: 'repeat'; TokenKind: tkRepeat),
    (Keyword: 'shl'; TokenKind: tkShl),
    (Keyword: 'shr'; TokenKind: tkShr),
    (Keyword: 'SizeOf'; TokenKind: tkSizeOf),
    (Keyword: 'stdcall'; TokenKind: tkStdcall),
    (Keyword: 'then'; TokenKind: tkThen),
    (Keyword: 'to'; TokenKind: tkTo),
    (Keyword: 'true'; TokenKind: tkTrue),
    (Keyword: 'type'; TokenKind: tkType),
    (Keyword: 'TypeOf'; TokenKind: tkTypeOf),
    (Keyword: 'union'; TokenKind: tkUnion),
    (Keyword: 'until'; TokenKind: tkUntil),
    (Keyword: 'var'; TokenKind: tkVar),
    (Keyword: 'while'; TokenKind: tkWhile),
    (Keyword: 'xor'; TokenKind: tkXor)
  );

{ Global functions }

function CPTokenKindToString(const ATokenKind: TCPTokenKind): string;
begin
  case ATokenKind of
    tkEOF: Result := 'EOF';
    tkInvalid: Result := 'Invalid';
    tkIdentifier: Result := 'Identifier';
    tkIntegerLiteral: Result := 'Integer';
    tkRealLiteral: Result := 'Real';
    tkStringLiteral: Result := 'String';
    tkCharacterLiteral: Result := 'Character';
    tkProgram: Result := 'program';
    tkLibrary: Result := 'library';
    tkModule: Result := 'module';
    tkImport: Result := 'import';
    tkExports: Result := 'exports';
    tkConst: Result := 'const';
    tkType: Result := 'type';
    tkVar: Result := 'var';
    tkFunction: Result := 'function';
    tkProcedure: Result := 'procedure';
    tkLabel: Result := 'label';
    tkPublic: Result := 'public';
    tkExternal: Result := 'external';
    tkInline: Result := 'inline';
    tkPacked: Result := 'packed';
    tkCdecl: Result := 'cdecl';
    tkStdcall: Result := 'stdcall';
    tkFastcall: Result := 'fastcall';
    tkRegister: Result := 'register';
    tkRecord: Result := 'record';
    tkUnion: Result := 'union';
    tkArray: Result := 'array';
    tkOf: Result := 'of';
    tkBegin: Result := 'begin';
    tkEnd: Result := 'end';
    tkIf: Result := 'if';
    tkThen: Result := 'then';
    tkElse: Result := 'else';
    tkCase: Result := 'case';
    tkWhile: Result := 'while';
    tkDo: Result := 'do';
    tkFor: Result := 'for';
    tkTo: Result := 'to';
    tkDownto: Result := 'downto';
    tkRepeat: Result := 'repeat';
    tkUntil: Result := 'until';
    tkGoto: Result := 'goto';
    tkBreak: Result := 'break';
    tkContinue: Result := 'continue';
    tkReturn: Result := 'return';
    tkAsm: Result := 'asm';
    tkNil: Result := 'nil';
    tkTrue: Result := 'true';
    tkFalse: Result := 'false';
    tkAnd: Result := 'and';
    tkOr: Result := 'or';
    tkXor: Result := 'xor';
    tkNot: Result := 'not';
    tkOut: Result := 'out';
    tkDiv: Result := 'div';
    tkMod: Result := 'mod';
    tkShl: Result := 'shl';
    tkShr: Result := 'shr';
    tkSizeOf: Result := 'SizeOf';
    tkTypeOf: Result := 'TypeOf';
    tkPlus: Result := '+';
    tkMinus: Result := '-';
    tkMultiply: Result := '*';
    tkDivide: Result := '/';
    tkAssign: Result := ':=';
    tkPlusAssign: Result := '+=';
    tkMinusAssign: Result := '-=';
    tkMultiplyAssign: Result := '*=';
    tkDivideAssign: Result := '/=';
    tkAndAssign: Result := 'and=';
    tkOrAssign: Result := 'or=';
    tkXorAssign: Result := 'xor=';
    tkShlAssign: Result := 'shl=';
    tkShrAssign: Result := 'shr=';
    tkEqual: Result := '=';
    tkNotEqual: Result := '<>';
    tkLessThan: Result := '<';
    tkLessEqual: Result := '<=';
    tkGreaterThan: Result := '>';
    tkGreaterEqual: Result := '>=';
    tkBitwiseAnd: Result := '&';
    tkBitwiseOr: Result := '|';
    tkIncrement: Result := '++';
    tkDecrement: Result := '--';
    tkAddressOf: Result := '@';
    tkDereference: Result := '^';
    tkQuestion: Result := '?';
    tkColon: Result := ':';
    tkLeftParen: Result := '(';
    tkRightParen: Result := ')';
    tkLeftBracket: Result := '[';
    tkRightBracket: Result := ']';
    tkLeftBrace: Result := '{';
    tkRightBrace: Result := '}';
    tkSemicolon: Result := ';';
    tkComma: Result := ',';
    tkDot: Result := '.';
    tkEllipsis: Result := '...';
    tkDirective: Result := 'Directive';
  else
    Result := 'Unknown';
  end;
end;

function CPCreateSourceLocation(const ALine: Integer; const AColumn: Integer; const APosition: Integer): TCPSourceLocation;
begin
  // Note: Position parameter ignored - centralized TCPSourceLocation doesn't support Position field
  Result := TCPSourceLocation.Create('<lexer>', ALine, AColumn);
end;

{ TCPLexer }

constructor TCPLexer.Create(const ASource: string; const AFileName: string = '<source>');
begin
  inherited Create;
  FSource := ASource;
  FFileName := AFileName;
  FPosition := 1;
  FLine := 1;
  FColumn := 1;

  // Initialize current character
  if Length(FSource) > 0 then
    FCurrentChar := FSource[1]
  else
    FCurrentChar := #0;
end;

procedure TCPLexer.AdvanceChar();
begin
  if FPosition <= Length(FSource) then
  begin
    if FCurrentChar = #10 then
      HandleNewline()
    else
      Inc(FColumn);

    Inc(FPosition);

    if FPosition <= Length(FSource) then
      FCurrentChar := FSource[FPosition]
    else
      FCurrentChar := #0;
  end;
end;

function TCPLexer.PeekChar(const AOffset: Integer = 1): Char;
var
  LPos: Integer;
begin
  LPos := FPosition + AOffset;
  if LPos <= Length(FSource) then
    Result := FSource[LPos]
  else
    Result := #0;
end;

function TCPLexer.IsAtEnd(): Boolean;
begin
  Result := FPosition > Length(FSource);
end;

function TCPLexer.CreateToken(const AKind: TCPTokenKind; const AValue: string = ''): TCPToken;
begin
  Result.Kind := AKind;
  Result.Value := AValue;
  Result.Location := CreateLocation();
end;

function TCPLexer.CreateLocation(): TCPSourceLocation;
begin
  Result := TCPSourceLocation.Create(FFileName, FStartLine, FStartColumn);
end;

procedure TCPLexer.MarkTokenStart();
begin
  FStartPosition := FPosition;
  FStartLine := FLine;
  FStartColumn := FColumn;
end;

function TCPLexer.IsLetter(const AChar: Char): Boolean;
begin
  Result := AChar.IsLetter() or (AChar = '_');
end;

function TCPLexer.IsDigit(const AChar: Char): Boolean;
begin
  Result := AChar.IsDigit();
end;

function TCPLexer.IsHexDigit(const AChar: Char): Boolean;
begin
  Result := AChar.IsDigit() or
            (AChar >= 'a') and (AChar <= 'f') or
            (AChar >= 'A') and (AChar <= 'F');
end;

function TCPLexer.IsBinaryDigit(const AChar: Char): Boolean;
begin
  Result := (AChar = '0') or (AChar = '1');
end;

function TCPLexer.IsOctalDigit(const AChar: Char): Boolean;
begin
  Result := (AChar >= '0') and (AChar <= '7');
end;

function TCPLexer.IsAlphaNumeric(const AChar: Char): Boolean;
begin
  Result := IsLetter(AChar) or IsDigit(AChar);
end;

function TCPLexer.IsWhitespace(const AChar: Char): Boolean;
begin
  Result := (AChar = ' ') or (AChar = #9) or (AChar = #13) or (AChar = #10);
end;

procedure TCPLexer.HandleNewline();
begin
  Inc(FLine);
  FColumn := 1;
end;

procedure TCPLexer.SkipWhitespace();
begin
  while not IsAtEnd() and IsWhitespace(FCurrentChar) do
    AdvanceChar();
end;

procedure TCPLexer.LexicalError(const AMessage: string; const AArgs: array of const);
begin
  raise ECPException.Create(
    AMessage,
    AArgs,
    FFileName,
    FLine,
    FColumn
  );
end;

function TCPLexer.GetKeywordTokenKind(const AIdentifier: string): TCPTokenKind;
var
  LLowerIdentifier: string;
  LIndex: Integer;
begin
  // CPascal keywords are case-insensitive per BNF specification
  LLowerIdentifier := LowerCase(AIdentifier);

  // Binary search through sorted keyword table
  for LIndex := Low(CPKeywords) to High(CPKeywords) do
  begin
    if LowerCase(CPKeywords[LIndex].Keyword) = LLowerIdentifier then
    begin
      Result := CPKeywords[LIndex].TokenKind;
      Exit;
    end;
  end;

  Result := tkIdentifier;
end;

function TCPLexer.ScanIdentifierOrKeyword(): TCPToken;
var
  LValue: string;
  LTokenKind: TCPTokenKind;
begin
  LValue := '';

  // Scan identifier characters according to BNF: <letter> (<letter> | <digit>)*
  while not IsAtEnd() and IsAlphaNumeric(FCurrentChar) do
  begin
    LValue := LValue + FCurrentChar;
    AdvanceChar();
  end;

  // Check if identifier is a keyword
  LTokenKind := GetKeywordTokenKind(LValue);
  Result := CreateToken(LTokenKind, LValue);
end;

function TCPLexer.ScanDecimalInteger(): string;
begin
  Result := '';
  while not IsAtEnd() and IsDigit(FCurrentChar) do
  begin
    Result := Result + FCurrentChar;
    AdvanceChar();
  end;
end;

function TCPLexer.ScanHexadecimalInteger(): string;
begin
  Result := '';
  while not IsAtEnd() and IsHexDigit(FCurrentChar) do
  begin
    Result := Result + FCurrentChar;
    AdvanceChar();
  end;
end;

function TCPLexer.ScanBinaryInteger(): string;
begin
  Result := '';
  while not IsAtEnd() and IsBinaryDigit(FCurrentChar) do
  begin
    Result := Result + FCurrentChar;
    AdvanceChar();
  end;
end;

function TCPLexer.ScanOctalInteger(): string;
begin
  Result := '';
  while not IsAtEnd() and IsOctalDigit(FCurrentChar) do
  begin
    Result := Result + FCurrentChar;
    AdvanceChar();
  end;
end;

function TCPLexer.ScanExponent(): string;
begin
  Result := '';
  
  // Scan 'E' or 'e'
  if (FCurrentChar = 'E') or (FCurrentChar = 'e') then
  begin
    Result := Result + FCurrentChar;
    AdvanceChar();

    // Optional sign
    if (FCurrentChar = '+') or (FCurrentChar = '-') then
    begin
      Result := Result + FCurrentChar;
      AdvanceChar();
    end;

    // Digits required after E/e
    if not IsDigit(FCurrentChar) then
      LexicalError('Expected digits after exponent indicator', []);

    while not IsAtEnd() and IsDigit(FCurrentChar) do
    begin
      Result := Result + FCurrentChar;
      AdvanceChar();
    end;
  end;
end;

function TCPLexer.ScanRealNumber(const AIntegerPart: string): string;
var
  LFractionalPart: string;
  LExponentPart: string;
begin
  Result := AIntegerPart;

  // Decimal point already consumed, scan fractional part
  LFractionalPart := ScanDecimalInteger();
  if LFractionalPart = '' then
    LexicalError('Expected digits after decimal point', []);

  Result := Result + '.' + LFractionalPart;

  // Optional exponent
  if (FCurrentChar = 'E') or (FCurrentChar = 'e') then
  begin
    LExponentPart := ScanExponent();
    Result := Result + LExponentPart;
  end;
end;

function TCPLexer.ScanNumber(): TCPToken;
var
  LValue: string;
  LTokenKind: TCPTokenKind;
  LIntegerPart: string;
begin
  LTokenKind := tkIntegerLiteral;

  // Check for hexadecimal (0x or $)
  if (FCurrentChar = '0') and ((PeekChar() = 'x') or (PeekChar() = 'X')) then
  begin
    AdvanceChar(); // Skip '0'
    AdvanceChar(); // Skip 'x'
    LValue := '0x' + ScanHexadecimalInteger();
    if Copy(LValue, 3, MaxInt) = '' then
      LexicalError('Expected hexadecimal digits after 0x', []);
  end
  else if FCurrentChar = '$' then
  begin
    AdvanceChar(); // Skip '$'
    LValue := '$' + ScanHexadecimalInteger();
    if Copy(LValue, 2, MaxInt) = '' then
      LexicalError('Expected hexadecimal digits after $', []);
  end
  // Check for binary (0b)
  else if (FCurrentChar = '0') and ((PeekChar() = 'b') or (PeekChar() = 'B')) then
  begin
    AdvanceChar(); // Skip '0'
    AdvanceChar(); // Skip 'b'
    LValue := '0b' + ScanBinaryInteger();
    if Copy(LValue, 3, MaxInt) = '' then
      LexicalError('Expected binary digits after 0b', []);
  end
  // Check for octal (0o)
  else if (FCurrentChar = '0') and ((PeekChar() = 'o') or (PeekChar() = 'O')) then
  begin
    AdvanceChar(); // Skip '0'
    AdvanceChar(); // Skip 'o'
    LValue := '0o' + ScanOctalInteger();
    if Copy(LValue, 3, MaxInt) = '' then
      LexicalError('Expected octal digits after 0o', []);
  end
  // Decimal number (may be real)
  else
  begin
    LIntegerPart := ScanDecimalInteger();
    
    // Check for real number (decimal point or exponent)
    if FCurrentChar = '.' then
    begin
      // Check if it's really a decimal point or range operator (..)
      if PeekChar() = '.' then
      begin
        // It's a range operator, return integer
        LValue := LIntegerPart;
      end
      else
      begin
        // It's a real number
        AdvanceChar(); // Skip '.'
        LValue := ScanRealNumber(LIntegerPart);
        LTokenKind := tkRealLiteral;
      end;
    end
    else if (FCurrentChar = 'E') or (FCurrentChar = 'e') then
    begin
      // Real number with exponent
      LValue := LIntegerPart + ScanExponent();
      LTokenKind := tkRealLiteral;
    end
    else
    begin
      LValue := LIntegerPart;
    end;
  end;

  Result := CreateToken(LTokenKind, LValue);
end;

function TCPLexer.ProcessEscapeSequence(): Char;
begin
  Result := #0;

  AdvanceChar(); // Skip backslash

  case FCurrentChar of
    'n': Result := #10;  // Newline
    't': Result := #9;   // Tab
    'r': Result := #13;  // Carriage return
    'b': Result := #8;   // Backspace
    'f': Result := #12;  // Form feed
    'a': Result := #7;   // Alert (bell)
    'v': Result := #11;  // Vertical tab
    '\': Result := '\';  // Backslash
    '''': Result := ''''; // Single quote
    '"': Result := '"';  // Double quote
    '0': Result := #0;   // Null character
    
    // Octal escape sequence (\xxx)
    '1'..'7':
    begin
      Result := Chr(Ord(FCurrentChar) - Ord('0'));
      AdvanceChar();
      
      // Second octal digit (optional)
      if IsOctalDigit(FCurrentChar) then
      begin
        Result := Chr((Ord(Result) shl 3) + (Ord(FCurrentChar) - Ord('0')));
        AdvanceChar();
        
        // Third octal digit (optional)
        if IsOctalDigit(FCurrentChar) then
        begin
          Result := Chr((Ord(Result) shl 3) + (Ord(FCurrentChar) - Ord('0')));
          AdvanceChar();
        end;
      end;
      Exit; // Don't advance again
    end;
    
    // Hexadecimal escape sequence (\x)
    'x', 'X':
    begin
      AdvanceChar(); // Skip 'x'
      
      if not IsHexDigit(FCurrentChar) then
        LexicalError('Expected hexadecimal digit after \x', []);
        
      Result := Chr(StrToInt('$' + FCurrentChar));
      AdvanceChar();
      
      // Second hex digit (optional)
      if IsHexDigit(FCurrentChar) then
      begin
        Result := Chr((Ord(Result) shl 4) + StrToInt('$' + FCurrentChar));
        AdvanceChar();
      end;
      Exit; // Don't advance again
    end;
    
  else
    LexicalError('Invalid escape sequence: \%s', [FCurrentChar]);

  end;
  
  AdvanceChar();
end;

function TCPLexer.ProcessStringContent(): string;
begin
  Result := '';
  
  while not IsAtEnd() and (FCurrentChar <> '"') do
  begin
    if FCurrentChar = '\' then
      Result := Result + ProcessEscapeSequence()
    else if FCurrentChar = #10 then
      LexicalError('Unterminated string literal', [])
    else
    begin
      Result := Result + FCurrentChar;
      AdvanceChar();
    end;
  end;
end;

function TCPLexer.ScanString(): TCPToken;
var
  LValue: string;
begin
  AdvanceChar(); // Skip opening quote
  
  LValue := ProcessStringContent();
  
  if FCurrentChar <> '"' then
    LexicalError('Unterminated string literal', []);
    
  AdvanceChar(); // Skip closing quote
  
  Result := CreateToken(tkStringLiteral, LValue);
end;

function TCPLexer.ScanCharacter(): TCPToken;
var
  LValue: string;
  LCharCode: Integer;
begin
  AdvanceChar(); // Skip '#'
  
  if not IsDigit(FCurrentChar) then
    LexicalError('Expected digit after # in character literal', []);
  
  LCharCode := 0;
  while not IsAtEnd() and IsDigit(FCurrentChar) do
  begin
    LCharCode := LCharCode * 10 + (Ord(FCurrentChar) - Ord('0'));
    AdvanceChar();
  end;
  
  if (LCharCode < 0) or (LCharCode > 255) then
    LexicalError('Character code %d out of range (0-255)', [LCharCode]);
    
  LValue := '#' + IntToStr(LCharCode);
  Result := CreateToken(tkCharacterLiteral, LValue);
end;

function TCPLexer.ScanSingleQuotedCharacter(): TCPToken;
var
  LValue: string;
  LCharacterCount: Integer;
begin
  AdvanceChar(); // Skip opening quote
  
  if IsAtEnd() then
    LexicalError('Unterminated character literal - unexpected end of file', []);
  
  LCharacterCount := 0;
  LValue := '';
  
  // Process content between quotes - BNF requires exactly one printable character
  while not IsAtEnd() and (FCurrentChar <> '''') do
  begin
    Inc(LCharacterCount);
    
    if FCurrentChar = '\' then
    begin
      // Handle escape sequences like '\n', '\t', '\x41', etc.
      LValue := LValue + ProcessEscapeSequence();
    end
    else if FCurrentChar = #10 then
    begin
      // Newline in character literal is not allowed
      LexicalError('Unterminated character literal - newline not allowed', []);
    end
    else
    begin
      // Regular printable character
      LValue := LValue + FCurrentChar;
      AdvanceChar();
    end;
    
    // Enforce single character requirement per BNF specification
    if LCharacterCount > 1 then
      LexicalError('Character literal must contain exactly one character', []);
  end;
  
  // Validate character literal requirements
  if LCharacterCount = 0 then
    LexicalError('Empty character literal - character required between quotes', []);
  
  // Check for proper closing quote
  if FCurrentChar <> '''' then
    LexicalError('Unterminated character literal - missing closing quote', []);
    
  AdvanceChar(); // Skip closing quote
  
  Result := CreateToken(tkCharacterLiteral, LValue);
end;

function TCPLexer.ScanLineComment(): TCPToken;
var
  LValue: string;
begin
  LValue := '';
  
  // Skip until end of line or end of source
  while not IsAtEnd() and (FCurrentChar <> #10) do
  begin
    LValue := LValue + FCurrentChar;
    AdvanceChar();
  end;
  
  // Line comments are typically ignored, but we return them for completeness
  Result := CreateToken(tkInvalid, LValue); // Comments are not tokens in CPascal
end;

function TCPLexer.ScanBlockComment(): TCPToken;
var
  LValue: string;
  LNestLevel: Integer;
begin
  LValue := '';
  LNestLevel := 1;
  
  AdvanceChar(); // Skip first '*'
  
  while not IsAtEnd() and (LNestLevel > 0) do
  begin
    if (FCurrentChar = '/') and (PeekChar() = '*') then
    begin
      Inc(LNestLevel);
      LValue := LValue + FCurrentChar;
      AdvanceChar();
      LValue := LValue + FCurrentChar;
      AdvanceChar();
    end
    else if (FCurrentChar = '*') and (PeekChar() = '/') then
    begin
      Dec(LNestLevel);
      LValue := LValue + FCurrentChar;
      AdvanceChar();
      LValue := LValue + FCurrentChar;
      AdvanceChar();
    end
    else
    begin
      LValue := LValue + FCurrentChar;
      AdvanceChar();
    end;
  end;
  
  if LNestLevel > 0 then
    LexicalError('Unterminated block comment', []);
    
  // Block comments are typically ignored
  Result := CreateToken(tkInvalid, LValue); // Comments are not tokens in CPascal
end;

function TCPLexer.ScanBraceComment(): TCPToken;
var
  LValue: string;
begin
  LValue := '';
  
  while not IsAtEnd() and (FCurrentChar <> '}') do
  begin
    LValue := LValue + FCurrentChar;
    AdvanceChar();
  end;
  
  if FCurrentChar <> '}' then
    LexicalError('Unterminated brace comment', []);
    
  AdvanceChar(); // Skip closing brace
  
  // Brace comments are typically ignored
  Result := CreateToken(tkInvalid, LValue); // Comments are not tokens in CPascal
end;

function TCPLexer.ScanDirective(): TCPToken;
var
  LValue: string;
begin
  LValue := '{$';
  AdvanceChar(); // Skip '$'
  
  while not IsAtEnd() and (FCurrentChar <> '}') do
  begin
    LValue := LValue + FCurrentChar;
    AdvanceChar();
  end;
  
  if FCurrentChar <> '}' then
    LexicalError('Unterminated compiler directive', []);
    
  LValue := LValue + '}';
  AdvanceChar(); // Skip closing brace
  
  Result := CreateToken(tkDirective, LValue);
end;

function TCPLexer.ScanOperator(): TCPToken;
var
  LChar1: Char;
  LChar2: Char;
  LChar3: Char;
begin
  LChar1 := FCurrentChar;
  LChar2 := PeekChar(1);
  LChar3 := PeekChar(2);

  // Three-character operators
  if (LChar1 = '.') and (LChar2 = '.') and (LChar3 = '.') then
  begin
    AdvanceChar();
    AdvanceChar();
    AdvanceChar();
    Result := CreateToken(tkEllipsis, '...');
    Exit;
  end;

  // Two-character operators
  case LChar1 of
    ':':
      if LChar2 = '=' then
      begin
        AdvanceChar();
        AdvanceChar();
        Result := CreateToken(tkAssign, ':=');
        Exit;
      end;

    '+':
      case LChar2 of
        '+':
        begin
          AdvanceChar();
          AdvanceChar();
          Result := CreateToken(tkIncrement, '++');
          Exit;
        end;
        '=':
        begin
          AdvanceChar();
          AdvanceChar();
          Result := CreateToken(tkPlusAssign, '+=');
          Exit;
        end;
      end;

    '-':
      case LChar2 of
        '-':
        begin
          AdvanceChar();
          AdvanceChar();
          Result := CreateToken(tkDecrement, '--');
          Exit;
        end;
        '=':
        begin
          AdvanceChar();
          AdvanceChar();
          Result := CreateToken(tkMinusAssign, '-=');
          Exit;
        end;
      end;

    '*':
      if LChar2 = '=' then
      begin
        AdvanceChar();
        AdvanceChar();
        Result := CreateToken(tkMultiplyAssign, '*=');
        Exit;
      end;

    '/':
      if LChar2 = '=' then
      begin
        AdvanceChar();
        AdvanceChar();
        Result := CreateToken(tkDivideAssign, '/=');
        Exit;
      end;

    '<':
      case LChar2 of
        '=':
        begin
          AdvanceChar();
          AdvanceChar();
          Result := CreateToken(tkLessEqual, '<=');
          Exit;
        end;
        '>':
        begin
          AdvanceChar();
          AdvanceChar();
          Result := CreateToken(tkNotEqual, '<>');
          Exit;
        end;
      end;

    '>':
      if LChar2 = '=' then
      begin
        AdvanceChar();
        AdvanceChar();
        Result := CreateToken(tkGreaterEqual, '>=');
        Exit;
      end;
  end;

  // Single-character operators
  case LChar1 of
    '+': Result := CreateToken(tkPlus, '+');
    '-': Result := CreateToken(tkMinus, '-');
    '*': Result := CreateToken(tkMultiply, '*');
    '/': Result := CreateToken(tkDivide, '/');
    '=': Result := CreateToken(tkEqual, '=');
    '<': Result := CreateToken(tkLessThan, '<');
    '>': Result := CreateToken(tkGreaterThan, '>');
    '&': Result := CreateToken(tkBitwiseAnd, '&');
    '|': Result := CreateToken(tkBitwiseOr, '|');
    '@': Result := CreateToken(tkAddressOf, '@');
    '^': Result := CreateToken(tkDereference, '^');
    '?': Result := CreateToken(tkQuestion, '?');
    ':': Result := CreateToken(tkColon, ':');
    '(': Result := CreateToken(tkLeftParen, '(');
    ')': Result := CreateToken(tkRightParen, ')');
    '[': Result := CreateToken(tkLeftBracket, '[');
    ']': Result := CreateToken(tkRightBracket, ']');
    '{': Result := CreateToken(tkLeftBrace, '{');
    '}': Result := CreateToken(tkRightBrace, '}');
    ';': Result := CreateToken(tkSemicolon, ';');
    ',': Result := CreateToken(tkComma, ',');
    '.': Result := CreateToken(tkDot, '.');
  else
    LexicalError('Unexpected character: %s', [LChar1]);
    Result := CreateToken(tkInvalid, LChar1);
  end;

  AdvanceChar();
end;

function TCPLexer.GetNextToken(): TCPToken;
begin
  // Skip whitespace and newlines
  SkipWhitespace();
  
  // Skip comments by continuing to next token
  while not IsAtEnd() do
  begin
    MarkTokenStart();
    
    // Check for end of file
    if IsAtEnd() then
    begin
      Result := CreateToken(tkEOF);
      Exit;
    end;

    // Line comment
    if (FCurrentChar = '/') and (PeekChar() = '/') then
    begin
      AdvanceChar(); // Skip first '/'
      AdvanceChar(); // Skip second '/'
      ScanLineComment();
      SkipWhitespace();
      Continue;
    end;

    // Block comment
    if (FCurrentChar = '/') and (PeekChar() = '*') then
    begin
      AdvanceChar(); // Skip '/'
      ScanBlockComment();
      SkipWhitespace();
      Continue;
    end;

    // Brace comment or directive
    if FCurrentChar = '{' then
    begin
      if PeekChar() = '$' then
      begin
        AdvanceChar(); // Skip '{'
        Result := ScanDirective();
        Exit;
      end
      else
      begin
        AdvanceChar(); // Skip '{'
        ScanBraceComment();
        SkipWhitespace();
        Continue;
      end;
    end;

    // Regular tokens
    Break;
  end;

  if IsAtEnd() then
  begin
    Result := CreateToken(tkEOF);
    Exit;
  end;

  MarkTokenStart();

  // Identifiers and keywords
  if IsLetter(FCurrentChar) then
  begin
    Result := ScanIdentifierOrKeyword();
    Exit;
  end;

  // Numbers
  if IsDigit(FCurrentChar) then
  begin
    Result := ScanNumber();
    Exit;
  end;

  // Hexadecimal numbers with $ prefix
  if (FCurrentChar = '$') and IsHexDigit(PeekChar()) then
  begin
    Result := ScanNumber();
    Exit;
  end;

  // String literals
  if FCurrentChar = '"' then
  begin
    Result := ScanString();
    Exit;
  end;

  // Character literals
  if FCurrentChar = '''' then
  begin
    Result := ScanSingleQuotedCharacter();
    Exit;
  end;

  // Character literals
  if FCurrentChar = '#' then
  begin
    Result := ScanCharacter();
    Exit;
  end;

  // Operators and delimiters
  Result := ScanOperator();
end;

function TCPLexer.PeekNextToken(): TCPToken;
var
  LSavedPosition: Integer;
  LSavedLine: Integer;
  LSavedColumn: Integer;
  LSavedChar: Char;
begin
  // Save current state
  LSavedPosition := FPosition;
  LSavedLine := FLine;
  LSavedColumn := FColumn;
  LSavedChar := FCurrentChar;

  // Get next token
  Result := GetNextToken();

  // Restore state
  FPosition := LSavedPosition;
  FLine := LSavedLine;
  FColumn := LSavedColumn;
  FCurrentChar := LSavedChar;
end;

end.