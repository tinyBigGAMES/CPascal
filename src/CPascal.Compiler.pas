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

unit CPascal.Compiler;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  CPascal.LLVM,
  CPascal.Exception,
  CPascal.Lexer,
  CPascal.Parser,
  CPascal.AST.CompilationUnit,
  CPascal.CodeGen,
  CPascal.CodeGen.JIT;

const
  CP_SOURCE_EXT = 'cpas';

type
  { Type alias to decouple public API from LLVM specifics }
  PCPModuleRef = LLVMModuleRef;

  { ICPCompilerProgress - Optional progress callback interface }
  ICPCompilerProgress = interface
    ['{B8F6D4C1-2E3F-4A8B-9C5D-7E1F8A2B3C4D}']
    procedure OnLexicalAnalysisStarted(const AFileName: string);
    procedure OnLexicalAnalysisCompleted(const ATokenCount: Integer);
    procedure OnSyntacticAnalysisStarted();
    procedure OnSyntacticAnalysisCompleted(const ANodeCount: Integer);
    procedure OnCodeGenerationStarted();
    procedure OnCodeGenerationCompleted();
    procedure OnJITCompilationStarted();
    procedure OnJITCompilationCompleted();
    procedure OnExecutionStarted();
    procedure OnExecutionCompleted(const AExitCode: Integer);
  end;

  { TCPCompilerOptions - Compilation configuration }
  TCPCompilerOptions = record
    FileName: string;              // Source file name for error reporting
    CompileOnly: Boolean;          // If true, only compile to LLVM module (don't execute)
    VerifyModule: Boolean;         // Verify LLVM module before compilation/execution
    ProgressCallback: ICPCompilerProgress; // Optional progress reporting
    
    class function Create(const AFileName: string = '<source>'): TCPCompilerOptions; static;
  end;

  { TCPCompiler - Main CPascal compilation orchestrator }
  TCPCompiler = class
  private
    FOptions: TCPCompilerOptions;
    FLastError: string;
    FLastExitCode: Integer;
    
    // Last compilation state
    FLastModule: PCPModuleRef;
    FLastContext: LLVMContextRef;  // Context for the last module
    FLastIR: string;
    FLastSource: string;
    FLastFileName: string;
    FIRGenerated: Boolean;
    FHasLastCompilation: Boolean;

    // Internal phase methods
    function DoLexicalAnalysis(const ASource: string): TCPLexer;
    function DoSyntacticAnalysis(const ALexer: TCPLexer): TCPCompilationUnitNode;
    function DoCodeGeneration(const AAST: TCPCompilationUnitNode): PCPModuleRef;
    function DoJITExecution(const AModule: PCPModuleRef): Integer;

    // Error handling and reporting
    procedure CompilerError(const APhase: string; const AMessage: string; const AArgs: array of const);
    procedure ReportProgress(AProgressProc: TProc);
    
    // Internal state management
    procedure ClearInternalState();
    function GenerateIRIfNeeded(): string;

  public
    constructor Create(); overload;
    constructor Create(const AOptions: TCPCompilerOptions); overload;
    destructor Destroy; override;

    // Main compilation interfaces
    function Compile(const ASource: string; const AFileName: string = '<source>'): PCPModuleRef;
    function CompileAndJIT(const ASource: string; const AFileName: string = '<source>'): Integer;
    function CompileFile(const AFilename: string; out ASource: string): PCPModuleRef;
    function CompileFileAndJIT(const AFilename: string): Integer;

    // Access last compilation results
    function GetLastIR(): string;
    function GetLastModule(): PCPModuleRef;
    function HasLastCompilation(): Boolean;
    procedure Reset();
    
    // JIT execution of compiled modules
    function JIT(const AModule: PCPModuleRef): Integer;
    
    // IR text extraction (legacy/convenience methods)
    function CompileToIR(const ASource: string; const AFileName: string = '<source>'): string;
    function GetModuleIR(const AModule: PCPModuleRef): string;

    // Individual phase access (for advanced usage)
    function LexicalAnalysis(const ASource: string; const AFileName: string = '<source>'): TCPLexer;
    function SyntacticAnalysis(const ALexer: TCPLexer): TCPCompilationUnitNode;
    function CodeGeneration(const AAST: TCPCompilationUnitNode): PCPModuleRef;
    function JITExecution(const AModule: PCPModuleRef): Integer;

    // Configuration and status
    procedure SetOptions(const AOptions: TCPCompilerOptions);

    property Options: TCPCompilerOptions read FOptions write SetOptions;
    property LastError: string read FLastError;
    property LastExitCode: Integer read FLastExitCode;
  end;

