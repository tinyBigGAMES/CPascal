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

unit CPascal.CodeGen.JIT;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  CPascal.LLVM,
  CPascal.Exception;

type
  { TCPJIT }
  TCPJIT = class
  private
    FContext: LLVMContextRef;
    FThreadSafeContext: LLVMOrcThreadSafeContextRef;
    FLLJIT: LLVMOrcLLJITRef;
    FIsInitialized: Boolean;
    FLastError: string;

    procedure Cleanup();
    procedure CPVerifyModule(AModule: LLVMModuleRef);
    function LoadIRFromMemory(const ALLVMIR: string): Boolean;
    function LoadIRFromFile(const AFilename: string): Boolean;
    function ExecuteMain(): Integer;
    function CreateLLJIT(): Boolean;
    function AddModuleToJIT(AModule: LLVMModuleRef): Boolean;

  public
    constructor Create;
    destructor Destroy; override;

    function ExecIRFromString(const ALLVMIR: string): Integer;
    function ExecIRFromFile(const AFilename: string): Integer;
    function ExecIRFromModule(const AModule: LLVMModuleRef): Integer;

    property LastError: string read FLastError;
    property IsInitialized: Boolean read FIsInitialized;

    class function IRFromString(const ALLVMIR: string): Integer;
    class function IRFromFile(const AFilename: string): Integer;
    class function IRFromModule(const AModule: LLVMModuleRef): Integer;
  end;

function CPJITIRFromString(const ALLVMIR: string): Integer;
function CPJITIRFromFile(const AFilename: string): Integer;
function CPJITIRFromModule(const AModule: LLVMModuleRef): Integer;

implementation

function CPJITIRFromString(const ALLVMIR: string): Integer;
begin
  Result := TCPJIT.IRFromString(ALLVMIR);
end;

function CPJITIRFromFile(const AFilename: string): Integer;
begin
  Result := TCPJIT.IRFromFile(AFilename);
end;

function CPJITIRFromModule(const AModule: LLVMModuleRef): Integer;
begin
  Result := TCPJIT.IRFromModule(AModule);
end;

{ TCPIRJIT }
constructor TCPJIT.Create;
begin
  inherited Create;
  FContext := nil;
  FThreadSafeContext := nil;
  FLLJIT := nil;
  FIsInitialized := False;
  FLastError := '';

  // Create per-instance LLVM context
  FContext := LLVMContextCreate();
  if FContext = nil then
  begin
    FLastError := 'Failed to create LLVM context';
    Exit;
  end;

  // Create thread-safe context wrapper for ORC
  FThreadSafeContext := LLVMOrcCreateNewThreadSafeContext();
  if FThreadSafeContext = nil then
  begin
    FLastError := 'Failed to create thread-safe context';
    Exit;
  end;

  // Create LLJIT instance
  if not CreateLLJIT() then
    Exit;

  FIsInitialized := True;
end;

destructor TCPJIT.Destroy;
begin
  Cleanup();
  inherited Destroy;
end;

procedure TCPJIT.Cleanup();
begin
  if FLLJIT <> nil then
  begin
    LLVMOrcDisposeLLJIT(FLLJIT);
    FLLJIT := nil;
  end;

  if FThreadSafeContext <> nil then
  begin
    LLVMOrcDisposeThreadSafeContext(FThreadSafeContext);
    FThreadSafeContext := nil;
  end;

  if FContext <> nil then
  begin
    LLVMContextDispose(FContext);
    FContext := nil;
  end;

  FIsInitialized := False;
end;

procedure TCPJIT.CPVerifyModule(AModule: LLVMModuleRef);
var
  LErrorMessage: PUTF8Char;
  LDiagnostic: string;
