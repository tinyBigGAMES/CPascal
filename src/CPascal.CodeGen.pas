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

unit CPascal.CodeGen;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  CPascal.LLVM,
  CPascal.Exception,
  CPascal.Lexer,
  CPascal.Parser,
  CPascal.AST,
  Cpascal.AST.Types,
  CPascal.AST.CompilationUnit,
  CPascal.AST.Expressions,
  CPascal.AST.Directives,
  CPascal.AST.Statements,
  CPascal.AST.Functions,
  CPascal.Platform,
  CPascal.CodeGen.SymbolTable;

type
  { TCPLLVMTypeMapper - Maps CPascal types to LLVM types }
  TCPLLVMTypeMapper = class
  private
    FContext: LLVMContextRef;
    FTypeCache: TDictionary<string, LLVMTypeRef>;
    FPointerElementTypes: TDictionary<string, LLVMTypeRef>; // Track what each pointer type points to

  public
    constructor Create(const AContext: LLVMContextRef);
    destructor Destroy; override;

    function MapCPascalTypeToLLVM(const ATypeNode: TCPTypeNode): LLVMTypeRef;
    function GetCPascalBasicType(const ATypeName: string): LLVMTypeRef;
    function MapTypeNameToLLVM(const ATypeName: string): LLVMTypeRef;
    procedure RegisterTypeAlias(const ATypeName: string; const ALLVMType: LLVMTypeRef);
    procedure RegisterPointerType(const APointerTypeName: string; const AElementType: LLVMTypeRef);
    function GetPointerElementType(const APointerTypeName: string): LLVMTypeRef;

    property Context: LLVMContextRef read FContext;
  end;

  { TCPCallingConventionMapper - Maps CPascal calling conventions to LLVM }
  TCPCallingConventionMapper = class
  public
    class function MapCallingConvention(const ACallingConvention: TCPCallingConvention): LLVMCallConv;
  end;

  { TCPCodeGen - Main LLVM IR code generator for CPascal AST }
  TCPCodeGen = class
  private
    FContext: LLVMContextRef;
    FModule: LLVMModuleRef;
    FBuilder: LLVMBuilderRef;
    FTypeMapper: TCPLLVMTypeMapper;
    FCallingConventionMapper: TCPCallingConventionMapper;
    FSymbolTable: TCPSymbolTable;
    FIsInitialized: Boolean;
    FOwnsContext: Boolean;  // Track if we own the context
    FOwnsModule: Boolean;   // Track if we own the module
    FStringCounter: Integer; // Counter for unique string global names
    FFunctionParameters: TDictionary<string, TArray<Boolean>>; // Maps function name to var/out parameter flags

    // Initialization and cleanup
    procedure InitializeLLVMComponents(const AUnitName: string);
    procedure CleanupLLVMComponents();
    procedure VerifyModule();
    
    // LLVM diagnostics capture helpers
    function CPCaptureLLVMModuleIR(): string;
    function CPCaptureLLVMCurrentFunction(): string;
    function CPCaptureLLVMBuilderContext(): string;

    // Unit-specific generation
    function GenerateProgram(const AProgram: TCPProgramNode): LLVMModuleRef;
    function GenerateLibrary(const ALibrary: TCPLibraryNode): LLVMModuleRef;
    function GenerateModule(const AModule: TCPModuleNode): LLVMModuleRef;

  public
    constructor Create;
    destructor Destroy; override;

    // Main generation method
    function GenerateFromAST(const AUnit: TCPCompilationUnitNode): LLVMModuleRef;
    
    // Transfer ownership of both context and module (must be called together)
    function TransferOwnership(out AContext: LLVMContextRef): LLVMModuleRef;
    
    // Get next unique string identifier
    function GetNextStringId(): Integer;
    
    // Function parameter metadata storage
    procedure CPStoreFunctionParameterInfo(const AFunctionName: string; const AParameterInfo: TArray<Boolean>);
    function CPGetFunctionParameterInfo(const AFunctionName: string): TArray<Boolean>;
    
    procedure CodeGenError(const AMessage: string; const AArgs: array of const; const ALocation: TCPSourceLocation; const ALLVMAPICall: string = ''; const ALLVMValueInfo: string = '');

    property Context: LLVMContextRef read FContext;
    property Module_: LLVMModuleRef read FModule;
    property Builder: LLVMBuilderRef read FBuilder;
    property TypeMapper: TCPLLVMTypeMapper read FTypeMapper;
    property CallingConventionMapper: TCPCallingConventionMapper read FCallingConventionMapper;
    property SymbolTable: TCPSymbolTable read FSymbolTable;
    property IsInitialized: Boolean read FIsInitialized;
  end;