// Convenience functions for simple usage
function CPCompile(const ASource: string; const AFileName: string = '<source>'): PCPModuleRef;
function CPCompileAndJIT(const ASource: string; const AFileName: string = '<source>'): Integer;
function CPCompileToIR(const ASource: string; const AFileName: string = '<source>'): string;
function CPGetModuleIR(const AModule: PCPModuleRef): string;

implementation

{ Global convenience functions }

function CPCompile(const ASource: string; const AFileName: string = '<source>'): PCPModuleRef;
var
  LCompiler: TCPCompiler;
begin
  LCompiler := TCPCompiler.Create;
  try
    Result := LCompiler.Compile(ASource, AFileName);
  finally
    LCompiler.Free;
  end;
end;

function CPCompileAndJIT(const ASource: string; const AFileName: string = '<source>'): Integer;
var
  LCompiler: TCPCompiler;
begin
  LCompiler := TCPCompiler.Create;
  try
    Result := LCompiler.CompileAndJIT(ASource, AFileName);
  finally
    LCompiler.Free;
  end;
end;

function CPCompileToIR(const ASource: string; const AFileName: string = '<source>'): string;
var
  LCompiler: TCPCompiler;
begin
  LCompiler := TCPCompiler.Create;
  try
    Result := LCompiler.CompileToIR(ASource, AFileName);
  finally
    LCompiler.Free;
  end;
end;

function CPGetModuleIR(const AModule: PCPModuleRef): string;
var
  LCompiler: TCPCompiler;
begin
  LCompiler := TCPCompiler.Create;
  try
    Result := LCompiler.GetModuleIR(AModule);
  finally
    LCompiler.Free;
  end;
end;

{ TCPCompilerOptions }

class function TCPCompilerOptions.Create(const AFileName: string = '<source>'): TCPCompilerOptions;
begin
  Result.FileName := AFileName;
  Result.CompileOnly := False;
  Result.VerifyModule := True;
  Result.ProgressCallback := nil;
end;

{ TCPCompiler }

constructor TCPCompiler.Create();
begin
  inherited Create;
  FOptions := TCPCompilerOptions.Create;
  FLastError := '';
  FLastExitCode := 0;
  FLastContext := nil;
  ClearInternalState();
end;

constructor TCPCompiler.Create(const AOptions: TCPCompilerOptions);
begin
  inherited Create;
  FOptions := AOptions;
  FLastError := '';
  FLastExitCode := 0;
  FLastContext := nil;
  ClearInternalState();
end;

destructor TCPCompiler.Destroy;
begin
  ClearInternalState();
  inherited Destroy;
end;

procedure TCPCompiler.SetOptions(const AOptions: TCPCompilerOptions);
begin
  FOptions := AOptions;
end;

// Internal state management

procedure TCPCompiler.ClearInternalState();
begin
  // Dispose module and context together (module cannot outlive context)
  if FLastModule <> nil then
  begin
    LLVMDisposeModule(FLastModule);
    FLastModule := nil;
  end;
  
  if FLastContext <> nil then
  begin
    LLVMContextDispose(FLastContext);
    FLastContext := nil;
  end;
  
  FLastIR := '';
  FLastSource := '';
  FLastFileName := '';
  FIRGenerated := False;
  FHasLastCompilation := False;
end;

function TCPCompiler.GenerateIRIfNeeded(): string;
begin
  if not FIRGenerated then
  begin
    if FLastModule = nil then
      CompilerError('IR Generation', 'No module available for IR generation', []);
      
    FLastIR := GetModuleIR(FLastModule);
    FIRGenerated := True;
  end;
  
  Result := FLastIR;
end;

procedure TCPCompiler.CompilerError(const APhase: string; const AMessage: string; const AArgs: array of const);
begin
  FLastError := Format('[%s] %s', [APhase, Format(AMessage, AArgs)]);
  
  raise ECPException.Create(
    AMessage,
    AArgs,
    FOptions.FileName,
    0,  // Line unknown at compiler level
    0   // Column unknown at compiler level
  );
