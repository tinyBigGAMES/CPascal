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

unit CPascal.Builder.IR;

{$I CPascal.Defines.inc}

interface

uses
  System.Classes,
  System.SysUtils,
  System.Rtti,
  System.Generics.Collections,
  CPascal.Common,
  CPascal.Expressions,
  CPascal.Builder.Interfaces,
  CPascal.LLVM;

type
  { TCPIRGenerator }
  TCPIRGenerator = class(TInterfacedObject, ICPIRGenerator)
  private
    // LLVM context and module for IR generation
    FLLVMContext: LLVMContextRef;
    FLLVMModule: LLVMModuleRef;
    FLLVMBuilder: LLVMBuilderRef;

    // Type mappings and function registry
    FTypeMap: TDictionary<string, LLVMTypeRef>;
    FFunctionMap: TDictionary<string, LLVMValueRef>;

  public
    constructor Create();
    destructor Destroy(); override;

    // ICPIRGenerator implementation
    function GenerateIR(): string;
    procedure Reset();

    function CPStartProgram(const AName: ICPIdentifier): ICPIRGenerator;
    function CPStartLibrary(const AName: ICPIdentifier): ICPIRGenerator;
    function CPStartModule(const AName: ICPIdentifier): ICPIRGenerator;

    // === Program Structure ===
    function CPAddImport(const AIdentifier: ICPIdentifier): ICPIRGenerator;
    function CPAddImports(const AIdentifiers: array of string): ICPIRGenerator;
    function CPAddExport(const AIdentifier: ICPIdentifier): ICPIRGenerator;
    function CPAddExports(const AIdentifiers: array of string): ICPIRGenerator;

    // === Compiler Directives ===
    // Conditional compilation directives
    function CPStartIfDef(const ASymbol: ICPIdentifier): ICPIRGenerator;
    function CPStartIfNDef(const ASymbol: ICPIdentifier): ICPIRGenerator;
    // Note: CPAddElse() and CPEndIf() are in Structured Statements section

    // Symbol management directives
    function CPAddDefine(const ASymbol: ICPIdentifier): ICPIRGenerator; overload;
    function CPAddDefine(const ASymbol: ICPIdentifier; const AValue: string): ICPIRGenerator; overload;
    function CPAddUndef(const ASymbol: ICPIdentifier): ICPIRGenerator;

    // Linking directives
    function CPAddLink(const ALibrary: ICPExpression): ICPIRGenerator;
    function CPAddLibPath(const APath: ICPExpression): ICPIRGenerator;
    function CPSetAppType(const AAppType: ICPExpression): ICPIRGenerator;
    function CPAddModulePath(const APath: ICPExpression): ICPIRGenerator;
    function CPAddExePath(const APath: ICPExpression): ICPIRGenerator;
    function CPAddObjPath(const APath: ICPExpression): ICPIRGenerator;

    // === Declaration Sections ===
    function CPStartConstSection(const AIsPublic: Boolean = False): ICPIRGenerator;
    function CPStartTypeSection(const AIsPublic: Boolean = False): ICPIRGenerator;
    function CPStartVarSection(const AIsPublic: Boolean = False): ICPIRGenerator;
    function CPStartLabelSection(): ICPIRGenerator;

    // === Constant Declarations ===
    function CPAddConstant(const AName: string; const AValue: string; const AIsPublic: Boolean = False): ICPIRGenerator;

    // === Type Declarations ===
    function CPAddTypeAlias(const AName, ATargetType: string; const AIsPublic: Boolean = False): ICPIRGenerator;
    function CPAddForwardDeclaration(const AName, ATargetType: string; const AIsPublic: Boolean = False): ICPIRGenerator;
    function CPAddPointerType(const AName, ATargetType: string; const AIsPublic: Boolean = False): ICPIRGenerator;
    function CPAddArrayType(const AName, AIndexRange, AElementType: string; const AIsPublic: Boolean = False): ICPIRGenerator;
    function CPAddEnumType(const AName: string; const AValues: array of string; const AIsPublic: Boolean = False): ICPIRGenerator;
    function CPStartRecordType(const AName: string; const APacked: Boolean = False; const AIsPublic: Boolean = False): ICPIRGenerator;
    function CPStartUnionType(const AName: string; const APacked: Boolean = False; const AIsPublic: Boolean = False): ICPIRGenerator;
    function CPAddRecordField(const AFieldNames: array of string; const AFieldType: string): ICPIRGenerator;
    function CPEndRecordType(): ICPIRGenerator;
    function CPEndUnionType(): ICPIRGenerator;
    function CPAddFunctionType(const AName: string; const AParams, AReturnType: string; const ACallingConv: string = ''; const AIsPublic: Boolean = False): ICPIRGenerator;
    function CPAddProcedureType(const AName: string; const AParams: string; const ACallingConv: string = ''; const AIsPublic: Boolean = False): ICPIRGenerator;

    // === Variable Declarations ===
    function CPAddVariable(const ANames: array of ICPIdentifier; const AType: TCPBuiltInType; const AIsPublic: Boolean = False): ICPIRGenerator; overload;
    function CPAddVariable(const ANames: array of ICPIdentifier; const AType: ICPType; const AIsPublic: Boolean = False): ICPIRGenerator; overload;
    function CPAddQualifiedVariable(const ANames: array of ICPIdentifier; const AQualifiers: string; const AType: TCPBuiltInType; const AIsPublic: Boolean = False): ICPIRGenerator; overload;
    function CPAddQualifiedVariable(const ANames: array of ICPIdentifier; const AQualifiers: string; const AType: ICPType; const AIsPublic: Boolean = False): ICPIRGenerator; overload;

    // === Label Declarations ===
    function CPAddLabels(const ALabels: array of string): ICPIRGenerator;

    // === Function/Procedure Declarations ===
    function CPStartFunction(const AName: ICPIdentifier; const AReturnType: TCPBuiltInType; const AIsPublic: Boolean = False): ICPIRGenerator; overload;
    function CPStartFunction(const AName: ICPIdentifier; const AReturnType: ICPType; const AIsPublic: Boolean = False): ICPIRGenerator; overload;
    function CPStartProcedure(const AName: ICPIdentifier; const AIsPublic: Boolean = False): ICPIRGenerator;
    function CPAddParameter(const ANames: array of ICPIdentifier; const AType: TCPBuiltInType; const AModifier: string = ''): ICPIRGenerator; overload;
    function CPAddParameter(const ANames: array of ICPIdentifier; const AType: ICPType; const AModifier: string = ''): ICPIRGenerator; overload;
    function CPAddVarArgsParameter(): ICPIRGenerator;
    function CPSetCallingConvention(const AConvention: string): ICPIRGenerator;
    function CPSetInline(const AInline: Boolean = True): ICPIRGenerator;
    function CPSetExternal(const ALibrary: string = ''): ICPIRGenerator;
    function CPStartFunctionBody(): ICPIRGenerator;
    function CPEndFunction(): ICPIRGenerator;
    function CPEndProcedure(): ICPIRGenerator;

    // === Statement Construction ===
    function CPStartCompoundStatement(): ICPIRGenerator;
    function CPEndCompoundStatement(): ICPIRGenerator;

    // Simple Statements
    function CPAddGoto(const ALabel: ICPIdentifier): ICPIRGenerator;
    function CPAddLabel(const ALabel: ICPIdentifier): ICPIRGenerator;
    function CPAddBreak(): ICPIRGenerator;
    function CPAddContinue(): ICPIRGenerator;
    function CPAddEmptyStatement(): ICPIRGenerator;

    // Inline Assembly
    function CPStartInlineAssembly(): ICPIRGenerator;
    function CPAddAssemblyLine(const AInstruction: string): ICPIRGenerator;
    function CPAddAssemblyConstraint(const ATemplate: string; const AOutputs, AInputs, AClobbers: array of string): ICPIRGenerator;
    function CPEndInlineAssembly(): ICPIRGenerator;

    // Structured Statements
    function CPAddElse(): ICPIRGenerator;
    function CPEndIf(): ICPIRGenerator;

    function CPAddCaseLabel(const ALabels: array of ICPExpression): ICPIRGenerator;
    function CPStartCaseElse(): ICPIRGenerator;
    function CPEndCase(): ICPIRGenerator;

    function CPEndWhile(): ICPIRGenerator;

    function CPStartFor(const AVariable: ICPIdentifier; const AStartValue, AEndValue: ICPExpression; const ADownTo: Boolean = False): ICPIRGenerator;
    function CPEndFor(): ICPIRGenerator;

    function CPStartRepeat(): ICPIRGenerator;


    // === SAA Expression Factory Methods ===
    // Identifier creation and validation
    function CPIdentifier(const AName: string): ICPIdentifier;

    // Specialized validation factory methods for compiler directives
    function CPLibraryName(const AName: string): ICPExpression;
    function CPFilePath(const APath: string): ICPExpression;
    function CPAppType(const AType: string): ICPExpression;

    // Type factory methods
    function CPBuiltInType(const AType: TCPBuiltInType): ICPType;

    // Enhanced type system access (Builder-Centralized Pattern)
    function CPGetTypeRegistry(): TCPTypeRegistry;
    function CPGetInt8Type(): ICPType;
    function CPGetInt16Type(): ICPType;
    function CPGetInt32Type(): ICPType;
    function CPGetInt64Type(): ICPType;
    function CPGetUInt8Type(): ICPType;
    function CPGetUInt16Type(): ICPType;
    function CPGetUInt32Type(): ICPType;
    function CPGetUInt64Type(): ICPType;
    function CPGetFloat32Type(): ICPType;
    function CPGetFloat64Type(): ICPType;
    function CPGetBooleanType(): ICPType;
    function CPGetStringType(): ICPType;
    function CPGetCharType(): ICPType;

    // Variable references
    function CPVariable(const AName: ICPIdentifier): ICPExpression;

    // Literal value factories
    function CPInt8(const AValue: Int8): ICPExpression;
    function CPInt16(const AValue: Int16): ICPExpression;
    function CPInt32(const AValue: Int32): ICPExpression;
    function CPInt64(const AValue: Int64): ICPExpression;
    function CPUInt8(const AValue: UInt8): ICPExpression;
    function CPUInt16(const AValue: UInt16): ICPExpression;
    function CPUInt32(const AValue: UInt32): ICPExpression;
    function CPUInt64(const AValue: UInt64): ICPExpression;
    function CPFloat32(const AValue: Single): ICPExpression;
    function CPFloat64(const AValue: Double): ICPExpression;
    function CPBoolean(const AValue: Boolean): ICPExpression;
    function CPString(const AValue: string): ICPExpression;
    function CPChar(const AValue: Char): ICPExpression;

    // Expression composition
    function CPBinaryOp(const ALeft: ICPExpression; const AOperator: TCPBinaryOperator; const ARight: ICPExpression): ICPExpression;
    function CPUnaryOp(const AOperator: TCPUnaryOperator; const AOperand: ICPExpression): ICPExpression;
    function CPTernaryOp(const ACondition: ICPExpression; const ATrueExpr: ICPExpression; const AFalseExpr: ICPExpression): ICPExpression;
    function CPFunctionCall(const AFunctionName: ICPIdentifier; const AParameters: array of ICPExpression): ICPExpression;
    function CPArrayAccess(const AArray: ICPExpression; const AIndex: ICPExpression): ICPExpression;
    function CPFieldAccess(const ARecord: ICPExpression; const AFieldName: ICPIdentifier): ICPExpression;
    function CPTypecast(const AExpression: ICPExpression; const ATargetType: ICPType): ICPExpression;

    // === SAA Statement Methods (Expression-Based) ===
    function CPAddAssignment(const AVariable: ICPIdentifier; const AExpression: ICPExpression): ICPIRGenerator;
    function CPAddProcedureCall(const AProcName: ICPIdentifier; const AParams: array of ICPExpression): ICPIRGenerator;
    function CPStartIf(const ACondition: ICPExpression): ICPIRGenerator;
    function CPStartCase(const AExpression: ICPExpression): ICPIRGenerator;
    function CPStartWhile(const ACondition: ICPExpression): ICPIRGenerator;
    function CPEndRepeat(const ACondition: ICPExpression): ICPIRGenerator;
    function CPAddExit(const AExpression: ICPExpression): ICPIRGenerator;

    // === Program Finalization ===
    function CPEndProgram(): ICPIRGenerator;
    function CPEndLibrary(): ICPIRGenerator;
    function CPEndModule(): ICPIRGenerator;

    // === Utility Methods ===
    function CPAddComment(const AComment: string; const AStyle: TCPCommentStyle = csLine): ICPIRGenerator;
    function CPAddBlankLine(): ICPIRGenerator;
    function CPGetCurrentContext(): string;
  end;