// Utility functions
function CPGenerateModuleFromAST(const AUnit: TCPCompilationUnitNode): LLVMModuleRef;

implementation

uses
  CPascal.CodeGen.CompilationUnit,
  CPascal.CodeGen.Declarations,
  CPascal.CodeGen.Functions,
  CPascal.CodeGen.Statements,
  CPascal.CodeGen.Expressions,
  CPascal.CodeGen.Types,
  CPascal.CodeGen.Directives;

// Utility function
function CPGenerateModuleFromAST(const AUnit: TCPCompilationUnitNode): LLVMModuleRef;
var
  LCodeGen: TCPCodeGen;
begin
  LCodeGen := TCPCodeGen.Create;
  try
    Result := LCodeGen.GenerateFromAST(AUnit);
  finally
    LCodeGen.Free;
  end;
end;

{ TCPLLVMTypeMapper }

constructor TCPLLVMTypeMapper.Create(const AContext: LLVMContextRef);
var
  LTargetData: LLVMTargetDataRef;
begin
  inherited Create;
  FContext := AContext;
  FTypeCache := TDictionary<string, LLVMTypeRef>.Create;
  FPointerElementTypes := TDictionary<string, LLVMTypeRef>.Create;

  // Create target data for platform-specific types, then dispose it
  LTargetData := LLVMCreateTargetData(PAnsiChar(UTF8String(CPGetLLVMPlatformDataLayout())));
  
  // Pre-populate cache with standard CPascal types
  FTypeCache.Add('Int8', LLVMInt8TypeInContext(FContext));
  FTypeCache.Add('UInt8', LLVMInt8TypeInContext(FContext));
  FTypeCache.Add('Int16', LLVMInt16TypeInContext(FContext));
  FTypeCache.Add('UInt16', LLVMInt16TypeInContext(FContext));
  FTypeCache.Add('Int32', LLVMInt32TypeInContext(FContext));
  FTypeCache.Add('UInt32', LLVMInt32TypeInContext(FContext));
  FTypeCache.Add('Int64', LLVMInt64TypeInContext(FContext));
  FTypeCache.Add('UInt64', LLVMInt64TypeInContext(FContext));
  FTypeCache.Add('Single', LLVMFloatTypeInContext(FContext));
  FTypeCache.Add('Double', LLVMDoubleTypeInContext(FContext));
  FTypeCache.Add('Boolean', LLVMInt1TypeInContext(FContext));
  FTypeCache.Add('Char', LLVMInt8TypeInContext(FContext));
  FTypeCache.Add('PChar', LLVMPointerType(LLVMInt8TypeInContext(FContext), 0));
  FTypeCache.Add('Pointer', LLVMPointerType(LLVMInt8TypeInContext(FContext), 0));
  FTypeCache.Add('NativeInt', LLVMIntPtrTypeInContext(FContext, LTargetData));
  FTypeCache.Add('NativeUInt', LLVMIntPtrTypeInContext(FContext, LTargetData));
  
  // Dispose target data after use to prevent leak
  LLVMDisposeTargetData(LTargetData);
end;

destructor TCPLLVMTypeMapper.Destroy;
begin
  FPointerElementTypes.Free;
  FTypeCache.Free;
  inherited Destroy;
end;

function TCPLLVMTypeMapper.MapCPascalTypeToLLVM(const ATypeNode: TCPTypeNode): LLVMTypeRef;
var
  LBaseType: LLVMTypeRef;
