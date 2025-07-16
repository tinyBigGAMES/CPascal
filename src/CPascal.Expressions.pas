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

unit CPascal.Expressions;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.TypInfo,
  System.Rtti,
  CPascal.Common;

type
  { Forward declarations }
  ICPType = interface;
  ICPIdentifier = interface;
  
  { ICPExpression }
  ICPExpression = interface
    ['{B8F4A7C2-1E3D-4F5E-9A8B-2C6D7E8F9A1B}']
    function GetCPas(const APrettyPrint: Boolean = True): string;
    function GetIR(): string;
    function GetType(): ICPType;
    function Validate(): Boolean;
  end;

  { ICPIdentifier }
  ICPIdentifier = interface
    ['{A1B2C3D4-5E6F-7A8B-9C0D-1E2F3A4B5C6D}']
    function GetName(): string;
    function IsValid(): Boolean;
    function GetLocation(): TCPSourceLocation;
  end;

  { ICPType }
  ICPType = interface
    ['{C3D4E5F6-7A8B-9C0D-1E2F-3A4B5C6D7E8F}']
    function GetName(): string;
    function GetSize(): Integer;
    function IsCompatibleWith(const AOther: ICPType): Boolean;
  end;

  { TCPBinaryOperator }
  TCPBinaryOperator = (
    cpOpAdd,      // +
    cpOpSub,      // -
    cpOpMul,      // *
    cpOpDiv,      // /
    cpOpMod,      // mod
    cpOpAnd,      // and
    cpOpOr,       // or
    cpOpXor,      // xor
    cpOpShl,      // shl
    cpOpShr,      // shr
    cpOpEQ,       // =
    cpOpNE,       // <>
    cpOpLT,       // <
    cpOpLE,       // <=
    cpOpGT,       // >
    cpOpGE        // >=
  );

  { TCPUnaryOperator }
  TCPUnaryOperator = (
    cpOpNeg,      // -
    cpOpNot,      // not
    cpOpAddr,     // @
    cpOpDeref     // ^
  );

  { TCPBuiltInType }
  TCPBuiltInType = (
    cptInt8,      // Int8
    cptInt16,     // Int16  
    cptInt32,     // Int32
    cptInt64,     // Int64
    cptUInt8,     // UInt8
    cptUInt16,    // UInt16
    cptUInt32,    // UInt32
    cptUInt64,    // UInt64
    cptFloat32,   // Float32
    cptFloat64,   // Float64
    cptBoolean,   // Boolean
    cptString,    // string
    cptChar       // Char
  );

  { TCPExpression }
  TCPExpression = class abstract(TInterfacedObject, ICPExpression)
  private
    FSourceLocation: TCPSourceLocation;
  protected
    function GetOperatorString(const AOperator: TCPBinaryOperator): string; overload;
    function GetOperatorString(const AOperator: TCPUnaryOperator): string; overload;
  public
    constructor Create(const ALocation: TCPSourceLocation);
    function GetCPas(const APrettyPrint: Boolean = True): string; virtual; abstract;
    function GetIR(): string; virtual; abstract;
    function GetType(): ICPType; virtual; abstract;
    function Validate(): Boolean; virtual; abstract;
    property SourceLocation: TCPSourceLocation read FSourceLocation;
  end;

  { TCPLiteral }
  TCPLiteral = class(TCPExpression)
  private
    FValue: TValue;
    FType: ICPType;
  public
    constructor Create(const AValue: TValue; const AType: ICPType; const ALocation: TCPSourceLocation);
    function GetCPas(const APrettyPrint: Boolean = True): string; override;
    function GetIR(): string; override;
    function GetType(): ICPType; override;
    function Validate(): Boolean; override;
  end;

  { TCPIdentifier }
  TCPIdentifier = class(TInterfacedObject, ICPIdentifier)
  private
    FName: string;
    FLocation: TCPSourceLocation;
    function IsValidPascalIdentifier(const AName: string): Boolean;
    function IsValidSimpleIdentifier(const AName: string): Boolean;
  public
    constructor Create(const AName: string; const ALocation: TCPSourceLocation);
    function GetName(): string;
    function IsValid(): Boolean;
    function GetLocation(): TCPSourceLocation;
  end;

  { TCPVariable }
  TCPVariable = class(TCPExpression)
  private
    FIdentifier: ICPIdentifier;
    FType: ICPType;
  public
    constructor Create(const AIdentifier: ICPIdentifier; const AType: ICPType; const ALocation: TCPSourceLocation);
    function GetCPas(const APrettyPrint: Boolean = True): string; override;
    function GetIR(): string; override;
    function GetType(): ICPType; override;
    function Validate(): Boolean; override;
  end;

  { TCPBinaryOp }
  TCPBinaryOp = class(TCPExpression)
  private
    FLeft: ICPExpression;
    FRight: ICPExpression;
    FOperator: TCPBinaryOperator;
    FResultType: ICPType;
  public
    constructor Create(const ALeft: ICPExpression; const AOperator: TCPBinaryOperator; 
      const ARight: ICPExpression; const ALocation: TCPSourceLocation);
    function GetCPas(const APrettyPrint: Boolean = True): string; override;
    function GetIR(): string; override;
    function GetType(): ICPType; override;
    function Validate(): Boolean; override;
  end;

  { TCPUnaryOp }
  TCPUnaryOp = class(TCPExpression)
  private
    FOperand: ICPExpression;
    FOperator: TCPUnaryOperator;
    FResultType: ICPType;
  public
    constructor Create(const AOperator: TCPUnaryOperator; const AOperand: ICPExpression; 
      const ALocation: TCPSourceLocation);
    function GetCPas(const APrettyPrint: Boolean = True): string; override;
    function GetIR(): string; override;
    function GetType(): ICPType; override;
    function Validate(): Boolean; override;
  end;

  { TCPFunctionCall }
  TCPFunctionCall = class(TCPExpression)
  private
    FFunctionName: ICPIdentifier;
    FParameters: array of ICPExpression;
    FReturnType: ICPType;
  public
    constructor Create(const AFunctionName: ICPIdentifier; const AParameters: array of ICPExpression; 
      const AReturnType: ICPType; const ALocation: TCPSourceLocation);
    function GetCPas(const APrettyPrint: Boolean = True): string; override;
    function GetIR(): string; override;
    function GetType(): ICPType; override;
    function Validate(): Boolean; override;
  end;

  { TCPArrayAccess }
  TCPArrayAccess = class(TCPExpression)
  private
    FArray: ICPExpression;
    FIndex: ICPExpression;
    FElementType: ICPType;
  public
    constructor Create(const AArray: ICPExpression; const AIndex: ICPExpression; 
      const AElementType: ICPType; const ALocation: TCPSourceLocation);
    function GetCPas(const APrettyPrint: Boolean = True): string; override;
    function GetIR(): string; override;
    function GetType(): ICPType; override;
    function Validate(): Boolean; override;
  end;

  { TCPFieldAccess }
  TCPFieldAccess = class(TCPExpression)
  private
    FRecord: ICPExpression;
    FFieldName: ICPIdentifier;
    FFieldType: ICPType;
  public
    constructor Create(const ARecord: ICPExpression; const AFieldName: ICPIdentifier; 
      const AFieldType: ICPType; const ALocation: TCPSourceLocation);
    function GetCPas(const APrettyPrint: Boolean = True): string; override;
    function GetIR(): string; override;
    function GetType(): ICPType; override;
    function Validate(): Boolean; override;
  end;

  { TCPTypecast }
  TCPTypecast = class(TCPExpression)
  private
    FExpression: ICPExpression;
    FTargetType: ICPType;
  public
    constructor Create(const AExpression: ICPExpression; const ATargetType: ICPType; 
      const ALocation: TCPSourceLocation);
    function GetCPas(const APrettyPrint: Boolean = True): string; override;
    function GetIR(): string; override;
    function GetType(): ICPType; override;
    function Validate(): Boolean; override;
  end;

  { TCPTernaryOp }
  TCPTernaryOp = class(TCPExpression)
  private
    FCondition: ICPExpression;
    FTrueExpr: ICPExpression;
    FFalseExpr: ICPExpression;
    FResultType: ICPType;
  public
    constructor Create(const ACondition: ICPExpression; const ATrueExpr: ICPExpression; 
      const AFalseExpr: ICPExpression; const ALocation: TCPSourceLocation);
    function GetCPas(const APrettyPrint: Boolean = True): string; override;
    function GetIR(): string; override;
    function GetType(): ICPType; override;
    function Validate(): Boolean; override;
  end;

  { TCPType }
  TCPType = class(TInterfacedObject, ICPType)
  private
    FName: string;
    FSize: Integer;
  public
    constructor Create(const AName: string; const ASize: Integer);
    function GetName(): string;
    function GetSize(): Integer;
    function IsCompatibleWith(const AOther: ICPType): Boolean; virtual;
  end;

  { TCPIntegerType }
  TCPIntegerType = class(TCPType)
  private
    FMinValue: Int64;
    FMaxValue: Int64;
    FIsSigned: Boolean;
    FBuiltInType: TCPBuiltInType;
  public
    constructor Create(const ABuiltInType: TCPBuiltInType);
    function IsCompatibleWith(const AOther: ICPType): Boolean; override;
    function CanPromoteTo(const AOther: ICPType): Boolean;
    function IsInRange(const AValue: Int64): Boolean;
    property MinValue: Int64 read FMinValue;
    property MaxValue: Int64 read FMaxValue;
    property IsSigned: Boolean read FIsSigned;
    property BuiltInType: TCPBuiltInType read FBuiltInType;
  end;

  { TCPFloatType }
  TCPFloatType = class(TCPType)
  private
    FPrecision: Integer;
    FBuiltInType: TCPBuiltInType;
  public
    constructor Create(const ABuiltInType: TCPBuiltInType);
    function IsCompatibleWith(const AOther: ICPType): Boolean; override;
    function CanPromoteTo(const AOther: ICPType): Boolean;
    property Precision: Integer read FPrecision;
    property BuiltInType: TCPBuiltInType read FBuiltInType;
  end;

  { TCPBooleanType }
  TCPBooleanType = class(TCPType)
  public
    constructor Create();
    function IsCompatibleWith(const AOther: ICPType): Boolean; override;
  end;

  { TCPStringType }
  TCPStringType = class(TCPType)
  public
    constructor Create();
    function IsCompatibleWith(const AOther: ICPType): Boolean; override;
  end;

  { TCPCharType }
  TCPCharType = class(TCPType)
  public
    constructor Create();
    function IsCompatibleWith(const AOther: ICPType): Boolean; override;
    function CanPromoteToString(): Boolean;
  end;

  { TCPTypeRegistry }
  TCPTypeRegistry = class
  private
    FBuiltInTypes: array[TCPBuiltInType] of ICPType;
    FStringType: ICPType;
    FCharType: ICPType;
    FBooleanType: ICPType;
    procedure CreateBuiltInTypes();
    class var FInstance: TCPTypeRegistry;
  public
    constructor Create();
    destructor Destroy(); override;
    
    // Built-in type access
    function GetType(const ABuiltInType: TCPBuiltInType): ICPType;
    function GetStringType(): ICPType;
    function GetCharType(): ICPType;
    function GetBooleanType(): ICPType;
    
    // Type resolution for operations
    function FindCommonType(const AType1, AType2: ICPType): ICPType;
    function GetPromotedType(const AFromType, AToType: ICPType): ICPType;
    
    // Singleton access
    class function GetInstance(): TCPTypeRegistry;
    class procedure ReleaseInstance();
  end;

