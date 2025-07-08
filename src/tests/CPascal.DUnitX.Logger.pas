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

unit CPascal.DUnitX.Logger;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  System.Diagnostics,
  DUnitX.TestFramework,
  DUnitX.ConsoleWriter.Base,
  DUnitX.Windows.Console,
  DUnitX.IoC;

type
  TCPascalTestLogger = class(TInterfacedObject, ITestLogger)
  private
    FConsoleWriter: IDUnitXConsoleWriter;
    FStartTime: TStopwatch;
    FTestCount: Integer;
    FCurrentTest: Integer;
    FPassedCount: Integer;
    FFailedCount: Integer;
    FErrorCount: Integer;
    FXMLOutputPath: string;

    procedure WriteHeader();
    procedure WriteFooter();
    procedure WriteTestResult(const ATestName: string; const AStatus: string);
    function FormatDuration(const AMilliseconds: Int64): string;

    // Color management methods
    procedure SetConsoleDefaultColor();
    procedure SetConsoleSuccessColor();
    procedure SetConsoleFailureColor();
    procedure SetConsoleErrorColor();
    procedure SetConsoleHeaderColor();
    procedure SetConsoleSummaryColor();

  public
    constructor Create(const AXMLOutputPath: string = '');

    // ITestLogger implementation - exact interface match
    procedure OnTestingStarts(const threadId: TThreadID; testCount, testActiveCount: Cardinal);
    procedure OnStartTestFixture(const threadId: TThreadID; const fixture: ITestFixtureInfo);
    procedure OnSetupFixture(const threadId: TThreadID; const fixture: ITestFixtureInfo);
    procedure OnEndSetupFixture(const threadId: TThreadID; const fixture: ITestFixtureInfo);
    procedure OnBeginTest(const threadId: TThreadID; const Test: ITestInfo);
    procedure OnSetupTest(const threadId: TThreadID; const Test: ITestInfo);
    procedure OnEndSetupTest(const threadId: TThreadID; const Test: ITestInfo);
    procedure OnExecuteTest(const threadId: TThreadID; const Test: ITestInfo);
    procedure OnTestSuccess(const threadId: TThreadID; const Test: ITestResult);
    procedure OnTestError(const threadId: TThreadID; const Error: ITestError);
    procedure OnTestFailure(const threadId: TThreadID; const Failure: ITestError);
    procedure OnTestIgnored(const threadId: TThreadID; const AIgnored: ITestResult);
    procedure OnTestMemoryLeak(const threadId: TThreadID; const Test: ITestResult);
    procedure OnLog(const logType: TLogLevel; const msg: string);
    procedure OnTeardownTest(const threadId: TThreadID; const Test: ITestInfo);
    procedure OnEndTeardownTest(const threadId: TThreadID; const Test: ITestInfo);
    procedure OnEndTest(const threadId: TThreadID; const Test: ITestResult);
    procedure OnTearDownFixture(const threadId: TThreadID; const fixture: ITestFixtureInfo);
    procedure OnEndTearDownFixture(const threadId: TThreadID; const fixture: ITestFixtureInfo);
    procedure OnEndTestFixture(const threadId: TThreadID; const results: IFixtureResult);
    procedure OnTestingEnds(const RunResults: IRunResults);
  end;

implementation

function IsRealClassName(const ALine: string): Boolean;
var
  LastDot: Integer;
  LastPart: string;
begin
  Result := False;
  LastDot := LastDelimiter('.', ALine);
  if LastDot > 0 then
  begin
    LastPart := Copy(ALine, LastDot + 1, MaxInt);
    Result := (Length(LastPart) > 1) and
              (LastPart[1] = 'T') and
              (CharInSet(LastPart[2], ['A'..'Z'])) and
              not LastPart.Contains(' '); // Prevent malformed names
  end;
end;

// =============================================================================
// Color Management Methods
// =============================================================================

procedure TCPascalTestLogger.SetConsoleDefaultColor();
begin
  FConsoleWriter.SetColour(ccDefault);
end;

procedure TCPascalTestLogger.SetConsoleSuccessColor();
begin
  FConsoleWriter.SetColour(ccBrightGreen, ccBlack);
end;

procedure TCPascalTestLogger.SetConsoleFailureColor();
begin
  FConsoleWriter.SetColour(ccBrightRed, ccBlack);
end;

procedure TCPascalTestLogger.SetConsoleErrorColor();
begin
  FConsoleWriter.SetColour(ccBrightRed, ccBlack);
end;

procedure TCPascalTestLogger.SetConsoleHeaderColor();
begin
  FConsoleWriter.SetColour(ccBrightAqua, ccBlack);
end;

procedure TCPascalTestLogger.SetConsoleSummaryColor();
begin
  FConsoleWriter.SetColour(ccBrightWhite, ccBlack);
end;

// =============================================================================
// Core Implementation
// =============================================================================

