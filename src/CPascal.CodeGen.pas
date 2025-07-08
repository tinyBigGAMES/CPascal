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

unit CPascal.CodeGen;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  System.StrUtils,
  System.TypInfo,
  System.Generics.Collections,
  Winapi.Windows,
  Winapi.ShellAPI,
  CPascal.Platform,
  CPascal.Common,
  CPascal.Parser,
  CPascal.LLVM;

type
  // === LINKER CONFIGURATION ===
  
  TCPSubsystemType = (
    stConsole,    // Console application
    stWindows     // GUI application
  );

  TCPLinkerConfig = class
  private
    FSubsystem: TCPSubsystemType;
    FLibraries: TStringList;
    FLinkerPath: string;
    FLibraryPaths: TStringList;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure AddLibrary(const ALibraryName: string);
    procedure AddLibraryPath(const APath: string);
    procedure SetDefaultLibraries();
    procedure ClearLibraries();

    property Subsystem: TCPSubsystemType read FSubsystem write FSubsystem;
    property Libraries: TStringList read FLibraries;
    property LibraryPaths: TStringList read FLibraryPaths;
    property LinkerPath: string read FLinkerPath write FLinkerPath;
  end;

  // === CODE GENERATOR ===
  
  TCPCodeGenerator = class
  private
    FContext: LLVMContextRef;
    FModule: LLVMModuleRef;
    FBuilder: LLVMBuilderRef;
    FMainFunction: LLVMValueRef;
    FTargetMachine: LLVMTargetMachineRef;
    FSymbols: TDictionary<string, LLVMValueRef>; // Variable symbol table
    FErrorHandler: TCPErrorHandler;

    // LLVM type helpers
    function GetInt8Type(): LLVMTypeRef;
    function GetInt32Type(): LLVMTypeRef;
    function GetDoubleType(): LLVMTypeRef;
    function GetVoidType(): LLVMTypeRef;
    function GetPointerType(const AElementType: LLVMTypeRef): LLVMTypeRef;

    // Code generation methods
    function GenerateProgram(const AProgram: TCPAstProgram): Boolean;
    function GenerateDeclarations(const ADeclarations: TCPAstDeclarations): Boolean;
    function GenerateExternalFunctions(const ADeclarations: TCPAstDeclarations): Boolean;
    function GenerateVariableDeclarations(const ADeclarations: TCPAstDeclarations): Boolean;
    function GenerateExternalFunction(const AFunction: TCPAstExternalFunction): LLVMValueRef;
    function GenerateVariableDecl(const AVariable: TCPAstVariableDecl): Boolean;
    function GenerateCompoundStatement(const AStatement: TCPAstCompoundStatement): Boolean;
    function GenerateStatement(const AStatement: TCPAstStatement): Boolean;
    function GenerateProcedureCall(const ACall: TCPAstProcedureCall): Boolean;
    function GenerateAssignmentStatement(const AAssignment: TCPAstAssignmentStatement): Boolean;
    function GenerateIfStatement(const AIfStatement: TCPAstIfStatement): Boolean;
    function GenerateExpression(const AExpression: TCPAstExpression): LLVMValueRef;
    function GenerateStringLiteral(const AString: TCPAstStringLiteral): LLVMValueRef;
    function GenerateNumberLiteral(const ANumber: TCPAstNumberLiteral): LLVMValueRef;
    function GenerateRealLiteral(const AReal: TCPAstRealLiteral): LLVMValueRef;
    function GenerateCharacterLiteral(const ACharacter: TCPAstCharacterLiteral): LLVMValueRef;
    function GenerateVariableReference(const AVariable: TCPAstVariableReference): LLVMValueRef;
    function GenerateComparisonExpression(const AComparison: TCPAstComparisonExpression): LLVMValueRef;

    // Utility methods
    function GetCallingConvention(const AConvention: TCPCallingConvention): Cardinal;
    function GetLLVMTypeFromCPascalType(const ATypeName: string): LLVMTypeRef;
    function CreateMainFunction(): LLVMValueRef;
    procedure AddFltUsedSymbol();
    procedure InitPlatform();
  public
    constructor Create(const AModuleName: string; const AErrorHandler: TCPErrorHandler);
    destructor Destroy(); override;

    function GenerateFromAST(const AProgram: TCPAstProgram): Boolean;
    function GetModuleIR(): string;
    function VerifyModule(): Boolean;
    function WriteObjectFile(const AFileName: string): Boolean;

    property Module: LLVMModuleRef read FModule;
  end;

  // === COMPILATION RESULT ===
  
  TCPCompilationResult = record
    Success: Boolean;
    ErrorMessage: string;
    OutputFile: string;
    
    class function CreateSuccess(const AOutputFile: string): TCPCompilationResult; static;
    class function CreateFailure(const AErrorMessage: string): TCPCompilationResult; static;
  end;

  // === MAIN COMPILER CLASS ===
  
  TCPCompiler = class
  private
    FOutputDirectory: string;
    FKeepIntermediateFiles: Boolean;
    FLinkerConfig: TCPLinkerConfig;

    // Phase tracking
    FCurrentPhase: TCPCompilationPhase;
    FCurrentFileName: string;

    // Enhanced callback fields
    FOnStartup: TCPCompilerStartupCallback;
    FOnShutdown: TCPCompilerShutdownCallback;
    FOnMessage: TCPCompilerMessageCallback;
    FOnProgress: TCPCompilerProgressCallback;
    FOnWarning: TCPCompilerWarningCallback;
    FOnError: TCPCompilerErrorCallback;
    FOnAnalysis: TCPCompilerAnalysisCallback;
    
    // Compiler configuration and statistics
    FCompilerConfig: TCPCompilerConfig;
    FErrorHandler: TCPErrorHandler;
    FSourceLines: TStringList; // Cache of source lines for context

    // Enhanced phase management methods
    procedure SetCurrentPhase(const APhase: TCPCompilationPhase; const AFileName: string = '');
    procedure DoStartup();
    procedure DoShutdown();
    procedure DoMessage(const AMessage: string);
    procedure DoProgress(const AMessage: string; const APercentComplete: Integer = -1);
    
    // Enhanced warning and error reporting
    procedure DoWarning(const ALocation: TCPSourceLocation; const ALevel: TCPWarningLevel; const ACategory: TCPWarningCategory; const AMessage: string; const AHint: string = '');
    procedure DoError(const ALocation: TCPSourceLocation; const AMessage: string; const AHelp: string = '');
    procedure DoAnalysis(const ALocation: TCPSourceLocation; const AAnalysisType: string; const AData: string);
    
    // Legacy compatibility methods
    procedure DoWarningSimple(const ALine, AColumn: Integer; const AMessage: string; const ACategory: TCPWarningCategory = wcGeneral);
    procedure DoErrorSimple(const ALine, AColumn: Integer; const AMessage: string);
    
    // Utility methods for enhanced reporting
    function CreateLocation(const ALine, AColumn: Integer; const ALength: Integer = 0): TCPSourceLocation;
    function GetSourceLineContent(const ALine: Integer): string;
    procedure CacheSourceLines(const ASourceCode: string);

    function CompileToObject(const ASourceCode: string; const ASourceFile: string): TCPCompilationResult;
    function LinkExecutable(const AObjectFile: string; const AExecutableFile: string): Boolean;
    function BuildLinkerCommandLine(const AObjectFile: string; const AExecutableFile: string): string;
    function ExecuteLinker(const ACommandLine: string): Boolean;
    function FindLinkerPath(): string;
    procedure InitializeLinkerConfig();
    procedure WriteDebugInfo(const ACommandLine: string; const AObjectFile: string);

    // Enhanced exception and message handling
    procedure HandleCompilerException(const E: ECPCompilerError);
    procedure HandleGeneralException(const E: Exception; const ADefaultLine: Integer = 0; const ADefaultColumn: Integer = 0);
    procedure WriteWarning(const AMessage: string; const ALine: Integer = 0; const AColumn: Integer = 0; const ACategory: TCPWarningCategory = wcGeneral);
    
    // Comprehensive semantic analysis warnings
    procedure CheckUnusedDeclarations(const AProgram: TCPAstProgram);
    procedure CheckVariableUsage(const AProgram: TCPAstProgram);
    procedure CheckFunctionParameterUsage(const AFunction: TCPAstExternalFunction);
    procedure CheckDeprecatedFeatures(const AProgram: TCPAstProgram);
    procedure CheckPerformanceIssues(const AProgram: TCPAstProgram);
    
    // Enhanced data flow analysis helper methods
    procedure AnalyzeStatementFlow(const AStatement: TCPAstStatement; const AAssignedVars, AUsedVars, AUnusedVars: TStringList);
    procedure AnalyzeExpressionUsage(const AExpression: TCPAstExpression; const AAssignedVars, AUsedVars: TStringList);
    procedure CheckVariableUse(const AVariableName: string; const APosition: TCPSourceLocation; const AAssignedVars, AUsedVars: TStringList);
    procedure AnalyzeProcedureCallUsage(const AProcCall: TCPAstProcedureCall; const AAssignedVars, AUsedVars: TStringList);

  public
    constructor Create();
    destructor Destroy(); override;

    procedure WriteMessage(const AMessage: string; const AArgs: array of const);
    procedure WriteMessageLn(const AMessage: string; const AArgs: array of const);

    function CompileProgram(const ASourceCode: string; const ASourceFile: string = 'program.pas'): TCPCompilationResult;
    function CompileFile(const ASourceFile: string): TCPCompilationResult;
    function CompileToExecutable(const ASourceCode: string; const ASourceFile: string = 'program.pas'): TCPCompilationResult;

    property OutputDirectory: string read FOutputDirectory write FOutputDirectory;
    property KeepIntermediateFiles: Boolean read FKeepIntermediateFiles write FKeepIntermediateFiles;
    property LinkerConfig: TCPLinkerConfig read FLinkerConfig;
    property CompilerConfig: TCPCompilerConfig read FCompilerConfig;

    // Phase tracking properties
    property CurrentPhase: TCPCompilationPhase read FCurrentPhase;
    property CurrentFileName: string read FCurrentFileName;

    // Enhanced callback properties
    property OnStartup: TCPCompilerStartupCallback read FOnStartup write FOnStartup;
    property OnShutdown: TCPCompilerShutdownCallback read FOnShutdown write FOnShutdown;
    property OnMessage: TCPCompilerMessageCallback read FOnMessage write FOnMessage;
    property OnProgress: TCPCompilerProgressCallback read FOnProgress write FOnProgress;
    property OnWarning: TCPCompilerWarningCallback read FOnWarning write FOnWarning;
    property OnError: TCPCompilerErrorCallback read FOnError write FOnError;
    property OnAnalysis: TCPCompilerAnalysisCallback read FOnAnalysis write FOnAnalysis;
  end;

implementation

// =============================================================================
// TCPCompilationResult Implementation
// =============================================================================

class function TCPCompilationResult.CreateSuccess(const AOutputFile: string): TCPCompilationResult;
begin
  Result.Success := True;
  Result.ErrorMessage := '';
  Result.OutputFile := AOutputFile;
end;

class function TCPCompilationResult.CreateFailure(const AErrorMessage: string): TCPCompilationResult;
begin
  Result.Success := False;
  Result.ErrorMessage := AErrorMessage;
  Result.OutputFile := '';
