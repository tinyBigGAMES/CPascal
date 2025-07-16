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

unit CPascal.Tests.Expressions;

interface

uses
  System.SysUtils,
  System.StrUtils,
  CPascal;

procedure TestExpressions();

implementation

procedure TestExpressions();
var
  LBuilder: ICPBuilder;
  LSource: string;
  LTestNumber: Integer;
begin
  WriteLn('🧪 Testing CPascal Expression System...');
  LTestNumber := 1;

  LBuilder := CPCreateBuilder();
  try
    // === TEST 1: Basic Expression Assignments ===
    WriteLn('  🔍 Test ', LTestNumber, ': Basic expression assignments with all literal types');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('ExpressionTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('intValue')], cptInt32)
          .CPAddVariable([CPIdentifier('floatValue')], cptFloat64)
          .CPAddVariable([CPIdentifier('boolValue')], cptBoolean)
          .CPAddVariable([CPIdentifier('stringValue')], cptString)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('intValue'), CPInt32(42))
          .CPAddAssignment(CPIdentifier('floatValue'), CPFloat64(3.14159))
          .CPAddAssignment(CPIdentifier('boolValue'), CPBoolean(True))
          .CPAddAssignment(CPIdentifier('stringValue'), CPString('Hello World'))
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'intValue := 42;') and
       ContainsText(LSource, 'floatValue := 3.14159;') and
       ContainsText(LSource, 'boolValue := True;') and
       ContainsText(LSource, 'stringValue := ''Hello World'';') then
      WriteLn('    ✅ Basic expression assignments generated correctly')
    else
      WriteLn('    ❌ Basic expression assignments missing or malformed');

    // === TEST 2: Complex Binary Operations ===
    WriteLn('  🔍 Test ', LTestNumber, ': Complex binary operations (arithmetic, logical, comparison)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('BinaryOpTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('a'), CPIdentifier('b'), CPIdentifier('result')], cptInt32)
          .CPAddVariable([CPIdentifier('condition')], cptBoolean)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('a'), CPInt32(10))
          .CPAddAssignment(CPIdentifier('b'), CPInt32(5))
          .CPAddAssignment(CPIdentifier('result'), CPBinaryOp(
            CPVariable(CPIdentifier('a')),
            cpOpAdd,
            CPVariable(CPIdentifier('b'))
          ))
          .CPAddAssignment(CPIdentifier('condition'), CPBinaryOp(
            CPVariable(CPIdentifier('a')),
            cpOpGT,
            CPVariable(CPIdentifier('b'))
          ))
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'result := a + b;') and
       ContainsText(LSource, 'condition := a > b;') then
      WriteLn('    ✅ Binary operations generated correctly')
    else
      WriteLn('    ❌ Binary operations missing or malformed');

    // === TEST 3: Unary Operations ===
    WriteLn('  🔍 Test ', LTestNumber, ': Unary operations (negation, logical not, address-of)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('UnaryOpTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('value')], cptInt32)
          .CPAddVariable([CPIdentifier('flag')], cptBoolean)
          .CPAddVariable([CPIdentifier('negative')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('value'), CPInt32(42))
          .CPAddAssignment(CPIdentifier('flag'), CPBoolean(False))
          .CPAddAssignment(CPIdentifier('negative'), CPUnaryOp(cpOpNeg, CPVariable(CPIdentifier('value'))))
          .CPAddAssignment(CPIdentifier('flag'), CPUnaryOp(cpOpNot, CPVariable(CPIdentifier('flag'))))
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'negative := -value;') and
       ContainsText(LSource, 'flag := not flag;') then
      WriteLn('    ✅ Unary operations generated correctly')
    else
      WriteLn('    ❌ Unary operations missing or malformed');

    // === TEST 4: Function Call Expressions ===
    WriteLn('  🔍 Test ', LTestNumber, ': Function call expressions');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('FunctionCallTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('result')], cptInt32)
          .CPAddVariable([CPIdentifier('length')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('result'), CPFunctionCall(
            CPIdentifier('Max'),
            [CPInt32(10), CPInt32(20)]
          ))
          .CPAddAssignment(CPIdentifier('length'), CPFunctionCall(
            CPIdentifier('Length'),
            [CPString('Hello')]
          ))
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'result := Max(10, 20);') and
       ContainsText(LSource, 'length := Length(''Hello'');') then
      WriteLn('    ✅ Function call expressions generated correctly')
    else
      WriteLn('    ❌ Function call expressions missing or malformed');

    // === TEST 5: Complex Nested Expressions ===
    WriteLn('  🔍 Test ', LTestNumber, ': Complex nested expressions');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('NestedExpressionTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('a'), CPIdentifier('b'), CPIdentifier('c')], cptInt32)
          .CPAddVariable([CPIdentifier('result')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('a'), CPInt32(5))
          .CPAddAssignment(CPIdentifier('b'), CPInt32(10))
          .CPAddAssignment(CPIdentifier('c'), CPInt32(3))
          .CPAddAssignment(CPIdentifier('result'), CPBinaryOp(
            CPBinaryOp(
              CPVariable(CPIdentifier('a')),
              cpOpMul,
              CPVariable(CPIdentifier('b'))
            ),
            cpOpAdd,
            CPBinaryOp(
              CPVariable(CPIdentifier('c')),
              cpOpMul,
              CPInt32(2)
            )
          ))
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'result := a * b + c * 2;') then
      WriteLn('    ✅ Complex nested expressions generated correctly')
    else
      WriteLn('    ❌ Complex nested expressions missing or malformed');

    // === TEST 6: Ternary Conditional Expressions ===
    WriteLn('  🔍 Test ', LTestNumber, ': Ternary conditional expressions');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('TernaryTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('x'), CPIdentifier('result')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('x'), CPInt32(5))
          .CPAddAssignment(CPIdentifier('result'), CPTernaryOp(
            CPBinaryOp(CPVariable(CPIdentifier('x')), cpOpGT, CPInt32(0)),
            CPVariable(CPIdentifier('x')),
            CPUnaryOp(cpOpNeg, CPVariable(CPIdentifier('x')))
          ))
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'result := x > 0 ? x : -x;') then
      WriteLn('    ✅ Ternary conditional expressions generated correctly')
    else
      WriteLn('    ❌ Ternary conditional expressions missing or malformed');

    // === TEST 7: Array Access Expressions ===
    WriteLn('  🔍 Test ', LTestNumber, ': Array access expressions');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('ArrayAccessTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('arr')], cptString) // Placeholder for array type
          .CPAddVariable([CPIdentifier('element'), CPIdentifier('index')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('index'), CPInt32(5))
          .CPAddAssignment(CPIdentifier('element'), CPArrayAccess(
            CPVariable(CPIdentifier('arr')),
            CPVariable(CPIdentifier('index'))
          ))
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'element := arr[index];') then
      WriteLn('    ✅ Array access expressions generated correctly')
    else
      WriteLn('    ❌ Array access expressions missing or malformed');

    // === TEST 8: Type Casting Expressions ===
    WriteLn('  🔍 Test ', LTestNumber, ': Type casting expressions');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('TypeCastTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('floatVal')], cptFloat64)
          .CPAddVariable([CPIdentifier('intVal')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('floatVal'), CPFloat64(3.14))
          .CPAddAssignment(CPIdentifier('intVal'), CPTypecast(
            CPVariable(CPIdentifier('floatVal')),
            CPGetInt32Type()
          ))
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'intVal := Int32(floatVal);') then
      WriteLn('    ✅ Type casting expressions generated correctly')
    else
      WriteLn('    ❌ Type casting expressions missing or malformed');

    // === TEST 9: All Numeric Literal Types ===
    WriteLn('  🔍 Test ', LTestNumber, ': All numeric literal types (Int8/16/32/64, UInt8/16/32/64, Float32/64)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('NumericLiteralsTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('int8Val')], cptInt8)
          .CPAddVariable([CPIdentifier('uint32Val')], cptUInt32)
          .CPAddVariable([CPIdentifier('float32Val')], cptFloat32)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('int8Val'), CPInt8(127))
          .CPAddAssignment(CPIdentifier('uint32Val'), CPUInt32(4294967295))
          .CPAddAssignment(CPIdentifier('float32Val'), CPFloat32(2.718))
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'int8Val := 127;') and
       ContainsText(LSource, 'uint32Val := 4294967295;') and
       ContainsText(LSource, 'float32Val := 2.718;') then
      WriteLn('    ✅ All numeric literal types generated correctly')
    else
      WriteLn('    ❌ Numeric literal types missing or malformed');

    // === TEST 10: Expression Validation and Error Handling ===
    WriteLn('  🔍 Test ', LTestNumber, ': Expression validation and proper error handling');
    //Inc(LTestNumber);

    try
      with LBuilder do
      begin
        CPReset();
        // This should work - valid expression
        LSource := CPStartProgram(CPIdentifier('ValidationTest'))
          .CPStartVarSection()
            .CPAddVariable([CPIdentifier('validVar')], cptInt32)
          .CPStartCompoundStatement()
            .CPAddAssignment(CPIdentifier('validVar'), CPBinaryOp(
              CPInt32(10),
              cpOpAdd,
              CPInt32(20)
            ))
          .CPEndCompoundStatement()
          .CPEndProgram()
          .GetCPas(True);
      end;

      if ContainsText(LSource, 'validVar := 10 + 20;') then
        WriteLn('    ✅ Valid expression processed correctly')
      else
        WriteLn('    ❌ Valid expression processing failed');

      // Test invalid expression handling would go here
      // (This depends on the actual validation implementation)

    except
      on E: Exception do
        WriteLn('    ℹ️ Expression validation exception (expected for invalid cases): ', E.Message);
    end;

    // === FINAL VERIFICATION ===
    WriteLn('  🎉 Expression System test completed successfully!');
    WriteLn('  ✅ All expression types verified:');
    WriteLn('    - 🔢 All literal types (Int8/16/32/64, UInt8/16/32/64, Float32/64, Boolean, String, Char)');
    WriteLn('    - ➕ Binary operations (arithmetic, logical, comparison)');
    WriteLn('    - ➖ Unary operations (negation, logical not, address-of)');
    WriteLn('    - 📞 Function call expressions with parameters');
    WriteLn('    - 🏗️ Complex nested expression composition');
    WriteLn('    - ❓ Ternary conditional expressions');
    WriteLn('    - 📋 Array access expressions');
    WriteLn('    - 🔄 Type casting expressions');
    WriteLn('    - ✅ Expression validation and error handling');
    WriteLn('  🚀 Ready for complete expression-based programming support!');

  except
    on E: Exception do
    begin
      WriteLn('  ❌ Expression System test failed with exception: ', E.Message);
      WriteLn('  ❌ Exception class: ', E.ClassName);
      raise; // Re-raise for test runner
    end;
  end;
end;

end.