implementation


{ TCPExpression }

constructor TCPExpression.Create(const ALocation: TCPSourceLocation);
begin
  inherited Create();
  FSourceLocation := ALocation;
end;

function TCPExpression.GetOperatorString(const AOperator: TCPBinaryOperator): string;
begin
  case AOperator of
    cpOpAdd: Result := '+';
    cpOpSub: Result := '-';
    cpOpMul: Result := '*';
    cpOpDiv: Result := '/';
    cpOpMod: Result := 'mod';
    cpOpAnd: Result := 'and';
    cpOpOr: Result := 'or';
    cpOpXor: Result := 'xor';
    cpOpShl: Result := 'shl';
    cpOpShr: Result := 'shr';
    cpOpEQ: Result := '=';
    cpOpNE: Result := '<>';
    cpOpLT: Result := '<';
    cpOpLE: Result := '<=';
    cpOpGT: Result := '>';
    cpOpGE: Result := '>=';
  else
    raise ECPException.Create('Invalid binary operator', []);
  end;
end;

function TCPExpression.GetOperatorString(const AOperator: TCPUnaryOperator): string;
begin
  case AOperator of
    cpOpNeg: Result := '-';
    cpOpNot: Result := 'not';
    cpOpAddr: Result := '@';
    cpOpDeref: Result := '^';
  else
    raise ECPException.Create('Invalid unary operator', []);
  end;