constructor TCPascalTestLogger.Create(const AXMLOutputPath: string);
begin
  inherited Create();
  FXMLOutputPath := AXMLOutputPath;
  FStartTime := TStopwatch.Create();
  FCurrentTest := 0;
  FPassedCount := 0;
  FFailedCount := 0;
  FErrorCount := 0;

  // Get console writer from DUnitX IoC container (same as default logger)
  FConsoleWriter := TDUnitXWindowsConsoleWriter.Create();
  if FConsoleWriter = nil then
    raise Exception.Create('No console writer class registered');
end;

procedure TCPascalTestLogger.WriteHeader();
begin
  SetConsoleHeaderColor();
  FConsoleWriter.WriteLn('');
  FConsoleWriter.WriteLn('================================================================================');
  FConsoleWriter.WriteLn('                            🚀 CPASCAL TEST SUITE                            ');
  FConsoleWriter.WriteLn('================================================================================');
  SetConsoleDefaultColor();
  FConsoleWriter.WriteLn(' Advanced Virtual Machine - Core System Validation                        ');
  if FXMLOutputPath <> '' then
  begin
    FConsoleWriter.WriteLn('');
    FConsoleWriter.WriteLn(Format(' XML Results: %s', [ExtractFileName(FXMLOutputPath)]));
  end;
  SetConsoleHeaderColor();
  FConsoleWriter.WriteLn('================================================================================');
  SetConsoleDefaultColor();
  FConsoleWriter.WriteLn('');
end;

procedure TCPascalTestLogger.WriteFooter();
var
  LDuration: string;
  LStatus: string;
  LStatusIcon: string;
begin
  LDuration := FormatDuration(FStartTime.ElapsedMilliseconds);

  if FFailedCount + FErrorCount = 0 then
  begin
    LStatus := 'ALL TESTS PASSED';
    LStatusIcon := '✅';
  end
  else
  begin
    LStatus := 'TESTS FAILED';
    LStatusIcon := '❌';
  end;

  FConsoleWriter.WriteLn('');
  SetConsoleHeaderColor();
  FConsoleWriter.WriteLn('================================================================================');
  if FFailedCount + FErrorCount = 0 then
    SetConsoleSuccessColor()
  else
    SetConsoleFailureColor();
  FConsoleWriter.WriteLn(Format('                            %s %s', [LStatusIcon, LStatus]));
  SetConsoleHeaderColor();
  FConsoleWriter.WriteLn('================================================================================');
  SetConsoleSummaryColor();
  FConsoleWriter.WriteLn(Format(' Tests Found   : %-10d | Tests Passed  : %-10d | Duration: %-10s',
    [FTestCount, FPassedCount, LDuration]));
  FConsoleWriter.WriteLn(Format(' Tests Failed  : %-10d | Tests Errored : %-10d | VM Status: %-9s',
    [FFailedCount, FErrorCount, 'Ready']));
  SetConsoleHeaderColor();
  FConsoleWriter.WriteLn('================================================================================');
  SetConsoleDefaultColor();
  FConsoleWriter.WriteLn('');
end;

procedure TCPascalTestLogger.WriteTestResult(const ATestName: string; const AStatus: string);
begin
  FConsoleWriter.WriteLn(Format(' %s %s', [AStatus, ATestName]));
end;

function TCPascalTestLogger.FormatDuration(const AMilliseconds: Int64): string;
begin
  if AMilliseconds < 1000 then
    Result := Format('%dms', [AMilliseconds])
  else if AMilliseconds < 60000 then
    Result := Format('%.2fs', [AMilliseconds / 1000])
  else
    Result := Format('%dm %.1fs', [AMilliseconds div 60000, (AMilliseconds mod 60000) / 1000]);
end;

// ITestLogger implementation

procedure TCPascalTestLogger.OnTestingStarts(const threadId: TThreadID; testCount, testActiveCount: Cardinal);
begin
  FTestCount := testCount;
  FStartTime.Start();
  WriteHeader();
  FConsoleWriter.WriteLn(Format('Discovering %d tests across %d active fixtures...', [testCount, testActiveCount]));
  FConsoleWriter.WriteLn('');
end;

procedure TCPascalTestLogger.OnTestSuccess(const threadId: TThreadID; const Test: ITestResult);
begin
  Inc(FCurrentTest);
  Inc(FPassedCount);
  SetConsoleSuccessColor();
  WriteTestResult(Test.Test.Name, '✓');
  SetConsoleDefaultColor();
end;

procedure TCPascalTestLogger.OnTestError(const threadId: TThreadID; const Error: ITestError);
begin
  Inc(FCurrentTest);
  Inc(FErrorCount);
  SetConsoleErrorColor();
  WriteTestResult(Error.Test.Name, '💥');
  FConsoleWriter.WriteLn(Format('    ERROR: %s', [Error.Message]));
  SetConsoleDefaultColor();
end;