end;

procedure TCPCompiler.ReportProgress(AProgressProc: TProc);
begin
  if Assigned(FOptions.ProgressCallback) and Assigned(AProgressProc) then
  begin
    try
      AProgressProc();
    except
      // Ignore progress callback exceptions to avoid disrupting compilation
    end;
  end;
end;

function TCPCompiler.DoLexicalAnalysis(const ASource: string): TCPLexer;
var
  LTokenCount: Integer;
  LToken: TCPToken;
begin
  try
    ReportProgress(
      procedure
      begin
        FOptions.ProgressCallback.OnLexicalAnalysisStarted(FOptions.FileName);
      end
    );

    Result := TCPLexer.Create(ASource, FOptions.FileName);

    // Count tokens for progress reporting (if needed)
    if Assigned(FOptions.ProgressCallback) then
    begin
      LTokenCount := 0;
      repeat
        LToken := Result.PeekNextToken();
        if LToken.Kind <> tkEOF then
          Inc(LTokenCount);
      until LToken.Kind = tkEOF;
    end
    else
      LTokenCount := 0;

    ReportProgress(
      procedure
      begin
        FOptions.ProgressCallback.OnLexicalAnalysisCompleted(LTokenCount);
      end
    );

  except
    on E: ECPException do
    begin
      // Preserve original exception context from lexer
      FLastError := Format('[%s] %s', ['Lexical Analysis', E.Message]);
      
      raise ECPException.Create(
        E.Message,
        [],
        E.SourceFileName,
        E.LineNumber,
        E.ColumnNumber
      );
    end;
    on E: Exception do
    begin
      CompilerError('Lexical Analysis', 'Unexpected error: %s (%s)', [E.Message, E.ClassName]);
      Result := nil; // Never reached due to exception
    end;
  end;
end;

function TCPCompiler.DoSyntacticAnalysis(const ALexer: TCPLexer): TCPCompilationUnitNode;
var
  LParser: TCPParser;
  LNodeCount: Integer;
begin
  if ALexer = nil then
    CompilerError('Syntactic Analysis', 'Lexer is nil', []);

  LParser := nil;
  try
    try
      ReportProgress(
        procedure
        begin
          FOptions.ProgressCallback.OnSyntacticAnalysisStarted();
        end
      );

      LParser := TCPParser.Create(ALexer);
      Result := LParser.Parse();

      if Result = nil then
        CompilerError('Syntactic Analysis', 'Parser returned nil AST', []);

      // Count nodes for progress reporting (simple estimation)
      LNodeCount := 1; // At minimum we have the compilation unit
      if Result.Declarations <> nil then
        LNodeCount := LNodeCount + Result.Declarations.Count;

      ReportProgress(
        procedure
        begin
          FOptions.ProgressCallback.OnSyntacticAnalysisCompleted(LNodeCount);
        end
      );

    except
      on E: ECPException do
      begin
        // Preserve original source location from parser instead of overwriting it
        FLastError := Format('[%s] %s', ['Syntactic Analysis', E.Message]);
        
        raise ECPException.Create(
          E.Message,
          [],
          E.SourceFileName,
          E.LineNumber,
          E.ColumnNumber
        );
      end;
      on E: Exception do
      begin
        CompilerError('Syntactic Analysis', 'Unexpected error: %s (%s)', [E.Message, E.ClassName]);
        Result := nil; // Never reached due to exception
      end;
    end;
  finally
    LParser.Free;
  end;
end;

function TCPCompiler.DoCodeGeneration(const AAST: TCPCompilationUnitNode): PCPModuleRef;
var
  LCodeGen: TCPCodeGen;
  LContext: LLVMContextRef;