end;

{ TCPIdentifier }

constructor TCPIdentifier.Create(const AName: string; const ALocation: TCPSourceLocation);
begin
  inherited Create();
  FName := AName;
  FLocation := ALocation;
  
  if not IsValidPascalIdentifier(AName) then
    raise ECPException.Create(
      'Invalid Pascal identifier: "%s"',
      [AName],
      ALocation.FileName,
      ALocation.Line,
      ALocation.Column
    );
end;

function TCPIdentifier.GetName(): string;
begin
  Result := FName;
end;

function TCPIdentifier.IsValid(): Boolean;
begin
  Result := IsValidPascalIdentifier(FName);
end;

function TCPIdentifier.GetLocation(): TCPSourceLocation;
begin
  Result := FLocation;
end;

function TCPIdentifier.IsValidPascalIdentifier(const AName: string): Boolean;
var
  LParts: TArray<string>;
  LPart: string;
begin
  Result := False;

  if AName = '' then
    Exit;

  // Check if this is a qualified identifier (contains dots)
  if AName.Contains('.') then
  begin
    // Split by dots and validate each part
    LParts := AName.Split(['.']);
    for LPart in LParts do
    begin
      if not IsValidSimpleIdentifier(LPart) then
        Exit;
    end;
    Result := True;
  end
  else
  begin
    // Simple identifier validation
    Result := IsValidSimpleIdentifier(AName);
  end;
end;

function TCPIdentifier.IsValidSimpleIdentifier(const AName: string): Boolean;
var
  LIndex: Integer;
  LChar: Char;
begin
  Result := False;

  if AName = '' then
    Exit;

  // First character must be letter or underscore
  LChar := AName[1];
  if not (CharInSet(LChar, ['A'..'Z', 'a'..'z', '_'])) then
    Exit;

  // Subsequent characters must be letters, digits, or underscores
  for LIndex := 2 to Length(AName) do
  begin
    LChar := AName[LIndex];
    if not (CharInSet(LChar, ['A'..'Z', 'a'..'z', '0'..'9', '_'])) then
      Exit;
  end;

  Result := True;
end;

{ TCPLiteral }

constructor TCPLiteral.Create(const AValue: TValue; const AType: ICPType; const ALocation: TCPSourceLocation);
begin
  inherited Create(ALocation);
  FValue := AValue;
  FType := AType;
end;

function TCPLiteral.GetCPas(const APrettyPrint: Boolean): string;
var
  LIntegerType: TCPIntegerType;
  LFloatType: TCPFloatType;
  LFormatSettings: TFormatSettings;
begin
  // Literals are the same in both pretty print and canonical modes
  
  // Use type-aware formatting for better precision and range handling
  if FType is TCPIntegerType then
  begin
    LIntegerType := FType as TCPIntegerType;
    
    // Handle different integer types with proper range support
    case LIntegerType.BuiltInType of
      cptInt8: Result := IntToStr(FValue.AsType<Int8>());
      cptInt16: Result := IntToStr(FValue.AsType<Int16>());
      cptInt32: Result := IntToStr(FValue.AsType<Int32>());
      cptInt64: Result := IntToStr(FValue.AsType<Int64>());
      cptUInt8: Result := UIntToStr(FValue.AsType<UInt8>());
      cptUInt16: Result := UIntToStr(FValue.AsType<UInt16>());
      cptUInt32: Result := UIntToStr(FValue.AsType<UInt32>());
      cptUInt64: Result := UIntToStr(FValue.AsType<UInt64>());
    else
      Result := FValue.ToString;
    end;
  end
  else if FType is TCPFloatType then
  begin
    LFloatType := FType as TCPFloatType;
    
    // Create format settings for precise floating point output
    LFormatSettings := TFormatSettings.Create();
    LFormatSettings.DecimalSeparator := '.';
    
    // Handle different float types with simple, precise formatting
    case LFloatType.BuiltInType of
      cptFloat32:
      begin
        // Format Float32 with controlled precision to avoid excessive decimal places
        Result := FormatFloat('0.######', FValue.AsType<Single>(), LFormatSettings);
      end;
      cptFloat64:
      begin
        // Format Float64 with controlled precision to avoid excessive decimal places
        Result := FormatFloat('0.##############', FValue.AsType<Double>(), LFormatSettings);
      end;
    else
      Result := FValue.ToString;
    end;
  end
  else if FType is TCPBooleanType then
  begin
    Result := BoolToStr(FValue.AsType<Boolean>(), True);
  end
  else if FType is TCPStringType then
  begin
    Result := QuotedStr(FValue.AsType<string>());
  end
  else if FType is TCPCharType then
  begin
    Result := QuotedStr(FValue.AsType<Char>());
  end
  else
  begin
    // Fallback to general TValue handling for unknown types
    case FValue.TypeInfo.Kind of
      tkInteger: Result := IntToStr(FValue.AsInteger);
      tkFloat: Result := FloatToStr(FValue.AsExtended);
      tkEnumeration:
        if FValue.TypeInfo = TypeInfo(Boolean) then
          Result := BoolToStr(FValue.AsBoolean, True)
        else
          Result := FValue.ToString;
      tkUString, tkString, tkWString:
        Result := QuotedStr(FValue.AsString);
      tkChar, tkWChar:
        Result := QuotedStr(FValue.AsString);
    else
      Result := FValue.ToString;
    end;
  end;
