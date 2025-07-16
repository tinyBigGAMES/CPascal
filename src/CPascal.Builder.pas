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

unit CPascal.Builder;

{$I CPascal.Defines.inc}

interface

uses
  System.Classes,
  System.SysUtils,
  System.Rtti,
  System.Generics.Collections,
  CPascal.Common,
  CPascal.Builder.Interfaces,
  CPascal.Builder.Source,
  CPascal.Builder.IR,
  CPascal.Expressions;

type

  { TCPBuilder }
  TCPBuilder = class(TInterfacedObject, ICPBuilder)
  private
    FSourceGenerator: ICPSourceGenerator;
    FIRGenerator: ICPIRGenerator;

  protected
    // Implementation will be added in subsequent iterations
  public
    constructor Create();
    destructor Destroy(); override;

    // === [COPY ALL METHOD DECLARATIONS FROM ICPBuilder INTERFACE] ===
    // [All methods delegate to appropriate generator]
    // === Compilation Unit Selection ===
    function CPStartProgram(const AName: ICPIdentifier): ICPBuilder;
    function CPStartLibrary(const AName: ICPIdentifier): ICPBuilder;
    function CPStartModule(const AName: ICPIdentifier): ICPBuilder;

    // === Program Structure ===
    function CPAddImport(const AIdentifier: ICPIdentifier): ICPBuilder;
    function CPAddImports(const AIdentifiers: array of string): ICPBuilder;
    function CPAddExport(const AIdentifier: ICPIdentifier): ICPBuilder;
    function CPAddExports(const AIdentifiers: array of string): ICPBuilder;

    // === Compiler Directives ===
    // Conditional compilation directives
    function CPStartIfDef(const ASymbol: ICPIdentifier): ICPBuilder;
    function CPStartIfNDef(const ASymbol: ICPIdentifier): ICPBuilder;
    // Note: CPAddElse() and CPEndIf() are in Structured Statements section

    // Symbol management directives
    function CPAddDefine(const ASymbol: ICPIdentifier): ICPBuilder; overload;
    function CPAddDefine(const ASymbol: ICPIdentifier; const AValue: string): ICPBuilder; overload;
    function CPAddUndef(const ASymbol: ICPIdentifier): ICPBuilder;

    // Linking directives
    function CPAddLink(const ALibrary: ICPExpression): ICPBuilder;
    function CPAddLibPath(const APath: ICPExpression): ICPBuilder;
    function CPSetAppType(const AAppType: ICPExpression): ICPBuilder;
    function CPAddModulePath(const APath: ICPExpression): ICPBuilder;
    function CPAddExePath(const APath: ICPExpression): ICPBuilder;
    function CPAddObjPath(const APath: ICPExpression): ICPBuilder;

    // === Declaration Sections ===
    function CPStartConstSection(const AIsPublic: Boolean = False): ICPBuilder;
    function CPStartTypeSection(const AIsPublic: Boolean = False): ICPBuilder;
    function CPStartVarSection(const AIsPublic: Boolean = False): ICPBuilder;
    function CPStartLabelSection(): ICPBuilder;

    // === Constant Declarations ===
    function CPAddConstant(const AName: string; const AValue: string; const AIsPublic: Boolean = False): ICPBuilder;

    // === Type Declarations ===
    function CPAddTypeAlias(const AName, ATargetType: string; const AIsPublic: Boolean = False): ICPBuilder;
    function CPAddForwardDeclaration(const AName, ATargetType: string; const AIsPublic: Boolean = False): ICPBuilder;
    function CPAddPointerType(const AName, ATargetType: string; const AIsPublic: Boolean = False): ICPBuilder;
    function CPAddArrayType(const AName, AIndexRange, AElementType: string; const AIsPublic: Boolean = False): ICPBuilder;
    function CPAddEnumType(const AName: string; const AValues: array of string; const AIsPublic: Boolean = False): ICPBuilder;
    function CPStartRecordType(const AName: string; const APacked: Boolean = False; const AIsPublic: Boolean = False): ICPBuilder;
    function CPStartUnionType(const AName: string; const APacked: Boolean = False; const AIsPublic: Boolean = False): ICPBuilder;
    function CPAddRecordField(const AFieldNames: array of string; const AFieldType: string): ICPBuilder;
    function CPEndRecordType(): ICPBuilder;
    function CPEndUnionType(): ICPBuilder;
    function CPAddFunctionType(const AName: string; const AParams, AReturnType: string; const ACallingConv: string = ''; const AIsPublic: Boolean = False): ICPBuilder;
    function CPAddProcedureType(const AName: string; const AParams: string; const ACallingConv: string = ''; const AIsPublic: Boolean = False): ICPBuilder;

    // === Variable Declarations ===
    function CPAddVariable(const ANames: array of ICPIdentifier; const AType: TCPBuiltInType; const AIsPublic: Boolean = False): ICPBuilder; overload;
    function CPAddVariable(const ANames: array of ICPIdentifier; const AType: ICPType; const AIsPublic: Boolean = False): ICPBuilder; overload;
    function CPAddQualifiedVariable(const ANames: array of ICPIdentifier; const AQualifiers: string; const AType: TCPBuiltInType; const AIsPublic: Boolean = False): ICPBuilder; overload;
    function CPAddQualifiedVariable(const ANames: array of ICPIdentifier; const AQualifiers: string; const AType: ICPType; const AIsPublic: Boolean = False): ICPBuilder; overload;

    // === Label Declarations ===
    function CPAddLabels(const ALabels: array of string): ICPBuilder;

    // === Function/Procedure Declarations ===
    function CPStartFunction(const AName: ICPIdentifier; const AReturnType: TCPBuiltInType; const AIsPublic: Boolean = False): ICPBuilder; overload;
    function CPStartFunction(const AName: ICPIdentifier; const AReturnType: ICPType; const AIsPublic: Boolean = False): ICPBuilder; overload;
    function CPStartProcedure(const AName: ICPIdentifier; const AIsPublic: Boolean = False): ICPBuilder;
    function CPAddParameter(const ANames: array of ICPIdentifier; const AType: TCPBuiltInType; const AModifier: string = ''): ICPBuilder; overload;
    function CPAddParameter(const ANames: array of ICPIdentifier; const AType: ICPType; const AModifier: string = ''): ICPBuilder; overload;
    function CPAddVarArgsParameter(): ICPBuilder;
    function CPSetCallingConvention(const AConvention: string): ICPBuilder;
    function CPSetInline(const AInline: Boolean = True): ICPBuilder;
    function CPSetExternal(const ALibrary: string = ''): ICPBuilder;
    function CPStartFunctionBody(): ICPBuilder;
    function CPEndFunction(): ICPBuilder;
    function CPEndProcedure(): ICPBuilder;

    // === Statement Construction ===
    function CPStartCompoundStatement(): ICPBuilder;
    function CPEndCompoundStatement(): ICPBuilder;

    // Simple Statements
    function CPAddGoto(const ALabel: ICPIdentifier): ICPBuilder;
    function CPAddLabel(const ALabel: ICPIdentifier): ICPBuilder;
    function CPAddBreak(): ICPBuilder;
    function CPAddContinue(): ICPBuilder;
    function CPAddEmptyStatement(): ICPBuilder;

    // Inline Assembly
    function CPStartInlineAssembly(): ICPBuilder;
    function CPAddAssemblyLine(const AInstruction: string): ICPBuilder;
    function CPAddAssemblyConstraint(const ATemplate: string; const AOutputs, AInputs, AClobbers: array of string): ICPBuilder;
    function CPEndInlineAssembly(): ICPBuilder;

    // Structured Statements
    function CPAddElse(): ICPBuilder;
    function CPEndIf(): ICPBuilder;

    function CPAddCaseLabel(const ALabels: array of ICPExpression): ICPBuilder;
    function CPStartCaseElse(): ICPBuilder;
    function CPEndCase(): ICPBuilder;

    function CPEndWhile(): ICPBuilder;

    function CPStartFor(const AVariable: ICPIdentifier; const AStartValue, AEndValue: ICPExpression; const ADownTo: Boolean = False): ICPBuilder;
    function CPEndFor(): ICPBuilder;

    function CPStartRepeat(): ICPBuilder;


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
    function CPAddAssignment(const AVariable: ICPIdentifier; const AExpression: ICPExpression): ICPBuilder;
    function CPAddProcedureCall(const AProcName: ICPIdentifier; const AParams: array of ICPExpression): ICPBuilder;
    function CPStartIf(const ACondition: ICPExpression): ICPBuilder;
    function CPStartCase(const AExpression: ICPExpression): ICPBuilder;
    function CPStartWhile(const ACondition: ICPExpression): ICPBuilder;
    function CPEndRepeat(const ACondition: ICPExpression): ICPBuilder;
    function CPAddExit(const AExpression: ICPExpression): ICPBuilder;

    // === Program Finalization ===
    function CPEndProgram(): ICPBuilder;
    function CPEndLibrary(): ICPBuilder;
    function CPEndModule(): ICPBuilder;

    // === Output Generation ===
    function GetCPas(const APrettyPrint: Boolean = True): string;
    function GetIR(): string; // Phase 2 implementation

    // === Utility Methods ===
    function CPAddComment(const AComment: string; const AStyle: TCPCommentStyle = csLine): ICPBuilder;
    function CPAddBlankLine(): ICPBuilder;
    function CPReset(): ICPBuilder;
    function CPGetCurrentContext(): string;
  end;