end;

// =============================================================================
// TCPLinkerConfig Implementation
// =============================================================================

constructor TCPLinkerConfig.Create();
begin
  inherited Create();
  FLibraries := TStringList.Create();
  FLibraryPaths := TStringList.Create();
  FSubsystem := stConsole;
  FLinkerPath := '';

  // Enable case-sensitive duplicates detection
  FLibraries.Duplicates := dupIgnore;
  FLibraryPaths.Duplicates := dupIgnore;
end;

destructor TCPLinkerConfig.Destroy();
begin
  FLibraryPaths.Free();
  FLibraries.Free();
  inherited Destroy();
end;

procedure TCPLinkerConfig.AddLibrary(const ALibraryName: string);
begin
  if Trim(ALibraryName) <> '' then
    FLibraries.Add(Trim(ALibraryName));
end;

procedure TCPLinkerConfig.AddLibraryPath(const APath: string);
begin
  if Trim(APath) <> '' then
    FLibraryPaths.Add(Trim(APath));
end;

procedure TCPLinkerConfig.SetDefaultLibraries();
begin
  ClearLibraries();

  // Essential Windows runtime libraries
  AddLibrary('kernel32.lib');
  AddLibrary('user32.lib');
  AddLibrary('msvcrt.lib');      // C runtime
  AddLibrary('legacy_stdio_definitions.lib');  // For older printf compatibility

  // Additional commonly needed libraries
  AddLibrary('advapi32.lib');    // Advanced Windows APIs
  AddLibrary('shell32.lib');     // Shell APIs
  AddLibrary('ole32.lib');       // COM/OLE APIs
end;

procedure TCPLinkerConfig.ClearLibraries();
begin
  FLibraries.Clear();
end;

// =============================================================================
// TCPCodeGenerator Implementation
// =============================================================================

constructor TCPCodeGenerator.Create(const AModuleName: string; const AErrorHandler: TCPErrorHandler);
begin
  inherited Create();
  FErrorHandler := AErrorHandler;

  try
    // Create LLVM context
    FContext := LLVMContextCreate();
    if not Assigned(FContext) then
      raise ECPCompilerError.Create('Failed to create LLVM context', cpCodeGeneration, 
                                   TCPSourceLocation.Create('', 0, 0));

    // Create LLVM module
    FModule := LLVMModuleCreateWithNameInContext(PUTF8Char(UTF8String(AModuleName)), FContext);
    if not Assigned(FModule) then
      raise ECPCompilerError.Create('Failed to create LLVM module', cpCodeGeneration, 
                                   TCPSourceLocation.Create('', 0, 0));

    // Create instruction builder
    FBuilder := LLVMCreateBuilderInContext(FContext);
    if not Assigned(FBuilder) then
      raise ECPCompilerError.Create('Failed to create LLVM builder', cpCodeGeneration, 
                                   TCPSourceLocation.Create('', 0, 0));

    // Initialize symbol table
    FSymbols := TDictionary<string, LLVMValueRef>.Create();

    // Initialize platform
    InitPlatform();

    FMainFunction := nil;

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E);
      raise;
    end;
  end;
end;

destructor TCPCodeGenerator.Destroy();
begin
  if Assigned(FTargetMachine) then
    LLVMDisposeTargetMachine(FTargetMachine);
  if Assigned(FBuilder) then
    LLVMDisposeBuilder(FBuilder);
  if Assigned(FModule) then
    LLVMDisposeModule(FModule);
  if Assigned(FContext) then
    LLVMContextDispose(FContext);
  FSymbols.Free();
  inherited Destroy();
end;

function TCPCodeGenerator.GetInt8Type(): LLVMTypeRef;
begin
  Result := LLVMInt8TypeInContext(FContext);
end;

function TCPCodeGenerator.GetInt32Type(): LLVMTypeRef;
begin
  Result := LLVMInt32TypeInContext(FContext);
end;

function TCPCodeGenerator.GetDoubleType(): LLVMTypeRef;
begin
  Result := LLVMDoubleTypeInContext(FContext);
end;

function TCPCodeGenerator.GetVoidType(): LLVMTypeRef;
begin
  Result := LLVMVoidTypeInContext(FContext);
end;

function TCPCodeGenerator.GetPointerType(const AElementType: LLVMTypeRef): LLVMTypeRef;
begin
  Result := LLVMPointerType(AElementType, 0);
end;

function TCPCodeGenerator.GetCallingConvention(const AConvention: TCPCallingConvention): Cardinal;
begin
  case AConvention of
    ccCdecl: Result := 0;    // LLVMCCallConv
    ccStdcall: Result := 64; // LLVMX86StdcallCallConv
    ccFastcall: Result := 65; // LLVMX86FastcallCallConv
    ccRegister: Result := 0;  // Use C calling convention
    else
      Result := 0; // Default to C calling convention
  end;
end;

function TCPCodeGenerator.GetLLVMTypeFromCPascalType(const ATypeName: string): LLVMTypeRef;
begin
  // Map CPascal types to LLVM types
  if SameText(ATypeName, 'Int8') then
    Result := GetInt8Type()
  else if SameText(ATypeName, 'UInt8') then
    Result := GetInt8Type()
  else if SameText(ATypeName, 'Int16') then
    Result := LLVMInt16TypeInContext(FContext)
  else if SameText(ATypeName, 'UInt16') then
    Result := LLVMInt16TypeInContext(FContext)
  else if SameText(ATypeName, 'Int32') then
    Result := GetInt32Type()
  else if SameText(ATypeName, 'UInt32') then
    Result := GetInt32Type()
  else if SameText(ATypeName, 'Int64') then
    Result := LLVMInt64TypeInContext(FContext)
  else if SameText(ATypeName, 'UInt64') then
    Result := LLVMInt64TypeInContext(FContext)
  else if SameText(ATypeName, 'Single') then
    Result := LLVMFloatTypeInContext(FContext)
  else if SameText(ATypeName, 'Double') then
    Result := GetDoubleType()
  else if SameText(ATypeName, 'Boolean') then
    Result := LLVMInt1TypeInContext(FContext)
  else if SameText(ATypeName, 'Char') then
    Result := GetInt8Type()
  else if SameText(ATypeName, 'PChar') then
    Result := GetPointerType(GetInt8Type())
  else if SameText(ATypeName, 'Pointer') then
    Result := GetPointerType(GetInt8Type())
  else
  begin
    // Default to i32 for unknown types
    Result := GetInt32Type();
  end;
end;

procedure TCPCodeGenerator.InitPlatform();
var
  LTargetTriple: PUTF8Char;
  LTarget: LLVMTargetRef;
  LErrorMessage: PUTF8Char;
  LCPUName: PUTF8Char;
  LFeatures: PUTF8Char;
  LDataLayout: LLVMTargetDataRef;
begin
  try
    // Initialize target
    Platform_InitLLVMTarget();

    // Get default target triple
    LTargetTriple := LLVMGetDefaultTargetTriple();
    try
      // Set target triple for module
      LLVMSetTarget(FModule, LTargetTriple);

      // Get target from triple
      if LLVMGetTargetFromTriple(LTargetTriple, @LTarget, @LErrorMessage) <> 0 then
      begin
        if Assigned(LErrorMessage) then
        begin
          LLVMDisposeMessage(LErrorMessage);
        end;
        raise ECPCompilerError.Create('Failed to get target from triple', cpCodeGeneration,
                                     TCPSourceLocation.Create('', 0, 0));
      end;

      // Create target machine
      LCPUName := PUTF8Char('generic');
      LFeatures := PUTF8Char('');
      FTargetMachine := LLVMCreateTargetMachine(
        LTarget,
        LTargetTriple,
        LCPUName,
        LFeatures,
        LLVMCodeGenLevelDefault,
        LLVMRelocDefault,
        LLVMCodeModelDefault
      );

      if not Assigned(FTargetMachine) then
        raise ECPCompilerError.Create('Failed to create target machine', cpCodeGeneration,
                                     TCPSourceLocation.Create('', 0, 0));

      // Set data layout
      LDataLayout := LLVMCreateTargetDataLayout(FTargetMachine);
      try
        LLVMSetModuleDataLayout(FModule, LDataLayout);
      finally
        LLVMDisposeTargetData(LDataLayout);
      end;

    finally
      LLVMDisposeMessage(LTargetTriple);
    end;

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E);
      raise;
    end;
  end;
end;

function TCPCodeGenerator.GenerateFromAST(const AProgram: TCPAstProgram): Boolean;
begin
  try
    FErrorHandler.SetCurrentPhase(cpCodeGeneration);
    Result := GenerateProgram(AProgram);
  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E);
      Result := False;
    end;
  end;
end;

function TCPCodeGenerator.GenerateProgram(const AProgram: TCPAstProgram): Boolean;
begin
  try
    // Add _fltused symbol for Windows floating-point runtime compatibility
    AddFltUsedSymbol();

    // Generate external function declarations (but not variables yet)
    if not GenerateExternalFunctions(AProgram.Declarations) then
    begin
      raise ECPCompilerError.Create('Failed to generate external function declarations', 
                                   cpCodeGeneration, AProgram.Position);
    end;

    // Create main function and position builder
    FMainFunction := CreateMainFunction();
    if not Assigned(FMainFunction) then
    begin
      raise ECPCompilerError.Create('Failed to create main function', 
                                   cpCodeGeneration, AProgram.Position);
    end;

    // NOW generate variable declarations (inside main function)
    if not GenerateVariableDeclarations(AProgram.Declarations) then
    begin
      raise ECPCompilerError.Create('Failed to generate variable declarations', 
                                   cpCodeGeneration, AProgram.Position);
    end;

    // Generate main compound statement
    if not GenerateCompoundStatement(AProgram.MainStatement) then
    begin
      raise ECPCompilerError.Create('Failed to generate main compound statement', 
                                   cpCodeGeneration, AProgram.MainStatement.Position);
    end;

    Result := True;
  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E);
      Result := False;
    end;
  end;
end;

function TCPCodeGenerator.CreateMainFunction(): LLVMValueRef;
var
  LMainType: LLVMTypeRef;
  LEntryBlock: LLVMBasicBlockRef;
begin
  try
    // Create main function type: int main()
    LMainType := LLVMFunctionType(GetInt32Type(), nil, 0, 0);

    // Add main function to module
    Result := LLVMAddFunction(FModule, PUTF8Char('main'), LMainType);

    // Create entry basic block
    LEntryBlock := LLVMAppendBasicBlockInContext(FContext, Result, PUTF8Char('entry'));

    // Position builder at end of entry block
    LLVMPositionBuilderAtEnd(FBuilder, LEntryBlock);

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E);
      Result := nil;
    end;
  end;
end;

procedure TCPCodeGenerator.AddFltUsedSymbol();
var
  LFltUsedType: LLVMTypeRef;
  LFltUsedVar: LLVMValueRef;
  LInitializer: LLVMValueRef;
