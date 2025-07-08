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
  System.Classes,
  System.Generics.Collections,
  CPascal.Platform,
  CPascal.Common;

type
  // === AST NODE BASE CLASS ===
  
  TCPAstNode = class
  private
    FNodeType: string;
    FPosition: TCPSourceLocation;
  public
    constructor Create(const ANodeType: string; const APosition: TCPSourceLocation);
    destructor Destroy(); override;
    
    property NodeType: string read FNodeType;
    property Position: TCPSourceLocation read FPosition;
  end;

  // === EXPRESSION NODES ===
  
  TCPAstExpression = class(TCPAstNode)
  public
    constructor Create(const ANodeType: string; const APosition: TCPSourceLocation);
  end;

  TCPAstStringLiteral = class(TCPAstExpression)
  private
    FValue: string;
  public
    constructor Create(const APosition: TCPSourceLocation; const AValue: string);
    property Value: string read FValue;
  end;

  TCPAstNumberLiteral = class(TCPAstExpression)
  private
    FValue: string;
  public
    constructor Create(const APosition: TCPSourceLocation; const AValue: string);
    property Value: string read FValue;
  end;

  TCPAstRealLiteral = class(TCPAstExpression)
  private
    FValue: string;
  public
    constructor Create(const APosition: TCPSourceLocation; const AValue: string);
    property Value: string read FValue;
  end;

  TCPAstCharacterLiteral = class(TCPAstExpression)
  private
    FValue: Integer;
  public
    constructor Create(const APosition: TCPSourceLocation; const AValue: Integer);
    property Value: Integer read FValue;
  end;

  TCPAstIdentifier = class(TCPAstExpression)
  private
    FName: string;
  public
    constructor Create(const APosition: TCPSourceLocation; const AName: string);
    property Name: string read FName;
  end;

  TCPAstVariableReference = class(TCPAstExpression)
  private
    FVariableName: string;
  public
    constructor Create(const APosition: TCPSourceLocation; const AVariableName: string);
    property VariableName: string read FVariableName;
  end;

  TCPAstComparisonExpression = class(TCPAstExpression)
  private
    FLeft: TCPAstExpression;
    FOperator: TCPTokenType;
    FRight: TCPAstExpression;
  public
    constructor Create(const APosition: TCPSourceLocation; const ALeft: TCPAstExpression; 
                      const AOperator: TCPTokenType; const ARight: TCPAstExpression);
    destructor Destroy(); override;
    property Left: TCPAstExpression read FLeft;
    property Operator: TCPTokenType read FOperator;
    property Right: TCPAstExpression read FRight;
  end;

  // === STATEMENT NODES ===
  
  TCPAstStatement = class(TCPAstNode)
  public
    constructor Create(const ANodeType: string; const APosition: TCPSourceLocation);
  end;

  TCPAstProcedureCall = class(TCPAstStatement)
  private
    FProcedureName: string;
    FArguments: TArray<TCPAstExpression>;
  public
    constructor Create(const APosition: TCPSourceLocation; const AProcedureName: string; 
                      const AArguments: TArray<TCPAstExpression>);
    destructor Destroy(); override;
    property ProcedureName: string read FProcedureName;
    property Arguments: TArray<TCPAstExpression> read FArguments;
  end;

  TCPAstCompoundStatement = class(TCPAstStatement)
  private
    FStatements: TArray<TCPAstStatement>;
  public
    constructor Create(const APosition: TCPSourceLocation; const AStatements: TArray<TCPAstStatement>);
    destructor Destroy(); override;
    property Statements: TArray<TCPAstStatement> read FStatements;
  end;

  TCPAstAssignmentStatement = class(TCPAstStatement)
  private
    FVariableName: string;
    FExpression: TCPAstExpression;
  public
    constructor Create(const APosition: TCPSourceLocation; const AVariableName: string; const AExpression: TCPAstExpression);
    destructor Destroy(); override;
    property VariableName: string read FVariableName;
    property Expression: TCPAstExpression read FExpression;
  end;

  TCPAstIfStatement = class(TCPAstStatement)
  private
    FCondition: TCPAstExpression;
    FThenStatement: TCPAstStatement;
    FElseStatement: TCPAstStatement; // Can be nil
  public
    constructor Create(const APosition: TCPSourceLocation; const ACondition: TCPAstExpression; 
                      const AThenStatement: TCPAstStatement; const AElseStatement: TCPAstStatement = nil);
    destructor Destroy(); override;
    property Condition: TCPAstExpression read FCondition;
    property ThenStatement: TCPAstStatement read FThenStatement;
    property ElseStatement: TCPAstStatement read FElseStatement;
  end;

  // === TYPE AND DECLARATION NODES ===
  
  TCPAstTypeReference = class(TCPAstNode)
  private
    FTypeName: string;
  public
    constructor Create(const APosition: TCPSourceLocation; const ATypeName: string);
    property TypeName: string read FTypeName;
  end;

  TCPAstParameter = class(TCPAstNode)
  private
    FName: string;
    FParamType: TCPAstTypeReference;
    FMode: TCPParameterMode;
  public
    constructor Create(const APosition: TCPSourceLocation; const AName: string; 
                      const AParamType: TCPAstTypeReference; const AMode: TCPParameterMode);
    destructor Destroy(); override;
    property Name: string read FName;
    property ParamType: TCPAstTypeReference read FParamType;
    property Mode: TCPParameterMode read FMode;
  end;

  TCPAstExternalFunction = class(TCPAstNode)
  private
    FFunctionName: string;
    FParameters: TArray<TCPAstParameter>;
    FReturnType: TCPAstTypeReference;
    FCallingConvention: TCPCallingConvention;
    FExternalLib: string;
    FIsProcedure: Boolean;
    FIsVariadic: Boolean;
  public
    constructor Create(const APosition: TCPSourceLocation; const AFunctionName: string;
                      const AParameters: TArray<TCPAstParameter>; const AReturnType: TCPAstTypeReference;
                      const ACallingConvention: TCPCallingConvention; const AExternalLib: string;
                      const AIsProcedure: Boolean; const AIsVariadic: Boolean);
    destructor Destroy(); override;
    property FunctionName: string read FFunctionName;
    property Parameters: TArray<TCPAstParameter> read FParameters;
    property ReturnType: TCPAstTypeReference read FReturnType;
    property CallingConvention: TCPCallingConvention read FCallingConvention;
    property ExternalLib: string read FExternalLib;
    property IsProcedure: Boolean read FIsProcedure;
    property IsVariadic: Boolean read FIsVariadic;
  end;

  TCPAstVariableDecl = class(TCPAstNode)
  private
    FVariableNames: TArray<string>;
    FVariableType: TCPAstTypeReference;
  public
    constructor Create(const APosition: TCPSourceLocation; const AVariableNames: TArray<string>; const AVariableType: TCPAstTypeReference);
    destructor Destroy(); override;
    property VariableNames: TArray<string> read FVariableNames;
    property VariableType: TCPAstTypeReference read FVariableType;
  end;

  TCPAstDeclarations = class(TCPAstNode)
  private
    FFunctions: TArray<TCPAstExternalFunction>;
    FVariables: TArray<TCPAstVariableDecl>;
  public
    constructor Create(const APosition: TCPSourceLocation; const AFunctions: TArray<TCPAstExternalFunction>; const AVariables: TArray<TCPAstVariableDecl> = nil);
    destructor Destroy(); override;
    property Functions: TArray<TCPAstExternalFunction> read FFunctions;
    property Variables: TArray<TCPAstVariableDecl> read FVariables;
  end;

  TCPAstProgram = class(TCPAstNode)
  private
    FProgramName: string;
    FDeclarations: TCPAstDeclarations;
    FMainStatement: TCPAstCompoundStatement;
  public
    constructor Create(const APosition: TCPSourceLocation; const AProgramName: string;
                      const ADeclarations: TCPAstDeclarations; const AMainStatement: TCPAstCompoundStatement);
    destructor Destroy(); override;
    property ProgramName: string read FProgramName;
    property Declarations: TCPAstDeclarations read FDeclarations;
    property MainStatement: TCPAstCompoundStatement read FMainStatement;
  end;

  // === COMPLETE LEXER ===
  
  TCPLexer = class
  private
    FSource: string;
    FFileName: string;
    FPosition: Integer;
    FLine: Integer;
    FColumn: Integer;
    FLength: Integer;
    FErrorHandler: TCPErrorHandler;
    FSourceLines: TStringList;
    
    function CurrentChar(): Char;
    function NextChar(): Char;
    function PeekChar(const AOffset: Integer = 1): Char;
    function IsEOF(): Boolean;
    procedure AdvancePosition();
    procedure SkipWhitespace();
    function GetCurrentPosition(): TCPSourceLocation;
    
    function IsLetter(const AChar: Char): Boolean;
    function IsDigit(const AChar: Char): Boolean;
    function IsAlphaNumeric(const AChar: Char): Boolean;
    
    function ReadIdentifier(): string;
    function ReadStringLiteral(): string;
    function ReadNumber(): string;
    function ReadCharacterLiteral(): Integer;
    function GetKeywordType(const AIdentifier: string): TCPTokenType;
    
    procedure ReportLexerError(const AMessage: string);
    procedure ReportLexerWarning(const AMessage: string; const AHint: string = '');
  public
    constructor Create(const ASource: string; const AFileName: string; const AErrorHandler: TCPErrorHandler);
    destructor Destroy(); override;
    
    function NextToken(): TCPToken;
  end;

  // === COMPLETE PARSER ===
  
  TCPParser = class
  private
    FLexer: TCPLexer;
    FCurrentToken: TCPToken;
    FErrorHandler: TCPErrorHandler;
    
    function CurrentToken(): TCPToken;
    function NextToken(): TCPToken;
    function Accept(const ATokenType: TCPTokenType): Boolean;
    function Expect(const ATokenType: TCPTokenType): TCPToken;
    
    procedure ReportParseError(const AMessage: string);
    procedure ReportParseWarning(const AMessage: string; const AHint: string = '');
    
    // Parsing methods for complete grammar
    function ParseProgram(): TCPAstProgram;
    function ParseDeclarations(): TCPAstDeclarations;
    function ParseExternalFunction(): TCPAstExternalFunction;
    function ParseVarSection(): TArray<TCPAstVariableDecl>;
    function ParseParameterList(): TArray<TCPAstParameter>;
    function ParseParameter(): TCPAstParameter;
    function ParseCallingConvention(): TCPCallingConvention;
    function ParseCompoundStatement(): TCPAstCompoundStatement;
    function ParseStatementList(): TArray<TCPAstStatement>;
    function ParseStatement(): TCPAstStatement;
    function ParseProcedureCall(): TCPAstProcedureCall;
    function ParseAssignmentStatement(): TCPAstAssignmentStatement;
    function ParseIfStatement(): TCPAstIfStatement;
    function ParseExpression(): TCPAstExpression;
    function ParseComparisonExpression(): TCPAstExpression;
    function ParseExpressionList(): TArray<TCPAstExpression>;
  public
    constructor Create(const ALexer: TCPLexer; const AErrorHandler: TCPErrorHandler);
    destructor Destroy(); override;
    
    function Parse(): TCPAstProgram;
  end;