// === Factory Function ===
function CPCreateBuilder(): ICPBuilder;

implementation

{ TCPBuilder }

constructor TCPBuilder.Create();
begin
  inherited Create();
  FSourceGenerator := TCPSourceGenerator.Create();
  FIRGenerator := TCPIRGenerator.Create();
end;

destructor TCPBuilder.Destroy();
begin
  FSourceGenerator := nil;
  FIRGenerator := nil;
  inherited Destroy();
end;

// === Output Generation ===
function TCPBuilder.GetCPas(const APrettyPrint: Boolean): string;
begin
  Result := FSourceGenerator.GenerateSource(APrettyPrint);
end;

function TCPBuilder.GetIR(): string;
begin
  Result := FIRGenerator.GenerateIR();
end;

// === Utility Methods ===
function TCPBuilder.CPReset(): ICPBuilder;
begin
  FSourceGenerator.Reset();
  FIRGenerator.Reset();
  Result := Self;
end;

function TCPBuilder.CPGetCurrentContext(): string;
begin
  // Delegate to source generator (context is mainly for source generation)
  Result := (FSourceGenerator as TCPSourceGenerator).CPGetCurrentContext();
end;

// === [DELEGATE ALL OTHER METHODS] ===
// [Each method calls the corresponding method on FSourceGenerator and FIRGenerator]
// [Pattern: both generators get called, return Self for fluent interface]
function TCPBuilder.CPStartLibrary(const AName: ICPIdentifier): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartLibrary(AName);
  (FIRGenerator as TCPIRGenerator).CPStartLibrary(AName);
  Result := Self;
