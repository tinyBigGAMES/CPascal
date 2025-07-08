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

unit CPascal.Common;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  // === SOURCE LOCATION AND CONTEXT ===
  
  TCPSourceLocation = record
    FileName: string;
    Line: Integer;
    Column: Integer;
    Index: Integer;
    Length: Integer;
    LineContent: string;
    
    class function Create(const AFileName: string; const ALine, AColumn: Integer; const AIndex: Integer = 0; const ALength: Integer = 1): TCPSourceLocation; static;
    function ToString(): string;
  end;

  // === COMPILATION PHASES ===
  
  TCPCompilationPhase = (
    cpInitialization,
    cpLexicalAnalysis,
    cpSyntaxAnalysis,
    cpSemanticAnalysis,
    cpCodeGeneration,
    cpOptimization,
    cpLinking,
    cpFinalization
  );

  // === WARNING AND ERROR CLASSIFICATION ===
  
  TCPWarningLevel = (
    wlInfo,
    wlHint,
    wlWarning,
    wlError
  );

  TCPWarningCategory = (
    wcGeneral,
    wcSyntax,
    wcSemantic,
    wcUnusedCode,
    wcCompatibility,
    wcPerformance,
    wcPortability,
    wcDeprecated
  );

  TCPErrorSeverity = (
    esInfo,
    esHint,
    esWarning,
    esError,
    esFatal
  );

  // === CALLBACK TYPES FOR IDE INTEGRATION ===
  
  TCPCompilerStartupCallback = reference to procedure();
  TCPCompilerShutdownCallback = reference to procedure(const ASuccess: Boolean; const ATotalErrors, ATotalWarnings: Integer);
  TCPCompilerMessageCallback = reference to procedure(const AMessage: string);
  TCPCompilerProgressCallback = reference to procedure(const AFileName: string; const APhase: TCPCompilationPhase; const AMessage: string; const APercentComplete: Integer = -1);
  
  TCPCompilerWarningCallback = reference to procedure(
    const ALocation: TCPSourceLocation;
    const APhase: TCPCompilationPhase;
    const ALevel: TCPWarningLevel;
    const ACategory: TCPWarningCategory;
    const AMessage: string;
    const AHint: string = ''
  );
  
  TCPCompilerErrorCallback = reference to procedure(
    const ALocation: TCPSourceLocation;
    const APhase: TCPCompilationPhase;
    const AMessage: string;
    const AHelp: string = ''
  );
  
  TCPCompilerAnalysisCallback = reference to procedure(
    const ALocation: TCPSourceLocation;
    const AAnalysisType: string;
    const AData: string
  );

  // === EXCEPTIONS ===
  
  ECPCompilerError = class(Exception)
  private
    FPhase: TCPCompilationPhase;
    FLocation: TCPSourceLocation;
    FHelp: string;
    FSeverity: TCPErrorSeverity;
  public
    constructor Create(const AMessage: string; const APhase: TCPCompilationPhase; const ALocation: TCPSourceLocation; const AHelp: string = ''; const ASeverity: TCPErrorSeverity = esError);
    
    property Phase: TCPCompilationPhase read FPhase;
    property Location: TCPSourceLocation read FLocation;
    property Help: string read FHelp;
    property Severity: TCPErrorSeverity read FSeverity;
  end;

  // === TOKEN TYPES (COMPLETE SET) ===
  
  TCPTokenType = (
    // Keywords
    tkProgram, tkProcedure, tkFunction, tkExternal, tkBegin, tkEnd,
    tkConst, tkVar, tkIf, tkThen, tkElse,
    
    // Calling conventions
    tkCdecl, tkStdcall, tkFastcall, tkRegister,
    
    // Symbols
    tkLeftParen, tkRightParen, tkSemicolon, tkDot, tkComma, tkColon,
    tkAssign, tkEllipsis,
    
    // Comparison operators
    tkEqual, tkNotEqual, tkLessThan, tkLessThanOrEqual, 
    tkGreaterThan, tkGreaterThanOrEqual,
    
    // Literals
    tkIdentifier, tkString, tkNumber, tkCharacter,
    
    // Special
    tkEOF, tkUnknown
  );

  // === TOKEN ===
  
  TCPToken = record
    TokenType: TCPTokenType;
    Value: string;
    Position: TCPSourceLocation;
    
    class function Create(const ATokenType: TCPTokenType; const AValue: string; const APosition: TCPSourceLocation): TCPToken; static;
  end;

  // === WARNING CONFIGURATION ===
  
  TCPCompilerConfig = class
  private
    FEnabledCategories: set of TCPWarningCategory;
    FWarningLevels: array[TCPWarningCategory] of TCPWarningLevel;
    FTreatWarningsAsErrors: Boolean;
    FMaxWarnings: Integer;
    FWarningCount: Integer;
    FErrorCount: Integer;
    
    // Error limiting and compilation control
    FMaxErrors: Integer;
    FStopOnFirstError: Boolean;
    FContinueOnError: Boolean;
    FStrictMode: Boolean;
  public
    constructor Create();
    
    procedure EnableCategory(const ACategory: TCPWarningCategory; const ALevel: TCPWarningLevel = wlWarning);
    procedure DisableCategory(const ACategory: TCPWarningCategory);
    function IsCategoryEnabled(const ACategory: TCPWarningCategory): Boolean;
    function GetWarningLevel(const ACategory: TCPWarningCategory): TCPWarningLevel;
    
    procedure IncrementWarning(const ACategory: TCPWarningCategory);
    procedure IncrementError();
    procedure SetErrorCount(const ACount: Integer);
    procedure Reset();
    
    // Error control methods
    function ShouldStopOnError(): Boolean;
    function HasReachedErrorLimit(): Boolean;
    function HasReachedWarningLimit(): Boolean;
    procedure CheckErrorLimits(); // Raises exception if over limit
    
    property TreatWarningsAsErrors: Boolean read FTreatWarningsAsErrors write FTreatWarningsAsErrors;
    property MaxWarnings: Integer read FMaxWarnings write FMaxWarnings;
    property WarningCount: Integer read FWarningCount;
    
    // Error properties
    property ErrorCount: Integer read FErrorCount;
    property MaxErrors: Integer read FMaxErrors write FMaxErrors;
    property StopOnFirstError: Boolean read FStopOnFirstError write FStopOnFirstError;
    property ContinueOnError: Boolean read FContinueOnError write FContinueOnError;
    property StrictMode: Boolean read FStrictMode write FStrictMode;
  end;
  
  // Legacy alias for backward compatibility
  TCPWarningConfig = TCPCompilerConfig;

  // === ERROR HANDLER FOR IDE INTEGRATION ===
  
  TCPErrorHandler = class
  private
    FOnError: TCPCompilerErrorCallback;
    FOnWarning: TCPCompilerWarningCallback;
    FOnMessage: TCPCompilerMessageCallback;
    FOnProgress: TCPCompilerProgressCallback;
    FOnAnalysis: TCPCompilerAnalysisCallback;
    FSourceLines: TStringList;
    FCurrentFileName: string;
    FCurrentPhase: TCPCompilationPhase;
    FErrorCount: Integer;  // NEW: Track errors locally
    FCompilerConfig: TCPCompilerConfig; // NEW: Reference to check limits
  public
    constructor Create(const AOnError: TCPCompilerErrorCallback;
                      const AOnWarning: TCPCompilerWarningCallback;
                      const AOnMessage: TCPCompilerMessageCallback;
                      const AOnProgress: TCPCompilerProgressCallback;
                      const ACompilerConfig: TCPCompilerConfig;
                      const AOnAnalysis: TCPCompilerAnalysisCallback = nil);
    destructor Destroy(); override;
    
    // Context management
    procedure SetSourceLines(const ASourceCode: string);
    procedure SetCurrentFile(const AFileName: string);
    procedure SetCurrentPhase(const APhase: TCPCompilationPhase);
    
    // Error reporting methods
    procedure ReportError(const ALine, AColumn: Integer; const AMessage: string; const AHelp: string = '');
    procedure ReportWarning(const ALine, AColumn: Integer; const ALevel: TCPWarningLevel; const ACategory: TCPWarningCategory; const AMessage: string; const AHint: string = '');
    procedure ReportInfo(const AMessage: string);
    procedure ReportProgress(const AMessage: string; const APercentComplete: Integer = -1);
    procedure ReportAnalysis(const ALine, AColumn: Integer; const AAnalysisType: string; const AData: string);
    
    // Exception handling
    procedure HandleException(const AException: Exception; const ALine: Integer = 0; const AColumn: Integer = 0);
    
    // Utility methods
    function CreateLocation(const ALine, AColumn: Integer; const ALength: Integer = 1): TCPSourceLocation;
    function GetSourceLine(const ALine: Integer): string;
    
    // NEW: Error tracking methods
    procedure ResetErrorCount();
    function GetErrorCount(): Integer;
    function ShouldStopParsing(): Boolean;
    
    property ErrorCount: Integer read FErrorCount;
  end;

  // === LANGUAGE CONSTRUCTS ===
  
  TCPCallingConvention = (ccCdecl, ccStdcall, ccFastcall, ccRegister);
  TCPParameterMode = (pmValue, pmConst, pmVar, pmOut);

  // === UTILITY FUNCTIONS ===
  
  function CPTokenTypeToString(const ATokenType: TCPTokenType): string;
  function CPCompilationPhaseToString(const APhase: TCPCompilationPhase): string;
  function CPWarningCategoryToString(const ACategory: TCPWarningCategory): string;
  function CPCallingConventionToString(const AConvention: TCPCallingConvention): string;