begin
  if ATypeNode = nil then
    raise ECPException.Create(
      'Cannot map nil type node to LLVM type',
      [],
      'Type node parameter is nil',
      'Ensure type node is properly created before mapping'
    );

  // Get base type from cache
  LBaseType := GetCPascalBasicType(ATypeNode.TypeName);

  // Handle pointer types
  if ATypeNode.IsPointer then
    Result := LLVMPointerType(LBaseType, 0)
  else
    Result := LBaseType;
end;

function TCPLLVMTypeMapper.GetCPascalBasicType(const ATypeName: string): LLVMTypeRef;
begin
  if not FTypeCache.TryGetValue(ATypeName, Result) then
    raise ECPException.Create(
      'Unknown CPascal type: %s',
      [ATypeName],
      'Type name not found in CPascal type system',
      'Use valid CPascal types: Int32, PChar, Boolean, etc. See CPASCAL-BNF.md for complete list'
    );
end;

function TCPLLVMTypeMapper.MapTypeNameToLLVM(const ATypeName: string): LLVMTypeRef;
begin
  // First check if it's a registered type (including aliases)
  if not FTypeCache.TryGetValue(ATypeName, Result) then
  begin
    // Not found - could be an unknown type
    Result := nil;
  end;
end;

procedure TCPLLVMTypeMapper.RegisterTypeAlias(const ATypeName: string; const ALLVMType: LLVMTypeRef);
begin
  if ALLVMType = nil then
    raise ECPException.Create(
      'Cannot register nil type for alias: %s',
      [ATypeName],
      'LLVM type is nil',
      'Ensure LLVM type is properly created before registering alias'
    );
    
  // Add or update the type mapping
  FTypeCache.AddOrSetValue(ATypeName, ALLVMType);
end;

procedure TCPLLVMTypeMapper.RegisterPointerType(const APointerTypeName: string; const AElementType: LLVMTypeRef);
begin
  if AElementType = nil then
    raise ECPException.Create(
      'Cannot register nil element type for pointer: %s',
      [APointerTypeName],
      'Element type is nil',
      'Ensure element type is properly created before registering pointer'
    );
    
  // Store what this pointer type points to
  FPointerElementTypes.AddOrSetValue(APointerTypeName, AElementType);
end;

function TCPLLVMTypeMapper.GetPointerElementType(const APointerTypeName: string): LLVMTypeRef;
begin
  if not FPointerElementTypes.TryGetValue(APointerTypeName, Result) then
    Result := nil;
end;

{ TCPCallingConventionMapper }

class function TCPCallingConventionMapper.MapCallingConvention(const ACallingConvention: TCPCallingConvention): LLVMCallConv;
begin
  case ACallingConvention of
    ccDefault, ccCdecl: Result := LLVMCCallConv;
    ccStdcall: Result := LLVMX86StdcallCallConv;
    ccFastcall: Result := LLVMX86FastcallCallConv;
    ccRegister: Result := LLVMX86FastcallCallConv; // Map register to fastcall
  else
    Result := LLVMCCallConv; // Default to C calling convention
  end;
end;

{ TCPCodeGen }

constructor TCPCodeGen.Create;
begin
  inherited Create;
  FContext := nil;
  FModule := nil;
  FBuilder := nil;
  FTypeMapper := nil;
  FCallingConventionMapper := nil;
  FSymbolTable := nil;
  FIsInitialized := False;
  FOwnsContext := False;
  FOwnsModule := False;
  FStringCounter := 0; // Initialize string counter
  FFunctionParameters := TDictionary<string, TArray<Boolean>>.Create;
end;

destructor TCPCodeGen.Destroy;
begin
  CleanupLLVMComponents();
  inherited Destroy;
end;

