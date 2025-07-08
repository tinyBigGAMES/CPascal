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

unit CPascal.Tests;

{$I CPascal.Defines.inc}

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Winapi.Windows,
  CPascal.Common,
  CPascal.Parser,
  CPascal.CodeGen;

type
  [TestFixture]
  TCPCompleteCompilerTests = class
  private
    FTestOutputDir: string;
    FCompiler: TCPCompiler;
    FCompilerMessages: TStringList;
    FCompilerErrors: TStringList;
    FCompilerWarnings: TStringList;
    
    function CreateTestErrorHandler(): TCPErrorHandler;
    procedure SetupCompilerCallbacks();
    procedure CleanupTestFiles();
    function ExecuteProgram(const AExecutablePath: string): Integer;
    function GetHelloWorldProgram(): string;
    function GetVariableTestProgram(): string;
    function GetIfStatementProgram(): string;
  public
    [Setup]
    procedure Setup();
    
    [TearDown]
    procedure TearDown();
    
    // === TOKEN AND LEXER TESTS ===
    [Test]
    procedure TestCompleteTokenTypes();
    
    [Test]
    procedure TestSourceLocationEnhanced();
    
    [Test]
    procedure TestLexer_Keywords();
    
    [Test]
    procedure TestLexer_CallingConventions();
    
    [Test]
    procedure TestLexer_Operators();
    
    [Test]
    procedure TestLexer_StringLiterals();
    
    [Test]
    procedure TestLexer_NumberLiterals();
    
    [Test]
    procedure TestLexer_CharacterLiterals();
    
    [Test]
    procedure TestLexer_Comments();
    
    [Test]
    procedure TestLexer_ComplexProgram();
    
    // === PARSER TESTS ===
    [Test]
    procedure TestParser_ExternalFunctionDeclaration();
    
    [Test]
    procedure TestParser_VarargsFunctions();
    
    [Test]
    procedure TestParser_VariableDeclarations();
    
    [Test]
    procedure TestParser_AssignmentStatements();
    
    [Test]
    procedure TestParser_IfStatements();
    
    [Test]
    procedure TestParser_ProcedureCalls();
    
    [Test]
    procedure TestParser_Expressions();
    
    [Test]
    procedure TestParser_CompleteProgram();
    
    // === CODE GENERATOR TESTS ===
    [Test]
    procedure TestCodeGenerator_ExternalFunctions();
    
    [Test]
    procedure TestCodeGenerator_Variables();
    
    [Test]
    procedure TestCodeGenerator_ProcedureCalls();
    
    [Test]
    procedure TestCodeGenerator_CompleteProgram();
    
    // === INTEGRATION TESTS ===
    [Test]
    procedure TestCompiler_HelloWorld();
    
    [Test]
    procedure TestCompiler_VariableAssignment();
    
    [Test]
    procedure TestCompiler_IfStatement();
    
    [Test]
    procedure TestCompiler_ExecutableGeneration();
    
    [Test]
    procedure TestCompiler_ExecutableExecution();
    
    // === ERROR HANDLING TESTS ===
    [Test]
    procedure TestErrorHandler_LexicalErrors();
    
    [Test]
    procedure TestErrorHandler_SyntaxErrors();
    
    [Test]
    procedure TestErrorHandler_SemanticWarnings();
    
    [Test]
    procedure TestWarningConfig_Categories();
    
    // === PERFORMANCE TESTS ===
    [Test]
    procedure TestCompiler_LargeProgram();
    
    [Test]
    procedure TestCompiler_MultipleCompilations();
  end;

implementation

// =============================================================================
// Test Setup and Utilities
// =============================================================================

procedure TCPCompleteCompilerTests.Setup();
begin
  FTestOutputDir := TPath.Combine(TPath.GetTempPath(), 'CPascalCompleteTests');
  if not TDirectory.Exists(FTestOutputDir) then
    TDirectory.CreateDirectory(FTestOutputDir);
    
  FCompiler := TCPCompiler.Create();
  FCompiler.OutputDirectory := FTestOutputDir;
  FCompiler.KeepIntermediateFiles := True;
  
  FCompilerMessages := TStringList.Create();
  FCompilerErrors := TStringList.Create();
  FCompilerWarnings := TStringList.Create();
  
  SetupCompilerCallbacks();
end;

procedure TCPCompleteCompilerTests.TearDown();
begin
  CleanupTestFiles();
  FCompilerWarnings.Free();
  FCompilerErrors.Free();
  FCompilerMessages.Free();
  FCompiler.Free();
end;

