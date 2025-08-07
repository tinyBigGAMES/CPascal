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

 https://github.com/tinyBigGAMES/CPascal

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

unit CPascal.Exception;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Math;

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
    
    // LLVM diagnostic fields
    FLLVMModuleIR: string;
    FLLVMFunctionName: string;
    FLLVMValueInfo: string;
    FLLVMAPICall: string;
    FLLVMDiagnostics: string;
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

    // LLVM error with rich diagnostics (forward declaration)
    constructor CreateLLVMError(const AMessage: string; const AArgs: array of const;
                               const AContext, ASuggestion: string; 
                               const ALLVMModuleIR, ALLVMFunctionName, ALLVMValueInfo, ALLVMAPICall: string); overload;

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
    
    // LLVM diagnostic properties
    property LLVMModuleIR: string read FLLVMModuleIR;
    property LLVMFunctionName: string read FLLVMFunctionName;
    property LLVMValueInfo: string read FLLVMValueInfo;
    property LLVMAPICall: string read FLLVMAPICall;
    property LLVMDiagnostics: string read FLLVMDiagnostics;

    // Formatted error output methods
    function GetDetailedMessage(): string;
    function GetFormattedLocation(): string;
    function GetErrorWithSuggestion(): string;
  end;

function IfThen(const ACondition: Boolean; const ATrueValue, AFalseValue: string): string; overload;

// UTF-8 string utilities
function UTF8ByteLengthFromUnicode(const AStr: string): Integer;

procedure CPDisplayExceptionError(const AError: ECPException); overload;
procedure CPDisplayExceptionError(const AError: Exception); overload;

implementation

uses
  CPascal.Platform;

// Overloaded routine for ECPException - rich compilation error display
procedure CPDisplayExceptionError(const AError: ECPException); overload;
begin
  if AError = nil then
  begin
    CPPrintLn('   (Error object is nil)', []);
    Exit;
  end;

  CPPrintLn('', []);
  CPPrintLn('❌ COMPILATION ERROR:', []);

  // Use the built-in detailed message method for comprehensive formatting
  CPPrintLn(' %s', [StringReplace(AError.GetDetailedMessage, sLineBreak, sLineBreak + '   ', [rfReplaceAll])]);

  // Display additional rich information if available
  CPPrintLn('', []);
  CPPrintLn('📍 ERROR DETAILS:', []);

  // Error categorization
  if AError.ErrorCategory <> '' then
    CPPrintLn('   Category: %s', [AError.ErrorCategory]);

  if AError.ErrorCode <> 0 then
    CPPrintLn('   Code: %d', [AError.ErrorCode]);

  // Source location information
  if AError.GetFormattedLocation <> '' then
    CPPrintLn('   Location: %s', [AError.GetFormattedLocation]);

  // Symbol-related information
  if AError.RelatedSymbol <> '' then
    CPPrintLn('   Related Symbol: %s', [AError.RelatedSymbol]);

  // Type mismatch information
  if (AError.ExpectedType <> '') and (AError.ActualType <> '') then
  begin
    CPPrintLn('   Type Mismatch: Expected "%s", got "%s"', [AError.ExpectedType, AError.ActualType]);
  end;

  // Context and suggestions
  if AError.ContextInfo <> '' then
    CPPrintLn('   Context: %s', [AError.ContextInfo]);

  if AError.Suggestion <> '' then
  begin
    CPPrintLn('', []);
    CPPrintLn('💡 SUGGESTION:', []);
    CPPrintLn('   %s', [AError.Suggestion]);
  end;
  
  // LLVM diagnostic information
  if (AError.ErrorCategory = 'LLVM') and (AError.LLVMAPICall <> '') then
  begin
    CPPrintLn('', []);
    CPPrintLn('🔧 LLVM DIAGNOSTICS:', []);
    CPPrintLn('   API Call: %s', [AError.LLVMAPICall]);
    if AError.LLVMFunctionName <> '' then
      CPPrintLn('   Function: %s', [AError.LLVMFunctionName]);
    if AError.LLVMValueInfo <> '' then
      CPPrintLn('   Value Info: %s', [AError.LLVMValueInfo]);    
    if AError.LLVMModuleIR <> '' then
    begin
      CPPrintLn('   LLVM Module IR:', []);
      CPPrintLn('   --- BEGIN LLVM IR ---', []);
      CPPrintLn('%s', [AError.LLVMModuleIR]);
      CPPrintLn('   --- END LLVM IR ---', []);
    end;
  end;

  CPPrintLn('', []);
