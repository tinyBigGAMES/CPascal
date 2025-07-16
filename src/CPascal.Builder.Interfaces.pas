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

unit CPascal.Builder.Interfaces;

{$I CPascal.Defines.inc}

interface

uses
  System.Classes,
  System.SysUtils,
  System.Rtti,
  System.Generics.Collections,
  CPascal.Common,
  CPascal.Expressions;

type
  { TCPCommentStyle }
  TCPCommentStyle = (
    csLine,     // // comment
    csBlock,    // /* comment */
    csBrace     // { comment }
  );

  { TCPAppType }
  TCPAppType = (
    atConsole,    // Console application
    atWindows,    // Windows GUI application
    atService,    // Windows service
    atDLL         // Dynamic library
  );

  { ICPBuilder }
  ICPBuilder = interface
    ['{B8F7E2A1-4C3D-4F5E-9B8A-7D6E5C4F3B2A}']

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

  { ICPSourceGenerator }
  ICPSourceGenerator = interface
    ['{C9A8B3F2-5D4E-6F7A-8B9C-1E2F3A4B5C6D}']

    // === Compilation Unit Selection ===
    function CPStartProgram(const AName: ICPIdentifier): ICPSourceGenerator;
    function CPStartLibrary(const AName: ICPIdentifier): ICPSourceGenerator;
    function CPStartModule(const AName: ICPIdentifier): ICPSourceGenerator;

    // === Program Structure ===
    function CPAddImport(const AIdentifier: ICPIdentifier): ICPSourceGenerator;
    function CPAddImports(const AIdentifiers: array of string): ICPSourceGenerator;
    function CPAddExport(const AIdentifier: ICPIdentifier): ICPSourceGenerator;
    function CPAddExports(const AIdentifiers: array of string): ICPSourceGenerator;

    // === Compiler Directives ===
    function CPStartIfDef(const ASymbol: ICPIdentifier): ICPSourceGenerator;
    function CPStartIfNDef(const ASymbol: ICPIdentifier): ICPSourceGenerator;
    function CPAddDefine(const ASymbol: ICPIdentifier): ICPSourceGenerator; overload;
    function CPAddDefine(const ASymbol: ICPIdentifier; const AValue: string): ICPSourceGenerator; overload;
    function CPAddUndef(const ASymbol: ICPIdentifier): ICPSourceGenerator;
    function CPAddLink(const ALibrary: ICPExpression): ICPSourceGenerator;
    function CPAddLibPath(const APath: ICPExpression): ICPSourceGenerator;
    function CPSetAppType(const AAppType: ICPExpression): ICPSourceGenerator;
    function CPAddModulePath(const APath: ICPExpression): ICPSourceGenerator;
    function CPAddExePath(const APath: ICPExpression): ICPSourceGenerator;
    function CPAddObjPath(const APath: ICPExpression): ICPSourceGenerator;

    // === Declaration Sections ===
    function CPStartConstSection(const AIsPublic: Boolean = False): ICPSourceGenerator;
    function CPStartTypeSection(const AIsPublic: Boolean = False): ICPSourceGenerator;
    function CPStartVarSection(const AIsPublic: Boolean = False): ICPSourceGenerator;
    function CPStartLabelSection(): ICPSourceGenerator;

    // === Constant Declarations ===
    function CPAddConstant(const AName: string; const AValue: string; const AIsPublic: Boolean = False): ICPSourceGenerator;

    // === Type Declarations ===
    function CPAddTypeAlias(const AName, ATargetType: string; const AIsPublic: Boolean = False): ICPSourceGenerator;
    function CPAddForwardDeclaration(const AName, ATargetType: string; const AIsPublic: Boolean = False): ICPSourceGenerator;
    function CPAddPointerType(const AName, ATargetType: string; const AIsPublic: Boolean = False): ICPSourceGenerator;
    function CPAddArrayType(const AName, AIndexRange, AElementType: string; const AIsPublic: Boolean = False): ICPSourceGenerator;
    function CPAddEnumType(const AName: string; const AValues: array of string; const AIsPublic: Boolean = False): ICPSourceGenerator;
    function CPStartRecordType(const AName: string; const APacked: Boolean = False; const AIsPublic: Boolean = False): ICPSourceGenerator;
    function CPStartUnionType(const AName: string; const APacked: Boolean = False; const AIsPublic: Boolean = False): ICPSourceGenerator;
    function CPAddRecordField(const AFieldNames: array of string; const AFieldType: string): ICPSourceGenerator;
    function CPEndRecordType(): ICPSourceGenerator;
    function CPEndUnionType(): ICPSourceGenerator;
    function CPAddFunctionType(const AName: string; const AParams, AReturnType: string; const ACallingConv: string = ''; const AIsPublic: Boolean = False): ICPSourceGenerator;
    function CPAddProcedureType(const AName: string; const AParams: string; const ACallingConv: string = ''; const AIsPublic: Boolean = False): ICPSourceGenerator;

    // === Variable Declarations ===
    function CPAddVariable(const ANames: array of ICPIdentifier; const AType: TCPBuiltInType; const AIsPublic: Boolean = False): ICPSourceGenerator; overload;
    function CPAddVariable(const ANames: array of ICPIdentifier; const AType: ICPType; const AIsPublic: Boolean = False): ICPSourceGenerator; overload;
    function CPAddQualifiedVariable(const ANames: array of ICPIdentifier; const AQualifiers: string; const AType: TCPBuiltInType; const AIsPublic: Boolean = False): ICPSourceGenerator; overload;
    function CPAddQualifiedVariable(const ANames: array of ICPIdentifier; const AQualifiers: string; const AType: ICPType; const AIsPublic: Boolean = False): ICPSourceGenerator; overload;

    // === Label Declarations ===
    function CPAddLabels(const ALabels: array of string): ICPSourceGenerator;

    // === Function/Procedure Declarations ===
    function CPStartFunction(const AName: ICPIdentifier; const AReturnType: TCPBuiltInType; const AIsPublic: Boolean = False): ICPSourceGenerator; overload;
    function CPStartFunction(const AName: ICPIdentifier; const AReturnType: ICPType; const AIsPublic: Boolean = False): ICPSourceGenerator; overload;
    function CPStartProcedure(const AName: ICPIdentifier; const AIsPublic: Boolean = False): ICPSourceGenerator;
    function CPAddParameter(const ANames: array of ICPIdentifier; const AType: TCPBuiltInType; const AModifier: string = ''): ICPSourceGenerator; overload;
    function CPAddParameter(const ANames: array of ICPIdentifier; const AType: ICPType; const AModifier: string = ''): ICPSourceGenerator; overload;
    function CPAddVarArgsParameter(): ICPSourceGenerator;
    function CPSetCallingConvention(const AConvention: string): ICPSourceGenerator;
    function CPSetInline(const AInline: Boolean = True): ICPSourceGenerator;
    function CPSetExternal(const ALibrary: string = ''): ICPSourceGenerator;
    function CPStartFunctionBody(): ICPSourceGenerator;
    function CPEndFunction(): ICPSourceGenerator;
    function CPEndProcedure(): ICPSourceGenerator;

    // === Statement Construction ===
    function CPStartCompoundStatement(): ICPSourceGenerator;
    function CPEndCompoundStatement(): ICPSourceGenerator;
    function CPAddGoto(const ALabel: ICPIdentifier): ICPSourceGenerator;
    function CPAddLabel(const ALabel: ICPIdentifier): ICPSourceGenerator;
    function CPAddBreak(): ICPSourceGenerator;
    function CPAddContinue(): ICPSourceGenerator;
    function CPAddEmptyStatement(): ICPSourceGenerator;
    function CPStartInlineAssembly(): ICPSourceGenerator;
    function CPAddAssemblyLine(const AInstruction: string): ICPSourceGenerator;
    function CPAddAssemblyConstraint(const ATemplate: string; const AOutputs, AInputs, AClobbers: array of string): ICPSourceGenerator;
    function CPEndInlineAssembly(): ICPSourceGenerator;
    function CPAddElse(): ICPSourceGenerator;
    function CPEndIf(): ICPSourceGenerator;
    function CPAddCaseLabel(const ALabels: array of ICPExpression): ICPSourceGenerator;
    function CPStartCaseElse(): ICPSourceGenerator;
    function CPEndCase(): ICPSourceGenerator;
    function CPEndWhile(): ICPSourceGenerator;
    function CPStartFor(const AVariable: ICPIdentifier; const AStartValue, AEndValue: ICPExpression; const ADownTo: Boolean = False): ICPSourceGenerator;
    function CPEndFor(): ICPSourceGenerator;
    function CPStartRepeat(): ICPSourceGenerator;

    // === SAA Expression Factory Methods ===
    function CPIdentifier(const AName: string): ICPIdentifier;
    function CPLibraryName(const AName: string): ICPExpression;
    function CPFilePath(const APath: string): ICPExpression;
    function CPAppType(const AType: string): ICPExpression;
    function CPBuiltInType(const AType: TCPBuiltInType): ICPType;
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
    function CPVariable(const AName: ICPIdentifier): ICPExpression;
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
    function CPBinaryOp(const ALeft: ICPExpression; const AOperator: TCPBinaryOperator; const ARight: ICPExpression): ICPExpression;
    function CPUnaryOp(const AOperator: TCPUnaryOperator; const AOperand: ICPExpression): ICPExpression;
    function CPTernaryOp(const ACondition: ICPExpression; const ATrueExpr: ICPExpression; const AFalseExpr: ICPExpression): ICPExpression;
    function CPFunctionCall(const AFunctionName: ICPIdentifier; const AParameters: array of ICPExpression): ICPExpression;
    function CPArrayAccess(const AArray: ICPExpression; const AIndex: ICPExpression): ICPExpression;
    function CPFieldAccess(const ARecord: ICPExpression; const AFieldName: ICPIdentifier): ICPExpression;
    function CPTypecast(const AExpression: ICPExpression; const ATargetType: ICPType): ICPExpression;

    // === SAA Statement Methods ===
    function CPAddAssignment(const AVariable: ICPIdentifier; const AExpression: ICPExpression): ICPSourceGenerator;
    function CPAddProcedureCall(const AProcName: ICPIdentifier; const AParams: array of ICPExpression): ICPSourceGenerator;
    function CPStartIf(const ACondition: ICPExpression): ICPSourceGenerator;
    function CPStartCase(const AExpression: ICPExpression): ICPSourceGenerator;
    function CPStartWhile(const ACondition: ICPExpression): ICPSourceGenerator;
    function CPEndRepeat(const ACondition: ICPExpression): ICPSourceGenerator;
    function CPAddExit(const AExpression: ICPExpression): ICPSourceGenerator;

    // === Program Finalization ===
    function CPEndProgram(): ICPSourceGenerator;
    function CPEndLibrary(): ICPSourceGenerator;
    function CPEndModule(): ICPSourceGenerator;

    // === Utility Methods ===
    function CPAddComment(const AComment: string; const AStyle: TCPCommentStyle = csLine): ICPSourceGenerator;
    function CPAddBlankLine(): ICPSourceGenerator;
    function CPGetCurrentContext(): string;

    // === Source Generation ===
    function GenerateSource(const APrettyPrint: Boolean = True): string;
    procedure Reset();
  end;

  { ICPIRGenerator }
  ICPIRGenerator = interface
    ['{D1B2C3E4-6F5A-7B8C-9D0E-2F3A4B5C6D7E}']

    // === Compilation Unit Selection ===
    function CPStartProgram(const AName: ICPIdentifier): ICPIRGenerator;
    function CPStartLibrary(const AName: ICPIdentifier): ICPIRGenerator;
    function CPStartModule(const AName: ICPIdentifier): ICPIRGenerator;

    // === Program Structure ===
    function CPAddImport(const AIdentifier: ICPIdentifier): ICPIRGenerator;
    function CPAddImports(const AIdentifiers: array of string): ICPIRGenerator;
    function CPAddExport(const AIdentifier: ICPIdentifier): ICPIRGenerator;
    function CPAddExports(const AIdentifiers: array of string): ICPIRGenerator;

    // === Compiler Directives ===
    function CPStartIfDef(const ASymbol: ICPIdentifier): ICPIRGenerator;
    function CPStartIfNDef(const ASymbol: ICPIdentifier): ICPIRGenerator;
    function CPAddDefine(const ASymbol: ICPIdentifier): ICPIRGenerator; overload;
    function CPAddDefine(const ASymbol: ICPIdentifier; const AValue: string): ICPIRGenerator; overload;
    function CPAddUndef(const ASymbol: ICPIdentifier): ICPIRGenerator;
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
    function CPAddGoto(const ALabel: ICPIdentifier): ICPIRGenerator;
    function CPAddLabel(const ALabel: ICPIdentifier): ICPIRGenerator;
    function CPAddBreak(): ICPIRGenerator;
    function CPAddContinue(): ICPIRGenerator;
    function CPAddEmptyStatement(): ICPIRGenerator;
    function CPStartInlineAssembly(): ICPIRGenerator;
    function CPAddAssemblyLine(const AInstruction: string): ICPIRGenerator;
    function CPAddAssemblyConstraint(const ATemplate: string; const AOutputs, AInputs, AClobbers: array of string): ICPIRGenerator;
    function CPEndInlineAssembly(): ICPIRGenerator;
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
    function CPIdentifier(const AName: string): ICPIdentifier;
    function CPLibraryName(const AName: string): ICPExpression;
    function CPFilePath(const APath: string): ICPExpression;
    function CPAppType(const AType: string): ICPExpression;
    function CPBuiltInType(const AType: TCPBuiltInType): ICPType;
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
    function CPVariable(const AName: ICPIdentifier): ICPExpression;
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
    function CPBinaryOp(const ALeft: ICPExpression; const AOperator: TCPBinaryOperator; const ARight: ICPExpression): ICPExpression;
    function CPUnaryOp(const AOperator: TCPUnaryOperator; const AOperand: ICPExpression): ICPExpression;
    function CPTernaryOp(const ACondition: ICPExpression; const ATrueExpr: ICPExpression; const AFalseExpr: ICPExpression): ICPExpression;
    function CPFunctionCall(const AFunctionName: ICPIdentifier; const AParameters: array of ICPExpression): ICPExpression;
    function CPArrayAccess(const AArray: ICPExpression; const AIndex: ICPExpression): ICPExpression;
    function CPFieldAccess(const ARecord: ICPExpression; const AFieldName: ICPIdentifier): ICPExpression;
    function CPTypecast(const AExpression: ICPExpression; const ATargetType: ICPType): ICPExpression;

    // === SAA Statement Methods ===
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

    // === IR Generation ===
    function GenerateIR(): string;
    procedure Reset();
  end;

implementation

end.