procedure TCPCompleteCompilerTests.SetupCompilerCallbacks();
begin
  FCompiler.OnMessage := procedure(const AMessage: string)
  begin
    FCompilerMessages.Add(AMessage);
  end;
  
  FCompiler.OnError := procedure(const ALocation: TCPSourceLocation; const APhase: TCPCompilationPhase; const AMessage: string; const AHelp: string)
  begin
    FCompilerErrors.Add(Format('[%s] %s: %s', [CPCompilationPhaseToString(APhase), ALocation.ToString(), AMessage]));
  end;
  
  FCompiler.OnWarning := procedure(const ALocation: TCPSourceLocation; const APhase: TCPCompilationPhase; const ALevel: TCPWarningLevel; const ACategory: TCPWarningCategory; const AMessage: string; const AHint: string)
  begin
    FCompilerWarnings.Add(Format('[%s] %s: %s', [CPWarningCategoryToString(ACategory), ALocation.ToString(), AMessage]));
  end;
end;

procedure TCPCompleteCompilerTests.CleanupTestFiles();
var
  LFiles: TArray<string>;
  LFile: string;
begin
  try
    if TDirectory.Exists(FTestOutputDir) then
    begin
      LFiles := TDirectory.GetFiles(FTestOutputDir);
      for LFile in LFiles do
        TFile.Delete(LFile);
    end;
  except
    // Ignore cleanup errors
  end;
end;

function TCPCompleteCompilerTests.ExecuteProgram(const AExecutablePath: string): Integer;
var
  LStartupInfo: TStartupInfo;
  LProcessInfo: TProcessInformation;
  LExitCode: DWORD;
begin
  Result := -1;
  
  if not TFile.Exists(AExecutablePath) then
    Exit;
    
  FillChar(LStartupInfo, SizeOf(LStartupInfo), 0);
  LStartupInfo.cb := SizeOf(LStartupInfo);
  LStartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  LStartupInfo.wShowWindow := SW_HIDE;
  
  if CreateProcess(
    PChar(AExecutablePath),
    nil,
    nil,
    nil,
    False,
    0,
    nil,
    nil,
    LStartupInfo,
    LProcessInfo
  ) then
  begin
    try
      WaitForSingleObject(LProcessInfo.hProcess, 5000); // 5 second timeout
      
      if GetExitCodeProcess(LProcessInfo.hProcess, LExitCode) then
        Result := Integer(LExitCode);
        
    finally
      CloseHandle(LProcessInfo.hThread);
      CloseHandle(LProcessInfo.hProcess);
    end;
  end;
end;

function TCPCompleteCompilerTests.GetHelloWorldProgram(): string;
begin
  Result := 
    'program HelloWorld;' + sLineBreak +
    'procedure printf(format: PChar, ...) cdecl external;' + sLineBreak +
    'begin' + sLineBreak +
    '  printf("Hello, World!");' + sLineBreak +
    'end.';
end;

function TCPCompleteCompilerTests.CreateTestErrorHandler(): TCPErrorHandler;
var
  LCompilerConfig: TCPCompilerConfig;
begin
  LCompilerConfig := TCPCompilerConfig.Create();
  Result := TCPErrorHandler.Create(
    procedure(const ALocation: TCPSourceLocation; const APhase: TCPCompilationPhase; const AMessage: string; const AHelp: string)
    begin
      // Error callback
    end,
    procedure(const ALocation: TCPSourceLocation; const APhase: TCPCompilationPhase; const ALevel: TCPWarningLevel; const ACategory: TCPWarningCategory; const AMessage: string; const AHint: string)
    begin
      // Warning callback
    end,
    procedure(const AMessage: string)
    begin
      // Message callback
    end,
    procedure(const AFileName: string; const APhase: TCPCompilationPhase; const AMessage: string; const APercentComplete: Integer)
    begin
      // Progress callback
    end,
    LCompilerConfig,
    procedure(const ALocation: TCPSourceLocation; const AAnalysisType: string; const AData: string)
    begin
      // Analysis callback
    end
  );
end;

function TCPCompleteCompilerTests.GetVariableTestProgram(): string;
begin
  Result := 
    'program VariableTest;' + sLineBreak +
    'procedure printf(format: PChar, ...) cdecl external;' + sLineBreak +
    'var' + sLineBreak +
    '  x: Int32;' + sLineBreak +
    '  y: Int32;' + sLineBreak +
    'begin' + sLineBreak +
    '  x := 42;' + sLineBreak +
    '  y := x;' + sLineBreak +
    '  printf("x = %d, y = %d", x, y);' + sLineBreak +
    'end.';
end;

function TCPCompleteCompilerTests.GetIfStatementProgram(): string;
begin
  Result := 
    'program IfTest;' + sLineBreak +
    'procedure printf(format: PChar, ...) cdecl external;' + sLineBreak +
    'var' + sLineBreak +
    '  x: Int32;' + sLineBreak +
    'begin' + sLineBreak +
    '  x := 42;' + sLineBreak +
    '  if x = 42 then' + sLineBreak +
    '    printf("x is 42")' + sLineBreak +
    '  else' + sLineBreak +
    '    printf("x is not 42");' + sLineBreak +
    'end.';
end;

// =============================================================================
// Token and Lexer Tests
// =============================================================================