implementation

// =============================================================================
// TCPSourceLocation Implementation
// =============================================================================

class function TCPSourceLocation.Create(const AFileName: string; const ALine, AColumn: Integer; const AIndex: Integer = 0; const ALength: Integer = 1): TCPSourceLocation;
begin
  Result.FileName := AFileName;
  Result.Line := ALine;
  Result.Column := AColumn;
  Result.Index := AIndex;
  Result.Length := ALength;
  Result.LineContent := '';
end;

function TCPSourceLocation.ToString(): string;
begin
  Result := Format('%s(%d,%d)', [FileName, Line, Column]);
end;

// =============================================================================
// TCPToken Implementation  
// =============================================================================

class function TCPToken.Create(const ATokenType: TCPTokenType; const AValue: string; const APosition: TCPSourceLocation): TCPToken;
begin
  Result.TokenType := ATokenType;
  Result.Value := AValue;
  Result.Position := APosition;
end;

// =============================================================================
// ECPCompilerError Implementation
// =============================================================================

constructor ECPCompilerError.Create(const AMessage: string; const APhase: TCPCompilationPhase; const ALocation: TCPSourceLocation; const AHelp: string = ''; const ASeverity: TCPErrorSeverity = esError);
begin
  inherited Create(AMessage);
  FPhase := APhase;
  FLocation := ALocation;
  FHelp := AHelp;
  FSeverity := ASeverity;