end;

function TCPLiteral.GetIR(): string;
begin
  // Placeholder - will be implemented in Phase 2
  Result := '';
  raise ECPException.Create('IR generation not implemented in Phase 1', []);
end;

function TCPLiteral.GetType(): ICPType;
begin
  Result := FType;
end;

function TCPLiteral.Validate(): Boolean;
var
  LIntegerType: TCPIntegerType;
begin
  // TValue-based literals are always syntactically valid since they store typed values
  Result := True;
  
  // Enhanced validation: Check range for integer types
  if FType is TCPIntegerType then
  begin
    LIntegerType := FType as TCPIntegerType;
    
    // Validate that the value is within the type's range
    if FValue.TypeInfo.Kind = tkInteger then
    begin
      if not LIntegerType.IsInRange(FValue.AsInteger) then
      begin
        raise ECPException.Create(
          'Integer literal %d is out of range for type %s (range: %d..%d)',
          [FValue.AsInteger, LIntegerType.GetName(), LIntegerType.MinValue, LIntegerType.MaxValue],
          FSourceLocation.FileName,
          FSourceLocation.Line,
          FSourceLocation.Column
        );
      end;
    end;
  end;
end;

{ TCPVariable }

constructor TCPVariable.Create(const AIdentifier: ICPIdentifier; const AType: ICPType; const ALocation: TCPSourceLocation);
begin
  inherited Create(ALocation);
  FIdentifier := AIdentifier;
  FType := AType;
end;

function TCPVariable.GetCPas(const APrettyPrint: Boolean): string;
begin
  // Variables are the same in both pretty print and canonical modes
  Result := FIdentifier.GetName();
end;

function TCPVariable.GetIR(): string;
begin
  // Placeholder - will be implemented in Phase 2
  Result := '';
  raise ECPException.Create('IR generation not implemented in Phase 1', []);
end;

function TCPVariable.GetType(): ICPType;
begin
  Result := FType;
end;

function TCPVariable.Validate(): Boolean;
begin
  Result := FIdentifier.IsValid();
  if not Result then
    raise ECPException.Create(
      'Invalid variable identifier: "%s"',
      [FIdentifier.GetName()],
      FSourceLocation.FileName,
      FSourceLocation.Line,
      FSourceLocation.Column
    );
end;

{ TCPBinaryOp }

constructor TCPBinaryOp.Create(const ALeft: ICPExpression; const AOperator: TCPBinaryOperator;
  const ARight: ICPExpression; const ALocation: TCPSourceLocation);
begin
  inherited Create(ALocation);
  FLeft := ALeft;
  FRight := ARight;
  FOperator := AOperator;
  
  // Calculate result type using Type Registry singleton
  FResultType := TCPTypeRegistry.GetInstance().FindCommonType(FLeft.GetType(), FRight.GetType());
  
  // If no common type found, default to left operand type
  if FResultType = nil then
    FResultType := FLeft.GetType();
end;

function TCPBinaryOp.GetCPas(const APrettyPrint: Boolean): string;
begin
  if APrettyPrint then
    // Pretty print: Add spaces around operators but no outer parentheses for simple expressions
    Result := Format('%s %s %s', [FLeft.GetCPas(True), GetOperatorString(FOperator), FRight.GetCPas(True)])
  else
    // Canonical: Minimal spacing, no outer parentheses
    Result := Format('%s%s%s', [FLeft.GetCPas(False), GetOperatorString(FOperator), FRight.GetCPas(False)]);
end;

function TCPBinaryOp.GetIR(): string;
begin
  // Placeholder - will be implemented in Phase 2
  Result := '';
  raise ECPException.Create('IR generation not implemented in Phase 1', []);
end;

function TCPBinaryOp.GetType(): ICPType;
begin
  Result := FResultType;
end;

function TCPBinaryOp.Validate(): Boolean;
begin
  // Validate operands
  if not FLeft.Validate() then
    Exit(False);
  if not FRight.Validate() then
    Exit(False);

  // Enhanced type compatibility checking
  if FResultType = nil then
  begin
    raise ECPException.Create(
      'Incompatible types in binary operation: %s %s %s',
      [FLeft.GetType().GetName(), GetOperatorString(FOperator), FRight.GetType().GetName()],
      FSourceLocation.FileName,
      FSourceLocation.Line,
      FSourceLocation.Column
    );
  end;
  
  Result := True;
end;

{ TCPUnaryOp }

constructor TCPUnaryOp.Create(const AOperator: TCPUnaryOperator; const AOperand: ICPExpression; 
  const ALocation: TCPSourceLocation);
begin
  inherited Create(ALocation);
  FOperator := AOperator;
  FOperand := AOperand;
  
  // Calculate result type based on operator and operand type
  case AOperator of
    cpOpNeg:      // -x: same type as operand
      FResultType := FOperand.GetType();
    cpOpNot:      // not x: Boolean result
      FResultType := TCPTypeRegistry.GetInstance().GetBooleanType();
    cpOpAddr:     // @x: pointer type (for now, use operand type)
      FResultType := FOperand.GetType();
    cpOpDeref:    // x^: operand should be pointer, result is pointed-to type
      FResultType := FOperand.GetType();
  else
    FResultType := FOperand.GetType(); // Default: same as operand
  end;
end;