begin
  try
    // Create _fltused as an i32 global variable with value 1
    // This symbol is required by the Microsoft C runtime when floating-point operations are used
    LFltUsedType := GetInt32Type();
    LFltUsedVar := LLVMAddGlobal(FModule, LFltUsedType, PUTF8Char('_fltused'));

    // Set initializer to 1
    LInitializer := LLVMConstInt(LFltUsedType, 1, 0);
    LLVMSetInitializer(LFltUsedVar, LInitializer);

    // Set linkage to external
    LLVMSetLinkage(LFltUsedVar, LLVMExternalLinkage);

    // Set global constant
    LLVMSetGlobalConstant(LFltUsedVar, 1);

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E);
      raise;
    end;
  end;
end;

function TCPCodeGenerator.GenerateDeclarations(const ADeclarations: TCPAstDeclarations): Boolean;
var
  LExternalFunction: TCPAstExternalFunction;
  LVariableDecl: TCPAstVariableDecl;
begin
  Result := True;

  // Generate external functions
  for LExternalFunction in ADeclarations.Functions do
  begin
    if not Assigned(GenerateExternalFunction(LExternalFunction)) then
    begin
      Exit(False);
    end;
  end;

  // Generate variable declarations
  for LVariableDecl in ADeclarations.Variables do
  begin
    if not GenerateVariableDecl(LVariableDecl) then
    begin
      Exit(False);
    end;
  end;
end;

function TCPCodeGenerator.GenerateExternalFunctions(const ADeclarations: TCPAstDeclarations): Boolean;
var
  LExternalFunction: TCPAstExternalFunction;
begin
  Result := True;

  // Generate external functions only
  for LExternalFunction in ADeclarations.Functions do
  begin
    if not Assigned(GenerateExternalFunction(LExternalFunction)) then
    begin
      FErrorHandler.ReportError(LExternalFunction.Position.Line, LExternalFunction.Position.Column, 
                               'Failed to generate external function: ' + LExternalFunction.FunctionName);
      Exit(False);
    end;
  end;
end;

function TCPCodeGenerator.GenerateVariableDeclarations(const ADeclarations: TCPAstDeclarations): Boolean;
var
  LVariableDecl: TCPAstVariableDecl;
begin
  Result := True;

  // Generate variable declarations only (must be called after main function is created)
  for LVariableDecl in ADeclarations.Variables do
  begin
    if not GenerateVariableDecl(LVariableDecl) then
    begin
      FErrorHandler.ReportError(LVariableDecl.Position.Line, LVariableDecl.Position.Column, 
                               'Failed to generate variable declaration');
      Exit(False);
    end;
  end;
end;

function TCPCodeGenerator.GenerateExternalFunction(const AFunction: TCPAstExternalFunction): LLVMValueRef;
var
  LParamTypes: array of LLVMTypeRef;
  LParamType: LLVMTypeRef;
  LReturnType: LLVMTypeRef;
  LFunctionType: LLVMTypeRef;
  LParameter: TCPAstParameter;
  LIndex: Integer;
begin
  try
    // Build parameter types array
    SetLength(LParamTypes, Length(AFunction.Parameters));
    LIndex := 0;

    for LParameter in AFunction.Parameters do
    begin
      // Map parameter type to LLVM type
      LParamType := GetLLVMTypeFromCPascalType(LParameter.ParamType.TypeName);
      LParamTypes[LIndex] := LParamType;
      Inc(LIndex);
    end;

    // Set return type based on function return type
    if Assigned(AFunction.ReturnType) then
    begin
      LReturnType := GetLLVMTypeFromCPascalType(AFunction.ReturnType.TypeName);
    end
    else
    begin
      LReturnType := GetVoidType();
    end;

    // Create function type
    if Length(LParamTypes) > 0 then
    begin
      LFunctionType := LLVMFunctionType(
        LReturnType,
        @LParamTypes[0],
        Length(LParamTypes),
        Ord(AFunction.IsVariadic)  // Use varargs flag
      );
    end
    else
    begin
      LFunctionType := LLVMFunctionType(
        LReturnType,
        nil,
        0,
        Ord(AFunction.IsVariadic)  // Use varargs flag
      );
    end;

    // Add function to module
    Result := LLVMAddFunction(FModule, PUTF8Char(UTF8String(AFunction.FunctionName)), LFunctionType);

    // Set calling convention
    LLVMSetFunctionCallConv(Result, GetCallingConvention(AFunction.CallingConvention));

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E, AFunction.Position.Line, AFunction.Position.Column);
      Result := nil;
    end;
  end;
end;

function TCPCodeGenerator.GenerateVariableDecl(const AVariable: TCPAstVariableDecl): Boolean;
var
  LVarType: LLVMTypeRef;
  LVarName: string;
  LAlloca: LLVMValueRef;
begin
  Result := True;
  
  try
    // Get LLVM type from CPascal type
    LVarType := GetLLVMTypeFromCPascalType(AVariable.VariableType.TypeName);
    
    // Create alloca instruction for each variable
    for LVarName in AVariable.VariableNames do
    begin
      // Create alloca instruction in entry block of main function
      LAlloca := LLVMBuildAlloca(FBuilder, LVarType, PUTF8Char(UTF8String(LVarName)));
      
      if not Assigned(LAlloca) then
      begin
        FErrorHandler.ReportError(AVariable.Position.Line, AVariable.Position.Column, 
                                 'Failed to create alloca for variable: ' + LVarName);
        Exit(False);
      end;
      
      // Store variable in symbol table
      FSymbols.AddOrSetValue(LVarName, LAlloca);
    end;
    
  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E, AVariable.Position.Line, AVariable.Position.Column);
      Result := False;
    end;
  end;
end;

function TCPCodeGenerator.GenerateCompoundStatement(const AStatement: TCPAstCompoundStatement): Boolean;
var
  LStatement: TCPAstStatement;
begin
  Result := True;

  try
    for LStatement in AStatement.Statements do
    begin
      if not GenerateStatement(LStatement) then
      begin
        Exit(False);
      end;
    end;

    // Add return statement at end of main function
    if Assigned(FMainFunction) then
    begin
      LLVMBuildRet(FBuilder, LLVMConstInt(GetInt32Type(), 0, 0));
    end;

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E, AStatement.Position.Line, AStatement.Position.Column);
      Result := False;
    end;
  end;
end;

function TCPCodeGenerator.GenerateStatement(const AStatement: TCPAstStatement): Boolean;
begin
  Result := True;

  try
    if AStatement is TCPAstProcedureCall then
    begin
      Result := GenerateProcedureCall(TCPAstProcedureCall(AStatement));
    end
    else if AStatement is TCPAstAssignmentStatement then
    begin
      Result := GenerateAssignmentStatement(TCPAstAssignmentStatement(AStatement));
    end
    else if AStatement is TCPAstIfStatement then
    begin
      Result := GenerateIfStatement(TCPAstIfStatement(AStatement));
    end
    else
    begin
      FErrorHandler.ReportError(AStatement.Position.Line, AStatement.Position.Column, 
                               'Unsupported statement type: ' + AStatement.ClassName);
      Result := False;
    end;

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E, AStatement.Position.Line, AStatement.Position.Column);
      Result := False;
    end;
  end;
end;

function TCPCodeGenerator.GenerateProcedureCall(const ACall: TCPAstProcedureCall): Boolean;
var
  LFunction: LLVMValueRef;
  LArgs: array of LLVMValueRef;
  LArg: LLVMValueRef;
  LExpression: TCPAstExpression;
  LIndex: Integer;
begin
  Result := False;

  try
    // Find the function in the module
    LFunction := LLVMGetNamedFunction(FModule, PUTF8Char(UTF8String(ACall.ProcedureName)));
    if not Assigned(LFunction) then
    begin
      FErrorHandler.ReportError(ACall.Position.Line, ACall.Position.Column, 
                               'Function not found: ' + ACall.ProcedureName);
      Exit;
    end;

    // Build arguments array
    SetLength(LArgs, Length(ACall.Arguments));
    LIndex := 0;

    for LExpression in ACall.Arguments do
    begin
      LArg := GenerateExpression(LExpression);
      if not Assigned(LArg) then
      begin
        FErrorHandler.ReportError(LExpression.Position.Line, LExpression.Position.Column, 
                                 'Failed to generate argument ' + IntToStr(LIndex + 1));
        Exit;
      end;

      LArgs[LIndex] := LArg;
      Inc(LIndex);
    end;

    // Generate function call
    if Length(LArgs) > 0 then
    begin
      LLVMBuildCall2(
        FBuilder,
        LLVMGlobalGetValueType(LFunction),
        LFunction,
        @LArgs[0],
        Length(LArgs),
        PUTF8Char('')
      );
    end
    else
    begin
      LLVMBuildCall2(
        FBuilder,
        LLVMGlobalGetValueType(LFunction),
        LFunction,
        nil,
        0,
        PUTF8Char('')
      );
    end;

    Result := True;

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E, ACall.Position.Line, ACall.Position.Column);
      Result := False;
    end;
  end;
end;

function TCPCodeGenerator.GenerateAssignmentStatement(const AAssignment: TCPAstAssignmentStatement): Boolean;
var
  LVariable: LLVMValueRef;
  LValue: LLVMValueRef;
begin
  Result := False;
  
  try
    // Look up variable in symbol table
    if not FSymbols.TryGetValue(AAssignment.VariableName, LVariable) then
    begin
      FErrorHandler.ReportError(AAssignment.Position.Line, AAssignment.Position.Column, 
                               'Variable not found: ' + AAssignment.VariableName);
      Exit;
    end;
    
    // Generate expression value
    LValue := GenerateExpression(AAssignment.Expression);
    if not Assigned(LValue) then
    begin
      FErrorHandler.ReportError(AAssignment.Expression.Position.Line, AAssignment.Expression.Position.Column, 
                               'Failed to generate expression value');
      Exit;
    end;
    
    // Generate store instruction
    LLVMBuildStore(FBuilder, LValue, LVariable);
    
    Result := True;

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E, AAssignment.Position.Line, AAssignment.Position.Column);
      Result := False;
    end;
  end;
end;

function TCPCodeGenerator.GenerateIfStatement(const AIfStatement: TCPAstIfStatement): Boolean;
var
  LCondition: LLVMValueRef;
  LThenBlock: LLVMBasicBlockRef;
  LElseBlock: LLVMBasicBlockRef;
  LMergeBlock: LLVMBasicBlockRef;
  LHasElse: Boolean;