end;

// =============================================================================
// TCPCompilerConfig Implementation
// =============================================================================

constructor TCPCompilerConfig.Create();
var
  LCategory: TCPWarningCategory;
begin
  inherited Create();
  
  // Enable all categories by default
  FEnabledCategories := [Low(TCPWarningCategory)..High(TCPWarningCategory)];
  
  // Set default warning levels
  for LCategory := Low(TCPWarningCategory) to High(TCPWarningCategory) do
    FWarningLevels[LCategory] := wlWarning;
    
  FTreatWarningsAsErrors := False;
  FMaxWarnings := 100;
  
  // Set default error control values
  FMaxErrors := 20;              // Industry standard limit
  FStopOnFirstError := False;    // Allow error collection
  FContinueOnError := False;     // Fail fast on errors
  FStrictMode := False;          // Reasonable default
  
  Reset();
end;

procedure TCPCompilerConfig.EnableCategory(const ACategory: TCPWarningCategory; const ALevel: TCPWarningLevel = wlWarning);
begin
  Include(FEnabledCategories, ACategory);
  FWarningLevels[ACategory] := ALevel;
end;

procedure TCPCompilerConfig.DisableCategory(const ACategory: TCPWarningCategory);
begin
  Exclude(FEnabledCategories, ACategory);
end;

function TCPCompilerConfig.IsCategoryEnabled(const ACategory: TCPWarningCategory): Boolean;
begin
  Result := ACategory in FEnabledCategories;
end;

function TCPCompilerConfig.GetWarningLevel(const ACategory: TCPWarningCategory): TCPWarningLevel;
begin
  Result := FWarningLevels[ACategory];
end;

procedure TCPCompilerConfig.IncrementWarning(const ACategory: TCPWarningCategory);
begin
  Inc(FWarningCount);
end;

procedure TCPCompilerConfig.IncrementError();
begin
  Inc(FErrorCount);
end;

procedure TCPCompilerConfig.SetErrorCount(const ACount: Integer);
begin
  FErrorCount := ACount;
end;

procedure TCPCompilerConfig.Reset();
begin
  FWarningCount := 0;
  FErrorCount := 0;