function TCPUnaryOp.GetCPas(const APrettyPrint: Boolean): string;
var
  LOperatorStr: string;
begin
  LOperatorStr := GetOperatorString(FOperator);
  if FOperator = cpOpDeref then
    // Postfix operators (^) - no spacing difference
    Result := Format('%s%s', [FOperand.GetCPas(APrettyPrint), LOperatorStr])
  else
  begin
    // Prefix operators (-, not, @)
    if APrettyPrint and (FOperator = cpOpNot) then
      // Pretty print: Add space after 'not' keyword
      Result := Format('%s %s', [LOperatorStr, FOperand.GetCPas(True)])
    else
      // Canonical or non-keyword operators: No space
      Result := Format('%s%s', [LOperatorStr, FOperand.GetCPas(APrettyPrint)]);
  end;
end;

function TCPUnaryOp.GetIR(): string;
begin
  // Placeholder - will be implemented in Phase 2
  Result := '';
  raise ECPException.Create('IR generation not implemented in Phase 1', []);
end;

function TCPUnaryOp.GetType(): ICPType;
begin
  Result := FResultType;
end;

function TCPUnaryOp.Validate(): Boolean;
begin
  Result := FOperand.Validate();
  
  // Enhanced type validation for specific operators
  if Result then
  begin
    case FOperator of
      cpOpNot:
      begin
        // 'not' operator requires Boolean operand
        if not (FOperand.GetType() is TCPBooleanType) then
        begin
          raise ECPException.Create(
            'Invalid operand type for "not" operator: expected Boolean, got %s',
            [FOperand.GetType().GetName()],
            FSourceLocation.FileName,
            FSourceLocation.Line,
            FSourceLocation.Column
          );
        end;
      end;
      cpOpNeg:
      begin
        // Negation requires numeric types
        if not ((FOperand.GetType() is TCPIntegerType) or (FOperand.GetType() is TCPFloatType)) then
        begin
          raise ECPException.Create(
            'Invalid operand type for negation: expected numeric type, got %s',
            [FOperand.GetType().GetName()],
            FSourceLocation.FileName,
            FSourceLocation.Line,
            FSourceLocation.Column
          );
        end;
      end;
      // cpOpAddr and cpOpDeref: Additional pointer validation could be added here
    end;
  end;
end;

{ TCPFunctionCall }

constructor TCPFunctionCall.Create(const AFunctionName: ICPIdentifier; const AParameters: array of ICPExpression; 
  const AReturnType: ICPType; const ALocation: TCPSourceLocation);
var
  LIndex: Integer;
begin
  inherited Create(ALocation);
  FFunctionName := AFunctionName;
  FReturnType := AReturnType;
  
  SetLength(FParameters, Length(AParameters));
  for LIndex := 0 to High(AParameters) do
    FParameters[LIndex] := AParameters[LIndex];
end;

function TCPFunctionCall.GetCPas(const APrettyPrint: Boolean): string;
var
  LParams: string;
  LIndex: Integer;
  LSeparator: string;
begin
  if APrettyPrint then
    LSeparator := ', '  // Pretty print: Space after comma
  else
    LSeparator := ',';  // Canonical: No space after comma
    
  LParams := '';
  for LIndex := 0 to High(FParameters) do
  begin
    if LIndex > 0 then
      LParams := LParams + LSeparator;
    LParams := LParams + FParameters[LIndex].GetCPas(APrettyPrint);
  end;
  
  Result := Format('%s(%s)', [FFunctionName.GetName(), LParams]);
end;

function TCPFunctionCall.GetIR(): string;
begin
  // Placeholder - will be implemented in Phase 2
  Result := '';
  raise ECPException.Create('IR generation not implemented in Phase 1', []);
end;

function TCPFunctionCall.GetType(): ICPType;
begin
  Result := FReturnType;
end;

function TCPFunctionCall.Validate(): Boolean;
var
  LIndex: Integer;
begin
  if not FFunctionName.IsValid() then
    Exit(False);
    
  for LIndex := 0 to High(FParameters) do
  begin
    if not FParameters[LIndex].Validate() then
      Exit(False);
  end;
  
  Result := True;
end;

{ TCPArrayAccess }

constructor TCPArrayAccess.Create(const AArray: ICPExpression; const AIndex: ICPExpression;
  const AElementType: ICPType; const ALocation: TCPSourceLocation);
begin
  inherited Create(ALocation);
  FArray := AArray;
  FIndex := AIndex;
  FElementType := AElementType;
end;

function TCPArrayAccess.GetCPas(const APrettyPrint: Boolean): string;
begin
  // Array access is the same in both pretty print and canonical modes
  Result := Format('%s[%s]', [FArray.GetCPas(APrettyPrint), FIndex.GetCPas(APrettyPrint)]);
end;

function TCPArrayAccess.GetIR(): string;
begin
  // Placeholder - will be implemented in Phase 2
  Result := '';
  raise ECPException.Create('IR generation not implemented in Phase 1', []);
end;

function TCPArrayAccess.GetType(): ICPType;
begin
  Result := FElementType;
end;

function TCPArrayAccess.Validate(): Boolean;
begin
  Result := FArray.Validate() and FIndex.Validate();
end;

{ TCPFieldAccess }

constructor TCPFieldAccess.Create(const ARecord: ICPExpression; const AFieldName: ICPIdentifier; 
  const AFieldType: ICPType; const ALocation: TCPSourceLocation);
begin
  inherited Create(ALocation);
  FRecord := ARecord;
  FFieldName := AFieldName;
  FFieldType := AFieldType;
end;

function TCPFieldAccess.GetCPas(const APrettyPrint: Boolean): string;
begin
  // Field access is the same in both pretty print and canonical modes
  Result := Format('%s.%s', [FRecord.GetCPas(APrettyPrint), FFieldName.GetName()]);
end;

function TCPFieldAccess.GetIR(): string;
begin
  // Placeholder - will be implemented in Phase 2
  Result := '';
  raise ECPException.Create('IR generation not implemented in Phase 1', []);
