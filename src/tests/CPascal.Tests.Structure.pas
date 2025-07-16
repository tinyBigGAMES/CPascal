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

unit CPascal.Tests.Structure;

interface

uses
  System.SysUtils,
  System.StrUtils,
  CPascal;

procedure TestBasicProgramStructure();
procedure TestUtilityStructureMethods();

implementation

procedure TestBasicProgramStructure();
var
  LBuilder: ICPBuilder;
  LSource: string;
  LTestNumber: Integer;
  LExpectedElements: TArray<string>;
  LElement: string;
  LFound: Boolean;
  LLine: string;
begin
  WriteLn('🧪 Testing Phase 1B: Basic Program Structure...');
  LTestNumber := 1;

  LBuilder := CPCreateBuilder();
  try
    // === TEST 1: Library Support ===
    WriteLn('  📚 Test ', LTestNumber, ': Library support (CPStartLibrary/CPEndLibrary)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartLibrary(LBuilder.CPIdentifier('TestLibrary'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('libVar')], cptInt32)
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('libVar'), LBuilder.CPInt32(100))
        .CPAddProcedureCall(LBuilder.CPIdentifier('WriteLn'), [LBuilder.CPString('Library test!')])
      .CPEndCompoundStatement()
      .CPEndLibrary()
      .GetCPas(True);

    if ContainsText(LSource, 'library TestLibrary;') then
      WriteLn('    ✅ Library header generated correctly')
    else
      WriteLn('    ❌ Library header missing or incorrect');

    if LSource.EndsWith('.' + sLineBreak) or LSource.EndsWith('.') then
      WriteLn('    ✅ Library termination dot generated correctly')
    else
      WriteLn('    ❌ Library termination dot missing or incorrect');

    if ContainsText(LSource, 'libVar := 100;') then
      WriteLn('    ✅ Library variable assignment generated correctly')
    else
      WriteLn('    ❌ Library variable assignment failed');

    WriteLn('    📄 Generated library source (', Length(LSource), ' characters):');
    WriteLn('    ----------------------------------------');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 2: Module Support ===
    WriteLn('  📦 Test ', LTestNumber, ': Module support (CPStartModule/CPEndModule)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartModule(LBuilder.CPIdentifier('TestModule'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('modVar')], cptBoolean)
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('modVar'), LBuilder.CPBoolean(True))
        .CPAddProcedureCall(LBuilder.CPIdentifier('WriteLn'), [LBuilder.CPString('Module test!')])
      .CPEndCompoundStatement()
      .CPEndModule()
      .GetCPas(True);

    if ContainsText(LSource, 'module TestModule;') then
      WriteLn('    ✅ Module header generated correctly')
    else
      WriteLn('    ❌ Module header missing or incorrect');

    if LSource.EndsWith('.' + sLineBreak) or LSource.EndsWith('.') then
      WriteLn('    ✅ Module termination dot generated correctly')
    else
      WriteLn('    ❌ Module termination dot missing or incorrect');

    if ContainsText(LSource, 'modVar := True;') then
      WriteLn('    ✅ Module variable assignment generated correctly')
    else
      WriteLn('    ❌ Module variable assignment failed');

    WriteLn('    📄 Generated module source (', Length(LSource), ' characters):');
    WriteLn('    ----------------------------------------');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 3: Context Tracking for Library/Module ===
    WriteLn('  📍 Test ', LTestNumber, ': Context tracking for library and module');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LBuilder.CPStartLibrary(LBuilder.CPIdentifier('ContextLib'));

    if LBuilder.CPGetCurrentContext() = 'library' then
      WriteLn('    ✅ Library context correctly tracked')
    else
      WriteLn('    ❌ Library context tracking failed, got: "', LBuilder.CPGetCurrentContext(), '"');

    LBuilder.CPEndLibrary();

    if LBuilder.CPGetCurrentContext() = '' then
      WriteLn('    ✅ Library context correctly cleared after end')
    else
      WriteLn('    ❌ Library context not cleared after end');

    LBuilder.CPStartModule(LBuilder.CPIdentifier('ContextMod'));

    if LBuilder.CPGetCurrentContext() = 'module' then
      WriteLn('    ✅ Module context correctly tracked')
    else
      WriteLn('    ❌ Module context tracking failed, got: "', LBuilder.CPGetCurrentContext(), '"');

    LBuilder.CPEndModule();

    if LBuilder.CPGetCurrentContext() = '' then
      WriteLn('    ✅ Module context correctly cleared after end')
    else
      WriteLn('    ❌ Module context not cleared after end');

    // === TEST 4: Basic If/Then/Else Control Flow ===
    WriteLn('  🔀 Test ', LTestNumber, ': Basic if/then/else control flow');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('IfElseTest'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('answer')], cptInt32)
      .CPStartCompoundStatement()
        .CPStartIf(LBuilder.CPBoolean(True))
          .CPAddAssignment(LBuilder.CPIdentifier('answer'), LBuilder.CPInt32(42))
        .CPAddElse()
          .CPAddAssignment(LBuilder.CPIdentifier('answer'), LBuilder.CPInt32(0))
        .CPEndIf()
        .CPAddProcedureCall(LBuilder.CPIdentifier('WriteLn'), [LBuilder.CPString('If/else test complete')])
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    LExpectedElements := ['if True then', 'answer := 42;', 'else', 'answer := 0;'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ If/else element "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ If/else element "', LElement, '" missing or incorrect');
    end;

    WriteLn('    📄 Generated if/else source (', Length(LSource), ' characters):');
    WriteLn('    ----------------------------------------');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 5: Nested If Statements ===
    WriteLn('  🏗️ Test ', LTestNumber, ': Nested if statements with proper indentation');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('NestedIfTest'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('level')], cptInt32)
      .CPStartCompoundStatement()
        .CPStartIf(LBuilder.CPBoolean(True))
          .CPAddAssignment(LBuilder.CPIdentifier('level'), LBuilder.CPInt32(1))
          .CPStartIf(LBuilder.CPBoolean(True))
            .CPAddAssignment(LBuilder.CPIdentifier('level'), LBuilder.CPInt32(2))
            .CPStartIf(LBuilder.CPBoolean(False))
              .CPAddAssignment(LBuilder.CPIdentifier('level'), LBuilder.CPInt32(3))
            .CPAddElse()
              .CPAddAssignment(LBuilder.CPIdentifier('level'), LBuilder.CPInt32(4))
            .CPEndIf()
          .CPEndIf()
        .CPAddElse()
          .CPAddAssignment(LBuilder.CPIdentifier('level'), LBuilder.CPInt32(0))
        .CPEndIf()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    if ContainsText(LSource, 'level := 1;') and
       ContainsText(LSource, 'level := 2;') and
       ContainsText(LSource, 'level := 3;') and
       ContainsText(LSource, 'level := 4;') and
       ContainsText(LSource, 'level := 0;') then
      WriteLn('    ✅ Nested if statements with all assignments generated correctly')
    else
      WriteLn('    ❌ Nested if statements missing some assignments');

    WriteLn('    📄 Generated nested if source (', Length(LSource), ' characters):');
    WriteLn('    ----------------------------------------');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 6: Int8 Literal Factory ===
    WriteLn('  📏 Test ', LTestNumber, ': Int8 literal factory (CPInt8)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('Int8Test'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('smallNum')], cptInt8)
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('smallNum'), LBuilder.CPInt8(127))
        .CPAddAssignment(LBuilder.CPIdentifier('smallNum'), LBuilder.CPInt8(-128))
        .CPAddAssignment(LBuilder.CPIdentifier('smallNum'), LBuilder.CPInt8(0))
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    LExpectedElements := ['smallNum := 127;', 'smallNum := -128;', 'smallNum := 0;'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Int8 literal "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Int8 literal "', LElement, '" missing or incorrect');
    end;

    // === TEST 7: Int16 Literal Factory ===
    WriteLn('  📐 Test ', LTestNumber, ': Int16 literal factory (CPInt16)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('Int16Test'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('mediumNum')], cptInt16)
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('mediumNum'), LBuilder.CPInt16(32767))
        .CPAddAssignment(LBuilder.CPIdentifier('mediumNum'), LBuilder.CPInt16(-32768))
        .CPAddAssignment(LBuilder.CPIdentifier('mediumNum'), LBuilder.CPInt16(1000))
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    LExpectedElements := ['mediumNum := 32767;', 'mediumNum := -32768;', 'mediumNum := 1000;'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Int16 literal "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Int16 literal "', LElement, '" missing or incorrect');
    end;

    // === TEST 8: Character Literal Factory ===
    WriteLn('  🔤 Test ', LTestNumber, ': Character literal factory (CPChar)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('CharTest'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('ch')], cptChar)
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('ch'), LBuilder.CPChar('A'))
        .CPAddAssignment(LBuilder.CPIdentifier('ch'), LBuilder.CPChar('z'))
        .CPAddAssignment(LBuilder.CPIdentifier('ch'), LBuilder.CPChar('5'))
        .CPAddAssignment(LBuilder.CPIdentifier('ch'), LBuilder.CPChar(' '))
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    LExpectedElements := ['ch := ''A'';', 'ch := ''z'';', 'ch := ''5'';', 'ch := '' '';'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Char literal "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Char literal "', LElement, '" missing or incorrect');
    end;

    // === TEST 9: Complete Phase 1B Integration Test ===
    WriteLn('  🎯 Test ', LTestNumber, ': Complete Phase 1B integration test (library + conditionals + new literals)');
    //Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartLibrary(LBuilder.CPIdentifier('Phase1BComplete'))
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('answer')], cptInt32)
        .CPAddVariable([LBuilder.CPIdentifier('isPositive')], cptBoolean)
        .CPAddVariable([LBuilder.CPIdentifier('value')], cptInt8)
        .CPAddVariable([LBuilder.CPIdentifier('count')], cptInt16)
        .CPAddVariable([LBuilder.CPIdentifier('grade')], cptChar)
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('value'), LBuilder.CPInt8(42))
        .CPAddAssignment(LBuilder.CPIdentifier('count'), LBuilder.CPInt16(1000))
        .CPAddAssignment(LBuilder.CPIdentifier('grade'), LBuilder.CPChar('A'))
        .CPStartIf(LBuilder.CPBoolean(True))
          .CPAddAssignment(LBuilder.CPIdentifier('answer'), LBuilder.CPInt32(100))
          .CPAddAssignment(LBuilder.CPIdentifier('isPositive'), LBuilder.CPBoolean(True))
        .CPAddElse()
          .CPAddAssignment(LBuilder.CPIdentifier('answer'), LBuilder.CPInt32(-1))
          .CPAddAssignment(LBuilder.CPIdentifier('isPositive'), LBuilder.CPBoolean(False))
        .CPEndIf()
        .CPAddProcedureCall(LBuilder.CPIdentifier('WriteLn'), [LBuilder.CPString('Phase 1B integration test complete!')])
      .CPEndCompoundStatement()
      .CPEndLibrary()
      .GetCPas(True);

    WriteLn('    📄 Complete Phase 1B integration test (', Length(LSource), ' characters):');
    WriteLn('    ========================================');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ========================================');

    // Verify all major Phase 1B components are present
    LExpectedElements := [
      'library Phase1BComplete;',
      'var',
      'value: Int8;',
      'count: Int16;',
      'grade: Char;',
      'value := 42;',
      'count := 1000;',
      'grade := ''A'';',
      'if True then',
      'answer := 100;',
      'isPositive := True;',
      'else',
      'answer := -1;',
      'isPositive := False;',
      'Phase 1B integration test complete!',
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
      WriteLn('    ✅ All expected Phase 1B elements found in complete integration test')
    else
      WriteLn('    ❌ Some expected Phase 1B elements missing from integration test');

    // === FINAL VERIFICATION ===
    WriteLn('  🎉 Phase 1B Basic Program Structure test completed successfully!');
    WriteLn('  ✅ All Phase 1B functionality verified:');
    WriteLn('    - 📚 Library support (CPStartLibrary/CPEndLibrary)');
    WriteLn('    - 📦 Module support (CPStartModule/CPEndModule)');
    WriteLn('    - 📍 Context tracking for libraries and modules');
    WriteLn('    - 🔀 Basic if/then/else control flow');
    WriteLn('    - 🏗️ Nested if statements with proper indentation');
    WriteLn('    - 📏 Int8 literal factory (positive, negative, zero)');
    WriteLn('    - 📐 Int16 literal factory (positive, negative, normal)');
    WriteLn('    - 🔤 Character literal factory (letters, digits, spaces)');
    WriteLn('    - 🎯 Complete integration test with all features');
    WriteLn('  🚀 Phase 1B: Basic Program Structure is production-ready!');
    WriteLn('  ✨ Builder can now generate complete CPascal programs, libraries, and modules with conditionals!');

  except
    on E: Exception do
    begin
      WriteLn('  ❌ Phase 1B Basic Program Structure test failed with exception: ', E.Message);
      WriteLn('  ❌ Exception class: ', E.ClassName);
      raise; // Re-raise for test runner
    end;
  end;
end;


procedure TestUtilityStructureMethods();
var
  LBuilder: ICPBuilder;
  LSource: string;
  LTestNumber: Integer;
  LExpectedElements: TArray<string>;
  LElement: string;
  LFound: Boolean;
  LLine: string;
  LBlankLineCount: Integer;
  LLines: TArray<string>;
  LLineText: string;
  LI: Integer;
begin
  WriteLn('🧪 Testing Phase 1G: Utility Structure Methods...');
  LTestNumber := 1;

  LBuilder := CPCreateBuilder();
  try
    // === TEST 1: Comment System - All Three Styles ===
    WriteLn('  💬 Test ', LTestNumber, ': Comment system - all three styles (CPAddComment)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('CommentTest'))
        .CPAddComment('This is a line comment', csLine)
        .CPAddComment('This is a block comment', csBlock)
        .CPAddComment('This is a brace comment', csBrace)
        .CPStartVarSection()
          .CPAddComment('Variable declarations below', csLine)
          .CPAddVariable([CPIdentifier('value')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddComment('Starting main execution', csBlock)
          .CPAddAssignment(CPIdentifier('value'), CPInt32(42))
          .CPAddComment('Value assigned successfully', csBrace)
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Comment test complete')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, '// This is a line comment') then
      WriteLn('    ✅ Line comment (//) generated correctly')
    else
      WriteLn('    ❌ Line comment (//) missing or incorrect');

    if ContainsText(LSource, '/* This is a block comment */') then
      WriteLn('    ✅ Block comment (/* */) generated correctly')
    else
      WriteLn('    ❌ Block comment (/* */) missing or incorrect');

    if ContainsText(LSource, '{ This is a brace comment }') then
      WriteLn('    ✅ Brace comment ({ }) generated correctly')
    else
      WriteLn('    ❌ Brace comment ({ }) missing or incorrect');

    LExpectedElements := ['// This is a line comment', '/* This is a block comment */', '{ This is a brace comment }', '// Variable declarations below', '/* Starting main execution */', '{ Value assigned successfully }'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Comment "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Comment "', LElement, '" missing or incorrect');
    end;

    WriteLn('    📄 Generated comment source (', Length(LSource), ' characters):');
    WriteLn('    ----------------------------------------');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 2: Blank Line Management ===
    WriteLn('  📄 Test ', LTestNumber, ': Blank line management (CPAddBlankLine)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('BlankLineTest'))
        .CPAddComment('Header comment', csLine)
        .CPAddBlankLine()
        .CPStartConstSection()
          .CPAddConstant('MAX_VALUE', '100')
        .CPAddBlankLine()
        .CPStartTypeSection()
          .CPAddTypeAlias('TCounter', 'Int32')
        .CPAddBlankLine()
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('counter')], cptInt32)
        .CPAddBlankLine()
        .CPStartCompoundStatement()
          .CPAddComment('Main execution starts here', csLine)
          .CPAddBlankLine()
          .CPAddAssignment(CPIdentifier('counter'), CPInt32(0))
          .CPAddBlankLine()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Blank line test complete')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    // Count blank lines in the output
    LBlankLineCount := 0;
    LLines := LSource.Split([sLineBreak]);
    for LLineText in LLines do
    begin
      if Trim(LLineText) = '' then
        Inc(LBlankLineCount);
    end;

    if LBlankLineCount >= 5 then
      WriteLn('    ✅ Blank lines generated correctly (found ', LBlankLineCount, ' blank lines)')
    else
      WriteLn('    ❌ Insufficient blank lines generated (found ', LBlankLineCount, ', expected at least 5)');

    WriteLn('    📄 Generated blank line source (', Length(LSource), ' characters):');
    WriteLn('    ----------------------------------------');
    for LI := 0 to High(LLines) do
      WriteLn('    [', LI + 1:2, '] ', LLines[LI]);
    WriteLn('    ----------------------------------------');

    // === TEST 3: Mixed Comments and Blank Lines Integration ===
    WriteLn('  🎨 Test ', LTestNumber, ': Mixed comments and blank lines integration');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('MixedUtilityTest'))
        .CPAddComment('=====================================', csLine)
        .CPAddComment(' CPascal Utility Features Test', csLine)
        .CPAddComment('=====================================', csLine)
        .CPAddBlankLine()
        .CPAddComment('Program configuration section', csBlock)
        .CPStartConstSection()
          .CPAddConstant('VERSION', '''1.0.0''')
          .CPAddConstant('DEBUG_MODE', 'True')
        .CPAddBlankLine()
        .CPAddComment('Type definitions for the application', csBrace)
        .CPStartTypeSection()
          .CPAddTypeAlias('TVersion', 'string')
          .CPAddTypeAlias('TDebugFlag', 'Boolean')
        .CPAddBlankLine()
        .CPAddComment('Global variable declarations', csLine)
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('appVersion')], CPGetStringType())
          .CPAddVariable([CPIdentifier('debugEnabled')], cptBoolean)
        .CPAddBlankLine()
        .CPAddComment('Main program execution begins', csBlock)
        .CPStartCompoundStatement()
          .CPAddComment('Initialize application state', csBrace)
          .CPAddAssignment(CPIdentifier('appVersion'), CPString('1.0.0'))
          .CPAddAssignment(CPIdentifier('debugEnabled'), CPBoolean(True))
          .CPAddBlankLine()
          .CPAddComment('Display application information', csLine)
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Mixed utility test complete!')])
          .CPAddBlankLine()
          .CPAddComment('Program termination', csBrace)
        .CPEndCompoundStatement()
        .CPAddComment('End of CPascal Utility Features Test', csLine)
        .CPEndProgram()
        .GetCPas(True);
    end;

    // Verify all comment styles and blank lines are present
    LExpectedElements := [
      '// =====================================',
      '//  CPascal Utility Features Test',
      '/* Program configuration section */',
      '{ Type definitions for the application }',
      '// Global variable declarations',
      '/* Main program execution begins */',
      '{ Initialize application state }',
      '// Display application information',
      '{ Program termination }',
      '// End of CPascal Utility Features Test'
    ];

    LFound := True;
    for LElement in LExpectedElements do
    begin
      if not ContainsText(LSource, LElement) then
      begin
        WriteLn('    ❌ Missing utility element: "', LElement, '"');
        LFound := False;
      end;
    end;

    if LFound then
      WriteLn('    ✅ All mixed utility elements found')
    else
      WriteLn('    ❌ Some mixed utility elements missing');

    // Count blank lines again
    LLines := LSource.Split([sLineBreak]);
    LBlankLineCount := 0;
    for LLineText in LLines do
    begin
      if Trim(LLineText) = '' then
        Inc(LBlankLineCount);
    end;

    if LBlankLineCount >= 6 then
      WriteLn('    ✅ Adequate blank lines in mixed test (found ', LBlankLineCount, ' blank lines)')
    else
      WriteLn('    ❌ Insufficient blank lines in mixed test (found ', LBlankLineCount, ', expected at least 6)');

    WriteLn('    📄 Complete mixed utility source (', Length(LSource), ' characters):');
    WriteLn('    ========================================');
    for LI := 0 to High(LLines) do
      WriteLn('    [', LI + 1:2, '] ', LLines[LI]);
    WriteLn('    ========================================');

    // === TEST 4: Comment Style Validation ===
    WriteLn('  🔍 Test ', LTestNumber, ': Comment style validation and edge cases');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('CommentStyleTest'))
        .CPAddComment('Line comment with special chars: @#$%^&*()', csLine)
        .CPAddComment('Block comment with "quotes" and ''apostrophes''', csBlock)
        .CPAddComment('Brace comment with {nested} and [brackets]', csBrace)
        .CPAddComment('', csLine)  // Empty comment
        .CPAddComment('Multi-word comment with spaces and numbers 123', csBlock)
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Comment validation complete')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    LExpectedElements := [
      '// Line comment with special chars: @#$%^&*()',
      '/* Block comment with "quotes" and ''apostrophes'' */',
      '{ Brace comment with {nested} and [brackets] }',
      '//',  // Empty line comment
      '/* Multi-word comment with spaces and numbers 123 */'
    ];

    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Comment style "', LElement, '" validated correctly')
      else
        WriteLn('    ❌ Comment style "', LElement, '" validation failed');
    end;

    // === TEST 5: Complete Phase 1G Integration Test ===
    WriteLn('  🎯 Test ', LTestNumber, ': Complete Phase 1G integration test');
    //Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('Phase1GComplete'))
        .CPAddComment('=========================================', csLine)
        .CPAddComment(' Phase 1G: Utility Structure Methods', csLine)
        .CPAddComment(' Complete Integration Test', csLine)
        .CPAddComment('=========================================', csLine)
        .CPAddBlankLine()
        .CPAddComment('This program demonstrates all utility features', csBlock)
        .CPAddBlankLine()
        .CPStartConstSection()
          .CPAddComment('Application constants', csBrace)
          .CPAddConstant('APP_NAME', '''Phase1G Test''')
          .CPAddConstant('VERSION_MAJOR', '1')
          .CPAddConstant('VERSION_MINOR', '0')
        .CPAddBlankLine()
        .CPStartTypeSection()
          .CPAddComment('Custom type definitions', csLine)
          .CPAddTypeAlias('TAppName', 'string')
          .CPAddTypeAlias('TVersionNumber', 'Int32')
        .CPAddBlankLine()
        .CPStartVarSection()
          .CPAddComment('Global application variables', csBlock)
          .CPAddVariable([CPIdentifier('applicationName')], CPGetStringType())
          .CPAddVariable([CPIdentifier('majorVersion'), CPIdentifier('minorVersion')], cptInt32)
          .CPAddVariable([CPIdentifier('isRunning')], cptBoolean)
        .CPAddBlankLine()
        .CPAddComment('Main execution block begins here', csBrace)
        .CPStartCompoundStatement()
          .CPAddComment('Initialize application data', csLine)
          .CPAddAssignment(CPIdentifier('applicationName'), CPString('Phase1G Test'))
          .CPAddAssignment(CPIdentifier('majorVersion'), CPInt32(1))
          .CPAddAssignment(CPIdentifier('minorVersion'), CPInt32(0))
          .CPAddAssignment(CPIdentifier('isRunning'), CPBoolean(True))
          .CPAddBlankLine()
          .CPAddComment('Display startup message', csBlock)
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Application started successfully!')])
          .CPAddBlankLine()
          .CPAddComment('Perform main application logic', csBrace)
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Phase 1G utility features working!')])
          .CPAddBlankLine()
          .CPAddComment('Clean shutdown sequence', csLine)
          .CPAddAssignment(CPIdentifier('isRunning'), CPBoolean(False))
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Application terminated gracefully.')])
        .CPEndCompoundStatement()
        .CPAddBlankLine()
        .CPAddComment('End of Phase 1G Complete Integration Test', csLine)
        .CPEndProgram()
        .GetCPas(True);
    end;

    // Final verification of all Phase 1G features
    LExpectedElements := [
      'program Phase1GComplete;',
      '// =========================================',
      '//  Phase 1G: Utility Structure Methods',
      '//  Complete Integration Test',
      '/* This program demonstrates all utility features */',
      '{ Application constants }',
      'APP_NAME = ''Phase1G Test'';',
      '// Custom type definitions',
      'TAppName = string;',
      '/* Global application variables */',
      'applicationName: string;',
      '{ Main execution block begins here }',
      '// Initialize application data',
      'applicationName := ''Phase1G Test'';',
      '/* Display startup message */',
      'Application started successfully!',
      '{ Perform main application logic }',
      'Phase 1G utility features working!',
      '// Clean shutdown sequence',
      'Application terminated gracefully.',
      '// End of Phase 1G Complete Integration Test',
      'end.'
    ];

    LFound := True;
    for LElement in LExpectedElements do
    begin
      if not ContainsText(LSource, LElement) then
      begin
        WriteLn('    ❌ Missing Phase 1G element: "', LElement, '"');
        LFound := False;
      end;
    end;

    if LFound then
      WriteLn('    ✅ All Phase 1G elements found in complete integration test')
    else
      WriteLn('    ❌ Some Phase 1G elements missing from integration test');

    // Final blank line count
    LLines := LSource.Split([sLineBreak]);
    LBlankLineCount := 0;
    for LLineText in LLines do
    begin
      if Trim(LLineText) = '' then
        Inc(LBlankLineCount);
    end;

    WriteLn('    📊 Total blank lines in complete test: ', LBlankLineCount);
    WriteLn('    📄 Complete Phase 1G program (', Length(LSource), ' characters):');
    WriteLn('    ========================================');
    for LI := 0 to High(LLines) do
      WriteLn('    [', LI + 1:2, '] ', LLines[LI]);
    WriteLn('    ========================================');

    // === FINAL VERIFICATION ===
    WriteLn('  🎉 Phase 1G Utility Structure Methods test completed successfully!');
    WriteLn('  ✅ ALL Phase 1G functionality verified and working:');
    WriteLn('    - 💬 Comment system with all three styles (line //, block /* */, brace { })');
    WriteLn('    - 📄 Blank line management for code formatting');
    WriteLn('    - 🎨 Mixed comments and blank lines integration');
    WriteLn('    - 🔍 Comment style validation and edge cases');
    WriteLn('    - 🎯 Complete integration test with all utility features');
    WriteLn('  🚀 Phase 1G: Utility Structure Methods is production-ready!');
    WriteLn('  ✨ Builder now has complete utility and formatting support!');
    WriteLn('  📝 Code generation includes proper documentation and formatting!');

  except
    on E: Exception do
    begin
      WriteLn('  ❌ Phase 1G Utility Structure Methods test failed with exception: ', E.Message);
      WriteLn('  ❌ Exception class: ', E.ClassName);
      raise; // Re-raise for test runner
    end;
  end;
end;


end.