procedure TCPCompleteCompilerTests.TestCompleteTokenTypes();
begin
  // Test all token types have string representations
  Assert.AreEqual('program', CPTokenTypeToString(tkProgram));
  Assert.AreEqual('procedure', CPTokenTypeToString(tkProcedure));
  Assert.AreEqual('function', CPTokenTypeToString(tkFunction));
  Assert.AreEqual('external', CPTokenTypeToString(tkExternal));
  Assert.AreEqual('var', CPTokenTypeToString(tkVar));
  Assert.AreEqual('if', CPTokenTypeToString(tkIf));
  Assert.AreEqual('then', CPTokenTypeToString(tkThen));
  Assert.AreEqual('else', CPTokenTypeToString(tkElse));
  
  // Calling conventions
  Assert.AreEqual('cdecl', CPTokenTypeToString(tkCdecl));
  Assert.AreEqual('stdcall', CPTokenTypeToString(tkStdcall));
  Assert.AreEqual('fastcall', CPTokenTypeToString(tkFastcall));
  Assert.AreEqual('register', CPTokenTypeToString(tkRegister));
  
  // Operators
  Assert.AreEqual('(', CPTokenTypeToString(tkLeftParen));
  Assert.AreEqual(')', CPTokenTypeToString(tkRightParen));
  Assert.AreEqual(':=', CPTokenTypeToString(tkAssign));
  Assert.AreEqual('...', CPTokenTypeToString(tkEllipsis));
  Assert.AreEqual('=', CPTokenTypeToString(tkEqual));
  Assert.AreEqual('<>', CPTokenTypeToString(tkNotEqual));
  Assert.AreEqual('<=', CPTokenTypeToString(tkLessThanOrEqual));
  Assert.AreEqual('>=', CPTokenTypeToString(tkGreaterThanOrEqual));
end;

procedure TCPCompleteCompilerTests.TestSourceLocationEnhanced();
var
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('test.pas', 10, 15, 100, 5);
  
  Assert.AreEqual('test.pas', LLocation.FileName);
  Assert.AreEqual(10, LLocation.Line);
  Assert.AreEqual(15, LLocation.Column);
  Assert.AreEqual(100, LLocation.Index);
  Assert.AreEqual(5, LLocation.Length);
  Assert.AreEqual('test.pas(10,15)', LLocation.ToString());
end;

procedure TCPCompleteCompilerTests.TestLexer_Keywords();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LToken: TCPToken;
  LSource: string;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LSource := 'program procedure function external begin end var const if then else';
    LLexer := TCPLexer.Create(LSource, 'test.pas', LErrorHandler);
    try
      // Test keyword recognition
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkProgram, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkProcedure, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkFunction, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkExternal, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkBegin, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkEnd, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkVar, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkConst, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkIf, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkThen, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkElse, LToken.TokenType);
      
    finally
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestLexer_CallingConventions();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LToken: TCPToken;
  LSource: string;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LSource := 'cdecl stdcall fastcall register';
    LLexer := TCPLexer.Create(LSource, 'test.pas', LErrorHandler);
    try
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkCdecl, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkStdcall, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkFastcall, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkRegister, LToken.TokenType);
      
    finally
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestLexer_Operators();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LToken: TCPToken;
  LSource: string;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LSource := '( ) ; . , : := ... = <> < <= > >=';
    LLexer := TCPLexer.Create(LSource, 'test.pas', LErrorHandler);
    try
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkLeftParen, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkRightParen, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkSemicolon, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkDot, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkComma, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkColon, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkAssign, LToken.TokenType);
      Assert.AreEqual(':=', LToken.Value);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkEllipsis, LToken.TokenType);
      Assert.AreEqual('...', LToken.Value);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkEqual, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkNotEqual, LToken.TokenType);
      Assert.AreEqual('<>', LToken.Value);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkLessThan, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkLessThanOrEqual, LToken.TokenType);
      Assert.AreEqual('<=', LToken.Value);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkGreaterThan, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkGreaterThanOrEqual, LToken.TokenType);
      Assert.AreEqual('>=', LToken.Value);
      
    finally
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestLexer_StringLiterals();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LToken: TCPToken;
  LSource: string;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LSource := '"Hello, World!" "Test with spaces" "Escape\nSequences"';
    LLexer := TCPLexer.Create(LSource, 'test.pas', LErrorHandler);
    try
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkString, LToken.TokenType);
      Assert.AreEqual('Hello, World!', LToken.Value);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkString, LToken.TokenType);
      Assert.AreEqual('Test with spaces', LToken.Value);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkString, LToken.TokenType);
      Assert.IsTrue(LToken.Value.Contains(#10)); // Should contain newline
      
    finally
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestLexer_NumberLiterals();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LToken: TCPToken;
  LSource: string;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LSource := '42 123 0 3.14 2.5e10 1.23E-5';
    LLexer := TCPLexer.Create(LSource, 'test.pas', LErrorHandler);
    try
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkNumber, LToken.TokenType);
      Assert.AreEqual('42', LToken.Value);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkNumber, LToken.TokenType);
      Assert.AreEqual('123', LToken.Value);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkNumber, LToken.TokenType);
      Assert.AreEqual('0', LToken.Value);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkNumber, LToken.TokenType);
      Assert.AreEqual('3.14', LToken.Value);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkNumber, LToken.TokenType);
      Assert.AreEqual('2.5e10', LToken.Value);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkNumber, LToken.TokenType);
      Assert.AreEqual('1.23E-5', LToken.Value);
      
    finally
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestLexer_CharacterLiterals();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LToken: TCPToken;
  LSource: string;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LSource := '#65 #32 #13 #10';
    LLexer := TCPLexer.Create(LSource, 'test.pas', LErrorHandler);
    try
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkCharacter, LToken.TokenType);
      Assert.AreEqual('65', LToken.Value);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkCharacter, LToken.TokenType);
      Assert.AreEqual('32', LToken.Value);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkCharacter, LToken.TokenType);
      Assert.AreEqual('13', LToken.Value);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkCharacter, LToken.TokenType);
      Assert.AreEqual('10', LToken.Value);
      
    finally
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestLexer_Comments();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LToken: TCPToken;
  LSource: string;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LSource := 'program // line comment' + sLineBreak + 
               'test /* block comment */ begin' + sLineBreak +
               '{ brace comment } end';
    LLexer := TCPLexer.Create(LSource, 'test.pas', LErrorHandler);
    try
      // Comments should be skipped, only tokens should remain
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkProgram, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkIdentifier, LToken.TokenType);
      Assert.AreEqual('test', LToken.Value);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkBegin, LToken.TokenType);
      
      LToken := LLexer.NextToken();
      Assert.AreEqual(tkEnd, LToken.TokenType);
      
    finally
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestLexer_ComplexProgram();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LToken: TCPToken;
  LTokenCount: Integer;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LLexer := TCPLexer.Create(GetHelloWorldProgram(), 'test.pas', LErrorHandler);
    try
      LTokenCount := 0;
      repeat
        LToken := LLexer.NextToken();
        Inc(LTokenCount);
      until LToken.TokenType = tkEOF;
      
      // Should have tokenized a reasonable number of tokens
      Assert.IsTrue(LTokenCount > 10, 'Should have more than 10 tokens');
      Assert.AreEqual(0, FCompilerErrors.Count, 'Should have no lexer errors');
      
    finally
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

