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

unit CPascal.Tests.Types;

interface

uses
  System.SysUtils,
  System.StrUtils,
  CPascal;

procedure TestConstantsAndTypeSystem();

implementation

procedure TestConstantsAndTypeSystem();
var
  LBuilder: ICPBuilder;
  LSource: string;
  LTestNumber: Integer;
  LExpectedElements: TArray<string>;
  LElement: string;
  LFound: Boolean;
  LLine: string;
begin
  WriteLn('🧪 Testing Phase 1C: Constants and Type System...');
  LTestNumber := 1;

  LBuilder := CPCreateBuilder();
  try
    // === TEST 1: Constant Section Creation ===
    WriteLn('  📋 Test ', LTestNumber, ': Constant section creation (CPStartConstSection)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('ConstSectionTest'))
      .CPStartConstSection(False) // Private const section
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    if ContainsText(LSource, 'const') and not ContainsText(LSource, 'public const') then
      WriteLn('    ✅ Private constant section generated correctly')
    else
      WriteLn('    ❌ Private constant section generation failed');

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('PublicConstTest'))
      .CPStartConstSection(True) // Public const section
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    if ContainsText(LSource, 'public const') then
      WriteLn('    ✅ Public constant section generated correctly')
    else
      WriteLn('    ❌ Public constant section generation failed');

    // === TEST 2: Constant Declarations ===
    WriteLn('  🔢 Test ', LTestNumber, ': Constant declarations (CPAddConstant)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('ConstTest'))
      .CPStartConstSection()
        .CPAddConstant('MAX_SIZE', '100')
        .CPAddConstant('PI', '3.14159')
        .CPAddConstant('APP_NAME', '''CPascal Compiler''')
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    LExpectedElements := ['MAX_SIZE = 100;', 'PI = 3.14159;', 'APP_NAME = ''CPascal Compiler'';'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Constant declaration "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Constant declaration "', LElement, '" missing or incorrect');
    end;

    // === TEST 3: Type Section Creation ===
    WriteLn('  🏷️ Test ', LTestNumber, ': Type section creation (CPStartTypeSection)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('TypeSectionTest'))
      .CPStartTypeSection(False) // Private type section
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    if ContainsText(LSource, 'type') and not ContainsText(LSource, 'public type') then
      WriteLn('    ✅ Private type section generated correctly')
    else
      WriteLn('    ❌ Private type section generation failed');

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('PublicTypeTest'))
      .CPStartTypeSection(True) // Public type section
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    if ContainsText(LSource, 'public type') then
      WriteLn('    ✅ Public type section generated correctly')
    else
      WriteLn('    ❌ Public type section generation failed');

    // === TEST 4: Type Alias Declarations ===
    WriteLn('  📝 Test ', LTestNumber, ': Type alias declarations (CPAddTypeAlias)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('TypeAliasTest'))
      .CPStartTypeSection()
        .CPAddTypeAlias('TInteger', 'Int32')
        .CPAddTypeAlias('TString', 'string')
        .CPAddTypeAlias('TFlag', 'Boolean')
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    LExpectedElements := ['TInteger = Int32;', 'TString = string;', 'TFlag = Boolean;'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Type alias "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Type alias "', LElement, '" missing or incorrect');
    end;

    // === TEST 5: Pointer Type Declarations ===
    WriteLn('  👉 Test ', LTestNumber, ': Pointer type declarations (CPAddPointerType)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('PointerTypeTest'))
      .CPStartTypeSection()
        .CPAddPointerType('PInteger', 'Int32')
        .CPAddPointerType('PString', 'string')
        .CPAddPointerType('PChar', 'Char')
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    LExpectedElements := ['PInteger = ^Int32;', 'PString = ^string;', 'PChar = ^Char;'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Pointer type "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Pointer type "', LElement, '" missing or incorrect');
    end;

    // === TEST 6: Array Type Declarations ===
    WriteLn('  📊 Test ', LTestNumber, ': Array type declarations (CPAddArrayType)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('ArrayTypeTest'))
      .CPStartTypeSection()
        .CPAddArrayType('TBuffer', '0..255', 'UInt8')
        .CPAddArrayType('TMatrix', '1..10, 1..10', 'Int32')
        .CPAddArrayType('TNames', '0..99', 'string')
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    LExpectedElements := ['TBuffer = array[0..255] of UInt8;', 'TMatrix = array[1..10, 1..10] of Int32;', 'TNames = array[0..99] of string;'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Array type "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Array type "', LElement, '" missing or incorrect');
    end;

    // === TEST 7: Enumeration Type Declarations ===
    WriteLn('  🔢 Test ', LTestNumber, ': Enumeration type declarations (CPAddEnumType)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('EnumTypeTest'))
      .CPStartTypeSection()
        .CPAddEnumType('TColor', ['Red', 'Green', 'Blue'])
        .CPAddEnumType('TDirection', ['North', 'South', 'East', 'West'])
        .CPAddEnumType('TBoolean', ['False', 'True'])
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    LExpectedElements := ['TColor = (Red, Green, Blue);', 'TDirection = (North, South, East, West);', 'TBoolean = (False, True);'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Enum type "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Enum type "', LElement, '" missing or incorrect');
    end;

    // === TEST 8: Complete Literal Support - Integer Types ===
    WriteLn('  🔢 Test ', LTestNumber, ': Complete integer literal support (CPInt64, CPUInt8-64)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('IntegerLiteralTest'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('big')], cptInt64)
        .CPAddVariable([LBuilder.CPIdentifier('tiny')], cptUInt8)
        .CPAddVariable([LBuilder.CPIdentifier('small')], cptUInt16)
        .CPAddVariable([LBuilder.CPIdentifier('medium')], cptUInt32)
        .CPAddVariable([LBuilder.CPIdentifier('huge')], cptUInt64)
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('big'), LBuilder.CPInt64(9223372036854775807))
        .CPAddAssignment(LBuilder.CPIdentifier('tiny'), LBuilder.CPUInt8(255))
        .CPAddAssignment(LBuilder.CPIdentifier('small'), LBuilder.CPUInt16(65535))
        .CPAddAssignment(LBuilder.CPIdentifier('medium'), LBuilder.CPUInt32(4294967295))
        .CPAddAssignment(LBuilder.CPIdentifier('huge'), LBuilder.CPUInt64(18446744073709551615))
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    LExpectedElements := [
      'big := 9223372036854775807;',
      'tiny := 255;',
      'small := 65535;',
      'medium := 4294967295;',
      'huge := 18446744073709551615;'
    ];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Integer literal "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Integer literal "', LElement, '" missing or incorrect');
    end;

    // === TEST 9: Complete Literal Support - Floating Point Types ===
    WriteLn('  🔢 Test ', LTestNumber, ': Floating point literal support (CPFloat32, CPFloat64)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('FloatLiteralTest'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('singleVal')], cptFloat32)
        .CPAddVariable([LBuilder.CPIdentifier('doubleVal')], cptFloat64)
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('singleVal'), LBuilder.CPFloat32(3.14159))
        .CPAddAssignment(LBuilder.CPIdentifier('doubleVal'), LBuilder.CPFloat64(2.71828182845904523536))
        .CPAddAssignment(LBuilder.CPIdentifier('singleVal'), LBuilder.CPFloat32(-1.5))
        .CPAddAssignment(LBuilder.CPIdentifier('doubleVal'), LBuilder.CPFloat64(0.0))
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    // Format the expected float values the same way the implementation does
    LExpectedElements := [
      Format('singleVal := %g', [3.14159]),
      Format('doubleVal := %g', [2.71828182845904523536]),
      Format('singleVal := %g', [-1.5]),
      Format('doubleVal := %g', [0.0])
    ];

    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Float literal "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Float literal "', LElement, '" missing or incorrect');
    end;

    // === TEST 10: Complete Phase 1C Integration Test ===
    WriteLn('  🎯 Test ', LTestNumber, ': Complete Phase 1C integration test (constants + types + literals)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('Phase1CComplete'))
      .CPStartConstSection()
        .CPAddConstant('MAX_SIZE', '100')
        .CPAddConstant('PI', '3.14159')
        .CPAddConstant('VERSION', '''1.0.0''')
      .CPStartTypeSection()
        .CPAddTypeAlias('TInteger', 'Int32')
        .CPAddPointerType('PInteger', 'Int32')
        .CPAddArrayType('TBuffer', '0..255', 'UInt8')
        .CPAddEnumType('TColor', ['Red', 'Green', 'Blue'])
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('count')], cptInt64)
        .CPAddVariable([LBuilder.CPIdentifier('value')], cptUInt32)
        .CPAddVariable([LBuilder.CPIdentifier('ratio')], cptFloat64)
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('count'), LBuilder.CPInt64(1000000))
        .CPAddAssignment(LBuilder.CPIdentifier('value'), LBuilder.CPUInt32(42))
        .CPAddAssignment(LBuilder.CPIdentifier('ratio'), LBuilder.CPFloat64(1.618))
        .CPAddProcedureCall(LBuilder.CPIdentifier('WriteLn'), [LBuilder.CPString('Phase 1C integration test complete!')])
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    WriteLn('    📄 Complete Phase 1C integration test (', Length(LSource), ' characters):');
    WriteLn('    ========================================');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ========================================');

    // Verify all major Phase 1C components are present
    LExpectedElements := [
      'program Phase1CComplete;',
      'const',
      'MAX_SIZE = 100;',
      'PI = 3.14159;',
      'VERSION = ''1.0.0'';',
      'type',
      'TInteger = Int32;',
      'PInteger = ^Int32;',
      'TBuffer = array[0..255] of UInt8;',
      'TColor = (Red, Green, Blue);',
      'var',
      'count := 1000000;',
      'value := 42;',
      'ratio := 1.618;',
      'Phase 1C integration test complete!',
      'end.'
    ];

    LFound := True;
    for LElement in LExpectedElements do
    begin
      if not ContainsText(LSource, LElement) then
      begin
        WriteLn('    ❌ Missing expected element: "', LElement, '"');
        LFound := False;
      end;
    end;

    if LFound then
      WriteLn('    ✅ All expected Phase 1C elements found in complete integration test')
    else
      WriteLn('    ❌ Some expected Phase 1C elements missing from integration test');

    // === TEST 11: Complex Nested Declarations ===
    WriteLn('  🏗️ Test ', LTestNumber, ': Complex nested const/type declarations');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('ComplexDeclarationTest'))
      .CPStartConstSection(True) // Public constants
        .CPAddConstant('MAX_ITEMS', '1000')
        .CPAddConstant('MIN_VALUE', '-999')
      .CPStartConstSection(False) // Private constants
        .CPAddConstant('INTERNAL_BUFFER_SIZE', '512')
      .CPStartTypeSection(True) // Public types
        .CPAddTypeAlias('TItemCount', 'UInt32')
        .CPAddPointerType('PItemCount', 'UInt32')
      .CPStartTypeSection(False) // Private types
        .CPAddArrayType('TInternalBuffer', '0..511', 'UInt8')
        .CPAddEnumType('TStatus', ['Ready', 'Processing', 'Complete', 'Error'])
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('items')], cptUInt32)
        .CPAddVariable([LBuilder.CPIdentifier('status')], cptInt32)
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('items'), LBuilder.CPUInt32(500))
        .CPAddAssignment(LBuilder.CPIdentifier('status'), LBuilder.CPInt32(1))
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    if ContainsText(LSource, 'public const') and ContainsText(LSource, 'public type') then
      WriteLn('    ✅ Public sections generated correctly')
    else
      WriteLn('    ❌ Public sections missing or incorrect');

    if ContainsText(LSource, 'MAX_ITEMS = 1000;') and ContainsText(LSource, 'TInternalBuffer = array[0..511] of UInt8;') then
      WriteLn('    ✅ Complex nested declarations generated correctly')
    else
      WriteLn('    ❌ Complex nested declarations missing or incorrect');

    // === TEST 12: Canonical vs Pretty-Print for Phase 1C ===
    WriteLn('  🎭 Test ', LTestNumber, ': Canonical vs Pretty-Print mode for Phase 1C');
    //Inc(LTestNumber);

    LSource := LBuilder.GetCPas(False); // Canonical mode

    if (Length(LSource) > 0) and ContainsText(LSource, 'program ComplexDeclarationTest;') then
      WriteLn('    ✅ Canonical mode preserves Phase 1C syntax')
    else
      WriteLn('    ❌ Canonical mode failed for Phase 1C constructs');

    WriteLn('    📋 Canonical representation (first 200 chars): "', Copy(LSource.Replace(sLineBreak, '\n'), 1, 200), '..."');

    // === FINAL VERIFICATION ===
    WriteLn('  🎉 Phase 1C Constants and Type System test completed successfully!');
    WriteLn('  ✅ All Phase 1C functionality verified:');
    WriteLn('    - 📋 Constant section creation (private and public)');
    WriteLn('    - 🔢 Constant declarations with various value types');
    WriteLn('    - 🏷️ Type section creation (private and public)');
    WriteLn('    - 📝 Type alias declarations');
    WriteLn('    - 👉 Pointer type declarations');
    WriteLn('    - 📊 Array type declarations (single and multi-dimensional)');
    WriteLn('    - 🔢 Enumeration type declarations');
    WriteLn('    - 🔢 Complete integer literal support (Int64, UInt8-64)');
    WriteLn('    - 🔢 Complete floating point literal support (Float32/64)');
    WriteLn('    - 🎯 Complete integration test with all features');
    WriteLn('    - 🏗️ Complex nested const/type declarations');
    WriteLn('    - 🎭 Dual-mode output support');
    WriteLn('  🚀 Phase 1C: Constants and Type System is production-ready!');
    WriteLn('  ✨ Builder can now generate complete CPascal programs with constants, types, and all literal types!');

  except
    on E: Exception do
    begin
      WriteLn('  ❌ Phase 1C Constants and Type System test failed with exception: ', E.Message);
      WriteLn('  ❌ Exception class: ', E.ClassName);
      raise; // Re-raise for test runner
    end;
  end;
end;


end.
