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

unit CPascal.Compiler;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.IOUtils,
  CPascal.Lexer,
  CPascal.Parser,
  CPascal.AST,
  CPascal.IRGen,
  CPascal.LLVM,
  CPascal.Common,
  CPascal.Platform;

type
  { Main compiler class that orchestrates the entire compilation process. }
  TCPCompiler = class
  private
    FOnStartup: TCPCompilerCallback;
    FOnShutdown: TCPCompilerCallback;
    FOnProgress: TCPCompilerProgressCallback;
    FOnError: TCPCompilerErrorCallback;
    FOnWarning: TCPCompilerWarningCallback;
    procedure InitializeLLVMTargets();
    procedure DoStartup();
    procedure DoShutdown();
    procedure DoProgress(const AFileName: string; const APhase: TCPCompilerPhase; const AMessage: string);
  public
    constructor Create();
    function GetVersionString: string;
    function Compile(const ASourceFile, AOutputFile: string): Boolean;
    property OnStartup: TCPCompilerCallback read FOnStartup write FOnStartup;
    property OnShutdown: TCPCompilerCallback read FOnShutdown write FOnShutdown;
    property OnProgress: TCPCompilerProgressCallback read FOnProgress write FOnProgress;
    property OnError: TCPCompilerErrorCallback read FOnError write FOnError;
    property OnWarning: TCPCompilerWarningCallback read FOnWarning write FOnWarning;
  end;

implementation

uses
  CPascal.Semantic;

{ TCPCompiler }

constructor TCPCompiler.Create;
begin
  inherited Create();
  InitPlatform();
  InitializeLLVMTargets();
end;

procedure TCPCompiler.DoStartup();
begin
  if Assigned(FOnStartup) then
    FOnStartup();
end;

procedure TCPCompiler.DoShutdown();
begin
  if Assigned(FOnShutdown) then
    FOnShutdown();
end;

function TCPCompiler.GetVersionString: string;
begin
  if CPASCAL_VERSION_TAG <> '' then
    Result := Format('%d.%d.%d-%s', [CPASCAL_VERSION_MAJOR, CPASCAL_VERSION_MINOR, CPASCAL_VERSION_PATCH, CPASCAL_VERSION_TAG])
  else
    Result := Format('%d.%d.%d', [CPASCAL_VERSION_MAJOR, CPASCAL_VERSION_MINOR, CPASCAL_VERSION_PATCH]);
end;

procedure TCPCompiler.DoProgress(const AFileName: string; const APhase: TCPCompilerPhase; const AMessage: string);
begin
  if Assigned(FOnProgress) then
    FOnProgress(AFileName, APhase, AMessage);
end;

procedure TCPCompiler.InitializeLLVMTargets;
begin
  LLVMInitializeX86TargetInfo();
  LLVMInitializeX86Target();
  LLVMInitializeX86TargetMC();
  LLVMInitializeX86AsmParser();
  LLVMInitializeX86AsmPrinter();
end;

function TCPCompiler.Compile(const ASourceFile, AOutputFile: string): Boolean;
var
  LSource: string;
  LLexer: TCPLexer;
  LParser: TCPParser;
  LAST: TCPASTNode;
  LAnalyzer: TCPSemanticAnalyzer;
  LIRGenerator: TCPIRGenerator;
  LSymbolTable: TCPSymbolTable;
  LTargetTriple: PAnsiChar;
  LCPU: PAnsiChar;
  LTarget: LLVMTargetRef;
  LTargetMachine: LLVMTargetMachineRef;
  LErrorMessage: PAnsiChar;
  LCurrentPhase: TCPCompilerPhase;
  LWarning: TCPCompilerWarning;