begin
  Result := False;
  
  try
    // Generate condition expression
    LCondition := GenerateExpression(AIfStatement.Condition);
    if not Assigned(LCondition) then
    begin
      FErrorHandler.ReportError(AIfStatement.Condition.Position.Line, AIfStatement.Condition.Position.Column, 
                               'Failed to generate if condition');
      Exit;
    end;
    
    // Check if there's an else clause
    LHasElse := Assigned(AIfStatement.ElseStatement);
    
    // Create basic blocks
    LThenBlock := LLVMAppendBasicBlockInContext(FContext, FMainFunction, PUTF8Char('if.then'));
    if LHasElse then
      LElseBlock := LLVMAppendBasicBlockInContext(FContext, FMainFunction, PUTF8Char('if.else'));
    LMergeBlock := LLVMAppendBasicBlockInContext(FContext, FMainFunction, PUTF8Char('if.end'));
    
    // Generate conditional branch
    if LHasElse then
      LLVMBuildCondBr(FBuilder, LCondition, LThenBlock, LElseBlock)
    else
      LLVMBuildCondBr(FBuilder, LCondition, LThenBlock, LMergeBlock);
    
    // Generate then block
    LLVMPositionBuilderAtEnd(FBuilder, LThenBlock);
    if not GenerateStatement(AIfStatement.ThenStatement) then
    begin
      FErrorHandler.ReportError(AIfStatement.ThenStatement.Position.Line, AIfStatement.ThenStatement.Position.Column, 
                               'Failed to generate then statement');
      Exit;
    end;
    LLVMBuildBr(FBuilder, LMergeBlock);
    
    // Generate else block if present
    if LHasElse then
    begin
      LLVMPositionBuilderAtEnd(FBuilder, LElseBlock);
      if not GenerateStatement(AIfStatement.ElseStatement) then
      begin
        FErrorHandler.ReportError(AIfStatement.ElseStatement.Position.Line, AIfStatement.ElseStatement.Position.Column, 
                                 'Failed to generate else statement');
        Exit;
      end;
      LLVMBuildBr(FBuilder, LMergeBlock);
    end;
    
    // Position at merge block for subsequent code
    LLVMPositionBuilderAtEnd(FBuilder, LMergeBlock);
    
    Result := True;

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E, AIfStatement.Position.Line, AIfStatement.Position.Column);
      Result := False;
    end;
  end;
end;

function TCPCodeGenerator.GenerateExpression(const AExpression: TCPAstExpression): LLVMValueRef;
var
  LVariableAlloca: LLVMValueRef;
  LAllocaType: LLVMTypeRef;
begin
  Result := nil;

  try
    if AExpression is TCPAstStringLiteral then
    begin
      Result := GenerateStringLiteral(TCPAstStringLiteral(AExpression));
    end
    else if AExpression is TCPAstNumberLiteral then
    begin
      Result := GenerateNumberLiteral(TCPAstNumberLiteral(AExpression));
    end
    else if AExpression is TCPAstRealLiteral then
    begin
      Result := GenerateRealLiteral(TCPAstRealLiteral(AExpression));
    end
    else if AExpression is TCPAstCharacterLiteral then
    begin
      Result := GenerateCharacterLiteral(TCPAstCharacterLiteral(AExpression));
    end
    else if AExpression is TCPAstVariableReference then
    begin
      Result := GenerateVariableReference(TCPAstVariableReference(AExpression));
    end
    else if AExpression is TCPAstComparisonExpression then
    begin
      Result := GenerateComparisonExpression(TCPAstComparisonExpression(AExpression));
    end
    else if AExpression is TCPAstIdentifier then
    begin
      // Treat identifiers as variable references in expression context
      if FSymbols.TryGetValue(TCPAstIdentifier(AExpression).Name, LVariableAlloca) then
      begin
        // Get the type that was allocated (the type the pointer points to)
        LAllocaType := LLVMGetAllocatedType(LVariableAlloca);
        // Generate load instruction to get variable value
        Result := LLVMBuildLoad2(
          FBuilder,
          LAllocaType,
          LVariableAlloca,
          PUTF8Char(UTF8String('load_' + TCPAstIdentifier(AExpression).Name))
        );
      end
      else
      begin
        FErrorHandler.ReportError(AExpression.Position.Line, AExpression.Position.Column, 
                                 'Variable not found in symbol table: ' + TCPAstIdentifier(AExpression).Name);
      end;
    end
    else
    begin
      FErrorHandler.ReportError(AExpression.Position.Line, AExpression.Position.Column, 
                               'Unsupported expression type: ' + AExpression.ClassName);
    end;

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E, AExpression.Position.Line, AExpression.Position.Column);
      Result := nil;
    end;
  end;
end;

function TCPCodeGenerator.GenerateStringLiteral(const AString: TCPAstStringLiteral): LLVMValueRef;
var
  LStringValue: string;
  LUtf8Value: UTF8String;
  LGlobalString: LLVMValueRef;
  LZeroIndex: LLVMValueRef;
  LIndices: array[0..1] of LLVMValueRef;
begin
  try
    // String is already without quotes from the parser
    LStringValue := AString.Value;

    // Store UTF8String in variable to avoid temporary destruction
    LUtf8Value := UTF8String(LStringValue);

    // Create global string constant
    LGlobalString := LLVMBuildGlobalString(FBuilder, PUTF8Char(LUtf8Value), PUTF8Char('str'));

    // Create GEP to get pointer to first character
    LZeroIndex := LLVMConstInt(GetInt32Type(), 0, 0);
    LIndices[0] := LZeroIndex;
    LIndices[1] := LZeroIndex;

    Result := LLVMBuildGEP2(
      FBuilder,
      LLVMGetElementType(LLVMTypeOf(LGlobalString)),
      LGlobalString,
      @LIndices[0],
      2,
      PUTF8Char('strptr')
    );

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E, AString.Position.Line, AString.Position.Column);
      Result := nil;
    end;
  end;
end;

function TCPCodeGenerator.GenerateNumberLiteral(const ANumber: TCPAstNumberLiteral): LLVMValueRef;
var
  LValue: Integer;
begin
  try
    // Convert string to integer (basic implementation)
    LValue := StrToIntDef(ANumber.Value, 0);

    // Create LLVM constant integer
    Result := LLVMConstInt(GetInt32Type(), LValue, 0);

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E, ANumber.Position.Line, ANumber.Position.Column);
      Result := nil;
    end;
  end;
end;

function TCPCodeGenerator.GenerateRealLiteral(const AReal: TCPAstRealLiteral): LLVMValueRef;
var
  LValue: Double;
begin
  try
    // Convert string to double (basic implementation)
    LValue := StrToFloatDef(AReal.Value, 0.0);

    // Create LLVM constant real
    Result := LLVMConstReal(GetDoubleType(), LValue);

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E, AReal.Position.Line, AReal.Position.Column);
      Result := nil;
    end;
  end;
end;

function TCPCodeGenerator.GenerateCharacterLiteral(const ACharacter: TCPAstCharacterLiteral): LLVMValueRef;
begin
  try
    // Create LLVM constant integer for character value
    Result := LLVMConstInt(GetInt8Type(), ACharacter.Value, 0);

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E, ACharacter.Position.Line, ACharacter.Position.Column);
      Result := nil;
    end;
  end;
end;

function TCPCodeGenerator.GenerateVariableReference(const AVariable: TCPAstVariableReference): LLVMValueRef;
var
  LVariableAlloca: LLVMValueRef;
  LAllocaType: LLVMTypeRef;
begin
  Result := nil;
  
  try
    // Look up variable in symbol table
    if not FSymbols.TryGetValue(AVariable.VariableName, LVariableAlloca) then
    begin
      FErrorHandler.ReportError(AVariable.Position.Line, AVariable.Position.Column, 
                               'Variable not found: ' + AVariable.VariableName);
      Exit;
    end;
    
    // Get the type that was allocated (the type the pointer points to)
    LAllocaType := LLVMGetAllocatedType(LVariableAlloca);
    // Generate load instruction using modern LLVM API
    Result := LLVMBuildLoad2(
      FBuilder,
      LAllocaType,
      LVariableAlloca,
      PUTF8Char(UTF8String('load_' + AVariable.VariableName))
    );

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E, AVariable.Position.Line, AVariable.Position.Column);
      Result := nil;
    end;
  end;
end;

function TCPCodeGenerator.GenerateComparisonExpression(const AComparison: TCPAstComparisonExpression): LLVMValueRef;
var
  LLeft: LLVMValueRef;
  LRight: LLVMValueRef;
  LLeftType: LLVMTypeRef;
  LRightType: LLVMTypeRef;
  LIsFloatComparison: Boolean;
begin
  Result := nil;
  
  try
    // Generate left and right operands
    LLeft := GenerateExpression(AComparison.Left);
    if not Assigned(LLeft) then
    begin
      FErrorHandler.ReportError(AComparison.Left.Position.Line, AComparison.Left.Position.Column, 
                               'Failed to generate left operand');
      Exit;
    end;
      
    LRight := GenerateExpression(AComparison.Right);
    if not Assigned(LRight) then
    begin
      FErrorHandler.ReportError(AComparison.Right.Position.Line, AComparison.Right.Position.Column, 
                               'Failed to generate right operand');
      Exit;
    end;
    
    // Get operand types to determine comparison type
    LLeftType := LLVMTypeOf(LLeft);
    LRightType := LLVMTypeOf(LRight);
    
    // Check if this is a floating point comparison
    LIsFloatComparison := (LLVMGetTypeKind(LLeftType) = LLVMFloatTypeKind) or 
                          (LLVMGetTypeKind(LLeftType) = LLVMDoubleTypeKind) or
                          (LLVMGetTypeKind(LRightType) = LLVMFloatTypeKind) or 
                          (LLVMGetTypeKind(LRightType) = LLVMDoubleTypeKind);
    
    // Generate appropriate comparison based on type and operator
    if LIsFloatComparison then
    begin
      // Floating point comparisons
      case AComparison.Operator of
        tkEqual:
          Result := LLVMBuildFCmp(FBuilder, LLVMRealOEQ, LLeft, LRight, PUTF8Char('fcmp_eq'));
        tkNotEqual:
          Result := LLVMBuildFCmp(FBuilder, LLVMRealONE, LLeft, LRight, PUTF8Char('fcmp_ne'));
        tkLessThan:
          Result := LLVMBuildFCmp(FBuilder, LLVMRealOLT, LLeft, LRight, PUTF8Char('fcmp_lt'));
        tkLessThanOrEqual:
          Result := LLVMBuildFCmp(FBuilder, LLVMRealOLE, LLeft, LRight, PUTF8Char('fcmp_le'));
        tkGreaterThan:
          Result := LLVMBuildFCmp(FBuilder, LLVMRealOGT, LLeft, LRight, PUTF8Char('fcmp_gt'));
        tkGreaterThanOrEqual:
          Result := LLVMBuildFCmp(FBuilder, LLVMRealOGE, LLeft, LRight, PUTF8Char('fcmp_ge'));
        else
        begin
          FErrorHandler.ReportError(AComparison.Position.Line, AComparison.Position.Column, 
                                   'Unsupported floating point comparison operator');
        end;
      end;
    end
    else
    begin
      // Integer comparisons
      case AComparison.Operator of
        tkEqual:
          Result := LLVMBuildICmp(FBuilder, LLVMIntEQ, LLeft, LRight, PUTF8Char('icmp_eq'));
        tkNotEqual:
          Result := LLVMBuildICmp(FBuilder, LLVMIntNE, LLeft, LRight, PUTF8Char('icmp_ne'));
        tkLessThan:
          Result := LLVMBuildICmp(FBuilder, LLVMIntSLT, LLeft, LRight, PUTF8Char('icmp_lt'));
        tkLessThanOrEqual:
          Result := LLVMBuildICmp(FBuilder, LLVMIntSLE, LLeft, LRight, PUTF8Char('icmp_le'));
        tkGreaterThan:
          Result := LLVMBuildICmp(FBuilder, LLVMIntSGT, LLeft, LRight, PUTF8Char('icmp_gt'));
        tkGreaterThanOrEqual:
          Result := LLVMBuildICmp(FBuilder, LLVMIntSGE, LLeft, LRight, PUTF8Char('icmp_ge'));
        else
        begin
          FErrorHandler.ReportError(AComparison.Position.Line, AComparison.Position.Column, 
                                   'Unsupported integer comparison operator');
        end;
      end;
    end;

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E, AComparison.Position.Line, AComparison.Position.Column);
      Result := nil;
    end;
  end;