end;

function TCPBuilder.CPStartModule(const AName: ICPIdentifier): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartModule(AName);
  (FIRGenerator as TCPIRGenerator).CPStartModule(AName);
  Result := Self;
end;

// === Program Structure ===
function TCPBuilder.CPAddImport(const AIdentifier: ICPIdentifier): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddImport(AIdentifier);
  (FIRGenerator as TCPIRGenerator).CPAddImport(AIdentifier);
  Result := Self;
end;

function TCPBuilder.CPAddImports(const AIdentifiers: array of string): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddImports(AIdentifiers);
  (FIRGenerator as TCPIRGenerator).CPAddImports(AIdentifiers);
  Result := Self;
end;

function TCPBuilder.CPAddExport(const AIdentifier: ICPIdentifier): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddExport(AIdentifier);
  (FIRGenerator as TCPIRGenerator).CPAddExport(AIdentifier);
  Result := Self;
end;

function TCPBuilder.CPAddExports(const AIdentifiers: array of string): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddExports(AIdentifiers);
  (FIRGenerator as TCPIRGenerator).CPAddExports(AIdentifiers);
  Result := Self;
end;


// === Compiler Directives ===
// Conditional compilation directives
function TCPBuilder.CPStartIfDef(const ASymbol: ICPIdentifier): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartIfDef(ASymbol);
  (FIRGenerator as TCPIRGenerator).CPStartIfDef(ASymbol);
  Result := Self;
end;

function TCPBuilder.CPStartIfNDef(const ASymbol: ICPIdentifier): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartIfNDef(ASymbol);
  (FIRGenerator as TCPIRGenerator).CPStartIfNDef(ASymbol);
  Result := Self;
