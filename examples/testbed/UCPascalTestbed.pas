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

unit UCPascalTestbed;

interface

procedure RunCPascalTestbed();

implementation

uses
  System.SysUtils,
  System.TypInfo,
  CPascal.Common,
  CPascal.CodeGen;


procedure Pause();
begin
  WriteLn;
  Write('Press ENTER to continue...');
  ReadLn;
  WriteLn;
end;


procedure Coverage();
const
  CSourceCode1 =
  '''
  program Coverage;

  procedure printf(format: PChar, ...) cdecl external;
  var
    LNumber: Int32;
    LUnusedVar: Int32;  // To trigger unused variable warning
  begin
    printf("Hello, World!\n");
    printf("Value: %d\n", 42);
    printf("Float: %f\n", 3.14);
    printf("Scientific: %e\n", 2.5e-3);
    printf("Large: %f\n", 1.0E+5);
    LNumber := 42;
    printf("Number: %d"#10, LNumber);
  end.
  ''';

  CSourceCode2 =
  '''
  program Coverage;

  procedure printf(format: PChar, ...) cdecl external;

  var
    LNumber: Int32;
  begin
    printf("Hello, World!\n");
    printf("Value: %d\n", 42);
    printf("Float: %f\n", 3.14);
    printf("Scientific: %e\n", 2.5e-3);
    printf("Large: %f\n", 1.0E+5);
    LNumber := 42;
    printf("Number: %d"#10, LNumber);
  end.
  ''';

  CSourceCode =
  '''
  program Coverage;
  procedure printf(format: PChar, ...) cdecl external;
  function getchar(): Int32 cdecl external;
  function fflush(stream: int32): Int32 cdecl external;
  var
    LNumber: Int32;
    x: Int32;        // This comment will now be ignored
    pi: Double;
  begin
    printf("Hello, World!\n");
    printf("Value: %d\n", 42);
    printf("Float: %f\n", 3.14);
    printf("Scientific: %e\n", 2.5e-3);
    printf("Large: %f\n", 1.0E+5);
    LNumber := 42;
    printf("Number: %d"#10, LNumber);
    x := 10;
    pi := 3.14159;
    // Integer comparisons          <- This will be skipped
    if x > 5 then
      printf("Integer comparison works\n");
    // Float comparisons            <- This will be skipped
    if pi >= 3.0 then
      printf("Float comparison works\n");
    // Mixed expressions...         <- This will be skipped
    if 2.5 < 3.7 then
      printf("Float literal comparison works\n");

    printf("\n");
    printf("Press ENTER to continue...");
    fflush(0);        // Ensure text appears before waiting
    getchar();             // Wait for ENTER key
    printf("\n");
  end.
  ''';

  // NEW: Test code with intentional errors to demonstrate error limiting
  CErrorTestCode =
  '''
  program ErrorTest;
  procedure printf(format: PChar, ...) cdecl external;
  var
    x: Int32;
  begin
    @ invalid character here  // Lexical error
    x := ;                    // Syntax error
    printf("This won't compile");
  end.
  ''';

var
  LCompiler: TCPCompiler;
  LResult: TCPCompilationResult;