begin
  if AModule = nil then
    raise ECPException.Create(
      'Cannot verify nil module',
      [],
      'Module parameter is nil',
      'Ensure module is properly loaded before verification'
    );

  LErrorMessage := nil;
  if LLVMVerifyModule(AModule, LLVMReturnStatusAction, @LErrorMessage) <> 0 then
  begin
    if LErrorMessage <> nil then
    begin
      LDiagnostic := string(UTF8String(LErrorMessage));
      LLVMDisposeMessage(LErrorMessage);
    end
    else
      LDiagnostic := 'Module verification failed with unknown error';
      
    raise ECPException.Create(
      'LLVM module verification failed',
      [],
      'Module contains invalid LLVM IR: ' + LDiagnostic,
      'Check LLVM IR syntax, ensure all references are valid, and verify function signatures match their calls'
    );
  end;
end;

function TCPJIT.CreateLLJIT(): Boolean;
var
  LError: LLVMErrorRef;
  LBuilder: LLVMOrcLLJITBuilderRef;
  LTargetMachineBuilder: LLVMOrcJITTargetMachineBuilderRef;
begin
  Result := False;
  FLastError := '';

  try
    // Create LLJIT builder for configuration
    LBuilder := LLVMOrcCreateLLJITBuilder();
    if LBuilder = nil then
    begin
      FLastError := 'Failed to create LLJIT builder';
      Exit;
    end;

    // Create target machine builder for native target
    LTargetMachineBuilder := LLVMOrcJITTargetMachineBuilderCreateFromTargetMachine(
      LLVMCreateTargetMachine(
        LLVMGetFirstTarget(), // Use first available target for simplicity
        LLVMGetDefaultTargetTriple(),
        LLVMGetHostCPUName(),
        LLVMGetHostCPUFeatures(),
        LLVMCodeGenLevelDefault,
        LLVMRelocDefault,
        LLVMCodeModelDefault
      )
    );

    if LTargetMachineBuilder = nil then
    begin
      FLastError := 'Failed to create target machine builder';
      LLVMOrcDisposeLLJITBuilder(LBuilder);
      Exit;
    end;

    // Set target machine builder in LLJIT builder
    LLVMOrcLLJITBuilderSetJITTargetMachineBuilder(LBuilder, LTargetMachineBuilder);

    // Create LLJIT instance
    LError := LLVMOrcCreateLLJIT(@FLLJIT, LBuilder);
    if LError <> nil then
    begin
      FLastError := 'Failed to create LLJIT: ' + string(UTF8String(LLVMGetErrorMessage(LError)));
      LLVMConsumeError(LError);
      Exit;
    end;

    Result := True;

  except
    on E: Exception do
    begin
      FLastError := 'Exception creating LLJIT: ' + E.Message;
      Result := False;
    end;
  end;
end;

function TCPJIT.AddModuleToJIT(AModule: LLVMModuleRef): Boolean;
var
  LError: LLVMErrorRef;
  LThreadSafeModule: LLVMOrcThreadSafeModuleRef;
  LMainJITDylib: LLVMOrcJITDylibRef;
begin
  Result := False;
  FLastError := '';

  if FLLJIT = nil then
  begin
    FLastError := 'LLJIT not initialized';
    Exit;
  end;

  if AModule = nil then
  begin
    FLastError := 'Module is nil';
    Exit;
  end;

  try
    // Wrap module in thread-safe wrapper
    LThreadSafeModule := LLVMOrcCreateNewThreadSafeModule(AModule, FThreadSafeContext);
    if LThreadSafeModule = nil then
    begin
      FLastError := 'Failed to create thread-safe module';
      Exit;
    end;

    // Get main JITDylib (the default dylib for symbol resolution)
    LMainJITDylib := LLVMOrcLLJITGetMainJITDylib(FLLJIT);
    if LMainJITDylib = nil then
    begin
      FLastError := 'Failed to get main JITDylib';
      LLVMOrcDisposeThreadSafeModule(LThreadSafeModule);
      Exit;
    end;

    // Add module to LLJIT (this triggers compilation)
    LError := LLVMOrcLLJITAddLLVMIRModule(FLLJIT, LMainJITDylib, LThreadSafeModule);
    if LError <> nil then
    begin
      FLastError := 'Failed to add module to LLJIT: ' + string(UTF8String(LLVMGetErrorMessage(LError)));
      LLVMConsumeError(LError);
      Exit;
    end;

    // ThreadSafeModule is now owned by LLJIT
    Result := True;

  except
    on E: Exception do
    begin
      FLastError := 'Exception adding module to JIT: ' + E.Message;
      Result := False;
    end;
  end;