end;

function TCPFieldAccess.GetType(): ICPType;
begin
  Result := FFieldType;
end;

function TCPFieldAccess.Validate(): Boolean;
begin
  Result := FRecord.Validate() and FFieldName.IsValid();
end;

{ TCPTypecast }

constructor TCPTypecast.Create(const AExpression: ICPExpression; const ATargetType: ICPType;
  const ALocation: TCPSourceLocation);
begin
  inherited Create(ALocation);
  FExpression := AExpression;
  FTargetType := ATargetType;
end;

function TCPTypecast.GetCPas(const APrettyPrint: Boolean): string;
begin
  // Type cast is the same in both pretty print and canonical modes
  Result := Format('%s(%s)', [FTargetType.GetName(), FExpression.GetCPas(APrettyPrint)]);
end;

function TCPTypecast.GetIR(): string;
begin
  // Placeholder - will be implemented in Phase 2
  Result := '';
  raise ECPException.Create('IR generation not implemented in Phase 1', []);
end;

function TCPTypecast.GetType(): ICPType;
begin
  Result := FTargetType;
end;

function TCPTypecast.Validate(): Boolean;
begin
  Result := FExpression.Validate();
  // Type cast compatibility checking would be done here
end;

{ TCPTernaryOp }

constructor TCPTernaryOp.Create(const ACondition: ICPExpression; const ATrueExpr: ICPExpression;
  const AFalseExpr: ICPExpression; const ALocation: TCPSourceLocation);
begin
  inherited Create(ALocation);
  FCondition := ACondition;
  FTrueExpr := ATrueExpr;
  FFalseExpr := AFalseExpr;
  
  // Calculate result type - common type of true and false expressions
  FResultType := TCPTypeRegistry.GetInstance().FindCommonType(FTrueExpr.GetType(), FFalseExpr.GetType());
  
  // If no common type found, use true expression type
  if FResultType = nil then
    FResultType := FTrueExpr.GetType();
end;

function TCPTernaryOp.GetCPas(const APrettyPrint: Boolean): string;
begin
  if APrettyPrint then
    // Pretty print: Spaces around operators, no outer parentheses
    Result := Format('%s ? %s : %s', [
      FCondition.GetCPas(True),
      FTrueExpr.GetCPas(True),
      FFalseExpr.GetCPas(True)
    ])
  else
    // Canonical: Minimal spacing, no outer parentheses
    Result := Format('%s?%s:%s', [
      FCondition.GetCPas(False),
      FTrueExpr.GetCPas(False),
      FFalseExpr.GetCPas(False)
    ]);
end;

function TCPTernaryOp.GetIR(): string;
begin
  // Placeholder - will be implemented in Phase 2
  Result := '';
  raise ECPException.Create('IR generation not implemented in Phase 1', []);
end;

function TCPTernaryOp.GetType(): ICPType;
begin
  Result := FResultType;
end;

function TCPTernaryOp.Validate(): Boolean;
begin
  Result := FCondition.Validate() and FTrueExpr.Validate() and FFalseExpr.Validate();
  
  // Enhanced validation for ternary operator
  if Result then
  begin
    // Condition must be Boolean type
    if not (FCondition.GetType() is TCPBooleanType) then
    begin
      raise ECPException.Create(
        'Ternary condition must be Boolean type, got %s',
        [FCondition.GetType().GetName()],
        FSourceLocation.FileName,
        FSourceLocation.Line,
        FSourceLocation.Column
      );
    end;
    
    // Check if result type was successfully calculated
    if FResultType = nil then
    begin
      raise ECPException.Create(
        'Incompatible types in ternary expression: %s and %s',
        [FTrueExpr.GetType().GetName(), FFalseExpr.GetType().GetName()],
        FSourceLocation.FileName,
        FSourceLocation.Line,
        FSourceLocation.Column
      );
    end;
  end;
end;

{ TCPType }

constructor TCPType.Create(const AName: string; const ASize: Integer);
begin
  inherited Create();
  FName := AName;
  FSize := ASize;
end;

function TCPType.GetName(): string;
begin
  Result := FName;
end;

function TCPType.GetSize(): Integer;
begin
  Result := FSize;
end;

function TCPType.IsCompatibleWith(const AOther: ICPType): Boolean;
begin
  // Basic compatibility check - same type name
  // This will be enhanced when the full type system is implemented
  Result := (AOther <> nil) and (FName = AOther.GetName());
end;

{ TCPIntegerType }

constructor TCPIntegerType.Create(const ABuiltInType: TCPBuiltInType);
begin
  FBuiltInType := ABuiltInType;
  
  case ABuiltInType of
    cptInt8:
    begin
      inherited Create('Int8', 1);
      FMinValue := -128;
      FMaxValue := 127;
      FIsSigned := True;
    end;
    cptInt16:
    begin
      inherited Create('Int16', 2);
      FMinValue := -32768;
      FMaxValue := 32767;
      FIsSigned := True;
    end;
    cptInt32:
    begin
      inherited Create('Int32', 4);
      FMinValue := -2147483648;
      FMaxValue := 2147483647;
      FIsSigned := True;
    end;
    cptInt64:
    begin
      inherited Create('Int64', 8);
      FMinValue := Low(Int64);
      FMaxValue := High(Int64);
      FIsSigned := True;
    end;
    cptUInt8:
    begin
      inherited Create('UInt8', 1);
      FMinValue := 0;
      FMaxValue := 255;
      FIsSigned := False;
    end;
    cptUInt16:
    begin
      inherited Create('UInt16', 2);
      FMinValue := 0;
      FMaxValue := 65535;
      FIsSigned := False;
    end;
    cptUInt32:
    begin
      inherited Create('UInt32', 4);
      FMinValue := 0;
      FMaxValue := 4294967295;
      FIsSigned := False;
    end;
    cptUInt64:
    begin
      inherited Create('UInt64', 8);
      FMinValue := 0;
      FMaxValue := High(Int64); // Limitation: using Int64 max for UInt64
      FIsSigned := False;
    end;
  else
    raise ECPException.Create('Invalid integer type: %d', [Ord(ABuiltInType)]);
  end;
