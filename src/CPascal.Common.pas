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

unit CPascal.Common;

{$I CPascal.Defines.inc}

interface

uses
  SysUtils;

type
  { TCPSourceLocation }
  TCPSourceLocation = record
    FileName: string;
    Line: Integer;
    Column: Integer;
    class function Create(const AFileName: string; const ALine, AColumn: Integer): TCPSourceLocation; static;
  end;

  { ECPException }
  ECPException = class(Exception)
  private
    FErrorCode: Integer;
    FErrorCategory: string;
    FSourceFileName: string;
    FLineNumber: Integer;
    FColumnNumber: Integer;
    FContextInfo: string;
    FSuggestion: string;
    FRelatedSymbol: string;
    FExpectedType: string;
    FActualType: string;
  public
    // Basic error with formatting
    constructor Create(const AMessage: string; const AArgs: array of const); overload;
    
    // Syntax error with location and formatting
    constructor Create(const AMessage: string; const AArgs: array of const; 
                      const AFileName: string; const ALine, AColumn: Integer); overload;
    
    // Semantic error with symbol and formatting  
    constructor Create(const AMessage: string; const AArgs: array of const;
                      const ASymbol, AFileName: string; const ALine, AColumn: Integer); overload;
    
    // Type error with expected/actual types and formatting
    constructor Create(const AMessage: string; const AArgs: array of const;
                      const AExpectedType, AActualType, AFileName: string; 
                      const ALine, AColumn: Integer); overload;
    
    // Validation error with context/suggestion and formatting
    constructor Create(const AMessage: string; const AArgs: array of const;
                      const AContext, ASuggestion: string); overload;
    
    // Properties for rich error information
    property ErrorCode: Integer read FErrorCode;
    property ErrorCategory: string read FErrorCategory;
    property SourceFileName: string read FSourceFileName;
    property LineNumber: Integer read FLineNumber;
    property ColumnNumber: Integer read FColumnNumber;
    property ContextInfo: string read FContextInfo;
    property Suggestion: string read FSuggestion;
    property RelatedSymbol: string read FRelatedSymbol;
    property ExpectedType: string read FExpectedType;
    property ActualType: string read FActualType;
    
    // Formatted error output methods
    function GetDetailedMessage(): string;
    function GetFormattedLocation(): string;
    function GetErrorWithSuggestion(): string;
  end;

implementation

{ TCPSourceLocation }

class function TCPSourceLocation.Create(const AFileName: string; const ALine, AColumn: Integer): TCPSourceLocation;
begin
  Result.FileName := AFileName;
  Result.Line := ALine;
  Result.Column := AColumn;
end;

{ ECPException }

constructor ECPException.Create(const AMessage: string; const AArgs: array of const);
begin
  try
    inherited Create(Format(AMessage, AArgs));
  except
    on E: Exception do
      inherited Create(AMessage + ' [Format Error: ' + E.Message + ']');
  end;
  
  FErrorCode := 0;
  FErrorCategory := 'General';
  FSourceFileName := '';
  FLineNumber := 0;
  FColumnNumber := 0;
  FContextInfo := '';
  FSuggestion := '';
  FRelatedSymbol := '';
  FExpectedType := '';
  FActualType := '';
end;

{ ECPException }

constructor ECPException.Create(const AMessage: string; const AArgs: array of const; 
                               const AFileName: string; const ALine, AColumn: Integer);
begin
  try
    inherited Create(Format(AMessage, AArgs));
  except
    on E: Exception do
      inherited Create(AMessage + ' [Format Error: ' + E.Message + ']');
  end;
  
  FErrorCode := 0;
  FErrorCategory := 'Syntax';
  FSourceFileName := AFileName;
  FLineNumber := ALine;
  FColumnNumber := AColumn;
  FContextInfo := '';
  FSuggestion := '';
  FRelatedSymbol := '';
  FExpectedType := '';
  FActualType := '';
end;

{ ECPException }

