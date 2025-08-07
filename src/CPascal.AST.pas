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

unit CPascal.AST;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  CPascal.Exception,
  CPascal.Lexer;

type
  { TCPCompilationUnitKind - Compilation unit types }
  TCPCompilationUnitKind = (
    ckProgram,
    ckLibrary,
    ckModule
  );

  { TCPNodeKind - AST node type classification }
  TCPNodeKind = (
    // Program structure
    nkProgram,
    nkLibrary,
    nkModule,

    // Declarations
    nkConstDeclaration,
    nkTypeDeclaration,
    nkVarDeclaration,
    nkFunctionDeclaration,
    nkExternalFunction,
    nkParameter,

    // Types
    nkSimpleType,
    nkPointerType,
    nkArrayType,
    nkRecordType,
    nkFunctionType,

    // Statements
    nkCompoundStatement,
    nkAssignmentStatement,
    nkFunctionCall,
    nkIfStatement,
    nkWhileStatement,
    nkForStatement,
    nkCaseStatement,
    nkGotoStatement,
    nkLabelStatement,
    nkBreakStatement,
    nkContinueStatement,
    nkReturnStatement,

    // Expressions
    nkIdentifier,
    nkIntegerLiteral,
    nkRealLiteral,
    nkStringLiteral,
    nkCharacterLiteral,
    nkBooleanLiteral,
    nkNilLiteral,
    nkBinaryOperation,
    nkUnaryOperation,
    nkTernaryOperation,
    nkArrayAccess,
    nkFieldAccess,
    nkDereference,
    nkAddressOf,
    nkTypeCast,
    nkSizeOfExpression,
    nkTypeOfExpression
  );

  { TCPCallingConvention - Function calling conventions }
  TCPCallingConvention = (
    ccDefault,
    ccCdecl,
    ccStdcall,
    ccFastcall,
    ccRegister
  );

  { Forward declarations }
  TCPASTNode = class;

  { TCPASTNodeList - Generic list for AST nodes }
  TCPASTNodeList = class(TObjectList<TCPASTNode>);

  { TCPASTNode - Base class for all AST nodes }
  TCPASTNode = class
  protected
    FNodeKind: TCPNodeKind;
    FLocation: TCPSourceLocation;
    FParent: TCPASTNode;
    FChildren: TCPASTNodeList;

  public
    constructor Create(const ANodeKind: TCPNodeKind; const ALocation: TCPSourceLocation);
    destructor Destroy; override;

    procedure AddChild(const AChild: TCPASTNode);
    procedure RemoveChild(const AChild: TCPASTNode);
    function GetChild(const AIndex: Integer): TCPASTNode;
    function ChildCount(): Integer;

    property NodeKind: TCPNodeKind read FNodeKind;
    property Location: TCPSourceLocation read FLocation;
    property Parent: TCPASTNode read FParent write FParent;
    property Children: TCPASTNodeList read FChildren;
  end;

// Utility functions
function CPNodeKindToString(const ANodeKind: TCPNodeKind): string;
function CPCallingConventionToString(const ACallingConvention: TCPCallingConvention): string;
function CPCompilationUnitKindToString(const AUnitKind: TCPCompilationUnitKind): string;

implementation