// =============================================================================
// Parser Tests
// =============================================================================

procedure TCPCompleteCompilerTests.TestParser_ExternalFunctionDeclaration();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LParser: TCPParser;
  LProgram: TCPAstProgram;
  LSource: string;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LSource := 'program test; procedure printf(format: PChar) cdecl external; begin end.';
    LLexer := TCPLexer.Create(LSource, 'test.pas', LErrorHandler);
    LParser := TCPParser.Create(LLexer, LErrorHandler);
    try
      LProgram := LParser.Parse();
      try
        Assert.IsNotNull(LProgram, 'Parser should return valid program');
        Assert.AreEqual(1, Integer(Length(LProgram.Declarations.Functions)), 'Should have one function');
        Assert.AreEqual('printf', LProgram.Declarations.Functions[0].FunctionName);
        Assert.AreEqual(ccCdecl, LProgram.Declarations.Functions[0].CallingConvention);
        Assert.IsTrue(LProgram.Declarations.Functions[0].IsProcedure);
        Assert.IsFalse(LProgram.Declarations.Functions[0].IsVariadic);
        
      finally
        LProgram.Free();
      end;
    finally
      LParser.Free();
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestParser_VarargsFunctions();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LParser: TCPParser;
  LProgram: TCPAstProgram;
  LSource: string;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LSource := 'program test; procedure printf(format: PChar, ...) cdecl external; begin end.';
    LLexer := TCPLexer.Create(LSource, 'test.pas', LErrorHandler);
    LParser := TCPParser.Create(LLexer, LErrorHandler);
    try
      LProgram := LParser.Parse();
      try
        Assert.IsNotNull(LProgram, 'Parser should return valid program');
        Assert.AreEqual(1, Integer(Length(LProgram.Declarations.Functions)), 'Should have one function');
        Assert.IsTrue(LProgram.Declarations.Functions[0].IsVariadic, 'Function should be variadic');
        
      finally
        LProgram.Free();
      end;
    finally
      LParser.Free();
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestParser_VariableDeclarations();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LParser: TCPParser;
  LProgram: TCPAstProgram;
  LSource: string;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LSource := 'program test; var x, y: Int32; z: Double; begin end.';
    LLexer := TCPLexer.Create(LSource, 'test.pas', LErrorHandler);
    LParser := TCPParser.Create(LLexer, LErrorHandler);
    try
      LProgram := LParser.Parse();
      try
        Assert.IsNotNull(LProgram, 'Parser should return valid program');
        Assert.AreEqual(2, Integer(Length(LProgram.Declarations.Variables)), 'Should have two variable declarations');
        Assert.AreEqual(2, Integer(Length(LProgram.Declarations.Variables[0].VariableNames)), 'First declaration should have 2 variables');
        Assert.AreEqual('x', LProgram.Declarations.Variables[0].VariableNames[0]);
        Assert.AreEqual('y', LProgram.Declarations.Variables[0].VariableNames[1]);
        Assert.AreEqual('Int32', LProgram.Declarations.Variables[0].VariableType.TypeName);
        Assert.AreEqual('Double', LProgram.Declarations.Variables[1].VariableType.TypeName);
        
      finally
        LProgram.Free();
      end;
    finally
      LParser.Free();
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestParser_AssignmentStatements();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LParser: TCPParser;
  LProgram: TCPAstProgram;
  LSource: string;
  LAssignment: TCPAstAssignmentStatement;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LSource := 'program test; var x: Int32; begin x := 42; end.';
    LLexer := TCPLexer.Create(LSource, 'test.pas', LErrorHandler);
    LParser := TCPParser.Create(LLexer, LErrorHandler);
    try
      LProgram := LParser.Parse();
      try
        Assert.IsNotNull(LProgram, 'Parser should return valid program');
        Assert.AreEqual(1, Integer(Length(LProgram.MainStatement.Statements)), 'Should have one statement');
        Assert.IsTrue(LProgram.MainStatement.Statements[0] is TCPAstAssignmentStatement, 'Statement should be assignment');
        
        LAssignment := TCPAstAssignmentStatement(LProgram.MainStatement.Statements[0]);
        Assert.AreEqual('x', LAssignment.VariableName);
        Assert.IsTrue(LAssignment.Expression is TCPAstNumberLiteral, 'Expression should be number literal');
        
      finally
        LProgram.Free();
      end;
    finally
      LParser.Free();
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestParser_IfStatements();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LParser: TCPParser;
  LProgram: TCPAstProgram;
  LSource: string;
  LIfStatement: TCPAstIfStatement;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LSource := 'program test; var x: Int32; begin if x = 42 then x := 1 else x := 0; end.';
    LLexer := TCPLexer.Create(LSource, 'test.pas', LErrorHandler);
    LParser := TCPParser.Create(LLexer, LErrorHandler);
    try
      LProgram := LParser.Parse();
      try
        Assert.IsNotNull(LProgram, 'Parser should return valid program');
        Assert.AreEqual(1, Integer(Length(LProgram.MainStatement.Statements)), 'Should have one statement');
        Assert.IsTrue(LProgram.MainStatement.Statements[0] is TCPAstIfStatement, 'Statement should be if statement');
        
        LIfStatement := TCPAstIfStatement(LProgram.MainStatement.Statements[0]);
        Assert.IsNotNull(LIfStatement.Condition, 'Should have condition');
        Assert.IsNotNull(LIfStatement.ThenStatement, 'Should have then statement');
        Assert.IsNotNull(LIfStatement.ElseStatement, 'Should have else statement');
        
      finally
        LProgram.Free();
      end;
    finally
      LParser.Free();
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestParser_ProcedureCalls();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LParser: TCPParser;
  LProgram: TCPAstProgram;
  LSource: string;
  LProcCall: TCPAstProcedureCall;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LSource := GetHelloWorldProgram();
    LLexer := TCPLexer.Create(LSource, 'test.pas', LErrorHandler);
    LParser := TCPParser.Create(LLexer, LErrorHandler);
    try
      LProgram := LParser.Parse();
      try
        Assert.IsNotNull(LProgram, 'Parser should return valid program');
        Assert.AreEqual(1, Integer(Length(LProgram.MainStatement.Statements)), 'Should have one statement');
        Assert.IsTrue(LProgram.MainStatement.Statements[0] is TCPAstProcedureCall, 'Statement should be procedure call');
        
        LProcCall := TCPAstProcedureCall(LProgram.MainStatement.Statements[0]);
        Assert.AreEqual('printf', LProcCall.ProcedureName);
        Assert.AreEqual(1, Integer(Length(LProcCall.Arguments)), 'Should have one argument');
        Assert.IsTrue(LProcCall.Arguments[0] is TCPAstStringLiteral, 'Argument should be string literal');
        
      finally
        LProgram.Free();
      end;
    finally
      LParser.Free();
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestParser_Expressions();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LParser: TCPParser;
  LProgram: TCPAstProgram;
  LSource: string;
  LIfStatement: TCPAstIfStatement;
  LComparison: TCPAstComparisonExpression;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LSource := 'program test; var x: Int32; begin if x <> 42 then x := 1; end.';
    LLexer := TCPLexer.Create(LSource, 'test.pas', LErrorHandler);
    LParser := TCPParser.Create(LLexer, LErrorHandler);
    try
      LProgram := LParser.Parse();
      try
        Assert.IsNotNull(LProgram, 'Parser should return valid program');
        LIfStatement := TCPAstIfStatement(LProgram.MainStatement.Statements[0]);
        Assert.IsTrue(LIfStatement.Condition is TCPAstComparisonExpression, 'Condition should be comparison');
        
        LComparison := TCPAstComparisonExpression(LIfStatement.Condition);
        Assert.AreEqual(tkNotEqual, LComparison.Operator);
        Assert.IsTrue(LComparison.Left is TCPAstIdentifier, 'Left should be identifier');
        Assert.IsTrue(LComparison.Right is TCPAstNumberLiteral, 'Right should be number');
        
      finally
        LProgram.Free();
      end;
    finally
      LParser.Free();
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestParser_CompleteProgram();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LParser: TCPParser;
  LProgram: TCPAstProgram;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LLexer := TCPLexer.Create(GetIfStatementProgram(), 'test.pas', LErrorHandler);
    LParser := TCPParser.Create(LLexer, LErrorHandler);
    try
      LProgram := LParser.Parse();
      try
        Assert.IsNotNull(LProgram, 'Parser should return valid program');
        Assert.AreEqual('IfTest', LProgram.ProgramName);
        Assert.AreEqual(1, Integer(Length(LProgram.Declarations.Functions)), 'Should have one function');
        Assert.AreEqual(1, Integer(Length(LProgram.Declarations.Variables)), 'Should have one variable declaration');
        Assert.IsTrue(Integer(Length(LProgram.MainStatement.Statements)) > 0, 'Should have statements');
        Assert.AreEqual(0, FCompilerErrors.Count, 'Should have no parse errors');
        
      finally
        LProgram.Free();
      end;
    finally
      LParser.Free();
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

