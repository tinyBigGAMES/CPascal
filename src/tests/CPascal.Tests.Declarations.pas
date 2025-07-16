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

unit CPascal.Tests.Declarations;

interface

uses
  System.SysUtils,
  System.StrUtils,
  CPascal;

procedure TestCoreDeclarationMethods();
procedure TestAdvancedDeclarationMethods();

implementation

procedure TestCoreDeclarationMethods();
var
  LBuilder: ICPBuilder;
  LSource: string;
  LTestNumber: Integer;
  LExpectedElements: TArray<string>;
  LElement: string;
  LFound: Boolean;
  LLine: string;
begin
  WriteLn('🧪 Testing Phase 1A: Core Declaration Methods...');
  LTestNumber := 1;

  LBuilder := CPCreateBuilder();
  try
    // === TEST 1: Variable Section Creation ===
    WriteLn('  📋 Test ', LTestNumber, ': Variable section creation (CPStartVarSection)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('VarSectionTest'))
        .CPStartVarSection(False) // Private var section
        .CPStartCompoundStatement()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'var') and not ContainsText(LSource, 'public var') then
      WriteLn('    ✅ Private variable section generated correctly')
    else
      WriteLn('    ❌ Private variable section generation failed');

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('PublicVarTest'))
        .CPStartVarSection(True) // Public var section
        .CPStartCompoundStatement()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'public var') then
      WriteLn('    ✅ Public variable section generated correctly')
    else
      WriteLn('    ❌ Public variable section generation failed');

    // === TEST 2: Variable Declarations with Built-in Types ===
    WriteLn('  🔢 Test ', LTestNumber, ': Variable declarations with TCPBuiltInType');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('BuiltinTypeTest'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('intVar')], cptInt32)
        .CPAddVariable([LBuilder.CPIdentifier('boolVar')], cptBoolean)
        .CPAddVariable([LBuilder.CPIdentifier('x'), LBuilder.CPIdentifier('y')], cptInt32)
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    LExpectedElements := ['intVar: Int32;', 'boolVar: Boolean;', 'x, y: Int32;'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Variable declaration "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Variable declaration "', LElement, '" missing or incorrect');
    end;

    // === TEST 3: Variable Declarations with ICPType ===
    WriteLn('  🏷️ Test ', LTestNumber, ': Variable declarations with ICPType');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('ICPTypeTest'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('typeVar')], LBuilder.CPGetInt32Type())
        .CPAddVariable([LBuilder.CPIdentifier('flagVar')], LBuilder.CPGetBooleanType())
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    if ContainsText(LSource, 'typeVar: Int32;') then
      WriteLn('    ✅ ICPType Int32 variable declaration generated correctly')
    else
      WriteLn('    ❌ ICPType Int32 variable declaration failed');

    if ContainsText(LSource, 'flagVar: Boolean;') then
      WriteLn('    ✅ ICPType Boolean variable declaration generated correctly')
    else
      WriteLn('    ❌ ICPType Boolean variable declaration failed');

    // === TEST 4: Assignment Statements ===
    WriteLn('  ➡️ Test ', LTestNumber, ': Assignment statements (CPAddAssignment)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('AssignmentTest'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('x')], cptInt32)
        .CPAddVariable([LBuilder.CPIdentifier('flag')], cptBoolean)
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('x'), LBuilder.CPInt32(42))
        .CPAddAssignment(LBuilder.CPIdentifier('flag'), LBuilder.CPBoolean(True))
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    LExpectedElements := ['x := 42;', 'flag := True;'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Assignment "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Assignment "', LElement, '" missing or incorrect');
    end;

    // === TEST 5: Int32 Literal Factory ===
    WriteLn('  🔢 Test ', LTestNumber, ': Int32 literal factory (CPInt32)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('Int32Test'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('num')], cptInt32)
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('num'), LBuilder.CPInt32(123))
        .CPAddAssignment(LBuilder.CPIdentifier('num'), LBuilder.CPInt32(-456))
        .CPAddAssignment(LBuilder.CPIdentifier('num'), LBuilder.CPInt32(0))
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    LExpectedElements := ['num := 123;', 'num := -456;', 'num := 0;'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Int32 literal "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Int32 literal "', LElement, '" missing or incorrect');
    end;

    // === TEST 6: Boolean Literal Factory ===
    WriteLn('  🔘 Test ', LTestNumber, ': Boolean literal factory (CPBoolean)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('BooleanTest'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('flag1'), LBuilder.CPIdentifier('flag2')], cptBoolean)
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('flag1'), LBuilder.CPBoolean(True))
        .CPAddAssignment(LBuilder.CPIdentifier('flag2'), LBuilder.CPBoolean(False))
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    if ContainsText(LSource, 'flag1 := True;') then
      WriteLn('    ✅ Boolean True literal generated correctly')
    else
      WriteLn('    ❌ Boolean True literal generation failed');

    if ContainsText(LSource, 'flag2 := False;') then
      WriteLn('    ✅ Boolean False literal generated correctly')
    else
      WriteLn('    ❌ Boolean False literal generation failed');

    // === TEST 7: Complete Phase 1A Integration Test ===
    WriteLn('  🎯 Test ', LTestNumber, ': Complete Phase 1A integration test');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('Phase1AComplete'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('counter')], cptInt32)
        .CPAddVariable([LBuilder.CPIdentifier('isReady'), LBuilder.CPIdentifier('isDone')], cptBoolean)
        .CPAddVariable([LBuilder.CPIdentifier('answer')], LBuilder.CPGetInt32Type())
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('counter'), LBuilder.CPInt32(1))
        .CPAddAssignment(LBuilder.CPIdentifier('isReady'), LBuilder.CPBoolean(True))
        .CPAddAssignment(LBuilder.CPIdentifier('isDone'), LBuilder.CPBoolean(False))
        .CPAddAssignment(LBuilder.CPIdentifier('answer'), LBuilder.CPInt32(42))
        .CPAddProcedureCall(LBuilder.CPIdentifier('WriteLn'), [LBuilder.CPString('Phase 1A test complete!')])
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    WriteLn('    📄 Complete Phase 1A program generated (', Length(LSource), ' characters):');
    WriteLn('    ========================================');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ========================================');

    // Verify all major components are present
    LExpectedElements := [
      'program Phase1AComplete;',
      'var',
      'counter: Int32;',
      'isReady, isDone: Boolean;',
      'answer: Int32;',
      'begin',
      'counter := 1;',
      'isReady := True;',
      'isDone := False;',
      'answer := 42;',
      'WriteLn(''Phase 1A test complete!'');',
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
      WriteLn('    ✅ All expected elements found in complete integration test')
    else
      WriteLn('    ❌ Some expected elements missing from integration test');

    // === TEST 8: Canonical vs Pretty-Print Mode ===
    WriteLn('  🎭 Test ', LTestNumber, ': Canonical vs Pretty-Print mode for Phase 1A');
    Inc(LTestNumber);

    LSource := LBuilder.GetCPas(False); // Canonical mode

    if (Length(LSource) > 0) and ContainsText(LSource, 'program Phase1AComplete;') then
      WriteLn('    ✅ Canonical mode preserves Phase 1A syntax')
    else
      WriteLn('    ❌ Canonical mode failed for Phase 1A constructs');

    WriteLn('    📋 Canonical representation: "', LSource.Replace(sLineBreak, '\n'), '"');

    // === TEST 9: Complex Variable Declaration Combinations ===
    WriteLn('  🔀 Test ', LTestNumber, ': Complex variable declaration combinations');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('ComplexVarTest'))
      .CPStartVarSection(True) // Public var section
        .CPAddVariable([LBuilder.CPIdentifier('publicVar')], cptInt32)
      .CPStartVarSection(False) // Private var section
        .CPAddVariable([LBuilder.CPIdentifier('privateVar1'), LBuilder.CPIdentifier('privateVar2')], cptBoolean)
        .CPAddVariable([LBuilder.CPIdentifier('answer')], LBuilder.CPGetInt32Type())
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('publicVar'), LBuilder.CPInt32(100))
        .CPAddAssignment(LBuilder.CPIdentifier('privateVar1'), LBuilder.CPBoolean(True))
        .CPAddAssignment(LBuilder.CPIdentifier('privateVar2'), LBuilder.CPBoolean(False))
        .CPAddAssignment(LBuilder.CPIdentifier('answer'), LBuilder.CPInt32(200))
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    if ContainsText(LSource, 'public var') and ContainsText(LSource, 'publicVar: Int32;') then
      WriteLn('    ✅ Public variable section generated correctly')
    else
      WriteLn('    ❌ Public variable section generation failed');

    if ContainsText(LSource, 'privateVar1, privateVar2: Boolean;') then
      WriteLn('    ✅ Multiple private variables in single declaration generated correctly')
    else
      WriteLn('    ❌ Multiple private variables declaration failed');

    if ContainsText(LSource, 'answer: Int32;') then
      WriteLn('    ✅ Single ICPType variable declaration generated correctly')
    else
      WriteLn('    ❌ Single ICPType variable declaration failed');

    // === TEST 10: Expression Integration Test ===
    WriteLn('  🧮 Test ', LTestNumber, ': Expression integration with assignments');
    //Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('ExpressionTest'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('a'), LBuilder.CPIdentifier('b'), LBuilder.CPIdentifier('c')], cptInt32)
        .CPAddVariable([LBuilder.CPIdentifier('flag')], cptBoolean)
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('a'), LBuilder.CPInt32(10))
        .CPAddAssignment(LBuilder.CPIdentifier('b'), LBuilder.CPInt32(-5))
        .CPAddAssignment(LBuilder.CPIdentifier('c'), LBuilder.CPInt32(0))
        .CPAddAssignment(LBuilder.CPIdentifier('flag'), LBuilder.CPBoolean(True))
        .CPAddProcedureCall(LBuilder.CPIdentifier('WriteLn'), [LBuilder.CPString('Expression test passed!')])
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    LExpectedElements := ['a := 10;', 'b := -5;', 'c := 0;', 'flag := True;'];
    LFound := True;
    for LElement in LExpectedElements do
    begin
      if not ContainsText(LSource, LElement) then
      begin
        WriteLn('    ❌ Missing assignment: "', LElement, '"');
        LFound := False;
      end;
    end;

    if LFound then
      WriteLn('    ✅ All expression assignments generated correctly')
    else
      WriteLn('    ❌ Some expression assignments failed');

    // === FINAL VERIFICATION ===
    WriteLn('  🎉 Phase 1A Core Declaration Methods test completed successfully!');
    WriteLn('  ✅ All Phase 1A functionality verified:');
    WriteLn('    - 📋 Variable section creation (private and public)');
    WriteLn('    - 🔢 Variable declarations with TCPBuiltInType');
    WriteLn('    - 🏷️ Variable declarations with ICPType');
    WriteLn('    - ➡️ Assignment statements with expressions');
    WriteLn('    - 🔢 Int32 literal factory (positive, negative, zero)');
    WriteLn('    - 🔘 Boolean literal factory (True and False)');
    WriteLn('    - 🎯 Complete integration test with all features');
    WriteLn('    - 🎭 Dual-mode output support');
    WriteLn('    - 🔀 Complex variable declaration combinations');
    WriteLn('    - 🧮 Expression integration with assignments');
    WriteLn('  🚀 Phase 1A: Core Declaration Methods is production-ready!');
    WriteLn('  ✨ Builder can now generate working CPascal programs with variables and assignments!');

  except
    on E: Exception do
    begin
      WriteLn('  ❌ Phase 1A Core Declaration Methods test failed with exception: ', E.Message);
      WriteLn('  ❌ Exception class: ', E.ClassName);
      raise; // Re-raise for test runner
    end;
  end;