{ Utility functions }
function CPNodeKindToString(const ANodeKind: TCPNodeKind): string;
begin
  case ANodeKind of
    nkProgram: Result := 'Program';
    nkLibrary: Result := 'Library';
    nkModule: Result := 'Module';
    nkConstDeclaration: Result := 'ConstDeclaration';
    nkTypeDeclaration: Result := 'TypeDeclaration';
    nkVarDeclaration: Result := 'VarDeclaration';
    nkFunctionDeclaration: Result := 'FunctionDeclaration';
    nkExternalFunction: Result := 'ExternalFunction';
    nkParameter: Result := 'Parameter';
    nkSimpleType: Result := 'SimpleType';
    nkPointerType: Result := 'PointerType';
    nkArrayType: Result := 'ArrayType';
    nkRecordType: Result := 'RecordType';
    nkFunctionType: Result := 'FunctionType';
    nkCompoundStatement: Result := 'CompoundStatement';
    nkAssignmentStatement: Result := 'AssignmentStatement';
    nkFunctionCall: Result := 'FunctionCall';
    nkIfStatement: Result := 'IfStatement';
    nkWhileStatement: Result := 'WhileStatement';
    nkForStatement: Result := 'ForStatement';
    nkCaseStatement: Result := 'CaseStatement';
    nkGotoStatement: Result := 'GotoStatement';
    nkLabelStatement: Result := 'LabelStatement';
    nkBreakStatement: Result := 'BreakStatement';
    nkContinueStatement: Result := 'ContinueStatement';
    nkReturnStatement: Result := 'ReturnStatement';
    nkIdentifier: Result := 'Identifier';
    nkIntegerLiteral: Result := 'IntegerLiteral';
    nkRealLiteral: Result := 'RealLiteral';
    nkStringLiteral: Result := 'StringLiteral';
    nkCharacterLiteral: Result := 'CharacterLiteral';
    nkBooleanLiteral: Result := 'BooleanLiteral';
    nkNilLiteral: Result := 'NilLiteral';
    nkBinaryOperation: Result := 'BinaryOperation';
    nkUnaryOperation: Result := 'UnaryOperation';
    nkTernaryOperation: Result := 'TernaryOperation';
    nkArrayAccess: Result := 'ArrayAccess';
    nkFieldAccess: Result := 'FieldAccess';
    nkDereference: Result := 'Dereference';
    nkAddressOf: Result := 'AddressOf';
    nkTypeCast: Result := 'TypeCast';
    nkSizeOfExpression: Result := 'SizeOfExpression';
    nkTypeOfExpression: Result := 'TypeOfExpression';
  else
    Result := 'Unknown';
  end;
end;

function CPCallingConventionToString(const ACallingConvention: TCPCallingConvention): string;
begin
  case ACallingConvention of
    ccDefault: Result := 'default';
    ccCdecl: Result := 'cdecl';
    ccStdcall: Result := 'stdcall';
    ccFastcall: Result := 'fastcall';
    ccRegister: Result := 'register';
  else
    Result := 'unknown';
  end;
end;

function CPCompilationUnitKindToString(const AUnitKind: TCPCompilationUnitKind): string;
begin
  case AUnitKind of
    ckProgram: Result := 'Program';
    ckLibrary: Result := 'Library';
    ckModule: Result := 'Module';
  else
    Result := 'Unknown';
  end;
end;

{ TCPASTNode }
constructor TCPASTNode.Create(const ANodeKind: TCPNodeKind; const ALocation: TCPSourceLocation);
begin
  inherited Create;
  FNodeKind := ANodeKind;
  FLocation := ALocation;
  FParent := nil;
  FChildren := TCPASTNodeList.Create(True); // Owns objects
end;

destructor TCPASTNode.Destroy;
begin
  FChildren.Free;
  inherited Destroy;
end;

procedure TCPASTNode.AddChild(const AChild: TCPASTNode);
begin
  if Assigned(AChild) then
  begin
    FChildren.Add(AChild);
    AChild.FParent := Self;
  end;
end;

procedure TCPASTNode.RemoveChild(const AChild: TCPASTNode);
begin
  if Assigned(AChild) then
  begin
    FChildren.Remove(AChild);
    AChild.FParent := nil;
  end;
end;

function TCPASTNode.GetChild(const AIndex: Integer): TCPASTNode;
begin
  if (AIndex >= 0) and (AIndex < FChildren.Count) then
    Result := FChildren[AIndex]
  else
    Result := nil;
end;

function TCPASTNode.ChildCount(): Integer;
begin
  Result := FChildren.Count;
end;



end.