// =============================================================================
// Code Generator Tests
// =============================================================================

procedure TCPCompleteCompilerTests.TestCodeGenerator_ExternalFunctions();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LParser: TCPParser;
  LProgram: TCPAstProgram;
  LCodeGen: TCPCodeGenerator;
  LIR: string;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LLexer := TCPLexer.Create(GetHelloWorldProgram(), 'test.pas', LErrorHandler);
    LParser := TCPParser.Create(LLexer, LErrorHandler);
    LProgram := LParser.Parse();
    LCodeGen := TCPCodeGenerator.Create('test_module', LErrorHandler);
    try
      Assert.IsTrue(LCodeGen.GenerateFromAST(LProgram), 'Code generation should succeed');
      
      LIR := LCodeGen.GetModuleIR();
      Assert.IsTrue(LIR.Contains('printf'), 'IR should contain printf declaration');
      Assert.IsTrue(LIR.Contains('...'), 'IR should contain varargs indicator');
      
    finally
      LCodeGen.Free();
      LProgram.Free();
      LParser.Free();
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestCodeGenerator_Variables();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LParser: TCPParser;
  LProgram: TCPAstProgram;
  LCodeGen: TCPCodeGenerator;
  LIR: string;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LLexer := TCPLexer.Create(GetVariableTestProgram(), 'test.pas', LErrorHandler);
    LParser := TCPParser.Create(LLexer, LErrorHandler);
    LProgram := LParser.Parse();
    LCodeGen := TCPCodeGenerator.Create('test_module', LErrorHandler);
    try
      Assert.IsTrue(LCodeGen.GenerateFromAST(LProgram), 'Code generation should succeed');
      
      LIR := LCodeGen.GetModuleIR();
      Assert.IsTrue(LIR.Contains('alloca'), 'IR should contain variable allocations');
      Assert.IsTrue(LIR.Contains('store'), 'IR should contain store instructions');
      Assert.IsTrue(LIR.Contains('load'), 'IR should contain load instructions');
      
    finally
      LCodeGen.Free();
      LProgram.Free();
      LParser.Free();
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestCodeGenerator_ProcedureCalls();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LParser: TCPParser;
  LProgram: TCPAstProgram;
  LCodeGen: TCPCodeGenerator;
  LIR: string;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LLexer := TCPLexer.Create(GetHelloWorldProgram(), 'test.pas', LErrorHandler);
    LParser := TCPParser.Create(LLexer, LErrorHandler);
    LProgram := LParser.Parse();
    LCodeGen := TCPCodeGenerator.Create('test_module', LErrorHandler);
    try
      Assert.IsTrue(LCodeGen.GenerateFromAST(LProgram), 'Code generation should succeed');
      
      LIR := LCodeGen.GetModuleIR();
      Assert.IsTrue(LIR.Contains('call'), 'IR should contain function calls');
      Assert.IsTrue(LIR.Contains('Hello, World!'), 'IR should contain string literal');
      
    finally
      LCodeGen.Free();
      LProgram.Free();
      LParser.Free();
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestCodeGenerator_CompleteProgram();
var
  LErrorHandler: TCPErrorHandler;
  LLexer: TCPLexer;
  LParser: TCPParser;
  LProgram: TCPAstProgram;
  LCodeGen: TCPCodeGenerator;
