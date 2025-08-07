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

unit CPascal.Parser.Types;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  CPascal.Exception,
  CPascal.Lexer,
  CPascal.Parser,
  CPascal.AST,
  CPascal.AST.Types,
  CPascal.AST.Declarations,
  CPascal.Parser.Expressions,
  CPascal.AST.Expressions;

function ParseType(const AParser: TCPParser): TCPTypeNode;
function ParseTypeSection(const AParser: TCPParser): TCPASTNodeList;


implementation

function ParseType(const AParser: TCPParser): TCPTypeNode;
var
  LTypeName: string;
  LIsPointer: Boolean;
  LStartIndex: TCPExpressionNode;
  LEndIndex: TCPExpressionNode;
  LElementType: TCPTypeNode;
  LLocation: TCPSourceLocation;
begin
  LIsPointer := False;
  LLocation := AParser.CurrentToken.Location;

  // Check for array type
  if AParser.MatchToken(tkArray) then
  begin
    AParser.AdvanceToken(); // Consume 'array'
    
    // Expect '['
    if not AParser.MatchToken(tkLeftBracket) then
      AParser.UnexpectedToken('[');
    AParser.AdvanceToken(); // Consume '['
    
    // Parse start index expression
    LStartIndex := ParseExpression(AParser);
    
    // Expect '..'
    if not AParser.MatchToken(tkDot) then
      AParser.UnexpectedToken('..');
    AParser.AdvanceToken(); // Consume first '.'
    
    if not AParser.MatchToken(tkDot) then
      AParser.UnexpectedToken('..');
    AParser.AdvanceToken(); // Consume second '.'
    
    // Parse end index expression  
    LEndIndex := ParseExpression(AParser);
    
    // Expect ']'
    if not AParser.MatchToken(tkRightBracket) then
      AParser.UnexpectedToken(']');
    AParser.AdvanceToken(); // Consume ']'
    
    // Expect 'of'
    if not AParser.MatchToken(tkOf) then
      AParser.UnexpectedToken('of');
    AParser.AdvanceToken(); // Consume 'of'
    
    // Parse element type
    LElementType := ParseType(AParser);
    
    Result := TCPArrayTypeNode.Create(LLocation, LStartIndex, LEndIndex, LElementType);
    Exit;
  end;

  // Check for pointer type
  if AParser.MatchToken(tkDereference) then // ^ symbol
  begin
    LIsPointer := True;
    AParser.AdvanceToken();
  end;

  // Parse type identifier
  if not AParser.MatchToken(tkIdentifier) then
    AParser.UnexpectedToken('type identifier');

  LTypeName := AParser.CurrentToken.Value;
  AParser.AdvanceToken();

  Result := TCPTypeNode.Create(LLocation, LTypeName, LIsPointer);
end;

function ParseTypeSection(const AParser: TCPParser): TCPASTNodeList;
var
  LIsPublic: Boolean;
  LTypeName: string;
  LTypeDefinition: TCPTypeNode;
  LTypeDeclaration: TCPTypeDeclarationNode;
  LLocation: TCPSourceLocation;
begin
  Result := TCPASTNodeList.Create(False); // Don't own objects, they'll be owned by the program

  // Check for public modifier
  LIsPublic := False;
  if AParser.MatchToken(tkPublic) then
  begin
    LIsPublic := True;
    AParser.AdvanceToken();
    
    // After 'public', 'type' is required
    if not AParser.MatchToken(tkType) then
      AParser.UnexpectedToken('type');
  end;

  // Skip 'type' keyword (already validated or consumed above)
  if AParser.MatchToken(tkType) then
    AParser.AdvanceToken();

  // Parse type declarations until we hit another section or begin
  while not AParser.MatchToken(tkConst) and not AParser.MatchToken(tkType) and
        not AParser.MatchToken(tkVar) and not AParser.MatchToken(tkFunction) and
        not AParser.MatchToken(tkProcedure) and not AParser.MatchToken(tkBegin) and
        not AParser.MatchToken(tkEOF) do
  begin
    // Mark location for error reporting
    LLocation := TCPSourceLocation.Create(AParser.CurrentToken.Location.FileName,
      AParser.CurrentToken.Location.Line, AParser.CurrentToken.Location.Column);

    // Parse optional 'public' for individual type declarations
    if AParser.MatchToken(tkPublic) then
    begin
      LIsPublic := True;
      AParser.AdvanceToken();
    end;

    // Parse type name
    if not AParser.MatchToken(tkIdentifier) then
      AParser.UnexpectedToken('type name');
    
    LTypeName := AParser.CurrentToken.Value;
    AParser.AdvanceToken();

    // Expect '='
    if not AParser.MatchToken(tkEqual) then
      AParser.UnexpectedToken('=');
    AParser.AdvanceToken();

    // Parse type definition
    LTypeDefinition := ParseType(AParser);

    // Expect ';'
    if not AParser.MatchToken(tkSemicolon) then
      AParser.UnexpectedToken(';');
    AParser.AdvanceToken();

    // Create type declaration node
    LTypeDeclaration := TCPTypeDeclarationNode.Create(LLocation, LTypeName, LTypeDefinition, LIsPublic);
    Result.Add(LTypeDeclaration);

    // Reset public flag for next declaration
    LIsPublic := False;
  end;
end;

end.