constructor ECPException.Create(const AMessage: string; const AArgs: array of const;
                               const ASymbol, AFileName: string; const ALine, AColumn: Integer);
begin
  try
    inherited Create(Format(AMessage, AArgs));
  except
    on E: Exception do
      inherited Create(AMessage + ' [Format Error: ' + E.Message + ']');
  end;
  
  FErrorCode := 0;
  FErrorCategory := 'Semantic';
  FSourceFileName := AFileName;
  FLineNumber := ALine;
  FColumnNumber := AColumn;
  FContextInfo := '';
  FSuggestion := '';
  FRelatedSymbol := ASymbol;
  FExpectedType := '';
  FActualType := '';
end;

{ ECPException }

constructor ECPException.Create(const AMessage: string; const AArgs: array of const;
                               const AExpectedType, AActualType, AFileName: string; 
                               const ALine, AColumn: Integer);
begin
  try
    inherited Create(Format(AMessage, AArgs));
  except
    on E: Exception do
      inherited Create(AMessage + ' [Format Error: ' + E.Message + ']');
  end;
  
  FErrorCode := 0;
  FErrorCategory := 'Type';
  FSourceFileName := AFileName;
  FLineNumber := ALine;
  FColumnNumber := AColumn;
  FContextInfo := '';
  FSuggestion := '';
  FRelatedSymbol := '';
  FExpectedType := AExpectedType;
  FActualType := AActualType;
end;

{ ECPException }

constructor ECPException.Create(const AMessage: string; const AArgs: array of const;
                               const AContext, ASuggestion: string);
begin
  try
    inherited Create(Format(AMessage, AArgs));
  except
    on E: Exception do
      inherited Create(AMessage + ' [Format Error: ' + E.Message + ']');
  end;
  
  FErrorCode := 0;
  FErrorCategory := 'Validation';
  FSourceFileName := '';
  FLineNumber := 0;
  FColumnNumber := 0;
  FContextInfo := AContext;
  FSuggestion := ASuggestion;
  FRelatedSymbol := '';
  FExpectedType := '';
  FActualType := '';
end;

{ ECPException }

function ECPException.GetDetailedMessage(): string;
begin
  Result := Message;
  
  if FSourceFileName <> '' then
  begin
    Result := Result + sLineBreak + 'File: ' + FSourceFileName;
    if FLineNumber > 0 then
    begin
      Result := Result + sLineBreak + 'Line: ' + IntToStr(FLineNumber);
      if FColumnNumber > 0 then
        Result := Result + ', Column: ' + IntToStr(FColumnNumber);
    end;
  end;
  
  if FErrorCategory <> '' then
    Result := Result + sLineBreak + 'Category: ' + FErrorCategory;
    
  if FRelatedSymbol <> '' then
    Result := Result + sLineBreak + 'Symbol: ' + FRelatedSymbol;
    
  if (FExpectedType <> '') and (FActualType <> '') then
    Result := Result + sLineBreak + 'Expected: ' + FExpectedType + ', Got: ' + FActualType;
    
  if FContextInfo <> '' then
    Result := Result + sLineBreak + 'Context: ' + FContextInfo;
    
  if FSuggestion <> '' then
    Result := Result + sLineBreak + 'Suggestion: ' + FSuggestion;
end;

{ ECPException }

function ECPException.GetFormattedLocation(): string;
begin
  Result := '';
  
  if FSourceFileName <> '' then
  begin
    Result := FSourceFileName;
    if FLineNumber > 0 then
    begin
      Result := Result + '(' + IntToStr(FLineNumber);
      if FColumnNumber > 0 then
        Result := Result + ',' + IntToStr(FColumnNumber);
      Result := Result + ')';
    end;
  end;
end;

{ ECPException }

function ECPException.GetErrorWithSuggestion(): string;
begin
  Result := Message;
  
  if FSuggestion <> '' then
    Result := Result + sLineBreak + sLineBreak + 'Suggestion: ' + FSuggestion;
end;

end.