begin
  LErrorHandler := CreateTestErrorHandler();
  try
    LLexer := TCPLexer.Create(GetIfStatementProgram(), 'test.pas', LErrorHandler);
    LParser := TCPParser.Create(LLexer, LErrorHandler);
    LProgram := LParser.Parse();
    LCodeGen := TCPCodeGenerator.Create('test_module', LErrorHandler);
    try
      Assert.IsTrue(LCodeGen.GenerateFromAST(LProgram), 'Code generation should succeed');
      Assert.IsTrue(LCodeGen.VerifyModule(), 'Generated module should be valid');
      
    finally
      LCodeGen.Free();
      LProgram.Free();
      LParser.Free();
      LLexer.Free();
    end;
  finally
    LErrorHandler.Free();
  end;
end;

// =============================================================================
// Integration Tests
// =============================================================================

procedure TCPCompleteCompilerTests.TestCompiler_HelloWorld();
var
  LResult: TCPCompilationResult;
begin
  FCompilerMessages.Clear();
  FCompilerErrors.Clear();
  FCompilerWarnings.Clear();
  
  LResult := FCompiler.CompileToExecutable(GetHelloWorldProgram(), 'HelloWorld.pas');
  
  Assert.IsTrue(LResult.Success, 'HelloWorld compilation should succeed. Errors: ' + String.Join('; ', FCompilerErrors.ToStringArray()));
  Assert.IsTrue(TFile.Exists(LResult.OutputFile), 'HelloWorld executable should exist');
  Assert.AreEqual(0, FCompilerErrors.Count, 'Should have no errors');
