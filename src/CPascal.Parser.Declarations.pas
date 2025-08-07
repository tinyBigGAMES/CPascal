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

unit CPascal.Parser.Declarations;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  CPascal.Lexer,
  CPascal.AST,
  CPascal.Parser;

function ParseDeclarations(const AParser: TCPParser): TCPASTNodeList;

implementation

uses
  CPascal.Parser.Functions,
  CPascal.Parser.Variables,
  CPascal.Parser.Types;

function ParseDeclarations(const AParser: TCPParser): TCPASTNodeList;
var
  LDeclaration: TCPASTNode;
  LVarDeclarations: TCPASTNodeList;
  LIndex: Integer;
begin
  Result := TCPASTNodeList.Create(False); // Don't own objects, they'll be owned by the program

  // Parse all declarations until we hit 'begin' (start of main body)
  while not AParser.MatchToken(tkBegin) and not AParser.MatchToken(tkEOF) do
  begin
    case AParser.CurrentToken.Kind of
      tkFunction, tkProcedure:
      begin
        LDeclaration := ParseFunctionDeclaration(AParser);
        Result.Add(LDeclaration);
      end;

      tkVar:
      begin
        LVarDeclarations := ParseVarSection(AParser);
        try
          // Add all variable declarations to result
          for LIndex := 0 to LVarDeclarations.Count - 1 do
          begin
            LDeclaration := LVarDeclarations[LIndex];
            Result.Add(LDeclaration);
          end;
        finally
          LVarDeclarations.Free; // Free the temporary list (not the nodes, they're owned by Result)
        end;
      end;

      tkType:
      begin
        LVarDeclarations := ParseTypeSection(AParser);
        try
          // Add all type declarations to result
          for LIndex := 0 to LVarDeclarations.Count - 1 do
          begin
            LDeclaration := LVarDeclarations[LIndex];
            Result.Add(LDeclaration);
          end;
        finally
          LVarDeclarations.Free; // Free the temporary list (not the nodes, they're owned by Result)
        end;
      end;

      // Skip const declarations for now
      tkConst:
      begin
        AParser.ParseError('Declaration type %s not yet implemented', [CPTokenKindToString(AParser.CurrentToken.Kind)]);
      end;

    else
      AParser.ParseError('Unexpected token in declarations: %s "%s"', [CPTokenKindToString(AParser.CurrentToken.Kind), AParser.CurrentToken.Value]);
    end;
  end;
end;

end.