implementation

// =============================================================================
// TCPAstNode Implementation
// =============================================================================

constructor TCPAstNode.Create(const ANodeType: string; const APosition: TCPSourceLocation);
begin
  inherited Create();
  FNodeType := ANodeType;
  FPosition := APosition;
end;

destructor TCPAstNode.Destroy();
begin
  inherited Destroy();
end;

// =============================================================================
// Expression Implementations
// =============================================================================

constructor TCPAstExpression.Create(const ANodeType: string; const APosition: TCPSourceLocation);
begin
  inherited Create(ANodeType, APosition);
end;

constructor TCPAstStringLiteral.Create(const APosition: TCPSourceLocation; const AValue: string);
begin
  inherited Create('StringLiteral', APosition);
  FValue := AValue;
end;

constructor TCPAstNumberLiteral.Create(const APosition: TCPSourceLocation; const AValue: string);
begin
  inherited Create('NumberLiteral', APosition);
  FValue := AValue;
end;

constructor TCPAstRealLiteral.Create(const APosition: TCPSourceLocation; const AValue: string);
begin
  inherited Create('RealLiteral', APosition);
  FValue := AValue;
end;

constructor TCPAstCharacterLiteral.Create(const APosition: TCPSourceLocation; const AValue: Integer);
begin
  inherited Create('CharacterLiteral', APosition);
  FValue := AValue;
end;

constructor TCPAstIdentifier.Create(const APosition: TCPSourceLocation; const AName: string);
begin
  inherited Create('Identifier', APosition);
  FName := AName;
end;

constructor TCPAstVariableReference.Create(const APosition: TCPSourceLocation; const AVariableName: string);
begin
  inherited Create('VariableReference', APosition);
  FVariableName := AVariableName;