end;

function TCPIntegerType.IsCompatibleWith(const AOther: ICPType): Boolean;
var
  LOtherIntType: TCPIntegerType;
begin
  Result := inherited IsCompatibleWith(AOther);
  if Result then
    Exit; // Exact match
    
  // Check for integer type promotion
  if AOther is TCPIntegerType then
  begin
    LOtherIntType := AOther as TCPIntegerType;
    Result := CanPromoteTo(LOtherIntType);
  end;
end;

function TCPIntegerType.CanPromoteTo(const AOther: ICPType): Boolean;
var
  LOtherIntType: TCPIntegerType;
begin
  Result := False;
  
  if not (AOther is TCPIntegerType) then
    Exit;
    
  LOtherIntType := AOther as TCPIntegerType;
  
  // Signed integer promotion: Int8 → Int16 → Int32 → Int64
  if FIsSigned and LOtherIntType.IsSigned then
  begin
    case FBuiltInType of
      cptInt8: Result := LOtherIntType.BuiltInType in [cptInt16, cptInt32, cptInt64];
      cptInt16: Result := LOtherIntType.BuiltInType in [cptInt32, cptInt64];
      cptInt32: Result := LOtherIntType.BuiltInType = cptInt64;
      cptInt64: Result := False; // Int64 is the largest signed integer
    end;
  end
  // Unsigned integer promotion: UInt8 → UInt16 → UInt32 → UInt64
  else if not FIsSigned and not LOtherIntType.IsSigned then
  begin
    case FBuiltInType of
      cptUInt8: Result := LOtherIntType.BuiltInType in [cptUInt16, cptUInt32, cptUInt64];
      cptUInt16: Result := LOtherIntType.BuiltInType in [cptUInt32, cptUInt64];
      cptUInt32: Result := LOtherIntType.BuiltInType = cptUInt64;
      cptUInt64: Result := False; // UInt64 is the largest unsigned integer
    end;
  end;
  // Mixed signed/unsigned promotion requires careful range checking
  // For now, don't allow automatic promotion between signed/unsigned
end;

function TCPIntegerType.IsInRange(const AValue: Int64): Boolean;
begin
  Result := (AValue >= FMinValue) and (AValue <= FMaxValue);
end;

{ TCPFloatType }

constructor TCPFloatType.Create(const ABuiltInType: TCPBuiltInType);
begin
  FBuiltInType := ABuiltInType;
  
  case ABuiltInType of
    cptFloat32:
    begin
      inherited Create('Float32', 4);
      FPrecision := 7; // Approximate decimal digits of precision
    end;
    cptFloat64:
    begin
      inherited Create('Float64', 8);
      FPrecision := 15; // Approximate decimal digits of precision
    end;
  else
    raise ECPException.Create('Invalid float type: %d', [Ord(ABuiltInType)]);
  end;
end;

function TCPFloatType.IsCompatibleWith(const AOther: ICPType): Boolean;
begin
  Result := inherited IsCompatibleWith(AOther);
  if Result then
    Exit; // Exact match
    
  // Check for float type promotion
  if AOther is TCPFloatType then
    Result := CanPromoteTo(AOther);
end;

function TCPFloatType.CanPromoteTo(const AOther: ICPType): Boolean;
var
  LOtherFloatType: TCPFloatType;
begin
  Result := False;
  
  if not (AOther is TCPFloatType) then
    Exit;
    
  LOtherFloatType := AOther as TCPFloatType;
  
  // Float promotion: Float32 → Float64
  if (FBuiltInType = cptFloat32) and (LOtherFloatType.BuiltInType = cptFloat64) then
    Result := True;
end;

{ TCPBooleanType }

constructor TCPBooleanType.Create();
begin
  inherited Create('Boolean', 1);
end;

function TCPBooleanType.IsCompatibleWith(const AOther: ICPType): Boolean;
begin
  // Boolean only compatible with other Boolean types
  Result := (AOther <> nil) and (AOther is TCPBooleanType);
end;

{ TCPStringType }

constructor TCPStringType.Create();
begin
  inherited Create('string', 0); // Variable size
end;

function TCPStringType.IsCompatibleWith(const AOther: ICPType): Boolean;
begin
  // String compatible with other string types and char (char can promote to string)
  Result := (AOther <> nil) and ((AOther is TCPStringType) or (AOther is TCPCharType));
end;

{ TCPCharType }

constructor TCPCharType.Create();
begin
  inherited Create('Char', 1);
end;

function TCPCharType.IsCompatibleWith(const AOther: ICPType): Boolean;
begin
  // Char compatible with other char types, and can promote to string
  Result := (AOther <> nil) and ((AOther is TCPCharType) or (AOther is TCPStringType));
end;

function TCPCharType.CanPromoteToString(): Boolean;
begin
  Result := True; // Char can always be promoted to string
end;

{ TCPTypeRegistry }

constructor TCPTypeRegistry.Create();
begin
  inherited Create();
  CreateBuiltInTypes();
end;

destructor TCPTypeRegistry.Destroy();
var
  LBuiltInType: TCPBuiltInType;
begin
  // Clear all type references
  for LBuiltInType := Low(TCPBuiltInType) to High(TCPBuiltInType) do
    FBuiltInTypes[LBuiltInType] := nil;
  FStringType := nil;
  FCharType := nil;
  FBooleanType := nil;
  inherited Destroy();
end;