begin
  Result := False;
  LErrorMessage := nil;
  LAST := nil;
  LCurrentPhase := cpFailure;
  LSymbolTable := nil;
  LIRGenerator := nil;

  DoStartup();

  try
    if not TFile.Exists(ASourceFile) then
    begin
      if Assigned(FOnError) then
        FOnError(ASourceFile, cpFailure, 0, 0, 'Source file not found: ' + ASourceFile);
      Exit;
    end;

    LSource := TFile.ReadAllText(ASourceFile);

    LCurrentPhase := cpParsing;
    DoProgress(ASourceFile, LCurrentPhase, 'Parsing...');
    LLexer := TCPLexer.Create(LSource);
    try
      LParser := TCPParser.Create(LLexer);
      try
        LAST := LParser.Parse();
      finally
        LParser.Free;
      end;
    finally
      LLexer.Free;
    end;

    LSymbolTable := TCPSymbolTable.Create();

    LCurrentPhase := cpSemanticAnalysis;
    DoProgress(ASourceFile, LCurrentPhase, 'Analyzing...');
    LAnalyzer := TCPSemanticAnalyzer.Create(LSymbolTable);
    try
      LAnalyzer.Check(LAST);
      if Assigned(FOnWarning) then
      begin
        for LWarning in LAnalyzer.Warnings do
        begin
          FOnWarning(ASourceFile, cpSemanticAnalysis, LWarning.Line, LWarning.Column, LWarning.Message);
        end;
      end;
    finally
      LAnalyzer.Free;
    end;

    LCurrentPhase := cpIRGeneration;
    DoProgress(ASourceFile, LCurrentPhase, 'Generating IR...');
    LIRGenerator := TCPIRGenerator.Create(LSymbolTable);
    LIRGenerator.Generate(LAST);

    LCurrentPhase := cpCodeGeneration;
    DoProgress(ASourceFile, LCurrentPhase, 'Emitting object file...');
    LTargetTriple := LLVMGetDefaultTargetTriple();
    try
      if LLVMGetTargetFromTriple(LTargetTriple, @LTarget, @LErrorMessage) <> 0 then
      begin
        if Assigned(FOnError) then FOnError(ASourceFile, LCurrentPhase, 0, 0, 'Error creating target: ' + string(LErrorMessage));
        LLVMDisposeMessage(LErrorMessage);
        Exit;
      end;
    finally
      LLVMDisposeMessage(LTargetTriple);
    end;

    LCPU := LLVMGetHostCPUName();
    try
      LTargetMachine := LLVMCreateTargetMachine(LTarget, LCPU, '', '', LLVMCodeGenLevelDefault, LLVMRelocDefault, LLVMCodeModelDefault);
      try
        if LLVMTargetMachineEmitToFile(LTargetMachine, LIRGenerator.Module, PAnsiChar(AnsiString(AOutputFile)), LLVMObjectFile, @LErrorMessage) <> 0 then
        begin
          if Assigned(FOnError) then FOnError(ASourceFile, LCurrentPhase, 0, 0, 'Error emitting object file: ' + string(LErrorMessage));
          LLVMDisposeMessage(LErrorMessage);
          Exit;
        end;
      finally
        LLVMDisposeTargetMachine(LTargetMachine);
      end;
    finally
       LLVMDisposeMessage(LCPU);
    end;

    DoProgress(ASourceFile, cpSuccess, 'Success! Output file: ' + AOutputFile);
    Result := True;

  except
    on E: ECPCompilerError do
    begin
      if Assigned(FOnError) then
        FOnError(ASourceFile, LCurrentPhase, E.Line, E.Column, E.Message);
      Result := False;
    end;
    on E: Exception do
    begin
      if Assigned(FOnError) then
        FOnError(ASourceFile, LCurrentPhase, 0, 0, E.Message);
      Result := False;
    end;
  end;

  if Assigned(LAST) then
    LAST.Free;

  if Assigned(LIRGenerator) then
    LIRGenerator.Free;
  if Assigned(LSymbolTable) then
    LSymbolTable.Free;

  DoShutdown();
end;

end.