end;

// Overloaded routine for general Exception - system error display
procedure CPDisplayExceptionError(const AError: Exception); overload;
begin
  if AError = nil then
  begin
    CPPrintLn('', []);
    CPPrintLn('❌ UNKNOWN SYSTEM ERROR:', []);
    CPPrintLn('   (Exception object is nil)', []);
    CPPrintLn('', []);
    Exit;
  end;

  CPPrintLn('', []);
  CPPrintLn('❌ UNEXPECTED SYSTEM ERROR:', []);
  CPPrintLn('', []);

  CPPrintLn('🔧 SYSTEM ERROR DETAILS:', []);
  CPPrintLn('   Exception Type: %s', [AError.ClassName]);
  CPPrintLn('   Message: %s', [AError.Message]);

  // Display additional system exception information if available
  if AError.HelpContext <> 0 then
    CPPrintLn('   Help Context: %d', [AError.HelpContext]);

  CPPrintLn('', []);
  CPPrintLn('📋 DIAGNOSTIC INFORMATION:', []);
  CPPrintLn('   This may indicate an internal compiler error or system issue.', []);
  CPPrintLn('   Please report this error with reproduction steps.', []);

  CPPrintLn('', []);
end;


{ TCPSourceLocation }

class function TCPSourceLocation.Create(const AFileName: string; const ALine, AColumn: Integer): TCPSourceLocation;
begin
  Result.FileName := AFileName;
  Result.Line := ALine;
  Result.Column := AColumn;
end;

{ ECPException }

{ ECPException }

constructor ECPException.CreateLLVMError(const AMessage: string; const AArgs: array of const;
                                        const AContext, ASuggestion: string; 
                                        const ALLVMModuleIR, ALLVMFunctionName, ALLVMValueInfo, ALLVMAPICall: string);
begin
  try
    inherited Create(Format(AMessage, AArgs));
  except
    on E: Exception do
      inherited Create(AMessage + ' [Format Error: ' + E.Message + ']');
  end;

  FErrorCode := 0;
  FErrorCategory := 'LLVM';
  FSourceFileName := '';
  FLineNumber := 0;
  FColumnNumber := 0;
  FContextInfo := AContext;
  FSuggestion := ASuggestion;
  FRelatedSymbol := '';
  FExpectedType := '';
  FActualType := '';
  
  // LLVM diagnostic information
  FLLVMModuleIR := ALLVMModuleIR;
  FLLVMFunctionName := ALLVMFunctionName;
  FLLVMValueInfo := ALLVMValueInfo;
  FLLVMAPICall := ALLVMAPICall;
  FLLVMDiagnostics := Format('API Call: %s | Function: %s | Value Info: %s', [ALLVMAPICall, ALLVMFunctionName, ALLVMValueInfo]);
end;

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
  
  // Initialize LLVM diagnostic fields
  FLLVMModuleIR := '';
  FLLVMFunctionName := '';
  FLLVMValueInfo := '';
  FLLVMAPICall := '';
  FLLVMDiagnostics := '';
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
  
  // Initialize LLVM diagnostic fields
  FLLVMModuleIR := '';
  FLLVMFunctionName := '';
  FLLVMValueInfo := '';
  FLLVMAPICall := '';
  FLLVMDiagnostics := '';
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

function IfThen(const ACondition: Boolean; const ATrueValue, AFalseValue: string): string;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

function UTF8ByteLengthFromUnicode(const AStr: string): Integer;
var
  LUtf8: UTF8String;
begin
  LUtf8 := UTF8Encode(AStr);
  Result := Length(LUtf8);
end;

end.