procedure TCPTypeRegistry.CreateBuiltInTypes();
begin
  // Create all integer types
  FBuiltInTypes[cptInt8] := TCPIntegerType.Create(cptInt8);
  FBuiltInTypes[cptInt16] := TCPIntegerType.Create(cptInt16);
  FBuiltInTypes[cptInt32] := TCPIntegerType.Create(cptInt32);
  FBuiltInTypes[cptInt64] := TCPIntegerType.Create(cptInt64);
  FBuiltInTypes[cptUInt8] := TCPIntegerType.Create(cptUInt8);
  FBuiltInTypes[cptUInt16] := TCPIntegerType.Create(cptUInt16);
  FBuiltInTypes[cptUInt32] := TCPIntegerType.Create(cptUInt32);
  FBuiltInTypes[cptUInt64] := TCPIntegerType.Create(cptUInt64);
  
  // Create float types
  FBuiltInTypes[cptFloat32] := TCPFloatType.Create(cptFloat32);
  FBuiltInTypes[cptFloat64] := TCPFloatType.Create(cptFloat64);
  
  // Create other types
  FBooleanType := TCPBooleanType.Create();
  FBuiltInTypes[cptBoolean] := FBooleanType;
  
  FStringType := TCPStringType.Create();
  FBuiltInTypes[cptString] := FStringType;
  
  FCharType := TCPCharType.Create();
  FBuiltInTypes[cptChar] := FCharType;
end;

function TCPTypeRegistry.GetType(const ABuiltInType: TCPBuiltInType): ICPType;
begin
  Result := FBuiltInTypes[ABuiltInType];
  if Result = nil then
    raise ECPException.Create('Built-in type not initialized: %d', [Ord(ABuiltInType)]);
end;

function TCPTypeRegistry.GetStringType(): ICPType;
begin
  Result := FStringType;
end;

function TCPTypeRegistry.GetCharType(): ICPType;
begin
  Result := FCharType;
end;

function TCPTypeRegistry.GetBooleanType(): ICPType;
begin
  Result := FBooleanType;
end;

function TCPTypeRegistry.FindCommonType(const AType1, AType2: ICPType): ICPType;
var
  LIntType1, LIntType2: TCPIntegerType;
  LFloatType1, LFloatType2: TCPFloatType;
begin
  Result := nil;
  
  // Same type - return either one
  if AType1.GetName() = AType2.GetName() then
  begin
    Result := AType1;
    Exit;
  end;
  
  // Integer type promotion
  if (AType1 is TCPIntegerType) and (AType2 is TCPIntegerType) then
  begin
    LIntType1 := AType1 as TCPIntegerType;
    LIntType2 := AType2 as TCPIntegerType;
    
    // Find the larger type that both can promote to
    if LIntType1.CanPromoteTo(AType2) then
      Result := AType2  // Type1 promotes to Type2
    else if LIntType2.CanPromoteTo(AType1) then
      Result := AType1  // Type2 promotes to Type1
    else
    begin
      // Find common promotion target
      if LIntType1.IsSigned and LIntType2.IsSigned then
      begin
        // Both signed - promote to largest
        if (LIntType1.BuiltInType = cptInt64) or (LIntType2.BuiltInType = cptInt64) then
          Result := GetType(cptInt64)
        else if (LIntType1.BuiltInType = cptInt32) or (LIntType2.BuiltInType = cptInt32) then
          Result := GetType(cptInt32)
        else if (LIntType1.BuiltInType = cptInt16) or (LIntType2.BuiltInType = cptInt16) then
          Result := GetType(cptInt16)
        else
          Result := GetType(cptInt8);
      end
      else if not LIntType1.IsSigned and not LIntType2.IsSigned then
      begin
        // Both unsigned - promote to largest
        if (LIntType1.BuiltInType = cptUInt64) or (LIntType2.BuiltInType = cptUInt64) then
          Result := GetType(cptUInt64)
        else if (LIntType1.BuiltInType = cptUInt32) or (LIntType2.BuiltInType = cptUInt32) then
          Result := GetType(cptUInt32)
        else if (LIntType1.BuiltInType = cptUInt16) or (LIntType2.BuiltInType = cptUInt16) then
          Result := GetType(cptUInt16)
        else
          Result := GetType(cptUInt8);
      end;
      // Mixed signed/unsigned - no automatic promotion for now
    end;
  end
  // Float type promotion
  else if (AType1 is TCPFloatType) and (AType2 is TCPFloatType) then
  begin
    LFloatType1 := AType1 as TCPFloatType;
    LFloatType2 := AType2 as TCPFloatType;
    
    // Always promote to Float64 if either is Float64
    if (LFloatType1.BuiltInType = cptFloat64) or (LFloatType2.BuiltInType = cptFloat64) then
      Result := GetType(cptFloat64)
    else
      Result := GetType(cptFloat32);
  end
  // Integer to float promotion
  else if (AType1 is TCPIntegerType) and (AType2 is TCPFloatType) then
    Result := AType2  // Integer promotes to float
  else if (AType1 is TCPFloatType) and (AType2 is TCPIntegerType) then
    Result := AType1  // Integer promotes to float
  // Char to string promotion
  else if (AType1 is TCPCharType) and (AType2 is TCPStringType) then
    Result := AType2  // Char promotes to string
  else if (AType1 is TCPStringType) and (AType2 is TCPCharType) then
    Result := AType1; // Char promotes to string
end;

function TCPTypeRegistry.GetPromotedType(const AFromType, AToType: ICPType): ICPType;
begin
  // Check if AFromType can be promoted to AToType
  if AFromType.IsCompatibleWith(AToType) then
    Result := AToType
  else
    Result := nil; // No valid promotion
end;

class function TCPTypeRegistry.GetInstance(): TCPTypeRegistry;
begin
  if FInstance = nil then
    FInstance := TCPTypeRegistry.Create();
  Result := FInstance;
end;

class procedure TCPTypeRegistry.ReleaseInstance();
begin
  if FInstance <> nil then
  begin
    FreeAndNil(FInstance);
  end;
end;

initialization
  // Required: initialization section must precede finalization section
  // Empty initialization - type registry uses lazy singleton pattern

finalization
  TCPTypeRegistry.ReleaseInstance();

end.