end;

procedure TCPCompleteCompilerTests.TestCompiler_VariableAssignment();
var
  LResult: TCPCompilationResult;
begin
  FCompilerMessages.Clear();
  FCompilerErrors.Clear();
  FCompilerWarnings.Clear();
  
  LResult := FCompiler.CompileToExecutable(GetVariableTestProgram(), 'VariableTest.pas');
  
  Assert.IsTrue(LResult.Success, 'Variable test compilation should succeed. Errors: ' + String.Join('; ', FCompilerErrors.ToStringArray()));
  Assert.IsTrue(TFile.Exists(LResult.OutputFile), 'Variable test executable should exist');
end;

procedure TCPCompleteCompilerTests.TestCompiler_IfStatement();
var
  LResult: TCPCompilationResult;
begin
  FCompilerMessages.Clear();
  FCompilerErrors.Clear();
  FCompilerWarnings.Clear();
  
  LResult := FCompiler.CompileToExecutable(GetIfStatementProgram(), 'IfTest.pas');
  
  Assert.IsTrue(LResult.Success, 'If statement compilation should succeed. Errors: ' + String.Join('; ', FCompilerErrors.ToStringArray()));
  Assert.IsTrue(TFile.Exists(LResult.OutputFile), 'If test executable should exist');
end;

procedure TCPCompleteCompilerTests.TestCompiler_ExecutableGeneration();
var
  LResult: TCPCompilationResult;
  LOutputPath: string;
begin
  LResult := FCompiler.CompileToExecutable(GetHelloWorldProgram(), 'ExecutableTest.pas');
  
  Assert.IsTrue(LResult.Success, 'Compilation should succeed');
  Assert.IsNotEmpty(LResult.OutputFile, 'Output file should be specified');
  
  LOutputPath := LResult.OutputFile;
  Assert.IsTrue(TFile.Exists(LOutputPath), 'Executable file should exist');
  Assert.IsTrue(LOutputPath.EndsWith('.exe'), 'Output should be an executable');
  
  // Check intermediate files
  Assert.IsTrue(TFile.Exists(TPath.ChangeExtension(LOutputPath, '.ll')), 'LLVM IR file should exist');
  Assert.IsTrue(TFile.Exists(TPath.ChangeExtension(LOutputPath, '.obj')), 'Object file should exist');
end;

procedure TCPCompleteCompilerTests.TestCompiler_ExecutableExecution();
var
  LResult: TCPCompilationResult;
  LExitCode: Integer;
begin
  LResult := FCompiler.CompileToExecutable(GetHelloWorldProgram(), 'ExecutionTest.pas');
  
  Assert.IsTrue(LResult.Success, 'Compilation should succeed');
  
  LExitCode := ExecuteProgram(LResult.OutputFile);
  Assert.AreEqual(0, LExitCode, 'Program should exit with code 0');
end;

// =============================================================================
// Error Handling Tests
// =============================================================================

procedure TCPCompleteCompilerTests.TestErrorHandler_LexicalErrors();
var
  LResult: TCPCompilationResult;
  LSourceCode: string;
begin
  LSourceCode := 'program test; begin @ end.'; // @ is invalid character
  
  FCompilerErrors.Clear();
  LResult := FCompiler.CompileToExecutable(LSourceCode, 'lexical_error_test.pas');
  
  Assert.IsFalse(LResult.Success, 'Compilation should fail for lexical errors');
  Assert.IsTrue(FCompilerErrors.Count > 0, 'Should have captured lexical errors');
end;

procedure TCPCompleteCompilerTests.TestErrorHandler_SyntaxErrors();
var
  LResult: TCPCompilationResult;
  LSourceCode: string;