end;

function TCPJIT.LoadIRFromMemory(const ALLVMIR: string): Boolean;
var
  LMemoryBuffer: LLVMMemoryBufferRef;
  LErrorMessage: PUTF8Char;
  LIRBytes: UTF8String;
  LModule: LLVMModuleRef;
  LDiagnostic: string;
begin

  FLastError := '';

  if not FIsInitialized then
    raise ECPException.Create(
      'Cannot load IR: LLVM JIT not initialized',
      [],
      'LLVM context or LLJIT instance failed to initialize properly',
      'Check LLVM installation and ensure proper initialization in constructor'
    );

  if Trim(ALLVMIR) = '' then
    raise ECPException.Create(
      'Cannot load empty LLVM IR',
      [],
      'LLVM IR string is empty or contains only whitespace',
      'Provide valid LLVM IR code for compilation and execution'
    );

  try
    // Convert string to UTF8 for LLVM
    LIRBytes := UTF8String(ALLVMIR);

    // Create memory buffer from string
    LMemoryBuffer := LLVMCreateMemoryBufferWithMemoryRange(
      PUTF8Char(LIRBytes),
      Length(LIRBytes),
      'cpascal_ir',
      0  // Don't copy - we manage the memory
    );

    if LMemoryBuffer = nil then
      raise ECPException.Create(
        'Failed to create LLVM memory buffer',
        [],
        'LLVM could not create memory buffer from IR string',
        'Check that LLVM IR string is valid UTF-8 and not corrupted'
      );

    // Parse IR into module
    LErrorMessage := nil;
    if LLVMParseIRInContext(FContext, LMemoryBuffer, @LModule, @LErrorMessage) <> 0 then
    begin
      if LErrorMessage <> nil then
      begin
        LDiagnostic := string(UTF8String(LErrorMessage));
        LLVMDisposeMessage(LErrorMessage);
      end
      else
        LDiagnostic := 'Unknown LLVM parsing error';
        
      raise ECPException.Create(
        'Failed to parse LLVM IR',
        [],
        'LLVM IR parsing failed: ' + LDiagnostic,
        'Check LLVM IR syntax, ensure proper module structure, and verify all instructions are valid'
      );
    end;

    // Verify module before adding to JIT
    CPVerifyModule(LModule);

    // Add module to JIT
    if not AddModuleToJIT(LModule) then
    begin
      LLVMDisposeModule(LModule);
      // AddModuleToJIT already sets FLastError, convert to exception
      raise ECPException.Create(
        'Failed to add module to JIT',
        [],
        'Module compilation failed: ' + FLastError,
        'Check module dependencies and ensure all symbols are available'
      );
    end;

    // Module is now owned by LLJIT
    Result := True;

  except
    on ECPException do
      raise; // Re-raise ECPExceptions as-is
    on E: Exception do
      raise ECPException.Create(
        'Unexpected error loading IR from memory',
        [],
        'Exception during IR loading: ' + E.Message + ' (' + E.ClassName + ')',
        'This may indicate a system-level issue or LLVM library problem'
      );
  end;
end;

function TCPJIT.LoadIRFromFile(const AFilename: string): Boolean;
var
  LMemoryBuffer: LLVMMemoryBufferRef;
  LErrorMessage: PUTF8Char;
  LFilenameUTF8: UTF8String;
  LModule: LLVMModuleRef;
  LDiagnostic: string;