procedure TCPascalTestLogger.OnTestFailure(const threadId: TThreadID; const Failure: ITestError);
begin
  Inc(FCurrentTest);
  Inc(FFailedCount);
  SetConsoleFailureColor();
  WriteTestResult(Failure.Test.Name, '❌');
  FConsoleWriter.WriteLn(Format('    FAILED: %s', [Failure.Message]));
  SetConsoleDefaultColor();
end;

procedure TCPascalTestLogger.OnTestIgnored(const threadId: TThreadID; const AIgnored: ITestResult);
begin
  Inc(FCurrentTest);
  WriteTestResult(AIgnored.Test.Name, '⏭️');
end;

procedure TCPascalTestLogger.OnTestingEnds(const RunResults: IRunResults);
begin
  FStartTime.Stop();
  WriteFooter();

  if FXMLOutputPath <> '' then
    FConsoleWriter.WriteLn(Format('Test results saved to: %s', [FXMLOutputPath]));
end;

// Focused event handlers - clean and elegant
procedure TCPascalTestLogger.OnStartTestFixture(const threadId: TThreadID; const fixture: ITestFixtureInfo);
begin
  // Only show if it's a real test fixture (not duplicate class names)
  if IsRealClassName(fixture.FullName) then
  begin
    SetConsoleHeaderColor();
    FConsoleWriter.WriteLn('');
    FConsoleWriter.WriteLn(Format('📦 %s', [fixture.FullName]));
    FConsoleWriter.WriteLn('────────────────────────────────────────────────────────────────────────────────');
    SetConsoleDefaultColor();
  end;
end;

procedure TCPascalTestLogger.OnSetupFixture(const threadId: TThreadID; const fixture: ITestFixtureInfo);
begin
  // Only show significant fixture setup
  if fixture.SetupFixtureMethodName <> '' then
  begin
    FConsoleWriter.WriteLn(Format('  🔧 Fixture setup: %s', [fixture.SetupFixtureMethodName]));
  end;
end;

procedure TCPascalTestLogger.OnEndSetupFixture(const threadId: TThreadID; const fixture: ITestFixtureInfo);
begin
  // Clean spacing only if there was setup
end;

procedure TCPascalTestLogger.OnBeginTest(const threadId: TThreadID; const Test: ITestInfo);
begin
  // Let the progress bar handle test identification
end;

procedure TCPascalTestLogger.OnSetupTest(const threadId: TThreadID; const Test: ITestInfo);
begin
  // Too verbose - skip individual test setup
end;

procedure TCPascalTestLogger.OnEndSetupTest(const threadId: TThreadID; const Test: ITestInfo);
begin
  // Skip
end;

procedure TCPascalTestLogger.OnExecuteTest(const threadId: TThreadID; const Test: ITestInfo);
begin
  // Let progress bar handle execution indication
end;

procedure TCPascalTestLogger.OnTestMemoryLeak(const threadId: TThreadID; const Test: ITestResult);
begin
  Inc(FCurrentTest);
  SetConsoleErrorColor();
  WriteTestResult(Test.Test.Name, '🧠');
  FConsoleWriter.WriteLn(Format('    MEMORY LEAK: %s', [Test.Message]));
  SetConsoleDefaultColor();
end;

procedure TCPascalTestLogger.OnLog(const logType: TLogLevel; const msg: string);
begin
  // Only show important logs
  if logType = TLogLevel.Error then
  begin
    SetConsoleErrorColor();
    FConsoleWriter.WriteLn(Format('    ⚠️  %s', [msg]));
    SetConsoleDefaultColor();
  end;
end;

procedure TCPascalTestLogger.OnTeardownTest(const threadId: TThreadID; const Test: ITestInfo);
begin
  // Too verbose - skip individual test teardown
end;

procedure TCPascalTestLogger.OnEndTeardownTest(const threadId: TThreadID; const Test: ITestInfo);
begin
  // Skip
end;

procedure TCPascalTestLogger.OnEndTest(const threadId: TThreadID; const Test: ITestResult);
begin
  // Clean spacing handled by progress bar
end;

procedure TCPascalTestLogger.OnTearDownFixture(const threadId: TThreadID; const fixture: ITestFixtureInfo);
begin
  // Only show significant fixture teardown
  if fixture.TearDownFixtureMethodName <> '' then
  begin
    FConsoleWriter.WriteLn(Format('  🧹 Fixture teardown: %s', [fixture.TearDownFixtureMethodName]));
  end;
end;

procedure TCPascalTestLogger.OnEndTearDownFixture(const threadId: TThreadID; const fixture: ITestFixtureInfo);
begin
  // Clean
end;

procedure TCPascalTestLogger.OnEndTestFixture(const threadId: TThreadID; const results: IFixtureResult);
begin
  // Only show separator if we showed a fixture header
  //if Pos('.T', results.Fixture.FullName) > 0 then
  if IsRealClassName(results.Fixture.FullName) then
  begin
    SetConsoleHeaderColor();
    FConsoleWriter.WriteLn('────────────────────────────────────────────────────────────────────────────────');
    SetConsoleDefaultColor();
    FConsoleWriter.WriteLn('');
  end;
end;

end.
