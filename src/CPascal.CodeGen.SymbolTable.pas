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
    this list of conditions and the documentation and/or other materials 
    provided with the distribution.

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

unit CPascal.CodeGen.SymbolTable;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  CPascal.LLVM,
  CPascal.Exception;

type
  { TCPSymbolCategory - Categories of symbols for parse-time validation }
  TCPSymbolCategory = (scFunction, scProcedure, scVariable, scConstant, scType);

  { TCPSymbolScope - Single scope containing symbol name->LLVM value mappings }
  TCPSymbolScope = TDictionary<string, LLVMValueRef>;

  { TCPSymbolCategoryScope - Single scope containing symbol name->category mappings }
  TCPSymbolCategoryScope = TDictionary<string, TCPSymbolCategory>;
  
  { TCPSymbolTypeScope - Single scope containing symbol name->type name mappings }
  TCPSymbolTypeScope = TDictionary<string, string>;

  { TCPSymbolTable - Scoped symbol table with proper lexical scoping support }
  TCPSymbolTable = class
  private
    FScopeStack: TList<TCPSymbolScope>;
    FCategoryScopeStack: TList<TCPSymbolCategoryScope>; // NEW: Track symbol categories for parsing
    FTypeScopeStack: TList<TCPSymbolTypeScope>; // Track symbol type names
    
    function GetCurrentScope: TCPSymbolScope;
    function GetCurrentCategoryScope: TCPSymbolCategoryScope; // NEW: Get current category scope
    function GetScopeCount: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    // Scope management - critical for local functions and nested blocks
    procedure PushScope();
    procedure PopScope();

    // Symbol operations - search from innermost to outermost scope
    procedure AddSymbol(const AName: string; const AValue: LLVMValueRef);
    procedure AddSymbolWithType(const AName: string; const AValue: LLVMValueRef; const ATypeName: string);
    function GetSymbol(const AName: string): LLVMValueRef;
    function GetSymbolType(const AName: string): string;
    function HasSymbol(const AName: string): Boolean;
    function HasSymbolInCurrentScope(const AName: string): Boolean;

    // Debugging and introspection
    function GetScopeDepth: Integer;
    procedure DumpScopes(const AList: TStrings);
    
    // NEW: Symbol category management for parse-time validation
    procedure AddFunctionSymbol(const AName: string);
    procedure AddProcedureSymbol(const AName: string);
    procedure AddVariableSymbol(const AName: string);
    procedure AddConstantSymbol(const AName: string);
    procedure AddTypeSymbol(const AName: string);
    function IsFunctionSymbol(const AName: string): Boolean;
    function IsProcedureSymbol(const AName: string): Boolean;
    function IsVariableSymbol(const AName: string): Boolean;
    function IsConstantSymbol(const AName: string): Boolean;
    function IsTypeSymbol(const AName: string): Boolean;
    function GetSymbolCategory(const AName: string; out ACategory: TCPSymbolCategory): Boolean;

    property CurrentScope: TCPSymbolScope read GetCurrentScope;
    property ScopeCount: Integer read GetScopeCount;
  end;

implementation

{ TCPSymbolTable }

constructor TCPSymbolTable.Create;
begin
  inherited Create;
  FScopeStack := TList<TCPSymbolScope>.Create;
  FCategoryScopeStack := TList<TCPSymbolCategoryScope>.Create; // NEW: Initialize category tracking
  FTypeScopeStack := TList<TCPSymbolTypeScope>.Create; // Initialize type tracking
  
  // Always start with global scope
  PushScope();
end;

destructor TCPSymbolTable.Destroy;
var
  LScope: TCPSymbolScope;
  LCategoryScope: TCPSymbolCategoryScope;
  LTypeScope: TCPSymbolTypeScope;
begin
  // Clean up all scopes manually (including global scope)
  while FScopeStack.Count > 0 do
  begin
    LScope := FScopeStack.Last;
    FScopeStack.Delete(FScopeStack.Count - 1);
    LScope.Free;
  end;
  
  // NEW: Clean up all category scopes
  while FCategoryScopeStack.Count > 0 do
  begin
    LCategoryScope := FCategoryScopeStack.Last;
    FCategoryScopeStack.Delete(FCategoryScopeStack.Count - 1);
    LCategoryScope.Free;
  end;
  
  // Clean up all type scopes
  while FTypeScopeStack.Count > 0 do
  begin
    LTypeScope := FTypeScopeStack.Last;
    FTypeScopeStack.Delete(FTypeScopeStack.Count - 1);
    LTypeScope.Free;
  end;
    
  FScopeStack.Free;
  FCategoryScopeStack.Free; // NEW: Free category scope stack
  FTypeScopeStack.Free; // Free type scope stack
  inherited Destroy;
end;