end;

constructor TCPAstComparisonExpression.Create(const APosition: TCPSourceLocation; const ALeft: TCPAstExpression; 
                                           const AOperator: TCPTokenType; const ARight: TCPAstExpression);
begin
  inherited Create('ComparisonExpression', APosition);
  FLeft := ALeft;
  FOperator := AOperator;
  FRight := ARight;
end;

destructor TCPAstComparisonExpression.Destroy();
begin
  FLeft.Free();
  FRight.Free();
  inherited Destroy();
end;

// =============================================================================
// Statement Implementations
// =============================================================================

constructor TCPAstStatement.Create(const ANodeType: string; const APosition: TCPSourceLocation);
begin
  inherited Create(ANodeType, APosition);
end;

constructor TCPAstProcedureCall.Create(const APosition: TCPSourceLocation; const AProcedureName: string; 
                                    const AArguments: TArray<TCPAstExpression>);
begin
  inherited Create('ProcedureCall', APosition);
  FProcedureName := AProcedureName;
  FArguments := AArguments;
end;

destructor TCPAstProcedureCall.Destroy();
var
  LArg: TCPAstExpression;
begin
  for LArg in FArguments do
    LArg.Free();
  inherited Destroy();
end;

constructor TCPAstCompoundStatement.Create(const APosition: TCPSourceLocation; const AStatements: TArray<TCPAstStatement>);
begin
  inherited Create('CompoundStatement', APosition);
  FStatements := AStatements;
end;

destructor TCPAstCompoundStatement.Destroy();
var
  LStmt: TCPAstStatement;
begin
  for LStmt in FStatements do
    LStmt.Free();
  inherited Destroy();
end;

constructor TCPAstAssignmentStatement.Create(const APosition: TCPSourceLocation; const AVariableName: string; const AExpression: TCPAstExpression);
begin
  inherited Create('AssignmentStatement', APosition);
  FVariableName := AVariableName;
  FExpression := AExpression;
end;

destructor TCPAstAssignmentStatement.Destroy();
begin
  FExpression.Free();
  inherited Destroy();
end;

constructor TCPAstIfStatement.Create(const APosition: TCPSourceLocation; const ACondition: TCPAstExpression; 
                                  const AThenStatement: TCPAstStatement; const AElseStatement: TCPAstStatement = nil);
begin
  inherited Create('IfStatement', APosition);
  FCondition := ACondition;
  FThenStatement := AThenStatement;
  FElseStatement := AElseStatement;
end;

destructor TCPAstIfStatement.Destroy();
begin
  FCondition.Free();
  FThenStatement.Free();
  if Assigned(FElseStatement) then
    FElseStatement.Free();
  inherited Destroy();
end;

// =============================================================================
// Type and Declaration Implementations
// =============================================================================

constructor TCPAstTypeReference.Create(const APosition: TCPSourceLocation; const ATypeName: string);
begin
  inherited Create('TypeReference', APosition);
  FTypeName := ATypeName;
end;

constructor TCPAstParameter.Create(const APosition: TCPSourceLocation; const AName: string; 
                                const AParamType: TCPAstTypeReference; const AMode: TCPParameterMode);
begin
  inherited Create('Parameter', APosition);
  FName := AName;
  FParamType := AParamType;
  FMode := AMode;
end;

destructor TCPAstParameter.Destroy();
begin
  FParamType.Free();
  inherited Destroy();
end;

constructor TCPAstExternalFunction.Create(const APosition: TCPSourceLocation; const AFunctionName: string;
                                       const AParameters: TArray<TCPAstParameter>; const AReturnType: TCPAstTypeReference;
                                       const ACallingConvention: TCPCallingConvention; const AExternalLib: string;
                                       const AIsProcedure: Boolean; const AIsVariadic: Boolean);
begin
  inherited Create('ExternalFunction', APosition);
  FFunctionName := AFunctionName;
  FParameters := AParameters;
  FReturnType := AReturnType;
  FCallingConvention := ACallingConvention;
  FExternalLib := AExternalLib;
  FIsProcedure := AIsProcedure;
  FIsVariadic := AIsVariadic;
end;

destructor TCPAstExternalFunction.Destroy();
var
  LParam: TCPAstParameter;
begin
  for LParam in FParameters do
    LParam.Free();
  if Assigned(FReturnType) then
    FReturnType.Free();
  inherited Destroy();
end;

constructor TCPAstVariableDecl.Create(const APosition: TCPSourceLocation; const AVariableNames: TArray<string>; const AVariableType: TCPAstTypeReference);
begin
  inherited Create('VariableDecl', APosition);
  FVariableNames := AVariableNames;
  FVariableType := AVariableType;
end;

destructor TCPAstVariableDecl.Destroy();
begin
  FVariableType.Free();
  inherited Destroy();
end;

constructor TCPAstDeclarations.Create(const APosition: TCPSourceLocation; const AFunctions: TArray<TCPAstExternalFunction>; const AVariables: TArray<TCPAstVariableDecl> = nil);
begin
  inherited Create('Declarations', APosition);
  FFunctions := AFunctions;
  FVariables := AVariables;
end;

destructor TCPAstDeclarations.Destroy();
var
  LFunc: TCPAstExternalFunction;
  LVar: TCPAstVariableDecl;
begin
  for LFunc in FFunctions do
    LFunc.Free();
  for LVar in FVariables do
    LVar.Free();
  inherited Destroy();
end;

constructor TCPAstProgram.Create(const APosition: TCPSourceLocation; const AProgramName: string;
                              const ADeclarations: TCPAstDeclarations; const AMainStatement: TCPAstCompoundStatement);
begin
  inherited Create('Program', APosition);
  FProgramName := AProgramName;
  FDeclarations := ADeclarations;
  FMainStatement := AMainStatement;
end;

destructor TCPAstProgram.Destroy();
begin
  FDeclarations.Free();
  FMainStatement.Free();
  inherited Destroy();
end;

// =============================================================================
// TCPLexer Implementation
// =============================================================================

constructor TCPLexer.Create(const ASource: string; const AFileName: string; const AErrorHandler: TCPErrorHandler);
begin
  inherited Create();
  FSource := ASource;
  FFileName := AFileName;
  FPosition := 1;
  FLine := 1;
  FColumn := 1;
  FLength := Length(ASource);
  FErrorHandler := AErrorHandler;
  
  // Cache source lines for enhanced error reporting
  FSourceLines := TStringList.Create();
  FSourceLines.Text := ASource;
  
  // Set current file in error handler
  FErrorHandler.SetCurrentFile(AFileName);
  FErrorHandler.SetCurrentPhase(cpLexicalAnalysis);
