# CPascal API Reference
**Version 1.0**

## Table of Contents

1. [Introduction](#introduction)
2. [Built-in Functions](#built-in-functions)
3. [Built-in Variables](#built-in-variables)
4. [Standard Types](#standard-types)
5. [Operators](#operators)
6. [Calling Conventions](#calling-conventions)
7. [Language Constants](#language-constants)

---

## 1. Introduction

This document provides the complete API reference for CPascal's built-in functions, types, and language constructs as defined in the BNF grammar. CPascal maintains full C ABI compatibility.

### 1.1 Built-in Language Elements

CPascal defines exactly five built-in functions:

- `SizeOf` - Returns size of type or variable
- `GetMem` - Allocates memory
- `FreeMem` - Deallocates memory  
- `Inc` - Increments a variable
- `Dec` - Decrements a variable

Plus one built-in variable:
- `Result` - Function return value

---

## 2. Built-in Functions

### 2.1 SizeOf

```cpascal
function SizeOf(const ATypeOrVariable): NativeUInt;
```

**Description**: Returns the size in bytes of a type or variable at compile time.

**Parameters**:
- `ATypeOrVariable`: Type name or variable identifier

**Returns**: Size in bytes as compile-time constant

**Examples**:
```cpascal
var
  Value: Int32;
  Size1, Size2: NativeUInt;
begin
  Size1 := SizeOf(Int32);     // 4
  Size2 := SizeOf(Value);     // 4
end;
```

### 2.2 GetMem

```cpascal
function GetMem(const ASize: NativeUInt): Pointer;
```

**Description**: Allocates a block of memory of the specified size.

**Parameters**:
- `ASize`: Size in bytes to allocate

**Returns**: Pointer to allocated memory, or `nil` if allocation fails

**Example**:
```cpascal
var
  Buffer: Pointer;
begin
  Buffer := GetMem(1024);
  if Buffer <> nil then
  begin
    FreeMem(Buffer);
  end;
end;
```

### 2.3 FreeMem

```cpascal
procedure FreeMem(const APtr: Pointer);
```

**Description**: Deallocates a memory block previously allocated with GetMem.

**Parameters**:
- `APtr`: Pointer to memory block to deallocate

**Example**:
```cpascal
var
  Data: Pointer;
begin
  Data := GetMem(512);
  if Data <> nil then
  begin
    FreeMem(Data);
  end;
end;
```

### 2.4 Inc

```cpascal
procedure Inc(var AVariable);
procedure Inc(var AVariable; const AIncrement);
```

**Description**: Increments a variable by 1 or by a specified amount.

**Parameters**:
- `AVariable`: Variable to increment (passed by reference)
- `AIncrement`: Amount to increment by (optional, default: 1)

**Examples**:
```cpascal
var
  Counter: Int32;
begin
  Counter := 10;
  Inc(Counter);        // Counter = 11
  Inc(Counter, 5);     // Counter = 16
end;
```

### 2.5 Dec

```cpascal
procedure Dec(var AVariable);
procedure Dec(var AVariable; const ADecrement);
```

**Description**: Decrements a variable by 1 or by a specified amount.

**Parameters**:
- `AVariable`: Variable to decrement (passed by reference)
- `ADecrement`: Amount to decrement by (optional, default: 1)

**Examples**:
```cpascal
var
  Counter: Int32;
begin
  Counter := 20;
  Dec(Counter);        // Counter = 19
  Dec(Counter, 3);     // Counter = 16
end;
```

---

## 3. Built-in Variables

### 3.1 Result

```cpascal
var Result: <function_return_type>;
```

**Description**: Implicit variable available in all functions (not procedures) that holds the function's return value.

**Type**: Same as the function's declared return type

**Scope**: Local to each function

**Usage**:
```cpascal
function Add(const A, B: Int32): Int32;
begin
  Result := A + B;
end;

function IsPositive(const AValue: Int32): Boolean;
begin
  Result := AValue > 0;
end;
```

---

## 4. Standard Types

### 4.1 C ABI Compatible Types

All CPascal types map directly to C types with identical size, alignment, and representation:

| CPascal Type | C Equivalent | Size (bytes) | Alignment | Range/Notes |
|--------------|--------------|--------------|-----------|-------------|
| `Int8` | `int8_t` | 1 | 1 | -128 to 127 |
| `UInt8` | `uint8_t` | 1 | 1 | 0 to 255 |
| `Int16` | `int16_t` | 2 | 2 | -32,768 to 32,767 |
| `UInt16` | `uint16_t` | 2 | 2 | 0 to 65,535 |
| `Int32` | `int32_t` | 4 | 4 | -2³¹ to 2³¹-1 |
| `UInt32` | `uint32_t` | 4 | 4 | 0 to 2³²-1 |
| `Int64` | `int64_t` | 8 | 8 | -2⁶³ to 2⁶³-1 |
| `UInt64` | `uint64_t` | 8 | 8 | 0 to 2⁶⁴-1 |
| `Single` | `float` | 4 | 4 | IEEE 754 single |
| `Double` | `double` | 8 | 8 | IEEE 754 double |
| `Boolean` | `bool` | 1 | 1 | true/false |
| `Char` | `char` | 1 | 1 | 0 to 255 |
| `Pointer` | `void*` | 8/4 | 8/4 | Platform dependent |
| `NativeInt` | `intptr_t` | 8/4 | 8/4 | Platform dependent |
| `NativeUInt` | `uintptr_t` | 8/4 | 8/4 | Platform dependent |
| `PChar` | `char*` | 8/4 | 8/4 | Platform dependent |

---

## 5. Operators

### 5.1 Equality Operators

```cpascal
=    // Equal
<>   // Not equal
```

### 5.2 Relational Operators

```cpascal
<    // Less than
<=   // Less than or equal
>    // Greater than
>=   // Greater than or equal
```

### 5.3 Shift Operators

```cpascal
shl  // Shift left
shr  // Shift right
```

### 5.4 Adding Operators

```cpascal
+    // Addition
-    // Subtraction
```

### 5.5 Multiplying Operators

```cpascal
*    // Multiplication
/    // Division
div  // Integer division
mod  // Modulo
```

### 5.6 Prefix Operators

```cpascal
+    // Unary plus
-    // Unary minus
not  // Logical/bitwise NOT
++   // Prefix increment
--   // Prefix decrement
@    // Address-of
*    // Dereference
```

### 5.7 Postfix Operators

```cpascal
++   // Postfix increment
--   // Postfix decrement
```

---

## 6. Calling Conventions

### 6.1 Supported Conventions

CPascal supports the following calling conventions for external function declarations:

#### 6.1.1 cdecl

```cpascal
function MyFunction(const A: Int32): Int32; cdecl;
```

- Default for C functions
- Parameters pushed right to left
- Caller cleans up stack

#### 6.1.2 stdcall

```cpascal
function MyFunction(const A: Int32): Int32; stdcall;
```

- Windows API standard
- Parameters pushed right to left
- Callee cleans up stack

#### 6.1.3 fastcall

```cpascal
function MyFunction(const A, B: Int32): Int32; fastcall;
```

- Register-based parameter passing
- Platform-specific implementation

#### 6.1.4 register

```cpascal
function MyFunction(const A: Int32): Int32; register;
```

- Compiler-optimized calling convention
- Platform-specific implementation

---

## 7. Language Constants

### 7.1 Boolean Constants

```cpascal
true   // Boolean true value
false  // Boolean false value
```

### 7.2 Pointer Constants

```cpascal
nil    // Null pointer constant
```

**Usage Examples**:
```cpascal
var
  Ptr: Pointer;
  Success: Boolean;
begin
  Ptr := GetMem(1024);
  Success := Ptr <> nil;
  
  if Success then
  begin
    FreeMem(Ptr);
    Ptr := nil;
  end;
end;
```

---

**End of CPascal API Reference**

*This document covers only the built-in functions, types, and language constructs explicitly defined in the CPascal BNF grammar.*