procedure TCPCodeGen.InitializeLLVMComponents(const AUnitName: string);
begin
  // Validate unit name
  if Trim(AUnitName) = '' then
    raise ECPException.Create(
      'Unit name cannot be empty',
      [],
      'Empty unit name provided to InitializeLLVMComponents',
      'Provide a valid unit name for LLVM module creation'
    );

  // Create LLVM context
  FContext := LLVMContextCreate();
  FOwnsContext := True;  // We created it, we own it
  if FContext = nil then
    raise ECPException.Create(
      'Failed to create LLVM context',
      [],
      'LLVM context creation returned nil',
      'Check LLVM installation and library dependencies'
    );

  // Create LLVM module
  FModule := LLVMModuleCreateWithNameInContext(PAnsiChar(UTF8String(AUnitName)), FContext);
  FOwnsModule := True;  // We created it, we own it
  if FModule = nil then
  begin
    if FOwnsContext then
    begin
      LLVMContextDispose(FContext);
      FOwnsContext := False;
    end;
    FContext := nil;
    raise ECPException.Create(
      'Failed to create LLVM module: %s',
      [AUnitName],
      'LLVM module creation returned nil',
      'Check unit name validity and LLVM initialization'
    );
  end;

  // Set target triple and data layout from platform detection
  LLVMSetTarget(FModule,  CPAsUTF8(CPGetLLVMPlatformTargetTriple()));
  LLVMSetDataLayout(FModule, CPAsUtf8(CPGetLLVMPlatformDataLayout()));

  // Create instruction builder
  FBuilder := LLVMCreateBuilderInContext(FContext);
  if FBuilder = nil then
  begin
    if FOwnsModule then
    begin
      LLVMDisposeModule(FModule);
      FOwnsModule := False;
    end;
    if FOwnsContext then
    begin
      LLVMContextDispose(FContext);
      FOwnsContext := False;
    end;
    FModule := nil;
    FContext := nil;
    raise ECPException.Create(
      'Failed to create LLVM instruction builder',
      [],
      'LLVM builder creation returned nil',
      'Check LLVM context validity and library status'
    );
  end;

  // Create helper components
  FTypeMapper := TCPLLVMTypeMapper.Create(FContext);
  if FTypeMapper = nil then
  begin
    if FBuilder <> nil then
    begin
      LLVMDisposeBuilder(FBuilder);
      FBuilder := nil;
    end;
    if FOwnsModule then
    begin
      LLVMDisposeModule(FModule);
      FOwnsModule := False;
    end;
    if FOwnsContext then
    begin
      LLVMContextDispose(FContext);
      FOwnsContext := False;
    end;
    FModule := nil;
    FContext := nil;
    raise ECPException.Create(
      'Failed to create LLVM type mapper',
      [],
      'Type mapper creation failed',
      'Check memory availability and LLVM context validity'
    );
  end;
  
  FCallingConventionMapper := TCPCallingConventionMapper.Create;
  if FCallingConventionMapper = nil then
  begin
    FTypeMapper.Free;
    FTypeMapper := nil;
    if FBuilder <> nil then
    begin
      LLVMDisposeBuilder(FBuilder);
      FBuilder := nil;
    end;
    if FOwnsModule then
    begin
      LLVMDisposeModule(FModule);
      FOwnsModule := False;
    end;
    if FOwnsContext then
    begin
      LLVMContextDispose(FContext);
      FOwnsContext := False;
    end;
    FModule := nil;
    FContext := nil;
    raise ECPException.Create(
      'Failed to create calling convention mapper',
      [],
      'Calling convention mapper creation failed',
      'Check memory availability'
    );
  end;
  
  FSymbolTable := TCPSymbolTable.Create;
  if FSymbolTable = nil then
  begin
    FCallingConventionMapper.Free;
    FCallingConventionMapper := nil;
    FTypeMapper.Free;
    FTypeMapper := nil;
    if FBuilder <> nil then
    begin
      LLVMDisposeBuilder(FBuilder);
      FBuilder := nil;
    end;
    if FOwnsModule then
    begin
      LLVMDisposeModule(FModule);
      FOwnsModule := False;
    end;
    if FOwnsContext then
    begin
      LLVMContextDispose(FContext);
      FOwnsContext := False;
    end;
    FModule := nil;
    FContext := nil;
    raise ECPException.Create(
      'Failed to create symbol table',
      [],
      'Symbol table creation failed',
      'Check memory availability'
    );
  end;

  FIsInitialized := True;