implementation

{ TCPIRGenerator }

constructor TCPIRGenerator.Create();
begin
  inherited Create();
  FTypeMap := TDictionary<string, LLVMTypeRef>.Create();
  FFunctionMap := TDictionary<string, LLVMValueRef>.Create();

  // Initialize LLVM context, module, and builder
  FLLVMContext := LLVMContextCreate();
  FLLVMModule := LLVMModuleCreateWithNameInContext('CPascalModule', FLLVMContext);
  FLLVMBuilder := LLVMCreateBuilderInContext(FLLVMContext);
end;

destructor TCPIRGenerator.Destroy();
begin
  if FLLVMBuilder <> nil then
    LLVMDisposeBuilder(FLLVMBuilder);
  if FLLVMModule <> nil then
    LLVMDisposeModule(FLLVMModule);
  if FLLVMContext <> nil then
    LLVMContextDispose(FLLVMContext);

  FTypeMap.Free();
  FFunctionMap.Free();
  inherited Destroy();
end;

function TCPIRGenerator.GenerateIR(): string;
var
  LIRString: PUTF8Char;
begin
  // Phase 2 implementation - will be completed after Phase 1 is complete
  LIRString := LLVMPrintModuleToString(FLLVMModule);
  try
    Result := string(UTF8String(LIRString));
  finally
    LLVMDisposeMessage(LIRString);
  end;