begin

  FLastError := '';

  if not FIsInitialized then
    raise ECPException.Create(
      'Cannot load IR: LLVM JIT not initialized',
      [],
      'LLVM context or LLJIT instance failed to initialize properly',
      'Check LLVM installation and ensure proper initialization in constructor'
    );

  if Trim(AFilename) = '' then
    raise ECPException.Create(
      'Cannot load IR from empty filename',
      [],
      'Filename parameter is empty or contains only whitespace',
      'Provide a valid file path to an LLVM IR file'
    );

  if not TFile.Exists(AFilename) then
    raise ECPException.Create(
      'LLVM IR file not found: %s',
      [AFilename],
      'File does not exist or is not accessible: ' + AFilename,
      'Check that the file path is correct and the file exists with proper read permissions'
    );

  try
    LFilenameUTF8 := UTF8String(AFilename);

    // Create memory buffer from file
    LErrorMessage := nil;
    if LLVMCreateMemoryBufferWithContentsOfFile(
      PUTF8Char(LFilenameUTF8),
      @LMemoryBuffer,
      @LErrorMessage) <> 0 then
    begin
      if LErrorMessage <> nil then
      begin
        LDiagnostic := string(UTF8String(LErrorMessage));
        LLVMDisposeMessage(LErrorMessage);
      end
      else
        LDiagnostic := 'Unknown file reading error';
        
      raise ECPException.Create(
        'Failed to read LLVM IR file: %s',
        [AFilename],
        'File reading failed: ' + LDiagnostic,
        'Check file permissions, ensure file is not corrupted, and verify it contains valid text'
      );
    end;

    // Parse IR into module
    LErrorMessage := nil;
    if LLVMParseIRInContext(FContext, LMemoryBuffer, @LModule, @LErrorMessage) <> 0 then
    begin
      if LErrorMessage <> nil then
      begin
        LDiagnostic := string(UTF8String(LErrorMessage));
        LLVMDisposeMessage(LErrorMessage);
      end
      else
        LDiagnostic := 'Unknown LLVM parsing error';
        
      raise ECPException.Create(
        'Failed to parse LLVM IR from file: %s',
        [AFilename],
        'LLVM IR parsing failed: ' + LDiagnostic,
        'Check LLVM IR syntax in file, ensure proper module structure, and verify all instructions are valid'
      );
    end;

    // Verify module before adding to JIT
    CPVerifyModule(LModule);

    // Add module to JIT
    if not AddModuleToJIT(LModule) then
    begin
      LLVMDisposeModule(LModule);
      // AddModuleToJIT already sets FLastError, convert to exception
      raise ECPException.Create(
        'Failed to add module to JIT from file: %s',
        [AFilename],
        'Module compilation failed: ' + FLastError,
        'Check module dependencies and ensure all symbols are available'
      );
    end;

    // Module is now owned by LLJIT
    Result := True;

  except
    on ECPException do
      raise; // Re-raise ECPExceptions as-is
    on E: Exception do
      raise ECPException.Create(
        'Unexpected error loading IR from file: %s',
        [AFilename],
        'Exception during file loading: ' + E.Message + ' (' + E.ClassName + ')',
        'This may indicate a system-level issue or LLVM library problem'
      );
  end;
end;

function TCPJIT.ExecuteMain(): Integer;
var
  LError: LLVMErrorRef;
  LMainSymbol: LLVMOrcExecutorAddress;
  LMainFunction: function(): Integer; cdecl;
  LDiagnostic: string;