end;

procedure TCPCodeGen.CleanupLLVMComponents();
begin
  // Clean up helper components (always ours)
  FFunctionParameters.Free;
  FFunctionParameters := nil;

  FSymbolTable.Free;
  FSymbolTable := nil;

  FCallingConventionMapper.Free;
  FCallingConventionMapper := nil;

  FTypeMapper.Free;
  FTypeMapper := nil;

  // Clean up LLVM builder (always ours if exists)
  if FBuilder <> nil then
  begin
    LLVMDisposeBuilder(FBuilder);
    FBuilder := nil;
  end;

  // Only dispose module if we own it
  if FOwnsModule and (FModule <> nil) then
  begin
    LLVMDisposeModule(FModule);
    FOwnsModule := False;
  end;
  FModule := nil;

  // Only dispose context if we own it
  if FOwnsContext and (FContext <> nil) then
  begin
    LLVMContextDispose(FContext);
    FOwnsContext := False;
  end;
  FContext := nil;

  FIsInitialized := False;
end;

procedure TCPCodeGen.VerifyModule();
var
  LErrorMessage: PUTF8Char;
  LDiagnostic: string;
begin
  if FModule = nil then
    raise ECPException.Create(
      'Cannot verify nil module',
      [],
      'Module is nil during verification',
      'Ensure module was properly initialized before verification'
    );

  if not FIsInitialized then
    raise ECPException.Create(
      'Cannot verify module - CodeGen not initialized',
      [],
      'CodeGen initialization incomplete',
      'Call InitializeLLVMComponents before verification'
    );

  LErrorMessage := nil;
  if LLVMVerifyModule(FModule, LLVMReturnStatusAction, @LErrorMessage) <> 0 then
  begin
    if LErrorMessage <> nil then
    begin
      LDiagnostic := string(UTF8String(LErrorMessage));
      LLVMDisposeMessage(LErrorMessage);
    end
    else
      LDiagnostic := 'Module verification failed with unknown error';

    raise ECPException.Create(
      'LLVM module verification failed: %s',
      [LDiagnostic],
      'Generated LLVM IR is invalid',
      'Check code generation logic and ensure all LLVM instructions are properly formed'
    );
  end;
end;

function TCPCodeGen.GenerateFromAST(const AUnit: TCPCompilationUnitNode): LLVMModuleRef;
begin
  if AUnit = nil then
    raise ECPException.Create(
      'Cannot generate code from nil AST unit',
      [],
      'Compilation unit parameter is nil',
      'Ensure AST was properly parsed before code generation'
    );

  if FIsInitialized then
    raise ECPException.Create(
      'CodeGen already initialized - cannot reuse instance',
      [],
      'GenerateFromAST called on already initialized CodeGen',
      'Create a new TCPCodeGen instance for each compilation'
    );

  if Trim(AUnit.GetUnitName) = '' then
    raise ECPException.Create(
      'Unit name cannot be empty',
      [],
      'AST unit has empty name',
      'Ensure AST unit has valid name for module creation'
    );

  InitializeLLVMComponents(AUnit.GetUnitName);

  try
    // Verify initialization succeeded
    if not FIsInitialized then
      raise ECPException.Create(
        'LLVM components initialization failed',
        [],
        'InitializeLLVMComponents did not complete successfully',
        'Check LLVM installation and system resources'
      );
      
    if FContext = nil then
      raise ECPException.Create(
        'LLVM context is nil after initialization',
        [],
        'Context creation failed silently',
        'Check LLVM library compatibility'
      );
      
    if FModule = nil then
      raise ECPException.Create(
        'LLVM module is nil after initialization',
        [],
        'Module creation failed silently',
        'Check LLVM library compatibility'
      );
      
    if FBuilder = nil then
      raise ECPException.Create(
        'LLVM builder is nil after initialization',
        [],
        'Builder creation failed silently',
        'Check LLVM library compatibility'
      );

    // Generate code based on compilation unit type
    case AUnit.UnitKind of
      ckProgram: Result := GenerateProgram(TCPProgramNode(AUnit));
      ckLibrary: Result := GenerateLibrary(TCPLibraryNode(AUnit));
      ckModule: Result := GenerateModule(TCPModuleNode(AUnit));
    else
      raise ECPException.Create(
        'Unknown compilation unit kind: %d',
        [Ord(AUnit.UnitKind)],
        'Compilation unit has invalid kind: ' + CPCompilationUnitKindToString(AUnit.UnitKind),
        'Ensure AST was properly parsed with valid unit type'
      );
    end;

    if Result = nil then
      raise ECPException.Create(
        'Code generation returned nil module',
        [],
        'Module generation failed for unit: ' + AUnit.GetUnitName,
        'Check code generation implementation for unit type: ' + CPCompilationUnitKindToString(AUnit.UnitKind)
      );

    // Verify generated module before returning
    VerifyModule();

    // NOTE: Ownership transfer happens via TransferOwnership method
    // Module and context remain owned by this instance until explicitly transferred

  except
    on E: Exception do
    begin
      CleanupLLVMComponents();
      raise;
    end;
  end;