procedure TCPSymbolTable.PushScope();
var
  LNewScope: TCPSymbolScope;
  LNewCategoryScope: TCPSymbolCategoryScope;
  LNewTypeScope: TCPSymbolTypeScope;
begin
  LNewScope := TCPSymbolScope.Create;
  FScopeStack.Add(LNewScope);
  
  // NEW: Create matching category scope
  LNewCategoryScope := TCPSymbolCategoryScope.Create;
  FCategoryScopeStack.Add(LNewCategoryScope);
  
  // Create matching type scope
  LNewTypeScope := TCPSymbolTypeScope.Create;
  FTypeScopeStack.Add(LNewTypeScope);
end;

procedure TCPSymbolTable.PopScope();
var
  LScope: TCPSymbolScope;
  LCategoryScope: TCPSymbolCategoryScope;
  LTypeScope: TCPSymbolTypeScope;
begin
  if FScopeStack.Count = 0 then
    raise ECPException.Create(
      'Cannot pop scope - no scopes available',
      [],
      'PopScope called on empty scope stack',
      'Ensure PushScope is called before PopScope, or check scope management logic'
    );

  if FScopeStack.Count = 1 then
    raise ECPException.Create(
      'Cannot pop global scope',
      [],
      'Attempted to pop the last remaining (global) scope',
      'Global scope must remain throughout compilation. Check scope push/pop balance.'
    );

  // Remove and dispose the innermost scope
  LScope := FScopeStack.Last;
  FScopeStack.Delete(FScopeStack.Count - 1);
  LScope.Free;
  
  // NEW: Remove and dispose the matching category scope
  LCategoryScope := FCategoryScopeStack.Last;
  FCategoryScopeStack.Delete(FCategoryScopeStack.Count - 1);
  LCategoryScope.Free;
  
  // Remove and dispose the matching type scope
  LTypeScope := FTypeScopeStack.Last;
  FTypeScopeStack.Delete(FTypeScopeStack.Count - 1);
  LTypeScope.Free;
end;

procedure TCPSymbolTable.AddSymbol(const AName: string; const AValue: LLVMValueRef);
begin
  if FScopeStack.Count = 0 then
    raise ECPException.Create(
      'Cannot add symbol - no scope available',
      [],
      'AddSymbol called with empty scope stack',
      'Ensure symbol table is properly initialized with at least global scope'
    );

  if AValue = nil then
    raise ECPException.Create(
      'Cannot add nil LLVM value for symbol: %s',
      [AName],
      'LLVM value reference is nil',
      'Ensure LLVM value is properly created before adding to symbol table'
    );

  // Add to current (innermost) scope, allowing shadowing of outer scopes
  CurrentScope.AddOrSetValue(AName, AValue);
end;

procedure TCPSymbolTable.AddSymbolWithType(const AName: string; const AValue: LLVMValueRef; const ATypeName: string);
var
  LTypeScope: TCPSymbolTypeScope;
begin
  // Add the symbol normally
  AddSymbol(AName, AValue);
  
  // Also track its type name
  if FTypeScopeStack.Count > 0 then
  begin
    LTypeScope := FTypeScopeStack.Last;
    LTypeScope.AddOrSetValue(AName, ATypeName);
  end;
end;

function TCPSymbolTable.GetSymbol(const AName: string): LLVMValueRef;
var
  LIndex: Integer;
  LScope: TCPSymbolScope;
begin
  // Search from innermost to outermost scope (proper lexical scoping)
  for LIndex := FScopeStack.Count - 1 downto 0 do
  begin
    LScope := FScopeStack[LIndex];
    if LScope.TryGetValue(AName, Result) then
      Exit; // Found in this scope
  end;
  
  // Symbol not found in any scope
  Result := nil;
end;

function TCPSymbolTable.GetSymbolType(const AName: string): string;
var
  LIndex: Integer;
  LTypeScope: TCPSymbolTypeScope;
begin
  // Search from innermost to outermost scope
  for LIndex := FTypeScopeStack.Count - 1 downto 0 do
  begin
    LTypeScope := FTypeScopeStack[LIndex];
    if LTypeScope.TryGetValue(AName, Result) then
      Exit; // Found in this scope
  end;
  
  // Type not found
  Result := '';
end;

function TCPSymbolTable.HasSymbol(const AName: string): Boolean;
begin
  Result := GetSymbol(AName) <> nil;
end;

function TCPSymbolTable.HasSymbolInCurrentScope(const AName: string): Boolean;
begin
  if FScopeStack.Count = 0 then
    Result := False
  else
    Result := CurrentScope.ContainsKey(AName);
end;

function TCPSymbolTable.GetCurrentScope: TCPSymbolScope;
begin
  if FScopeStack.Count = 0 then
    raise ECPException.Create(
      'No current scope available',
      [],
      'CurrentScope accessed with empty scope stack',
      'Ensure symbol table is properly initialized'
    );
    
  Result := FScopeStack.Last;