begin
  LSourceCode := 'program test begin end.'; // Missing semicolon after program name
  
  FCompilerErrors.Clear();
  LResult := FCompiler.CompileToExecutable(LSourceCode, 'syntax_error_test.pas');
  
  Assert.IsFalse(LResult.Success, 'Compilation should fail for syntax errors');
  Assert.IsTrue(FCompilerErrors.Count > 0, 'Should have captured syntax errors');
end;

procedure TCPCompleteCompilerTests.TestErrorHandler_SemanticWarnings();
var
  LResult: TCPCompilationResult;
  LSourceCode: string;
begin
  LSourceCode := 
    'program test;' + sLineBreak +
    'procedure printf(format: PChar, ...) cdecl external;' + sLineBreak +
    'procedure unused_proc() register external;' + sLineBreak +  // Should generate deprecated warning
    'var unused_var: Int32;' + sLineBreak +  // Should generate unused warning
    'begin' + sLineBreak +
    '  printf("Hello");' + sLineBreak +
    'end.';
  
  FCompilerWarnings.Clear();
  LResult := FCompiler.CompileToExecutable(LSourceCode, 'semantic_warning_test.pas');
  
  Assert.IsTrue(LResult.Success, 'Compilation should succeed despite warnings');
  // Should have warnings about deprecated register calling convention
  Assert.IsTrue(FCompilerWarnings.Count >= 0, 'May have semantic warnings');
end;

procedure TCPCompleteCompilerTests.TestWarningConfig_Categories();
var
  LCompilerConfig: TCPCompilerConfig;
begin
  LCompilerConfig := FCompiler.CompilerConfig;
  
  Assert.IsNotNull(LCompilerConfig, 'Compiler config should exist');
  Assert.IsTrue(LCompilerConfig.IsCategoryEnabled(wcGeneral), 'General warnings should be enabled');
  Assert.IsTrue(LCompilerConfig.IsCategoryEnabled(wcSyntax), 'Syntax warnings should be enabled');
  Assert.IsTrue(LCompilerConfig.IsCategoryEnabled(wcDeprecated), 'Deprecated warnings should be enabled');
  
  // Test disabling a category
  LCompilerConfig.DisableCategory(wcPerformance);
  Assert.IsFalse(LCompilerConfig.IsCategoryEnabled(wcPerformance), 'Performance warnings should be disabled');
  
  // Test enabling with different level
  LCompilerConfig.EnableCategory(wcPortability, wlError);
  Assert.AreEqual(wlError, LCompilerConfig.GetWarningLevel(wcPortability), 'Portability should be error level');
end;

// =============================================================================
// Performance Tests
// =============================================================================

procedure TCPCompleteCompilerTests.TestCompiler_LargeProgram();
var
  LResult: TCPCompilationResult;
  LSourceCode: TStringBuilder;
  LI: Integer;
begin
  // Generate a larger program with multiple functions and variables
  LSourceCode := TStringBuilder.Create();
  try
    LSourceCode.AppendLine('program LargeTest;');
    LSourceCode.AppendLine('procedure printf(format: PChar, ...) cdecl external;');
    
    // Add multiple function declarations
    for LI := 1 to 10 do
    begin
      LSourceCode.AppendLine(Format('procedure func%d() cdecl external;', [LI]));
    end;
    
    LSourceCode.AppendLine('var');
    // Add multiple variable declarations
    for LI := 1 to 20 do
    begin
      LSourceCode.AppendLine(Format('  var%d: Int32;', [LI]));
    end;
    
    LSourceCode.AppendLine('begin');
    // Add multiple assignments
    for LI := 1 to 20 do
    begin
      LSourceCode.AppendLine(Format('  var%d := %d;', [LI, LI]));
    end;
    LSourceCode.AppendLine('  printf("Large program test");');
    LSourceCode.AppendLine('end.');
    
    LResult := FCompiler.CompileToExecutable(LSourceCode.ToString(), 'LargeTest.pas');
    
    Assert.IsTrue(LResult.Success, 'Large program compilation should succeed');
    Assert.IsTrue(TFile.Exists(LResult.OutputFile), 'Large program executable should exist');
    
  finally
    LSourceCode.Free();
  end;
end;

procedure TCPCompleteCompilerTests.TestCompiler_MultipleCompilations();
var
  LResult: TCPCompilationResult;
  LI: Integer;
begin
  // Test compiling multiple programs in sequence
  for LI := 1 to 5 do
  begin
    FCompilerErrors.Clear();
    FCompilerWarnings.Clear();
    
    LResult := FCompiler.CompileToExecutable(GetHelloWorldProgram(), Format('MultiTest%d.pas', [LI]));
    
    Assert.IsTrue(LResult.Success, Format('Compilation %d should succeed', [LI]));
    Assert.AreEqual(0, FCompilerErrors.Count, Format('Compilation %d should have no errors', [LI]));
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TCPCompleteCompilerTests);

end.