end;

// New error control methods
function TCPCompilerConfig.ShouldStopOnError(): Boolean;
begin
  Result := FStopOnFirstError or (FErrorCount >= FMaxErrors);
end;

function TCPCompilerConfig.HasReachedErrorLimit(): Boolean;
begin
  Result := FErrorCount >= FMaxErrors;
end;

function TCPCompilerConfig.HasReachedWarningLimit(): Boolean;
begin
  Result := FWarningCount >= FMaxWarnings;
end;

procedure TCPCompilerConfig.CheckErrorLimits();
begin
  // NOTE: This method no longer throws exceptions to prevent error cascades
  // Use ShouldStopOnError() or HasReachedErrorLimit() to check limits instead
end;

// =============================================================================
// TCPErrorHandler Implementation
// =============================================================================

constructor TCPErrorHandler.Create(const AOnError: TCPCompilerErrorCallback;
                                  const AOnWarning: TCPCompilerWarningCallback;
                                  const AOnMessage: TCPCompilerMessageCallback;
                                  const AOnProgress: TCPCompilerProgressCallback;
                                  const ACompilerConfig: TCPCompilerConfig;
                                  const AOnAnalysis: TCPCompilerAnalysisCallback = nil);
begin
  inherited Create();
  FOnError := AOnError;
  FOnWarning := AOnWarning;
  FOnMessage := AOnMessage;
  FOnProgress := AOnProgress;
  FOnAnalysis := AOnAnalysis;
  FCompilerConfig := ACompilerConfig;
  FSourceLines := TStringList.Create();
  FCurrentFileName := '';
  FCurrentPhase := cpInitialization;
  FErrorCount := 0;  // NEW: Initialize error count
end;

destructor TCPErrorHandler.Destroy();
begin
  FSourceLines.Free();
  inherited Destroy();
end;

procedure TCPErrorHandler.SetSourceLines(const ASourceCode: string);
begin
  FSourceLines.Clear();
  FSourceLines.Text := ASourceCode;
end;

procedure TCPErrorHandler.SetCurrentFile(const AFileName: string);
begin
  FCurrentFileName := AFileName;
end;

procedure TCPErrorHandler.SetCurrentPhase(const APhase: TCPCompilationPhase);
begin
  FCurrentPhase := APhase;
end;

procedure TCPErrorHandler.ReportError(const ALine, AColumn: Integer; const AMessage: string; const AHelp: string = '');
var
  LLocation: TCPSourceLocation;
begin
  Inc(FErrorCount);  // NEW: Track errors locally
  LLocation := CreateLocation(ALine, AColumn);
  if Assigned(FOnError) then
    FOnError(LLocation, FCurrentPhase, AMessage, AHelp);
end;

procedure TCPErrorHandler.ReportWarning(const ALine, AColumn: Integer; const ALevel: TCPWarningLevel; const ACategory: TCPWarningCategory; const AMessage: string; const AHint: string = '');
var
  LLocation: TCPSourceLocation;
begin
  LLocation := CreateLocation(ALine, AColumn);
  if Assigned(FOnWarning) then
    FOnWarning(LLocation, FCurrentPhase, ALevel, ACategory, AMessage, AHint);
end;

procedure TCPErrorHandler.ReportInfo(const AMessage: string);
begin
  if Assigned(FOnMessage) then
    FOnMessage(AMessage);
end;

procedure TCPErrorHandler.ReportProgress(const AMessage: string; const APercentComplete: Integer = -1);
begin
  if Assigned(FOnProgress) then
    FOnProgress(FCurrentFileName, FCurrentPhase, AMessage, APercentComplete);
end;

procedure TCPErrorHandler.ReportAnalysis(const ALine, AColumn: Integer; const AAnalysisType: string; const AData: string);
var
  LLocation: TCPSourceLocation;
begin
  LLocation := CreateLocation(ALine, AColumn);
  if Assigned(FOnAnalysis) then
    FOnAnalysis(LLocation, AAnalysisType, AData);
end;

procedure TCPErrorHandler.HandleException(const AException: Exception; const ALine: Integer = 0; const AColumn: Integer = 0);
var
  LLocation: TCPSourceLocation;