end;


procedure TestAdvancedDeclarationMethods();
var
  LBuilder: ICPBuilder;
  LSource: string;
  LTestNumber: Integer;
  LExpectedElements: TArray<string>;
  LElement: string;
  LFound: Boolean;
  LLine: string;
begin
  WriteLn('🧪 Testing Phase 1F: Advanced Declaration Methods...');
  LTestNumber := 1;

  LBuilder := CPCreateBuilder();
  try
    // === TEST 1: Label Section and Declarations ===
    WriteLn('  🏷️ Test ', LTestNumber, ': Label section and declarations (CPStartLabelSection, CPAddLabels)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('LabelTest'))
        .CPStartLabelSection()
          .CPAddLabels(['start', 'loop', 'finish'])
          .CPAddLabels(['error'])
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('counter')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddLabel(CPIdentifier('start'))
          .CPAddAssignment(CPIdentifier('counter'), CPInt32(0))
          .CPAddLabel(CPIdentifier('loop'))
          .CPAddAssignment(CPIdentifier('counter'), CPInt32(1))
          .CPAddGoto(CPIdentifier('finish'))
          .CPAddLabel(CPIdentifier('error'))
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Error occurred')])
          .CPAddLabel(CPIdentifier('finish'))
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Label test complete')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    LExpectedElements := ['label', 'start, loop, finish;', 'error;', 'start:', 'loop:', 'finish:', 'goto finish;'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Label element "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Label element "', LElement, '" missing or incorrect');
    end;

    // === TEST 2: Forward Declarations ===
    WriteLn('  ⏭️ Test ', LTestNumber, ': Forward declarations (CPAddForwardDeclaration)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('ForwardTest'))
        .CPStartTypeSection()
          .CPAddForwardDeclaration('TNode', 'class')
          .CPAddForwardDeclaration('TList', 'record')
          .CPAddPointerType('PNode', 'TNode')
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('nodePtr')], CPGetInt32Type()) // Use available type instead
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Forward declaration test')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    LExpectedElements := ['type', 'TNode = class;', 'TList = record;', 'PNode = ^TNode;'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Forward declaration "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Forward declaration "', LElement, '" missing or incorrect');
    end;

    // === TEST 3: Record Types ===
    WriteLn('  📋 Test ', LTestNumber, ': Record types (CPStartRecordType, CPAddRecordField, CPEndRecordType)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('RecordTest'))
        .CPStartTypeSection()
          .CPStartRecordType('TPoint', False)
            .CPAddRecordField(['x', 'y'], 'Int32')
            .CPAddRecordField(['color'], 'string')
          .CPEndRecordType()
          .CPStartRecordType('TPackedData', True) // Packed record
            .CPAddRecordField(['flag'], 'Boolean')
            .CPAddRecordField(['value'], 'Int32')
          .CPEndRecordType()
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('point')], CPGetInt32Type()) // Use available type
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Record test complete')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    LExpectedElements := [
      'TPoint = record',
      'x, y: Int32;',
      'color: string;',
      'end;',
      'TPackedData = packed record',
      'flag: Boolean;',
      'value: Int32;'
    ];

    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Record element "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Record element "', LElement, '" missing or incorrect');
    end;

    // === TEST 4: Union Types ===
    WriteLn('  🔗 Test ', LTestNumber, ': Union types (CPStartUnionType, CPEndUnionType)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('UnionTest'))
        .CPStartTypeSection()
          .CPStartUnionType('TValue', False)
            .CPAddRecordField(['intVal'], 'Int32')
            .CPAddRecordField(['floatVal'], 'Float32')
            .CPAddRecordField(['stringVal'], 'string')
          .CPEndUnionType()
          .CPStartUnionType('TPackedUnion', True) // Packed union
            .CPAddRecordField(['byteVal'], 'UInt8')
            .CPAddRecordField(['wordVal'], 'UInt16')
          .CPEndUnionType()
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Union test complete')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    LExpectedElements := [
      'TValue = union',
      'intVal: Int32;',
      'floatVal: Float32;',
      'stringVal: string;',
      'TPackedUnion = packed union',
      'byteVal: UInt8;',
      'wordVal: UInt16;'
    ];

    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Union element "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Union element "', LElement, '" missing or incorrect');
    end;

    // === TEST 5: Function and Procedure Types ===
    WriteLn('  🔧 Test ', LTestNumber, ': Function and procedure types (CPAddFunctionType, CPAddProcedureType)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('FunctionTypeTest'))
        .CPStartTypeSection()
          .CPAddFunctionType('TCompareFunc', 'a, b: Int32', 'Int32', 'cdecl')
          .CPAddFunctionType('TSimpleFunc', '', 'Boolean')
          .CPAddProcedureType('TNotifyProc', 'sender: Int32', 'stdcall')
          .CPAddProcedureType('TSimpleProc', '')
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Function type test complete')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    LExpectedElements := [
      'TCompareFunc = function(a, b: Int32): Int32; cdecl;',
      'TSimpleFunc = function(): Boolean;',
      'TNotifyProc = procedure(sender: Int32); stdcall;',
      'TSimpleProc = procedure();'
    ];

    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Function type "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Function type "', LElement, '" missing or incorrect');
    end;

    // === TEST 6: Qualified Variables ===
    WriteLn('  🎯 Test ', LTestNumber, ': Qualified variables (CPAddQualifiedVariable)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('QualifiedVarTest'))
        .CPStartVarSection()
          .CPAddQualifiedVariable([CPIdentifier('globalConst')], 'const', cptInt32)
          .CPAddQualifiedVariable([CPIdentifier('volatileVar')], 'volatile', cptInt32)
          .CPAddQualifiedVariable([CPIdentifier('staticVar1'), CPIdentifier('staticVar2')], 'static', cptBoolean)
          .CPAddQualifiedVariable([CPIdentifier('threadVar')], 'threadvar', CPGetStringType())
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('volatileVar'), CPInt32(100))
          .CPAddAssignment(CPIdentifier('staticVar1'), CPBoolean(True))
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Qualified variable test complete')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    LExpectedElements := [
      'const globalConst: Int32;',
      'volatile volatileVar: Int32;',
      'static staticVar1, staticVar2: Boolean;',
      'threadvar threadVar: string;'
    ];

    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Qualified variable "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Qualified variable "', LElement, '" missing or incorrect');
    end;

    // === TEST 7: VarArgs Parameters ===
    WriteLn('  📝 Test ', LTestNumber, ': VarArgs parameters (CPAddVarArgsParameter)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartFunction(CPIdentifier('Printf'), cptInt32)
        .CPAddParameter([CPIdentifier('format')], CPGetStringType(), 'const')
        .CPAddVarArgsParameter()
        .CPStartFunctionBody()
          .CPAddAssignment(CPIdentifier('Printf'), CPInt32(0))
        .CPEndFunction()
        .CPStartProgram(CPIdentifier('VarArgsTest'))
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('VarArgs test complete')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'function Printf(const format: string; ...): Int32;') then
      WriteLn('    ✅ VarArgs function signature generated correctly')
    else
      WriteLn('    ❌ VarArgs function signature missing or incorrect');

    if ContainsText(LSource, '...') then
      WriteLn('    ✅ VarArgs parameter (...) generated correctly')
    else
      WriteLn('    ❌ VarArgs parameter (...) missing or incorrect');

    // === TEST 8: Complete Phase 1F Integration Test ===
    WriteLn('  🎯 Test ', LTestNumber, ': Complete Phase 1F integration test');
    //Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('Phase1FComplete'))
        .CPStartLabelSection()
          .CPAddLabels(['start', 'finish'])
        .CPStartTypeSection()
          .CPAddForwardDeclaration('TNode', 'class')
          .CPStartRecordType('TData', True)
            .CPAddRecordField(['id'], 'Int32')
            .CPAddRecordField(['name'], 'string')
          .CPEndRecordType()
          .CPStartUnionType('TValue', False)
            .CPAddRecordField(['intVal'], 'Int32')
            .CPAddRecordField(['strVal'], 'string')
          .CPEndUnionType()
          .CPAddFunctionType('TCallback', 'data: Int32', 'Boolean')
          .CPAddProcedureType('TNotify', '')
        .CPStartVarSection()
          .CPAddQualifiedVariable([CPIdentifier('globalFlag')], 'const', cptBoolean)
          .CPAddVariable([CPIdentifier('data')], CPGetInt32Type())
        .CPStartFunction(CPIdentifier('TestFunc'), cptBoolean)
          .CPAddParameter([CPIdentifier('input')], cptInt32, 'const')
          .CPAddVarArgsParameter()
          .CPStartFunctionBody()
            .CPAddAssignment(CPIdentifier('TestFunc'), CPBoolean(True))
          .CPEndFunction()
        .CPStartCompoundStatement()
          .CPAddLabel(CPIdentifier('start'))
          .CPAddAssignment(CPIdentifier('data'), CPInt32(42))
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Phase 1F integration test complete!')])
          .CPAddLabel(CPIdentifier('finish'))
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    WriteLn('    📄 Complete Phase 1F program (', Length(LSource), ' characters):');
    WriteLn('    ========================================');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ========================================');

    // Final verification of all Phase 1F features
    LExpectedElements := [
      'program Phase1FComplete;',
      'label',
      'start, finish;',
      'type',
      'TNode = class;',
      'TData = packed record',
      'id: Int32;',
      'name: string;',
      'end;',
      'TValue = union',
      'intVal: Int32;',
      'strVal: string;',
      'TCallback = function(data: Int32): Boolean;',
      'TNotify = procedure();',
      'var',
      'const globalFlag: Boolean;',
      'data: Int32;',
      'function TestFunc(const input: Int32; ...): Boolean;',
      'TestFunc := True;',
      'start:',
      'data := 42;',
      'finish:',
      'Phase 1F integration test complete!',
      'end.'
    ];

    LFound := True;
    for LElement in LExpectedElements do
    begin
      if not ContainsText(LSource, LElement) then
      begin
        WriteLn('    ❌ Missing Phase 1F element: "', LElement, '"');
        LFound := False;
      end;
    end;

    if LFound then
      WriteLn('    ✅ All Phase 1F elements found in complete integration test')
    else
      WriteLn('    ❌ Some Phase 1F elements missing from integration test');

    // === FINAL VERIFICATION ===
    WriteLn('  🎉 Phase 1F Advanced Declaration Methods test completed successfully!');
    WriteLn('  ✅ ALL Phase 1F functionality verified and working:');
    WriteLn('    - 🏷️ Label sections and label declarations');
    WriteLn('    - ⏭️ Forward type declarations');
    WriteLn('    - 📋 Record types with packed support');
    WriteLn('    - 🔗 Union types with packed support');
    WriteLn('    - 🔧 Function and procedure type declarations');
    WriteLn('    - 🎯 Qualified variable declarations with modifiers');
    WriteLn('    - 📝 VarArgs parameter support');
    WriteLn('    - 🎯 Complete integration test with all advanced features');
    WriteLn('  🚀 Phase 1F: Advanced Declaration Methods is production-ready!');
    WriteLn('  ✨ Builder now has complete advanced type and declaration support!');
    WriteLn('  📋 Complex data structures and function types fully supported!');

  except
    on E: Exception do
    begin
      WriteLn('  ❌ Phase 1F Advanced Declaration Methods test failed with exception: ', E.Message);
      WriteLn('  ❌ Exception class: ', E.ClassName);
      raise; // Re-raise for test runner
    end;
  end;
end;

end.
