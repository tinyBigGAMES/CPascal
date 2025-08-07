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

unit CPascal.AST.Declarations;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  CPascal.Exception,
  CPascal.Lexer,
  CPascal.AST,
  CPascal.AST.Types;

type
  { TCPTypeDeclarationNode - Represents a type declaration in the AST }
  TCPTypeDeclarationNode = class(TCPASTNode)
  private
    FTypeName: string;
    FTypeDefinition: TCPTypeNode;
    FIsPublic: Boolean;

  public
    constructor Create(const ALocation: TCPSourceLocation; const ATypeName: string;
      const ATypeDefinition: TCPTypeNode; const AIsPublic: Boolean = False);
    destructor Destroy; override;

    property TypeName: string read FTypeName;
    property TypeDefinition: TCPTypeNode read FTypeDefinition;
    property IsPublic: Boolean read FIsPublic;
  end;

  { TCPVarDeclarationNode - Represents a variable declaration in the AST }
  TCPVarDeclarationNode = class(TCPASTNode)
  private
    FVariableNames: TStringList;
    FVariableType: TCPTypeNode;
    FIsPublic: Boolean;

  public
    constructor Create(const ALocation: TCPSourceLocation; const AVariableType: TCPTypeNode; const AIsPublic: Boolean = False);
    destructor Destroy; override;

    procedure AddVariableName(const AVariableName: string);
    function GetVariableName(const AIndex: Integer): string;
    function VariableNameCount(): Integer;

    property VariableNames: TStringList read FVariableNames;
    property VariableType: TCPTypeNode read FVariableType;
    property IsPublic: Boolean read FIsPublic;
  end;

implementation

{ TCPTypeDeclarationNode }
constructor TCPTypeDeclarationNode.Create(const ALocation: TCPSourceLocation;
  const ATypeName: string; const ATypeDefinition: TCPTypeNode;
  const AIsPublic: Boolean = False);
begin
  inherited Create(nkTypeDeclaration, ALocation);
  FTypeName := ATypeName;
  FTypeDefinition := ATypeDefinition;
  FIsPublic := AIsPublic;
end;

destructor TCPTypeDeclarationNode.Destroy;
begin
  FTypeDefinition.Free;
  inherited Destroy;
end;

{ TCPVarDeclarationNode }
constructor TCPVarDeclarationNode.Create(const ALocation: TCPSourceLocation; const AVariableType: TCPTypeNode; const AIsPublic: Boolean = False);
begin
  inherited Create(nkVarDeclaration, ALocation);
  FVariableNames := TStringList.Create;
  FVariableType := AVariableType;
  FIsPublic := AIsPublic;
end;

destructor TCPVarDeclarationNode.Destroy;
begin
  FVariableNames.Free;
  FVariableType.Free;
  inherited Destroy;
end;

procedure TCPVarDeclarationNode.AddVariableName(const AVariableName: string);
begin
  FVariableNames.Add(AVariableName);
end;

function TCPVarDeclarationNode.GetVariableName(const AIndex: Integer): string;
begin
  if (AIndex >= 0) and (AIndex < FVariableNames.Count) then
    Result := FVariableNames[AIndex]
  else
    Result := '';
end;

function TCPVarDeclarationNode.VariableNameCount(): Integer;
begin
  Result := FVariableNames.Count;
end;

end.