begin
  LLocation := CreateLocation(ALine, AColumn);
  
  if AException is ECPCompilerError then
  begin
    // Re-route compiler exception
    ReportError(ECPCompilerError(AException).Location.Line, 
               ECPCompilerError(AException).Location.Column, 
               AException.Message, 
               ECPCompilerError(AException).Help);
  end
  else
  begin
    // Handle general exception
    ReportError(ALine, AColumn, AException.Message, 'General exception occurred');
  end;
end;

function TCPErrorHandler.CreateLocation(const ALine, AColumn: Integer; const ALength: Integer = 1): TCPSourceLocation;
begin
  Result := TCPSourceLocation.Create(FCurrentFileName, ALine, AColumn, 0, ALength);
  Result.LineContent := GetSourceLine(ALine);
end;

function TCPErrorHandler.GetSourceLine(const ALine: Integer): string;
begin
  Result := '';
  if (ALine > 0) and (ALine <= FSourceLines.Count) then
    Result := FSourceLines[ALine - 1];
end;

// NEW: Error tracking method implementations
procedure TCPErrorHandler.ResetErrorCount();
begin
  FErrorCount := 0;
end;

function TCPErrorHandler.GetErrorCount(): Integer;
begin
  Result := FErrorCount;
end;

function TCPErrorHandler.ShouldStopParsing(): Boolean;
begin
  Result := (FErrorCount > 0) and FCompilerConfig.ShouldStopOnError();
end;

// =============================================================================
// Utility Functions
// =============================================================================

function CPTokenTypeToString(const ATokenType: TCPTokenType): string;
begin
  case ATokenType of
    tkProgram: Result := 'program';
    tkProcedure: Result := 'procedure';
    tkFunction: Result := 'function';
    tkExternal: Result := 'external';
    tkBegin: Result := 'begin';
    tkEnd: Result := 'end';
    tkConst: Result := 'const';
    tkVar: Result := 'var';
    tkIf: Result := 'if';
    tkThen: Result := 'then';
    tkElse: Result := 'else';
    tkCdecl: Result := 'cdecl';
    tkStdcall: Result := 'stdcall';
    tkFastcall: Result := 'fastcall';
    tkRegister: Result := 'register';
    tkLeftParen: Result := '(';
    tkRightParen: Result := ')';
    tkSemicolon: Result := ';';
    tkDot: Result := '.';
    tkComma: Result := ',';
    tkColon: Result := ':';
    tkAssign: Result := ':=';
    tkEllipsis: Result := '...';
    tkEqual: Result := '=';
    tkNotEqual: Result := '<>';
    tkLessThan: Result := '<';
    tkLessThanOrEqual: Result := '<=';
    tkGreaterThan: Result := '>';
    tkGreaterThanOrEqual: Result := '>=';
    tkIdentifier: Result := 'identifier';
    tkString: Result := 'string';
    tkNumber: Result := 'number';
    tkCharacter: Result := 'character';
    tkEOF: Result := '<EOF>';
    tkUnknown: Result := '<unknown>';
    else
      Result := '<undefined>';
  end;
end;

function CPCompilationPhaseToString(const APhase: TCPCompilationPhase): string;
begin
  case APhase of
    cpInitialization: Result := 'Initialization';
    cpLexicalAnalysis: Result := 'Lexical Analysis';
    cpSyntaxAnalysis: Result := 'Syntax Analysis';
    cpSemanticAnalysis: Result := 'Semantic Analysis';
    cpCodeGeneration: Result := 'Code Generation';
    cpOptimization: Result := 'Optimization';
    cpLinking: Result := 'Linking';
    cpFinalization: Result := 'Finalization';
    else
      Result := 'Unknown Phase';
  end;
end;

function CPWarningCategoryToString(const ACategory: TCPWarningCategory): string;
begin
  case ACategory of
    wcGeneral: Result := 'General';
    wcSyntax: Result := 'Syntax';
    wcSemantic: Result := 'Semantic';
    wcUnusedCode: Result := 'Unused Code';
    wcCompatibility: Result := 'Compatibility';
    wcPerformance: Result := 'Performance';
    wcPortability: Result := 'Portability';
    wcDeprecated: Result := 'Deprecated';
    else
      Result := 'Unknown Category';
  end;
end;

function CPCallingConventionToString(const AConvention: TCPCallingConvention): string;
begin
  case AConvention of
    ccCdecl: Result := 'cdecl';
    ccStdcall: Result := 'stdcall';
    ccFastcall: Result := 'fastcall';
    ccRegister: Result := 'register';
    else
      Result := 'unknown';
  end;
end;

end.