end;

function TCPCodeGenerator.GetModuleIR(): string;
var
  LIRString: PUTF8Char;
begin
  try
    LIRString := LLVMPrintModuleToString(FModule);
    try
      Result := string(UTF8String(LIRString));
    finally
      LLVMDisposeMessage(LIRString);
    end;
  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E);
      Result := '';
    end;
  end;
end;

function TCPCodeGenerator.VerifyModule(): Boolean;
var
  LErrorMessage: PUTF8Char;
begin
  try
    Result := LLVMVerifyModule(FModule, LLVMReturnStatusAction, @LErrorMessage) = 0;
    if not Result and Assigned(LErrorMessage) then
    begin
      FErrorHandler.ReportError(0, 0, 'Module verification failed: ' + string(UTF8String(LErrorMessage)));
      LLVMDisposeMessage(LErrorMessage);
    end;
  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E);
      Result := False;
    end;
  end;
end;

function TCPCodeGenerator.WriteObjectFile(const AFileName: string): Boolean;
var
  LObjectFileName: string;
  LIRFileName: string;
  LErrorMessage: PUTF8Char;
begin
  Result := False;

  try
    if not Assigned(FTargetMachine) then
    begin
      FErrorHandler.ReportError(0, 0, 'Target machine not initialized');
      Exit;
    end;

    // Generate both .ll (IR) and .obj (object) files
    LIRFileName := ChangeFileExt(AFileName, '.ll');
    LObjectFileName := ChangeFileExt(AFileName, '.obj');

    // Write LLVM IR file for debugging
    TFile.WriteAllText(LIRFileName, GetModuleIR());
    FErrorHandler.ReportProgress('LLVM IR written to: ' + LIRFileName);

    // Generate actual object file using target machine
    if LLVMTargetMachineEmitToFile(
      FTargetMachine,
      FModule,
      PUTF8Char(UTF8String(LObjectFileName)),
      LLVMObjectFile,
      @LErrorMessage
    ) = 0 then
    begin
      Result := True;
      FErrorHandler.ReportProgress('Object file written to: ' + LObjectFileName);
    end
    else
    begin
      if Assigned(LErrorMessage) then
      begin
        FErrorHandler.ReportError(0, 0, 'Failed to write object file: ' + string(UTF8String(LErrorMessage)));
        LLVMDisposeMessage(LErrorMessage);
      end;
    end;

  except
    on E: Exception do
    begin
      FErrorHandler.HandleException(E);
      Result := False;
    end;
  end;
end;

// =============================================================================
// TCPCompiler Implementation
// =============================================================================

constructor TCPCompiler.Create();
begin
  inherited Create();
  FOutputDirectory := 'output';
  FKeepIntermediateFiles := True;
  FLinkerConfig := TCPLinkerConfig.Create();
  FCompilerConfig := TCPCompilerConfig.Create();
  FSourceLines := TStringList.Create();
  
  // Create error handler with proper callback references
  FErrorHandler := TCPErrorHandler.Create(
    procedure(const ALocation: TCPSourceLocation; const APhase: TCPCompilationPhase; const AMessage: string; const AHelp: string = '')
    begin
      DoError(ALocation, AMessage, AHelp);
    end,
    procedure(const ALocation: TCPSourceLocation; const APhase: TCPCompilationPhase; const ALevel: TCPWarningLevel; const ACategory: TCPWarningCategory; const AMessage: string; const AHint: string = '')
    begin
      DoWarning(ALocation, ALevel, ACategory, AMessage, AHint);
    end,
    procedure(const AMessage: string)
    begin
      DoMessage(AMessage);
    end,
    procedure(const AFileName: string; const APhase: TCPCompilationPhase; const AMessage: string; const APercentComplete: Integer = -1)
    begin
      DoProgress(AMessage, APercentComplete);
    end,
    FCompilerConfig,
    procedure(const ALocation: TCPSourceLocation; const AAnalysisType: string; const AData: string)
    begin
      DoAnalysis(ALocation, AAnalysisType, AData);
    end
  );

  InitializeLinkerConfig();
end;

destructor TCPCompiler.Destroy();
begin
  DoShutdown();
  FErrorHandler.Free();
  FSourceLines.Free();
  FCompilerConfig.Free();
  FLinkerConfig.Free();
  inherited Destroy();
end;

procedure TCPCompiler.InitializeLinkerConfig();
var
  LLinkerPath: string;
begin
  // Set default subsystem
  FLinkerConfig.Subsystem := stConsole;

  // Find linker path
  LLinkerPath := FindLinkerPath();
  if LLinkerPath <> '' then
    FLinkerConfig.LinkerPath := LLinkerPath;

  // Set default libraries
  FLinkerConfig.SetDefaultLibraries();

  // Add common library paths
  FLinkerConfig.AddLibraryPath('.\libs');
end;

function TCPCompiler.FindLinkerPath(): string;
var
  LPossiblePaths: TArray<string>;
  LPath: string;
  LExpandedPath: string;