end;

// Note: CPAddElse() and CPEndIf() are in Structured Statements section

// Symbol management directives
function TCPBuilder.CPAddDefine(const ASymbol: ICPIdentifier): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddDefine(ASymbol);
  (FIRGenerator as TCPIRGenerator).CPAddDefine(ASymbol);
  Result := Self;
end;

function TCPBuilder.CPAddDefine(const ASymbol: ICPIdentifier; const AValue: string): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddDefine(ASymbol, AValue);
  (FIRGenerator as TCPIRGenerator).CPAddDefine(ASymbol, AValue);
  Result := Self;
end;

function TCPBuilder.CPAddUndef(const ASymbol: ICPIdentifier): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddUndef(ASymbol);
  (FIRGenerator as TCPIRGenerator).CPAddUndef(ASymbol);
  Result := Self;
end;


// Linking directives
function TCPBuilder.CPAddLink(const ALibrary: ICPExpression): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddLink(ALibrary);
  (FIRGenerator as TCPIRGenerator).CPAddLink(ALibrary);
  Result := Self;
end;

function TCPBuilder.CPAddLibPath(const APath: ICPExpression): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddLibPath(APath);
  (FIRGenerator as TCPIRGenerator).CPAddLibPath(APath);
  Result := Self;
end;

function TCPBuilder.CPSetAppType(const AAppType: ICPExpression): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPSetAppType(AAppType);
  (FIRGenerator as TCPIRGenerator).CPSetAppType(AAppType);
  Result := Self;
end;

function TCPBuilder.CPAddModulePath(const APath: ICPExpression): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddModulePath(APath);
  (FIRGenerator as TCPIRGenerator).CPAddModulePath(APath);
  Result := Self;
end;

function TCPBuilder.CPAddExePath(const APath: ICPExpression): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddExePath(APath);
  (FIRGenerator as TCPIRGenerator).CPAddExePath(APath);
  Result := Self;
end;

function TCPBuilder.CPAddObjPath(const APath: ICPExpression): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddObjPath(APath);
  (FIRGenerator as TCPIRGenerator).CPAddObjPath(APath);
  Result := Self;
end;