end;

function TCPCodeGen.TransferOwnership(out AContext: LLVMContextRef): LLVMModuleRef;
begin
  if not FIsInitialized then
    raise ECPException.Create(
      'Cannot transfer ownership - CodeGen not initialized',
      [],
      'TransferOwnership called before initialization',
      'Call GenerateFromAST first to initialize CodeGen'
    );

  if not FOwnsModule or not FOwnsContext then
    raise ECPException.Create(
      'Cannot transfer ownership - already transferred',
      [],
      'Ownership already transferred to another caller',
      'Each CodeGen instance can only transfer ownership once'
    );

  // Transfer ownership of both context and module
  AContext := FContext;
  Result := FModule;
  
  // Clear our ownership - caller now responsible for disposal
  FOwnsContext := False;
  FOwnsModule := False;
end;

function TCPCodeGen.GetNextStringId(): Integer;
begin
  Inc(FStringCounter);
  Result := FStringCounter;
end;

procedure TCPCodeGen.CPStoreFunctionParameterInfo(const AFunctionName: string; const AParameterInfo: TArray<Boolean>);
begin
  if FFunctionParameters = nil then
    raise ECPException.Create(
      'Function parameter storage not initialized',
      [],
      'CPStoreFunctionParameterInfo called with nil parameter dictionary',
      'Ensure CodeGen is properly initialized before storing parameter info'
    );
    
  FFunctionParameters.AddOrSetValue(AFunctionName, AParameterInfo);
end;

function TCPCodeGen.CPGetFunctionParameterInfo(const AFunctionName: string): TArray<Boolean>;
begin
  if FFunctionParameters = nil then
  begin
    SetLength(Result, 0);
    Exit;
  end;
    
  if not FFunctionParameters.TryGetValue(AFunctionName, Result) then
    SetLength(Result, 0); // Return empty array if function not found
end;

function TCPCodeGen.GenerateProgram(const AProgram: TCPProgramNode): LLVMModuleRef;
begin
  Result := CPascal.CodeGen.CompilationUnit.GenerateProgram(Self, AProgram);
  // Note: Module ownership transfer happens after verification in GenerateFromAST
end;

function TCPCodeGen.GenerateLibrary(const ALibrary: TCPLibraryNode): LLVMModuleRef;
begin
  Result := CPascal.CodeGen.CompilationUnit.GenerateLibrary(Self, ALibrary);
  // Note: Module ownership transfer happens after verification in GenerateFromAST
end;

function TCPCodeGen.GenerateModule(const AModule: TCPModuleNode): LLVMModuleRef;
begin
  Result := CPascal.CodeGen.CompilationUnit.GenerateModule(Self, AModule);
  // Note: Module ownership transfer happens after verification in GenerateFromAST
end;

function TCPCodeGen.CPCaptureLLVMModuleIR(): string;
var
  LModuleString: PUTF8Char;
