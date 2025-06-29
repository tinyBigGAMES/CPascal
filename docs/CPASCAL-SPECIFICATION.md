# CPascal Language Specification
**Version 1.0**

## Table of Contents

1. [Introduction](#introduction)
2. [Design Goals](#design-goals)
3. [Lexical Structure](#lexical-structure)
4. [Data Types](#data-types)
5. [Expressions and Operators](#expressions-and-operators)
6. [Statements](#statements)
7. [Functions and Procedures](#functions-and-procedures)
8. [Modules and Visibility](#modules-and-visibility)
9. [C ABI Compatibility](#c-abi-compatibility)
10. [External Interface](#external-interface)
11. [Compiler Directives](#compiler-directives)
12. [File Conventions](#file-conventions)
13. [Standard Library](#standard-library)
14. [Formal Grammar](#formal-grammar)
15. [Examples](#examples)

---

## 1. Introduction

CPascal is a systems programming language that combines Pascal's readable syntax with C's semantic model and binary compatibility. It compiles to LLVM IR and maintains full C ABI compatibility, enabling seamless interoperation with existing C libraries and codebases.

### 1.1 Language Philosophy

CPascal is designed as "better C" - providing the power and control of C with the clarity and structure of Pascal. Every CPascal construct maps directly to equivalent C constructs at the binary level, ensuring zero-overhead abstraction and complete compatibility.

### 1.2 Target Applications

- Systems programming
- Game development  
- Device drivers
- Embedded systems
- Performance-critical applications
- Modernizing C codebases

---

## 2. Design Goals

### 2.1 Primary Goals

1. **Full C ABI Compatibility**: All data types, function calls, and memory layouts identical to C
2. **Pascal Syntax**: Clean, readable syntax with structured programming constructs
3. **Zero Runtime Overhead**: Direct compilation to efficient machine code
4. **Seamless C Interop**: Link any C library without bindings or wrappers
5. **Modern Module System**: Clean imports without C's preprocessor complexity

### 2.2 Non-Goals

- Object-oriented programming features
- Garbage collection or automatic memory management
- Runtime type information (RTTI)
- Exception handling beyond C's setjmp/longjmp
- Dynamic typing or reflection

---

## 3. Lexical Structure

### 3.1 Character Set

CPascal source files use UTF-8 encoding. The basic character set includes:
- Letters: `a-z`, `A-Z`, `_`
- Digits: `0-9`
- Special characters: Standard ASCII printable characters

### 3.2 Case Sensitivity

CPascal is **case-sensitive**. `MyVariable` and `myvariable` are distinct identifiers.

### 3.3 Comments

```cpascal
// Line comment - continues to end of line

/* Block comment
   can span multiple lines */

{ Brace comment - Pascal style }
```

### 3.4 Identifiers

```
identifier = letter { letter | digit }
letter = "a".."z" | "A".."Z" | "_"
digit = "0".."9"
```

Examples: `MyVariable`, `count`, `SDL_Window`, `buffer_size`

### 3.5 Keywords

Reserved words that cannot be used as identifiers:

```
and       array     asm       begin     break     case      const
continue  div       do        downto    else      end       exit
external  false     for       function  goto      if        import
inline    label     libpath   link      mod       module    nil
not       of        or        packed    procedure program   public
record    repeat    shl       shr       then      to        true
type      union     until     var       while     xor
```

### 3.6 Numeric Literals

#### 3.6.1 Integer Literals

```cpascal
// Decimal
42
1234567

// Hexadecimal  
0xFF
0x1A2B
$DEADBEEF    // Pascal-style hex

// Binary
0b10110011
0b11111111

// Octal
0o755
0o644
```

#### 3.6.2 Floating-Point Literals

```cpascal
// Standard notation
3.14159
0.5
42.0

// Scientific notation
1.23e-4
6.022E23
-1.5e+10
```

### 3.7 String Literals

```cpascal
// Double-quoted strings (C-style)
"Hello, World!"
"Path\\to\\file"
"Line 1\nLine 2\t\tTabbed"

// Escape sequences
"\n"     // newline
"\t"     // tab
"\r"     // carriage return
"\\"     // backslash
"\""     // double quote
"\0"     // null character
"\xFF"   // hex escape (1-2 digits)
"\123"   // octal escape (1-3 digits)
"\u1234" // Unicode escape (4 hex digits)
"\U12345678" // Unicode escape (8 hex digits)
"\a"     // bell/alert
"\b"     // backspace
"\f"     // form feed
"\v"     // vertical tab
```

### 3.8 Character Literals

```cpascal
#65      // Character with ASCII code 65 ('A')
#13      // Carriage return
#10      // Line feed
#0       // Null character
```

---

## 4. Data Types

### 4.1 Fundamental Types

All CPascal types map directly to C types with identical size and alignment:

| CPascal Type | C Equivalent | Size (bytes) | Range |
|--------------|--------------|--------------|--------|
| `Int8` | `int8_t` | 1 | -128 to 127 |
| `UInt8` | `uint8_t` | 1 | 0 to 255 |
| `Int16` | `int16_t` | 2 | -32,768 to 32,767 |
| `UInt16` | `uint16_t` | 2 | 0 to 65,535 |
| `Int32` | `int32_t` | 4 | -2³¹ to 2³¹-1 |
| `UInt32` | `uint32_t` | 4 | 0 to 2³²-1 |
| `Int64` | `int64_t` | 8 | -2⁶³ to 2⁶³-1 |
| `UInt64` | `uint64_t` | 8 | 0 to 2⁶⁴-1 |
| `Single` | `float` | 4 | IEEE 754 single |
| `Double` | `double` | 8 | IEEE 754 double |
| `Boolean` | `bool` | 1 | `true` or `false` |
| `Char` | `char` | 1 | 0 to 255 |
| `Pointer` | `void*` | 8/4 | Platform pointer |
| `NativeInt` | `intptr_t` | 8/4 | Platform integer |
| `NativeUInt` | `uintptr_t` | 8/4 | Platform unsigned |
| `PChar` | `char*` | 8/4 | String pointer |

### 4.2 Type Qualifiers

```cpascal
const Value: Int32 = 42;        // Immutable
volatile Status: UInt32;        // Prevents optimization
const volatile Register: UInt32; // Both qualifiers
```

### 4.3 Pointer Types

```cpascal
type
  PInt32 = ^Int32;              // Pointer to Int32
  PPChar = ^PChar;              // Pointer to pointer to Char
  
var
  Value: Int32;
  Ptr: ^Int32;
  
begin
  Ptr := @Value;                // Address-of operator
  Value := Ptr^;                // Dereference operator
end;
```

### 4.4 Array Types

#### 4.4.1 Fixed Arrays

```cpascal
type
  TBuffer = array[0..255] of UInt8;        // 256 bytes
  TMatrix = array[0..3, 0..3] of Single;  // 4x4 matrix
  
var
  Buffer: TBuffer;
  Matrix: TMatrix;
  
begin
  Buffer[0] := 255;
  Matrix[1, 2] := 3.14;
end;
```

### 4.5 Record Types

```cpascal
type
  TPoint = packed record
    X, Y: Int32;
  end;
  
  TColor = packed record
    case Boolean of
      true: (RGBA: UInt32);
      false: (R, G, B, A: UInt8);
  end;
  
var
  Point: TPoint;
  Color: TColor;
  
begin
  Point.X := 100;
  Point.Y := 200;
  
  Color.R := 255;
  Color.G := 128;
  Color.B := 64;
  Color.A := 255;
end;
```

### 4.6 Union Types

```cpascal
type
  TValue = union
    AsInt: Int32;
    AsFloat: Single;
    AsBytes: array[0..3] of UInt8;
  end;
  
var
  Value: TValue;
  
begin
  Value.AsInt := 0x3F800000;    // IEEE 754 for 1.0
  // Value.AsFloat is now 1.0
end;
```

### 4.7 Enumeration Types

```cpascal
type
  TDirection = (North, South, East, West);
  TFileMode = (Read = 1, Write = 2, Execute = 4);
  
var
  Dir: TDirection;
  Mode: TFileMode;
  
begin
  Dir := North;                 // First value (0)
  Mode := Write;                // Explicit value (2)
end;
```

### 4.8 Function Types

```cpascal
type
  TCallback = function(const AValue: Int32): Boolean;
  THandler = procedure(const AData: Pointer);
  TVariadicFunc = function(const AFormat: PChar, ...): Int32;
  
var
  Callback: TCallback;
  Handler: THandler;
  VarFunc: TVariadicFunc;
  
function MyCallback(const AValue: Int32): Boolean;
begin
  Result := AValue > 0;
end;

begin
  Callback := @MyCallback;
  if Callback(42) then
    // Do something
    
  VarFunc := @printf;  // C printf function
end;
```

---

## 5. Expressions and Operators

### 5.1 Operator Precedence

From highest to lowest precedence:

1. **Postfix**: `[]`, `^`, `.`, `++`, `--`, function call
2. **Unary**: `+`, `-`, `not`, `++`, `--`, `@`, `*`
3. **Multiplicative**: `*`, `/`, `div`, `mod`
4. **Additive**: `+`, `-`
5. **Shift**: `shl`, `shr`
6. **Relational**: `<`, `<=`, `>`, `>=`
7. **Equality**: `=`, `<>`
8. **Bitwise AND**: `&`
9. **Bitwise XOR**: `xor`
10. **Bitwise OR**: `|`
11. **Logical AND**: `and`
12. **Logical OR**: `or`
13. **Ternary**: `?:`
14. **Assignment**: `:=`, `+=`, `-=`, `*=`, `/=`, `and=`, `or=`, `xor=`, `shl=`, `shr=`

### 5.2 Arithmetic Operators

```cpascal
var
  A, B, C: Int32;
begin
  C := A + B;    // Addition
  C := A - B;    // Subtraction
  C := A * B;    // Multiplication
  C := A div B;  // Integer division
  C := A mod B;  // Modulo
  C := A / B;    // Floating-point division (if operands are float)
end;
```

### 5.3 Bitwise Operators

```cpascal
var
  Flags: UInt32;
begin
  Flags := $FF & $0F;      // Bitwise AND
  Flags := Flags | $80;    // Bitwise OR
  Flags := Flags xor $AA;  // Bitwise XOR
  Flags := not Flags;      // Bitwise NOT
  Flags := Flags shl 2;    // Shift left
  Flags := Flags shr 1;    // Shift right
end;
```

### 5.4 Comparison Operators

```cpascal
var
  A, B: Int32;
  Result: Boolean;
begin
  Result := A = B;     // Equal
  Result := A <> B;    // Not equal
  Result := A < B;     // Less than
  Result := A <= B;    // Less than or equal
  Result := A > B;     // Greater than
  Result := A >= B;    // Greater than or equal
end;
```

### 5.5 Logical Operators

```cpascal
var
  A, B, C: Boolean;
begin
  C := A and B;        // Logical AND
  C := A or B;         // Logical OR
  C := not A;          // Logical NOT
end;
```

### 5.6 Assignment Operators

```cpascal
var
  Value: Int32;
  Flags: UInt32;
begin
  Value := 42;         // Simple assignment
  Value += 10;         // Compound addition
  Value -= 5;          // Compound subtraction
  Value *= 2;          // Compound multiplication
  Value /= 3;          // Compound division
  
  Flags and= $FF;      // Compound bitwise AND
  Flags or= $80;       // Compound bitwise OR
  Flags xor= $AA;      // Compound bitwise XOR
  Flags shl= 2;        // Compound shift left
  Flags shr= 1;        // Compound shift right
end;
```

### 5.7 Increment/Decrement Operators

```cpascal
var
  I: Int32;
begin
  Inc(I);              // Built-in increment
  Dec(I);              // Built-in decrement
  I++;                 // Postfix increment
  ++I;                 // Prefix increment
  I--;                 // Postfix decrement
  --I;                 // Prefix decrement
end;
```

### 5.8 Ternary Operator

```cpascal
var
  A, B, Max: Int32;
  Status: Boolean;
  Message: PChar;
begin
  Max := (A > B) ? A : B;              // Conditional expression
  Message := Status ? "Success" : "Failed";
end;
```

### 5.9 Address and Dereference

```cpascal
var
  Value: Int32;
  Ptr: ^Int32;
begin
  Ptr := @Value;               // Address-of
  Value := Ptr^;               // Dereference
end;
```

### 5.10 Type Casting

```cpascal
var
  IntValue: Int32;
  FloatValue: Single;
  Ptr: Pointer;
begin
  FloatValue := Single(IntValue);     // Type cast
  Ptr := Pointer(IntValue);           // Cast to pointer
  IntValue := Int32(Ptr);             // Cast from pointer
end;
```

### 5.11 Multiple Assignment

```cpascal
var
  A, B, C: Int32;
  X, Y: Single;
  
function GetCoordinates(): (Int32, Int32);
begin
  Result := (100, 200);
end;

function GetPoint(): (Single, Single);
begin
  Result := (3.14, 2.71);
end;

begin
  A, B := GetCoordinates();    // Multiple assignment
  X, Y := GetPoint();
  A, B, C := 1, 2, 3;         // Direct multiple assignment
end;
```

---

## 6. Statements

### 6.1 Simple Statements

#### 6.1.1 Assignment Statement

```cpascal
var
  A, B, C: Int32;
begin
  A := 42;                     // Single assignment
  A, B := GetCoordinates();    // Multiple assignment
  A += 10;                     // Compound assignment
end;
```

#### 6.1.2 Procedure Call

```cpascal
begin
  WriteLn("Hello, World!");
  ProcessData(@Buffer, SizeOf(Buffer));
end;
```

#### 6.1.3 Empty Statement

```cpascal
begin
  ;  // Empty statement
end;
```

### 6.2 Compound Statement

```cpascal
begin
  Statement1();
  Statement2();
  Statement3();
end;
```

### 6.3 Conditional Statements

#### 6.3.1 If Statement

```cpascal
begin
  if Condition then
    SingleStatement();
    
  if Condition then
  begin
    Statement1();
    Statement2();
  end;
  
  if Condition then
    Statement1()
  else
    Statement2();
    
  if Condition1 then
    Statement1()
  else if Condition2 then
    Statement2()
  else
    Statement3();
end;
```

#### 6.3.2 Case Statement

```cpascal
var
  Value: Int32;
begin
  case Value of
    1: HandleOne();
    2, 3, 4: HandleTwoThreeFour();
    5..10: HandleRange();
  else
    HandleDefault();
  end;
end;
```

### 6.4 Loop Statements

#### 6.4.1 While Loop

```cpascal
var
  I: Int32;
begin
  I := 0;
  while I < 10 do
  begin
    ProcessItem(I);
    Inc(I);
  end;
end;
```

#### 6.4.2 For Loop

```cpascal
var
  I: Int32;
begin
  for I := 1 to 10 do
    ProcessItem(I);
    
  for I := 10 downto 1 do
    ProcessItem(I);
end;
```

#### 6.4.3 Repeat-Until Loop

```cpascal
var
  Input: Char;
begin
  repeat
    Input := ReadChar();
    ProcessInput(Input);
  until Input = #27;  // ESC key
end;
```

### 6.5 Jump Statements

#### 6.5.1 Break and Continue

```cpascal
var
  I: Int32;
begin
  for I := 1 to 100 do
  begin
    if I mod 2 = 0 then
      continue;  // Skip even numbers
      
    if I > 50 then
      break;     // Exit loop
      
    ProcessOddNumber(I);
  end;
end;
```

#### 6.5.2 Exit Statement

```cpascal
function FindValue(const AArray: ^Int32; const ACount: Int32; const AValue: Int32): Int32;
var
  I: Int32;
begin
  for I := 0 to ACount - 1 do
  begin
    if AArray[I] = AValue then
      exit(I);  // Return index with value
  end;
  
  exit(-1);     // Not found - return with value
end;

procedure ProcessData();
begin
  if not InitializeData() then
    exit;       // Early return from procedure
    
  DoProcessing();
end;
```

#### 6.5.3 Goto Statement

```cpascal
label
  ErrorExit, Cleanup;
  
var
  Success: Boolean;
begin
  Success := InitializeSystem();
  if not Success then
    goto ErrorExit;
    
  ProcessData();
  goto Cleanup;
  
ErrorExit:
  ShowError("Initialization failed");
  
Cleanup:
  CleanupResources();
end;
```

### 6.6 Inline Assembly

CPascal supports inline assembly using extended assembly syntax with input/output constraints:

```cpascal
function GetCPUID(): UInt32;
var
  Result: UInt32;
begin
  asm
    "mov $1, %%eax"
    "cpuid"
    "mov %%eax, %0"
    : "=r" (Result)        // Output operands
    :                      // Input operands (none)
    : "eax", "ebx", "ecx", "edx"  // Clobbered registers
  end;
end;

procedure MemoryBarrier();
begin
  asm
    "mfence"
    :                      // No outputs
    :                      // No inputs
    : "memory"             // Memory barrier
  end;
end;

function AtomicIncrement(const APtr: ^Int32): Int32;
var
  Result: Int32;
begin
  asm
    "lock incl %1"
    "movl %1, %0"
    : "=r" (Result)        // Output: Result register
    : "m" (APtr^)          // Input: memory location
    : "memory"             // Clobbered: memory
  end;
end;
```

#### 6.6.1 Assembly Constraints

**Output Constraints:**
- `"=r"` - Register output
- `"=m"` - Memory output
- `"=a"` - EAX register specifically

**Input Constraints:**
- `"r"` - Register input
- `"m"` - Memory input
- `"i"` - Immediate integer constant
- `"n"` - Immediate integer constant with known value

**Modifier Characters:**
- `=` - Output operand
- `+` - Input/output operand
- `&` - Early clobber operand

**Clobbered Registers:**
- Specific registers: `"eax"`, `"ebx"`, `"ecx"`, `"edx"`
- Memory effects: `"memory"`
- Condition codes: `"cc"`

---

## 7. Functions and Procedures

### 7.1 Function Declaration

```cpascal
function Add(const A, B: Int32): Int32;
begin
  Result := A + B;
end;

procedure ShowMessage(const AMessage: PChar);
begin
  printf("%s\n", AMessage);
end;
```

### 7.2 Parameter Passing

#### 7.2.1 Value Parameters

```cpascal
function Square(const AValue: Int32): Int32;
begin
  Result := AValue * AValue;  // AValue is read-only copy
end;
```

#### 7.2.2 Variable Parameters

```cpascal
procedure Swap(var A, B: Int32);
var
  Temp: Int32;
begin
  Temp := A;
  A := B;
  B := Temp;
end;
```

#### 7.2.3 Output Parameters

```cpascal
function DivMod(const A, B: Int32; out Remainder: Int32): Int32;
begin
  Result := A div B;
  Remainder := A mod B;
end;
```

### 7.3 Calling Conventions

```cpascal
// Default calling convention (C)
function StandardFunc(const A: Int32): Int32;

// Explicit calling conventions
function CdeclFunc(const A: Int32): Int32; cdecl;
function StdcallFunc(const A: Int32): Int32; stdcall;
function FastcallFunc(const A: Int32): Int32; fastcall;
function RegisterFunc(const A: Int32): Int32; register;

// Combined with inline
function InlineCdecl(const A: Int32): Int32; cdecl; inline;
function InlineStdcall(const A: Int32): Int32; inline; stdcall;
```

### 7.4 Variadic Functions

```cpascal
// External variadic function
function printf(const AFormat: PChar, ...): Int32; external;
function sprintf(const ABuffer: PChar; const AFormat: PChar, ...): Int32; external;

// Custom variadic function declaration
function MyPrintf(const AFormat: PChar, ...): Int32; cdecl;
// Implementation requires va_list handling

// Using variadic functions
var
  Buffer: array[0..255] of Char;
  Count: Int32;
begin
  printf("Hello %s, you have %d messages\n", "User", 5);
  Count := sprintf(@Buffer[0], "Value: %d", 42);
end;
```

### 7.5 Inline Functions

```cpascal
function Square(const AValue: Int32): Int32; inline;
begin
  Result := AValue * AValue;
end;

function Max(const A, B: Int32): Int32; inline; cdecl;
begin
  Result := (A > B) ? A : B;
end;
```

### 7.6 External Functions

```cpascal
// System functions
function malloc(const ASize: NativeUInt): Pointer; external;
procedure free(const APtr: Pointer); external;

// Library functions with explicit library
function SDL_Init(const AFlags: UInt32): Int32; external "SDL2.dll";
function SDL_CreateWindow(const ATitle: PChar; const AX, AY, AW, AH, AFlags: Int32): Pointer; external "SDL2.dll";

// With calling conventions
function WinAPI_GetTickCount(): UInt32; stdcall; external "kernel32.dll";
function GetSystemMetrics(const AIndex: Int32): Int32; stdcall; external "user32.dll";
```

### 7.7 Function Overloading by Calling Convention

```cpascal
// Different calling conventions create different symbols
function ApiCall(const AParam: Int32): Int32; cdecl; external;
function ApiCall(const AParam: Int32): Int32; stdcall; external;
```

---

## 8. Modules and Visibility

### 8.1 Module Structure

```cpascal
module ModuleName;

import Module1, Module2;
libpath "/usr/local/lib";
link SDL2, OpenGL;

// Private declarations (default)
type
  TInternalType = record
    Data: Int32;
  end;

// Public declarations
public type
  TPublicType = record
    Value: Int32;
  end;

public function PublicFunction(const A: Int32): Int32;
begin
  Result := A * 2;
end;

// Private function
function PrivateHelper(): Boolean;
begin
  Result := true;
end;

end.
```

### 8.2 Program Structure

```cpascal
program GameEngine;

import Graphics, Audio, Input;
libpath "/usr/lib/x86_64-linux-gnu";
libpath "/usr/local/lib";
link SDL2, OpenGL32;

var
  Running: Boolean;

begin
  InitializeSystem();
  
  Running := true;
  while Running do
  begin
    ProcessInput();
    UpdateGame();
    RenderFrame();
  end;
  
  CleanupSystem();
end.
```

### 8.3 Library Structure

```cpascal
library GameEngineLib;

import Core, Graphics;

public function CreateEngine(): Pointer; export;
begin
  Result := GetMem(SizeOf(TGameEngine));
  InitializeEngine(Result);
end;

public procedure DestroyEngine(const AEngine: Pointer); export;
begin
  CleanupEngine(AEngine);
  FreeMem(AEngine);
end;

exports
  CreateEngine,
  DestroyEngine;

end.
```

### 8.4 Import System

```cpascal
module Graphics;
import Math, Utilities;  // Imports public declarations

// Can use public types/functions from imported modules:
// Math.Sin(), Math.Cos(), Math.PI
// Utilities.LoadFile(), Utilities.TFileData
```

### 8.5 Visibility Rules

- **Default**: All declarations are private (module-internal)
- **Public**: Declarations marked `public` are visible to importing modules
- **Scope**: Public visibility applies to the entire declaration section

```cpascal
// Private section
const
  INTERNAL_BUFFER_SIZE = 1024;

// Public section  
public const
  MAX_VERTICES = 65536;
  MAX_TEXTURES = 256;

// Mixed section
var
  public GlobalRenderer: Pointer;
  InternalState: Int32;  // Still private
```

---

## 9. C ABI Compatibility

### 9.1 Binary Compatibility Guarantee

CPascal guarantees binary-level compatibility with C through exact type mapping, identical memory layouts, and compatible calling conventions.

### 9.2 Complete Type Mapping

| CPascal Type | C Equivalent | Size | Alignment | Notes |
|--------------|--------------|------|-----------|-------|
| `Int8` | `int8_t` | 1 | 1 | Signed 8-bit |
| `UInt8` | `uint8_t` | 1 | 1 | Unsigned 8-bit |
| `Int16` | `int16_t` | 2 | 2 | Signed 16-bit |
| `UInt16` | `uint16_t` | 2 | 2 | Unsigned 16-bit |
| `Int32` | `int32_t` | 4 | 4 | Signed 32-bit |
| `UInt32` | `uint32_t` | 4 | 4 | Unsigned 32-bit |
| `Int64` | `int64_t` | 8 | 8 | Signed 64-bit |
| `UInt64` | `uint64_t` | 8 | 8 | Unsigned 64-bit |
| `Single` | `float` | 4 | 4 | IEEE 754 single |
| `Double` | `double` | 8 | 8 | IEEE 754 double |
| `Boolean` | `bool` | 1 | 1 | C99 bool |
| `Char` | `char` | 1 | 1 | 8-bit character |
| `Pointer` | `void*` | 8/4 | 8/4 | Platform pointer |
| `NativeInt` | `intptr_t` | 8/4 | 8/4 | Platform signed |
| `NativeUInt` | `uintptr_t` | 8/4 | 8/4 | Platform unsigned |
| `PChar` | `char*` | 8/4 | 8/4 | String pointer |

**Platform Sizing:**
- 64-bit platforms: Pointers are 8 bytes, aligned to 8-byte boundaries
- 32-bit platforms: Pointers are 4 bytes, aligned to 4-byte boundaries

### 9.3 Function Compatibility

```cpascal
// CPascal function
function ProcessData(const AData: ^UInt8; const ASize: Int32): Boolean;

// Equivalent C function
bool ProcessData(const uint8_t* data, int32_t size);

// Binary compatible - can be called from C or vice versa
```

### 9.4 Structure Compatibility

```cpascal
// CPascal
type
  TPoint3D = packed record
    X, Y, Z: Single;
  end;

// C
struct Point3D {
    float x, y, z;
};

// Identical memory layout:
// - Size: 12 bytes
// - Alignment: 4 bytes
// - Field offsets: X=0, Y=4, Z=8
```

### 9.5 Array Compatibility

```cpascal
// CPascal
type
  TMatrix4x4 = array[0..3, 0..3] of Single;

// C
float matrix4x4[4][4];

// Identical memory layout:
// - Size: 64 bytes (4*4*4)
// - Row-major ordering
// - Compatible indexing
```

### 9.6 Function Pointer Compatibility

```cpascal
// CPascal
type
  TCallback = function(const AValue: Int32): Boolean; cdecl;

// C
typedef bool (*callback_t)(int32_t value);

// Binary compatible function pointers
```

---

## 10. External Interface

### 10.1 Linking C Libraries

#### 10.1.1 Library Path Configuration

```cpascal
libpath "/usr/local/lib";
libpath "C:\SDL2\lib\x64";
libpath "/opt/homebrew/lib";
```

#### 10.1.2 Library Linking

```cpascal
link SDL2;           // Links libSDL2.so, SDL2.lib, etc.
link OpenGL32;       // Platform-appropriate OpenGL library  
link "custom.a";     // Explicit library file
link pthread;        // POSIX threads
```

#### 10.1.3 External Function Declaration

```cpascal
// Basic external function
function malloc(const ASize: NativeUInt): Pointer; external;

// Function from specific library
function SDL_Init(const AFlags: UInt32): Int32; external "SDL2";

// Function with specific calling convention
function GetTickCount(): UInt32; stdcall; external "kernel32";

// Function with both library and calling convention
function DirectSound_Create(const ADevice: Pointer; out AInterface: Pointer): Int32; 
  stdcall; external "dsound.dll";
```

### 10.2 Exporting Functions

```cpascal
library MyLib;

// Function available to C code
public function Add(const A, B: Int32): Int32; export;
begin
  Result := A + B;
end;

// Function with calling convention
public function Win32Add(const A, B: Int32): Int32; stdcall; export;
begin
  Result := A + B;
end;

// Explicit export list
exports
  Add,
  Win32Add;

end.
```

### 10.3 Header Equivalence

CPascal external declarations should match C headers exactly:

```c
// C header
int SDL_Init(uint32_t flags);
void* malloc(size_t size);
DWORD GetTickCount(void);
```

```cpascal
// CPascal declarations
function SDL_Init(const AFlags: UInt32): Int32; external;
function malloc(const ASize: NativeUInt): Pointer; external;
function GetTickCount(): UInt32; stdcall; external;
```

### 10.4 Complex External Declarations

```cpascal
// OpenGL function pointers
type
  PFNGLGENBUFFERSPROC = function(const ACount: Int32; const ABuffers: ^UInt32): void; stdcall;

// Windows API structures
type
  TSystemTime = packed record
    Year: UInt16;
    Month: UInt16;
    DayOfWeek: UInt16;
    Day: UInt16;
    Hour: UInt16;
    Minute: UInt16;
    Second: UInt16;
    Milliseconds: UInt16;
  end;

// Complex function declarations
function CreateFileA(const AFileName: PChar; const AAccess, AShare, ASecurity, 
  ACreation, AFlags, ATemplate: UInt32): Pointer; stdcall; external "kernel32";
```

---

## 11. Compiler Directives

### 11.1 Conditional Compilation

```cpascal
{$IFDEF DEBUG}
{$DEFINE ENABLE_LOGGING}
{$DEFINE VERBOSE_OUTPUT}
{$ENDIF}

{$IFDEF WINDOWS}
link user32, kernel32, gdi32;
{$ELSE}
link X11, pthread, dl;
{$ENDIF}

{$IFNDEF DISABLE_GRAPHICS}
import Graphics, OpenGL;
{$ENDIF}

{$IFDEF RELEASE}
{$DEFINE OPTIMIZE_SIZE}
{$ELSE}
{$DEFINE DEBUG_CHECKS}
{$ENDIF}
```

### 11.2 Platform Detection

```cpascal
{$IFDEF WINDOWS}
  // Windows-specific code
  function GetCurrentDirectory(): PChar; stdcall; external "kernel32";
{$ENDIF}

{$IFDEF LINUX}  
  // Linux-specific code
  function getcwd(const ABuffer: PChar; const ASize: NativeUInt): PChar; external;
{$ENDIF}

{$IFDEF MACOS}
  // macOS-specific code
  function NSHomeDirectory(): Pointer; external;
{$ENDIF}

{$IFDEF X86_64}
  // 64-bit specific optimizations
{$ENDIF}

{$IFDEF ARM64}
  // ARM64 specific code
{$ENDIF}
```

### 11.3 Build Configuration Directives

```cpascal
// Linking directives
{$LINK SDL2}
{$LIBPATH /usr/local/lib}
{$LIBPATH C:\SDL2\lib\x64}

// Application type (Windows)
{$APPTYPE CONSOLE}    // Console application
{$APPTYPE GUI}        // GUI application  

// Module and object paths
{$MODULEPATH src\modules}
{$EXEPATH bin\release}
{$OBJPATH obj\release}

// Build optimization
{$IFDEF RELEASE}
{$DEFINE OPTIMIZE_SPEED}
{$ELSE}
{$DEFINE SAFE_CHECKS}
{$ENDIF}
```

### 11.4 Feature Toggles

```cpascal
{$IFDEF DEBUG}
procedure DebugLog(const AMessage: PChar);
begin
  printf("[DEBUG] %s\n", AMessage);
end;
{$ELSE}
procedure DebugLog(const AMessage: PChar);
begin
  // No-op in release builds
end;
{$ENDIF}

{$IFDEF ENABLE_PROFILING}
procedure StartProfiler(const ASection: PChar);
procedure EndProfiler();
{$ELSE}
procedure StartProfiler(const ASection: PChar); begin end;
procedure EndProfiler(); begin end;
{$ENDIF}
```

### 11.5 Advanced Conditional Blocks

```cpascal
{$IFDEF GRAPHICS_ENABLED}
  {$IFDEF OPENGL_SUPPORT}
    import OpenGL;
    {$DEFINE HAS_MODERN_GRAPHICS}
  {$ELSE}
    {$IFDEF DIRECTX_SUPPORT}
      import DirectX;
      {$DEFINE HAS_MODERN_GRAPHICS}
    {$ELSE}
      import SoftwareRenderer;
      {$UNDEF HAS_MODERN_GRAPHICS}
    {$ENDIF}
  {$ENDIF}
{$ELSE}
  // Text-only mode
  {$UNDEF HAS_MODERN_GRAPHICS}
{$ENDIF}
```

---

## 12. File Conventions

### 12.1 Source Files

- **Extension**: `.cpas`
- **Encoding**: UTF-8
- **Line Endings**: Any (LF, CRLF, CR)

### 12.2 File Organization

```
project/
├── src/
│   ├── main.cpas         // Program entry point
│   ├── graphics.cpas     // Graphics module
│   ├── audio.cpas        // Audio module
│   ├── math.cpas         // Math utilities
│   └── platform/
│       ├── windows.cpas  // Platform-specific code
│       ├── linux.cpas
│       └── macos.cpas
├── lib/
│   ├── SDL2.lib         // External libraries
│   ├── OpenGL32.lib
│   └── static/          // Static libraries
│       └── custom.a
├── include/             // C header equivalents
│   ├── SDL2.h
│   └── opengl.h
└── build/
    ├── obj/             // Compiled object files
    │   ├── main.o
    │   └── graphics.o
    ├── lib/             // Intermediate libraries
    └── bin/             // Final executables
        └── game.exe
```

### 12.3 Naming Conventions

#### 12.3.1 Modules
- Use PascalCase: `Graphics`, `AudioEngine`, `NetworkManager`
- Match filename: `graphics.cpas` contains `module Graphics`

#### 12.3.2 Types
- Use TPascalCase: `TVector3`, `TGameState`, `TRenderMode`
- Pointer types: `PVector3`, `PGameState`
- Enum values: PascalCase without prefix

#### 12.3.3 Functions
- Use PascalCase: `InitializeGraphics`, `ProcessInput`
- Parameters use APascalCase: `AWidth`, `AHeight`, `ACallback`

#### 12.3.4 Variables
- Local variables use PascalCase: `Index`, `Buffer`, `Result`
- Global variables use GPascalCase: `GRenderer`, `GGameState`

#### 12.3.5 Constants
- Use UPPER_CASE: `MAX_BUFFER_SIZE`, `DEFAULT_TIMEOUT`
- Or PascalCase for complex constants: `DefaultSettings`

---

## 13. Standard Library

### 13.1 Built-in Functions

#### 13.1.1 Memory Management

```cpascal
function GetMem(const ASize: NativeUInt): Pointer;
// Allocates memory block of specified size

procedure FreeMem(const APtr: Pointer);
// Frees previously allocated memory

function SizeOf(ATypeOrVariable): NativeUInt;
// Returns size of type or variable at compile time

function TypeOf(AExpression): TypeInfo;
// Returns type information for expression
```

#### 13.1.2 Arithmetic

```cpascal
procedure Inc(var AVariable);
procedure Inc(var AVariable; const AIncrement);
// Increment variable by 1 or specified amount

procedure Dec(var AVariable);
procedure Dec(var AVariable; const ADecrement);
// Decrement variable by 1 or specified amount
```

#### 13.1.3 Type Information

```cpascal
function SizeOf(const AType): NativeUInt;  // Compile-time size
function Ord(const AValue): Int32;         // Ordinal value
function Chr(const AValue: Int32): Char;   // Character from ordinal
```

### 13.2 Standard Types

```cpascal
// Always available without imports
type
  Int8 = // 8-bit signed integer
  UInt8 = // 8-bit unsigned integer
  Int16 = // 16-bit signed integer
  UInt16 = // 16-bit unsigned integer
  Int32 = // 32-bit signed integer
  UInt32 = // 32-bit unsigned integer
  Int64 = // 64-bit signed integer
  UInt64 = // 64-bit unsigned integer
  Single = // 32-bit floating point
  Double = // 64-bit floating point
  Boolean = // Boolean type
  Char = // 8-bit character
  Pointer = // Generic pointer
  NativeInt = // Platform-sized signed integer
  NativeUInt = // Platform-sized unsigned integer
  PChar = // Null-terminated string pointer
```

### 13.3 Memory Management Examples

```cpascal
var
  Buffer: ^UInt8;
  Size: NativeUInt;
  
begin
  Size := 1024;
  Buffer := GetMem(Size);
  
  if Buffer <> nil then
  begin
    // Use buffer
    ProcessData(Buffer, Size);
    
    // Free when done
    FreeMem(Buffer);
    Buffer := nil;
  end;
end;
```

### 13.4 Built-in Constants

```cpascal
const
  // Boolean values
  true = Boolean(1);
  false = Boolean(0);
  
  // Null pointer
  nil = Pointer(0);
  
  // Platform-specific sizes
  POINTER_SIZE = SizeOf(Pointer);
  NATIVE_INT_SIZE = SizeOf(NativeInt);
```

---

## 14. Formal Grammar

The complete BNF grammar for CPascal is defined in the CPascal Grammar Specification (BNF.md). Key productions include:

### 14.1 Program Structure

```bnf
<compilation_unit> ::= <program> | <library> | <module>

<program> ::= <comment>* <compiler_directive>* <program_header> 
              <import_clause>? <declarations> <compound_statement> "."

<library> ::= <comment>* <compiler_directive>* <library_header> 
              <import_clause>? <declarations> <exports_clause>? "."

<module> ::= <comment>* <compiler_directive>* <module_header> 
             <import_clause>? <declarations> "."
```

### 14.2 Type System

```bnf
<type_definition> ::= <simple_type> | <pointer_type> | <array_type> 
                    | <record_type> | <union_type> | <function_type> 
                    | <enum_type>

<function_type> ::= "function" "(" <parameter_type_list>? ")" ":" <type_definition> <calling_convention>?
                  | "procedure" "(" <parameter_type_list>? ")" <calling_convention>?
```

### 14.3 Expressions

```bnf
<expression> ::= <ternary_expression>

<ternary_expression> ::= <logical_or_expression> ("?" <expression> ":" <ternary_expression>)?

<assignment_statement> ::= <variable_list> ":=" <expression_list>
                         | <variable> "+=" <expression>
                         | <variable> "-=" <expression>
                         | <variable> "*=" <expression>
                         | <variable> "/=" <expression>
                         | <variable> "and=" <expression>
                         | <variable> "or=" <expression>
                         | <variable> "xor=" <expression>
                         | <variable> "shl=" <expression>
                         | <variable> "shr=" <expression>
```

### 14.4 Statements

```bnf
<statement> ::= <simple_statement> | <structured_statement>

<simple_statement> ::= <assignment_statement> | <procedure_call> | <goto_statement> 
                     | <label_statement> | <empty_statement> | <inline_assembly> 
                     | <break_statement> | <continue_statement> | <exit_statement>

<inline_assembly> ::= "asm" <assembly_block> "end"
```

**Note**: The complete formal grammar is available in the BNF.md document, which provides the authoritative syntactic specification for all CPascal constructs.

---

## 15. Examples

### 15.1 Hello World

```cpascal
program HelloWorld;

function printf(const AFormat: PChar, ...): Int32; external;

begin
  printf("Hello, World!\n");
end.
```

### 15.2 Advanced Graphics Application

```cpascal
program GraphicsDemo;

import Graphics, Math;
libpath "/usr/local/lib";
link SDL2, OpenGL32;

// External SDL2 functions
function SDL_Init(const AFlags: UInt32): Int32; external "SDL2";
function SDL_CreateWindow(const ATitle: PChar; const AX, AY, AW, AH, AFlags: Int32): Pointer; external "SDL2";
function SDL_GL_CreateContext(const AWindow: Pointer): Pointer; external "SDL2";
function SDL_GL_SwapWindow(const AWindow: Pointer): void; external "SDL2";
function SDL_PollEvent(const AEvent: ^TSDL_Event): Int32; external "SDL2";
procedure SDL_DestroyWindow(const AWindow: Pointer); external "SDL2";
procedure SDL_Quit(); external "SDL2";

// OpenGL functions
procedure glClear(const AMask: UInt32); external "OpenGL32";
procedure glClearColor(const AR, AG, AB, AA: Single); external "OpenGL32";

type
  TSDL_Event = packed record
    EventType: UInt32;
    // Simplified - real structure is much larger
    Padding: array[0..55] of UInt8;
  end;

const
  SDL_INIT_VIDEO = $00000020;
  SDL_WINDOW_OPENGL = $00000002;
  SDL_QUIT = $100;
  GL_COLOR_BUFFER_BIT = $00004000;

var
  Window: Pointer;
  Context: Pointer;
  Event: TSDL_Event;
  Running: Boolean;
  FrameCount: Int32;
  
function InitializeGraphics(): Boolean;
begin
  if SDL_Init(SDL_INIT_VIDEO) <> 0 then
    exit(false);
    
  Window := SDL_CreateWindow("CPascal OpenGL Demo", 
    100, 100, 800, 600, SDL_WINDOW_OPENGL);
    
  if Window = nil then
  begin
    SDL_Quit();
    exit(false);
  end;
  
  Context := SDL_GL_CreateContext(Window);
  if Context = nil then
  begin
    SDL_DestroyWindow(Window);
    SDL_Quit();
    exit(false);
  end;
  
  Result := true;
end;

procedure UpdateFrame();
var
  Red, Green, Blue: Single;
begin
  // Animated colors using ternary operator
  Red := (FrameCount mod 120 < 60) ? 1.0 : 0.0;
  Green := (FrameCount mod 180 < 90) ? 1.0 : 0.0;
  Blue := (FrameCount mod 240 < 120) ? 1.0 : 0.0;
  
  glClearColor(Red, Green, Blue, 1.0);
  glClear(GL_COLOR_BUFFER_BIT);
  
  SDL_GL_SwapWindow(Window);
  FrameCount++;
end;

procedure CleanupGraphics();
begin
  if Context <> nil then
    SDL_GL_DeleteContext(Context);
  if Window <> nil then
    SDL_DestroyWindow(Window);
  SDL_Quit();
end;

begin
  if not InitializeGraphics() then
    exit;
    
  Running := true;
  FrameCount := 0;
  
  while Running do
  begin
    while SDL_PollEvent(@Event) <> 0 do
    begin
      if Event.EventType = SDL_QUIT then
        Running := false;
    end;
    
    UpdateFrame();
    
    // Break after 300 frames for demo
    if FrameCount > 300 then
      break;
  end;
  
  CleanupGraphics();
end.
```

### 15.3 Module with Inline Assembly

```cpascal
module PlatformUtils;

public type
  TCPUInfo = packed record
    Vendor: array[0..12] of Char;
    Features: UInt32;
    ModelName: array[0..48] of Char;
  end;

// Get CPU vendor string using inline assembly
public function GetCPUVendor(): array[0..12] of Char;
var
  Result: array[0..12] of Char;
  EBX, ECX, EDX: UInt32;
begin
  asm
    "mov $0, %%eax"
    "cpuid"
    "mov %%ebx, %0"
    "mov %%ecx, %1" 
    "mov %%edx, %2"
    : "=m" (EBX), "=m" (ECX), "=m" (EDX)
    :
    : "eax", "ebx", "ecx", "edx"
  end;
  
  // Copy vendor string
  GetMem(@Result[0], 13);
  @Result[0] := EBX;
  @Result[4] := EDX;
  @Result[8] := ECX;
  Result[12] := #0;
end;

// Atomic operations using inline assembly
public function AtomicCompareExchange(const ADestination: ^Int32; 
  const AComparand, AExchange: Int32): Int32;
begin
  asm
    "lock cmpxchgl %2, %1"
    : "=a" (Result), "+m" (*ADestination)
    : "r" (AExchange), "0" (AComparand)
    : "memory"
  end;
end;

// Memory barrier
public procedure MemoryBarrier();
begin
  asm
    "mfence"
    :
    :
    : "memory"
  end;
end;

// High-precision timer
public function GetHighPrecisionTimer(): UInt64;
var
  Low, High: UInt32;
begin
  asm
    "rdtsc"
    "mov %%eax, %0"
    "mov %%edx, %1"
    : "=m" (Low), "=m" (High)
    :
    : "eax", "edx"
  end;
  
  Result := (UInt64(High) shl 32) or UInt64(Low);
end;

end.
```

### 15.4 Complex Data Structures

```cpascal
module DataStructures;

public type
  // Generic node structure
  TNode = packed record
    Data: Pointer;
    Next: ^TNode;
    Prev: ^TNode;
  end;
  PNode = ^TNode;
  
  // Hash table entry
  THashEntry = packed record
    Key: UInt32;
    Value: Pointer;
    Next: ^THashEntry;
  end;
  
  // Hash table
  THashTable = packed record
    Buckets: ^PHashEntry;
    BucketCount: UInt32;
    ItemCount: UInt32;
  end;
  PHashEntry = ^THashEntry;
  PHashTable = ^THashTable;

// Hash function
function Hash(const AKey: UInt32; const ABuckets: UInt32): UInt32;
begin
  Result := AKey mod ABuckets;
end;

// Create hash table
public function CreateHashTable(const ABucketCount: UInt32): PHashTable;
var
  Table: PHashTable;
  I: UInt32;
begin
  Table := GetMem(SizeOf(THashTable));
  if Table = nil then
    exit(nil);
    
  Table^.BucketCount := ABucketCount;
  Table^.ItemCount := 0;
  Table^.Buckets := GetMem(ABucketCount * SizeOf(PHashEntry));
  
  if Table^.Buckets = nil then
  begin
    FreeMem(Table);
    exit(nil);
  end;
  
  // Initialize buckets to nil
  for I := 0 to ABucketCount - 1 do
    Table^.Buckets[I] := nil;
    
  Result := Table;
end;

// Insert into hash table
public function HashTableInsert(const ATable: PHashTable; 
  const AKey: UInt32; const AValue: Pointer): Boolean;
var
  BucketIndex: UInt32;
  Entry: PHashEntry;
begin
  if ATable = nil then
    exit(false);
    
  BucketIndex := Hash(AKey, ATable^.BucketCount);
  
  // Check if key already exists
  Entry := ATable^.Buckets[BucketIndex];
  while Entry <> nil do
  begin
    if Entry^.Key = AKey then
    begin
      Entry^.Value := AValue;  // Update existing
      exit(true);
    end;
    Entry := Entry^.Next;
  end;
  
  // Create new entry
  Entry := GetMem(SizeOf(THashEntry));
  if Entry = nil then
    exit(false);
    
  Entry^.Key := AKey;
  Entry^.Value := AValue;
  Entry^.Next := ATable^.Buckets[BucketIndex];
  ATable^.Buckets[BucketIndex] := Entry;
  
  ATable^.ItemCount++;
  Result := true;
end;

// Find in hash table
public function HashTableFind(const ATable: PHashTable; 
  const AKey: UInt32): Pointer;
var
  BucketIndex: UInt32;
  Entry: PHashEntry;
begin
  if ATable = nil then
    exit(nil);
    
  BucketIndex := Hash(AKey, ATable^.BucketCount);
  Entry := ATable^.Buckets[BucketIndex];
  
  while Entry <> nil do
  begin
    if Entry^.Key = AKey then
      exit(Entry^.Value);
    Entry := Entry^.Next;
  end;
  
  Result := nil;
end;

end.
```

### 15.5 Variadic Function Usage

```cpascal
module Logging;

// External C functions
function printf(const AFormat: PChar, ...): Int32; external;
function sprintf(const ABuffer: PChar; const AFormat: PChar, ...): Int32; external;
function vprintf(const AFormat: PChar; const AArgs: Pointer): Int32; external;

public type
  TLogLevel = (LogDebug, LogInfo, LogWarning, LogError);

// Custom logging function
public procedure Log(const ALevel: TLogLevel; const AFormat: PChar, ...);
var
  Prefix: PChar;
  Buffer: array[0..1023] of Char;
  Timestamp: array[0..31] of Char;
begin
  // Get timestamp (simplified)
  sprintf(@Timestamp[0], "[%08X]", GetTickCount());
  
  case ALevel of
    LogDebug: Prefix := "DEBUG";
    LogInfo: Prefix := "INFO";
    LogWarning: Prefix := "WARN";
    LogError: Prefix := "ERROR";
  else
    Prefix := "UNKNOWN";
  end;
  
  // Format the message
  sprintf(@Buffer[0], "%s %s: ", @Timestamp[0], Prefix);
  
  // This would require va_list handling in real implementation
  // For now, just print the format string
  printf("%s%s\n", @Buffer[0], AFormat);
end;

// Usage examples
public procedure TestLogging();
begin
  Log(LogInfo, "System initialized");
  Log(LogWarning, "Low memory warning: %d bytes free", 1024);
  Log(LogError, "Failed to open file: %s", "config.ini");
end;

end.
```

---

## Appendix A: C Compatibility Matrix

| Feature | CPascal | C | Compatible |
|---------|---------|---|------------|
| Function calls | Standard | Standard | ✓ |
| Data structures | `packed record` | `struct` | ✓ |
| Arrays | `array[0..N]` | `type[N+1]` | ✓ |
| Pointers | `^Type` | `Type*` | ✓ |
| Function pointers | `function(): Type` | `Type (*)()` | ✓ |
| Unions | `union` | `union` | ✓ |
| Enums | `(A, B, C)` | `enum {A, B, C}` | ✓ |
| Calling conventions | `cdecl`, `stdcall` | Same | ✓ |
| Memory layout | Identical | Identical | ✓ |
| Inline assembly | Extended syntax | GCC extended | ✓ |
| Variadic functions | `...` syntax | `...` syntax | ✓ |
| Atomic operations | Inline assembly | Inline assembly | ✓ |

---

## Appendix B: Migration from C

### B.1 Type Mapping

```c
// C code
int32_t count;
float* buffer;
struct Point { int x, y; };
union Value { int i; float f; };
bool (*callback)(int value);

// CPascal equivalent
var
  Count: Int32;
  Buffer: ^Single;
  
type
  TPoint = packed record
    X, Y: Int32;
  end;
  
  TValue = union
    I: Int32;
    F: Single;
  end;
  
  TCallback = function(const AValue: Int32): Boolean;
```

### B.2 Function Translation

```c
// C function
int process_data(const uint8_t* data, size_t size) {
    for (size_t i = 0; i < size; i++) {
        data[i] *= 2;
    }
    return size;
}

// CPascal equivalent
function ProcessData(const AData: ^UInt8; const ASize: NativeUInt): Int32;
var
  Index: NativeUInt;
begin
  for Index := 0 to ASize - 1 do
    AData[Index] *= 2;  // Compound assignment
  Result := ASize;
end;
```

### B.3 Inline Assembly Translation

```c
// C inline assembly (GCC)
static inline uint64_t rdtsc(void) {
    uint32_t low, high;
    asm volatile ("rdtsc" : "=a" (low), "=d" (high));
    return ((uint64_t)high << 32) | low;
}

// CPascal equivalent
function RDTSC(): UInt64; inline;
var
  Low, High: UInt32;
begin
  asm
    "rdtsc"
    : "=a" (Low), "=d" (High)
    :
    :
  end;
  Result := (UInt64(High) shl 32) or UInt64(Low);
end;
```

### B.4 Memory Management Translation

```c
// C code
void* buffer = malloc(1024);
if (buffer != NULL) {
    memset(buffer, 0, 1024);
    process_buffer(buffer, 1024);
    free(buffer);
}

// CPascal equivalent
var
  Buffer: Pointer;
  Size: NativeUInt;
begin
  Size := 1024;
  Buffer := GetMem(Size);
  if Buffer <> nil then
  begin
    FillChar(Buffer^, Size, 0);  // or use memset external
    ProcessBuffer(Buffer, Size);
    FreeMem(Buffer);
  end;
end;
```

### B.5 Complex Structure Translation

```c
// C structure with bitfields and unions
struct packet_header {
    union {
        uint32_t flags;
        struct {
            unsigned type : 8;
            unsigned version : 4;  
            unsigned reserved : 20;
        };
    };
    uint32_t length;
    uint8_t data[];
};

// CPascal equivalent
type
  TPacketHeader = packed record
    case Boolean of
      true: (Flags: UInt32);
      false: (
        TypeAndVersion: UInt16;  // Combine type and version
        Reserved: UInt16;
      );
    Length: UInt32;
    // Variable length data would be handled separately
  end;

// Bitfield access functions
function GetPacketType(const AHeader: ^TPacketHeader): UInt8;
begin
  Result := AHeader^.TypeAndVersion and $FF;
end;

function GetPacketVersion(const AHeader: ^TPacketHeader): UInt8;
begin
  Result := (AHeader^.TypeAndVersion shr 8) and $0F;
end;
```

---

## Appendix C: Compiler Implementation Notes

### C.1 LLVM Target

CPascal compilers should target LLVM IR for optimal code generation and platform support. Key considerations:

- Use LLVM's C ABI support for calling conventions
- Leverage LLVM's optimization passes
- Maintain debug information compatibility with C debuggers
- Support for inline assembly through LLVM's extended assembly syntax

### C.2 Name Mangling

CPascal uses minimal name mangling to maintain C compatibility:

```cpascal
function MyFunction(): Int32; external;
// Generates symbol: MyFunction (no mangling for external)

function MyFunction(): Int32;  // Internal function
// May generate: MyFunction or _MyFunction depending on platform
```

### C.3 Runtime Requirements

CPascal requires minimal runtime support:
- Standard C library for memory allocation (`malloc`/`free` or `GetMem`/`FreeMem`)
- Platform-specific system calls
- No garbage collection or exception handling runtime
- Optional runtime type information for debugging

### C.4 Optimization Considerations

- Inline functions should be aggressively inlined
- Constant folding for compile-time expressions
- Dead code elimination for conditional compilation blocks
- Register allocation for local variables
- Tail call optimization for recursive functions

---

**End of Specification**

*CPascal Language Specification v1.0*  
*This document defines the complete CPascal programming language with full C ABI compatibility.*