// === Declaration Sections ===
function TCPBuilder.CPStartConstSection(const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartConstSection(AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPStartConstSection(AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPStartTypeSection(const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartTypeSection(AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPStartTypeSection(AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPStartVarSection(const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartVarSection(AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPStartVarSection(AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPStartLabelSection(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartLabelSection();
  (FIRGenerator as TCPIRGenerator).CPStartLabelSection();
  Result := Self;
end;


// === Constant Declarations ===
function TCPBuilder.CPAddConstant(const AName: string; const AValue: string; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddConstant(AName, AValue, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPAddConstant(AName, AValue, AIsPublic);
  Result := Self;
end;


// === Type Declarations ===
function TCPBuilder.CPAddTypeAlias(const AName, ATargetType: string; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddTypeAlias(AName, ATargetType, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPAddTypeAlias(AName, ATargetType, AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPAddForwardDeclaration(const AName, ATargetType: string; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddForwardDeclaration(AName, ATargetType, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPAddForwardDeclaration(AName, ATargetType, AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPAddPointerType(const AName, ATargetType: string; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddPointerType(AName, ATargetType, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPAddPointerType(AName, ATargetType, AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPAddArrayType(const AName, AIndexRange, AElementType: string; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddArrayType(AName, AIndexRange, AElementType, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPAddArrayType(AName, AIndexRange, AElementType, AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPAddEnumType(const AName: string; const AValues: array of string; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddEnumType(AName, AValues, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPAddEnumType(AName, AValues, AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPStartRecordType(const AName: string; const APacked: Boolean = False; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartRecordType(AName, APacked, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPStartRecordType(AName, APacked, AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPStartUnionType(const AName: string; const APacked: Boolean = False; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartUnionType(AName, APacked, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPStartUnionType(AName, APacked, AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPAddRecordField(const AFieldNames: array of string; const AFieldType: string): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddRecordField(AFieldNames, AFieldType);
  (FIRGenerator as TCPIRGenerator).CPAddRecordField(AFieldNames, AFieldType);
  Result := Self;
end;

function TCPBuilder.CPEndRecordType(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPEndRecordType();
  (FIRGenerator as TCPIRGenerator).CPEndRecordType();
  Result := Self;
end;

function TCPBuilder.CPEndUnionType(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPEndUnionType();
  (FIRGenerator as TCPIRGenerator).CPEndUnionType();
  Result := Self;
end;

function TCPBuilder.CPAddFunctionType(const AName: string; const AParams, AReturnType: string; const ACallingConv: string = ''; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddFunctionType(AName, AParams, AReturnType, ACallingConv, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPAddFunctionType(AName, AParams, AReturnType, ACallingConv, AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPAddProcedureType(const AName: string; const AParams: string; const ACallingConv: string = ''; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddProcedureType(AName, AParams, ACallingConv, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPAddProcedureType(AName, AParams, ACallingConv, AIsPublic);
  Result := Self;
end;


// === Variable Declarations ===
function TCPBuilder.CPAddVariable(const ANames: array of ICPIdentifier; const AType: TCPBuiltInType; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddVariable(ANames, AType, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPAddVariable(ANames, AType, AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPAddVariable(const ANames: array of ICPIdentifier; const AType: ICPType; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddVariable(ANames, AType, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPAddVariable(ANames, AType, AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPAddQualifiedVariable(const ANames: array of ICPIdentifier; const AQualifiers: string; const AType: TCPBuiltInType; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddQualifiedVariable(ANames, AQualifiers, AType, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPAddQualifiedVariable(ANames, AQualifiers, AType, AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPAddQualifiedVariable(const ANames: array of ICPIdentifier; const AQualifiers: string; const AType: ICPType; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddQualifiedVariable(ANames, AQualifiers, AType, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPAddQualifiedVariable(ANames, AQualifiers, AType, AIsPublic);
  Result := Self;
end;


// === Label Declarations ===
function TCPBuilder.CPAddLabels(const ALabels: array of string): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddLabels(ALabels);
  (FIRGenerator as TCPIRGenerator).CPAddLabels(ALabels);
  Result := Self;
end;


// === Function/Procedure Declarations ===
function TCPBuilder.CPStartFunction(const AName: ICPIdentifier; const AReturnType: TCPBuiltInType; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartFunction(AName, AReturnType, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPStartFunction(AName, AReturnType, AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPStartFunction(const AName: ICPIdentifier; const AReturnType: ICPType; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartFunction(AName, AReturnType, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPStartFunction(AName, AReturnType, AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPStartProcedure(const AName: ICPIdentifier; const AIsPublic: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartProcedure(AName, AIsPublic);
  (FIRGenerator as TCPIRGenerator).CPStartProcedure(AName, AIsPublic);
  Result := Self;
end;

function TCPBuilder.CPAddParameter(const ANames: array of ICPIdentifier; const AType: TCPBuiltInType; const AModifier: string = ''): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddParameter(ANames, AType, AModifier);
  (FIRGenerator as TCPIRGenerator).CPAddParameter(ANames, AType, AModifier);
  Result := Self;
end;

function TCPBuilder.CPAddParameter(const ANames: array of ICPIdentifier; const AType: ICPType; const AModifier: string = ''): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddParameter(ANames, AType, AModifier);
  (FIRGenerator as TCPIRGenerator).CPAddParameter(ANames, AType, AModifier);
  Result := Self;
end;

function TCPBuilder.CPAddVarArgsParameter(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddVarArgsParameter();
  (FIRGenerator as TCPIRGenerator).CPAddVarArgsParameter();
  Result := Self;
end;

function TCPBuilder.CPSetCallingConvention(const AConvention: string): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPSetCallingConvention(AConvention);
  (FIRGenerator as TCPIRGenerator).CPSetCallingConvention(AConvention);
  Result := Self;
end;

function TCPBuilder.CPSetInline(const AInline: Boolean = True): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPSetInline(AInline);
  (FIRGenerator as TCPIRGenerator).CPSetInline(AInline);
  Result := Self;
end;

function TCPBuilder.CPSetExternal(const ALibrary: string = ''): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPSetExternal(ALibrary);
  (FIRGenerator as TCPIRGenerator).CPSetExternal(ALibrary);
  Result := Self;
end;

function TCPBuilder.CPStartFunctionBody(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartFunctionBody();
  (FIRGenerator as TCPIRGenerator).CPStartFunctionBody();
  Result := Self;
end;

function TCPBuilder.CPEndFunction(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPEndFunction();
  (FIRGenerator as TCPIRGenerator).CPEndFunction();
  Result := Self;
end;

function TCPBuilder.CPEndProcedure(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPEndProcedure();
  (FIRGenerator as TCPIRGenerator).CPEndProcedure();
  Result := Self;
end;


// === Statement Construction ===
function TCPBuilder.CPStartCompoundStatement(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartCompoundStatement();
  (FIRGenerator as TCPIRGenerator).CPStartCompoundStatement();
  Result := Self;
end;

function TCPBuilder.CPEndCompoundStatement(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPEndCompoundStatement();
  (FIRGenerator as TCPIRGenerator).CPEndCompoundStatement();
  Result := Self;
end;


// Simple Statements
function TCPBuilder.CPAddGoto(const ALabel: ICPIdentifier): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddGoto(ALabel);
  (FIRGenerator as TCPIRGenerator).CPAddGoto(ALabel);
  Result := Self;
end;

function TCPBuilder.CPAddLabel(const ALabel: ICPIdentifier): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddLabel(ALabel);
  (FIRGenerator as TCPIRGenerator).CPAddLabel(ALabel);
  Result := Self;
end;

function TCPBuilder.CPAddBreak(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddBreak();
  (FIRGenerator as TCPIRGenerator).CPAddBreak();
  Result := Self;
end;

function TCPBuilder.CPAddContinue(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddContinue();
  (FIRGenerator as TCPIRGenerator).CPAddContinue();
  Result := Self;
end;

function TCPBuilder.CPAddEmptyStatement(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddEmptyStatement();
  (FIRGenerator as TCPIRGenerator).CPAddEmptyStatement();
  Result := Self;
end;


// Inline Assembly
function TCPBuilder.CPStartInlineAssembly(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartInlineAssembly();
  (FIRGenerator as TCPIRGenerator).CPStartInlineAssembly();
  Result := Self;
end;

function TCPBuilder.CPAddAssemblyLine(const AInstruction: string): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddAssemblyLine(AInstruction);
  (FIRGenerator as TCPIRGenerator).CPAddAssemblyLine(AInstruction);
  Result := Self;
end;

function TCPBuilder.CPAddAssemblyConstraint(const ATemplate: string; const AOutputs, AInputs, AClobbers: array of string): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddAssemblyConstraint(ATemplate, AOutputs, AInputs, AClobbers);
  (FIRGenerator as TCPIRGenerator).CPAddAssemblyConstraint(ATemplate, AOutputs, AInputs, AClobbers);
  Result := Self;
end;

function TCPBuilder.CPEndInlineAssembly(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPEndInlineAssembly();
  (FIRGenerator as TCPIRGenerator).CPEndInlineAssembly();
  Result := Self;
end;


// Structured Statements
function TCPBuilder.CPAddElse(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddElse();
  (FIRGenerator as TCPIRGenerator).CPAddElse();
  Result := Self;
end;

function TCPBuilder.CPEndIf(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPEndIf();
  (FIRGenerator as TCPIRGenerator).CPEndIf();
  Result := Self;
end;


function TCPBuilder.CPAddCaseLabel(const ALabels: array of ICPExpression): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddCaseLabel(ALabels);
  (FIRGenerator as TCPIRGenerator).CPAddCaseLabel(ALabels);
  Result := Self;
end;

function TCPBuilder.CPStartCaseElse(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartCaseElse();
  (FIRGenerator as TCPIRGenerator).CPStartCaseElse();
  Result := Self;
end;

function TCPBuilder.CPEndCase(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPEndCase();
  (FIRGenerator as TCPIRGenerator).CPEndCase();
  Result := Self;
end;


function TCPBuilder.CPEndWhile(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPEndWhile();
  (FIRGenerator as TCPIRGenerator).CPEndWhile();
  Result := Self;
end;


function TCPBuilder.CPStartFor(const AVariable: ICPIdentifier; const AStartValue, AEndValue: ICPExpression; const ADownTo: Boolean = False): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartFor(AVariable, AStartValue, AEndValue, ADownTo);
  (FIRGenerator as TCPIRGenerator).CPStartFor(AVariable, AStartValue, AEndValue, ADownTo);
  Result := Self;
end;

function TCPBuilder.CPEndFor(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPEndFor();
  (FIRGenerator as TCPIRGenerator).CPEndFor();
  Result := Self;
end;

function TCPBuilder.CPStartRepeat(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartRepeat();
  (FIRGenerator as TCPIRGenerator).CPStartRepeat();
  Result := Self;
end;

// === SAA Expression Factory Methods ===
// Identifier creation and validation
function TCPBuilder.CPIdentifier(const AName: string): ICPIdentifier;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPIdentifier(AName);
end;


// Specialized validation factory methods for compiler directives
function TCPBuilder.CPLibraryName(const AName: string): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPLibraryName(AName);
end;

function TCPBuilder.CPFilePath(const APath: string): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPFilePath(APath);
end;

function TCPBuilder.CPAppType(const AType: string): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPAppType(AType);
end;


// Type factory methods
function TCPBuilder.CPBuiltInType(const AType: TCPBuiltInType): ICPType;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPBuiltInType(AType);
end;


// Enhanced type system access (Builder-Centralized Pattern)
function TCPBuilder.CPGetTypeRegistry(): TCPTypeRegistry;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPGetTypeRegistry();
end;

function TCPBuilder.CPGetInt8Type(): ICPType;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPGetInt8Type();
end;

function TCPBuilder.CPGetInt16Type(): ICPType;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPGetInt16Type();
end;

function TCPBuilder.CPGetInt32Type(): ICPType;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPGetInt32Type();
end;

function TCPBuilder.CPGetInt64Type(): ICPType;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPGetInt64Type();
end;

function TCPBuilder.CPGetUInt8Type(): ICPType;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPGetUInt8Type();
end;

function TCPBuilder.CPGetUInt16Type(): ICPType;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPGetUInt16Type();
end;

function TCPBuilder.CPGetUInt32Type(): ICPType;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPGetUInt32Type();
end;

function TCPBuilder.CPGetUInt64Type(): ICPType;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPGetUInt64Type();
end;

function TCPBuilder.CPGetFloat32Type(): ICPType;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPGetFloat32Type();
end;

function TCPBuilder.CPGetFloat64Type(): ICPType;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPGetFloat64Type();
end;

function TCPBuilder.CPGetBooleanType(): ICPType;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPGetBooleanType();
end;

function TCPBuilder.CPGetStringType(): ICPType;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPGetStringType();
end;

function TCPBuilder.CPGetCharType(): ICPType;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPGetCharType();
end;


// Variable references
function TCPBuilder.CPVariable(const AName: ICPIdentifier): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPVariable(AName);
end;


// Literal value factories
function TCPBuilder.CPInt8(const AValue: Int8): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPInt8(AValue);
end;

function TCPBuilder.CPInt16(const AValue: Int16): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPInt16(AValue);
end;

function TCPBuilder.CPInt32(const AValue: Int32): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPInt32(AValue);
end;

function TCPBuilder.CPInt64(const AValue: Int64): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPInt64(AValue);
end;

function TCPBuilder.CPUInt8(const AValue: UInt8): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPUInt8(AValue);
end;

function TCPBuilder.CPUInt16(const AValue: UInt16): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPUInt16(AValue);
end;

function TCPBuilder.CPUInt32(const AValue: UInt32): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPUInt32(AValue);
end;

function TCPBuilder.CPUInt64(const AValue: UInt64): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPUInt64(AValue);
end;

function TCPBuilder.CPFloat32(const AValue: Single): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPFloat32(AValue);
end;

function TCPBuilder.CPFloat64(const AValue: Double): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPFloat64(AValue);
end;

function TCPBuilder.CPBoolean(const AValue: Boolean): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPBoolean(AValue);
end;

function TCPBuilder.CPString(const AValue: string): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPString(AValue);
end;

function TCPBuilder.CPChar(const AValue: Char): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPChar(AValue);
end;


// Expression composition
function TCPBuilder.CPBinaryOp(const ALeft: ICPExpression; const AOperator: TCPBinaryOperator; const ARight: ICPExpression): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPBinaryOp(ALeft, AOperator, ARight);
end;

function TCPBuilder.CPUnaryOp(const AOperator: TCPUnaryOperator; const AOperand: ICPExpression): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPUnaryOp(AOperator, AOperand);
end;

function TCPBuilder.CPTernaryOp(const ACondition: ICPExpression; const ATrueExpr: ICPExpression; const AFalseExpr: ICPExpression): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPTernaryOp(ACondition, ATrueExpr, AFalseExpr);
end;

function TCPBuilder.CPFunctionCall(const AFunctionName: ICPIdentifier; const AParameters: array of ICPExpression): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPFunctionCall(AFunctionName, AParameters);
end;

function TCPBuilder.CPArrayAccess(const AArray: ICPExpression; const AIndex: ICPExpression): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPArrayAccess(AArray, AIndex);
end;

function TCPBuilder.CPFieldAccess(const ARecord: ICPExpression; const AFieldName: ICPIdentifier): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPFieldAccess(ARecord, AFieldName);
end;

function TCPBuilder.CPTypecast(const AExpression: ICPExpression; const ATargetType: ICPType): ICPExpression;
begin
  Result := (FSourceGenerator as TCPSourceGenerator).CPTypecast(AExpression, ATargetType);
end;


// === SAA Statement Methods (Expression-Based) ===
function TCPBuilder.CPAddAssignment(const AVariable: ICPIdentifier; const AExpression: ICPExpression): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddAssignment(AVariable, AExpression);
  (FIRGenerator as TCPIRGenerator).CPAddAssignment(AVariable, AExpression);
  Result := Self;
end;

function TCPBuilder.CPAddProcedureCall(const AProcName: ICPIdentifier; const AParams: array of ICPExpression): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddProcedureCall(AProcName, AParams);
  (FIRGenerator as TCPIRGenerator).CPAddProcedureCall(AProcName, AParams);
  Result := Self;
end;

function TCPBuilder.CPStartIf(const ACondition: ICPExpression): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartIf(ACondition);
  (FIRGenerator as TCPIRGenerator).CPStartIf(ACondition);
  Result := Self;
end;

function TCPBuilder.CPStartCase(const AExpression: ICPExpression): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartCase(AExpression);
  (FIRGenerator as TCPIRGenerator).CPStartCase(AExpression);
  Result := Self;
end;

function TCPBuilder.CPStartWhile(const ACondition: ICPExpression): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartWhile(ACondition);
  (FIRGenerator as TCPIRGenerator).CPStartWhile(ACondition);
  Result := Self;
end;

function TCPBuilder.CPEndRepeat(const ACondition: ICPExpression): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPEndRepeat(ACondition);
  (FIRGenerator as TCPIRGenerator).CPEndRepeat(ACondition);
  Result := Self;
end;

function TCPBuilder.CPAddExit(const AExpression: ICPExpression): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddExit(AExpression);
  (FIRGenerator as TCPIRGenerator).CPAddExit(AExpression);
  Result := Self;
end;


// === Program Finalization ===
function TCPBuilder.CPEndProgram(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPEndProgram();
  (FIRGenerator as TCPIRGenerator).CPEndProgram();
  Result := Self;
end;

function TCPBuilder.CPEndLibrary(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPEndLibrary();
  (FIRGenerator as TCPIRGenerator).CPEndLibrary();
  Result := Self;
end;

function TCPBuilder.CPEndModule(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPEndModule();
  (FIRGenerator as TCPIRGenerator).CPEndModule();
  Result := Self;
end;

// === Utility Methods ===
function TCPBuilder.CPAddComment(const AComment: string; const AStyle: TCPCommentStyle = csLine): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddComment(AComment, AStyle);
  (FIRGenerator as TCPIRGenerator).CPAddComment(AComment, AStyle);
  Result := Self;
end;

function TCPBuilder.CPAddBlankLine(): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPAddBlankLine();
  (FIRGenerator as TCPIRGenerator).CPAddBlankLine();
  Result := Self;
end;

// Example delegation pattern:
function TCPBuilder.CPStartProgram(const AName: ICPIdentifier): ICPBuilder;
begin
  (FSourceGenerator as TCPSourceGenerator).CPStartProgram(AName);
  (FIRGenerator as TCPIRGenerator).CPStartProgram(AName);
  Result := Self;
end;

// === Factory Function Implementation ===
function CPCreateBuilder(): ICPBuilder;
begin
  Result := TCPBuilder.Create();
end;

end.