end;

// NEW: Get current category scope
function TCPSymbolTable.GetCurrentCategoryScope: TCPSymbolCategoryScope;
begin
  if FCategoryScopeStack.Count = 0 then
    raise ECPException.Create(
      'No current category scope available',
      [],
      'CurrentCategoryScope accessed with empty scope stack',
      'Ensure symbol table is properly initialized'
    );
    
  Result := FCategoryScopeStack.Last;
end;

function TCPSymbolTable.GetScopeCount: Integer;
begin
  Result := FScopeStack.Count;
end;

function TCPSymbolTable.GetScopeDepth: Integer;
begin
  // Scope depth: 0 = global, 1 = first local scope, etc.
  Result := FScopeStack.Count - 1;
end;

procedure TCPSymbolTable.DumpScopes(const AList: TStrings);
var
  LIndex: Integer;
  LScope: TCPSymbolScope;
  LSymbolName: string;
  LSymbolNames: TStringList;
  LScopeName: string;
begin
  if AList = nil then
    Exit;
    
  AList.Clear;
  
  LSymbolNames := TStringList.Create;
  try
    for LIndex := 0 to FScopeStack.Count - 1 do
    begin
      LScope := FScopeStack[LIndex];
      
      if LIndex = 0 then
        LScopeName := 'Global Scope'
      else
        LScopeName := Format('Local Scope %d', [LIndex]);
        
      AList.Add(Format('%s (%d symbols):', [LScopeName, LScope.Count]));
      
      // Get sorted symbol names for consistent output
      LSymbolNames.Clear;
      for LSymbolName in LScope.Keys do
        LSymbolNames.Add(LSymbolName);
      LSymbolNames.Sort;
      
      for LSymbolName in LSymbolNames do
        AList.Add(Format('  %s', [LSymbolName]));
        
      if LIndex < FScopeStack.Count - 1 then
        AList.Add(''); // Blank line between scopes
    end;
  finally
    LSymbolNames.Free;
  end;
end;

// NEW: Symbol category management methods
procedure TCPSymbolTable.AddFunctionSymbol(const AName: string);
begin
  GetCurrentCategoryScope.AddOrSetValue(AName, scFunction);
end;

procedure TCPSymbolTable.AddProcedureSymbol(const AName: string);
begin
  GetCurrentCategoryScope.AddOrSetValue(AName, scProcedure);
end;

procedure TCPSymbolTable.AddVariableSymbol(const AName: string);
begin
  GetCurrentCategoryScope.AddOrSetValue(AName, scVariable);
end;

procedure TCPSymbolTable.AddConstantSymbol(const AName: string);
begin
  GetCurrentCategoryScope.AddOrSetValue(AName, scConstant);
end;

procedure TCPSymbolTable.AddTypeSymbol(const AName: string);
begin
  GetCurrentCategoryScope.AddOrSetValue(AName, scType);
end;

function TCPSymbolTable.GetSymbolCategory(const AName: string; out ACategory: TCPSymbolCategory): Boolean;
var
  LIndex: Integer;
  LCategoryScope: TCPSymbolCategoryScope;
begin
  // Search from innermost to outermost scope (proper lexical scoping)
  for LIndex := FCategoryScopeStack.Count - 1 downto 0 do
  begin
    LCategoryScope := FCategoryScopeStack[LIndex];
    if LCategoryScope.TryGetValue(AName, ACategory) then
    begin
      Result := True;
      Exit; // Found in this scope
    end;
  end;
  
  // Symbol category not found in any scope
  Result := False;
end;

function TCPSymbolTable.IsFunctionSymbol(const AName: string): Boolean;
var
  LCategory: TCPSymbolCategory;
begin
  Result := GetSymbolCategory(AName, LCategory) and (LCategory = scFunction);
end;

function TCPSymbolTable.IsProcedureSymbol(const AName: string): Boolean;
var
  LCategory: TCPSymbolCategory;
begin
  Result := GetSymbolCategory(AName, LCategory) and (LCategory = scProcedure);
end;

function TCPSymbolTable.IsVariableSymbol(const AName: string): Boolean;
var
  LCategory: TCPSymbolCategory;
begin
  Result := GetSymbolCategory(AName, LCategory) and (LCategory = scVariable);
end;

function TCPSymbolTable.IsConstantSymbol(const AName: string): Boolean;
var
  LCategory: TCPSymbolCategory;
begin
  Result := GetSymbolCategory(AName, LCategory) and (LCategory = scConstant);
end;

function TCPSymbolTable.IsTypeSymbol(const AName: string): Boolean;
var
  LCategory: TCPSymbolCategory;
begin
  Result := GetSymbolCategory(AName, LCategory) and (LCategory = scType);
end;

end.