end;

// === [PLACEHOLDER IMPLEMENTATIONS - ALL RETURN SELF] ===
// [Copy all method signatures from TCPBuilder and make them return Self]
// [No actual IR generation logic yet - this is Phase 2 work]

// === Compilation Unit Selection ===
function TCPIRGenerator.CPStartProgram(const AName: ICPIdentifier): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPStartLibrary(const AName: ICPIdentifier): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPStartModule(const AName: ICPIdentifier): ICPIRGenerator;
begin
  Result := Self;
end;

// === Program Structure ===
function TCPIRGenerator.CPAddImport(const AIdentifier: ICPIdentifier): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddImports(const AIdentifiers: array of string): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddExport(const AIdentifier: ICPIdentifier): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddExports(const AIdentifiers: array of string): ICPIRGenerator;
begin
  Result := Self;
end;


// === Compiler Directives ===
// Conditional compilation directives
function TCPIRGenerator.CPStartIfDef(const ASymbol: ICPIdentifier): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPStartIfNDef(const ASymbol: ICPIdentifier): ICPIRGenerator;
begin
  Result := Self;
end;

// Note: CPAddElse() and CPEndIf() are in Structured Statements section

// Symbol management directives
function TCPIRGenerator.CPAddDefine(const ASymbol: ICPIdentifier): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddDefine(const ASymbol: ICPIdentifier; const AValue: string): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddUndef(const ASymbol: ICPIdentifier): ICPIRGenerator;
begin
  Result := Self;