begin

  FLastError := '';

  if FLLJIT = nil then
    raise ECPException.Create(
      'Cannot execute: LLJIT not initialized',
      [],
      'JIT compilation engine was not properly initialized',
      'Ensure module was successfully loaded and compiled before attempting execution'
    );

  try
    // Look up the main function symbol
    LError := LLVMOrcLLJITLookup(FLLJIT, @LMainSymbol, 'main');
    if LError <> nil then
    begin
      LDiagnostic := string(UTF8String(LLVMGetErrorMessage(LError)));
      LLVMConsumeError(LError);
      
      raise ECPException.Create(
        'Failed to lookup main function symbol',
        [],
        'Symbol lookup failed: ' + LDiagnostic,
        'Ensure the module contains a main function and was successfully compiled'
      );
    end;

    if LMainSymbol = 0 then
      raise ECPException.Create(
        'main function symbol has null address',
        [],
        'Symbol lookup succeeded but returned null address for main function',
        'This indicates a JIT compilation issue - check that main function was properly compiled'
      );

    // Cast symbol address to function pointer and call it
    // Note: This assumes main() takes no arguments and returns int
    LMainFunction := Pointer(LMainSymbol);
    Result := LMainFunction();

  except
    on ECPException do
      raise; // Re-raise ECPExceptions as-is
    on E: Exception do
      raise ECPException.Create(
        'Unexpected error during execution',
        [],
        'Exception during main function execution: ' + E.Message + ' (' + E.ClassName + ')',
        'This may indicate a runtime error in the compiled code or system-level issue'
      );
  end;
end;

function TCPJIT.ExecIRFromString(const ALLVMIR: string): Integer;
begin
  Result := -1;

  if not LoadIRFromMemory(ALLVMIR) then
    Exit;

  Result := ExecuteMain();
end;

function TCPJIT.ExecIRFromFile(const AFilename: string): Integer;
begin
  Result := -1;

  if not LoadIRFromFile(AFilename) then
    Exit;

  Result := ExecuteMain();
end;

// Convenience class methods with enhanced error handling
class function TCPJIT.IRFromString(const ALLVMIR: string): Integer;
var
  LJit: TCPJIT;
begin
  LJit := TCPJIT.Create;
  try
    // Check initialization before proceeding
    if not LJit.IsInitialized then
      raise ECPException.Create(
        'LLVM JIT initialization failed',
        [],
        'Failed to initialize LLVM context, thread-safe context, or LLJIT instance',
        'Check LLVM installation and library dependencies'
      );

    Result := LJit.ExecIRFromString(ALLVMIR);

  finally
    LJit.Free;
  end;
end;

class function TCPJIT.IRFromFile(const AFilename: string): Integer;
var
  LJit: TCPJIT;
begin
  LJit := TCPJIT.Create;
  try
    // Check initialization before proceeding
    if not LJit.IsInitialized then
      raise ECPException.Create(
        'LLVM JIT initialization failed',
        [],
        'Failed to initialize LLVM context, thread-safe context, or LLJIT instance',
        'Check LLVM installation and library dependencies'
      );

    Result := LJit.ExecIRFromFile(AFilename);

  finally
    LJit.Free;
  end;
end;

function TCPJIT.ExecIRFromModule(const AModule: LLVMModuleRef): Integer;
begin
  FLastError := '';

  if not FIsInitialized then
    raise ECPException.Create(
      'Cannot execute: LLVM JIT not initialized',
      [],
      'LLVM context or LLJIT instance failed to initialize properly',
      'Check LLVM installation and ensure proper initialization in constructor'
    );

  if AModule = nil then
    raise ECPException.Create(
      'Cannot execute: Module is nil',
      [],
      'LLVM module parameter is nil',
      'Ensure module was properly generated before execution'
    );

  // Verify the module before adding to JIT
  CPVerifyModule(AModule);

  // Add module to JIT
  if not AddModuleToJIT(AModule) then
    raise ECPException.Create(
      'Failed to add module to JIT',
      [],
      'Module compilation failed: ' + FLastError,
      'Check module dependencies and ensure all symbols are available'
    );

  // Execute main function
  Result := ExecuteMain();
end;

class function TCPJIT.IRFromModule(const AModule: LLVMModuleRef): Integer;
var
  LJit: TCPJIT;
begin
  LJit := TCPJIT.Create;
  try
    // Check initialization before proceeding
    if not LJit.IsInitialized then
      raise ECPException.Create(
        'LLVM JIT initialization failed',
        [],
        'Failed to initialize LLVM context, thread-safe context, or LLJIT instance',
        'Check LLVM installation and library dependencies'
      );

    Result := LJit.ExecIRFromModule(AModule);

  finally
    LJit.Free;
  end;
end;

end.
