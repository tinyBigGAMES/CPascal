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

unit CPascal.Builder.Source;

{$I CPascal.Defines.inc}

interface

uses
  System.Classes,
  System.SysUtils,
  System.Rtti,
  System.Generics.Collections,
  CPascal.Common,
  CPascal.Expressions,
  CPascal.Builder.Interfaces;

type
  { TCPSourceGenerator }
  TCPSourceGenerator = class(TInterfacedObject, ICPSourceGenerator)
  private
    FSourceBuilder: TStringBuilder;
    FIndentLevel: Integer;
    FCurrentContext: string;
    FCurrentFunctionName: string;
    FCurrentFunctionParameters: TStringBuilder;
    FInFunctionDeclaration: Boolean;
    FCurrentCallingConvention: string;
    FCurrentInline: Boolean;
    FCurrentExternal: string;
    FInCompilerDirective: Boolean;

    // Variable symbol table for proper type lookup
    FDeclaredVariables: TDictionary<string, ICPType>;

    // Helper methods for source generation
    procedure AppendLine(const AText: string);
    procedure AppendIndentedLine(const AText: string);
    {$HINTS OFF}
    procedure AppendIndented(const AText: string);
    {$HINTS ON}
    procedure AppendToCurrentLine(const AText: string);

    procedure ResetIndent();
    procedure IncreaseIndent();
    procedure DecreaseIndent();
    function  GetIndentString(): string;

    // Symbol table management
    procedure AddVariableToSymbolTable(const AName: string; const AType: ICPType);
  public
    constructor Create();
    destructor Destroy(); override;

    // ICPSourceGenerator implementation
    function GenerateSource(const APrettyPrint: Boolean = True): string;
    procedure Reset();

    // === [COPY ALL METHOD DECLARATIONS FROM TCPBuilder PUBLIC SECTION] ===
    // [Copy all method declarations except GetCPas, GetIR, CPReset]

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
    // Conditional compilation directives
    function CPStartIfDef(const ASymbol: ICPIdentifier): ICPSourceGenerator;
    function CPStartIfNDef(const ASymbol: ICPIdentifier): ICPSourceGenerator;
    // Note: CPAddElse() and CPEndIf() are in Structured Statements section

    // Symbol management directives
    function CPAddDefine(const ASymbol: ICPIdentifier): ICPSourceGenerator; overload;
    function CPAddDefine(const ASymbol: ICPIdentifier; const AValue: string): ICPSourceGenerator; overload;
    function CPAddUndef(const ASymbol: ICPIdentifier): ICPSourceGenerator;

    // Linking directives
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

    // Simple Statements
    function CPAddGoto(const ALabel: ICPIdentifier): ICPSourceGenerator;
    function CPAddLabel(const ALabel: ICPIdentifier): ICPSourceGenerator;
    function CPAddBreak(): ICPSourceGenerator;
    function CPAddContinue(): ICPSourceGenerator;
    function CPAddEmptyStatement(): ICPSourceGenerator;

    // Inline Assembly
    function CPStartInlineAssembly(): ICPSourceGenerator;
    function CPAddAssemblyLine(const AInstruction: string): ICPSourceGenerator;
    function CPAddAssemblyConstraint(const ATemplate: string; const AOutputs, AInputs, AClobbers: array of string): ICPSourceGenerator;
    function CPEndInlineAssembly(): ICPSourceGenerator;

    // Structured Statements
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
  end;

implementation

// === [COPY ALL IMPLEMENTATIONS FROM TCPBuilder] ===
// [Copy constructor, destructor, all helper methods, and all method implementations]
// [Replace GetCPas with GenerateSource]
// [Remove GetIR implementation]
// [Replace CPReset with Reset]

constructor TCPSourceGenerator.Create();
begin
  inherited Create();
  FSourceBuilder := TStringBuilder.Create();
  FCurrentFunctionParameters := TStringBuilder.Create();
  FDeclaredVariables := TDictionary<string, ICPType>.Create();
  ResetIndent();
  FCurrentContext := '';
  FCurrentFunctionName := '';
  FInFunctionDeclaration := False;
  FCurrentCallingConvention := '';
  FCurrentInline := False;
  FCurrentExternal := '';
  FInCompilerDirective := False;
end;



destructor TCPSourceGenerator.Destroy();
begin
  FSourceBuilder.Free();
  FCurrentFunctionParameters.Free();
  FDeclaredVariables.Free();
  inherited Destroy();
end;

// === Helper Methods Implementation ===
procedure TCPSourceGenerator.AddVariableToSymbolTable(const AName: string; const AType: ICPType);
begin
  // Add variable to symbol table for type lookup
  FDeclaredVariables.AddOrSetValue(AName, AType);
end;


procedure TCPSourceGenerator.AppendLine(const AText: string);
begin
  FSourceBuilder.AppendLine(AText);
end;


procedure TCPSourceGenerator.AppendIndentedLine(const AText: string);
begin
  FSourceBuilder.AppendLine(GetIndentString() + AText);
end;


procedure TCPSourceGenerator.AppendIndented(const AText: string);
begin
  FSourceBuilder.Append(GetIndentString() + AText);
end;


procedure TCPSourceGenerator.AppendToCurrentLine(const AText: string);
begin
  FSourceBuilder.Append(AText);
end;


procedure TCPSourceGenerator.ResetIndent();
begin
  FIndentLevel := 0;
end;

procedure TCPSourceGenerator.IncreaseIndent();
begin
  Inc(FIndentLevel);
end;


procedure TCPSourceGenerator.DecreaseIndent();
begin
  if FIndentLevel > 0 then
    Dec(FIndentLevel);
end;


function TCPSourceGenerator.GetIndentString(): string;
begin
  Result := StringOfChar(' ', FIndentLevel * 2); // 2 spaces per indent level
end;

// === Main Method Implementations ===


function TCPSourceGenerator.CPStartProgram(const AName: ICPIdentifier): ICPSourceGenerator;
begin
  AppendLine(Format('program %s;', [AName.GetName()]));
  AppendLine('');
  FCurrentContext := 'program';
  Result := Self;
end;


function TCPSourceGenerator.CPStartLibrary(const AName: ICPIdentifier): ICPSourceGenerator;
begin
  AppendLine(Format('library %s;', [AName.GetName()]));
  AppendLine('');
  FCurrentContext := 'library';
  Result := Self;
end;


function TCPSourceGenerator.CPStartModule(const AName: ICPIdentifier): ICPSourceGenerator;
begin
  AppendLine(Format('module %s;', [AName.GetName()]));
  AppendLine('');
  FCurrentContext := 'module';
  Result := Self;
end;