end;


// Linking directives
function TCPIRGenerator.CPAddLink(const ALibrary: ICPExpression): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddLibPath(const APath: ICPExpression): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPSetAppType(const AAppType: ICPExpression): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddModulePath(const APath: ICPExpression): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddExePath(const APath: ICPExpression): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddObjPath(const APath: ICPExpression): ICPIRGenerator;
begin
  Result := Self;
end;


// === Declaration Sections ===
function TCPIRGenerator.CPStartConstSection(const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPStartTypeSection(const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPStartVarSection(const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPStartLabelSection(): ICPIRGenerator;
begin
  Result := Self;
end;


// === Constant Declarations ===
function TCPIRGenerator.CPAddConstant(const AName: string; const AValue: string; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;


// === Type Declarations ===
function TCPIRGenerator.CPAddTypeAlias(const AName, ATargetType: string; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddForwardDeclaration(const AName, ATargetType: string; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddPointerType(const AName, ATargetType: string; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddArrayType(const AName, AIndexRange, AElementType: string; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddEnumType(const AName: string; const AValues: array of string; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPStartRecordType(const AName: string; const APacked: Boolean = False; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPStartUnionType(const AName: string; const APacked: Boolean = False; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddRecordField(const AFieldNames: array of string; const AFieldType: string): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPEndRecordType(): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPEndUnionType(): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddFunctionType(const AName: string; const AParams, AReturnType: string; const ACallingConv: string = ''; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddProcedureType(const AName: string; const AParams: string; const ACallingConv: string = ''; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;


// === Variable Declarations ===
function TCPIRGenerator.CPAddVariable(const ANames: array of ICPIdentifier; const AType: TCPBuiltInType; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddVariable(const ANames: array of ICPIdentifier; const AType: ICPType; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddQualifiedVariable(const ANames: array of ICPIdentifier; const AQualifiers: string; const AType: TCPBuiltInType; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddQualifiedVariable(const ANames: array of ICPIdentifier; const AQualifiers: string; const AType: ICPType; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;


// === Label Declarations ===
function TCPIRGenerator.CPAddLabels(const ALabels: array of string): ICPIRGenerator;
begin
  Result := Self;
end;


// === Function/Procedure Declarations ===
function TCPIRGenerator.CPStartFunction(const AName: ICPIdentifier; const AReturnType: TCPBuiltInType; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPStartFunction(const AName: ICPIdentifier; const AReturnType: ICPType; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPStartProcedure(const AName: ICPIdentifier; const AIsPublic: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddParameter(const ANames: array of ICPIdentifier; const AType: TCPBuiltInType; const AModifier: string = ''): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddParameter(const ANames: array of ICPIdentifier; const AType: ICPType; const AModifier: string = ''): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddVarArgsParameter(): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPSetCallingConvention(const AConvention: string): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPSetInline(const AInline: Boolean = True): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPSetExternal(const ALibrary: string = ''): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPStartFunctionBody(): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPEndFunction(): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPEndProcedure(): ICPIRGenerator;
begin
  Result := Self;
end;


// === Statement Construction ===
function TCPIRGenerator.CPStartCompoundStatement(): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPEndCompoundStatement(): ICPIRGenerator;
begin
  Result := Self;
end;


// Simple Statements
function TCPIRGenerator.CPAddGoto(const ALabel: ICPIdentifier): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddLabel(const ALabel: ICPIdentifier): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddBreak(): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddContinue(): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddEmptyStatement(): ICPIRGenerator;
begin
  Result := Self;
end;


// Inline Assembly
function TCPIRGenerator.CPStartInlineAssembly(): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddAssemblyLine(const AInstruction: string): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddAssemblyConstraint(const ATemplate: string; const AOutputs, AInputs, AClobbers: array of string): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPEndInlineAssembly(): ICPIRGenerator;
begin
  Result := Self;
end;


// Structured Statements
function TCPIRGenerator.CPAddElse(): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPEndIf(): ICPIRGenerator;
begin
  Result := Self;
end;


function TCPIRGenerator.CPAddCaseLabel(const ALabels: array of ICPExpression): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPStartCaseElse(): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPEndCase(): ICPIRGenerator;
begin
  Result := Self;
end;


function TCPIRGenerator.CPEndWhile(): ICPIRGenerator;
begin
  Result := Self;
end;


function TCPIRGenerator.CPStartFor(const AVariable: ICPIdentifier; const AStartValue, AEndValue: ICPExpression; const ADownTo: Boolean = False): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPEndFor(): ICPIRGenerator;
begin
  Result := Self;
end;


function TCPIRGenerator.CPStartRepeat(): ICPIRGenerator;
begin
  Result := Self;
end;



// === SAA Expression Factory Methods ===
// Identifier creation and validation
function TCPIRGenerator.CPIdentifier(const AName: string): ICPIdentifier;
begin
  Result := TCPIdentifier.Create(AName, TCPSourceLocation.Create('', 0, 0));
end;


// Specialized validation factory methods for compiler directives
function TCPIRGenerator.CPLibraryName(const AName: string): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create string literal (simplified - no validation in IR generator)
  LLiteral := TCPLiteral.Create(
    TValue.From<string>(AName),
    CPGetStringType(),
    LLocation
  );

  Result := LLiteral;
end;

function TCPIRGenerator.CPFilePath(const APath: string): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create string literal (simplified - no validation in IR generator)
  LLiteral := TCPLiteral.Create(
    TValue.From<string>(APath),
    CPGetStringType(),
    LLocation
  );

  Result := LLiteral;
end;

function TCPIRGenerator.CPAppType(const AType: string): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create string literal (simplified - no validation in IR generator)
  LLiteral := TCPLiteral.Create(
    TValue.From<string>(AType),
    CPGetStringType(),
    LLocation
  );

  Result := LLiteral;
end;


// Type factory methods
function TCPIRGenerator.CPBuiltInType(const AType: TCPBuiltInType): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(AType);
end;


// Enhanced type system access (Builder-Centralized Pattern)
function TCPIRGenerator.CPGetTypeRegistry(): TCPTypeRegistry;
begin
  Result := TCPTypeRegistry.GetInstance();
end;

function TCPIRGenerator.CPGetInt8Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptInt8);
end;

function TCPIRGenerator.CPGetInt16Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptInt16);
end;

function TCPIRGenerator.CPGetInt32Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptInt32);
end;

function TCPIRGenerator.CPGetInt64Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptInt64);
end;

function TCPIRGenerator.CPGetUInt8Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptUInt8);
end;

function TCPIRGenerator.CPGetUInt16Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptUInt16);
end;

function TCPIRGenerator.CPGetUInt32Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptUInt32);
end;

function TCPIRGenerator.CPGetUInt64Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptUInt64);
end;

function TCPIRGenerator.CPGetFloat32Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptFloat32);
end;

function TCPIRGenerator.CPGetFloat64Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptFloat64);
end;

function TCPIRGenerator.CPGetBooleanType(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetBooleanType();
end;

function TCPIRGenerator.CPGetStringType(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetStringType();
end;

function TCPIRGenerator.CPGetCharType(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetCharType();
end;


// Variable references
function TCPIRGenerator.CPVariable(const AName: ICPIdentifier): ICPExpression;
var
  LVariable: TCPVariable;
  LLocation: TCPSourceLocation;
  LType: ICPType;
begin
  // Create default source location
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Use a default type (Int32) since we don't have symbol table lookup in IR generator
  LType := CPGetInt32Type();

  // Create variable expression
  LVariable := TCPVariable.Create(
    AName,
    LType,
    LLocation
  );

  Result := LVariable;
end;


// Literal value factories
function TCPIRGenerator.CPInt8(const AValue: Int8): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LLiteral := TCPLiteral.Create(
    TValue.From<Int8>(AValue),
    CPGetInt8Type(),
    LLocation
  );
  Result := LLiteral;
end;

function TCPIRGenerator.CPInt16(const AValue: Int16): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LLiteral := TCPLiteral.Create(
    TValue.From<Int16>(AValue),
    CPGetInt16Type(),
    LLocation
  );
  Result := LLiteral;
end;

function TCPIRGenerator.CPInt32(const AValue: Int32): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LLiteral := TCPLiteral.Create(
    TValue.From<Int32>(AValue),
    CPGetInt32Type(),
    LLocation
  );
  Result := LLiteral;
end;

function TCPIRGenerator.CPInt64(const AValue: Int64): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LLiteral := TCPLiteral.Create(
    TValue.From<Int64>(AValue),
    CPGetInt64Type(),
    LLocation
  );
  Result := LLiteral;
end;

function TCPIRGenerator.CPUInt8(const AValue: UInt8): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LLiteral := TCPLiteral.Create(
    TValue.From<UInt8>(AValue),
    CPGetUInt8Type(),
    LLocation
  );
  Result := LLiteral;
end;

function TCPIRGenerator.CPUInt16(const AValue: UInt16): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LLiteral := TCPLiteral.Create(
    TValue.From<UInt16>(AValue),
    CPGetUInt16Type(),
    LLocation
  );
  Result := LLiteral;
end;

function TCPIRGenerator.CPUInt32(const AValue: UInt32): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LLiteral := TCPLiteral.Create(
    TValue.From<UInt32>(AValue),
    CPGetUInt32Type(),
    LLocation
  );
  Result := LLiteral;
end;

function TCPIRGenerator.CPUInt64(const AValue: UInt64): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LLiteral := TCPLiteral.Create(
    TValue.From<UInt64>(AValue),
    CPGetUInt64Type(),
    LLocation
  );
  Result := LLiteral;
end;

function TCPIRGenerator.CPFloat32(const AValue: Single): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LLiteral := TCPLiteral.Create(
    TValue.From<Single>(AValue),
    CPGetFloat32Type(),
    LLocation
  );
  Result := LLiteral;
end;

function TCPIRGenerator.CPFloat64(const AValue: Double): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LLiteral := TCPLiteral.Create(
    TValue.From<Double>(AValue),
    CPGetFloat64Type(),
    LLocation
  );
  Result := LLiteral;
end;

function TCPIRGenerator.CPBoolean(const AValue: Boolean): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LLiteral := TCPLiteral.Create(
    TValue.From<Boolean>(AValue),
    CPGetBooleanType(),
    LLocation
  );
  Result := LLiteral;
end;

function TCPIRGenerator.CPString(const AValue: string): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LLiteral := TCPLiteral.Create(
    TValue.From<string>(AValue),
    CPGetStringType(),
    LLocation
  );
  Result := LLiteral;
end;

function TCPIRGenerator.CPChar(const AValue: Char): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LLiteral := TCPLiteral.Create(
    TValue.From<Char>(AValue),
    CPGetCharType(),
    LLocation
  );
  Result := LLiteral;
end;


// Expression composition
function TCPIRGenerator.CPBinaryOp(const ALeft: ICPExpression; const AOperator: TCPBinaryOperator; const ARight: ICPExpression): ICPExpression;
var
  LBinaryOp: TCPBinaryOp;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LBinaryOp := TCPBinaryOp.Create(
    ALeft,
    AOperator,
    ARight,
    LLocation
  );
  Result := LBinaryOp;
end;

function TCPIRGenerator.CPUnaryOp(const AOperator: TCPUnaryOperator; const AOperand: ICPExpression): ICPExpression;
var
  LUnaryOp: TCPUnaryOp;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LUnaryOp := TCPUnaryOp.Create(
    AOperator,
    AOperand,
    LLocation
  );
  Result := LUnaryOp;
end;

function TCPIRGenerator.CPTernaryOp(const ACondition: ICPExpression; const ATrueExpr: ICPExpression; const AFalseExpr: ICPExpression): ICPExpression;
var
  LTernaryOp: TCPTernaryOp;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LTernaryOp := TCPTernaryOp.Create(
    ACondition,
    ATrueExpr,
    AFalseExpr,
    LLocation
  );
  Result := LTernaryOp;
end;

function TCPIRGenerator.CPFunctionCall(const AFunctionName: ICPIdentifier; const AParameters: array of ICPExpression): ICPExpression;
var
  LFunctionCall: TCPFunctionCall;
  LLocation: TCPSourceLocation;
  LReturnType: ICPType;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LReturnType := CPGetInt32Type(); // Default return type
  LFunctionCall := TCPFunctionCall.Create(
    AFunctionName,
    AParameters,
    LReturnType,
    LLocation
  );
  Result := LFunctionCall;
end;

function TCPIRGenerator.CPArrayAccess(const AArray: ICPExpression; const AIndex: ICPExpression): ICPExpression;
var
  LArrayAccess: TCPArrayAccess;
  LLocation: TCPSourceLocation;
  LElementType: ICPType;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LElementType := CPGetInt32Type(); // Default element type
  LArrayAccess := TCPArrayAccess.Create(
    AArray,
    AIndex,
    LElementType,
    LLocation
  );
  Result := LArrayAccess;
end;

function TCPIRGenerator.CPFieldAccess(const ARecord: ICPExpression; const AFieldName: ICPIdentifier): ICPExpression;
var
  LFieldAccess: TCPFieldAccess;
  LLocation: TCPSourceLocation;
  LFieldType: ICPType;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LFieldType := CPGetInt32Type(); // Default field type
  LFieldAccess := TCPFieldAccess.Create(
    ARecord,
    AFieldName,
    LFieldType,
    LLocation
  );
  Result := LFieldAccess;
end;

function TCPIRGenerator.CPTypecast(const AExpression: ICPExpression; const ATargetType: ICPType): ICPExpression;
var
  LTypecast: TCPTypecast;
  LLocation: TCPSourceLocation;
begin
  LLocation := TCPSourceLocation.Create('', 0, 0);
  LTypecast := TCPTypecast.Create(
    AExpression,
    ATargetType,
    LLocation
  );
  Result := LTypecast;
end;


// === SAA Statement Methods (Expression-Based) ===
function TCPIRGenerator.CPAddAssignment(const AVariable: ICPIdentifier; const AExpression: ICPExpression): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddProcedureCall(const AProcName: ICPIdentifier; const AParams: array of ICPExpression): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPStartIf(const ACondition: ICPExpression): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPStartCase(const AExpression: ICPExpression): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPStartWhile(const ACondition: ICPExpression): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPEndRepeat(const ACondition: ICPExpression): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddExit(const AExpression: ICPExpression): ICPIRGenerator;
begin
  Result := Self;
end;


// === Program Finalization ===
function TCPIRGenerator.CPEndProgram(): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPEndLibrary(): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPEndModule(): ICPIRGenerator;
begin
  Result := Self;
end;

// === Utility Methods ===
function TCPIRGenerator.CPAddComment(const AComment: string; const AStyle: TCPCommentStyle = csLine): ICPIRGenerator;
begin
  Result := Self;
end;

function TCPIRGenerator.CPAddBlankLine(): ICPIRGenerator;
begin
  Result := Self;
end;

procedure TCPIRGenerator.Reset();
begin
end;

function TCPIRGenerator.CPGetCurrentContext(): string;
begin
  Result := '';
end;


end.
