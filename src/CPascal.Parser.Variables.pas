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

unit CPascal.Parser.Variables;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  CPascal.Lexer,
  CPascal.Parser,
  CPascal.AST,
  CPascal.AST.Types,
  CPascal.AST.Declarations;

function ParseVarSection(const AParser: TCPParser): TCPASTNodeList;
function ParseVarDeclaration(const AParser: TCPParser): TCPVarDeclarationNode;
function ParseIdentifierList(const AParser: TCPParser): TStringList;

implementation

uses
  CPascal.Parser.Types;

function ParseVarSection(const AParser: TCPParser): TCPASTNodeList;
var
  LVarDeclaration: TCPVarDeclarationNode;
begin
  // Parse: ("public"? "var" | "var") <var_declaration>+
  Result := TCPASTNodeList.Create(False); // Don't own objects, they'll be owned by the program

  // Consume "var" keyword
  AParser.ConsumeToken(tkVar);

  // Parse variable declarations until we hit something that's not a variable declaration
  while AParser.MatchToken(tkIdentifier) or AParser.MatchToken(tkPublic) do
  begin
    LVarDeclaration := ParseVarDeclaration(AParser);
    Result.Add(LVarDeclaration);
  end;
end;

function ParseVarDeclaration(const AParser: TCPParser): TCPVarDeclarationNode;
var
  LIsPublic: Boolean;
  LIdentifierList: TStringList;
  LVariableType: TCPTypeNode;
  LVariableName: string;
  LIndex: Integer;
begin
  // Parse: "public"? <identifier_list> ":" <qualified_type> ";"
  
  // Check for public modifier
  LIsPublic := False;
  if AParser.MatchToken(tkPublic) then
  begin
    LIsPublic := True;
    AParser.AdvanceToken();
  end;

  // Parse identifier list
  LIdentifierList := ParseIdentifierList(AParser);

  try
    AParser.ConsumeToken(tkColon);

    // Parse variable type
    LVariableType := ParseType(AParser);

    AParser.ConsumeToken(tkSemicolon);

    // Create variable declaration node
    Result := TCPVarDeclarationNode.Create(
      AParser.CurrentToken.Location,
      LVariableType,
      LIsPublic
    );

    // Add all variable names to the declaration
    for LIndex := 0 to LIdentifierList.Count - 1 do
    begin
      LVariableName := LIdentifierList[LIndex];
      Result.AddVariableName(LVariableName);
    end;

  finally
    LIdentifierList.Free;
  end;
end;

function ParseIdentifierList(const AParser: TCPParser): TStringList;
var
  LIdentifierName: string;
begin
  // Parse: <identifier> ("," <identifier>)*
  Result := TStringList.Create;

  // Parse first identifier
  if not AParser.MatchToken(tkIdentifier) then
    AParser.UnexpectedToken('variable identifier');

  LIdentifierName := AParser.CurrentToken.Value;
  Result.Add(LIdentifierName);
  AParser.AdvanceToken();

  // Parse additional identifiers
  while AParser.MatchToken(tkComma) do
  begin
    AParser.AdvanceToken(); // Consume comma

    if not AParser.MatchToken(tkIdentifier) then
      AParser.UnexpectedToken('variable identifier');

    LIdentifierName := AParser.CurrentToken.Value;
    Result.Add(LIdentifierName);
    AParser.AdvanceToken();
  end;
end;

end.