begin
  if AAST = nil then
    CompilerError('Code Generation', 'AST is nil', []);

  LCodeGen := nil;
  try
    try
      ReportProgress(
        procedure
        begin
          FOptions.ProgressCallback.OnCodeGenerationStarted();
        end
      );

      LCodeGen := TCPCodeGen.Create;
      
      // Generate the AST and verify
      LCodeGen.GenerateFromAST(AAST);
      
      // Transfer ownership of both context and module to compiler
      Result := LCodeGen.TransferOwnership(LContext);
      
      // Store context for proper disposal later
      FLastContext := LContext;

      if Result = nil then
        CompilerError('Code Generation', 'Code generator returned nil module', []);

      ReportProgress(
        procedure
        begin
          FOptions.ProgressCallback.OnCodeGenerationCompleted();
        end
      );

    except
      on E: ECPException do
      begin
        // Preserve original exception context from code generator
        FLastError := Format('[%s] %s', ['Code Generation', E.Message]);
        
        raise ECPException.Create(
          E.Message,
          [],
          E.SourceFileName,
          E.LineNumber,
          E.ColumnNumber
        );
      end;
      on E: Exception do
      begin
        CompilerError('Code Generation', 'Unexpected error: %s (%s)', [E.Message, E.ClassName]);
        Result := nil; // Never reached due to exception
      end;
    end;
  finally
    LCodeGen.Free;
  end;
end;

function TCPCompiler.DoJITExecution(const AModule: PCPModuleRef): Integer;
var
  LExitCode: Integer;
begin

  if AModule = nil then
    CompilerError('JIT Execution', 'LLVM module is nil', []);

  try
    ReportProgress(
      procedure
      begin
        FOptions.ProgressCallback.OnJITCompilationStarted();
      end
    );

    ReportProgress(
      procedure
      begin
        FOptions.ProgressCallback.OnJITCompilationCompleted();
      end
    );

    ReportProgress(
      procedure
      begin
        FOptions.ProgressCallback.OnExecutionStarted();
      end
    );

    // Execute the module using the JIT
    LExitCode := TCPJIT.IRFromModule(AModule);

    // Clear our reference if this is our internal module since JIT took ownership
    if AModule = FLastModule then
    begin
      FLastModule := nil;  // JIT now owns it, we don't
      // Also clear the context since the module is gone
      if FLastContext <> nil then
      begin
        // Note: Don't dispose context here - JIT may still need it
        // Just clear our reference to avoid double-disposal
        FLastContext := nil;
      end;
    end;
    
    Result := LExitCode;
    FLastExitCode := LExitCode;

    ReportProgress(
      procedure
      begin
        FOptions.ProgressCallback.OnExecutionCompleted(LExitCode);
      end
    );
    

  except
    on E: ECPException do
    begin
      // Preserve original exception context from JIT
      FLastError := Format('[%s] %s', ['JIT Execution', E.Message]);
      
      raise ECPException.Create(
        E.Message,
        [],
        E.SourceFileName,
        E.LineNumber,
        E.ColumnNumber
      );
    end;
    on E: Exception do
    begin
      CompilerError('JIT Execution', 'Unexpected error: %s (%s)', [E.Message, E.ClassName]);
      Result := -1; // Never reached due to exception
    end;
  end;

end;

function TCPCompiler.Compile(const ASource: string; const AFileName: string = '<source>'): PCPModuleRef;
var
  LLexer: TCPLexer;
  LAST: TCPCompilationUnitNode;
  LSavedFileName: string;
begin
  // Clear previous compilation state
  ClearInternalState();
  
  // Store current compilation info
  FLastSource := ASource;
  FLastFileName := AFileName;
  
  // Update filename for this compilation
  LSavedFileName := FOptions.FileName;
  FOptions.FileName := AFileName;

  LLexer := nil;
  LAST := nil;
  try
    FLastError := '';

    // Validate input
    if Trim(ASource) = '' then
      CompilerError('Input Validation', 'Source code is empty', []);

    // Phase 1: Lexical Analysis
    LLexer := DoLexicalAnalysis(ASource);

    // Phase 2: Syntactic Analysis
    LAST := DoSyntacticAnalysis(LLexer);

    // Phase 3: Code Generation
    Result := DoCodeGeneration(LAST);
    
    // Store result for stateful access
    FLastModule := Result;
    FHasLastCompilation := True;
    FIRGenerated := False;  // Mark IR as needing generation

  finally
    // Restore original filename
    FOptions.FileName := LSavedFileName;
    
    // Cleanup intermediate objects
    LAST.Free;
    LLexer.Free;
  end;
end;

function TCPCompiler.CompileAndJIT(const ASource: string; const AFileName: string = '<source>'): Integer;
var
  LModule: PCPModuleRef;