end;

destructor TCPLexer.Destroy();
begin
  FSourceLines.Free();
  inherited Destroy();
end;

function TCPLexer.CurrentChar(): Char;
begin
  if FPosition <= FLength then
    Result := FSource[FPosition]
  else
    Result := #0;
end;

function TCPLexer.NextChar(): Char;
begin
  if FPosition <= FLength then
  begin
    Result := FSource[FPosition];
    AdvancePosition();
  end
  else
    Result := #0;
end;

function TCPLexer.PeekChar(const AOffset: Integer = 1): Char;
var
  LPos: Integer;
begin
  LPos := FPosition + AOffset;
  if LPos <= FLength then
    Result := FSource[LPos]
  else
    Result := #0;
end;

function TCPLexer.IsEOF(): Boolean;
begin
  Result := FPosition > FLength;
end;

procedure TCPLexer.AdvancePosition();
begin
  if FPosition <= FLength then
  begin
    if FSource[FPosition] = #10 then
    begin
      Inc(FLine);
      FColumn := 1;
    end
    else if FSource[FPosition] <> #13 then
      Inc(FColumn);
    Inc(FPosition);
  end;
end;

procedure TCPLexer.SkipWhitespace();
begin
  while not IsEOF() do
  begin
    if CharInSet(CurrentChar(), [' ', #9, #10, #13]) then
      NextChar()
    else if (CurrentChar() = '/') and (PeekChar(1) = '/') then
    begin
      // Skip line comment: // until end of line
      NextChar(); NextChar(); // Skip //
      while not IsEOF() and not CharInSet(CurrentChar(), [#10, #13]) do
        NextChar();
    end
    else if (CurrentChar() = '/') and (PeekChar(1) = '*') then
    begin
      // Skip block comment: /* ... */
      NextChar(); NextChar(); // Skip /*
      while not IsEOF() and not ((CurrentChar() = '*') and (PeekChar(1) = '/')) do
        NextChar();
      if not IsEOF() then
      begin
        NextChar(); NextChar(); // Skip */
      end;
    end
    else if CurrentChar() = '{' then
    begin
      // Skip brace comment: { ... }
      NextChar(); // Skip {
      while not IsEOF() and (CurrentChar() <> '}') do
        NextChar();
      if not IsEOF() then
        NextChar(); // Skip }
    end
    else
      Break;
  end;
end;

function TCPLexer.GetCurrentPosition(): TCPSourceLocation;
begin
  Result := TCPSourceLocation.Create(FFileName, FLine, FColumn, FPosition, 1);
end;

function TCPLexer.IsLetter(const AChar: Char): Boolean;
begin
  Result := CharInSet(AChar, ['A'..'Z', 'a'..'z', '_']);
end;

function TCPLexer.IsDigit(const AChar: Char): Boolean;
begin
  Result := CharInSet(AChar, ['0'..'9']);
end;

function TCPLexer.IsAlphaNumeric(const AChar: Char): Boolean;
begin
  Result := IsLetter(AChar) or IsDigit(AChar);
end;

function TCPLexer.ReadIdentifier(): string;
var
  LResult: TStringBuilder;
begin
  LResult := TStringBuilder.Create();
  try
    if IsLetter(CurrentChar()) then
    begin
      LResult.Append(NextChar());
      while not IsEOF() and IsAlphaNumeric(CurrentChar()) do
        LResult.Append(NextChar());
    end;
    Result := LResult.ToString();
  finally
    LResult.Free();
  end;
end;

function TCPLexer.ReadStringLiteral(): string;
var
  LResult: TStringBuilder;
  LChar: Char;
  LCharValue: Integer;
begin
  LResult := TStringBuilder.Create();
  try
    // Skip opening quote
    NextChar();
    
    while not IsEOF() and (CurrentChar() <> '"') do
    begin
      LChar := NextChar();
      
      // Handle escape sequences
      if LChar = '\' then
      begin
        if not IsEOF() then
        begin
          LChar := NextChar();
          case LChar of
            'n': LResult.Append(#10);
            't': LResult.Append(#9);
            'r': LResult.Append(#13);
            '\': LResult.Append('\');
            '"': LResult.Append('"');
            else
              LResult.Append(LChar);
          end;
        end;
      end
      else
        LResult.Append(LChar);
    end;
    
    // Skip closing quote
    if CurrentChar() = '"' then
      NextChar();
    
    // Check for character literal concatenation (#digits)
    while not IsEOF() and (CurrentChar() = '#') do
    begin
      NextChar(); // Skip '#'
      
      // Read character literal digits
      LCharValue := 0;
      while not IsEOF() and IsDigit(CurrentChar()) do
      begin
        LCharValue := LCharValue * 10 + (Ord(CurrentChar()) - Ord('0'));
        NextChar();
      end;
      
      // Append character to string
      if LCharValue <= 255 then
        LResult.Append(Chr(LCharValue));
    end;
    
    Result := LResult.ToString();
  finally
    LResult.Free();
  end;
end;

function TCPLexer.ReadNumber(): string;
var
  LResult: TStringBuilder;
  LHasDecimalPoint: Boolean;
  LHasExponent: Boolean;
begin
  LResult := TStringBuilder.Create();
  LHasDecimalPoint := False;
  LHasExponent := False;

  try
    // Read integer part
    while not IsEOF() and IsDigit(CurrentChar()) do
      LResult.Append(NextChar());

    // Check for decimal point
    if not IsEOF() and (CurrentChar() = '.') and IsDigit(PeekChar(1)) then
    begin
      LHasDecimalPoint := True;
      LResult.Append(NextChar()); // Add the '.'

      // Read fractional part
      while not IsEOF() and IsDigit(CurrentChar()) do
        LResult.Append(NextChar());
    end;

    // Check for exponent
    if not IsEOF() and CharInSet(CurrentChar(), ['e', 'E']) then
    begin
      LHasExponent := True;
      LResult.Append(NextChar()); // Add 'e' or 'E'

      // Check for optional sign
      if not IsEOF() and CharInSet(CurrentChar(), ['+', '-']) then
        LResult.Append(NextChar());

      // Read exponent digits
      while not IsEOF() and IsDigit(CurrentChar()) do
        LResult.Append(NextChar());
    end;

    Result := LResult.ToString();
  finally
    LResult.Free();
  end;
end;

function TCPLexer.ReadCharacterLiteral(): Integer;
var
  LDigits: string;
begin
  Result := 0;
  LDigits := '';
  
  // Skip the '#' character
  NextChar();
  
  // Read digits
  while not IsEOF() and IsDigit(CurrentChar()) do
  begin
    LDigits := LDigits + NextChar();
  end;
  
  // Convert to integer
  if LDigits <> '' then
    Result := StrToIntDef(LDigits, 0);
end;

function TCPLexer.GetKeywordType(const AIdentifier: string): TCPTokenType;
begin
  if SameText(AIdentifier, 'program') then
    Result := tkProgram
  else if SameText(AIdentifier, 'procedure') then
    Result := tkProcedure
  else if SameText(AIdentifier, 'function') then
    Result := tkFunction
  else if SameText(AIdentifier, 'external') then
    Result := tkExternal
  else if SameText(AIdentifier, 'begin') then
    Result := tkBegin
  else if SameText(AIdentifier, 'end') then
    Result := tkEnd
  else if SameText(AIdentifier, 'const') then
    Result := tkConst
  else if SameText(AIdentifier, 'var') then
    Result := tkVar
  else if SameText(AIdentifier, 'if') then
    Result := tkIf
  else if SameText(AIdentifier, 'then') then
    Result := tkThen
  else if SameText(AIdentifier, 'else') then
    Result := tkElse
  else if SameText(AIdentifier, 'cdecl') then
    Result := tkCdecl
  else if SameText(AIdentifier, 'stdcall') then
    Result := tkStdcall
  else if SameText(AIdentifier, 'fastcall') then
    Result := tkFastcall
  else if SameText(AIdentifier, 'register') then
    Result := tkRegister
  else
    Result := tkIdentifier;
end;

procedure TCPLexer.ReportLexerError(const AMessage: string);
begin
  FErrorHandler.ReportError(FLine, FColumn, 'Lexical error: ' + AMessage);
  
  // IMMEDIATE stop check after reporting lexical error
  if FErrorHandler.ShouldStopParsing() then
  begin
    // Set position to EOF to stop lexical analysis immediately
    FPosition := FLength + 1;
  end;
end;

procedure TCPLexer.ReportLexerWarning(const AMessage: string; const AHint: string = '');
begin
  FErrorHandler.ReportWarning(FLine, FColumn, wlWarning, wcSyntax, 'Lexical warning: ' + AMessage, AHint);
end;

function TCPLexer.NextToken(): TCPToken;
var
  LPosition: TCPSourceLocation;
  LChar: Char;
  LValue: string;
  LCharValue: Integer;
begin
  SkipWhitespace();

  // Check if we should stop lexing due to previous errors
  if FErrorHandler.ShouldStopParsing() then
  begin
    Result := TCPToken.Create(tkEOF, '', GetCurrentPosition());
    Exit;
  end;

  LPosition := GetCurrentPosition();

  if IsEOF() then
  begin
    Result := TCPToken.Create(tkEOF, '', LPosition);
    Exit;
  end;

  LChar := CurrentChar();

  // String literals
  if LChar = '"' then
  begin
    Result := TCPToken.Create(tkString, ReadStringLiteral(), LPosition);
  end
  // Character literals
  else if LChar = '#' then
  begin
    LCharValue := ReadCharacterLiteral();
    Result := TCPToken.Create(tkCharacter, IntToStr(LCharValue), LPosition);
  end
  // Identifiers and keywords
  else if IsLetter(LChar) then
  begin
    LValue := ReadIdentifier();
    Result := TCPToken.Create(GetKeywordType(LValue), LValue, LPosition);
  end
  // Numbers
  else if IsDigit(LChar) then
  begin
    LValue := ReadNumber();
    Result := TCPToken.Create(tkNumber, LValue, LPosition);
  end
  // Symbols
  else
  begin
    LValue := LChar;
    NextChar();

    case LChar of
      '(': Result := TCPToken.Create(tkLeftParen, LValue, LPosition);
      ')': Result := TCPToken.Create(tkRightParen, LValue, LPosition);
      ';': Result := TCPToken.Create(tkSemicolon, LValue, LPosition);
      '.':
      begin
        // Check for ellipsis "..."
        if (CurrentChar() = '.') and (PeekChar(1) = '.') then
        begin
          Result := TCPToken.Create(tkEllipsis, '...', LPosition);
          NextChar(); // Skip second dot
          NextChar(); // Skip third dot
        end
        else
          Result := TCPToken.Create(tkDot, LValue, LPosition);
      end;
      ',': Result := TCPToken.Create(tkComma, LValue, LPosition);
      ':':
      begin
        // Check for assignment ":="
        if CurrentChar() = '=' then
        begin
          Result := TCPToken.Create(tkAssign, ':=', LPosition);
          NextChar(); // Skip the '=' character
        end
        else
          Result := TCPToken.Create(tkColon, LValue, LPosition);
      end;
      '<':
      begin
        // Check for "<=" or "<>"
        if CurrentChar() = '=' then
        begin
          Result := TCPToken.Create(tkLessThanOrEqual, '<=', LPosition);
          NextChar(); // Skip '='
        end
        else if CurrentChar() = '>' then
        begin
          Result := TCPToken.Create(tkNotEqual, '<>', LPosition);
          NextChar(); // Skip '>'
        end
        else
          Result := TCPToken.Create(tkLessThan, LValue, LPosition);
      end;
      '>':
      begin
        // Check for ">="
        if CurrentChar() = '=' then
        begin
          Result := TCPToken.Create(tkGreaterThanOrEqual, '>=', LPosition);
          NextChar(); // Skip '='
        end
        else
          Result := TCPToken.Create(tkGreaterThan, LValue, LPosition);
      end;
      '=': Result := TCPToken.Create(tkEqual, LValue, LPosition);
      else
      begin
        ReportLexerError(Format('Unexpected character: %s', [LChar]));
        
        // If we should stop after this error, return EOF immediately
        if FErrorHandler.ShouldStopParsing() then
          Result := TCPToken.Create(tkEOF, '', LPosition)
        else
          Result := TCPToken.Create(tkUnknown, LValue, LPosition);
      end;
    end;
  end;
end;

// =============================================================================
// TCPParser Implementation
// =============================================================================

constructor TCPParser.Create(const ALexer: TCPLexer; const AErrorHandler: TCPErrorHandler);
begin
  inherited Create();
  FLexer := ALexer;
  FErrorHandler := AErrorHandler;
  FCurrentToken := FLexer.NextToken();
  
  // Set parsing phase
  FErrorHandler.SetCurrentPhase(cpSyntaxAnalysis);
end;

destructor TCPParser.Destroy();
begin
  inherited Destroy();
end;

function TCPParser.CurrentToken(): TCPToken;
begin
  Result := FCurrentToken;
end;

function TCPParser.NextToken(): TCPToken;
begin
  FCurrentToken := FLexer.NextToken();
  Result := FCurrentToken;
end;

function TCPParser.Accept(const ATokenType: TCPTokenType): Boolean;
begin
  if CurrentToken().TokenType = ATokenType then
  begin
    NextToken();
    Result := True;
  end
  else
    Result := False;
end;

function TCPParser.Expect(const ATokenType: TCPTokenType): TCPToken;
begin
  // Check if we should stop parsing before processing
  if FErrorHandler.ShouldStopParsing() then
  begin
    Result := CurrentToken();
    Exit;
  end;
  
  if CurrentToken().TokenType = ATokenType then
  begin
    Result := CurrentToken();
    NextToken();
  end
  else
  begin
    ReportParseError(Format('Expected %s but found %s', 
      [CPTokenTypeToString(ATokenType), CPTokenTypeToString(CurrentToken().TokenType)]));
    Result := CurrentToken();
  end;
end;

procedure TCPParser.ReportParseError(const AMessage: string);
begin
  FErrorHandler.ReportError(CurrentToken().Position.Line, CurrentToken().Position.Column, 
                           'Parse error: ' + AMessage);
  
  // IMMEDIATE stop check after reporting error
  if FErrorHandler.ShouldStopParsing() then
  begin
    // Create an EOF token to stop parsing immediately
    FCurrentToken := TCPToken.Create(tkEOF, '', CurrentToken().Position);
  end;
end;

procedure TCPParser.ReportParseWarning(const AMessage: string; const AHint: string = '');
begin
  FErrorHandler.ReportWarning(CurrentToken().Position.Line, CurrentToken().Position.Column,
                             wlWarning, wcSyntax, 'Parse warning: ' + AMessage, AHint);
end;

function TCPParser.Parse(): TCPAstProgram;
begin
  try
    Result := ParseProgram();
    
    // If ParseProgram returned nil due to stop-on-error, return nil
    if not Assigned(Result) and FErrorHandler.ShouldStopParsing() then
    begin
      Result := nil;
      Exit;
    end;
    
  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E, CurrentToken().Position.Line, CurrentToken().Position.Column);
      Result := nil;
    end;
  end;
end;

function TCPParser.ParseProgram(): TCPAstProgram;
var
  LPosition: TCPSourceLocation;
  LProgramName: string;
  LDeclarations: TCPAstDeclarations;
  LMainStatement: TCPAstCompoundStatement;
begin
  LPosition := CurrentToken().Position;
  
  // Parse: program <identifier> ;
  Expect(tkProgram);
  
  // Check if we should stop after first token
  if FErrorHandler.ShouldStopParsing() then
  begin
    Result := nil;
    Exit;
  end;
  
  LProgramName := Expect(tkIdentifier).Value;
  
  // Check if we should stop after identifier
  if FErrorHandler.ShouldStopParsing() then
  begin
    Result := nil;
    Exit;
  end;
  
  Expect(tkSemicolon);
  
  // Check if we should stop after semicolon
  if FErrorHandler.ShouldStopParsing() then
  begin
    Result := nil;
    Exit;
  end;
  
  // Parse declarations
  LDeclarations := ParseDeclarations();
  
  // Check if we should stop after declarations
  if FErrorHandler.ShouldStopParsing() then
  begin
    LDeclarations.Free();
    Result := nil;
    Exit;
  end;
  
  // Parse main compound statement
  LMainStatement := ParseCompoundStatement();
  
  // Check if we should stop after main statement
  if FErrorHandler.ShouldStopParsing() then
  begin
    LDeclarations.Free();
    LMainStatement.Free();
    Result := nil;
    Exit;
  end;
  
  // Expect final dot
  Expect(tkDot);
  
  Result := TCPAstProgram.Create(LPosition, LProgramName, LDeclarations, LMainStatement);
end;

function TCPParser.ParseDeclarations(): TCPAstDeclarations;
var
  LPosition: TCPSourceLocation;
  LFunctions: TList<TCPAstExternalFunction>;
  LVariables: TList<TCPAstVariableDecl>;
  LFunction: TCPAstExternalFunction;
  LVarArray: TArray<TCPAstVariableDecl>;
  LVar: TCPAstVariableDecl;
begin
  LPosition := CurrentToken().Position;
  LFunctions := TList<TCPAstExternalFunction>.Create();
  LVariables := TList<TCPAstVariableDecl>.Create();
  try
    // Parse declarations in any order
    while (CurrentToken().TokenType = tkProcedure) or (CurrentToken().TokenType = tkFunction) or (CurrentToken().TokenType = tkVar) do
    begin
      if CurrentToken().TokenType = tkVar then
      begin
        // Parse variable section
        LVarArray := ParseVarSection();
        for LVar in LVarArray do
          LVariables.Add(LVar);
      end
      else
      begin
        // Parse external function declarations
        LFunction := ParseExternalFunction();
        if Assigned(LFunction) then
          LFunctions.Add(LFunction);
      end;
    end;
    
    Result := TCPAstDeclarations.Create(LPosition, LFunctions.ToArray(), LVariables.ToArray());
  finally
    LVariables.Free();
    LFunctions.Free();
  end;
end;

function TCPParser.ParseExternalFunction(): TCPAstExternalFunction;
var
  LPosition: TCPSourceLocation;
  LFunctionName: string;
  LParameters: TArray<TCPAstParameter>;
  LReturnType: TCPAstTypeReference;
  LCallingConvention: TCPCallingConvention;
  LExternalLib: string;
  LIsProcedure: Boolean;
  LIsVariadic: Boolean;
begin
  LPosition := CurrentToken().Position;
  LCallingConvention := ccCdecl; // Default
  LExternalLib := '';
  LReturnType := nil;
  
  // Parse procedure or function
  LIsProcedure := CurrentToken().TokenType = tkProcedure;
  if LIsProcedure then
    Expect(tkProcedure)
  else
    Expect(tkFunction);
  
  // Parse function name
  LFunctionName := Expect(tkIdentifier).Value;
  
  // Parse parameter list
  LIsVariadic := False;
  Expect(tkLeftParen);
  if CurrentToken().TokenType <> tkRightParen then
  begin
    LParameters := ParseParameterList();
    // Check for varargs
    if CurrentToken().TokenType = tkComma then
    begin
      NextToken(); // Skip comma
      if CurrentToken().TokenType = tkEllipsis then
      begin
        NextToken(); // Skip "..."
        LIsVariadic := True;
      end;
    end;
  end
  else
    SetLength(LParameters, 0);
  Expect(tkRightParen);
  
  // Parse return type for functions
  if not LIsProcedure then
  begin
    Expect(tkColon);
    LReturnType := TCPAstTypeReference.Create(CurrentToken().Position, Expect(tkIdentifier).Value);
  end;
  
  // Parse calling convention
  if CurrentToken().TokenType in [tkCdecl, tkStdcall, tkFastcall, tkRegister] then
    LCallingConvention := ParseCallingConvention();
  
  // Parse external
  Expect(tkExternal);
  
  // Parse optional external library
  if CurrentToken().TokenType = tkString then
  begin
    LExternalLib := CurrentToken().Value;
    NextToken();
  end;
  
  Expect(tkSemicolon);
  
  Result := TCPAstExternalFunction.Create(LPosition, LFunctionName, LParameters,
    LReturnType, LCallingConvention, LExternalLib, LIsProcedure, LIsVariadic);
end;

function TCPParser.ParseVarSection(): TArray<TCPAstVariableDecl>;
var
  LVariables: TList<TCPAstVariableDecl>;
  LPosition: TCPSourceLocation;
  LVarNames: TList<string>;
  LVarName: string;
  LVarType: TCPAstTypeReference;
  LVariableDecl: TCPAstVariableDecl;
begin
  LVariables := TList<TCPAstVariableDecl>.Create();
  LVarNames := TList<string>.Create();
  try
    // Expect 'var' keyword
    Expect(tkVar);
    
    // Parse variable declarations until we hit something else
    while CurrentToken().TokenType = tkIdentifier do
    begin
      LPosition := CurrentToken().Position;
      LVarNames.Clear();
      
      // Parse identifier list: var1, var2, var3
      LVarName := Expect(tkIdentifier).Value;
      LVarNames.Add(LVarName);
      
      while CurrentToken().TokenType = tkComma do
      begin
        NextToken(); // Skip comma
        LVarName := Expect(tkIdentifier).Value;
        LVarNames.Add(LVarName);
      end;
      
      // Parse type: : TypeName
      Expect(tkColon);
      LVarType := TCPAstTypeReference.Create(CurrentToken().Position, Expect(tkIdentifier).Value);
      Expect(tkSemicolon);
      
      // Create variable declaration
      LVariableDecl := TCPAstVariableDecl.Create(LPosition, LVarNames.ToArray(), LVarType);
      LVariables.Add(LVariableDecl);
    end;
    
    Result := LVariables.ToArray();
  finally
    LVarNames.Free();
    LVariables.Free();
  end;
end;

function TCPParser.ParseParameterList(): TArray<TCPAstParameter>;
var
  LParameters: TList<TCPAstParameter>;
  LParameter: TCPAstParameter;
begin
  LParameters := TList<TCPAstParameter>.Create();
  try
    LParameter := ParseParameter();
    if Assigned(LParameter) then
      LParameters.Add(LParameter);
    
    while CurrentToken().TokenType = tkSemicolon do
    begin
      NextToken(); // Skip semicolon
      LParameter := ParseParameter();
      if Assigned(LParameter) then
        LParameters.Add(LParameter);
    end;
    
    Result := LParameters.ToArray();
  finally
    LParameters.Free();
  end;
end;

function TCPParser.ParseParameter(): TCPAstParameter;
var
  LPosition: TCPSourceLocation;
  LParamName: string;
  LParamType: TCPAstTypeReference;
  LMode: TCPParameterMode;
begin
  LPosition := CurrentToken().Position;
  LMode := pmValue; // Default
  
  // Parse optional parameter mode
  if CurrentToken().TokenType = tkConst then
  begin
    LMode := pmConst;
    NextToken();
  end
  else if CurrentToken().TokenType = tkVar then
  begin
    LMode := pmVar;
    NextToken();
  end
  else if (CurrentToken().TokenType = tkIdentifier) and SameText(CurrentToken().Value, 'out') then
  begin
    LMode := pmOut;
    NextToken();
  end;
  
  // Parse parameter name
  LParamName := Expect(tkIdentifier).Value;
  
  // Parse type
  Expect(tkColon);
  LParamType := TCPAstTypeReference.Create(CurrentToken().Position, Expect(tkIdentifier).Value);
  
  Result := TCPAstParameter.Create(LPosition, LParamName, LParamType, LMode);
end;

function TCPParser.ParseCallingConvention(): TCPCallingConvention;
begin
  case CurrentToken().TokenType of
    tkCdecl:
    begin
      NextToken();
      Result := ccCdecl;
    end;
    tkStdcall:
    begin
      NextToken();
      Result := ccStdcall;
    end;
    tkFastcall:
    begin
      NextToken();
      Result := ccFastcall;
    end;
    tkRegister:
    begin
      NextToken();
      Result := ccRegister;
    end;
    else
    begin
      ReportParseError('Expected calling convention');
      Result := ccCdecl;
    end;
  end;
end;

function TCPParser.ParseCompoundStatement(): TCPAstCompoundStatement;
var
  LPosition: TCPSourceLocation;
  LStatements: TArray<TCPAstStatement>;
begin
  LPosition := CurrentToken().Position;
  
  Expect(tkBegin);
  LStatements := ParseStatementList();
  Expect(tkEnd);
  
  Result := TCPAstCompoundStatement.Create(LPosition, LStatements);
end;

function TCPParser.ParseStatementList(): TArray<TCPAstStatement>;
var
  LStatements: TList<TCPAstStatement>;
  LStatement: TCPAstStatement;
begin
  LStatements := TList<TCPAstStatement>.Create();
  try
    while (CurrentToken().TokenType <> tkEnd) and (CurrentToken().TokenType <> tkEOF) do
    begin
      if (CurrentToken().TokenType = tkIdentifier) or (CurrentToken().TokenType = tkIf) then
      begin
        LStatement := ParseStatement();
        if Assigned(LStatement) then
          LStatements.Add(LStatement);
      end
      else if CurrentToken().TokenType = tkSemicolon then
      begin
        NextToken(); // Skip optional semicolon
      end
      else
      begin
        ReportParseError('Unexpected token in statement list');
        NextToken(); // Skip for error recovery
      end;
    end;
    
    Result := LStatements.ToArray();
  finally
    LStatements.Free();
  end;
end;

function TCPParser.ParseStatement(): TCPAstStatement;
var
  LIdentifier: string;
  LPosition: TCPSourceLocation;
  LArguments: TArray<TCPAstExpression>;
begin
  if CurrentToken().TokenType = tkIf then
  begin
    // Parse if statement
    Result := ParseIfStatement();
  end
  else if CurrentToken().TokenType = tkIdentifier then
  begin
    // Save identifier info
    LIdentifier := CurrentToken().Value;
    LPosition := CurrentToken().Position;
    NextToken(); // Advance past identifier
    
    if CurrentToken().TokenType = tkAssign then
    begin
      // This is assignment: identifier := expression
      NextToken(); // Skip :=
      Result := TCPAstAssignmentStatement.Create(LPosition, LIdentifier, ParseExpression());
    end
    else if CurrentToken().TokenType = tkLeftParen then
    begin
      // This is procedure call: identifier(args)
      // Parse the rest manually since we already consumed identifier
      NextToken(); // Skip (
      
      // Parse arguments
      if CurrentToken().TokenType <> tkRightParen then
        LArguments := ParseExpressionList()
      else
        SetLength(LArguments, 0);
      
      Expect(tkRightParen);
      Result := TCPAstProcedureCall.Create(LPosition, LIdentifier, LArguments);
    end
    else
    begin
      ReportParseError('Expected assignment (:=) or procedure call (() after identifier');
      Result := nil;
    end;
  end
  else
  begin
    ReportParseError('Expected statement');
    Result := nil;
  end;
end;

function TCPParser.ParseProcedureCall(): TCPAstProcedureCall;
var
  LPosition: TCPSourceLocation;
  LProcedureName: string;
  LArguments: TArray<TCPAstExpression>;
begin
  LPosition := CurrentToken().Position;
  
  LProcedureName := Expect(tkIdentifier).Value;
  Expect(tkLeftParen);
  
  if CurrentToken().TokenType <> tkRightParen then
    LArguments := ParseExpressionList()
  else
    SetLength(LArguments, 0);
  
  Expect(tkRightParen);
  
  Result := TCPAstProcedureCall.Create(LPosition, LProcedureName, LArguments);
end;

function TCPParser.ParseAssignmentStatement(): TCPAstAssignmentStatement;
var
  LPosition: TCPSourceLocation;
  LVariableName: string;
  LExpression: TCPAstExpression;
begin
  LPosition := CurrentToken().Position;
  
  // Parse variable name
  LVariableName := Expect(tkIdentifier).Value;
  
  // Expect assignment operator
  Expect(tkAssign);
  
  // Parse expression
  LExpression := ParseExpression();
  
  Result := TCPAstAssignmentStatement.Create(LPosition, LVariableName, LExpression);
end;

function TCPParser.ParseIfStatement(): TCPAstIfStatement;
var
  LPosition: TCPSourceLocation;
  LCondition: TCPAstExpression;
  LThenStatement: TCPAstStatement;
  LElseStatement: TCPAstStatement;
begin
  LPosition := CurrentToken().Position;
  LElseStatement := nil;
  
  // Parse: if condition then statement [else statement]
  Expect(tkIf);
  LCondition := ParseExpression();
  Expect(tkThen);
  LThenStatement := ParseStatement();
  
  // Optional else clause
  if CurrentToken().TokenType = tkElse then
  begin
    NextToken(); // Skip 'else'
    LElseStatement := ParseStatement();
  end;
  
  Result := TCPAstIfStatement.Create(LPosition, LCondition, LThenStatement, LElseStatement);
end;

function TCPParser.ParseExpression(): TCPAstExpression;
begin
  // For now, delegate to comparison expression parsing
  Result := ParseComparisonExpression();
end;

function TCPParser.ParseComparisonExpression(): TCPAstExpression;
var
  LLeft: TCPAstExpression;
  LOperator: TCPTokenType;
  LRight: TCPAstExpression;
  LPosition: TCPSourceLocation;
begin
  // Parse primary expression first
  case CurrentToken().TokenType of
    tkString:
    begin
      Result := TCPAstStringLiteral.Create(CurrentToken().Position, CurrentToken().Value);
      NextToken();
    end;
    tkCharacter:
    begin
      Result := TCPAstCharacterLiteral.Create(CurrentToken().Position, StrToIntDef(CurrentToken().Value, 0));
      NextToken();
    end;
    tkIdentifier:
    begin
      Result := TCPAstIdentifier.Create(CurrentToken().Position, CurrentToken().Value);
      NextToken();
    end;
    tkNumber:
    begin
      // Check if it's a real number (contains '.' or 'e'/'E')
      if (CurrentToken().Value.Contains('.')) or
         (CurrentToken().Value.ToLower.Contains('e')) then
      begin
        Result := TCPAstRealLiteral.Create(CurrentToken().Position, CurrentToken().Value);
      end
      else
      begin
        Result := TCPAstNumberLiteral.Create(CurrentToken().Position, CurrentToken().Value);
      end;
      NextToken();
    end;
    else
    begin
      ReportParseError('Expected expression');
      Result := nil;
      Exit;
    end;
  end;
  
  // Check for comparison operators
  if CurrentToken().TokenType in [tkEqual, tkNotEqual, tkLessThan, tkLessThanOrEqual, 
                                  tkGreaterThan, tkGreaterThanOrEqual] then
  begin
    LLeft := Result;
    LOperator := CurrentToken().TokenType;
    LPosition := CurrentToken().Position;
    NextToken(); // Skip operator
    
    // Parse right side
    LRight := ParseComparisonExpression();
    if not Assigned(LRight) then
    begin
      LLeft.Free();
      Result := nil;
      Exit;
    end;
    
    Result := TCPAstComparisonExpression.Create(LPosition, LLeft, LOperator, LRight);
  end;
end;

function TCPParser.ParseExpressionList(): TArray<TCPAstExpression>;
var
  LExpressions: TList<TCPAstExpression>;
  LExpression: TCPAstExpression;
begin
  LExpressions := TList<TCPAstExpression>.Create();
  try
    LExpression := ParseExpression();
    if Assigned(LExpression) then
      LExpressions.Add(LExpression);
    
    while CurrentToken().TokenType = tkComma do
    begin
      NextToken(); // Skip comma
      LExpression := ParseExpression();
      if Assigned(LExpression) then
        LExpressions.Add(LExpression);
    end;
    
    Result := LExpressions.ToArray();
  finally
    LExpressions.Free();
  end;
end;

initialization
begin
  Platform_InitConsole();
end;

end.