begin
  Result := '';
  if FModule <> nil then
  begin
    try
      LModuleString := LLVMPrintModuleToString(FModule);
      if LModuleString <> nil then
      begin
        Result := string(UTF8String(LModuleString));
        LLVMDisposeMessage(LModuleString);
      end;
    except
      on E: Exception do
        Result := '[LLVM IR capture failed: ' + E.Message + ']';
    end;
  end
  else
    Result := '[No LLVM module available]';
end;

function TCPCodeGen.CPCaptureLLVMCurrentFunction(): string;
var
  LCurrentBlock: LLVMBasicBlockRef;
  LCurrentFunction: LLVMValueRef;
  LFunctionName: PUTF8Char;
begin
  Result := '';
  if FBuilder <> nil then
  begin
    try
      LCurrentBlock := LLVMGetInsertBlock(FBuilder);
      if LCurrentBlock <> nil then
      begin
        LCurrentFunction := LLVMGetBasicBlockParent(LCurrentBlock);
        if LCurrentFunction <> nil then
        begin
          LFunctionName := LLVMGetValueName(LCurrentFunction);
          if LFunctionName <> nil then
            Result := string(UTF8String(LFunctionName))
          else
            Result := '[Anonymous function]';
        end
        else
          Result := '[No parent function]';
      end
      else
        Result := '[No current basic block]';
    except
      on E: Exception do
        Result := '[Function capture failed: ' + E.Message + ']';
    end;
  end
  else
    Result := '[No LLVM builder available]';
end;

function TCPCodeGen.CPCaptureLLVMBuilderContext(): string;
var
  LCurrentBlock: LLVMBasicBlockRef;
  LBlockName: PUTF8Char;
begin
  Result := '';
  if FBuilder <> nil then
  begin
    try
      LCurrentBlock := LLVMGetInsertBlock(FBuilder);
      if LCurrentBlock <> nil then
      begin
        LBlockName := LLVMGetValueName(LCurrentBlock);
        if LBlockName <> nil then
          Result := 'Block: ' + string(UTF8String(LBlockName))
        else
          Result := 'Block: [Anonymous]';
      end
      else
        Result := 'No current basic block';
    except
      on E: Exception do
        Result := '[Builder context capture failed: ' + E.Message + ']';
    end;
  end
  else
    Result := 'No LLVM builder available';
end;

procedure TCPCodeGen.CodeGenError(const AMessage: string; const AArgs: array of const; const ALocation: TCPSourceLocation; const ALLVMAPICall: string = ''; const ALLVMValueInfo: string = '');
var
  LLLVMModuleIR: string;
  LLLVMFunctionName: string;
  LLLVMContextInfo: string;
  LLLVMAPICall: string;
begin
  // Capture LLVM diagnostics safely
  try
    LLLVMModuleIR := CPCaptureLLVMModuleIR();
    LLLVMFunctionName := CPCaptureLLVMCurrentFunction();
    LLLVMContextInfo := CPCaptureLLVMBuilderContext();
    LLLVMAPICall := ALLVMAPICall;
    if LLLVMAPICall = '' then
      LLLVMAPICall := '[LLVM API call not specified]';
  except
    on E: Exception do
    begin
      // Fallback if diagnostics capture fails
      LLLVMModuleIR := '[Diagnostic capture failed: ' + E.Message + ']';
      LLLVMFunctionName := '[Unknown]';
      LLLVMContextInfo := '[Unknown]';
      LLLVMAPICall := ALLVMAPICall;
    end;
  end;

  // Create enhanced LLVM exception with rich diagnostics
  raise ECPException.CreateLLVMError(
    AMessage,
    AArgs,
    'LLVM code generation in ' + ALocation.FileName + '(' + IntToStr(ALocation.Line) + ',' + IntToStr(ALocation.Column) + ')',
    'Check LLVM module IR and function context above for detailed diagnostics',
    LLLVMModuleIR,
    LLLVMFunctionName,
    ALLVMValueInfo + ' | ' + LLLVMContextInfo,
    LLLVMAPICall
  );
end;

end.