begin
  Result := '';

  // Common locations for lld-link.exe
  LPossiblePaths := [
    'lld-link.exe',  // In PATH
    'bin\lld-link.exe',  // Relative to current directory
    '..\bin\lld-link.exe',  // Relative to parent
    'C:\Program Files\LLVM\bin\lld-link.exe',  // Standard LLVM installation
    'C:\LLVM\bin\lld-link.exe',  // Alternative LLVM location
    ExtractFilePath(ParamStr(0)) + 'lld-link.exe',  // Same directory as executable
    ExtractFilePath(ParamStr(0)) + 'bin\lld-link.exe',  // bin subdirectory
    ExtractFilePath(ParamStr(0)) + '..\bin\lld-link.exe'  // Parent bin subdirectory
  ];

  for LPath in LPossiblePaths do
  begin
    try
      if TPath.IsRelativePath(LPath) and not LPath.StartsWith('C:\') then
      begin
        LExpandedPath := TPath.GetFullPath(LPath);
      end
      else
      begin
        LExpandedPath := LPath;
      end;

      if TFile.Exists(LExpandedPath) then
      begin
        Result := LExpandedPath;
        Break;
      end;
    except
      // Ignore path resolution errors and continue
      Continue;
    end;
  end;

  // If not found in standard locations, try PATH environment variable
  if Result = '' then
  begin
    // Check if lld-link.exe can be found via PATH
    Result := 'lld-link.exe';  // Will be resolved by CreateProcess if in PATH
  end;
end;

// Enhanced phase management methods
procedure TCPCompiler.SetCurrentPhase(const APhase: TCPCompilationPhase; const AFileName: string = '');
begin
  FCurrentPhase := APhase;
  if AFileName <> '' then
    FCurrentFileName := AFileName;
  FErrorHandler.SetCurrentPhase(APhase);
  if AFileName <> '' then
    FErrorHandler.SetCurrentFile(AFileName);
end;

procedure TCPCompiler.DoStartup();
begin
  if Assigned(FOnStartup) then
    FOnStartup();
end;

procedure TCPCompiler.DoShutdown();
begin
  if Assigned(FOnShutdown) then
    FOnShutdown(FCompilerConfig.ErrorCount = 0, FCompilerConfig.ErrorCount, FCompilerConfig.WarningCount);
end;

procedure TCPCompiler.DoMessage(const AMessage: string);
begin
  if Assigned(FOnMessage) then
    FOnMessage(AMessage);
end;

procedure TCPCompiler.DoProgress(const AMessage: string; const APercentComplete: Integer = -1);
begin
  if Assigned(FOnProgress) then
    FOnProgress(FCurrentFileName, FCurrentPhase, AMessage, APercentComplete);
end;

// Enhanced warning and error reporting
procedure TCPCompiler.DoWarning(const ALocation: TCPSourceLocation; const ALevel: TCPWarningLevel; const ACategory: TCPWarningCategory; const AMessage: string; const AHint: string = '');
begin
  // Check if category is enabled and within limits
  if not FCompilerConfig.IsCategoryEnabled(ACategory) then
    Exit;
    
  if FCompilerConfig.WarningCount >= FCompilerConfig.MaxWarnings then
    Exit;
    
  // Increment warning count
  FCompilerConfig.IncrementWarning(ACategory);
  
  // Treat as error if configured
  if FCompilerConfig.TreatWarningsAsErrors or (ALevel = wlError) then
  begin
    FCompilerConfig.IncrementError();
    DoError(ALocation, AMessage, AHint);
    Exit;
  end;
  
  if Assigned(FOnWarning) then
    FOnWarning(ALocation, FCurrentPhase, ALevel, ACategory, AMessage, AHint);
end;

procedure TCPCompiler.DoError(const ALocation: TCPSourceLocation; const AMessage: string; const AHelp: string = '');
begin
  FCompilerConfig.IncrementError();
  
  if Assigned(FOnError) then
    FOnError(ALocation, FCurrentPhase, AMessage, AHelp);
end;

procedure TCPCompiler.DoAnalysis(const ALocation: TCPSourceLocation; const AAnalysisType: string; const AData: string);
begin
  if Assigned(FOnAnalysis) then
    FOnAnalysis(ALocation, AAnalysisType, AData);
end;

// Legacy compatibility methods
procedure TCPCompiler.DoWarningSimple(const ALine, AColumn: Integer; const AMessage: string; const ACategory: TCPWarningCategory = wcGeneral);
var
  LLocation: TCPSourceLocation;
begin
  LLocation := CreateLocation(ALine, AColumn);
  DoWarning(LLocation, wlWarning, ACategory, AMessage);
end;

procedure TCPCompiler.DoErrorSimple(const ALine, AColumn: Integer; const AMessage: string);
var
  LLocation: TCPSourceLocation;
begin
  LLocation := CreateLocation(ALine, AColumn);
  DoError(LLocation, AMessage);
end;

// Utility methods for enhanced reporting
function TCPCompiler.CreateLocation(const ALine, AColumn: Integer; const ALength: Integer = 0): TCPSourceLocation;
begin
  Result.FileName := FCurrentFileName;
  Result.Line := ALine;
  Result.Column := AColumn;
  Result.Index := 0; // Could calculate from line/column if needed
  Result.Length := ALength;
  Result.LineContent := GetSourceLineContent(ALine);
end;

function TCPCompiler.GetSourceLineContent(const ALine: Integer): string;
begin
  Result := '';
  if (ALine > 0) and (ALine <= FSourceLines.Count) then
    Result := FSourceLines[ALine - 1]; // Lines are 1-based, list is 0-based
end;

procedure TCPCompiler.CacheSourceLines(const ASourceCode: string);
begin
  FSourceLines.Clear();
  FSourceLines.Text := ASourceCode;
end;

// Enhanced exception and message handling
procedure TCPCompiler.HandleCompilerException(const E: ECPCompilerError);
begin
  DoError(E.Location, E.Message, E.Help);
end;

procedure TCPCompiler.HandleGeneralException(const E: Exception; const ADefaultLine: Integer = 0; const ADefaultColumn: Integer = 0);
var
  LLocation: TCPSourceLocation;
begin
  LLocation := CreateLocation(ADefaultLine, ADefaultColumn);
  DoError(LLocation, E.Message);
end;

procedure TCPCompiler.WriteMessage(const AMessage: string; const AArgs: array of const);
begin
  DoMessage(Format(AMessage, AArgs));
end;

procedure TCPCompiler.WriteMessageLn(const AMessage: string; const AArgs: array of const);
begin
  DoMessage(Format(AMessage, AArgs) + sLineBreak);
end;

procedure TCPCompiler.WriteWarning(const AMessage: string; const ALine: Integer = 0; const AColumn: Integer = 0; const ACategory: TCPWarningCategory = wcGeneral);
begin
  DoWarningSimple(ALine, AColumn, AMessage, ACategory);
end;

function TCPCompiler.CompileProgram(const ASourceCode: string; const ASourceFile: string = 'program.pas'): TCPCompilationResult;
begin
  Result := CompileToObject(ASourceCode, ASourceFile);
end;

function TCPCompiler.CompileFile(const ASourceFile: string): TCPCompilationResult;
var
  LSourceCode: string;
begin
  try
    LSourceCode := TFile.ReadAllText(ASourceFile);
    Result := CompileToObject(LSourceCode, ASourceFile);
  except
    on E: Exception do
    begin
      Result.Success := False;
      Result.ErrorMessage := 'Failed to read source file: ' + E.Message;
      Result.OutputFile := '';
    end;
  end;
end;

function TCPCompiler.CompileToExecutable(const ASourceCode: string; const ASourceFile: string = 'program.pas'): TCPCompilationResult;
var
  LObjectResult: TCPCompilationResult;
  LBaseName: string;
  LExecutableFile: string;
  LObjectFile: string;
begin
  DoStartup();

  Result.Success := False;
  Result.ErrorMessage := '';
  Result.OutputFile := '';

  try
    // Reset warning/error counters for this compilation
    FCompilerConfig.Reset();
    FErrorHandler.ResetErrorCount();
    WriteMessageLn('Error counters reset. Starting fresh compilation.', []);
    
    // First, compile to object file
    LObjectResult := CompileToObject(ASourceCode, ASourceFile);
    if not LObjectResult.Success then
    begin
      Result := LObjectResult;
      Exit;
    end;

    // Determine output executable name
    LBaseName := TPath.GetFileNameWithoutExtension(ASourceFile);
    LExecutableFile := TPath.Combine(FOutputDirectory, LBaseName + '.exe');
    LObjectFile := ChangeFileExt(LObjectResult.OutputFile, '.obj');

    // Link to executable
    if not LinkExecutable(LObjectFile, LExecutableFile) then
    begin
      Result.ErrorMessage := 'Linking failed';
      Exit;
    end;

    // Clean up intermediate files if requested
    if not FKeepIntermediateFiles then
    begin
      if TFile.Exists(LObjectFile) then
        TFile.Delete(LObjectFile);
      if TFile.Exists(ChangeFileExt(LObjectFile, '.ll')) then
        TFile.Delete(ChangeFileExt(LObjectFile, '.ll'));
    end;

    Result.Success := True;
    Result.OutputFile := LExecutableFile;

  except
    on E: Exception do
    begin
      HandleGeneralException(E);
      Result.ErrorMessage := E.Message;
    end;
  end;
end;

function TCPCompiler.CompileToObject(const ASourceCode: string; const ASourceFile: string): TCPCompilationResult;
var
  LLexer: TCPLexer;
  LParser: TCPParser;
  LProgram: TCPAstProgram;
  LCodeGen: TCPCodeGenerator;
  LBaseName: string;
  LOutputFile: string;
  LHasErrors: Boolean;
begin
  // Initialize result
  Result.Success := False;
  Result.ErrorMessage := '';
  Result.OutputFile := '';
  LHasErrors := False;

  // PHASE: Initialization
  SetCurrentPhase(cpInitialization, ASourceFile);
  DoProgress('Starting compilation of ' + ASourceFile, 0);
  
  // Reset warning/error counters for this compilation
  FCompilerConfig.Reset();
  FErrorHandler.ResetErrorCount();
  WriteMessageLn('Error counters reset for object compilation.', []);
  
  // Cache source lines for enhanced error reporting
  CacheSourceLines(ASourceCode);

  // Ensure output directory exists
  if not TDirectory.Exists(FOutputDirectory) then
  begin
    TDirectory.CreateDirectory(FOutputDirectory);
    WriteMessageLn('Created output directory: %s', [FOutputDirectory]);
  end;

  LLexer := nil;
  LParser := nil;
  LProgram := nil;
  LCodeGen := nil;

  try
    try
      // PHASE: Lexical Analysis
      SetCurrentPhase(cpLexicalAnalysis);
      DoProgress('Performing lexical analysis', 10);

      LLexer := TCPLexer.Create(ASourceCode, ASourceFile, FErrorHandler);
      WriteMessageLn('Lexer initialized successfully', []);
      
      // CRITICAL FIX: Sync error counts after lexical analysis
      // FCompilerConfig.SetErrorCount(FErrorHandler.GetErrorCount());
      // Temporary workaround: Manual sync
      while FCompilerConfig.ErrorCount < FErrorHandler.GetErrorCount() do
        FCompilerConfig.IncrementError();
      WriteMessageLn('Lexical analysis completed. ErrorHandler=%d, CompilerConfig=%d', [FErrorHandler.GetErrorCount(), FCompilerConfig.ErrorCount]);
      
      // Check error limits after lexical analysis
      if (FCompilerConfig.ErrorCount > 0) and FCompilerConfig.ShouldStopOnError() then
      begin
        WriteMessageLn('STOPPING compilation - error limit reached during lexical analysis (%d errors)', [FCompilerConfig.ErrorCount]);
        Result.ErrorMessage := Format('Compilation stopped: error limit reached (%d errors)', [FCompilerConfig.ErrorCount]);
        Exit;
      end;

      // PHASE: Syntax Analysis
      SetCurrentPhase(cpSyntaxAnalysis);
      DoProgress('Performing syntax analysis', 25);

      LParser := TCPParser.Create(LLexer, FErrorHandler);
      WriteMessageLn('Parser created, starting parse...', []);
      LProgram := LParser.Parse();
      
      // CRITICAL FIX: Sync error counts after parsing
      // FCompilerConfig.SetErrorCount(FErrorHandler.GetErrorCount());
      // Temporary workaround: Manual sync
      while FCompilerConfig.ErrorCount < FErrorHandler.GetErrorCount() do
        FCompilerConfig.IncrementError();
      WriteMessageLn('Parse completed. ErrorCount=%d, LProgram assigned=%s', [FCompilerConfig.ErrorCount, BoolToStr(Assigned(LProgram), True)]);

      // Check error limits after syntax analysis
      if (FCompilerConfig.ErrorCount > 0) and FCompilerConfig.ShouldStopOnError() then
      begin
        WriteMessageLn('STOPPING compilation - error limit reached during syntax analysis (%d errors)', [FCompilerConfig.ErrorCount]);
        Result.ErrorMessage := Format('Compilation stopped: error limit reached (%d errors)', [FCompilerConfig.ErrorCount]);
        Exit;
      end;

      // CRITICAL: Check for lexical AND syntax errors AFTER parsing
      if FCompilerConfig.ErrorCount > 0 then
      begin
        WriteMessageLn('STOPPING compilation due to %d errors', [FCompilerConfig.ErrorCount]);
        Result.ErrorMessage := Format('Compilation failed with %d errors during lexical/syntax analysis', [FCompilerConfig.ErrorCount]);
        Exit; // STOP HERE - No code generation!
      end;

      if not Assigned(LProgram) then
      begin
        Result.ErrorMessage := 'Parsing failed - no AST generated';
        Exit; // STOP HERE - No code generation!
      end
      else
      begin
        WriteMessageLn('Syntax analysis completed successfully', []);
      end;

      // PHASE: Semantic Analysis
      SetCurrentPhase(cpSemanticAnalysis);
      DoProgress('Performing semantic analysis', 50);

      // Comprehensive semantic analysis with enhanced warnings
      if Assigned(LProgram) then
      begin
        DoProgress('Analyzing declarations and usage', 55);
        CheckUnusedDeclarations(LProgram);
        
        DoProgress('Checking variable usage patterns', 60);
        CheckVariableUsage(LProgram);
        
        DoProgress('Checking for deprecated features', 62);
        CheckDeprecatedFeatures(LProgram);
        
        DoProgress('Analyzing performance implications', 64);
        CheckPerformanceIssues(LProgram);
      end;

      WriteMessageLn('Semantic analysis completed with %d warnings', [FCompilerConfig.WarningCount]);
      
      // CRITICAL FIX: Sync error counts after semantic analysis
      // FCompilerConfig.SetErrorCount(FErrorHandler.GetErrorCount());
      // Temporary workaround: Manual sync
      while FCompilerConfig.ErrorCount < FErrorHandler.GetErrorCount() do
        FCompilerConfig.IncrementError();
      WriteMessageLn('Semantic analysis error count synced. ErrorCount=%d', [FCompilerConfig.ErrorCount]);
      
      // Check error limits after semantic analysis
      if (FCompilerConfig.ErrorCount > 0) and FCompilerConfig.ShouldStopOnError() then
      begin
        WriteMessageLn('STOPPING compilation - error limit reached during semantic analysis (%d errors)', [FCompilerConfig.ErrorCount]);
        Result.ErrorMessage := Format('Compilation stopped: error limit reached (%d errors)', [FCompilerConfig.ErrorCount]);
        Exit;
      end;
      
      // CRITICAL: Check for semantic errors - STOP if any found
      if FCompilerConfig.ErrorCount > 0 then
      begin
        Result.ErrorMessage := Format('Compilation failed with %d semantic errors', [FCompilerConfig.ErrorCount]);
        Exit; // STOP HERE - No code generation!
      end;

      // PHASE: Code Generation - ONLY if NO errors exist
      SetCurrentPhase(cpCodeGeneration);
      DoProgress('Generating LLVM IR', 65);

      if Assigned(LProgram) and (FCompilerConfig.ErrorCount = 0) then
      begin
        LCodeGen := TCPCodeGenerator.Create(TPath.GetFileNameWithoutExtension(ASourceFile), FErrorHandler);
        WriteMessageLn('Code generator initialized', []);

        if not LCodeGen.GenerateFromAST(LProgram) then
        begin
          Result.ErrorMessage := 'Code generation failed';
          LHasErrors := True;
        end
        else
        begin
          WriteMessageLn('LLVM IR generation completed', []);
        end;
        
        // CRITICAL FIX: Sync error counts after code generation
        // FCompilerConfig.SetErrorCount(FErrorHandler.GetErrorCount());
        // Temporary workaround: Manual sync
        while FCompilerConfig.ErrorCount < FErrorHandler.GetErrorCount() do
          FCompilerConfig.IncrementError();
        WriteMessageLn('Code generation error count synced. ErrorCount=%d', [FCompilerConfig.ErrorCount]);
        
        // Check error limits after code generation
        if (FCompilerConfig.ErrorCount > 0) and FCompilerConfig.ShouldStopOnError() then
        begin
          WriteMessageLn('STOPPING compilation - error limit reached during code generation (%d errors)', [FCompilerConfig.ErrorCount]);
          Result.ErrorMessage := Format('Compilation stopped: error limit reached (%d errors)', [FCompilerConfig.ErrorCount]);
          LHasErrors := True;
        end;
      end;

      // PHASE: Optimization - ONLY if NO errors exist
      if Assigned(LCodeGen) and not LHasErrors and (FCompilerConfig.ErrorCount = 0) then
      begin
        SetCurrentPhase(cpOptimization);
        DoProgress('Performing optimization and verification', 80);

        if not LCodeGen.VerifyModule() then
        begin
          Result.ErrorMessage := 'LLVM module verification failed';
          LHasErrors := True;
        end
        else
        begin
          WriteMessageLn('Module verification completed successfully', []);
        end;
      end;

      // PHASE: Finalization - ONLY if NO errors exist
      if Assigned(LCodeGen) and not LHasErrors and (FCompilerConfig.ErrorCount = 0) then
      begin
        SetCurrentPhase(cpFinalization);
        DoProgress('Writing output files', 90);

        LBaseName := TPath.GetFileNameWithoutExtension(ASourceFile);
        LOutputFile := TPath.Combine(FOutputDirectory, LBaseName + '.ll');

        if not LCodeGen.WriteObjectFile(LOutputFile) then
        begin
          Result.ErrorMessage := 'Failed to write output file: ' + LOutputFile;
          LHasErrors := True;
        end
        else
        begin
          WriteMessageLn('Output file written: %s', [TPath.ChangeExtension(LOutputFile, 'obj')]);
          WriteMessageLn('Output file written: %s', [LOutputFile]);
          Result.OutputFile := LOutputFile;
          
          // CRITICAL FIX: Final error count sync before success determination
          // FCompilerConfig.SetErrorCount(FErrorHandler.GetErrorCount());
          // Temporary workaround: Manual sync
          while FCompilerConfig.ErrorCount < FErrorHandler.GetErrorCount() do
            FCompilerConfig.IncrementError();
          WriteMessageLn('Final error count check. ErrorCount=%d, LHasErrors=%s', [FCompilerConfig.ErrorCount, BoolToStr(LHasErrors, True)]);
          
          // CRITICAL: Only set Success = True if there are NO errors
          Result.Success := (FCompilerConfig.ErrorCount = 0) and not LHasErrors;
          
          if Result.Success then
            DoProgress('Compilation completed successfully', 100)
          else
            Result.ErrorMessage := Format('Compilation completed with %d errors', [FCompilerConfig.ErrorCount]);
        end;
      end;

    except
      on E: ECPCompilerError do
      begin
        HandleCompilerException(E);
        LHasErrors := True;
      end;
      on E: Exception do
      begin
        HandleGeneralException(E);
        LHasErrors := True;
      end;
    end;

  finally
    // Cleanup
    LProgram.Free();
    LParser.Free();
    LLexer.Free();
    LCodeGen.Free();

    if LHasErrors or (FCompilerConfig.ErrorCount > 0) then
    begin
      if Result.ErrorMessage = '' then
      begin
        Result.ErrorMessage := Format('Compilation completed with %d errors and %d warnings', 
          [FCompilerConfig.ErrorCount, FCompilerConfig.WarningCount]);
      end;
      WriteMessageLn('Compilation finished with %d errors and %d warnings', 
        [FCompilerConfig.ErrorCount, FCompilerConfig.WarningCount]);
    end
    else
    begin
      if FCompilerConfig.WarningCount > 0 then
        WriteMessageLn('Compilation finished successfully with %d warnings', [FCompilerConfig.WarningCount])
      else
        WriteMessageLn('Compilation finished successfully with no warnings', []);
    end;
  end;
end;

function TCPCompiler.LinkExecutable(const AObjectFile: string; const AExecutableFile: string): Boolean;
var
  LCommandLine: string;
begin
  Result := False;

  try
    // PHASE: Linking
    SetCurrentPhase(cpLinking);
    DoProgress('Starting linking phase');

    // Validate that linker exists
    if FLinkerConfig.LinkerPath = '' then
    begin
      DoErrorSimple(0, 0, 'Linker path not configured');
      Exit;
    end;

    if not TFile.Exists(AObjectFile) then
    begin
      DoErrorSimple(0, 0, 'Object file not found: ' + AObjectFile);
      Exit;
    end;

    WriteMessageLn('Linking %s to %s', [AObjectFile, AExecutableFile]);

    // Build command line
    LCommandLine := BuildLinkerCommandLine(AObjectFile, AExecutableFile);
    WriteMessageLn('Linker command: %s', [LCommandLine]);

    // Write debug info
    WriteDebugInfo(LCommandLine, AObjectFile);

    // Execute linker
    Result := ExecuteLinker(LCommandLine);

    if Result then
    begin
      WriteMessageLn('Linking completed successfully', []);
      DoProgress('Executable created: ' + AExecutableFile);
    end
    else
    begin
      DoErrorSimple(0, 0, 'Linker execution failed');
    end;

  except
    on E: Exception do
    begin
      HandleGeneralException(E);
      Result := False;
    end;
  end;
end;

function TCPCompiler.BuildLinkerCommandLine(const AObjectFile: string; const AExecutableFile: string): string;
var
  LCommand: TStringBuilder;
  LLibrary: string;
  LLibPath: string;

  function QuoteIfNeeded(const APath: string): string;
  begin
    if APath.Contains(' ') and not APath.StartsWith('"') then
      Result := '"' + APath + '"'
    else
      Result := APath;
  end;

begin
  LCommand := TStringBuilder.Create();
  try
    // Basic lld-link command - quote only if needed
    LCommand.Append(QuoteIfNeeded(FLinkerConfig.LinkerPath));
    LCommand.Append(' ');

    // Input object file
    LCommand.Append(QuoteIfNeeded(AObjectFile));
    LCommand.Append(' ');

    // Output executable
    LCommand.Append('/OUT:');
    LCommand.Append(QuoteIfNeeded(AExecutableFile));
    LCommand.Append(' ');

    // Subsystem specification
    if FLinkerConfig.Subsystem = stConsole then
      LCommand.Append('/SUBSYSTEM:CONSOLE ')
    else
      LCommand.Append('/SUBSYSTEM:WINDOWS ');

    // Add library paths
    for LLibPath in FLinkerConfig.LibraryPaths do
    begin
      LCommand.Append('/LIBPATH:');
      LCommand.Append(QuoteIfNeeded(LLibPath));
      LCommand.Append(' ');
    end;

    // Add libraries (no quotes needed for library names)
    for LLibrary in FLinkerConfig.Libraries do
    begin
      LCommand.Append(LLibrary);
      LCommand.Append(' ');
    end;

    // Additional linker flags
    LCommand.Append('/NOLOGO ');           // Suppress copyright banner
    LCommand.Append('/ENTRY:main ');       // Entry point
    LCommand.Append('/DYNAMICBASE ');      // ASLR support
    LCommand.Append('/NXCOMPAT ');         // DEP support
    LCommand.Append('/MACHINE:X64 ');      // Target architecture

    Result := Trim(LCommand.ToString());
  finally
    LCommand.Free();
  end;
end;

function TCPCompiler.ExecuteLinker(const ACommandLine: string): Boolean;
var
  LStartupInfo: TStartupInfo;
  LProcessInfo: TProcessInformation;
  LExitCode: DWORD;
  LLastError: DWORD;
  LWorkingDir: string;
  LLinkerExe: string;
  LArgs: string;
  LCommandLineCopy: string;
begin
  Result := False;

  try
    // Validate command line length
    if Length(ACommandLine) > 32767 then
    begin
      DoErrorSimple(0, 0, 'Command line too long: ' + IntToStr(Length(ACommandLine)) + ' characters');
      Exit;
    end;

    // Extract linker executable and arguments
    LCommandLineCopy := Trim(ACommandLine);
    if LCommandLineCopy.StartsWith('"') then
    begin
      // Quoted executable path
      LLinkerExe := Copy(LCommandLineCopy, 2, Pos('"', Copy(LCommandLineCopy, 2, MaxInt)) - 1);
      LArgs := Trim(Copy(LCommandLineCopy, Length(LLinkerExe) + 4, MaxInt));
    end
    else
    begin
      // Unquoted executable path
      LLinkerExe := Copy(LCommandLineCopy, 1, Pos(' ', LCommandLineCopy + ' ') - 1);
      LArgs := Trim(Copy(LCommandLineCopy, Length(LLinkerExe) + 1, MaxInt));
    end;

    // Validate linker executable exists
    if not TFile.Exists(LLinkerExe) then
    begin
      DoErrorSimple(0, 0, Format('Linker executable not found: %s', [LLinkerExe]));
      Exit;
    end;

    // Set working directory to output directory
    LWorkingDir := TPath.GetFullPath(FOutputDirectory);
    if not TDirectory.Exists(LWorkingDir) then
      TDirectory.CreateDirectory(LWorkingDir);

    // Initialize startup info
    FillChar(LStartupInfo, SizeOf(LStartupInfo), 0);
    LStartupInfo.cb := SizeOf(LStartupInfo);
    LStartupInfo.dwFlags := STARTF_USESHOWWINDOW;
    LStartupInfo.wShowWindow := SW_HIDE;

    // Create a mutable copy of the command line
    LCommandLineCopy := ACommandLine;
    UniqueString(LCommandLineCopy);

    // Create process
    if CreateProcess(
      PChar(LLinkerExe),            // Application name (helps with path resolution)
      PChar(LCommandLineCopy),      // Command line (mutable)
      nil,                          // Process security attributes
      nil,                          // Thread security attributes
      False,                        // Inherit handles
      0,                            // Creation flags
      nil,                          // Environment
      nil,                          // Current directory
      LStartupInfo,                 // Startup info
      LProcessInfo                  // Process info
    ) then
    begin
      try
        // Wait for process to complete
        WaitForSingleObject(LProcessInfo.hProcess, INFINITE);

        // Get exit code
        if GetExitCodeProcess(LProcessInfo.hProcess, LExitCode) then
        begin
          Result := (LExitCode = 0);
          if not Result then
          begin
            DoErrorSimple(0, 0, Format('Linker failed with exit code %d', [LExitCode]));
          end;
        end
        else
        begin
          LLastError := GetLastError();
          DoErrorSimple(0, 0, Format('Failed to get linker exit code. Error: %d', [LLastError]));
        end;

      finally
        CloseHandle(LProcessInfo.hThread);
        CloseHandle(LProcessInfo.hProcess);
      end;
    end
    else
    begin
      LLastError := GetLastError();
      case LLastError of
        2: DoErrorSimple(0, 0, Format('Linker not found: %s', [LLinkerExe]));
        3: DoErrorSimple(0, 0, Format('Path not found for linker: %s', [LLinkerExe]));
        5: DoErrorSimple(0, 0, 'Access denied when trying to execute linker');
        8: DoErrorSimple(0, 0, 'Not enough memory to execute linker');
        193: DoErrorSimple(0, 0, Format('Invalid executable: %s', [LLinkerExe]));
        else
          DoErrorSimple(0, 0, Format('Failed to execute linker. Error %d: %s', [LLastError, SysErrorMessage(LLastError)]));
      end;
    end;

  except
    on E: Exception do
    begin
      HandleGeneralException(E);
      Result := False;
    end;
  end;
end;

procedure TCPCompiler.WriteDebugInfo(const ACommandLine: string; const AObjectFile: string);
var
  LDebugFile: string;
  LDebugContent: TStringList;
begin
  try
    LDebugFile := TPath.Combine(FOutputDirectory, 'linker_debug.txt');
    LDebugContent := TStringList.Create();
    try
      LDebugContent.Add('CPascal Linker Debug Information');
      LDebugContent.Add('Generated: ' + DateTimeToStr(Now()));
      LDebugContent.Add('');
      LDebugContent.Add('Linker Path: ' + FLinkerConfig.LinkerPath);
      LDebugContent.Add('Object File: ' + AObjectFile);
      LDebugContent.Add('Object File Exists: ' + BoolToStr(TFile.Exists(AObjectFile), True));
      LDebugContent.Add('Subsystem: ' + GetEnumName(TypeInfo(TCPSubsystemType), Ord(FLinkerConfig.Subsystem)));
      LDebugContent.Add('');
      LDebugContent.Add('Libraries:');
      LDebugContent.AddStrings(FLinkerConfig.Libraries);
      LDebugContent.Add('');
      LDebugContent.Add('Library Paths:');
      LDebugContent.AddStrings(FLinkerConfig.LibraryPaths);
      LDebugContent.Add('');
      LDebugContent.Add('Command Line:');
      LDebugContent.Add(ACommandLine);
      LDebugContent.Add('');
      LDebugContent.Add('Command Line Length: ' + IntToStr(Length(ACommandLine)));

      LDebugContent.SaveToFile(LDebugFile);
    finally
      LDebugContent.Free();
    end;
  except
    // Ignore debug file write errors
  end;
end;

// Comprehensive semantic analysis warning methods
procedure TCPCompiler.CheckUnusedDeclarations(const AProgram: TCPAstProgram);
var
  LFunction: TCPAstExternalFunction;
  LVariable: TCPAstVariableDecl;
  LVarName: string;
  LLocation: TCPSourceLocation;
begin
  // Check for unused external functions (simplified - would need proper usage tracking)
  for LFunction in AProgram.Declarations.Functions do
  begin
    LLocation := CreateLocation(LFunction.Position.Line, LFunction.Position.Column, Length(LFunction.FunctionName));
    DoAnalysis(LLocation, 'FUNCTION_DECLARATION', Format('External function declared: %s', [LFunction.FunctionName]));
  end;
  
  // Check for unused variables (simplified - would need proper usage tracking)
  for LVariable in AProgram.Declarations.Variables do
  begin
    for LVarName in LVariable.VariableNames do
    begin
      LLocation := CreateLocation(LVariable.Position.Line, LVariable.Position.Column, Length(LVarName));
      DoAnalysis(LLocation, 'VARIABLE_DECLARATION', Format('Variable declared: %s : %s', [LVarName, LVariable.VariableType.TypeName]));
    end;
  end;
end;

procedure TCPCompiler.CheckVariableUsage(const AProgram: TCPAstProgram);
var
  LVariable: TCPAstVariableDecl;
  LVarName: string;
  LAssignedVars: TStringList;
  LUsedVars: TStringList;
  LUnusedVars: TStringList;
begin
  LAssignedVars := TStringList.Create();
  LUsedVars := TStringList.Create();
  LUnusedVars := TStringList.Create();
  try
    // Step 1: Collect all variable names
    for LVariable in AProgram.Declarations.Variables do
    begin
      for LVarName in LVariable.VariableNames do
        LUnusedVars.Add(LVarName);
    end;
    
    // Step 2: Analyze the main compound statement for assignments and uses
    AnalyzeStatementFlow(AProgram.MainStatement, LAssignedVars, LUsedVars, LUnusedVars);
    
    // Step 3: Report unused variables (optional - could be a separate check)
    for LVarName in LUnusedVars do
    begin
      // Find the variable declaration for position info
      for LVariable in AProgram.Declarations.Variables do
      begin
        if IndexText(LVarName, LVariable.VariableNames) >= 0 then
        begin
          DoWarning(CreateLocation(LVariable.Position.Line, LVariable.Position.Column, Length(LVarName)),
            wlHint, wcUnusedCode,
            Format('Variable %s is declared but never used', [LVarName]),
            'Consider removing unused variables');
          Break;
        end;
      end;
    end;
    
  finally
    LUnusedVars.Free();
    LUsedVars.Free();
    LAssignedVars.Free();
  end;
end;

procedure TCPCompiler.AnalyzeStatementFlow(const AStatement: TCPAstStatement; const AAssignedVars, AUsedVars, AUnusedVars: TStringList);
var
  LCompound: TCPAstCompoundStatement;
  LAssignment: TCPAstAssignmentStatement;
  LIfStmt: TCPAstIfStatement;
  LProcCall: TCPAstProcedureCall;
  LStmt: TCPAstStatement;
  LIndex: Integer;
begin
  if AStatement is TCPAstCompoundStatement then
  begin
    // Process statements in order - this preserves execution flow
    LCompound := TCPAstCompoundStatement(AStatement);
    for LStmt in LCompound.Statements do
      AnalyzeStatementFlow(LStmt, AAssignedVars, AUsedVars, AUnusedVars);
  end
  else if AStatement is TCPAstAssignmentStatement then
  begin
    // Variable is being assigned - check if it was used before this point
    LAssignment := TCPAstAssignmentStatement(AStatement);
    
    // First analyze the expression (right side) for variable uses
    AnalyzeExpressionUsage(LAssignment.Expression, AAssignedVars, AUsedVars);
    
    // Then record this variable as assigned
    if AAssignedVars.IndexOf(LAssignment.VariableName) = -1 then
      AAssignedVars.Add(LAssignment.VariableName);
    
    // Remove from unused list since it's now assigned
    LIndex := AUnusedVars.IndexOf(LAssignment.VariableName);
    if LIndex >= 0 then
      AUnusedVars.Delete(LIndex);
  end
  else if AStatement is TCPAstIfStatement then
  begin
    // Handle if statements - analyze condition and branches
    LIfStmt := TCPAstIfStatement(AStatement);
    
    // Analyze condition for variable uses
    AnalyzeExpressionUsage(LIfStmt.Condition, AAssignedVars, AUsedVars);
    
    // Analyze both branches (simplified - doesn't track per-branch assignment state)
    AnalyzeStatementFlow(LIfStmt.ThenStatement, AAssignedVars, AUsedVars, AUnusedVars);
    if Assigned(LIfStmt.ElseStatement) then
      AnalyzeStatementFlow(LIfStmt.ElseStatement, AAssignedVars, AUsedVars, AUnusedVars);
  end
  else if AStatement is TCPAstProcedureCall then
  begin
    // Analyze procedure call arguments for variable uses
    LProcCall := TCPAstProcedureCall(AStatement);
    AnalyzeProcedureCallUsage(LProcCall, AAssignedVars, AUsedVars);
  end;
end;

procedure TCPCompiler.AnalyzeExpressionUsage(const AExpression: TCPAstExpression; const AAssignedVars, AUsedVars: TStringList);
var
  LVarRef: TCPAstVariableReference;
  LIdentifier: TCPAstIdentifier;
  LComparison: TCPAstComparisonExpression;
begin
  if AExpression is TCPAstVariableReference then
  begin
    LVarRef := TCPAstVariableReference(AExpression);
    CheckVariableUse(LVarRef.VariableName, LVarRef.Position, AAssignedVars, AUsedVars);
  end
  else if AExpression is TCPAstIdentifier then
  begin
    LIdentifier := TCPAstIdentifier(AExpression);
    CheckVariableUse(LIdentifier.Name, LIdentifier.Position, AAssignedVars, AUsedVars);
  end
  else if AExpression is TCPAstComparisonExpression then
  begin
    LComparison := TCPAstComparisonExpression(AExpression);
    AnalyzeExpressionUsage(LComparison.Left, AAssignedVars, AUsedVars);
    AnalyzeExpressionUsage(LComparison.Right, AAssignedVars, AUsedVars);
  end;
  // Add other expression types as needed (literals don't reference variables)
end;

procedure TCPCompiler.CheckVariableUse(const AVariableName: string; const APosition: TCPSourceLocation; const AAssignedVars, AUsedVars: TStringList);
begin
  // Record that this variable is being used
  if AUsedVars.IndexOf(AVariableName) = -1 then
    AUsedVars.Add(AVariableName);
  
  // Check if it's being used before assignment
  if AAssignedVars.IndexOf(AVariableName) = -1 then
  begin
    // This is a REAL uninitialized use - warn about it
    DoWarning(APosition, wlWarning, wcGeneral,
      Format('Variable %s is used before being assigned', [AVariableName]),
      'Initialize the variable before using it');
  end;
end;

procedure TCPCompiler.AnalyzeProcedureCallUsage(const AProcCall: TCPAstProcedureCall; const AAssignedVars, AUsedVars: TStringList);
var
  LArgument: TCPAstExpression;
begin
  // Analyze all procedure call arguments for variable uses
  for LArgument in AProcCall.Arguments do
    AnalyzeExpressionUsage(LArgument, AAssignedVars, AUsedVars);
end;

procedure TCPCompiler.CheckFunctionParameterUsage(const AFunction: TCPAstExternalFunction);
var
  LParameter: TCPAstParameter;
  LLocation: TCPSourceLocation;
begin
  // Check for unused function parameters (simplified)
  for LParameter in AFunction.Parameters do
  begin
    LLocation := CreateLocation(LParameter.Position.Line, LParameter.Position.Column, Length(LParameter.Name));
    // In a real implementation, you'd track parameter usage
  end;
end;

procedure TCPCompiler.CheckDeprecatedFeatures(const AProgram: TCPAstProgram);
var
  LFunction: TCPAstExternalFunction;
  LLocation: TCPSourceLocation;
begin
  // Check for deprecated calling conventions or practices
  for LFunction in AProgram.Declarations.Functions do
  begin
    LLocation := CreateLocation(LFunction.Position.Line, LFunction.Position.Column);
    
    // Example: warn about certain calling conventions in specific contexts
    if (LFunction.CallingConvention = ccRegister) then
    begin
      DoWarning(LLocation, wlHint, wcDeprecated,
        'The register calling convention is deprecated in 64-bit targets',
        'Consider using cdecl for better compatibility');
    end;
  end;
end;

procedure TCPCompiler.CheckPerformanceIssues(const AProgram: TCPAstProgram);
var
  LFunction: TCPAstExternalFunction;
  LLocation: TCPSourceLocation;
begin
  // Check for potential performance issues
  for LFunction in AProgram.Declarations.Functions do
  begin
    LLocation := CreateLocation(LFunction.Position.Line, LFunction.Position.Column);
    
    // Report performance analysis
    DoAnalysis(LLocation, 'PERFORMANCE_CHECK', Format('Function %s has %d parameters, calling convention: %s', 
      [LFunction.FunctionName, Length(LFunction.Parameters), CPCallingConventionToString(LFunction.CallingConvention)]));
    
    // Example: suggest inline for small frequently called functions
    if Length(LFunction.Parameters) = 0 then
    begin
      DoWarning(LLocation, wlHint, wcPerformance,
        Format('Function %s might benefit from inlining', [LFunction.FunctionName]),
        'Consider marking small, frequently called functions as inline');
    end;
  end;
end;

end.