function TCPSourceGenerator.CPAddImport(const AIdentifier: ICPIdentifier): ICPSourceGenerator;
begin
  AppendLine(Format('import %s;', [AIdentifier.GetName()]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddImports(const AIdentifiers: array of string): ICPSourceGenerator;
var
  LIdentifierList: string;
  LIdentifier: string;
begin
  if Length(AIdentifiers) = 0 then
  begin
    Result := Self;
    Exit;
  end;

  // Build comma-separated list of qualified identifiers
  LIdentifierList := '';
  for LIdentifier in AIdentifiers do
  begin
    if LIdentifierList <> '' then
      LIdentifierList := LIdentifierList + ', ';
    LIdentifierList := LIdentifierList + LIdentifier;
  end;

  AppendLine(Format('import %s;', [LIdentifierList]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddExport(const AIdentifier: ICPIdentifier): ICPSourceGenerator;
begin
  AppendLine(Format('export %s;', [AIdentifier.GetName()]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddExports(const AIdentifiers: array of string): ICPSourceGenerator;
var
  LIdentifierList: string;
  LIdentifier: string;
begin
  if Length(AIdentifiers) = 0 then
  begin
    Result := Self;
    Exit;
  end;

  // Build comma-separated list of qualified identifiers
  LIdentifierList := '';
  for LIdentifier in AIdentifiers do
  begin
    if LIdentifierList <> '' then
      LIdentifierList := LIdentifierList + ', ';
    LIdentifierList := LIdentifierList + LIdentifier;
  end;

  AppendLine(Format('export %s;', [LIdentifierList]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddDefine(const ASymbol: ICPIdentifier): ICPSourceGenerator;
begin
  // Generate symbol definition directive
  AppendIndentedLine(Format('{$DEFINE %s}', [ASymbol.GetName()]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddDefine(const ASymbol: ICPIdentifier; const AValue: string): ICPSourceGenerator;
begin
  // Generate symbol definition directive with value
  AppendIndentedLine(Format('{$DEFINE %s %s}', [ASymbol.GetName(), AValue]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddUndef(const ASymbol: ICPIdentifier): ICPSourceGenerator;
begin
  // Generate symbol undefinition directive
  AppendIndentedLine(Format('{$UNDEF %s}', [ASymbol.GetName()]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddLink(const ALibrary: ICPExpression): ICPSourceGenerator;
begin
  // Generate linking directive using validated library name
  AppendIndentedLine(Format('{$LINK %s}', [ALibrary.GetCPas()]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddLibPath(const APath: ICPExpression): ICPSourceGenerator;
begin
  // Generate library path directive using validated path
  AppendIndentedLine(Format('{$LIBPATH %s}', [APath.GetCPas()]));
  Result := Self;
end;


function TCPSourceGenerator.CPStartIfDef(const ASymbol: ICPIdentifier): ICPSourceGenerator;
begin
  // Generate conditional compilation directive
  AppendIndentedLine(Format('{$IFDEF %s}', [ASymbol.GetName()]));
  IncreaseIndent();
  FInCompilerDirective := True;
  Result := Self;
end;


function TCPSourceGenerator.CPStartIfNDef(const ASymbol: ICPIdentifier): ICPSourceGenerator;
begin
  // Generate conditional compilation directive (if not defined)
  AppendIndentedLine(Format('{$IFNDEF %s}', [ASymbol.GetName()]));
  IncreaseIndent();
  FInCompilerDirective := True;
  Result := Self;
end;


function TCPSourceGenerator.CPSetAppType(const AAppType: ICPExpression): ICPSourceGenerator;
begin
  // Generate application type directive using validated app type
  AppendIndentedLine(Format('{$APPTYPE %s}', [AAppType.GetCPas()]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddModulePath(const APath: ICPExpression): ICPSourceGenerator;
begin
  // Generate module path directive using validated path
  AppendIndentedLine(Format('{$MODULEPATH %s}', [APath.GetCPas()]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddExePath(const APath: ICPExpression): ICPSourceGenerator;
begin
  // Generate executable path directive using validated path
  AppendIndentedLine(Format('{$EXEPATH %s}', [APath.GetCPas()]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddObjPath(const APath: ICPExpression): ICPSourceGenerator;
begin
  // Generate object path directive using validated path
  AppendIndentedLine(Format('{$OBJPATH %s}', [APath.GetCPas()]));
  Result := Self;
end;


function TCPSourceGenerator.CPStartConstSection(const AIsPublic: Boolean): ICPSourceGenerator;
begin
  // Reset indentation to base level for declaration sections
  ResetIndent();

  if AIsPublic then
    AppendLine('public const')
  else
    AppendLine('const');
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPStartTypeSection(const AIsPublic: Boolean): ICPSourceGenerator;
begin
  // Reset indentation to base level for declaration sections
  ResetIndent();

  if AIsPublic then
    AppendLine('public type')
  else
    AppendLine('type');
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPStartVarSection(const AIsPublic: Boolean): ICPSourceGenerator;
begin
  // Reset indentation to base level for declaration sections
  ResetIndent();

  if AIsPublic then
    AppendLine('public var')
  else
    AppendLine('var');
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPStartLabelSection(): ICPSourceGenerator;
begin
  // Reset indentation to base level for declaration sections
  ResetIndent();

  AppendLine('label');
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPAddConstant(const AName: string; const AValue: string; const AIsPublic: Boolean): ICPSourceGenerator;
begin
  // Generate constant declaration: NAME = value;
  AppendIndentedLine(Format('%s = %s;', [AName, AValue]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddTypeAlias(const AName, ATargetType: string; const AIsPublic: Boolean): ICPSourceGenerator;
begin
  // Generate type alias: TMyType = TargetType;
  AppendIndentedLine(Format('%s = %s;', [AName, ATargetType]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddForwardDeclaration(const AName, ATargetType: string; const AIsPublic: Boolean): ICPSourceGenerator;
begin
  // Generate forward type declaration: TMyType = class; or TMyType = record;
  AppendIndentedLine(Format('%s = %s;', [AName, ATargetType]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddPointerType(const AName, ATargetType: string; const AIsPublic: Boolean): ICPSourceGenerator;
begin
  // Generate pointer type: PMyType = ^TargetType;
  AppendIndentedLine(Format('%s = ^%s;', [AName, ATargetType]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddArrayType(const AName, AIndexRange, AElementType: string; const AIsPublic: Boolean): ICPSourceGenerator;
begin
  // Generate array type: TMyArray = array[0..255] of ElementType;
  AppendIndentedLine(Format('%s = array[%s] of %s;', [AName, AIndexRange, AElementType]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddEnumType(const AName: string; const AValues: array of string; const AIsPublic: Boolean): ICPSourceGenerator;
var
  LValuesList: string;
  LValue: string;
begin
  // Build comma-separated list of enum values
  LValuesList := '';
  for LValue in AValues do
  begin
    if LValuesList <> '' then
      LValuesList := LValuesList + ', ';
    LValuesList := LValuesList + LValue;
  end;

  // Generate enum type: TMyEnum = (value1, value2, value3);
  AppendIndentedLine(Format('%s = (%s);', [AName, LValuesList]));
  Result := Self;
end;


function TCPSourceGenerator.CPStartRecordType(const AName: string; const APacked: Boolean; const AIsPublic: Boolean): ICPSourceGenerator;
begin
  // Generate record type start: TMyRecord = packed record or TMyRecord = record
  if APacked then
    AppendIndentedLine(Format('%s = packed record', [AName]))
  else
    AppendIndentedLine(Format('%s = record', [AName]));
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPStartUnionType(const AName: string; const APacked: Boolean; const AIsPublic: Boolean): ICPSourceGenerator;
begin
  // Generate union type start: TMyUnion = packed union or TMyUnion = union
  if APacked then
    AppendIndentedLine(Format('%s = packed union', [AName]))
  else
    AppendIndentedLine(Format('%s = union', [AName]));
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPAddRecordField(const AFieldNames: array of string; const AFieldType: string): ICPSourceGenerator;
var
  LFieldsList: string;
  LField: string;
begin
  if Length(AFieldNames) = 0 then
  begin
    Result := Self;
    Exit;
  end;

  // Build comma-separated list of field names
  LFieldsList := '';
  for LField in AFieldNames do
  begin
    if LFieldsList <> '' then
      LFieldsList := LFieldsList + ', ';
    LFieldsList := LFieldsList + LField;
  end;

  // Generate record field: field1, field2: FieldType;
  AppendIndentedLine(Format('%s: %s;', [LFieldsList, AFieldType]));
  Result := Self;
end;


function TCPSourceGenerator.CPEndRecordType(): ICPSourceGenerator;
begin
  // End record type declaration
  DecreaseIndent();
  AppendIndentedLine('end;');
  Result := Self;
end;


function TCPSourceGenerator.CPEndUnionType(): ICPSourceGenerator;
begin
  // End union type declaration
  DecreaseIndent();
  AppendIndentedLine('end;');
  Result := Self;
end;


function TCPSourceGenerator.CPAddFunctionType(const AName: string; const AParams, AReturnType: string; const ACallingConv: string; const AIsPublic: Boolean): ICPSourceGenerator;
var
  LTypeDecl: string;
begin
  // Build function type declaration
  if AParams <> '' then
    LTypeDecl := Format('%s = function(%s): %s', [AName, AParams, AReturnType])
  else
    LTypeDecl := Format('%s = function(): %s', [AName, AReturnType]);

  // Add calling convention if specified
  if ACallingConv <> '' then
    LTypeDecl := LTypeDecl + '; ' + ACallingConv;

  // Generate function type: TMyFunc = function(params): ReturnType; convention;
  AppendIndentedLine(LTypeDecl + ';');
  Result := Self;
end;


function TCPSourceGenerator.CPAddProcedureType(const AName: string; const AParams: string; const ACallingConv: string; const AIsPublic: Boolean): ICPSourceGenerator;
var
  LTypeDecl: string;
begin
  // Build procedure type declaration
  if AParams <> '' then
    LTypeDecl := Format('%s = procedure(%s)', [AName, AParams])
  else
    LTypeDecl := Format('%s = procedure()', [AName]);

  // Add calling convention if specified
  if ACallingConv <> '' then
    LTypeDecl := LTypeDecl + '; ' + ACallingConv;

  // Generate procedure type: TMyProc = procedure(params); convention;
  AppendIndentedLine(LTypeDecl + ';');
  Result := Self;
end;


function TCPSourceGenerator.CPAddVariable(const ANames: array of ICPIdentifier; const AType: TCPBuiltInType; const AIsPublic: Boolean): ICPSourceGenerator;
var
  LNamesList: string;
  LName: ICPIdentifier;
  LTypeStr: string;
  LICPType: ICPType;
begin
  // Build comma-separated list of variable names
  LNamesList := '';
  for LName in ANames do
  begin
    if LNamesList <> '' then
      LNamesList := LNamesList + ', ';
    LNamesList := LNamesList + LName.GetName();
  end;

  // Convert built-in type to string and get ICPType
  case AType of
    cptInt8:    begin LTypeStr := 'Int8'; LICPType := CPGetInt8Type(); end;
    cptInt16:   begin LTypeStr := 'Int16'; LICPType := CPGetInt16Type(); end;
    cptInt32:   begin LTypeStr := 'Int32'; LICPType := CPGetInt32Type(); end;
    cptInt64:   begin LTypeStr := 'Int64'; LICPType := CPGetInt64Type(); end;
    cptUInt8:   begin LTypeStr := 'UInt8'; LICPType := CPGetUInt8Type(); end;
    cptUInt16:  begin LTypeStr := 'UInt16'; LICPType := CPGetUInt16Type(); end;
    cptUInt32:  begin LTypeStr := 'UInt32'; LICPType := CPGetUInt32Type(); end;
    cptUInt64:  begin LTypeStr := 'UInt64'; LICPType := CPGetUInt64Type(); end;
    cptFloat32: begin LTypeStr := 'Float32'; LICPType := CPGetFloat32Type(); end;
    cptFloat64: begin LTypeStr := 'Float64'; LICPType := CPGetFloat64Type(); end;
    cptBoolean: begin LTypeStr := 'Boolean'; LICPType := CPGetBooleanType(); end;
    cptString:  begin LTypeStr := 'string'; LICPType := CPGetStringType(); end;
    cptChar:    begin LTypeStr := 'Char'; LICPType := CPGetCharType(); end;
  else
    raise ECPException.Create('Invalid built-in type: %d', [Ord(AType)]);
  end;

  // Add each variable to symbol table
  for LName in ANames do
    AddVariableToSymbolTable(LName.GetName(), LICPType);

  // Generate variable declaration
  AppendIndentedLine(Format('%s: %s;', [LNamesList, LTypeStr]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddVariable(const ANames: array of ICPIdentifier; const AType: ICPType; const AIsPublic: Boolean): ICPSourceGenerator;
var
  LNamesList: string;
  LName: ICPIdentifier;
  LTypeStr: string;
begin
  // Build comma-separated list of variable names
  LNamesList := '';
  for LName in ANames do
  begin
    if LNamesList <> '' then
      LNamesList := LNamesList + ', ';
    LNamesList := LNamesList + LName.GetName();
  end;

  // Safely get type name with error checking
  if AType = nil then
    raise ECPException.Create('Type parameter cannot be nil', []);

  LTypeStr := AType.GetName();
  if LTypeStr = '' then
    raise ECPException.Create('Type name cannot be empty', []);

  // Add each variable to symbol table
  for LName in ANames do
    AddVariableToSymbolTable(LName.GetName(), AType);

  // Generate variable declaration using safe type string
  AppendIndentedLine(Format('%s: %s;', [LNamesList, LTypeStr]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddQualifiedVariable(const ANames: array of ICPIdentifier; const AQualifiers: string; const AType: TCPBuiltInType; const AIsPublic: Boolean): ICPSourceGenerator;
var
  LNamesList: string;
  LName: ICPIdentifier;
  LTypeStr: string;
  LICPType: ICPType;
begin
  // Build comma-separated list of variable names
  LNamesList := '';
  for LName in ANames do
  begin
    if LNamesList <> '' then
      LNamesList := LNamesList + ', ';
    LNamesList := LNamesList + LName.GetName();
  end;

  // Convert built-in type to string and get ICPType
  case AType of
    cptInt8:    begin LTypeStr := 'Int8'; LICPType := CPGetInt8Type(); end;
    cptInt16:   begin LTypeStr := 'Int16'; LICPType := CPGetInt16Type(); end;
    cptInt32:   begin LTypeStr := 'Int32'; LICPType := CPGetInt32Type(); end;
    cptInt64:   begin LTypeStr := 'Int64'; LICPType := CPGetInt64Type(); end;
    cptUInt8:   begin LTypeStr := 'UInt8'; LICPType := CPGetUInt8Type(); end;
    cptUInt16:  begin LTypeStr := 'UInt16'; LICPType := CPGetUInt16Type(); end;
    cptUInt32:  begin LTypeStr := 'UInt32'; LICPType := CPGetUInt32Type(); end;
    cptUInt64:  begin LTypeStr := 'UInt64'; LICPType := CPGetUInt64Type(); end;
    cptFloat32: begin LTypeStr := 'Float32'; LICPType := CPGetFloat32Type(); end;
    cptFloat64: begin LTypeStr := 'Float64'; LICPType := CPGetFloat64Type(); end;
    cptBoolean: begin LTypeStr := 'Boolean'; LICPType := CPGetBooleanType(); end;
    cptString:  begin LTypeStr := 'string'; LICPType := CPGetStringType(); end;
    cptChar:    begin LTypeStr := 'Char'; LICPType := CPGetCharType(); end;
  else
    raise ECPException.Create('Invalid built-in type: %d', [Ord(AType)]);
  end;

  // Add each variable to symbol table
  for LName in ANames do
    AddVariableToSymbolTable(LName.GetName(), LICPType);

  // Generate qualified variable declaration: qualifiers name1, name2: Type;
  if AQualifiers <> '' then
    AppendIndentedLine(Format('%s %s: %s;', [AQualifiers, LNamesList, LTypeStr]))
  else
    AppendIndentedLine(Format('%s: %s;', [LNamesList, LTypeStr]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddQualifiedVariable(const ANames: array of ICPIdentifier; const AQualifiers: string; const AType: ICPType; const AIsPublic: Boolean): ICPSourceGenerator;
var
  LNamesList: string;
  LName: ICPIdentifier;
  LTypeStr: string;
begin
  // Build comma-separated list of variable names
  LNamesList := '';
  for LName in ANames do
  begin
    if LNamesList <> '' then
      LNamesList := LNamesList + ', ';
    LNamesList := LNamesList + LName.GetName();
  end;

  // Safely get type name with error checking
  if AType = nil then
    raise ECPException.Create('Type parameter cannot be nil', []);

  LTypeStr := AType.GetName();
  if LTypeStr = '' then
    raise ECPException.Create('Type name cannot be empty', []);

  // Add each variable to symbol table
  for LName in ANames do
    AddVariableToSymbolTable(LName.GetName(), AType);

  // Generate qualified variable declaration: qualifiers name1, name2: Type;
  if AQualifiers <> '' then
    AppendIndentedLine(Format('%s %s: %s;', [AQualifiers, LNamesList, LTypeStr]))
  else
    AppendIndentedLine(Format('%s: %s;', [LNamesList, LTypeStr]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddLabels(const ALabels: array of string): ICPSourceGenerator;
var
  LLabelsList: string;
  LLabel: string;
begin
  if Length(ALabels) = 0 then
  begin
    Result := Self;
    Exit;
  end;

  // Build comma-separated list of labels
  LLabelsList := '';
  for LLabel in ALabels do
  begin
    if LLabelsList <> '' then
      LLabelsList := LLabelsList + ', ';
    LLabelsList := LLabelsList + LLabel;
  end;

  // Generate label declaration: label1, label2, label3;
  AppendIndentedLine(Format('%s;', [LLabelsList]));
  Result := Self;
end;


function TCPSourceGenerator.CPStartFunction(const AName: ICPIdentifier; const AReturnType: TCPBuiltInType; const AIsPublic: Boolean): ICPSourceGenerator;
var
  LTypeStr: string;
begin
  // Reset indentation to base level for function declarations
  ResetIndent();

  // Convert built-in type to string
  case AReturnType of
    cptInt8:    LTypeStr := 'Int8';
    cptInt16:   LTypeStr := 'Int16';
    cptInt32:   LTypeStr := 'Int32';
    cptInt64:   LTypeStr := 'Int64';
    cptUInt8:   LTypeStr := 'UInt8';
    cptUInt16:  LTypeStr := 'UInt16';
    cptUInt32:  LTypeStr := 'UInt32';
    cptUInt64:  LTypeStr := 'UInt64';
    cptFloat32: LTypeStr := 'Float32';
    cptFloat64: LTypeStr := 'Float64';
    cptBoolean: LTypeStr := 'Boolean';
    cptString:  LTypeStr := 'string';
    cptChar:    LTypeStr := 'Char';
  else
    raise ECPException.Create('Invalid built-in type: %d', [Ord(AReturnType)]);
  end;

  // Initialize function declaration state
  FCurrentFunctionName := AName.GetName();
  FCurrentFunctionParameters.Clear();
  FInFunctionDeclaration := True;

  // Start function declaration (parameters will be added separately)
  if AIsPublic then
    AppendToCurrentLine(Format('public function %s', [AName.GetName()]))
  else
    AppendToCurrentLine(Format('function %s', [AName.GetName()]));

  // Store return type for later completion
  FCurrentContext := 'function:' + LTypeStr;
  Result := Self;
end;


function TCPSourceGenerator.CPStartFunction(const AName: ICPIdentifier; const AReturnType: ICPType; const AIsPublic: Boolean): ICPSourceGenerator;
var
  LTypeStr: string;
begin
  // Reset indentation to base level for function declarations
  ResetIndent();

  // Safely get type name with error checking
  if AReturnType = nil then
    raise ECPException.Create('Return type parameter cannot be nil', []);

  LTypeStr := AReturnType.GetName();
  if LTypeStr = '' then
    raise ECPException.Create('Return type name cannot be empty', []);

  // Initialize function declaration state
  FCurrentFunctionName := AName.GetName();
  FCurrentFunctionParameters.Clear();
  FInFunctionDeclaration := True;

  // Start function declaration (parameters will be added separately)
  if AIsPublic then
    AppendToCurrentLine(Format('public function %s', [AName.GetName()]))
  else
    AppendToCurrentLine(Format('function %s', [AName.GetName()]));

  // Store return type for later completion
  FCurrentContext := 'function:' + LTypeStr;
  Result := Self;
end;


function TCPSourceGenerator.CPStartProcedure(const AName: ICPIdentifier; const AIsPublic: Boolean): ICPSourceGenerator;
begin
  // Reset indentation to base level for procedure declarations
  ResetIndent();

  // Initialize procedure declaration state
  FCurrentFunctionName := AName.GetName();
  FCurrentFunctionParameters.Clear();
  FInFunctionDeclaration := True;

  // Start procedure declaration (parameters will be added separately)
  if AIsPublic then
    AppendToCurrentLine(Format('public procedure %s', [AName.GetName()]))
  else
    AppendToCurrentLine(Format('procedure %s', [AName.GetName()]));

  // Store context (no return type for procedures)
  FCurrentContext := 'procedure';
  Result := Self;
end;


function TCPSourceGenerator.CPAddParameter(const ANames: array of ICPIdentifier; const AType: TCPBuiltInType; const AModifier: string): ICPSourceGenerator;
var
  LNamesList: string;
  LName: ICPIdentifier;
  LTypeStr: string;
  LParamDecl: string;
  LICPType: ICPType;
begin
  if not FInFunctionDeclaration then
    raise ECPException.Create('CPAddParameter can only be called during function/procedure declaration', []);

  // Build comma-separated list of parameter names
  LNamesList := '';
  for LName in ANames do
  begin
    if LNamesList <> '' then
      LNamesList := LNamesList + ', ';
    LNamesList := LNamesList + LName.GetName();
  end;

  // Convert built-in type to string and get ICPType
  case AType of
    cptInt8:    begin LTypeStr := 'Int8'; LICPType := CPGetInt8Type(); end;
    cptInt16:   begin LTypeStr := 'Int16'; LICPType := CPGetInt16Type(); end;
    cptInt32:   begin LTypeStr := 'Int32'; LICPType := CPGetInt32Type(); end;
    cptInt64:   begin LTypeStr := 'Int64'; LICPType := CPGetInt64Type(); end;
    cptUInt8:   begin LTypeStr := 'UInt8'; LICPType := CPGetUInt8Type(); end;
    cptUInt16:  begin LTypeStr := 'UInt16'; LICPType := CPGetUInt16Type(); end;
    cptUInt32:  begin LTypeStr := 'UInt32'; LICPType := CPGetUInt32Type(); end;
    cptUInt64:  begin LTypeStr := 'UInt64'; LICPType := CPGetUInt64Type(); end;
    cptFloat32: begin LTypeStr := 'Float32'; LICPType := CPGetFloat32Type(); end;
    cptFloat64: begin LTypeStr := 'Float64'; LICPType := CPGetFloat64Type(); end;
    cptBoolean: begin LTypeStr := 'Boolean'; LICPType := CPGetBooleanType(); end;
    cptString:  begin LTypeStr := 'string'; LICPType := CPGetStringType(); end;
    cptChar:    begin LTypeStr := 'Char'; LICPType := CPGetCharType(); end;
  else
    raise ECPException.Create('Invalid built-in type: %d', [Ord(AType)]);
  end;

  // Add each parameter to symbol table
  for LName in ANames do
    AddVariableToSymbolTable(LName.GetName(), LICPType);

  // Build parameter declaration
  if AModifier <> '' then
    LParamDecl := Format('%s %s: %s', [AModifier, LNamesList, LTypeStr])
  else
    LParamDecl := Format('%s: %s', [LNamesList, LTypeStr]);

  // Add parameter to the parameter list
  if FCurrentFunctionParameters.Length > 0 then
    FCurrentFunctionParameters.Append('; ');
  FCurrentFunctionParameters.Append(LParamDecl);

  Result := Self;
end;


function TCPSourceGenerator.CPAddParameter(const ANames: array of ICPIdentifier; const AType: ICPType; const AModifier: string): ICPSourceGenerator;
var
  LNamesList: string;
  LName: ICPIdentifier;
  LTypeStr: string;
  LParamDecl: string;
begin
  if not FInFunctionDeclaration then
    raise ECPException.Create('CPAddParameter can only be called during function/procedure declaration', []);

  // Build comma-separated list of parameter names
  LNamesList := '';
  for LName in ANames do
  begin
    if LNamesList <> '' then
      LNamesList := LNamesList + ', ';
    LNamesList := LNamesList + LName.GetName();
  end;

  // Safely get type name with error checking
  if AType = nil then
    raise ECPException.Create('Type parameter cannot be nil', []);

  LTypeStr := AType.GetName();
  if LTypeStr = '' then
    raise ECPException.Create('Type name cannot be empty', []);

  // Add each parameter to symbol table
  for LName in ANames do
    AddVariableToSymbolTable(LName.GetName(), AType);

  // Build parameter declaration
  if AModifier <> '' then
    LParamDecl := Format('%s %s: %s', [AModifier, LNamesList, LTypeStr])
  else
    LParamDecl := Format('%s: %s', [LNamesList, LTypeStr]);

  // Add parameter to the parameter list
  if FCurrentFunctionParameters.Length > 0 then
    FCurrentFunctionParameters.Append('; ');
  FCurrentFunctionParameters.Append(LParamDecl);

  Result := Self;
end;


function TCPSourceGenerator.CPAddVarArgsParameter(): ICPSourceGenerator;
begin
  if not FInFunctionDeclaration then
    raise ECPException.Create('CPAddVarArgsParameter can only be called during function/procedure declaration', []);

  // Add varargs parameter to the parameter list
  if FCurrentFunctionParameters.Length > 0 then
    FCurrentFunctionParameters.Append('; ');
  FCurrentFunctionParameters.Append('...');

  Result := Self;
end;


function TCPSourceGenerator.CPSetCallingConvention(const AConvention: string): ICPSourceGenerator;
begin
  if not FInFunctionDeclaration then
    raise ECPException.Create('CPSetCallingConvention can only be called during function/procedure declaration', []);

  FCurrentCallingConvention := AConvention;
  Result := Self;
end;


function TCPSourceGenerator.CPSetInline(const AInline: Boolean): ICPSourceGenerator;
begin
  if not FInFunctionDeclaration then
    raise ECPException.Create('CPSetInline can only be called during function/procedure declaration', []);

  FCurrentInline := AInline;
  Result := Self;
end;


function TCPSourceGenerator.CPSetExternal(const ALibrary: string): ICPSourceGenerator;
begin
  if not FInFunctionDeclaration then
    raise ECPException.Create('CPSetExternal can only be called during function/procedure declaration', []);

  FCurrentExternal := ALibrary;
  Result := Self;
end;


function TCPSourceGenerator.CPStartFunctionBody(): ICPSourceGenerator;
var
  LSignature: string;
  LReturnType: string;
begin
  if not FInFunctionDeclaration then
    raise ECPException.Create('CPStartFunctionBody can only be called during function/procedure declaration', []);

  // Complete the function signature with parameters
  if FCurrentFunctionParameters.Length > 0 then
    LSignature := Format('(%s)', [FCurrentFunctionParameters.ToString()])
  else
    LSignature := '()';

  // Add return type for functions (extract from context)
  if FCurrentContext.StartsWith('function:') then
  begin
    LReturnType := FCurrentContext.Substring(9); // Remove 'function:' prefix
    LSignature := LSignature + ': ' + LReturnType;
  end;

  // Add calling convention if specified
  if FCurrentCallingConvention <> '' then
    LSignature := LSignature + '; ' + FCurrentCallingConvention;

  // Add inline modifier if specified
  if FCurrentInline then
    LSignature := LSignature + '; inline';

  // Add external modifier if specified
  if FCurrentExternal <> '' then
    LSignature := LSignature + '; external ''' + FCurrentExternal + '''';

  // Complete the signature and add semicolon
  AppendToCurrentLine(LSignature + ';');
  AppendLine('');

  // Start function body with begin block
  AppendIndentedLine('begin');
  IncreaseIndent();

  // Update state - no longer in declaration phase
  FInFunctionDeclaration := False;
  Result := Self;
end;


function TCPSourceGenerator.CPEndFunction(): ICPSourceGenerator;
begin
  // End function body
  DecreaseIndent();
  AppendIndentedLine('end;');
  AppendLine('');

  // Reset function context
  FCurrentFunctionName := '';
  FCurrentFunctionParameters.Clear();
  FCurrentContext := '';
  FInFunctionDeclaration := False;
  FCurrentCallingConvention := '';
  FCurrentInline := False;
  FCurrentExternal := '';

  Result := Self;
end;


function TCPSourceGenerator.CPEndProcedure(): ICPSourceGenerator;
begin
  // End procedure body
  DecreaseIndent();
  AppendIndentedLine('end;');
  AppendLine('');

  // Reset procedure context
  FCurrentFunctionName := '';
  FCurrentFunctionParameters.Clear();
  FCurrentContext := '';
  FInFunctionDeclaration := False;
  FCurrentCallingConvention := '';
  FCurrentInline := False;
  FCurrentExternal := '';

  Result := Self;
end;


function TCPSourceGenerator.CPStartCompoundStatement(): ICPSourceGenerator;
begin
  AppendIndentedLine('begin');
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPEndCompoundStatement(): ICPSourceGenerator;
begin
  DecreaseIndent();
  AppendIndentedLine('end;');
  Result := Self;
end;


function TCPSourceGenerator.CPAddGoto(const ALabel: ICPIdentifier): ICPSourceGenerator;
begin
  AppendIndentedLine(Format('goto %s;', [ALabel.GetName()]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddLabel(const ALabel: ICPIdentifier): ICPSourceGenerator;
begin
  AppendIndentedLine(Format('%s:', [ALabel.GetName()]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddBreak(): ICPSourceGenerator;
begin
  AppendIndentedLine('break;');
  Result := Self;
end;


function TCPSourceGenerator.CPAddContinue(): ICPSourceGenerator;
begin
  AppendIndentedLine('continue;');
  Result := Self;
end;


function TCPSourceGenerator.CPAddEmptyStatement(): ICPSourceGenerator;
begin
  // Generate empty statement (single semicolon)
  AppendIndentedLine(';');
  Result := Self;
end;


function TCPSourceGenerator.CPStartInlineAssembly(): ICPSourceGenerator;
begin
  AppendIndentedLine('asm');
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPAddAssemblyLine(const AInstruction: string): ICPSourceGenerator;
begin
  AppendIndentedLine(AInstruction);
  Result := Self;
end;


function TCPSourceGenerator.CPAddAssemblyConstraint(const ATemplate: string; const AOutputs, AInputs, AClobbers: array of string): ICPSourceGenerator;
var
  LConstraintLine: string;
  LOutputList, LInputList, LClobberList: string;
  LItem: string;
begin
  // Build output constraints list
  LOutputList := '';
  for LItem in AOutputs do
  begin
    if LOutputList <> '' then
      LOutputList := LOutputList + ', ';
    LOutputList := LOutputList + '"' + LItem + '"';
  end;

  // Build input constraints list
  LInputList := '';
  for LItem in AInputs do
  begin
    if LInputList <> '' then
      LInputList := LInputList + ', ';
    LInputList := LInputList + '"' + LItem + '"';
  end;

  // Build clobber constraints list
  LClobberList := '';
  for LItem in AClobbers do
  begin
    if LClobberList <> '' then
      LClobberList := LClobberList + ', ';
    LClobberList := LClobberList + '"' + LItem + '"';
  end;

  // Generate inline assembly constraint: "template" : [outputs] : [inputs] : [clobbers]
  LConstraintLine := '"' + ATemplate + '"';
  if LOutputList <> '' then
    LConstraintLine := LConstraintLine + ' : [' + LOutputList + ']';
  if LInputList <> '' then
    LConstraintLine := LConstraintLine + ' : [' + LInputList + ']';
  if LClobberList <> '' then
    LConstraintLine := LConstraintLine + ' : [' + LClobberList + ']';

  AppendIndentedLine(LConstraintLine);
  Result := Self;
end;


function TCPSourceGenerator.CPEndInlineAssembly(): ICPSourceGenerator;
begin
  DecreaseIndent();
  AppendIndentedLine('end;');
  Result := Self;
end;


function TCPSourceGenerator.CPAddElse(): ICPSourceGenerator;
begin
  DecreaseIndent();
  if FInCompilerDirective then
    AppendIndentedLine('{$ELSE}')
  else
    AppendIndentedLine('else');
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPEndIf(): ICPSourceGenerator;
begin
  DecreaseIndent();
  if FInCompilerDirective then
  begin
    AppendIndentedLine('{$ENDIF}');
    FInCompilerDirective := False;
  end;
  Result := Self;
end;


function TCPSourceGenerator.CPAddCaseLabel(const ALabels: array of ICPExpression): ICPSourceGenerator;
var
  LLabelStr: string;
  LLabel: ICPExpression;
begin
  // Decrease indentation to get back to case body level (except for first label)
  if FIndentLevel > 1 then
    DecreaseIndent();

  LLabelStr := '';
  for LLabel in ALabels do
  begin
    if LLabelStr <> '' then
      LLabelStr := LLabelStr + ', ';
    LLabelStr := LLabelStr + LLabel.GetCPas();
  end;

  AppendIndentedLine(Format('%s:', [LLabelStr]));
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPStartCaseElse(): ICPSourceGenerator;
begin
  // Decrease indentation to get back to case body level
  if FIndentLevel > 1 then
    DecreaseIndent();

  AppendIndentedLine('else');
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPEndCase(): ICPSourceGenerator;
begin
  DecreaseIndent();
  AppendIndentedLine('end;');
  Result := Self;
end;


function TCPSourceGenerator.CPEndWhile(): ICPSourceGenerator;
begin
  DecreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPStartFor(const AVariable: ICPIdentifier; const AStartValue, AEndValue: ICPExpression; const ADownTo: Boolean): ICPSourceGenerator;
var
  LDirection: string;
begin
  if ADownTo then
    LDirection := 'downto'
  else
    LDirection := 'to';

  AppendIndentedLine(Format('for %s := %s %s %s do', [
    AVariable.GetName(),
    AStartValue.GetCPas(),
    LDirection,
    AEndValue.GetCPas()
  ]));
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPEndFor(): ICPSourceGenerator;
begin
  DecreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPStartRepeat(): ICPSourceGenerator;
begin
  AppendIndentedLine('repeat');
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPEndProgram(): ICPSourceGenerator;
var
  LSource: string;
begin
  // Get current source to check for trailing pattern
  LSource := FSourceBuilder.ToString();
  
  // Check if source ends with "end;" + newline (from main compound statement)
  if LSource.TrimRight().EndsWith('end;') then
  begin
    // Remove the trailing semicolon and any whitespace
    LSource := LSource.TrimRight();
    LSource := LSource.Substring(0, LSource.Length - 1); // Remove semicolon
    
    // Replace the entire source and add the dot
    FSourceBuilder.Clear();
    FSourceBuilder.Append(LSource + '.');
  end
  else
  begin
    // Fallback: append dot to current line (for edge cases)
    AppendToCurrentLine('.');
  end;
  
  AppendLine(''); // Add final line break after the dot
  FCurrentContext := '';
  Result := Self;
end;


function TCPSourceGenerator.CPEndLibrary(): ICPSourceGenerator;
var
  LSource: string;
begin
  // Get current source to check for trailing pattern
  LSource := FSourceBuilder.ToString();
  
  // Check if source ends with "end;" + newline (from main compound statement)
  if LSource.TrimRight().EndsWith('end;') then
  begin
    // Remove the trailing semicolon and any whitespace
    LSource := LSource.TrimRight();
    LSource := LSource.Substring(0, LSource.Length - 1); // Remove semicolon
    
    // Replace the entire source and add the dot
    FSourceBuilder.Clear();
    FSourceBuilder.Append(LSource + '.');
  end
  else
  begin
    // Fallback: append dot to current line (for edge cases)
    AppendToCurrentLine('.');
  end;
  
  AppendLine(''); // Add final line break after the dot
  FCurrentContext := '';
  Result := Self;
end;


function TCPSourceGenerator.CPEndModule(): ICPSourceGenerator;
var
  LSource: string;
begin
  // Get current source to check for trailing pattern
  LSource := FSourceBuilder.ToString();
  
  // Check if source ends with "end;" + newline (from main compound statement)
  if LSource.TrimRight().EndsWith('end;') then
  begin
    // Remove the trailing semicolon and any whitespace
    LSource := LSource.TrimRight();
    LSource := LSource.Substring(0, LSource.Length - 1); // Remove semicolon
    
    // Replace the entire source and add the dot
    FSourceBuilder.Clear();
    FSourceBuilder.Append(LSource + '.');
  end
  else
  begin
    // Fallback: append dot to current line (for edge cases)
    AppendToCurrentLine('.');
  end;
  
  AppendLine(''); // Add final line break after the dot
  FCurrentContext := '';
  Result := Self;
end;


function TCPSourceGenerator.GenerateSource(const APrettyPrint: Boolean): string;
var
  LSource: string;
begin
  LSource := FSourceBuilder.ToString();

  if APrettyPrint then
    // Pretty print mode: return formatted source with indentation
    Result := LSource
  else
  begin
    // Canonical mode: minimize whitespace for testing
    Result := LSource.Replace(sLineBreak + sLineBreak, sLineBreak, [rfReplaceAll]);
    Result := Result.Replace('  ', ' ', [rfReplaceAll]);
    Result := Result.Trim();
  end;
end;

function TCPSourceGenerator.CPAddComment(const AComment: string; const AStyle: TCPCommentStyle): ICPSourceGenerator;
begin
  case AStyle of
    csLine:
      // Line comment: // comment
      AppendIndentedLine(Format('// %s', [AComment]));

    csBlock:
      // Block comment: /* comment */
      AppendIndentedLine(Format('/* %s */', [AComment]));

    csBrace:
      // Brace comment: { comment }
      AppendIndentedLine(Format('{ %s }', [AComment]));
  else
    raise ECPException.Create('Invalid comment style: %d', [Ord(AStyle)]);
  end;

  Result := Self;
end;


function TCPSourceGenerator.CPAddBlankLine(): ICPSourceGenerator;
begin
  // Add blank line to source
  AppendLine('');
  Result := Self;
end;


procedure TCPSourceGenerator.Reset();
begin
  FSourceBuilder.Clear();
  FCurrentFunctionParameters.Clear();
  FDeclaredVariables.Clear();
  ResetIndent();
  FCurrentContext := '';
  FCurrentFunctionName := '';
  FInFunctionDeclaration := False;
  FCurrentCallingConvention := '';
  FCurrentInline := False;
  FCurrentExternal := '';
  FInCompilerDirective := False;
end;


function TCPSourceGenerator.CPGetCurrentContext(): string;
begin
  Result := FCurrentContext;
end;

// === SAA Expression Factory Methods Implementation ===


function TCPSourceGenerator.CPIdentifier(const AName: string): ICPIdentifier;
begin
  // Implementation placeholder - will be completed in subsequent iterations
  Result := TCPIdentifier.Create(AName, TCPSourceLocation.Create('', 0, 0));
end;


function TCPSourceGenerator.CPBuiltInType(const AType: TCPBuiltInType): ICPType;
begin
  // Use type registry to get proper specialized type instances
  Result := TCPTypeRegistry.GetInstance().GetType(AType);
end;

// Enhanced Type System Access Methods (Builder-Centralized Pattern)


function TCPSourceGenerator.CPGetTypeRegistry(): TCPTypeRegistry;
begin
  Result := TCPTypeRegistry.GetInstance();
end;


function TCPSourceGenerator.CPGetInt8Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptInt8);
end;


function TCPSourceGenerator.CPGetInt16Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptInt16);
end;


function TCPSourceGenerator.CPGetInt32Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptInt32);
end;


function TCPSourceGenerator.CPGetInt64Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptInt64);
end;


function TCPSourceGenerator.CPGetUInt8Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptUInt8);
end;


function TCPSourceGenerator.CPGetUInt16Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptUInt16);
end;


function TCPSourceGenerator.CPGetUInt32Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptUInt32);
end;


function TCPSourceGenerator.CPGetUInt64Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptUInt64);
end;


function TCPSourceGenerator.CPGetFloat32Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptFloat32);
end;


function TCPSourceGenerator.CPGetFloat64Type(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetType(cptFloat64);
end;


function TCPSourceGenerator.CPGetBooleanType(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetBooleanType();
end;


function TCPSourceGenerator.CPGetStringType(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetStringType();
end;


function TCPSourceGenerator.CPGetCharType(): ICPType;
begin
  Result := TCPTypeRegistry.GetInstance().GetCharType();
end;


function TCPSourceGenerator.CPVariable(const AName: ICPIdentifier): ICPExpression;
var
  LVariable: TCPVariable;
  LLocation: TCPSourceLocation;
  LType: ICPType;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Lookup variable type in symbol table
  if not FDeclaredVariables.TryGetValue(AName.GetName(), LType) then
  begin
    raise ECPException.Create(
      'Variable "%s" is not declared',
      [AName.GetName()],
      LLocation.FileName,
      LLocation.Line,
      LLocation.Column
    );
  end;

  // Create variable expression with actual declared type
  LVariable := TCPVariable.Create(
    AName,
    LType,
    LLocation
  );

  Result := LVariable;
end;


function TCPSourceGenerator.CPInt8(const AValue: Int8): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create literal with proper constructor parameters
  LLiteral := TCPLiteral.Create(
    TValue.From<Int8>(AValue),
    CPGetInt8Type(),
    LLocation
  );

  Result := LLiteral;
end;


function TCPSourceGenerator.CPInt16(const AValue: Int16): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create literal with proper constructor parameters
  LLiteral := TCPLiteral.Create(
    TValue.From<Int16>(AValue),
    CPGetInt16Type(),
    LLocation
  );

  Result := LLiteral;
end;


function TCPSourceGenerator.CPInt32(const AValue: Int32): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create literal with proper constructor parameters
  LLiteral := TCPLiteral.Create(
    TValue.From<Int32>(AValue),
    CPGetInt32Type(),
    LLocation
  );

  Result := LLiteral;
end;


function TCPSourceGenerator.CPInt64(const AValue: Int64): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create literal with proper constructor parameters
  LLiteral := TCPLiteral.Create(
    TValue.From<Int64>(AValue),
    CPGetInt64Type(),
    LLocation
  );

  Result := LLiteral;
end;


function TCPSourceGenerator.CPUInt8(const AValue: UInt8): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create literal with proper constructor parameters
  LLiteral := TCPLiteral.Create(
    TValue.From<UInt8>(AValue),
    CPGetUInt8Type(),
    LLocation
  );

  Result := LLiteral;
end;


function TCPSourceGenerator.CPUInt16(const AValue: UInt16): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create literal with proper constructor parameters
  LLiteral := TCPLiteral.Create(
    TValue.From<UInt16>(AValue),
    CPGetUInt16Type(),
    LLocation
  );

  Result := LLiteral;
end;


function TCPSourceGenerator.CPUInt32(const AValue: UInt32): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create literal with proper constructor parameters
  LLiteral := TCPLiteral.Create(
    TValue.From<UInt32>(AValue),
    CPGetUInt32Type(),
    LLocation
  );

  Result := LLiteral;
end;


function TCPSourceGenerator.CPUInt64(const AValue: UInt64): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create literal with proper constructor parameters
  LLiteral := TCPLiteral.Create(
    TValue.From<UInt64>(AValue),
    CPGetUInt64Type(),
    LLocation
  );

  Result := LLiteral;
end;


function TCPSourceGenerator.CPFloat32(const AValue: Single): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create literal with proper constructor parameters
  LLiteral := TCPLiteral.Create(
    TValue.From<Single>(AValue),
    CPGetFloat32Type(),
    LLocation
  );

  Result := LLiteral;
end;


function TCPSourceGenerator.CPFloat64(const AValue: Double): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create literal with proper constructor parameters
  LLiteral := TCPLiteral.Create(
    TValue.From<Double>(AValue),
    CPGetFloat64Type(),
    LLocation
  );

  Result := LLiteral;
end;


function TCPSourceGenerator.CPBoolean(const AValue: Boolean): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create literal with proper constructor parameters
  LLiteral := TCPLiteral.Create(
    TValue.From<Boolean>(AValue),
    CPGetBooleanType(),
    LLocation
  );

  Result := LLiteral;
end;


function TCPSourceGenerator.CPString(const AValue: string): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create literal with proper constructor parameters
  LLiteral := TCPLiteral.Create(
    TValue.From<string>(AValue),
    CPGetStringType(),
    LLocation
  );

  Result := LLiteral;
end;

// === Specialized Validation Factory Methods ===


function TCPSourceGenerator.CPLibraryName(const AName: string): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
  LValidatedName: string;
begin
  // Create default source location
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Platform-specific library name validation
  LValidatedName := AName;

  {$IF DEFINED(MSWINDOWS)}
    // Windows: .lib (static) or .dll (dynamic) extensions
    if not (AName.EndsWith('.lib', True) or AName.EndsWith('.dll', True)) then
    begin
      // Allow generic names but warn about missing extension
      if not (AName.Contains('.')) then
        LValidatedName := AName // Allow generic names like 'user32'
      else
        raise ECPException.Create(
          'Library name "%s" has invalid extension for Windows. Expected: .lib, .dll',
          [AName],
          LLocation.FileName,
          LLocation.Line,
          LLocation.Column
        );
    end;
  {$ELSEIF DEFINED(LINUX)}
    // Linux: lib prefix + .a (static) or .so (shared) extensions
    if not ((AName.StartsWith('lib') and (AName.EndsWith('.a') or AName.EndsWith('.so'))) or
            (not AName.Contains('.'))) then
    begin
      if AName.Contains('.') then
        raise ECPException.Create(
          'Library name "%s" has invalid format for Linux. Expected: lib*.a, lib*.so',
          [AName],
          LLocation.FileName,
          LLocation.Line,
          LLocation.Column
        );
    end;
  {$ELSEIF DEFINED(MACOS)}
    // macOS: lib prefix + .a (static) or .dylib (dynamic) extensions
    if not ((AName.StartsWith('lib') and (AName.EndsWith('.a') or AName.EndsWith('.dylib'))) or
            (not AName.Contains('.'))) then
    begin
      if AName.Contains('.') then
        raise ECPException.Create(
          'Library name "%s" has invalid format for macOS. Expected: lib*.a, lib*.dylib',
          [AName],
          LLocation.FileName,
          LLocation.Line,
          LLocation.Column
        );
    end;
  {$ELSE}
    // Generic platform - allow most formats but validate basic rules
    if AName.Trim = '' then
      raise ECPException.Create(
        'Library name cannot be empty',
        [],
        LLocation.FileName,
        LLocation.Line,
        LLocation.Column
      );
  {$ENDIF}

  // Create validated string literal
  LLiteral := TCPLiteral.Create(
    TValue.From<string>(LValidatedName),
    CPGetStringType(),
    LLocation
  );

  Result := LLiteral;
end;


function TCPSourceGenerator.CPFilePath(const APath: string): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
  LValidatedPath: string;
begin
  // Create default source location
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Basic path validation
  if APath.Trim = '' then
    raise ECPException.Create(
      'File path cannot be empty',
      [],
      LLocation.FileName,
      LLocation.Line,
      LLocation.Column
    );

  LValidatedPath := APath;

  {$IF DEFINED(MSWINDOWS)}
    // Windows: Use backslashes, allow drive letters
    if APath.Contains('/') and not APath.Contains('\') then
    begin
      // Convert forward slashes to backslashes for Windows
      LValidatedPath := APath.Replace('/', '\');
    end;

    // Validate Windows path format
    if APath.Contains('*') or APath.Contains('?') or APath.Contains('<') or
       APath.Contains('>') or APath.Contains('|') then
      raise ECPException.Create(
        'Path "%s" contains invalid characters for Windows',
        [APath],
        LLocation.FileName,
        LLocation.Line,
        LLocation.Column
      );
  {$ELSE}
    // Unix-like: Use forward slashes
    if APath.Contains('\\') then
      raise ECPException.Create(
        'Path "%s" uses Windows separators on Unix. Use forward slashes',
        [APath],
        LLocation.FileName,
        LLocation.Line,
        LLocation.Column
      );

    // Validate Unix path format
    if APath.Contains('*') or APath.Contains('?') then
      raise ECPException.Create(
        'Path "%s" contains wildcard characters',
        [APath],
        LLocation.FileName,
        LLocation.Line,
        LLocation.Column
      );
  {$ENDIF}

  // Create validated path literal
  LLiteral := TCPLiteral.Create(
    TValue.From<string>(LValidatedPath),
    CPGetStringType(),
    LLocation
  );

  Result := LLiteral;
end;


function TCPSourceGenerator.CPAppType(const AType: string): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
  LValidatedType: string;
  LUpperType: string;
begin
  // Create default source location
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Validate application type
  LUpperType := AType.ToUpper;
  LValidatedType := LUpperType; // Use canonical uppercase form

  // Platform-specific validation
  {$IF DEFINED(MSWINDOWS)}
    if not (LUpperType.Equals('CONSOLE') or LUpperType.Equals('GUI') or LUpperType.Equals('SERVICE')) then
      raise ECPException.Create(
        'Application type "%s" not supported on Windows. Allowed: CONSOLE, GUI, SERVICE',
        [AType],
        LLocation.FileName,
        LLocation.Line,
        LLocation.Column
      );
  {$ELSE}
    // Unix-like platforms
    if not (LUpperType.Equals('CONSOLE') or LUpperType.Equals('GUI') or LUpperType.Equals('DAEMON')) then
      raise ECPException.Create(
        'Application type "%s" not supported on this platform. Allowed: CONSOLE, GUI, DAEMON',
        [AType],
        LLocation.FileName,
        LLocation.Line,
        LLocation.Column
      );
  {$ENDIF}

  // Create validated app type literal
  LLiteral := TCPLiteral.Create(
    TValue.From<string>(LValidatedType),
    CPGetStringType(),
    LLocation
  );

  Result := LLiteral;
end;


function TCPSourceGenerator.CPChar(const AValue: Char): ICPExpression;
var
  LLiteral: TCPLiteral;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create literal with proper constructor parameters
  LLiteral := TCPLiteral.Create(
    TValue.From<Char>(AValue),
    CPGetCharType(),
    LLocation
  );

  Result := LLiteral;
end;


function TCPSourceGenerator.CPBinaryOp(const ALeft: ICPExpression; const AOperator: TCPBinaryOperator; const ARight: ICPExpression): ICPExpression;
var
  LBinaryOp: TCPBinaryOp;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create binary operation expression
  LBinaryOp := TCPBinaryOp.Create(
    ALeft,
    AOperator,
    ARight,
    LLocation
  );

  Result := LBinaryOp;
end;


function TCPSourceGenerator.CPUnaryOp(const AOperator: TCPUnaryOperator; const AOperand: ICPExpression): ICPExpression;
var
  LUnaryOp: TCPUnaryOp;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create unary operation expression
  LUnaryOp := TCPUnaryOp.Create(
    AOperator,
    AOperand,
    LLocation
  );

  Result := LUnaryOp;
end;


function TCPSourceGenerator.CPTernaryOp(const ACondition: ICPExpression; const ATrueExpr: ICPExpression; const AFalseExpr: ICPExpression): ICPExpression;
var
  LTernaryOp: TCPTernaryOp;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create ternary operation expression
  LTernaryOp := TCPTernaryOp.Create(
    ACondition,
    ATrueExpr,
    AFalseExpr,
    LLocation
  );

  Result := LTernaryOp;
end;


function TCPSourceGenerator.CPFunctionCall(const AFunctionName: ICPIdentifier; const AParameters: array of ICPExpression): ICPExpression;
var
  LFunctionCall: TCPFunctionCall;
  LLocation: TCPSourceLocation;
  LReturnType: ICPType;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Default return type - in a full implementation, this would be resolved from a symbol table
  // For now, use Int32 as a safe default
  LReturnType := CPGetInt32Type();

  // Create function call expression
  LFunctionCall := TCPFunctionCall.Create(
    AFunctionName,
    AParameters,
    LReturnType,
    LLocation
  );

  Result := LFunctionCall;
end;


function TCPSourceGenerator.CPArrayAccess(const AArray: ICPExpression; const AIndex: ICPExpression): ICPExpression;
var
  LArrayAccess: TCPArrayAccess;
  LLocation: TCPSourceLocation;
  LElementType: ICPType;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Default element type - in a full implementation, this would be resolved from the array type
  // For now, use Int32 as a safe default
  LElementType := CPGetInt32Type();

  // Create array access expression
  LArrayAccess := TCPArrayAccess.Create(
    AArray,
    AIndex,
    LElementType,
    LLocation
  );

  Result := LArrayAccess;
end;


function TCPSourceGenerator.CPFieldAccess(const ARecord: ICPExpression; const AFieldName: ICPIdentifier): ICPExpression;
var
  LFieldAccess: TCPFieldAccess;
  LLocation: TCPSourceLocation;
  LFieldType: ICPType;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Default field type - in a full implementation, this would be resolved from the record type
  // For now, use Int32 as a safe default
  LFieldType := CPGetInt32Type();

  // Create field access expression
  LFieldAccess := TCPFieldAccess.Create(
    ARecord,
    AFieldName,
    LFieldType,
    LLocation
  );

  Result := LFieldAccess;
end;


function TCPSourceGenerator.CPTypecast(const AExpression: ICPExpression; const ATargetType: ICPType): ICPExpression;
var
  LTypecast: TCPTypecast;
  LLocation: TCPSourceLocation;
begin
  // Create default source location (builder could track actual location in future)
  LLocation := TCPSourceLocation.Create('', 0, 0);

  // Create typecast expression
  LTypecast := TCPTypecast.Create(
    AExpression,
    ATargetType,
    LLocation
  );

  Result := LTypecast;
end;

// === SAA Statement Methods Implementation ===


function TCPSourceGenerator.CPAddAssignment(const AVariable: ICPIdentifier; const AExpression: ICPExpression): ICPSourceGenerator;
begin
  // Generate assignment statement: variable := expression;
  AppendIndentedLine(Format('%s := %s;', [AVariable.GetName(), AExpression.GetCPas()]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddProcedureCall(const AProcName: ICPIdentifier; const AParams: array of ICPExpression): ICPSourceGenerator;
var
  LParamStr: string;
  LParam: ICPExpression;
begin
  LParamStr := '';

  // Build parameter list
  if Length(AParams) > 0 then
  begin
    for LParam in AParams do
    begin
      if LParamStr <> '' then
        LParamStr := LParamStr + ', ';
      LParamStr := LParamStr + LParam.GetCPas();
    end;
  end;

  // Generate procedure call
  if LParamStr <> '' then
    AppendIndentedLine(Format('%s(%s);', [AProcName.GetName(), LParamStr]))
  else
    AppendIndentedLine(Format('%s();', [AProcName.GetName()]));

  Result := Self;
end;


function TCPSourceGenerator.CPStartIf(const ACondition: ICPExpression): ICPSourceGenerator;
begin
  AppendIndentedLine(Format('if %s then', [ACondition.GetCPas()]));
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPStartCase(const AExpression: ICPExpression): ICPSourceGenerator;
begin
  AppendIndentedLine(Format('case %s of', [AExpression.GetCPas()]));
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPStartWhile(const ACondition: ICPExpression): ICPSourceGenerator;
begin
  AppendIndentedLine(Format('while %s do', [ACondition.GetCPas()]));
  IncreaseIndent();
  Result := Self;
end;


function TCPSourceGenerator.CPEndRepeat(const ACondition: ICPExpression): ICPSourceGenerator;
begin
  DecreaseIndent();
  AppendIndentedLine(Format('until %s;', [ACondition.GetCPas()]));
  Result := Self;
end;


function TCPSourceGenerator.CPAddExit(const AExpression: ICPExpression): ICPSourceGenerator;
begin
  if AExpression <> nil then
    AppendIndentedLine(Format('exit(%s);', [AExpression.GetCPas()]))
  else
    AppendIndentedLine('exit;');
  Result := Self;
end;

end.