begin
  WriteLn('=== Coverage: Enhanced CPascal Compiler Test ===');
  WriteLn('Source: ' + CSourceCode);
  WriteLn('');

  LCompiler := TCPCompiler.Create();
  try
    // Enhanced startup callback
    LCompiler.OnStartup := procedure()
    begin
      WriteLn('[STARTUP]  CPascal compiler initializing...');
    end;

    // Enhanced shutdown callback with statistics
    LCompiler.OnShutdown := procedure(const ASuccess: Boolean; const ATotalErrors, ATotalWarnings: Integer)
    begin
      WriteLn('');
      WriteLn('[SHUTDOWN] Compilation completed');
      WriteLn(Format('[SHUTDOWN] Success: %s', [BoolToStr(ASuccess, True)]));
      WriteLn(Format('[SHUTDOWN] Total Errors: %d', [ATotalErrors]));
      WriteLn(Format('[SHUTDOWN] Total Warnings: %d', [ATotalWarnings]));
    end;

    // Enhanced message callback
    LCompiler.OnMessage := procedure(const AMessage: string)
    begin
      Write(Format('[MESSAGE]  %s', [AMessage]));
    end;

    // Enhanced progress callback with phase and percentage
    LCompiler.OnProgress := procedure(const AFileName: string; const APhase: TCPCompilationPhase; const AMessage: string; const APercentComplete: Integer = -1)
    var
      LPhase: string;
      LPercent: string;
    begin
      case APhase of
        cpInitialization  : LPhase := 'Initialization';
        cpLexicalAnalysis : LPhase := 'LexicalAnalysis';
        cpSyntaxAnalysis  : LPhase := 'SyntaxAnalysis';
        cpSemanticAnalysis: LPhase := 'SemanticAnalysis';
        cpCodeGeneration  : LPhase := 'CodeGeneration';
        cpOptimization    : LPhase := 'Optimization';
        cpLinking         : LPhase := 'Linking';
        cpFinalization    : LPhase := 'Finalization';
      end;

      if APercentComplete >= 0 then
        LPercent := Format(' (%d%%)', [APercentComplete])
      else
        LPercent := '';

      WriteLn(Format('[PROGRESS] [%s]%s %s', [LPhase, LPercent, AMessage]));
    end;

    // Enhanced error callback with location context and help
    LCompiler.OnError := procedure(const ALocation: TCPSourceLocation; const APhase: TCPCompilationPhase; const AMessage: string; const AHelp: string = '')
    var
      LPhase: string;
    begin
      case APhase of
        cpInitialization  : LPhase := 'Init';
        cpLexicalAnalysis : LPhase := 'Lex';
        cpSyntaxAnalysis  : LPhase := 'Parse';
        cpSemanticAnalysis: LPhase := 'Semantic';
        cpCodeGeneration  : LPhase := 'CodeGen';
        cpOptimization    : LPhase := 'Optimize';
        cpLinking         : LPhase := 'Link';
        cpFinalization    : LPhase := 'Final';
      end;

      WriteLn(Format('[ERROR]    [%s] %s(%d:%d): %s', [LPhase, ALocation.FileName, ALocation.Line, ALocation.Column, AMessage]));

      if ALocation.LineContent <> '' then
        WriteLn(Format('[ERROR]      Source: %s', [Trim(ALocation.LineContent)]));

      if AHelp <> '' then
        WriteLn(Format('[ERROR]      Help: %s', [AHelp]));
    end;

    // Enhanced warning callback with categories and levels
    LCompiler.OnWarning := procedure(const ALocation: TCPSourceLocation; const APhase: TCPCompilationPhase; const ALevel: TCPWarningLevel; const ACategory: TCPWarningCategory; const AMessage: string; const AHint: string = '')
    var
      LPhase: string;
      LLevel: string;
      LCategory: string;
    begin
      case APhase of
        cpInitialization  : LPhase := 'Init';
        cpLexicalAnalysis : LPhase := 'Lex';
        cpSyntaxAnalysis  : LPhase := 'Parse';
        cpSemanticAnalysis: LPhase := 'Semantic';
        cpCodeGeneration  : LPhase := 'CodeGen';
        cpOptimization    : LPhase := 'Optimize';
        cpLinking         : LPhase := 'Link';
        cpFinalization    : LPhase := 'Final';
      end;

      case ALevel of
        wlInfo:    LLevel := 'Info';
        wlHint:    LLevel := 'Hint';
        wlWarning: LLevel := 'Warning';
        wlError:   LLevel := 'Error';
      end;

      case ACategory of
        wcGeneral:       LCategory := 'General';
        wcSyntax:        LCategory := 'Syntax';
        wcSemantic:      LCategory := 'Semantic';
        wcUnusedCode:    LCategory := 'UnusedCode';
        wcCompatibility: LCategory := 'Compatibility';
        wcPerformance:   LCategory := 'Performance';
        wcPortability:   LCategory := 'Portability';
        wcDeprecated:    LCategory := 'Deprecated';
      end;

      WriteLn(Format('[WARNING]  [%s] [%s/%s] %s(%d:%d): %s', [LPhase, LLevel, LCategory, ALocation.FileName, ALocation.Line, ALocation.Column, AMessage]));

      if ALocation.LineContent <> '' then
        WriteLn(Format('[WARNING]    Source: %s', [Trim(ALocation.LineContent)]));

      if AHint <> '' then
        WriteLn(Format('[WARNING]    Hint: %s', [AHint]));
    end;

    // Enhanced analysis callback for IDE integration
    LCompiler.OnAnalysis := procedure(const ALocation: TCPSourceLocation; const AAnalysisType: string; const AData: string)
    begin
      WriteLn(Format('[ANALYSIS] [%s] %s(%d:%d): %s', [AAnalysisType, ALocation.FileName, ALocation.Line, ALocation.Column, AData]));
    end;

    // === NEW: Configure Enhanced Compiler System (TCPCompilerConfig) ===

    // Warning category configuration
    LCompiler.CompilerConfig.EnableCategory(wcGeneral, wlWarning);
    LCompiler.CompilerConfig.EnableCategory(wcSyntax, wlWarning);
    LCompiler.CompilerConfig.EnableCategory(wcSemantic, wlWarning);
    LCompiler.CompilerConfig.EnableCategory(wcUnusedCode, wlHint);
    LCompiler.CompilerConfig.EnableCategory(wcCompatibility, wlWarning);
    LCompiler.CompilerConfig.EnableCategory(wcPerformance, wlHint);
    LCompiler.CompilerConfig.EnableCategory(wcPortability, wlHint);
    LCompiler.CompilerConfig.EnableCategory(wcDeprecated, wlWarning);

    // Legacy warning settings
    LCompiler.CompilerConfig.TreatWarningsAsErrors := False;
    LCompiler.CompilerConfig.MaxWarnings := 50;

    // NEW: Error limiting configuration
    LCompiler.CompilerConfig.MaxErrors := 10;              // Stop after 10 errors
    LCompiler.CompilerConfig.StopOnFirstError := False;    // Collect multiple errors
    LCompiler.CompilerConfig.ContinueOnError := False;     // Don't continue to code generation if errors exist
    LCompiler.CompilerConfig.StrictMode := False;          // Reasonable defaults

    // Configure compiler settings
    LCompiler.OutputDirectory := 'output';
    LCompiler.KeepIntermediateFiles := True;

    // Configure linker
    LCompiler.LinkerConfig.Subsystem := stConsole;
    LCompiler.LinkerConfig.SetDefaultLibraries();

    WriteLn('[CONFIG]   Enhanced compiler configuration loaded');
    WriteLn(Format('[CONFIG]   Warning categories enabled: %d', [8])); // All categories
    WriteLn(Format('[CONFIG]   Max warnings: %d', [LCompiler.CompilerConfig.MaxWarnings]));
    WriteLn(Format('[CONFIG]   Max errors: %d', [LCompiler.CompilerConfig.MaxErrors]));
    WriteLn(Format('[CONFIG]   Stop on first error: %s', [BoolToStr(LCompiler.CompilerConfig.StopOnFirstError, True)]));
    WriteLn(Format('[CONFIG]   Continue on error: %s', [BoolToStr(LCompiler.CompilerConfig.ContinueOnError, True)]));
    WriteLn(Format('[CONFIG]   Strict mode: %s', [BoolToStr(LCompiler.CompilerConfig.StrictMode, True)]));
    WriteLn(Format('[CONFIG]   Output directory: %s', [LCompiler.OutputDirectory]));
    WriteLn(Format('[CONFIG]   Keep intermediates: %s', [BoolToStr(LCompiler.KeepIntermediateFiles, True)]));
    WriteLn(Format('[CONFIG]   Linker subsystem: %s', [GetEnumName(TypeInfo(TCPSubsystemType), Ord(LCompiler.LinkerConfig.Subsystem))]));
    WriteLn('');

    // Execute enhanced compilation with SUCCESS case
    WriteLn('=== TEST 1: Valid Code (Should Succeed) ===');
    LResult := LCompiler.CompileToExecutable(CSourceCode, 'coverage.pas');

    WriteLn('');
    if LResult.Success then
    begin
      WriteLn('✅ COMPILATION SUCCESS');
      WriteLn(Format('   Output: %s', [LResult.OutputFile]));
    end
    else
    begin
      WriteLn('❌ COMPILATION FAILED');
      if LResult.ErrorMessage <> '' then
        WriteLn(Format('   Error: %s', [LResult.ErrorMessage]));
    end;

    // Display statistics for first test
    WriteLn('');
    WriteLn('=== Test 1 Statistics ===');
    WriteLn(Format('Errors: %d', [LCompiler.CompilerConfig.ErrorCount]));
    WriteLn(Format('Warnings: %d', [LCompiler.CompilerConfig.WarningCount]));
    WriteLn(Format('Error limit reached: %s', [BoolToStr(LCompiler.CompilerConfig.HasReachedErrorLimit(), True)]));
    WriteLn(Format('Warning limit reached: %s', [BoolToStr(LCompiler.CompilerConfig.HasReachedWarningLimit(), True)]));

    // === NEW: Test Error Limiting Functionality ===
    WriteLn('');
    WriteLn('=== TEST 2: Error Limiting Demo (Should Fail Fast) ===');

    // Configure strict error limiting for demonstration
    LCompiler.CompilerConfig.MaxErrors := 3;              // Very low limit
    LCompiler.CompilerConfig.StopOnFirstError := False;   // Allow collection of a few errors

    WriteLn(Format('[CONFIG]   Lowered MaxErrors to %d for demonstration', [LCompiler.CompilerConfig.MaxErrors]));
    WriteLn('[CONFIG]   Testing with invalid code...');
    WriteLn('');

    LResult := LCompiler.CompileToExecutable(CErrorTestCode, 'error_test.pas');

    WriteLn('');
    if LResult.Success then
    begin
      WriteLn('✅ COMPILATION SUCCESS (Unexpected!)');
      WriteLn(Format('   Output: %s', [LResult.OutputFile]));
    end
    else
    begin
      WriteLn('❌ COMPILATION FAILED (Expected)');
      if LResult.ErrorMessage <> '' then
        WriteLn(Format('   Error: %s', [LResult.ErrorMessage]));
    end;

    // Display statistics for error test
    WriteLn('');
    WriteLn('=== Test 2 Statistics ===');
    WriteLn(Format('Errors: %d', [LCompiler.CompilerConfig.ErrorCount]));
    WriteLn(Format('Warnings: %d', [LCompiler.CompilerConfig.WarningCount]));
    WriteLn(Format('Error limit reached: %s', [BoolToStr(LCompiler.CompilerConfig.HasReachedErrorLimit(), True)]));
    WriteLn(Format('Should stop on error: %s', [BoolToStr(LCompiler.CompilerConfig.ShouldStopOnError(), True)]));

    // === NEW: Test StopOnFirstError Mode ===
    WriteLn('');
    WriteLn('=== TEST 3: Stop On First Error Demo ===');

    // Configure stop on first error
    LCompiler.CompilerConfig.Reset();
    LCompiler.CompilerConfig.StopOnFirstError := True;
    LCompiler.CompilerConfig.MaxErrors := 20;             // Higher limit, but stop on first

    WriteLn('[CONFIG]   Enabled StopOnFirstError mode');
    WriteLn('[CONFIG]   Testing with invalid code...');
    WriteLn('');

    try
      LResult := LCompiler.CompileToExecutable(CErrorTestCode, 'stop_on_first_test.pas');

      WriteLn('');
      if LResult.Success then
      begin
        WriteLn('✅ COMPILATION SUCCESS (Unexpected!)');
      end
      else
      begin
        WriteLn('❌ COMPILATION FAILED (Expected - Stop on First Error)');
        if LResult.ErrorMessage <> '' then
          WriteLn(Format('   Error: %s', [LResult.ErrorMessage]));
      end;
    except
      on E: ECPCompilerError do
      begin
        WriteLn('');
        WriteLn('❌ COMPILATION STOPPED (Expected - Error Limit Exception)');
        WriteLn(Format('   Exception: %s', [E.Message]));
        if E.Help <> '' then
          WriteLn(Format('   Help: %s', [E.Help]));
      end;
    end;

    // Display final comprehensive statistics
    WriteLn('');
    WriteLn('=== FINAL COMPREHENSIVE STATISTICS ===');
    WriteLn(Format('Current Phase: %s', [GetEnumName(TypeInfo(TCPCompilationPhase), Ord(LCompiler.CurrentPhase))]));
    WriteLn(Format('Current File: %s', [LCompiler.CurrentFileName]));
    WriteLn('');
    WriteLn('Compiler Configuration:');
    WriteLn(Format('  Max Errors: %d', [LCompiler.CompilerConfig.MaxErrors]));
    WriteLn(Format('  Max Warnings: %d', [LCompiler.CompilerConfig.MaxWarnings]));
    WriteLn(Format('  Stop On First Error: %s', [BoolToStr(LCompiler.CompilerConfig.StopOnFirstError, True)]));
    WriteLn(Format('  Continue On Error: %s', [BoolToStr(LCompiler.CompilerConfig.ContinueOnError, True)]));
    WriteLn(Format('  Strict Mode: %s', [BoolToStr(LCompiler.CompilerConfig.StrictMode, True)]));
    WriteLn(Format('  Treat Warnings As Errors: %s', [BoolToStr(LCompiler.CompilerConfig.TreatWarningsAsErrors, True)]));
    WriteLn('');
    WriteLn('Current Counts:');
    WriteLn(Format('  Errors: %d', [LCompiler.CompilerConfig.ErrorCount]));
    WriteLn(Format('  Warnings: %d', [LCompiler.CompilerConfig.WarningCount]));
    WriteLn('');
    WriteLn('Limit Status:');
    WriteLn(Format('  Error Limit Reached: %s', [BoolToStr(LCompiler.CompilerConfig.HasReachedErrorLimit(), True)]));
    WriteLn(Format('  Warning Limit Reached: %s', [BoolToStr(LCompiler.CompilerConfig.HasReachedWarningLimit(), True)]));
    WriteLn(Format('  Should Stop On Error: %s', [BoolToStr(LCompiler.CompilerConfig.ShouldStopOnError(), True)]));

  finally
    LCompiler.Free();
  end;

  WriteLn('');
  WriteLn('=== Enhanced Coverage Test Complete ===');
  WriteLn('✨ New Features Demonstrated:');
  WriteLn('   • TCPCompilerConfig (renamed from TCPWarningConfig)');
  WriteLn('   • Error limiting with MaxErrors');
  WriteLn('   • StopOnFirstError mode');
  WriteLn('   • Proper compilation pipeline with error checking');
  WriteLn('   • Professional error reporting and statistics');
  WriteLn('   • Industry-standard compiler behavior');
end;



procedure RunCPascalTestbed();
begin
  try
    try
      Coverage();
    except
      on E: Exception do
      begin
        WriteLn('');
        WriteLn('❌ UNEXPECTED EXCEPTION IN COVERAGE TEST:');
        WriteLn(Format('   Exception Type: %s', [E.ClassName]));
        WriteLn(Format('   Message: %s', [E.Message]));
        WriteLn('   This may indicate a compiler bug or test issue.');
        WriteLn('');
      end;
    end;
  finally
    // ALWAYS pause, regardless of success or exception
    Pause();
  end;
end;
end.