begin
  // First compile the program
  LModule := Compile(ASource, AFileName);
  
  try
    // Then execute it
    Result := DoJITExecution(LModule);
  finally
    // LLVM module is owned by JIT after execution, no need to dispose
  end;
end;

function TCPCompiler.CompileFile(const AFilename: string; out ASource: string): PCPModuleRef;
var
  LFilename: string;
  LSource: string;
begin
  LFilename := TPath.ChangeExtension(AFilename, CP_SOURCE_EXT);
  LSource := TFile.ReadAllText(LFilename, TEncoding.UTF8);
  ASource := LSource;
  Result := Compile(LSource, LFilename);
end;

function TCPCompiler.CompileFileAndJIT(const AFilename: string): Integer;
var
  LFilename: string;
  LSource: string;
begin
  LFilename := TPath.ChangeExtension(AFilename, CP_SOURCE_EXT);
  LSource := TFile.ReadAllText(LFilename, TEncoding.UTF8);
  Result := CPCompileAndJIT(LSource, LFilename);
end;

function TCPCompiler.JIT(const AModule: PCPModuleRef): Integer;
begin
  FLastError := '';
  Result := DoJITExecution(AModule);
end;

// Individual phase access methods (for advanced usage)

function TCPCompiler.LexicalAnalysis(const ASource: string; const AFileName: string = '<source>'): TCPLexer;
var
  LSavedFileName: string;
begin
  LSavedFileName := FOptions.FileName;
  FOptions.FileName := AFileName;
  try
    FLastError := '';
    
    if Trim(ASource) = '' then
      CompilerError('Input Validation', 'Source code is empty', []);
      
    Result := DoLexicalAnalysis(ASource);
  finally
    FOptions.FileName := LSavedFileName;
  end;
end;

function TCPCompiler.SyntacticAnalysis(const ALexer: TCPLexer): TCPCompilationUnitNode;
begin
  FLastError := '';
  Result := DoSyntacticAnalysis(ALexer);
end;

function TCPCompiler.CodeGeneration(const AAST: TCPCompilationUnitNode): PCPModuleRef;
begin
  FLastError := '';
  Result := DoCodeGeneration(AAST);
end;

function TCPCompiler.JITExecution(const AModule: PCPModuleRef): Integer;
begin
  FLastError := '';
  Result := DoJITExecution(AModule);
end;

// Public methods for accessing last compilation state

function TCPCompiler.GetLastIR(): string;
begin
  if not FHasLastCompilation then
    CompilerError('State Access', 'No compilation available - call Compile() first', []);
    
  Result := GenerateIRIfNeeded();
end;

function TCPCompiler.GetLastModule(): PCPModuleRef;
begin
  if not FHasLastCompilation then
    CompilerError('State Access', 'No compilation available - call Compile() first', []);
    
  Result := FLastModule;
end;

function TCPCompiler.HasLastCompilation(): Boolean;
begin
  Result := FHasLastCompilation;
end;

procedure TCPCompiler.Reset();
begin
  ClearInternalState();
end;

// IR text extraction methods

function TCPCompiler.GetModuleIR(const AModule: PCPModuleRef): string;
var
  LIRString: PUTF8Char;
begin
  if AModule = nil then
    CompilerError('IR Generation', 'LLVM module is nil', []);

  try
    // Convert LLVM module to string representation
    LIRString := LLVMPrintModuleToString(AModule);
    if LIRString = nil then
      CompilerError('IR Generation', 'Failed to convert module to string', []);

    try
      Result := string(UTF8String(LIRString));
    finally
      // Always dispose the string returned by LLVM
      LLVMDisposeMessage(LIRString);
    end;

  except
    on E: ECPException do
      raise;
    on E: Exception do
      CompilerError('IR Generation', 'Unexpected error: %s (%s)', [E.Message, E.ClassName]);
  end;
end;

function TCPCompiler.CompileToIR(const ASource: string; const AFileName: string = '<source>'): string;
var
  LModule: PCPModuleRef;
begin
  // Compile the source to LLVM module
  LModule := Compile(ASource, AFileName);
  try
    // Extract IR text from module
    Result := GetModuleIR(LModule);
  finally
    // Clean up the module
    if LModule <> nil then
      LLVMDisposeModule(LModule);
  end;
end;

end.
