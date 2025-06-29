# CPascal Migration Guide: From C to CPascal
**Complete Practitioner's Guide for C Developers**

## Table of Contents

1. [Strategic Overview](#1-strategic-overview)
2. [Quick Start Migration](#2-quick-start-migration)
3. [Comprehensive Syntax Translation](#3-comprehensive-syntax-translation)
4. [Type System Deep Dive](#4-type-system-deep-dive)
5. [Real-World Migration Examples](#5-real-world-migration-examples)
6. [Advanced Topics](#6-advanced-topics)
7. [Tooling and Workflow](#7-tooling-and-workflow)
8. [Performance Considerations](#8-performance-considerations)
9. [Integration Strategies](#9-integration-strategies)
10. [Troubleshooting Guide](#10-troubleshooting-guide)

---

## 1. Strategic Overview

### 1.1 Why Migrate to CPascal?

**CPascal provides C's power with Pascal's clarity:**

| Benefit | Description | Impact |
|---------|-------------|--------|
| **Readability** | Pascal syntax is more verbose but clearer | Faster code reviews, easier maintenance |
| **Type Safety** | Stricter type checking than C | Fewer runtime errors, better compile-time validation |
| **Modern Features** | Multiple assignment, ternary operators, inline assembly | More expressive code |
| **C Compatibility** | 100% C ABI compatibility | Zero-cost interop, gradual migration |
| **Module System** | Clean imports without preprocessor | Better dependency management |

### 1.2 Migration Strategies

#### 1.2.1 Incremental Migration (Recommended)

```c
// Existing C codebase
graphics.c      ← Keep as-is initially
audio.c         ← Keep as-is initially  
main.c          ← Migrate first to CPascal
utils.c         ← Migrate second
```

**Benefits:**
- Lower risk
- Immediate productivity
- Learn CPascal gradually
- Maintain existing functionality

#### 1.2.2 Complete Rewrite

**When to consider:**
- Small codebase (< 10k lines)
- Major refactoring needed anyway
- Clean slate requirements
- Learning/training project

#### 1.2.3 Hybrid Approach

**Best for:**
- Large codebases
- Performance-critical sections
- Legacy code with unclear behavior

```cpascal
// main.cpas - New CPascal code
program ModernApp;

// Link existing C libraries
function legacy_process_data(const AData: Pointer; const ASize: Int32): Int32; external "legacy.a";
function legacy_init(): Boolean; external "legacy.a";

var
  LData: ^UInt8;
  LResult: Int32;
  
begin
  if not legacy_init() then
    exit;
    
  // New CPascal code calling legacy C
  LData := GetMem(1024);
  LResult := legacy_process_data(LData, 1024);
  FreeMem(LData);
end.
```

### 1.3 Risk Assessment

#### 1.3.1 Low Risk Areas
- Pure computational code
- Data structure definitions
- Simple algorithms
- Utility functions

#### 1.3.2 Medium Risk Areas
- Complex pointer arithmetic
- Platform-specific code
- Performance-critical loops
- External library interfaces

#### 1.3.3 High Risk Areas
- Inline assembly
- Signal handlers
- Interrupt service routines
- Memory-mapped I/O

---

## 2. Quick Start Migration

### 2.1 Hello World Comparison

```c
// hello.c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

```cpascal
// hello.cpas
program Hello;

function printf(const AFormat: PChar, ...): Int32; external;

begin
  printf("Hello, World!\n");
end.
```

### 2.2 Basic Function Migration

```c
// C version
int add(int a, int b) {
    return a + b;
}

void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}
```

```cpascal
// CPascal version
function Add(const A, B: Int32): Int32;
begin
  Result := A + B;
end;

procedure Swap(var A, B: Int32);
var
  LTemp: Int32;
begin
  LTemp := A;
  A := B;
  B := LTemp;
end;
```

### 2.3 Structure Migration

```c
// C struct
typedef struct {
    float x, y, z;
    int id;
} Point3D;

Point3D create_point(float x, float y, float z) {
    Point3D p = {x, y, z, 0};
    return p;
}
```

```cpascal
// CPascal record
type
  TPoint3D = packed record
    X, Y, Z: Single;
    ID: Int32;
  end;

function CreatePoint(const AX, AY, AZ: Single): TPoint3D;
begin
  Result.X := AX;
  Result.Y := AY;
  Result.Z := AZ;
  Result.ID := 0;
end;
```

---

## 3. Comprehensive Syntax Translation

### 3.1 Variable Declarations

| C | CPascal | Notes |
|---|---------|-------|
| `int x;` | `var X: Int32;` | Explicit type required |
| `int x = 42;` | `var X: Int32 = 42;` | or in const section |
| `const int x = 42;` | `const X = 42;` | Type inferred |
| `static int x;` | `var X: Int32;` | Static nature handled by module system |
| `extern int x;` | `var X: Int32; external;` | External declaration |
| `volatile int x;` | `var X: volatile Int32;` | Direct equivalent |

### 3.2 Control Flow Translation

#### 3.2.1 Conditional Statements

```c
// C if-else
if (condition) {
    statement1();
} else if (condition2) {
    statement2();
} else {
    statement3();
}
```

```cpascal
// CPascal if-else
if Condition then
begin
  Statement1();
end
else if Condition2 then
begin
  Statement2();
end
else
begin
  Statement3();
end;
```

#### 3.2.2 Switch vs Case

```c
// C switch
switch (value) {
    case 1:
        handle_one();
        break;
    case 2:
    case 3:
        handle_two_or_three();
        break;
    default:
        handle_default();
        break;
}
```

```cpascal
// CPascal case
case Value of
  1: HandleOne();
  2, 3: HandleTwoOrThree();
else
  HandleDefault();
end;
```

#### 3.2.3 Loop Translation

```c
// C for loop
for (int i = 0; i < 10; i++) {
    process(i);
}

// C while loop
int i = 0;
while (i < 10) {
    process(i);
    i++;
}

// C do-while
int i = 0;
do {
    process(i);
    i++;
} while (i < 10);
```

```cpascal
// CPascal for loop
var
  I: Int32;
begin
  for I := 0 to 9 do
    Process(I);
end;

// CPascal while loop
var
  I: Int32;
begin
  I := 0;
  while I < 10 do
  begin
    Process(I);
    Inc(I);
  end;
end;

// CPascal repeat-until
var
  I: Int32;
begin
  I := 0;
  repeat
    Process(I);
    Inc(I);
  until I >= 10;
end;
```

### 3.3 Operator Translation

#### 3.3.1 Arithmetic Operators

| C | CPascal | Notes |
|---|---------|-------|
| `a + b` | `A + B` | Same |
| `a - b` | `A - B` | Same |
| `a * b` | `A * B` | Same |
| `a / b` | `A / B` | Floating division |
| `a / b` | `A div B` | Integer division |
| `a % b` | `A mod B` | Modulo |
| `++a` | `Inc(A)` | Prefix increment |
| `a++` | `A++` | Postfix increment (if supported) |
| `a += b` | `A += B` | Compound assignment |

#### 3.3.2 Bitwise Operators

| C | CPascal | Notes |
|---|---------|-------|
| `a & b` | `A and B` | Bitwise AND |
| `a \| b` | `A or B` | Bitwise OR |
| `a ^ b` | `A xor B` | Bitwise XOR |
| `~a` | `not A` | Bitwise NOT |
| `a << b` | `A shl B` | Shift left |
| `a >> b` | `A shr B` | Shift right |

#### 3.3.3 Comparison Operators

| C | CPascal | Notes |
|---|---------|-------|
| `a == b` | `A = B` | Equality |
| `a != b` | `A <> B` | Inequality |
| `a < b` | `A < B` | Same |
| `a <= b` | `A <= B` | Same |
| `a > b` | `A > B` | Same |
| `a >= b` | `A >= B` | Same |

### 3.4 Pointer Operations

```c
// C pointer operations
int value = 42;
int* ptr = &value;
int result = *ptr;
ptr[0] = 100;
*(ptr + 1) = 200;
```

```cpascal
// CPascal pointer operations
var
  LValue: Int32;
  LPtr: ^Int32;
  LResult: Int32;
begin
  LValue := 42;
  LPtr := @LValue;          // Address-of
  LResult := LPtr^;         // Dereference
  LPtr^ := 100;             // Assignment through pointer
  (LPtr + 1)^ := 200;       // Pointer arithmetic
end;
```

---

## 4. Type System Deep Dive

### 4.1 Complete Type Mapping

#### 4.1.1 Integer Types

| C Type | CPascal Type | Size | Range | Notes |
|--------|--------------|------|-------|-------|
| `char` | `Char` | 1 | 0-255 | Unsigned in CPascal |
| `signed char` | `Int8` | 1 | -128 to 127 | |
| `unsigned char` | `UInt8` | 1 | 0 to 255 | |
| `short` | `Int16` | 2 | -32768 to 32767 | |
| `unsigned short` | `UInt16` | 2 | 0 to 65535 | |
| `int` | `Int32` | 4 | -2³¹ to 2³¹-1 | |
| `unsigned int` | `UInt32` | 4 | 0 to 2³²-1 | |
| `long` | `Int32/Int64` | 4/8 | Platform dependent | Use NativeInt |
| `long long` | `Int64` | 8 | -2⁶³ to 2⁶³-1 | |
| `size_t` | `NativeUInt` | 4/8 | Platform dependent | |
| `ssize_t` | `NativeInt` | 4/8 | Platform dependent | |
| `intptr_t` | `NativeInt` | 4/8 | Platform dependent | |
| `uintptr_t` | `NativeUInt` | 4/8 | Platform dependent | |

#### 4.1.2 Floating Point Types

| C Type | CPascal Type | Size | Standard |
|--------|--------------|------|----------|
| `float` | `Single` | 4 | IEEE 754 |
| `double` | `Double` | 8 | IEEE 754 |
| `long double` | `Double` | 8/16 | Platform dependent |

#### 4.1.3 Complex Structure Migration

```c
// Complex C structure
typedef struct node {
    int data;
    struct node* next;
    struct node* prev;
    union {
        int flags;
        struct {
            unsigned active : 1;
            unsigned visible : 1;
            unsigned selected : 1;
            unsigned reserved : 29;
        } bits;
    } status;
} node_t;
```

```cpascal
// CPascal equivalent
type
  PNode = ^TNode;
  
  TNodeStatus = packed record
    case Boolean of
      true: (Flags: UInt32);
      false: (
        // Bitfields combined into single fields
        ActiveAndVisible: UInt8;    // Contains active(bit 0) and visible(bit 1)
        Selected: UInt8;            // Contains selected flag
        Reserved: UInt16;           // Reserved bits
      );
  end;
  
  TNode = packed record
    Data: Int32;
    Next: PNode;
    Prev: PNode;
    Status: TNodeStatus;
  end;

// Helper functions for bitfield access
function IsNodeActive(const ANode: ^TNode): Boolean;
begin
  Result := (ANode^.Status.ActiveAndVisible and $01) <> 0;
end;

procedure SetNodeActive(const ANode: ^TNode; const AActive: Boolean);
begin
  if AActive then
    ANode^.Status.ActiveAndVisible := ANode^.Status.ActiveAndVisible or $01
  else
    ANode^.Status.ActiveAndVisible := ANode^.Status.ActiveAndVisible and $FE;
end;
```

### 4.2 Array Migration Patterns

#### 4.2.1 Fixed Arrays

```c
// C fixed arrays
int numbers[10];
float matrix[4][4];
char buffer[256];
```

```cpascal
// CPascal fixed arrays
var
  Numbers: array[0..9] of Int32;
  Matrix: array[0..3, 0..3] of Single;
  Buffer: array[0..255] of Char;
```

#### 4.2.2 Dynamic Arrays (Pointers)

```c
// C dynamic arrays
int* numbers = malloc(count * sizeof(int));
float** matrix = malloc(rows * sizeof(float*));
for (int i = 0; i < rows; i++) {
    matrix[i] = malloc(cols * sizeof(float));
}
```

```cpascal
// CPascal dynamic arrays
var
  Numbers: ^Int32;
  Matrix: ^^Single;
  I: Int32;
begin
  Numbers := GetMem(Count * SizeOf(Int32));
  
  Matrix := GetMem(Rows * SizeOf(^Single));
  for I := 0 to Rows - 1 do
    Matrix[I] := GetMem(Cols * SizeOf(Single));
end;
```

#### 4.2.3 Variable Length Arrays (VLA)

```c
// C VLA (C99)
void process_data(int count) {
    int buffer[count];  // VLA not supported in CPascal
    // Process with buffer
}
```

```cpascal
// CPascal alternative
procedure ProcessData(const ACount: Int32);
var
  LBuffer: ^Int32;
begin
  LBuffer := GetMem(ACount * SizeOf(Int32));
  try
    // Process with buffer
  finally
    FreeMem(LBuffer);
  end;
end;
```

### 4.3 Function Pointer Migration

#### 4.3.1 Simple Function Pointers

```c
// C function pointer
typedef int (*callback_t)(int value);

int process_data(callback_t callback, int data) {
    return callback(data);
}
```

```cpascal
// CPascal function pointer
type
  TCallback = function(const AValue: Int32): Int32;

function ProcessData(const ACallback: TCallback; const AData: Int32): Int32;
begin
  Result := ACallback(AData);
end;
```

#### 4.3.2 Complex Function Pointers

```c
// C complex function pointer
typedef struct {
    int (*compare)(const void* a, const void* b);
    void (*swap)(void* a, void* b, size_t size);
    void* (*alloc)(size_t size);
    void (*free)(void* ptr);
} sort_vtable_t;
```

```cpascal
// CPascal equivalent
type
  TCompareFunc = function(const A, B: Pointer): Int32;
  TSwapProc = procedure(const A, B: Pointer; const ASize: NativeUInt);
  TAllocFunc = function(const ASize: NativeUInt): Pointer;
  TFreeProc = procedure(const APtr: Pointer);
  
  TSortVTable = packed record
    Compare: TCompareFunc;
    Swap: TSwapProc;
    Alloc: TAllocFunc;
    Free: TFreeProc;
  end;
```

---

## 5. Real-World Migration Examples

### 5.1 File I/O Migration

#### 5.1.1 Basic File Operations

```c
// file_ops.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char* data;
    size_t size;
    size_t capacity;
} buffer_t;

int read_file(const char* filename, buffer_t* buffer) {
    FILE* file = fopen(filename, "rb");
    if (!file) return -1;
    
    fseek(file, 0, SEEK_END);
    long size = ftell(file);
    fseek(file, 0, SEEK_SET);
    
    buffer->data = malloc(size + 1);
    if (!buffer->data) {
        fclose(file);
        return -1;
    }
    
    buffer->size = fread(buffer->data, 1, size, file);
    buffer->data[buffer->size] = '\0';
    buffer->capacity = size + 1;
    
    fclose(file);
    return 0;
}

void free_buffer(buffer_t* buffer) {
    if (buffer && buffer->data) {
        free(buffer->data);
        buffer->data = NULL;
        buffer->size = 0;
        buffer->capacity = 0;
    }
}
```

```cpascal
// file_ops.cpas
module FileOps;

// External C library functions
function fopen(const AFilename, AMode: PChar): Pointer; external;
function fclose(const AFile: Pointer): Int32; external;
function fseek(const AFile: Pointer; const AOffset: Int32; const AWhence: Int32): Int32; external;
function ftell(const AFile: Pointer): Int32; external;
function fread(const APtr: Pointer; const ASize, ACount: NativeUInt; const AFile: Pointer): NativeUInt; external;

const
  SEEK_END = 2;
  SEEK_SET = 0;

type
  TBuffer = packed record
    Data: PChar;
    Size: NativeUInt;
    Capacity: NativeUInt;
  end;

public function ReadFile(const AFilename: PChar; var ABuffer: TBuffer): Int32;
var
  LFile: Pointer;
  LSize: Int32;
begin
  LFile := fopen(AFilename, "rb");
  if LFile = nil then
    exit(-1);
    
  fseek(LFile, 0, SEEK_END);
  LSize := ftell(LFile);
  fseek(LFile, 0, SEEK_SET);
  
  ABuffer.Data := GetMem(LSize + 1);
  if ABuffer.Data = nil then
  begin
    fclose(LFile);
    exit(-1);
  end;
  
  ABuffer.Size := fread(ABuffer.Data, 1, LSize, LFile);
  ABuffer.Data[ABuffer.Size] := #0;
  ABuffer.Capacity := LSize + 1;
  
  fclose(LFile);
  Result := 0;
end;

public procedure FreeBuffer(var ABuffer: TBuffer);
begin
  if (ABuffer.Data <> nil) then
  begin
    FreeMem(ABuffer.Data);
    ABuffer.Data := nil;
    ABuffer.Size := 0;
    ABuffer.Capacity := 0;
  end;
end;

end.
```

### 5.2 Data Structure Migration

#### 5.2.1 Linked List Implementation

```c
// linked_list.c
#include <stdlib.h>
#include <string.h>

typedef struct node {
    void* data;
    struct node* next;
    struct node* prev;
} node_t;

typedef struct {
    node_t* head;
    node_t* tail;
    size_t count;
    size_t data_size;
} list_t;

list_t* list_create(size_t data_size) {
    list_t* list = malloc(sizeof(list_t));
    if (!list) return NULL;
    
    list->head = NULL;
    list->tail = NULL;
    list->count = 0;
    list->data_size = data_size;
    return list;
}

int list_push_back(list_t* list, const void* data) {
    if (!list || !data) return -1;
    
    node_t* node = malloc(sizeof(node_t));
    if (!node) return -1;
    
    node->data = malloc(list->data_size);
    if (!node->data) {
        free(node);
        return -1;
    }
    
    memcpy(node->data, data, list->data_size);
    node->next = NULL;
    node->prev = list->tail;
    
    if (list->tail) {
        list->tail->next = node;
    } else {
        list->head = node;
    }
    
    list->tail = node;
    list->count++;
    return 0;
}

void list_destroy(list_t* list) {
    if (!list) return;
    
    node_t* current = list->head;
    while (current) {
        node_t* next = current->next;
        free(current->data);
        free(current);
        current = next;
    }
    
    free(list);
}
```

```cpascal
// linked_list.cpas
module LinkedList;

// External memory functions
function memcpy(const ADest, ASrc: Pointer; const ACount: NativeUInt): Pointer; external;

type
  PNode = ^TNode;
  TNode = packed record
    Data: Pointer;
    Next: PNode;
    Prev: PNode;
  end;
  
  PList = ^TList;
  TList = packed record
    Head: PNode;
    Tail: PNode;
    Count: NativeUInt;
    DataSize: NativeUInt;
  end;

public function ListCreate(const ADataSize: NativeUInt): PList;
var
  LList: PList;
begin
  LList := GetMem(SizeOf(TList));
  if LList = nil then
    exit(nil);
    
  LList^.Head := nil;
  LList^.Tail := nil;
  LList^.Count := 0;
  LList^.DataSize := ADataSize;
  Result := LList;
end;

public function ListPushBack(const AList: PList; const AData: Pointer): Int32;
var
  LNode: PNode;
begin
  if (AList = nil) or (AData = nil) then
    exit(-1);
    
  LNode := GetMem(SizeOf(TNode));
  if LNode = nil then
    exit(-1);
    
  LNode^.Data := GetMem(AList^.DataSize);
  if LNode^.Data = nil then
  begin
    FreeMem(LNode);
    exit(-1);
  end;
  
  memcpy(LNode^.Data, AData, AList^.DataSize);
  LNode^.Next := nil;
  LNode^.Prev := AList^.Tail;
  
  if AList^.Tail <> nil then
    AList^.Tail^.Next := LNode
  else
    AList^.Head := LNode;
    
  AList^.Tail := LNode;
  Inc(AList^.Count);
  Result := 0;
end;

public procedure ListDestroy(const AList: PList);
var
  LCurrent, LNext: PNode;
begin
  if AList = nil then
    exit;
    
  LCurrent := AList^.Head;
  while LCurrent <> nil do
  begin
    LNext := LCurrent^.Next;
    FreeMem(LCurrent^.Data);
    FreeMem(LCurrent);
    LCurrent := LNext;
  end;
  
  FreeMem(AList);
end;

end.
```

### 5.3 Graphics Programming Migration

#### 5.3.1 Simple Graphics Application

```c
// graphics.c
#include <SDL2/SDL.h>
#include <GL/gl.h>
#include <stdbool.h>

typedef struct {
    SDL_Window* window;
    SDL_GLContext context;
    int width, height;
    bool running;
} app_state_t;

int init_graphics(app_state_t* app, int width, int height) {
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        return -1;
    }
    
    app->window = SDL_CreateWindow("Graphics Demo",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        width, height, SDL_WINDOW_OPENGL);
    
    if (!app->window) {
        SDL_Quit();
        return -1;
    }
    
    app->context = SDL_GL_CreateContext(app->window);
    if (!app->context) {
        SDL_DestroyWindow(app->window);
        SDL_Quit();
        return -1;
    }
    
    app->width = width;
    app->height = height;
    app->running = true;
    
    glViewport(0, 0, width, height);
    return 0;
}

void render_frame(app_state_t* app) {
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Simple triangle
    glBegin(GL_TRIANGLES);
    glColor3f(1.0f, 0.0f, 0.0f);
    glVertex2f(-0.5f, -0.5f);
    glColor3f(0.0f, 1.0f, 0.0f);
    glVertex2f(0.5f, -0.5f);
    glColor3f(0.0f, 0.0f, 1.0f);
    glVertex2f(0.0f, 0.5f);
    glEnd();
    
    SDL_GL_SwapWindow(app->window);
}

void handle_events(app_state_t* app) {
    SDL_Event event;
    while (SDL_PollEvent(&event)) {
        switch (event.type) {
            case SDL_QUIT:
                app->running = false;
                break;
            case SDL_KEYDOWN:
                if (event.key.keysym.sym == SDLK_ESCAPE) {
                    app->running = false;
                }
                break;
        }
    }
}

void cleanup_graphics(app_state_t* app) {
    if (app->context) {
        SDL_GL_DeleteContext(app->context);
    }
    if (app->window) {
        SDL_DestroyWindow(app->window);
    }
    SDL_Quit();
}
```

```cpascal
// graphics.cpas
program GraphicsDemo;

// SDL2 external functions
function SDL_Init(const AFlags: UInt32): Int32; external "SDL2";
function SDL_CreateWindow(const ATitle: PChar; const AX, AY, AW, AH: Int32; const AFlags: UInt32): Pointer; external "SDL2";
function SDL_GL_CreateContext(const AWindow: Pointer): Pointer; external "SDL2";
function SDL_GL_SwapWindow(const AWindow: Pointer): void; external "SDL2";
function SDL_PollEvent(const AEvent: ^TSDL_Event): Int32; external "SDL2";
procedure SDL_DestroyWindow(const AWindow: Pointer); external "SDL2";
procedure SDL_GL_DeleteContext(const AContext: Pointer); external "SDL2";
procedure SDL_Quit(); external "SDL2";

// OpenGL external functions
procedure glViewport(const AX, AY, AWidth, AHeight: Int32); external "OpenGL32";
procedure glClear(const AMask: UInt32); external "OpenGL32";
procedure glBegin(const AMode: UInt32); external "OpenGL32";
procedure glEnd(); external "OpenGL32";
procedure glColor3f(const AR, AG, AB: Single); external "OpenGL32";
procedure glVertex2f(const AX, AY: Single); external "OpenGL32";

const
  SDL_INIT_VIDEO = $00000020;
  SDL_WINDOW_OPENGL = $00000002;
  SDL_WINDOWPOS_CENTERED = $2FFF0000;
  SDL_QUIT = $100;
  SDL_KEYDOWN = $300;
  SDLK_ESCAPE = 27;
  GL_COLOR_BUFFER_BIT = $00004000;
  GL_TRIANGLES = $0004;

type
  TSDL_Event = packed record
    EventType: UInt32;
    // Simplified structure
    Padding: array[0..55] of UInt8;
  end;
  
  TSDLKeysym = packed record
    Scancode: Int32;
    Sym: Int32;
    Mod: UInt16;
    Unicode: UInt32;
  end;
  
  TSDLKeyboardEvent = packed record
    EventType: UInt32;
    Timestamp: UInt32;
    WindowID: UInt32;
    State: UInt8;
    Repeat: UInt8;
    Padding: array[0..1] of UInt8;
    Keysym: TSDLKeysym;
  end;
  
  TAppState = packed record
    Window: Pointer;
    Context: Pointer;
    Width, Height: Int32;
    Running: Boolean;
  end;

var
  GApp: TAppState;

function InitGraphics(var AApp: TAppState; const AWidth, AHeight: Int32): Int32;
begin
  if SDL_Init(SDL_INIT_VIDEO) < 0 then
    exit(-1);
    
  AApp.Window := SDL_CreateWindow("Graphics Demo",
    SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
    AWidth, AHeight, SDL_WINDOW_OPENGL);
    
  if AApp.Window = nil then
  begin
    SDL_Quit();
    exit(-1);
  end;
  
  AApp.Context := SDL_GL_CreateContext(AApp.Window);
  if AApp.Context = nil then
  begin
    SDL_DestroyWindow(AApp.Window);
    SDL_Quit();
    exit(-1);
  end;
  
  AApp.Width := AWidth;
  AApp.Height := AHeight;
  AApp.Running := true;
  
  glViewport(0, 0, AWidth, AHeight);
  Result := 0;
end;

procedure RenderFrame(const AApp: ^TAppState);
begin
  glClear(GL_COLOR_BUFFER_BIT);
  
  // Simple triangle
  glBegin(GL_TRIANGLES);
  glColor3f(1.0, 0.0, 0.0);
  glVertex2f(-0.5, -0.5);
  glColor3f(0.0, 1.0, 0.0);
  glVertex2f(0.5, -0.5);
  glColor3f(0.0, 0.0, 1.0);
  glVertex2f(0.0, 0.5);
  glEnd();
  
  SDL_GL_SwapWindow(AApp^.Window);
end;

procedure HandleEvents(var AApp: TAppState);
var
  LEvent: TSDL_Event;
  LKeyEvent: ^TSDLKeyboardEvent;
begin
  while SDL_PollEvent(@LEvent) <> 0 do
  begin
    case LEvent.EventType of
      SDL_QUIT:
        AApp.Running := false;
      SDL_KEYDOWN:
        begin
          LKeyEvent := ^TSDLKeyboardEvent(@LEvent);
          if LKeyEvent^.Keysym.Sym = SDLK_ESCAPE then
            AApp.Running := false;
        end;
    end;
  end;
end;

procedure CleanupGraphics(var AApp: TAppState);
begin
  if AApp.Context <> nil then
    SDL_GL_DeleteContext(AApp.Context);
  if AApp.Window <> nil then
    SDL_DestroyWindow(AApp.Window);
  SDL_Quit();
end;

begin
  if InitGraphics(GApp, 800, 600) < 0 then
    exit;
    
  while GApp.Running do
  begin
    HandleEvents(GApp);
    RenderFrame(@GApp);
  end;
  
  CleanupGraphics(GApp);
end.
```

---

## 6. Advanced Topics

### 6.1 Inline Assembly Migration

#### 6.1.1 GCC Extended Assembly to CPascal

```c
// C inline assembly (GCC)
static inline uint64_t rdtsc(void) {
    uint32_t low, high;
    asm volatile ("rdtsc" : "=a" (low), "=d" (high));
    return ((uint64_t)high << 32) | low;
}

static inline void cpuid(uint32_t func, uint32_t* eax, uint32_t* ebx, 
                        uint32_t* ecx, uint32_t* edx) {
    asm volatile ("cpuid"
        : "=a" (*eax), "=b" (*ebx), "=c" (*ecx), "=d" (*edx)
        : "a" (func));
}

static inline void memory_barrier(void) {
    asm volatile ("mfence" ::: "memory");
}
```

```cpascal
// CPascal inline assembly
function RDTSC(): UInt64; inline;
var
  LLow, LHigh: UInt32;
begin
  asm
    "rdtsc"
    : "=a" (LLow), "=d" (LHigh)
    :
    :
  end;
  Result := (UInt64(LHigh) shl 32) or UInt64(LLow);
end;

procedure CPUID(const AFunc: UInt32; out AEAX, AEBX, AECX, AEDX: UInt32); inline;
begin
  asm
    "cpuid"
    : "=a" (AEAX), "=b" (AEBX), "=c" (AECX), "=d" (AEDX)
    : "a" (AFunc)
    :
  end;
end;

procedure MemoryBarrier(); inline;
begin
  asm
    "mfence"
    :
    :
    : "memory"
  end;
end;
```

#### 6.1.2 Atomic Operations

```c
// C atomic operations
static inline int atomic_compare_exchange(volatile int* ptr, int expected, int desired) {
    int result;
    asm volatile (
        "lock cmpxchgl %2, %1"
        : "=a" (result), "+m" (*ptr)
        : "r" (desired), "0" (expected)
        : "memory"
    );
    return result;
}

static inline int atomic_increment(volatile int* ptr) {
    int result = 1;
    asm volatile (
        "lock xaddl %0, %1"
        : "+r" (result), "+m" (*ptr)
        :
        : "memory"
    );
    return result + 1;
}
```

```cpascal
// CPascal atomic operations
function AtomicCompareExchange(const APtr: ^volatile Int32; 
  const AExpected, ADesired: Int32): Int32; inline;
begin
  asm
    "lock cmpxchgl %2, %1"
    : "=a" (Result), "+m" (APtr^)
    : "r" (ADesired), "0" (AExpected)
    : "memory"
  end;
end;

function AtomicIncrement(const APtr: ^volatile Int32): Int32; inline;
var
  LResult: Int32;
begin
  LResult := 1;
  asm
    "lock xaddl %0, %1"
    : "+r" (LResult), "+m" (APtr^)
    :
    : "memory"
  end;
  Result := LResult + 1;
end;
```

### 6.2 Macro to Function Conversion

#### 6.2.1 Simple Macros

```c
// C macros
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define CLAMP(x, min, max) (MAX(MIN(x, max), min))
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
```

```cpascal
// CPascal inline functions
function Max(const A, B: Int32): Int32; inline;
begin
  Result := (A > B) ? A : B;
end;

function Min(const A, B: Int32): Int32; inline;
begin
  Result := (A < B) ? A : B;
end;

function Clamp(const AX, AMin, AMax: Int32): Int32; inline;
begin
  Result := Max(Min(AX, AMax), AMin);
end;

// Array size must be handled differently - no direct equivalent
// Use SizeOf(Array) div SizeOf(Array[0]) in code
```

#### 6.2.2 Complex Macros and Generic Patterns

**Important**: CPascal does **not** support generics or templates. All type definitions must be concrete and explicitly defined.

```c
// Complex C macro for "generic" data structures
#define DEFINE_LIST_TYPE(TYPE, NAME) \
    typedef struct NAME##_node { \
        TYPE data; \
        struct NAME##_node* next; \
    } NAME##_node_t; \
    \
    typedef struct { \
        NAME##_node_t* head; \
        size_t count; \
    } NAME##_list_t; \
    \
    static inline void NAME##_init(NAME##_list_t* list) { \
        list->head = NULL; \
        list->count = 0; \
    }

// Usage
DEFINE_LIST_TYPE(int, int_list);
DEFINE_LIST_TYPE(float, float_list);
```

```cpascal
// CPascal approach: Manual type definitions for each needed type
// (No generics support - must create separate types)

type
  // Integer list types
  TIntListNode = packed record
    Data: Int32;
    Next: ^TIntListNode;
  end;
  
  TIntList = packed record
    Head: ^TIntListNode;
    Count: NativeUInt;
  end;
  
  // Float list types  
  TFloatListNode = packed record
    Data: Single;
    Next: ^TFloatListNode;
  end;
  
  TFloatList = packed record
    Head: ^TFloatListNode;
    Count: NativeUInt;
  end;

procedure InitIntList(var AList: TIntList); inline;
begin
  AList.Head := nil;
  AList.Count := 0;
end;

procedure InitFloatList(var AList: TFloatList); inline;
begin
  AList.Head := nil;
  AList.Count := 0;
end;
```

### 6.3 Platform-Specific Code Migration

#### 6.3.1 Conditional Compilation

```c
// C platform-specific code
#ifdef _WIN32
    #include <windows.h>
    #define EXPORT __declspec(dllexport)
    #define CALL __stdcall
    typedef DWORD thread_id_t;
#elif defined(__linux__)
    #include <pthread.h>
    #define EXPORT __attribute__((visibility("default")))
    #define CALL
    typedef pthread_t thread_id_t;
#elif defined(__APPLE__)
    #include <pthread.h>
    #define EXPORT __attribute__((visibility("default")))
    #define CALL
    typedef pthread_t thread_id_t;
#endif

EXPORT int CALL create_thread(thread_id_t* id, void* (*func)(void*), void* arg);
```

```cpascal
// CPascal platform-specific code
module Threading;

{$IFDEF WINDOWS}
type
  TThreadID = UInt32;  // DWORD

function CreateThread(const ASecurity: Pointer; const AStackSize: NativeUInt;
  const AStartAddress: Pointer; const AParameter: Pointer; 
  const AFlags: UInt32; out AThreadID: TThreadID): Pointer; stdcall; external "kernel32";

{$ENDIF}

{$IFDEF LINUX}
type
  TThreadID = NativeUInt;  // pthread_t

function pthread_create(out AThread: TThreadID; const AAttr: Pointer;
  const AStartRoutine: Pointer; const AArg: Pointer): Int32; external "pthread";

{$ENDIF}

{$IFDEF MACOS}
type
  TThreadID = NativeUInt;  // pthread_t

function pthread_create(out AThread: TThreadID; const AAttr: Pointer;
  const AStartRoutine: Pointer; const AArg: Pointer): Int32; external "pthread";

{$ENDIF}

// Cross-platform wrapper
public function CreateThreadCrossPlatform(out AThreadID: TThreadID; 
  const AFunc: Pointer; const AArg: Pointer): Int32;
begin
{$IFDEF WINDOWS}
  Result := (CreateThread(nil, 0, AFunc, AArg, 0, AThreadID) <> nil) ? 0 : -1;
{$ELSE}
  Result := pthread_create(AThreadID, nil, AFunc, AArg);
{$ENDIF}
end;

end.
```

### 6.4 Working Without Generics

#### 6.4.1 CPascal Limitation: No Generic Types

CPascal intentionally omits generics to maintain C ABI compatibility and simplicity. This means:

- **No template syntax**: `TList<T>` is not supported
- **No generic constraints**: Cannot define type requirements
- **Manual instantiation required**: Must create separate types for each data type

#### 6.4.2 Alternative Approaches

**Option 1: Void Pointer with Type Safety Wrappers**

```cpascal
// Generic container using void pointers
type
  TGenericListNode = packed record
    Data: Pointer;
    Next: ^TGenericListNode;
  end;
  
  TGenericList = packed record
    Head: ^TGenericListNode;
    Count: NativeUInt;
    DataSize: NativeUInt;
  end;

// Type-safe wrappers
function CreateIntList(): TGenericList;
begin
  Result.Head := nil;
  Result.Count := 0;
  Result.DataSize := SizeOf(Int32);
end;

function AddToIntList(var AList: TGenericList; const AValue: Int32): Boolean;
var
  LNode: ^TGenericListNode;
  LData: ^Int32;
begin
  LNode := GetMem(SizeOf(TGenericListNode));
  if LNode = nil then
    exit(false);
    
  LData := GetMem(SizeOf(Int32));
  if LData = nil then
  begin
    FreeMem(LNode);
    exit(false);
  end;
  
  LData^ := AValue;
  LNode^.Data := LData;
  LNode^.Next := AList.Head;
  AList.Head := LNode;
  Inc(AList.Count);
  Result := true;
end;
```

**Option 2: Code Generation/Macros (External Tools)**

```cpascal
// Use external code generation for repetitive patterns
// Template file: list_template.cpas.template

// Generated: int_list.cpas
type
  TIntListNode = packed record
    Data: Int32;
    Next: ^TIntListNode;
  end;
  
  TIntList = packed record
    Head: ^TIntListNode;
    Count: NativeUInt;
  end;

// Generated: float_list.cpas  
type
  TFloatListNode = packed record
    Data: Single;
    Next: ^TFloatListNode;
  end;
  
  TFloatList = packed record
    Head: ^TFloatListNode;
    Count: NativeUInt;
  end;
```

**Option 3: Union-Based Variant Types**

```cpascal
// Variant type that can hold multiple types
type
  TDataType = (dtInt32, dtSingle, dtString, dtPointer);
  
  TVariantData = packed union
    AsInt32: Int32;
    AsSingle: Single;
    AsString: PChar;
    AsPointer: Pointer;
  end;
  
  TVariantListNode = packed record
    DataType: TDataType;
    Data: TVariantData;
    Next: ^TVariantListNode;
  end;
  
  TVariantList = packed record
    Head: ^TVariantListNode;
    Count: NativeUInt;
  end;

function AddInt32ToVariantList(var AList: TVariantList; const AValue: Int32): Boolean;
var
  LNode: ^TVariantListNode;
begin
  LNode := GetMem(SizeOf(TVariantListNode));
  if LNode = nil then
    exit(false);
    
  LNode^.DataType := dtInt32;
  LNode^.Data.AsInt32 := AValue;
  LNode^.Next := AList.Head;
  AList.Head := LNode;
  Inc(AList.Count);
  Result := true;
end;
```

# CPascal Migration Guide: From C to CPascal
**Complete Practitioner's Guide for C Developers**

## Table of Contents

1. [Strategic Overview](#1-strategic-overview)
2. [Quick Start Migration](#2-quick-start-migration)
3. [Comprehensive Syntax Translation](#3-comprehensive-syntax-translation)
4. [Type System Deep Dive](#4-type-system-deep-dive)
5. [Real-World Migration Examples](#5-real-world-migration-examples)
6. [Advanced Topics](#6-advanced-topics)
7. [Tooling and Workflow](#7-tooling-and-workflow)
8. [Performance Considerations](#8-performance-considerations)
9. [Integration Strategies](#9-integration-strategies)
10. [Troubleshooting Guide](#10-troubleshooting-guide)

---

## 1. Strategic Overview

### 1.1 Why Migrate to CPascal?

**CPascal provides C's power with Pascal's clarity:**

| Benefit | Description | Impact |
|---------|-------------|--------|
| **Readability** | Pascal syntax is more verbose but clearer | Faster code reviews, easier maintenance |
| **Type Safety** | Stricter type checking than C | Fewer runtime errors, better compile-time validation |
| **Modern Features** | Multiple assignment, ternary operators, inline assembly | More expressive code |
| **C Compatibility** | 100% C ABI compatibility | Zero-cost interop, gradual migration |
| **Module System** | Clean imports without preprocessor | Better dependency management |

### 1.2 Migration Strategies

#### 1.2.1 Incremental Migration (Recommended)

```c
// Existing C codebase
graphics.c      ← Keep as-is initially
audio.c         ← Keep as-is initially  
main.c          ← Migrate first to CPascal
utils.c         ← Migrate second
```

**Benefits:**
- Lower risk
- Immediate productivity
- Learn CPascal gradually
- Maintain existing functionality

#### 1.2.2 Complete Rewrite

**When to consider:**
- Small codebase (< 10k lines)
- Major refactoring needed anyway
- Clean slate requirements
- Learning/training project

#### 1.2.3 Hybrid Approach

**Best for:**
- Large codebases
- Performance-critical sections
- Legacy code with unclear behavior

```cpascal
// main.cpas - New CPascal code
program ModernApp;

// Link existing C libraries
function legacy_process_data(const AData: Pointer; const ASize: Int32): Int32; external "legacy.a";
function legacy_init(): Boolean; external "legacy.a";

var
  LData: ^UInt8;
  LResult: Int32;
  
begin
  if not legacy_init() then
    exit;
    
  // New CPascal code calling legacy C
  LData := GetMem(1024);
  LResult := legacy_process_data(LData, 1024);
  FreeMem(LData);
end.
```

### 1.3 Risk Assessment

#### 1.3.1 Low Risk Areas
- Pure computational code
- Data structure definitions
- Simple algorithms
- Utility functions

#### 1.3.2 Medium Risk Areas
- Complex pointer arithmetic
- Platform-specific code
- Performance-critical loops
- External library interfaces

#### 1.3.3 High Risk Areas
- Inline assembly
- Signal handlers
- Interrupt service routines
- Memory-mapped I/O

---

## 2. Quick Start Migration

### 2.1 Hello World Comparison

```c
// hello.c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

```cpascal
// hello.cpas
program Hello;

function printf(const AFormat: PChar, ...): Int32; external;

begin
  printf("Hello, World!\n");
end.
```

### 2.2 Basic Function Migration

```c
// C version
int add(int a, int b) {
    return a + b;
}

void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}
```

```cpascal
// CPascal version
function Add(const A, B: Int32): Int32;
begin
  Result := A + B;
end;

procedure Swap(var A, B: Int32);
var
  LTemp: Int32;
begin
  LTemp := A;
  A := B;
  B := LTemp;
end;
```

### 2.3 Structure Migration

```c
// C struct
typedef struct {
    float x, y, z;
    int id;
} Point3D;

Point3D create_point(float x, float y, float z) {
    Point3D p = {x, y, z, 0};
    return p;
}
```

```cpascal
// CPascal record
type
  TPoint3D = packed record
    X, Y, Z: Single;
    ID: Int32;
  end;

function CreatePoint(const AX, AY, AZ: Single): TPoint3D;
begin
  Result.X := AX;
  Result.Y := AY;
  Result.Z := AZ;
  Result.ID := 0;
end;
```

---

## 3. Comprehensive Syntax Translation

### 3.1 Variable Declarations

| C | CPascal | Notes |
|---|---------|-------|
| `int x;` | `var X: Int32;` | Explicit type required |
| `int x = 42;` | `var X: Int32 = 42;` | or in const section |
| `const int x = 42;` | `const X = 42;` | Type inferred |
| `static int x;` | `var X: Int32;` | Static nature handled by module system |
| `extern int x;` | `var X: Int32; external;` | External declaration |
| `volatile int x;` | `var X: volatile Int32;` | Direct equivalent |

### 3.2 Control Flow Translation

#### 3.2.1 Conditional Statements

```c
// C if-else
if (condition) {
    statement1();
} else if (condition2) {
    statement2();
} else {
    statement3();
}
```

```cpascal
// CPascal if-else
if Condition then
begin
  Statement1();
end
else if Condition2 then
begin
  Statement2();
end
else
begin
  Statement3();
end;
```

#### 3.2.2 Switch vs Case

```c
// C switch
switch (value) {
    case 1:
        handle_one();
        break;
    case 2:
    case 3:
        handle_two_or_three();
        break;
    default:
        handle_default();
        break;
}
```

```cpascal
// CPascal case
case Value of
  1: HandleOne();
  2, 3: HandleTwoOrThree();
else
  HandleDefault();
end;
```

#### 3.2.3 Loop Translation

```c
// C for loop
for (int i = 0; i < 10; i++) {
    process(i);
}

// C while loop
int i = 0;
while (i < 10) {
    process(i);
    i++;
}

// C do-while
int i = 0;
do {
    process(i);
    i++;
} while (i < 10);
```

```cpascal
// CPascal for loop
var
  I: Int32;
begin
  for I := 0 to 9 do
    Process(I);
end;

// CPascal while loop
var
  I: Int32;
begin
  I := 0;
  while I < 10 do
  begin
    Process(I);
    Inc(I);
  end;
end;

// CPascal repeat-until
var
  I: Int32;
begin
  I := 0;
  repeat
    Process(I);
    Inc(I);
  until I >= 10;
end;
```

### 3.3 Operator Translation

#### 3.3.1 Arithmetic Operators

| C | CPascal | Notes |
|---|---------|-------|
| `a + b` | `A + B` | Same |
| `a - b` | `A - B` | Same |
| `a * b` | `A * B` | Same |
| `a / b` | `A / B` | Floating division |
| `a / b` | `A div B` | Integer division |
| `a % b` | `A mod B` | Modulo |
| `++a` | `Inc(A)` | Prefix increment |
| `a++` | `A++` | Postfix increment (if supported) |
| `a += b` | `A += B` | Compound assignment |

#### 3.3.2 Bitwise Operators

| C | CPascal | Notes |
|---|---------|-------|
| `a & b` | `A and B` | Bitwise AND |
| `a \| b` | `A or B` | Bitwise OR |
| `a ^ b` | `A xor B` | Bitwise XOR |
| `~a` | `not A` | Bitwise NOT |
| `a << b` | `A shl B` | Shift left |
| `a >> b` | `A shr B` | Shift right |

#### 3.3.3 Comparison Operators

| C | CPascal | Notes |
|---|---------|-------|
| `a == b` | `A = B` | Equality |
| `a != b` | `A <> B` | Inequality |
| `a < b` | `A < B` | Same |
| `a <= b` | `A <= B` | Same |
| `a > b` | `A > B` | Same |
| `a >= b` | `A >= B` | Same |

### 3.4 Pointer Operations

```c
// C pointer operations
int value = 42;
int* ptr = &value;
int result = *ptr;
ptr[0] = 100;
*(ptr + 1) = 200;
```

```cpascal
// CPascal pointer operations
var
  LValue: Int32;
  LPtr: ^Int32;
  LResult: Int32;
begin
  LValue := 42;
  LPtr := @LValue;          // Address-of
  LResult := LPtr^;         // Dereference
  LPtr^ := 100;             // Assignment through pointer
  (LPtr + 1)^ := 200;       // Pointer arithmetic
end;
```

---

## 4. Type System Deep Dive

### 4.1 Complete Type Mapping

#### 4.1.1 Integer Types

| C Type | CPascal Type | Size | Range | Notes |
|--------|--------------|------|-------|-------|
| `char` | `Char` | 1 | 0-255 | Unsigned in CPascal |
| `signed char` | `Int8` | 1 | -128 to 127 | |
| `unsigned char` | `UInt8` | 1 | 0 to 255 | |
| `short` | `Int16` | 2 | -32768 to 32767 | |
| `unsigned short` | `UInt16` | 2 | 0 to 65535 | |
| `int` | `Int32` | 4 | -2³¹ to 2³¹-1 | |
| `unsigned int` | `UInt32` | 4 | 0 to 2³²-1 | |
| `long` | `Int32/Int64` | 4/8 | Platform dependent | Use NativeInt |
| `long long` | `Int64` | 8 | -2⁶³ to 2⁶³-1 | |
| `size_t` | `NativeUInt` | 4/8 | Platform dependent | |
| `ssize_t` | `NativeInt` | 4/8 | Platform dependent | |
| `intptr_t` | `NativeInt` | 4/8 | Platform dependent | |
| `uintptr_t` | `NativeUInt` | 4/8 | Platform dependent | |

#### 4.1.2 Floating Point Types

| C Type | CPascal Type | Size | Standard |
|--------|--------------|------|----------|
| `float` | `Single` | 4 | IEEE 754 |
| `double` | `Double` | 8 | IEEE 754 |
| `long double` | `Double` | 8/16 | Platform dependent |

#### 4.1.3 Complex Structure Migration

```c
// Complex C structure
typedef struct node {
    int data;
    struct node* next;
    struct node* prev;
    union {
        int flags;
        struct {
            unsigned active : 1;
            unsigned visible : 1;
            unsigned selected : 1;
            unsigned reserved : 29;
        } bits;
    } status;
} node_t;
```

```cpascal
// CPascal equivalent
type
  PNode = ^TNode;
  
  TNodeStatus = packed record
    case Boolean of
      true: (Flags: UInt32);
      false: (
        // Bitfields combined into single fields
        ActiveAndVisible: UInt8;    // Contains active(bit 0) and visible(bit 1)
        Selected: UInt8;            // Contains selected flag
        Reserved: UInt16;           // Reserved bits
      );
  end;
  
  TNode = packed record
    Data: Int32;
    Next: PNode;
    Prev: PNode;
    Status: TNodeStatus;
  end;

// Helper functions for bitfield access
function IsNodeActive(const ANode: ^TNode): Boolean;
begin
  Result := (ANode^.Status.ActiveAndVisible and $01) <> 0;
end;

procedure SetNodeActive(const ANode: ^TNode; const AActive: Boolean);
begin
  if AActive then
    ANode^.Status.ActiveAndVisible := ANode^.Status.ActiveAndVisible or $01
  else
    ANode^.Status.ActiveAndVisible := ANode^.Status.ActiveAndVisible and $FE;
end;
```

### 4.2 Array Migration Patterns

#### 4.2.1 Fixed Arrays

```c
// C fixed arrays
int numbers[10];
float matrix[4][4];
char buffer[256];
```

```cpascal
// CPascal fixed arrays
var
  Numbers: array[0..9] of Int32;
  Matrix: array[0..3, 0..3] of Single;
  Buffer: array[0..255] of Char;
```

#### 4.2.2 Dynamic Arrays (Pointers)

```c
// C dynamic arrays
int* numbers = malloc(count * sizeof(int));
float** matrix = malloc(rows * sizeof(float*));
for (int i = 0; i < rows; i++) {
    matrix[i] = malloc(cols * sizeof(float));
}
```

```cpascal
// CPascal dynamic arrays
var
  Numbers: ^Int32;
  Matrix: ^^Single;
  I: Int32;
begin
  Numbers := GetMem(Count * SizeOf(Int32));
  
  Matrix := GetMem(Rows * SizeOf(^Single));
  for I := 0 to Rows - 1 do
    Matrix[I] := GetMem(Cols * SizeOf(Single));
end;
```

#### 4.2.3 Variable Length Arrays (VLA)

```c
// C VLA (C99)
void process_data(int count) {
    int buffer[count];  // VLA not supported in CPascal
    // Process with buffer
}
```

```cpascal
// CPascal alternative
procedure ProcessData(const ACount: Int32);
var
  LBuffer: ^Int32;
begin
  LBuffer := GetMem(ACount * SizeOf(Int32));
  try
    // Process with buffer
  finally
    FreeMem(LBuffer);
  end;
end;
```

### 4.3 Function Pointer Migration

#### 4.3.1 Simple Function Pointers

```c
// C function pointer
typedef int (*callback_t)(int value);

int process_data(callback_t callback, int data) {
    return callback(data);
}
```

```cpascal
// CPascal function pointer
type
  TCallback = function(const AValue: Int32): Int32;

function ProcessData(const ACallback: TCallback; const AData: Int32): Int32;
begin
  Result := ACallback(AData);
end;
```

#### 4.3.2 Complex Function Pointers

```c
// C complex function pointer
typedef struct {
    int (*compare)(const void* a, const void* b);
    void (*swap)(void* a, void* b, size_t size);
    void* (*alloc)(size_t size);
    void (*free)(void* ptr);
} sort_vtable_t;
```

```cpascal
// CPascal equivalent
type
  TCompareFunc = function(const A, B: Pointer): Int32;
  TSwapProc = procedure(const A, B: Pointer; const ASize: NativeUInt);
  TAllocFunc = function(const ASize: NativeUInt): Pointer;
  TFreeProc = procedure(const APtr: Pointer);
  
  TSortVTable = packed record
    Compare: TCompareFunc;
    Swap: TSwapProc;
    Alloc: TAllocFunc;
    Free: TFreeProc;
  end;
```

---

## 5. Real-World Migration Examples

### 5.1 File I/O Migration

#### 5.1.1 Basic File Operations

```c
// file_ops.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char* data;
    size_t size;
    size_t capacity;
} buffer_t;

int read_file(const char* filename, buffer_t* buffer) {
    FILE* file = fopen(filename, "rb");
    if (!file) return -1;
    
    fseek(file, 0, SEEK_END);
    long size = ftell(file);
    fseek(file, 0, SEEK_SET);
    
    buffer->data = malloc(size + 1);
    if (!buffer->data) {
        fclose(file);
        return -1;
    }
    
    buffer->size = fread(buffer->data, 1, size, file);
    buffer->data[buffer->size] = '\0';
    buffer->capacity = size + 1;
    
    fclose(file);
    return 0;
}

void free_buffer(buffer_t* buffer) {
    if (buffer && buffer->data) {
        free(buffer->data);
        buffer->data = NULL;
        buffer->size = 0;
        buffer->capacity = 0;
    }
}
```

```cpascal
// file_ops.cpas
module FileOps;

// External C library functions
function fopen(const AFilename, AMode: PChar): Pointer; external;
function fclose(const AFile: Pointer): Int32; external;
function fseek(const AFile: Pointer; const AOffset: Int32; const AWhence: Int32): Int32; external;
function ftell(const AFile: Pointer): Int32; external;
function fread(const APtr: Pointer; const ASize, ACount: NativeUInt; const AFile: Pointer): NativeUInt; external;

const
  SEEK_END = 2;
  SEEK_SET = 0;

type
  TBuffer = packed record
    Data: PChar;
    Size: NativeUInt;
    Capacity: NativeUInt;
  end;

public function ReadFile(const AFilename: PChar; var ABuffer: TBuffer): Int32;
var
  LFile: Pointer;
  LSize: Int32;
begin
  LFile := fopen(AFilename, "rb");
  if LFile = nil then
    exit(-1);
    
  fseek(LFile, 0, SEEK_END);
  LSize := ftell(LFile);
  fseek(LFile, 0, SEEK_SET);
  
  ABuffer.Data := GetMem(LSize + 1);
  if ABuffer.Data = nil then
  begin
    fclose(LFile);
    exit(-1);
  end;
  
  ABuffer.Size := fread(ABuffer.Data, 1, LSize, LFile);
  ABuffer.Data[ABuffer.Size] := #0;
  ABuffer.Capacity := LSize + 1;
  
  fclose(LFile);
  Result := 0;
end;

public procedure FreeBuffer(var ABuffer: TBuffer);
begin
  if (ABuffer.Data <> nil) then
  begin
    FreeMem(ABuffer.Data);
    ABuffer.Data := nil;
    ABuffer.Size := 0;
    ABuffer.Capacity := 0;
  end;
end;

end.
```

### 5.2 Data Structure Migration

#### 5.2.1 Linked List Implementation

```c
// linked_list.c
#include <stdlib.h>
#include <string.h>

typedef struct node {
    void* data;
    struct node* next;
    struct node* prev;
} node_t;

typedef struct {
    node_t* head;
    node_t* tail;
    size_t count;
    size_t data_size;
} list_t;

list_t* list_create(size_t data_size) {
    list_t* list = malloc(sizeof(list_t));
    if (!list) return NULL;
    
    list->head = NULL;
    list->tail = NULL;
    list->count = 0;
    list->data_size = data_size;
    return list;
}

int list_push_back(list_t* list, const void* data) {
    if (!list || !data) return -1;
    
    node_t* node = malloc(sizeof(node_t));
    if (!node) return -1;
    
    node->data = malloc(list->data_size);
    if (!node->data) {
        free(node);
        return -1;
    }
    
    memcpy(node->data, data, list->data_size);
    node->next = NULL;
    node->prev = list->tail;
    
    if (list->tail) {
        list->tail->next = node;
    } else {
        list->head = node;
    }
    
    list->tail = node;
    list->count++;
    return 0;
}

void list_destroy(list_t* list) {
    if (!list) return;
    
    node_t* current = list->head;
    while (current) {
        node_t* next = current->next;
        free(current->data);
        free(current);
        current = next;
    }
    
    free(list);
}
```

```cpascal
// linked_list.cpas
module LinkedList;

// External memory functions
function memcpy(const ADest, ASrc: Pointer; const ACount: NativeUInt): Pointer; external;

type
  PNode = ^TNode;
  TNode = packed record
    Data: Pointer;
    Next: PNode;
    Prev: PNode;
  end;
  
  PList = ^TList;
  TList = packed record
    Head: PNode;
    Tail: PNode;
    Count: NativeUInt;
    DataSize: NativeUInt;
  end;

public function ListCreate(const ADataSize: NativeUInt): PList;
var
  LList: PList;
begin
  LList := GetMem(SizeOf(TList));
  if LList = nil then
    exit(nil);
    
  LList^.Head := nil;
  LList^.Tail := nil;
  LList^.Count := 0;
  LList^.DataSize := ADataSize;
  Result := LList;
end;

public function ListPushBack(const AList: PList; const AData: Pointer): Int32;
var
  LNode: PNode;
begin
  if (AList = nil) or (AData = nil) then
    exit(-1);
    
  LNode := GetMem(SizeOf(TNode));
  if LNode = nil then
    exit(-1);
    
  LNode^.Data := GetMem(AList^.DataSize);
  if LNode^.Data = nil then
  begin
    FreeMem(LNode);
    exit(-1);
  end;
  
  memcpy(LNode^.Data, AData, AList^.DataSize);
  LNode^.Next := nil;
  LNode^.Prev := AList^.Tail;
  
  if AList^.Tail <> nil then
    AList^.Tail^.Next := LNode
  else
    AList^.Head := LNode;
    
  AList^.Tail := LNode;
  Inc(AList^.Count);
  Result := 0;
end;

public procedure ListDestroy(const AList: PList);
var
  LCurrent, LNext: PNode;
begin
  if AList = nil then
    exit;
    
  LCurrent := AList^.Head;
  while LCurrent <> nil do
  begin
    LNext := LCurrent^.Next;
    FreeMem(LCurrent^.Data);
    FreeMem(LCurrent);
    LCurrent := LNext;
  end;
  
  FreeMem(AList);
end;

end.
```

### 5.3 Graphics Programming Migration

#### 5.3.1 Simple Graphics Application

```c
// graphics.c
#include <SDL2/SDL.h>
#include <GL/gl.h>
#include <stdbool.h>

typedef struct {
    SDL_Window* window;
    SDL_GLContext context;
    int width, height;
    bool running;
} app_state_t;

int init_graphics(app_state_t* app, int width, int height) {
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        return -1;
    }
    
    app->window = SDL_CreateWindow("Graphics Demo",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        width, height, SDL_WINDOW_OPENGL);
    
    if (!app->window) {
        SDL_Quit();
        return -1;
    }
    
    app->context = SDL_GL_CreateContext(app->window);
    if (!app->context) {
        SDL_DestroyWindow(app->window);
        SDL_Quit();
        return -1;
    }
    
    app->width = width;
    app->height = height;
    app->running = true;
    
    glViewport(0, 0, width, height);
    return 0;
}

void render_frame(app_state_t* app) {
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Simple triangle
    glBegin(GL_TRIANGLES);
    glColor3f(1.0f, 0.0f, 0.0f);
    glVertex2f(-0.5f, -0.5f);
    glColor3f(0.0f, 1.0f, 0.0f);
    glVertex2f(0.5f, -0.5f);
    glColor3f(0.0f, 0.0f, 1.0f);
    glVertex2f(0.0f, 0.5f);
    glEnd();
    
    SDL_GL_SwapWindow(app->window);
}

void handle_events(app_state_t* app) {
    SDL_Event event;
    while (SDL_PollEvent(&event)) {
        switch (event.type) {
            case SDL_QUIT:
                app->running = false;
                break;
            case SDL_KEYDOWN:
                if (event.key.keysym.sym == SDLK_ESCAPE) {
                    app->running = false;
                }
                break;
        }
    }
}

void cleanup_graphics(app_state_t* app) {
    if (app->context) {
        SDL_GL_DeleteContext(app->context);
    }
    if (app->window) {
        SDL_DestroyWindow(app->window);
    }
    SDL_Quit();
}
```

```cpascal
// graphics.cpas
program GraphicsDemo;

// SDL2 external functions
function SDL_Init(const AFlags: UInt32): Int32; external "SDL2";
function SDL_CreateWindow(const ATitle: PChar; const AX, AY, AW, AH: Int32; const AFlags: UInt32): Pointer; external "SDL2";
function SDL_GL_CreateContext(const AWindow: Pointer): Pointer; external "SDL2";
function SDL_GL_SwapWindow(const AWindow: Pointer): void; external "SDL2";
function SDL_PollEvent(const AEvent: ^TSDL_Event): Int32; external "SDL2";
procedure SDL_DestroyWindow(const AWindow: Pointer); external "SDL2";
procedure SDL_GL_DeleteContext(const AContext: Pointer); external "SDL2";
procedure SDL_Quit(); external "SDL2";

// OpenGL external functions
procedure glViewport(const AX, AY, AWidth, AHeight: Int32); external "OpenGL32";
procedure glClear(const AMask: UInt32); external "OpenGL32";
procedure glBegin(const AMode: UInt32); external "OpenGL32";
procedure glEnd(); external "OpenGL32";
procedure glColor3f(const AR, AG, AB: Single); external "OpenGL32";
procedure glVertex2f(const AX, AY: Single); external "OpenGL32";

const
  SDL_INIT_VIDEO = $00000020;
  SDL_WINDOW_OPENGL = $00000002;
  SDL_WINDOWPOS_CENTERED = $2FFF0000;
  SDL_QUIT = $100;
  SDL_KEYDOWN = $300;
  SDLK_ESCAPE = 27;
  GL_COLOR_BUFFER_BIT = $00004000;
  GL_TRIANGLES = $0004;

type
  TSDL_Event = packed record
    EventType: UInt32;
    // Simplified structure
    Padding: array[0..55] of UInt8;
  end;
  
  TSDLKeysym = packed record
    Scancode: Int32;
    Sym: Int32;
    Mod: UInt16;
    Unicode: UInt32;
  end;
  
  TSDLKeyboardEvent = packed record
    EventType: UInt32;
    Timestamp: UInt32;
    WindowID: UInt32;
    State: UInt8;
    Repeat: UInt8;
    Padding: array[0..1] of UInt8;
    Keysym: TSDLKeysym;
  end;
  
  TAppState = packed record
    Window: Pointer;
    Context: Pointer;
    Width, Height: Int32;
    Running: Boolean;
  end;

var
  GApp: TAppState;

function InitGraphics(var AApp: TAppState; const AWidth, AHeight: Int32): Int32;
begin
  if SDL_Init(SDL_INIT_VIDEO) < 0 then
    exit(-1);
    
  AApp.Window := SDL_CreateWindow("Graphics Demo",
    SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
    AWidth, AHeight, SDL_WINDOW_OPENGL);
    
  if AApp.Window = nil then
  begin
    SDL_Quit();
    exit(-1);
  end;
  
  AApp.Context := SDL_GL_CreateContext(AApp.Window);
  if AApp.Context = nil then
  begin
    SDL_DestroyWindow(AApp.Window);
    SDL_Quit();
    exit(-1);
  end;
  
  AApp.Width := AWidth;
  AApp.Height := AHeight;
  AApp.Running := true;
  
  glViewport(0, 0, AWidth, AHeight);
  Result := 0;
end;

procedure RenderFrame(const AApp: ^TAppState);
begin
  glClear(GL_COLOR_BUFFER_BIT);
  
  // Simple triangle
  glBegin(GL_TRIANGLES);
  glColor3f(1.0, 0.0, 0.0);
  glVertex2f(-0.5, -0.5);
  glColor3f(0.0, 1.0, 0.0);
  glVertex2f(0.5, -0.5);
  glColor3f(0.0, 0.0, 1.0);
  glVertex2f(0.0, 0.5);
  glEnd();
  
  SDL_GL_SwapWindow(AApp^.Window);
end;

procedure HandleEvents(var AApp: TAppState);
var
  LEvent: TSDL_Event;
  LKeyEvent: ^TSDLKeyboardEvent;
begin
  while SDL_PollEvent(@LEvent) <> 0 do
  begin
    case LEvent.EventType of
      SDL_QUIT:
        AApp.Running := false;
      SDL_KEYDOWN:
        begin
          LKeyEvent := ^TSDLKeyboardEvent(@LEvent);
          if LKeyEvent^.Keysym.Sym = SDLK_ESCAPE then
            AApp.Running := false;
        end;
    end;
  end;
end;

procedure CleanupGraphics(var AApp: TAppState);
begin
  if AApp.Context <> nil then
    SDL_GL_DeleteContext(AApp.Context);
  if AApp.Window <> nil then
    SDL_DestroyWindow(AApp.Window);
  SDL_Quit();
end;

begin
  if InitGraphics(GApp, 800, 600) < 0 then
    exit;
    
  while GApp.Running do
  begin
    HandleEvents(GApp);
    RenderFrame(@GApp);
  end;
  
  CleanupGraphics(GApp);
end.
```

---

## 6. Advanced Topics

### 6.1 Inline Assembly Migration

#### 6.1.1 GCC Extended Assembly to CPascal

```c
// C inline assembly (GCC)
static inline uint64_t rdtsc(void) {
    uint32_t low, high;
    asm volatile ("rdtsc" : "=a" (low), "=d" (high));
    return ((uint64_t)high << 32) | low;
}

static inline void cpuid(uint32_t func, uint32_t* eax, uint32_t* ebx, 
                        uint32_t* ecx, uint32_t* edx) {
    asm volatile ("cpuid"
        : "=a" (*eax), "=b" (*ebx), "=c" (*ecx), "=d" (*edx)
        : "a" (func));
}

static inline void memory_barrier(void) {
    asm volatile ("mfence" ::: "memory");
}
```

```cpascal
// CPascal inline assembly
function RDTSC(): UInt64; inline;
var
  LLow, LHigh: UInt32;
begin
  asm
    "rdtsc"
    : "=a" (LLow), "=d" (LHigh)
    :
    :
  end;
  Result := (UInt64(LHigh) shl 32) or UInt64(LLow);
end;

procedure CPUID(const AFunc: UInt32; out AEAX, AEBX, AECX, AEDX: UInt32); inline;
begin
  asm
    "cpuid"
    : "=a" (AEAX), "=b" (AEBX), "=c" (AECX), "=d" (AEDX)
    : "a" (AFunc)
    :
  end;
end;

procedure MemoryBarrier(); inline;
begin
  asm
    "mfence"
    :
    :
    : "memory"
  end;
end;
```

#### 6.1.2 Atomic Operations

```c
// C atomic operations
static inline int atomic_compare_exchange(volatile int* ptr, int expected, int desired) {
    int result;
    asm volatile (
        "lock cmpxchgl %2, %1"
        : "=a" (result), "+m" (*ptr)
        : "r" (desired), "0" (expected)
        : "memory"
    );
    return result;
}

static inline int atomic_increment(volatile int* ptr) {
    int result = 1;
    asm volatile (
        "lock xaddl %0, %1"
        : "+r" (result), "+m" (*ptr)
        :
        : "memory"
    );
    return result + 1;
}
```

```cpascal
// CPascal atomic operations
function AtomicCompareExchange(const APtr: ^volatile Int32; 
  const AExpected, ADesired: Int32): Int32; inline;
begin
  asm
    "lock cmpxchgl %2, %1"
    : "=a" (Result), "+m" (APtr^)
    : "r" (ADesired), "0" (AExpected)
    : "memory"
  end;
end;

function AtomicIncrement(const APtr: ^volatile Int32): Int32; inline;
var
  LResult: Int32;
begin
  LResult := 1;
  asm
    "lock xaddl %0, %1"
    : "+r" (LResult), "+m" (APtr^)
    :
    : "memory"
  end;
  Result := LResult + 1;
end;
```

### 6.2 Macro to Function Conversion

#### 6.2.1 Simple Macros

```c
// C macros
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define CLAMP(x, min, max) (MAX(MIN(x, max), min))
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
```

```cpascal
// CPascal inline functions
function Max(const A, B: Int32): Int32; inline;
begin
  Result := (A > B) ? A : B;
end;

function Min(const A, B: Int32): Int32; inline;
begin
  Result := (A < B) ? A : B;
end;

function Clamp(const AX, AMin, AMax: Int32): Int32; inline;
begin
  Result := Max(Min(AX, AMax), AMin);
end;

// Array size must be handled differently - no direct equivalent
// Use SizeOf(Array) div SizeOf(Array[0]) in code
```

#### 6.2.2 Complex Macros and Generic Patterns

**Important**: CPascal does **not** support generics or templates. All type definitions must be concrete and explicitly defined.

```c
// Complex C macro for "generic" data structures
#define DEFINE_LIST_TYPE(TYPE, NAME) \
    typedef struct NAME##_node { \
        TYPE data; \
        struct NAME##_node* next; \
    } NAME##_node_t; \
    \
    typedef struct { \
        NAME##_node_t* head; \
        size_t count; \
    } NAME##_list_t; \
    \
    static inline void NAME##_init(NAME##_list_t* list) { \
        list->head = NULL; \
        list->count = 0; \
    }

// Usage
DEFINE_LIST_TYPE(int, int_list);
DEFINE_LIST_TYPE(float, float_list);
```

```cpascal
// CPascal approach: Manual type definitions for each needed type
// (No generics support - must create separate types)

type
  // Integer list types
  TIntListNode = packed record
    Data: Int32;
    Next: ^TIntListNode;
  end;
  
  TIntList = packed record
    Head: ^TIntListNode;
    Count: NativeUInt;
  end;
  
  // Float list types  
  TFloatListNode = packed record
    Data: Single;
    Next: ^TFloatListNode;
  end;
  
  TFloatList = packed record
    Head: ^TFloatListNode;
    Count: NativeUInt;
  end;

procedure InitIntList(var AList: TIntList); inline;
begin
  AList.Head := nil;
  AList.Count := 0;
end;

procedure InitFloatList(var AList: TFloatList); inline;
begin
  AList.Head := nil;
  AList.Count := 0;
end;
```

### 6.3 Platform-Specific Code Migration

#### 6.3.1 Conditional Compilation

```c
// C platform-specific code
#ifdef _WIN32
    #include <windows.h>
    #define EXPORT __declspec(dllexport)
    #define CALL __stdcall
    typedef DWORD thread_id_t;
#elif defined(__linux__)
    #include <pthread.h>
    #define EXPORT __attribute__((visibility("default")))
    #define CALL
    typedef pthread_t thread_id_t;
#elif defined(__APPLE__)
    #include <pthread.h>
    #define EXPORT __attribute__((visibility("default")))
    #define CALL
    typedef pthread_t thread_id_t;
#endif

EXPORT int CALL create_thread(thread_id_t* id, void* (*func)(void*), void* arg);
```

```cpascal
// CPascal platform-specific code
module Threading;

{$IFDEF WINDOWS}
type
  TThreadID = UInt32;  // DWORD

function CreateThread(const ASecurity: Pointer; const AStackSize: NativeUInt;
  const AStartAddress: Pointer; const AParameter: Pointer; 
  const AFlags: UInt32; out AThreadID: TThreadID): Pointer; stdcall; external "kernel32";

{$ENDIF}

{$IFDEF LINUX}
type
  TThreadID = NativeUInt;  // pthread_t

function pthread_create(out AThread: TThreadID; const AAttr: Pointer;
  const AStartRoutine: Pointer; const AArg: Pointer): Int32; external "pthread";

{$ENDIF}

{$IFDEF MACOS}
type
  TThreadID = NativeUInt;  // pthread_t

function pthread_create(out AThread: TThreadID; const AAttr: Pointer;
  const AStartRoutine: Pointer; const AArg: Pointer): Int32; external "pthread";

{$ENDIF}

// Cross-platform wrapper
public function CreateThreadCrossPlatform(out AThreadID: TThreadID; 
  const AFunc: Pointer; const AArg: Pointer): Int32;
begin
{$IFDEF WINDOWS}
  Result := (CreateThread(nil, 0, AFunc, AArg, 0, AThreadID) <> nil) ? 0 : -1;
{$ELSE}
  Result := pthread_create(AThreadID, nil, AFunc, AArg);
{$ENDIF}
end;

end.
```

---

## 7. Tooling and Workflow

### 7.1 Migration Checklist

#### 7.1.1 Pre-Migration Assessment

- [ ] **Code Analysis**
  - [ ] Identify external dependencies
  - [ ] List platform-specific code sections
  - [ ] Count lines of code (LoC) estimate
  - [ ] Document complex pointer arithmetic
  - [ ] Note inline assembly usage

- [ ] **Risk Assessment** 
  - [ ] Performance-critical sections identified
  - [ ] Thread-safety requirements documented
  - [ ] Memory allocation patterns analyzed
  - [ ] External API compatibility verified

- [ ] **Testing Strategy**
  - [ ] Unit tests exist or can be created
  - [ ] Integration test plan defined
  - [ ] Performance benchmarks established
  - [ ] Regression test suite prepared

#### 7.1.2 Migration Phase Checklist

- [ ] **Setup Phase**
  - [ ] CPascal compiler installed and tested
  - [ ] Build system configured
  - [ ] External libraries linked successfully
  - [ ] Basic "Hello World" compiles and runs

- [ ] **Code Conversion**
  - [ ] Header files converted to external declarations
  - [ ] Type definitions migrated
  - [ ] Simple functions converted first
  - [ ] Complex functions converted incrementally
  - [ ] Inline assembly converted (if any)

- [ ] **Testing Phase**
  - [ ] Unit tests pass
  - [ ] Integration tests pass
  - [ ] Performance benchmarks meet requirements
  - [ ] Memory leak testing completed
  - [ ] Cross-platform testing (if applicable)

### 7.2 Automated Conversion Tools

#### 7.2.1 Simple Text Processing Script

```bash
#!/bin/bash
# c_to_cpascal.sh - Basic C to CPascal conversion

# Convert basic type names
sed -i 's/\bint\b/Int32/g' "$1"
sed -i 's/\bfloat\b/Single/g' "$1"
sed -i 's/\bdouble\b/Double/g' "$1"
sed -i 's/\bchar\b/Char/g' "$1"
sed -i 's/\bvoid\*/Pointer/g' "$1"

# Convert operators
sed -i 's/==/=/g' "$1"
sed -i 's/!=/\<\>/g' "$1"
sed -i 's/&&/and/g' "$1"
sed -i 's/||/or/g' "$1"
sed -i 's/!/not /g' "$1"

# Convert control structures
sed -i 's/if (/if /g' "$1"
sed -i 's/) {/then/g' "$1"
sed -i 's/} else {/else/g' "$1"
sed -i 's/}/end;/g' "$1"

echo "Basic conversion complete. Manual review required."
```

#### 7.2.2 Python Conversion Script

```python
#!/usr/bin/env python3
# c_to_cpascal.py - More sophisticated conversion

import re
import sys

class CToColorPascalConverter:
    def __init__(self):
        self.type_map = {
            'int': 'Int32',
            'short': 'Int16', 
            'long': 'Int32',
            'long long': 'Int64',
            'unsigned int': 'UInt32',
            'unsigned short': 'UInt16',
            'unsigned long': 'UInt32',
            'unsigned long long': 'UInt64',
            'float': 'Single',
            'double': 'Double',
            'char': 'Char',
            'unsigned char': 'UInt8',
            'signed char': 'Int8',
            'void*': 'Pointer',
            'size_t': 'NativeUInt',
            'ssize_t': 'NativeInt'
        }
        
        self.operator_map = {
            '==': '=',
            '!=': '<>',
            '&&': ' and ',
            '||': ' or ',
            '!': 'not ',
            '<<': ' shl ',
            '>>': ' shr '
        }
    
    def convert_types(self, text):
        for c_type, pascal_type in self.type_map.items():
            text = re.sub(r'\b' + re.escape(c_type) + r'\b', pascal_type, text)
        return text
    
    def convert_operators(self, text):
        for c_op, pascal_op in self.operator_map.items():
            text = text.replace(c_op, pascal_op)
        return text
    
    def convert_function_declaration(self, text):
        # Convert: int function_name(params) to function FunctionName(params): Int32;
        pattern = r'(\w+)\s+(\w+)\s*\((.*?)\)\s*\{'
        def replace_func(match):
            return_type = self.convert_types(match.group(1))
            func_name = self.snake_to_pascal(match.group(2))
            params = self.convert_parameters(match.group(3))
            return f'function {func_name}({params}): {return_type};\nbegin'
        
        return re.sub(pattern, replace_func, text)
    
    def snake_to_pascal(self, name):
        return ''.join(word.capitalize() for word in name.split('_'))
    
    def convert_parameters(self, params):
        if not params.strip():
            return ''
        
        param_list = []
        for param in params.split(','):
            param = param.strip()
            parts = param.split()
            if len(parts) >= 2:
                type_part = ' '.join(parts[:-1])
                name_part = parts[-1]
                # Remove pointer stars from name
                name_part = name_part.lstrip('*')
                type_part = self.convert_types(type_part)
                param_list.append(f'const A{self.snake_to_pascal(name_part)}: {type_part}')
        
        return '; '.join(param_list)
    
    def convert_file(self, input_file, output_file):
        with open(input_file, 'r') as f:
            content = f.read()
        
        content = self.convert_types(content)
        content = self.convert_operators(content)
        content = self.convert_function_declaration(content)
        
        with open(output_file, 'w') as f:
            f.write(content)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python3 c_to_cpascal.py input.c output.cpas")
        sys.exit(1)
    
    converter = CToColorPascalConverter()
    converter.convert_file(sys.argv[1], sys.argv[2])
    print(f"Conversion complete: {sys.argv[1]} -> {sys.argv[2]}")
    print("Manual review and testing required!")
```

### 7.3 Testing Strategies

#### 7.3.1 Binary Compatibility Testing

```cpascal
// test_compatibility.cpas
program TestCompatibility;

// Test that CPascal types match C types exactly
type
  TTestStruct = packed record
    A: Int32;
    B: Single;
    C: UInt16;
    D: UInt8;
  end;

// External C function that tests binary compatibility
function test_struct_layout(const AStruct: ^TTestStruct): Int32; external "test_lib";
function test_calling_convention(const A, B, C: Int32): Int32; external "test_lib";

var
  LTestStruct: TTestStruct;
  LResult: Int32;

begin
  // Test struct layout compatibility
  LTestStruct.A := $12345678;
  LTestStruct.B := 3.14159;
  LTestStruct.C := $ABCD;
  LTestStruct.D := $EF;
  
  LResult := test_struct_layout(@LTestStruct);
  if LResult <> 0 then
  begin
    printf("Struct layout test failed: %d\n", LResult);
    exit;
  end;
  
  // Test calling convention
  LResult := test_calling_convention(1, 2, 3);
  if LResult <> 6 then
  begin
    printf("Calling convention test failed: expected 6, got %d\n", LResult);
    exit;
  end;
  
  printf("All compatibility tests passed!\n");
end.
```

```c
// test_lib.c - Companion C library for testing
#include <stdint.h>
#include <stdio.h>

typedef struct {
    int32_t a;
    float b;
    uint16_t c;
    uint8_t d;
} test_struct_t;

int test_struct_layout(const test_struct_t* s) {
    printf("C sees: a=%08x, b=%f, c=%04x, d=%02x\n", 
           s->a, s->b, s->c, s->d);
    
    // Verify expected values
    if (s->a != 0x12345678) return 1;
    if (s->b < 3.14 || s->b > 3.15) return 2;
    if (s->c != 0xABCD) return 3;
    if (s->d != 0xEF) return 4;
    
    return 0;  // Success
}

int test_calling_convention(int a, int b, int c) {
    return a + b + c;
}
```

#### 7.3.2 Performance Testing

```cpascal
// benchmark.cpas
program Benchmark;

function GetTicks(): UInt64; external;

const
  ITERATIONS = 1000000;

type
  TTestData = packed record
    Values: array[0..999] of Int32;
  end;

// CPascal version of algorithm
function ProcessDataCPascal(var AData: TTestData): Int32;
var
  I, LSum: Int32;
begin
  LSum := 0;
  for I := 0 to 999 do
  begin
    AData.Values[I] := AData.Values[I] * 2 + 1;
    LSum += AData.Values[I];
  end;
  Result := LSum;
end;

// External C version for comparison
function ProcessDataC(var AData: TTestData): Int32; external "benchmark_lib";

var
  LData: TTestData;
  LStartTime, LEndTime: UInt64;
  LResult: Int32;
  I: Int32;

begin
  // Initialize test data
  for I := 0 to 999 do
    LData.Values[I] := I;
  
  // Benchmark CPascal version
  LStartTime := GetTicks();
  for I := 0 to ITERATIONS - 1 do
    LResult := ProcessDataCPascal(LData);
  LEndTime := GetTicks();
  
  printf("CPascal version: %d ticks, result: %d\n", 
         LEndTime - LStartTime, LResult);
  
  // Reset data
  for I := 0 to 999 do
    LData.Values[I] := I;
  
  // Benchmark C version
  LStartTime := GetTicks();
  for I := 0 to ITERATIONS - 1 do
    LResult := ProcessDataC(LData);
  LEndTime := GetTicks();
  
  printf("C version: %d ticks, result: %d\n", 
         LEndTime - LStartTime, LResult);
end.
```

---

## 8. Performance Considerations

### 8.1 Performance Comparison

#### 8.1.1 Optimization Levels

| Aspect | C | CPascal | Notes |
|--------|---|---------|-------|
| **Function Calls** | Direct | Direct | Identical overhead |
| **Memory Access** | Direct | Direct | Same pointer arithmetic |
| **Arithmetic** | Native | Native | Same instruction generation |
| **Inlining** | Compiler dependent | `inline` keyword | Explicit control |
| **Loop Optimization** | Yes | Yes | LLVM backend provides same optimizations |

#### 8.1.2 Potential Performance Differences

**Areas where CPascal might be slower:**
- Additional type checking (compile-time only)
- More verbose syntax (no runtime impact)
- Range checking (if enabled, usually disabled in release)

**Areas where CPascal might be faster:**
- Better inlining control with explicit `inline` keyword
- Clearer code leading to better optimization opportunities
- Reduced undefined behavior due to stricter typing

### 8.2 Optimization Techniques

#### 8.2.1 Aggressive Inlining

```cpascal
// High-frequency functions should be inlined
function DotProduct(const A, B: TVector3): Single; inline;
begin
  Result := A.X * B.X + A.Y * B.Y + A.Z * B.Z;
end;

function VectorLength(const A: TVector3): Single; inline;
begin
  Result := Sqrt(DotProduct(A, A));
end;

// Complex functions that benefit from inlining
function FastSin(const AX: Single): Single; inline;
const
  FRAC_PI_2 = 1.5707963267948966;
  FRAC_4_PI = 1.2732395447351627;
  FRAC_4_PI_2 = -0.40528473456935109;
var
  LY: Single;
begin
  LY := AX * FRAC_4_PI;
  if LY > 1.0 then
    LY := LY - 2.0
  else if LY < -1.0 then
    LY := LY + 2.0;
  Result := LY * (4.0 - Abs(LY));
  Result := Result * (0.225 * (Abs(Result) - 1.0) + 1.0);
end;
```

#### 8.2.2 Cache-Friendly Data Structures

```cpascal
// Bad: Array of Structures (AoS)
type
  TParticleAoS = packed record
    Position: TVector3;
    Velocity: TVector3;
    Life: Single;
    Active: Boolean;
  end;
  TParticleArrayAoS = array[0..9999] of TParticleAoS;

// Better: Structure of Arrays (SoA)  
type
  TParticlesSoA = packed record
    Positions: array[0..9999] of TVector3;
    Velocities: array[0..9999] of TVector3;
    Lives: array[0..9999] of Single;
    Active: array[0..9999] of Boolean;
    Count: Int32;
  end;

procedure UpdateParticlesSoA(var AParticles: TParticlesSoA; const ADeltaTime: Single);
var
  I: Int32;
begin
  // Cache-friendly: process each array sequentially
  for I := 0 to AParticles.Count - 1 do
  begin
    if AParticles.Active[I] then
    begin
      AParticles.Positions[I].X += AParticles.Velocities[I].X * ADeltaTime;
      AParticles.Positions[I].Y += AParticles.Velocities[I].Y * ADeltaTime;
      AParticles.Positions[I].Z += AParticles.Velocities[I].Z * ADeltaTime;
      
      AParticles.Lives[I] -= ADeltaTime;
      if AParticles.Lives[I] <= 0.0 then
        AParticles.Active[I] := false;
    end;
  end;
end;
```

#### 8.2.3 SIMD-Ready Code

```cpascal
// Structure data for SIMD operations
type
  TVector4 = packed record
    case Boolean of
      true: (X, Y, Z, W: Single);
      false: (Data: array[0..3] of Single);
  end;
  
  // Aligned arrays for SIMD
  TAlignedVectorArray = packed record
    Count: Int32;
    Vectors: array[0..1023] of TVector4;
  end;

// SIMD-friendly vector operations
procedure AddVectors4(const A, B: ^TVector4; const AResult: ^TVector4; const ACount: Int32);
var
  I: Int32;
begin
  // Compiler can vectorize this loop
  for I := 0 to ACount - 1 do
  begin
    AResult[I].X := A[I].X + B[I].X;
    AResult[I].Y := A[I].Y + B[I].Y;
    AResult[I].Z := A[I].Z + B[I].Z;
    AResult[I].W := A[I].W + B[I].W;
  end;
end;

// Manual SIMD with inline assembly
procedure AddVectors4SIMD(const A, B: ^TVector4; const AResult: ^TVector4; const ACount: Int32);
var
  I: Int32;
begin
  // Process 4 vectors at a time with SSE
  for I := 0 to (ACount div 4) - 1 do
  begin
    asm
      "movups (%1), %%xmm0"      // Load 4 floats from A
      "movups (%2), %%xmm1"      // Load 4 floats from B  
      "addps %%xmm1, %%xmm0"     // Add vectors
      "movups %%xmm0, (%0)"      // Store result
      :
      : "r" (@AResult[I * 4]), "r" (@A[I * 4]), "r" (@B[I * 4])
      : "xmm0", "xmm1", "memory"
    end;
  end;
  
  // Handle remaining vectors
  for I := (ACount div 4) * 4 to ACount - 1 do
  begin
    AResult[I].X := A[I].X + B[I].X;
    AResult[I].Y := A[I].Y + B[I].Y;
    AResult[I].Z := A[I].Z + B[I].Z;
    AResult[I].W := A[I].W + B[I].W;
  end;
end;
```

---

## 9. Integration Strategies

### 9.1 Gradual Migration Approach

#### 9.1.1 Phase 1: New Code in CPascal

```c
// Existing C code (keep as-is)
// graphics.c, audio.c, input.c

// New features in CPascal
// networking.cpas, ai.cpas, scripting.cpas
```

#### 9.1.2 Phase 2: Replace Utility Modules

```cpascal
// Replace C utilities with CPascal equivalents
module MathUtils;

// CPascal math functions that replace C math.h usage
public function FastSqrt(const AX: Single): Single; inline;
public function Lerp(const A, B, T: Single): Single; inline;
public function Clamp(const AValue, AMin, AMax: Single): Single; inline;

end.
```

#### 9.1.3 Phase 3: Core Module Migration

```cpascal
// Migrate core systems one by one
module RenderCore;

// Import existing C graphics functions
function glCreateShader(const AType: UInt32): UInt32; external;
function glShaderSource(const AShader: UInt32; const ACount: Int32; const AString: ^PChar; const ALength: ^Int32): void; external;

// New CPascal rendering pipeline
type
  TShader = packed record
    ID: UInt32;
    ShaderType: UInt32;
    Compiled: Boolean;
  end;

public function CreateShader(const ASource: PChar; const AType: UInt32): TShader;
begin
  Result.ID := glCreateShader(AType);
  Result.ShaderType := AType;
  
  glShaderSource(Result.ID, 1, @ASource, nil);
  glCompileShader(Result.ID);
  
  Result.Compiled := CheckShaderCompilation(Result.ID);
end;

end.
```

### 9.2 Mixed Language Builds

#### 9.2.1 Makefile Integration

```makefile
# Makefile supporting both C and CPascal
CC = gcc
CPASCAL = cpascal
CFLAGS = -Wall -O2 -fPIC
CPASCALFLAGS = -O2 -shared

# C source files
C_SOURCES = graphics.c audio.c input.c
C_OBJECTS = $(C_SOURCES:.c=.o)

# CPascal source files  
CPASCAL_SOURCES = main.cpas networking.cpas ai.cpas
CPASCAL_OBJECTS = $(CPASCAL_SOURCES:.cpas=.o)

# Final executable
game: $(C_OBJECTS) $(CPASCAL_OBJECTS)
	$(CPASCAL) -o game $(CPASCAL_OBJECTS) $(C_OBJECTS) -lSDL2 -lGL

# C compilation rules
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# CPascal compilation rules
%.o: %.cpas
	$(CPASCAL) $(CPASCALFLAGS) -c $< -o $@

clean:
	rm -f *.o game

.PHONY: clean
```

#### 9.2.2 CMake Integration

```cmake
# CMakeLists.txt for mixed C/CPascal project
cmake_minimum_required(VERSION 3.10)
project(MixedGame)

# Find CPascal compiler
find_program(CPASCAL_COMPILER cpascal)
if(NOT CPASCAL_COMPILER)
    message(FATAL_ERROR "CPascal compiler not found")
endif()

# C sources
set(C_SOURCES
    graphics.c
    audio.c
    input.c
)

# CPascal sources
set(CPASCAL_SOURCES
    main.cpas
    networking.cpas
    ai.cpas
)

# Add C library
add_library(game_core ${C_SOURCES})
target_link_libraries(game_core SDL2 GL)

# Custom command for CPascal compilation
foreach(CPASCAL_FILE ${CPASCAL_SOURCES})
    get_filename_component(CPASCAL_NAME ${CPASCAL_FILE} NAME_WE)
    set(CPASCAL_OBJ ${CMAKE_CURRENT_BINARY_DIR}/${CPASCAL_NAME}.o)
    
    add_custom_command(
        OUTPUT ${CPASCAL_OBJ}
        COMMAND ${CPASCAL_COMPILER} -c ${CMAKE_CURRENT_SOURCE_DIR}/${CPASCAL_FILE} -o ${CPASCAL_OBJ}
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${CPASCAL_FILE}
        COMMENT "Compiling CPascal file ${CPASCAL_FILE}"
    )
    
    list(APPEND CPASCAL_OBJECTS ${CPASCAL_OBJ})
endforeach()

# Create CPascal library
add_custom_target(cpascal_objects ALL DEPENDS ${CPASCAL_OBJECTS})

# Final executable linking both C and CPascal objects
add_executable(game ${CPASCAL_OBJECTS})
add_dependencies(game cpascal_objects)
target_link_libraries(game game_core)
```

### 9.3 API Boundary Management

#### 9.3.1 Clean Interface Definitions

```cpascal
// api_interface.cpas - Define clean boundaries between C and CPascal
module APIInterface;

// C functions we call from CPascal
function c_init_graphics(const AWidth, AHeight: Int32): Int32; external "graphics_lib";
function c_render_frame(): void; external "graphics_lib";
function c_cleanup_graphics(): void; external "graphics_lib";

// CPascal functions we export to C
public function cpascal_process_input(const AInputData: Pointer): Int32; export;
public function cpascal_update_ai(const ADeltaTime: Single): void; export;
public function cpascal_handle_network(): Int32; export;

// Implementation
function cpascal_process_input(const AInputData: Pointer): Int32;
var
  LInputState: ^TInputState;
begin
  LInputState := ^TInputState(AInputData);
  // Process input in CPascal
  Result := ProcessGameInput(LInputState^);
end;

end.
```

#### 9.3.2 Data Structure Marshaling

```cpascal
// marshaling.cpas - Handle data transfer between C and CPascal
module Marshaling;

// Shared data structures (C-compatible)
type
  TVector3C = packed record
    X, Y, Z: Single;
  end;
  
  TGameObjectC = packed record
    Position: TVector3C;
    Rotation: TVector3C;
    Scale: TVector3C;
    ID: UInt32;
    Active: UInt8;  // Use UInt8 instead of Boolean for C compatibility
  end;

// CPascal native structures (more type-safe)
type
  TVector3 = record
    X, Y, Z: Single;
  end;
  
  TGameObject = record
    Position: TVector3;
    Rotation: TVector3;
    Scale: TVector3;
    ID: UInt32;
    Active: Boolean;
  end;

// Conversion functions
function CToNative(const ACObj: TGameObjectC): TGameObject;
begin
  Result.Position.X := ACObj.Position.X;
  Result.Position.Y := ACObj.Position.Y; 
  Result.Position.Z := ACObj.Position.Z;
  Result.Rotation := TVector3(ACObj.Rotation);
  Result.Scale := TVector3(ACObj.Scale);
  Result.ID := ACObj.ID;
  Result.Active := ACObj.Active <> 0;
end;

function NativeToC(const ANativeObj: TGameObject): TGameObjectC;
begin
  Result.Position := TVector3C(ANativeObj.Position);
  Result.Rotation := TVector3C(ANativeObj.Rotation);
  Result.Scale := TVector3C(ANativeObj.Scale);
  Result.ID := ANativeObj.ID;
  Result.Active := (ANativeObj.Active) ? 1 : 0;
end;

end.
```

---

## 10. Troubleshooting Guide

### 10.1 Common Migration Issues

#### 10.1.1 Type-Related Problems

**Problem: Integer size mismatches**
```c
// C code
long value = 123456789L;
```

```cpascal
// Wrong - 'long' size is platform-dependent
var Value: Int32 = 123456789;  // May truncate on some platforms

// Correct - use explicit sized types
var Value: Int64 = 123456789;
```

**Problem: Pointer arithmetic differences**
```c
// C pointer arithmetic
int* ptr = array;
ptr += 5;  // Advances by 5 * sizeof(int)
```

```cpascal
// CPascal requires explicit sizing
var LPtr: ^Int32;
begin
  LPtr := @LArray[0];
  Inc(LPtr, 5);  // Correct way
  // OR
  LPtr := LPtr + 5;  // Also works
end;
```

**Problem: Boolean conversion**
```c
// C boolean context
int value = 42;
if (value) {  // Non-zero is true
    // ...
}
```

```cpascal
// CPascal requires explicit comparison
var LValue: Int32;
begin
  LValue := 42;
  if LValue <> 0 then  // Explicit comparison required
  begin
    // ...
  end;
end;
```

#### 10.1.2 Syntax Translation Issues

**Problem: Case sensitivity**
```c
// C (case-sensitive)
int Value;
int value;  // Different variable
```

```cpascal
// CPascal (also case-sensitive)
var
  Value: Int32;
  // value: Int32;  // Error: duplicate identifier
```

**Problem: Assignment vs equality**
```c
// C code
if (x = getValue()) {  // Assignment in condition
    // ...
}
```

```cpascal
// CPascal equivalent
var LX: Int32;
begin
  LX := GetValue();
  if LX <> 0 then  // Explicit comparison
  begin
    // ...
  end;
end;
```

**Problem: For loop differences**
```c
// C for loop
for (int i = 0; i < 10; i++) {
    // ...
}
```

```cpascal
// CPascal for loop
var I: Int32;
begin
  for I := 0 to 9 do  // Note: 'to 9' not 'to 10'
  begin
    // ...
  end;
end;
```

#### 10.1.3 Memory Management Issues

**Problem: Automatic vs manual memory management**
```c
// C code with automatic cleanup
void function() {
    char buffer[1024];  // Automatic cleanup
    // ...
}  // buffer automatically freed
```

```cpascal
// CPascal requires explicit management for dynamic memory
procedure SomeFunction();
var
  LBuffer: array[0..1023] of Char;  // Automatic (stack-allocated)
  LDynamicBuffer: ^Char;
begin
  // Stack allocation (automatic cleanup)
  // ... use LBuffer ...
  
  // Dynamic allocation (manual cleanup required)
  LDynamicBuffer := GetMem(1024);
  try
    // ... use LDynamicBuffer ...
  finally
    FreeMem(LDynamicBuffer);
  end;
end;
```

### 10.2 Debugging Strategies

#### 10.2.1 Binary Compatibility Verification

```cpascal
// debug_compat.cpas
program DebugCompatibility;

type
  TTestStruct = packed record
    IntField: Int32;
    FloatField: Single;
    CharField: Char;
    BoolField: Boolean;
  end;

// External C function for verification
function verify_struct_size(const ASize: NativeUInt): Int32; external "debug_lib";
function verify_struct_fields(const AStruct: ^TTestStruct): Int32; external "debug_lib";

var
  LTestStruct: TTestStruct;
  LResult: Int32;

begin
  // Verify struct size matches C expectation
  LResult := verify_struct_size(SizeOf(TTestStruct));
  if LResult <> 0 then
  begin
    printf("ERROR: Struct size mismatch. CPascal: %zu, Expected: %d\n", 
           SizeOf(TTestStruct), LResult);
    exit;
  end;
  
  // Verify field layout
  LTestStruct.IntField := $12345678;
  LTestStruct.FloatField := 3.14159;
  LTestStruct.CharField := #65;  // 'A'
  LTestStruct.BoolField := true;
  
  LResult := verify_struct_fields(@LTestStruct);
  if LResult <> 0 then
  begin
    printf("ERROR: Field layout mismatch at field %d\n", LResult);
    exit;
  end;
  
  printf("All compatibility checks passed!\n");
end.
```

```c
// debug_lib.c
#include <stdint.h>
#include <stdio.h>

typedef struct {
    int32_t int_field;
    float float_field;
    char char_field;
    bool bool_field;
} test_struct_t;

int verify_struct_size(size_t size) {
    size_t expected = sizeof(test_struct_t);
    if (size != expected) {
        return expected;  // Return expected size
    }
    return 0;  // Success
}

int verify_struct_fields(const test_struct_t* s) {
    if (s->int_field != 0x12345678) return 1;
    if (s->float_field < 3.14 || s->float_field > 3.15) return 2;
    if (s->char_field != 'A') return 3;
    if (!s->bool_field) return 4;
    return 0;  // Success
}
```

#### 10.2.2 Performance Profiling

```cpascal
// profiler.cpas
module Profiler;

type
  TProfileEntry = packed record
    Name: array[0..63] of Char;
    StartTime: UInt64;
    TotalTime: UInt64;
    CallCount: UInt32;
  end;

var
  GProfileEntries: array[0..99] of TProfileEntry;
  GProfileCount: Int32 = 0;

function GetHighPrecisionTime(): UInt64;
var
  LLow, LHigh: UInt32;
begin
  asm
    "rdtsc"
    : "=a" (LLow), "=d" (LHigh)
    :
    :
  end;
  Result := (UInt64(LHigh) shl 32) or UInt64(LLow);
end;

public procedure ProfileBegin(const AName: PChar);
var
  I: Int32;
  LEntry: ^TProfileEntry;
begin
  // Find existing entry or create new one
  for I := 0 to GProfileCount - 1 do
  begin
    if StrComp(@GProfileEntries[I].Name[0], AName) = 0 then
    begin
      GProfileEntries[I].StartTime := GetHighPrecisionTime();
      exit;
    end;
  end;
  
  // Create new entry
  if GProfileCount < 100 then
  begin
    LEntry := @GProfileEntries[GProfileCount];
    StrCopy(@LEntry^.Name[0], AName);
    LEntry^.StartTime := GetHighPrecisionTime();
    LEntry^.TotalTime := 0;
    LEntry^.CallCount := 0;
    Inc(GProfileCount);
  end;
end;

public procedure ProfileEnd(const AName: PChar);
var
  I: Int32;
  LEndTime: UInt64;
begin
  LEndTime := GetHighPrecisionTime();
  
  for I := 0 to GProfileCount - 1 do
  begin
    if StrComp(@GProfileEntries[I].Name[0], AName) = 0 then
    begin
      GProfileEntries[I].TotalTime += LEndTime - GProfileEntries[I].StartTime;
      Inc(GProfileEntries[I].CallCount);
      exit;
    end;
  end;
end;

public procedure ProfileReport();
var
  I: Int32;
  LEntry: ^TProfileEntry;
begin
  printf("Profile Report:\n");
  printf("%-20s %10s %10s %15s\n", "Function", "Calls", "Total", "Avg/Call");
  printf("------------------------------------------------------------\n");
  
  for I := 0 to GProfileCount - 1 do
  begin
    LEntry := @GProfileEntries[I];
    printf("%-20s %10u %10llu %15.2f\n",
           @LEntry^.Name[0],
           LEntry^.CallCount,
           LEntry^.TotalTime,
           Single(LEntry^.TotalTime) / LEntry^.CallCount);
  end;
end;

// External string functions
function StrComp(const AStr1, AStr2: PChar): Int32; external;
function StrCopy(const ADest, ASrc: PChar): PChar; external;

end.
```

#### 10.2.3 Memory Leak Detection

```cpascal
// memory_debug.cpas
module MemoryDebug;

type
  TAllocation = packed record
    Ptr: Pointer;
    Size: NativeUInt;
    FileName: PChar;
    LineNumber: Int32;
    Next: ^TAllocation;
  end;

var
  GAllocations: ^TAllocation = nil;
  GAllocationCount: Int32 = 0;
  GTotalAllocated: NativeUInt = 0;

function DebugGetMem(const ASize: NativeUInt; const AFileName: PChar; const ALine: Int32): Pointer;
var
  LAlloc: ^TAllocation;
  LPtr: Pointer;
begin
  LPtr := GetMem(ASize);
  if LPtr = nil then
    exit(nil);
  
  LAlloc := GetMem(SizeOf(TAllocation));
  if LAlloc <> nil then
  begin
    LAlloc^.Ptr := LPtr;
    LAlloc^.Size := ASize;
    LAlloc^.FileName := AFileName;
    LAlloc^.LineNumber := ALine;
    LAlloc^.Next := GAllocations;
    GAllocations := LAlloc;
    Inc(GAllocationCount);
    GTotalAllocated += ASize;
  end;
  
  Result := LPtr;
end;

procedure DebugFreeMem(const APtr: Pointer);
var
  LCurrent, LPrev: ^TAllocation;
begin
  LPrev := nil;
  LCurrent := GAllocations;
  
  while LCurrent <> nil do
  begin
    if LCurrent^.Ptr = APtr then
    begin
      // Remove from list
      if LPrev <> nil then
        LPrev^.Next := LCurrent^.Next
      else
        GAllocations := LCurrent^.Next;
      
      GTotalAllocated -= LCurrent^.Size;
      Dec(GAllocationCount);
      
      FreeMem(LCurrent);
      FreeMem(APtr);
      exit;
    end;
    
    LPrev := LCurrent;
    LCurrent := LCurrent^.Next;
  end;
  
  printf("WARNING: Attempt to free untracked pointer %p\n", APtr);
end;

public procedure ReportLeaks();
var
  LCurrent: ^TAllocation;
begin
  if GAllocationCount = 0 then
  begin
    printf("No memory leaks detected.\n");
    exit;
  end;
  
  printf("MEMORY LEAKS DETECTED:\n");
  printf("Total leaked: %zu bytes in %d allocations\n", 
         GTotalAllocated, GAllocationCount);
  printf("\nLeak details:\n");
  
  LCurrent := GAllocations;
  while LCurrent <> nil do
  begin
    printf("  %p: %zu bytes allocated at %s:%d\n",
           LCurrent^.Ptr, LCurrent^.Size, 
           LCurrent^.FileName, LCurrent^.LineNumber);
    LCurrent := LCurrent^.Next;
  end;
end;

end.

// Usage macros (would be implemented as compiler intrinsics)
// #define DEBUG_GETMEM(size) DebugGetMem(size, __FILE__, __LINE__)
// #define DEBUG_FREEMEM(ptr) DebugFreeMem(ptr)
```

### 10.3 Migration Validation

#### 10.3.1 Functional Equivalence Testing

```cpascal
// validation.cpas
program ValidationSuite;

import OriginalCLib, MigratedCPascalLib;

type
  TTestCase = packed record
    Name: array[0..63] of Char;
    InputData: Pointer;
    InputSize: NativeUInt;
    ExpectedOutput: Pointer;
    ExpectedSize: NativeUInt;
  end;

function RunValidationTest(const ATestCase: ^TTestCase): Boolean;
var
  LCResult, LCPascalResult: Pointer;
  LCResultSize, LCPascalResultSize: NativeUInt;
begin
  // Run original C version
  LCResult := OriginalCLib.ProcessData(ATestCase^.InputData, ATestCase^.InputSize, @LCResultSize);
  
  // Run migrated CPascal version
  LCPascalResult := MigratedCPascalLib.ProcessData(ATestCase^.InputData, ATestCase^.InputSize, @LCPascalResultSize);
  
  // Compare results
  if LCResultSize <> LCPascalResultSize then
  begin
    printf("FAIL: %s - Size mismatch (C: %zu, CPascal: %zu)\n", 
           @ATestCase^.Name[0], LCResultSize, LCPascalResultSize);
    Result := false;
    exit;
  end;
  
  if memcmp(LCResult, LCPascalResult, LCResultSize) <> 0 then
  begin
    printf("FAIL: %s - Data mismatch\n", @ATestCase^.Name[0]);
    Result := false;
    exit;
  end;
  
  printf("PASS: %s\n", @ATestCase^.Name[0]);
  Result := true;
end;

// External memory comparison
function memcmp(const A, B: Pointer; const ASize: NativeUInt): Int32; external;

var
  LTestCases: array[0..9] of TTestCase;
  LTestCount: Int32;
  I, LPassed: Int32;

begin
  // Initialize test cases
  // ... (setup test data)
  
  LPassed := 0;
  for I := 0 to LTestCount - 1 do
  begin
    if RunValidationTest(@LTestCases[I]) then
      Inc(LPassed);
  end;
  
  printf("\nValidation Results: %d/%d tests passed\n", LPassed, LTestCount);
  
  if LPassed = LTestCount then
    printf("All tests passed! Migration appears successful.\n")
  else
    printf("Some tests failed. Review migration implementation.\n");
end.
```

## 7. Tooling and Workflow

### 7.1 Migration Checklist

#### 7.1.1 Pre-Migration Assessment

- [ ] **Code Analysis**
  - [ ] Identify external dependencies
  - [ ] List platform-specific code sections
  - [ ] Count lines of code (LoC) estimate
  - [ ] Document complex pointer arithmetic
  - [ ] Note inline assembly usage

- [ ] **Risk Assessment** 
  - [ ] Performance-critical sections identified
  - [ ] Thread-safety requirements documented
  - [ ] Memory allocation patterns analyzed
  - [ ] External API compatibility verified

- [ ] **Testing Strategy**
  - [ ] Unit tests exist or can be created
  - [ ] Integration test plan defined
  - [ ] Performance benchmarks established
  - [ ] Regression test suite prepared

#### 7.1.2 Migration Phase Checklist

- [ ] **Setup Phase**
  - [ ] CPascal compiler installed and tested
  - [ ] Build system configured
  - [ ] External libraries linked successfully
  - [ ] Basic "Hello World" compiles and runs

- [ ] **Code Conversion**
  - [ ] Header files converted to external declarations
  - [ ] Type definitions migrated
  - [ ] Simple functions converted first
  - [ ] Complex functions converted incrementally
  - [ ] Inline assembly converted (if any)

- [ ] **Testing Phase**
  - [ ] Unit tests pass
  - [ ] Integration tests pass
  - [ ] Performance benchmarks meet requirements
  - [ ] Memory leak testing completed
  - [ ] Cross-platform testing (if applicable)

### 7.2 Automated Conversion Tools

#### 7.2.1 Simple Text Processing Script

```bash
#!/bin/bash
# c_to_cpascal.sh - Basic C to CPascal conversion

# Convert basic type names
sed -i 's/\bint\b/Int32/g' "$1"
sed -i 's/\bfloat\b/Single/g' "$1"
sed -i 's/\bdouble\b/Double/g' "$1"
sed -i 's/\bchar\b/Char/g' "$1"
sed -i 's/\bvoid\*/Pointer/g' "$1"

# Convert operators
sed -i 's/==/=/g' "$1"
sed -i 's/!=/\<\>/g' "$1"
sed -i 's/&&/and/g' "$1"
sed -i 's/||/or/g' "$1"
sed -i 's/!/not /g' "$1"

# Convert control structures
sed -i 's/if (/if /g' "$1"
sed -i 's/) {/then/g' "$1"
sed -i 's/} else {/else/g' "$1"
sed -i 's/}/end;/g' "$1"

echo "Basic conversion complete. Manual review required."
```

#### 7.2.2 Python Conversion Script

```python
#!/usr/bin/env python3
# c_to_cpascal.py - More sophisticated conversion

import re
import sys

class CToColorPascalConverter:
    def __init__(self):
        self.type_map = {
            'int': 'Int32',
            'short': 'Int16', 
            'long': 'Int32',
            'long long': 'Int64',
            'unsigned int': 'UInt32',
            'unsigned short': 'UInt16',
            'unsigned long': 'UInt32',
            'unsigned long long': 'UInt64',
            'float': 'Single',
            'double': 'Double',
            'char': 'Char',
            'unsigned char': 'UInt8',
            'signed char': 'Int8',
            'void*': 'Pointer',
            'size_t': 'NativeUInt',
            'ssize_t': 'NativeInt'
        }
        
        self.operator_map = {
            '==': '=',
            '!=': '<>',
            '&&': ' and ',
            '||': ' or ',
            '!': 'not ',
            '<<': ' shl ',
            '>>': ' shr '
        }
    
    def convert_types(self, text):
        for c_type, pascal_type in self.type_map.items():
            text = re.sub(r'\b' + re.escape(c_type) + r'\b', pascal_type, text)
        return text
    
    def convert_operators(self, text):
        for c_op, pascal_op in self.operator_map.items():
            text = text.replace(c_op, pascal_op)
        return text
    
    def convert_function_declaration(self, text):
        # Convert: int function_name(params) to function FunctionName(params): Int32;
        pattern = r'(\w+)\s+(\w+)\s*\((.*?)\)\s*\{'
        def replace_func(match):
            return_type = self.convert_types(match.group(1))
            func_name = self.snake_to_pascal(match.group(2))
            params = self.convert_parameters(match.group(3))
            return f'function {func_name}({params}): {return_type};\nbegin'
        
        return re.sub(pattern, replace_func, text)
    
    def snake_to_pascal(self, name):
        return ''.join(word.capitalize() for word in name.split('_'))
    
    def convert_parameters(self, params):
        if not params.strip():
            return ''
        
        param_list = []
        for param in params.split(','):
            param = param.strip()
            parts = param.split()
            if len(parts) >= 2:
                type_part = ' '.join(parts[:-1])
                name_part = parts[-1]
                # Remove pointer stars from name
                name_part = name_part.lstrip('*')
                type_part = self.convert_types(type_part)
                param_list.append(f'const A{self.snake_to_pascal(name_part)}: {type_part}')
        
        return '; '.join(param_list)
    
    def convert_file(self, input_file, output_file):
        with open(input_file, 'r') as f:
            content = f.read()
        
        content = self.convert_types(content)
        content = self.convert_operators(content)
        content = self.convert_function_declaration(content)
        
        with open(output_file, 'w') as f:
            f.write(content)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python3 c_to_cpascal.py input.c output.cpas")
        sys.exit(1)
    
    converter = CToColorPascalConverter()
    converter.convert_file(sys.argv[1], sys.argv[2])
    print(f"Conversion complete: {sys.argv[1]} -> {sys.argv[2]}")
    print("Manual review and testing required!")
```

### 7.3 Testing Strategies

#### 7.3.1 Binary Compatibility Testing

```cpascal
// test_compatibility.cpas
program TestCompatibility;

// Test that CPascal types match C types exactly
type
  TTestStruct = packed record
    A: Int32;
    B: Single;
    C: UInt16;
    D: UInt8;
  end;

// External C function that tests binary compatibility
function test_struct_layout(const AStruct: ^TTestStruct): Int32; external "test_lib";
function test_calling_convention(const A, B, C: Int32): Int32; external "test_lib";

var
  LTestStruct: TTestStruct;
  LResult: Int32;

begin
  // Test struct layout compatibility
  LTestStruct.A := $12345678;
  LTestStruct.B := 3.14159;
  LTestStruct.C := $ABCD;
  LTestStruct.D := $EF;
  
  LResult := test_struct_layout(@LTestStruct);
  if LResult <> 0 then
  begin
    printf("Struct layout test failed: %d\n", LResult);
    exit;
  end;
  
  // Test calling convention
  LResult := test_calling_convention(1, 2, 3);
  if LResult <> 6 then
  begin
    printf("Calling convention test failed: expected 6, got %d\n", LResult);
    exit;
  end;
  
  printf("All compatibility tests passed!\n");
end.
```

```c
// test_lib.c - Companion C library for testing
#include <stdint.h>
#include <stdio.h>

typedef struct {
    int32_t a;
    float b;
    uint16_t c;
    uint8_t d;
} test_struct_t;

int test_struct_layout(const test_struct_t* s) {
    printf("C sees: a=%08x, b=%f, c=%04x, d=%02x\n", 
           s->a, s->b, s->c, s->d);
    
    // Verify expected values
    if (s->a != 0x12345678) return 1;
    if (s->b < 3.14 || s->b > 3.15) return 2;
    if (s->c != 0xABCD) return 3;
    if (s->d != 0xEF) return 4;
    
    return 0;  // Success
}

int test_calling_convention(int a, int b, int c) {
    return a + b + c;
}
```

#### 7.3.2 Performance Testing

```cpascal
// benchmark.cpas
program Benchmark;

function GetTicks(): UInt64; external;

const
  ITERATIONS = 1000000;

type
  TTestData = packed record
    Values: array[0..999] of Int32;
  end;

// CPascal version of algorithm
function ProcessDataCPascal(var AData: TTestData): Int32;
var
  I, LSum: Int32;
begin
  LSum := 0;
  for I := 0 to 999 do
  begin
    AData.Values[I] := AData.Values[I] * 2 + 1;
    LSum += AData.Values[I];
  end;
  Result := LSum;
end;

// External C version for comparison
function ProcessDataC(var AData: TTestData): Int32; external "benchmark_lib";

var
  LData: TTestData;
  LStartTime, LEndTime: UInt64;
  LResult: Int32;
  I: Int32;

begin
  // Initialize test data
  for I := 0 to 999 do
    LData.Values[I] := I;
  
  // Benchmark CPascal version
  LStartTime := GetTicks();
  for I := 0 to ITERATIONS - 1 do
    LResult := ProcessDataCPascal(LData);
  LEndTime := GetTicks();
  
  printf("CPascal version: %d ticks, result: %d\n", 
         LEndTime - LStartTime, LResult);
  
  // Reset data
  for I := 0 to 999 do
    LData.Values[I] := I;
  
  // Benchmark C version
  LStartTime := GetTicks();
  for I := 0 to ITERATIONS - 1 do
    LResult := ProcessDataC(LData);
  LEndTime := GetTicks();
  
  printf("C version: %d ticks, result: %d\n", 
         LEndTime - LStartTime, LResult);
end.
```

---

## 8. Performance Considerations

### 8.1 Performance Comparison

#### 8.1.1 Optimization Levels

| Aspect | C | CPascal | Notes |
|--------|---|---------|-------|
| **Function Calls** | Direct | Direct | Identical overhead |
| **Memory Access** | Direct | Direct | Same pointer arithmetic |
| **Arithmetic** | Native | Native | Same instruction generation |
| **Inlining** | Compiler dependent | `inline` keyword | Explicit control |
| **Loop Optimization** | Yes | Yes | LLVM backend provides same optimizations |

#### 8.1.2 Potential Performance Differences

**Areas where CPascal might be slower:**
- Additional type checking (compile-time only)
- More verbose syntax (no runtime impact)
- Range checking (if enabled, usually disabled in release)

**Areas where CPascal might be faster:**
- Better inlining control with explicit `inline` keyword
- Clearer code leading to better optimization opportunities
- Reduced undefined behavior due to stricter typing

### 8.2 Optimization Techniques

#### 8.2.1 Aggressive Inlining

```cpascal
// High-frequency functions should be inlined
function DotProduct(const A, B: TVector3): Single; inline;
begin
  Result := A.X * B.X + A.Y * B.Y + A.Z * B.Z;
end;

function VectorLength(const A: TVector3): Single; inline;
begin
  Result := Sqrt(DotProduct(A, A));
end;

// Complex functions that benefit from inlining
function FastSin(const AX: Single): Single; inline;
const
  FRAC_PI_2 = 1.5707963267948966;
  FRAC_4_PI = 1.2732395447351627;
  FRAC_4_PI_2 = -0.40528473456935109;
var
  LY: Single;
begin
  LY := AX * FRAC_4_PI;
  if LY > 1.0 then
    LY := LY - 2.0
  else if LY < -1.0 then
    LY := LY + 2.0;
  Result := LY * (4.0 - Abs(LY));
  Result := Result * (0.225 * (Abs(Result) - 1.0) + 1.0);
end;
```

#### 8.2.2 Cache-Friendly Data Structures

```cpascal
// Bad: Array of Structures (AoS)
type
  TParticleAoS = packed record
    Position: TVector3;
    Velocity: TVector3;
    Life: Single;
    Active: Boolean;
  end;
  TParticleArrayAoS = array[0..9999] of TParticleAoS;

// Better: Structure of Arrays (SoA)  
type
  TParticlesSoA = packed record
    Positions: array[0..9999] of TVector3;
    Velocities: array[0..9999] of TVector3;
    Lives: array[0..9999] of Single;
    Active: array[0..9999] of Boolean;
    Count: Int32;
  end;

procedure UpdateParticlesSoA(var AParticles: TParticlesSoA; const ADeltaTime: Single);
var
  I: Int32;
begin
  // Cache-friendly: process each array sequentially
  for I := 0 to AParticles.Count - 1 do
  begin
    if AParticles.Active[I] then
    begin
      AParticles.Positions[I].X += AParticles.Velocities[I].X * ADeltaTime;
      AParticles.Positions[I].Y += AParticles.Velocities[I].Y * ADeltaTime;
      AParticles.Positions[I].Z += AParticles.Velocities[I].Z * ADeltaTime;
      
      AParticles.Lives[I] -= ADeltaTime;
      if AParticles.Lives[I] <= 0.0 then
        AParticles.Active[I] := false;
    end;
  end;
end;
```

#### 8.2.3 SIMD-Ready Code

```cpascal
// Structure data for SIMD operations
type
  TVector4 = packed record
    case Boolean of
      true: (X, Y, Z, W: Single);
      false: (Data: array[0..3] of Single);
  end;
  
  // Aligned arrays for SIMD
  TAlignedVectorArray = packed record
    Count: Int32;
    Vectors: array[0..1023] of TVector4;
  end;

// SIMD-friendly vector operations
procedure AddVectors4(const A, B: ^TVector4; const AResult: ^TVector4; const ACount: Int32);
var
  I: Int32;
begin
  // Compiler can vectorize this loop
  for I := 0 to ACount - 1 do
  begin
    AResult[I].X := A[I].X + B[I].X;
    AResult[I].Y := A[I].Y + B[I].Y;
    AResult[I].Z := A[I].Z + B[I].Z;
    AResult[I].W := A[I].W + B[I].W;
  end;
end;

// Manual SIMD with inline assembly
procedure AddVectors4SIMD(const A, B: ^TVector4; const AResult: ^TVector4; const ACount: Int32);
var
  I: Int32;
begin
  // Process 4 vectors at a time with SSE
  for I := 0 to (ACount div 4) - 1 do
  begin
    asm
      "movups (%1), %%xmm0"      // Load 4 floats from A
      "movups (%2), %%xmm1"      // Load 4 floats from B  
      "addps %%xmm1, %%xmm0"     // Add vectors
      "movups %%xmm0, (%0)"      // Store result
      :
      : "r" (@AResult[I * 4]), "r" (@A[I * 4]), "r" (@B[I * 4])
      : "xmm0", "xmm1", "memory"
    end;
  end;
  
  // Handle remaining vectors
  for I := (ACount div 4) * 4 to ACount - 1 do
  begin
    AResult[I].X := A[I].X + B[I].X;
    AResult[I].Y := A[I].Y + B[I].Y;
    AResult[I].Z := A[I].Z + B[I].Z;
    AResult[I].W := A[I].W + B[I].W;
  end;
end;
```

---

## 9. Integration Strategies

### 9.1 Gradual Migration Approach

#### 9.1.1 Phase 1: New Code in CPascal

```c
// Existing C code (keep as-is)
// graphics.c, audio.c, input.c

// New features in CPascal
// networking.cpas, ai.cpas, scripting.cpas
```

#### 9.1.2 Phase 2: Replace Utility Modules

```cpascal
// Replace C utilities with CPascal equivalents
module MathUtils;

// CPascal math functions that replace C math.h usage
public function FastSqrt(const AX: Single): Single; inline;
public function Lerp(const A, B, T: Single): Single; inline;
public function Clamp(const AValue, AMin, AMax: Single): Single; inline;

end.
```

#### 9.1.3 Phase 3: Core Module Migration

```cpascal
// Migrate core systems one by one
module RenderCore;

// Import existing C graphics functions
function glCreateShader(const AType: UInt32): UInt32; external;
function glShaderSource(const AShader: UInt32; const ACount: Int32; const AString: ^PChar; const ALength: ^Int32): void; external;

// New CPascal rendering pipeline
type
  TShader = packed record
    ID: UInt32;
    ShaderType: UInt32;
    Compiled: Boolean;
  end;

public function CreateShader(const ASource: PChar; const AType: UInt32): TShader;
begin
  Result.ID := glCreateShader(AType);
  Result.ShaderType := AType;
  
  glShaderSource(Result.ID, 1, @ASource, nil);
  glCompileShader(Result.ID);
  
  Result.Compiled := CheckShaderCompilation(Result.ID);
end;

end.
```

### 9.2 Mixed Language Builds

#### 9.2.1 Makefile Integration

```makefile
# Makefile supporting both C and CPascal
CC = gcc
CPASCAL = cpascal
CFLAGS = -Wall -O2 -fPIC
CPASCALFLAGS = -O2 -shared

# C source files
C_SOURCES = graphics.c audio.c input.c
C_OBJECTS = $(C_SOURCES:.c=.o)

# CPascal source files  
CPASCAL_SOURCES = main.cpas networking.cpas ai.cpas
CPASCAL_OBJECTS = $(CPASCAL_SOURCES:.cpas=.o)

# Final executable
game: $(C_OBJECTS) $(CPASCAL_OBJECTS)
	$(CPASCAL) -o game $(CPASCAL_OBJECTS) $(C_OBJECTS) -lSDL2 -lGL

# C compilation rules
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# CPascal compilation rules
%.o: %.cpas
	$(CPASCAL) $(CPASCALFLAGS) -c $< -o $@

clean:
	rm -f *.o game

.PHONY: clean
```

#### 9.2.2 CMake Integration

```cmake
# CMakeLists.txt for mixed C/CPascal project
cmake_minimum_required(VERSION 3.10)
project(MixedGame)

# Find CPascal compiler
find_program(CPASCAL_COMPILER cpascal)
if(NOT CPASCAL_COMPILER)
    message(FATAL_ERROR "CPascal compiler not found")
endif()

# C sources
set(C_SOURCES
    graphics.c
    audio.c
    input.c
)

# CPascal sources
set(CPASCAL_SOURCES
    main.cpas
    networking.cpas
    ai.cpas
)

# Add C library
add_library(game_core ${C_SOURCES})
target_link_libraries(game_core SDL2 GL)

# Custom command for CPascal compilation
foreach(CPASCAL_FILE ${CPASCAL_SOURCES})
    get_filename_component(CPASCAL_NAME ${CPASCAL_FILE} NAME_WE)
    set(CPASCAL_OBJ ${CMAKE_CURRENT_BINARY_DIR}/${CPASCAL_NAME}.o)
    
    add_custom_command(
        OUTPUT ${CPASCAL_OBJ}
        COMMAND ${CPASCAL_COMPILER} -c ${CMAKE_CURRENT_SOURCE_DIR}/${CPASCAL_FILE} -o ${CPASCAL_OBJ}
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${CPASCAL_FILE}
        COMMENT "Compiling CPascal file ${CPASCAL_FILE}"
    )
    
    list(APPEND CPASCAL_OBJECTS ${CPASCAL_OBJ})
endforeach()

# Create CPascal library
add_custom_target(cpascal_objects ALL DEPENDS ${CPASCAL_OBJECTS})

# Final executable linking both C and CPascal objects
add_executable(game ${CPASCAL_OBJECTS})
add_dependencies(game cpascal_objects)
target_link_libraries(game game_core)
```

### 9.3 API Boundary Management

#### 9.3.1 Clean Interface Definitions

```cpascal
// api_interface.cpas - Define clean boundaries between C and CPascal
module APIInterface;

// C functions we call from CPascal
function c_init_graphics(const AWidth, AHeight: Int32): Int32; external "graphics_lib";
function c_render_frame(): void; external "graphics_lib";
function c_cleanup_graphics(): void; external "graphics_lib";

// CPascal functions we export to C
public function cpascal_process_input(const AInputData: Pointer): Int32; export;
public function cpascal_update_ai(const ADeltaTime: Single): void; export;
public function cpascal_handle_network(): Int32; export;

// Implementation
function cpascal_process_input(const AInputData: Pointer): Int32;
var
  LInputState: ^TInputState;
begin
  LInputState := ^TInputState(AInputData);
  // Process input in CPascal
  Result := ProcessGameInput(LInputState^);
end;

end.
```

#### 9.3.2 Data Structure Marshaling

```cpascal
// marshaling.cpas - Handle data transfer between C and CPascal
module Marshaling;

// Shared data structures (C-compatible)
type
  TVector3C = packed record
    X, Y, Z: Single;
  end;
  
  TGameObjectC = packed record
    Position: TVector3C;
    Rotation: TVector3C;
    Scale: TVector3C;
    ID: UInt32;
    Active: UInt8;  // Use UInt8 instead of Boolean for C compatibility
  end;

// CPascal native structures (more type-safe)
type
  TVector3 = record
    X, Y, Z: Single;
  end;
  
  TGameObject = record
    Position: TVector3;
    Rotation: TVector3;
    Scale: TVector3;
    ID: UInt32;
    Active: Boolean;
  end;

// Conversion functions
function CToNative(const ACObj: TGameObjectC): TGameObject;
begin
  Result.Position.X := ACObj.Position.X;
  Result.Position.Y := ACObj.Position.Y; 
  Result.Position.Z := ACObj.Position.Z;
  Result.Rotation := TVector3(ACObj.Rotation);
  Result.Scale := TVector3(ACObj.Scale);
  Result.ID := ACObj.ID;
  Result.Active := ACObj.Active <> 0;
end;

function NativeToC(const ANativeObj: TGameObject): TGameObjectC;
begin
  Result.Position := TVector3C(ANativeObj.Position);
  Result.Rotation := TVector3C(ANativeObj.Rotation);
  Result.Scale := TVector3C(ANativeObj.Scale);
  Result.ID := ANativeObj.ID;
  Result.Active := (ANativeObj.Active) ? 1 : 0;
end;

end.
```

---

## 10. Troubleshooting Guide

### 10.1 Common Migration Issues

#### 10.1.1 Type-Related Problems

**Problem: Integer size mismatches**
```c
// C code
long value = 123456789L;
```

```cpascal
// Wrong - 'long' size is platform-dependent
var Value: Int32 = 123456789;  // May truncate on some platforms

// Correct - use explicit sized types
var Value: Int64 = 123456789;
```

**Problem: Pointer arithmetic differences**
```c
// C pointer arithmetic
int* ptr = array;
ptr += 5;  // Advances by 5 * sizeof(int)
```

```cpascal
// CPascal requires explicit sizing
var LPtr: ^Int32;
begin
  LPtr := @LArray[0];
  Inc(LPtr, 5);  // Correct way
  // OR
  LPtr := LPtr + 5;  // Also works
end;
```

**Problem: Boolean conversion**
```c
// C boolean context
int value = 42;
if (value) {  // Non-zero is true
    // ...
}
```

```cpascal
// CPascal requires explicit comparison
var LValue: Int32;
begin
  LValue := 42;
  if LValue <> 0 then  // Explicit comparison required
  begin
    // ...
  end;
end;
```

#### 10.1.2 Syntax Translation Issues

**Problem: Case sensitivity**
```c
// C (case-sensitive)
int Value;
int value;  // Different variable
```

```cpascal
// CPascal (also case-sensitive)
var
  Value: Int32;
  // value: Int32;  // Error: duplicate identifier
```

**Problem: Assignment vs equality**
```c
// C code
if (x = getValue()) {  // Assignment in condition
    // ...
}
```

```cpascal
// CPascal equivalent
var LX: Int32;
begin
  LX := GetValue();
  if LX <> 0 then  // Explicit comparison
  begin
    // ...
  end;
end;
```

**Problem: For loop differences**
```c
// C for loop
for (int i = 0; i < 10; i++) {
    // ...
}
```

```cpascal
// CPascal for loop
var I: Int32;
begin
  for I := 0 to 9 do  // Note: 'to 9' not 'to 10'
  begin
    // ...
  end;
end;
```

#### 10.1.3 Memory Management Issues

**Problem: Automatic vs manual memory management**
```c
// C code with automatic cleanup
void function() {
    char buffer[1024];  // Automatic cleanup
    // ...
}  // buffer automatically freed
```

```cpascal
// CPascal requires explicit management for dynamic memory
procedure SomeFunction();
var
  LBuffer: array[0..1023] of Char;  // Automatic (stack-allocated)
  LDynamicBuffer: ^Char;
begin
  // Stack allocation (automatic cleanup)
  // ... use LBuffer ...
  
  // Dynamic allocation (manual cleanup required)
  LDynamicBuffer := GetMem(1024);
  try
    // ... use LDynamicBuffer ...
  finally
    FreeMem(LDynamicBuffer);
  end;
end;
```

### 10.2 Debugging Strategies

#### 10.2.1 Binary Compatibility Verification

```cpascal
// debug_compat.cpas
program DebugCompatibility;

type
  TTestStruct = packed record
    IntField: Int32;
    FloatField: Single;
    CharField: Char;
    BoolField: Boolean;
  end;

// External C function for verification
function verify_struct_size(const ASize: NativeUInt): Int32; external "debug_lib";
function verify_struct_fields(const AStruct: ^TTestStruct): Int32; external "debug_lib";

var
  LTestStruct: TTestStruct;
  LResult: Int32;

begin
  // Verify struct size matches C expectation
  LResult := verify_struct_size(SizeOf(TTestStruct));
  if LResult <> 0 then
  begin
    printf("ERROR: Struct size mismatch. CPascal: %zu, Expected: %d\n", 
           SizeOf(TTestStruct), LResult);
    exit;
  end;
  
  // Verify field layout
  LTestStruct.IntField := $12345678;
  LTestStruct.FloatField := 3.14159;
  LTestStruct.CharField := #65;  // 'A'
  LTestStruct.BoolField := true;
  
  LResult := verify_struct_fields(@LTestStruct);
  if LResult <> 0 then
  begin
    printf("ERROR: Field layout mismatch at field %d\n", LResult);
    exit;
  end;
  
  printf("All compatibility checks passed!\n");
end.
```

```c
// debug_lib.c
#include <stdint.h>
#include <stdio.h>

typedef struct {
    int32_t int_field;
    float float_field;
    char char_field;
    bool bool_field;
} test_struct_t;

int verify_struct_size(size_t size) {
    size_t expected = sizeof(test_struct_t);
    if (size != expected) {
        return expected;  // Return expected size
    }
    return 0;  // Success
}

int verify_struct_fields(const test_struct_t* s) {
    if (s->int_field != 0x12345678) return 1;
    if (s->float_field < 3.14 || s->float_field > 3.15) return 2;
    if (s->char_field != 'A') return 3;
    if (!s->bool_field) return 4;
    return 0;  // Success
}
```

#### 10.2.2 Performance Profiling

```cpascal
// profiler.cpas
module Profiler;

type
  TProfileEntry = packed record
    Name: array[0..63] of Char;
    StartTime: UInt64;
    TotalTime: UInt64;
    CallCount: UInt32;
  end;

var
  GProfileEntries: array[0..99] of TProfileEntry;
  GProfileCount: Int32 = 0;

function GetHighPrecisionTime(): UInt64;
var
  LLow, LHigh: UInt32;
begin
  asm
    "rdtsc"
    : "=a" (LLow), "=d" (LHigh)
    :
    :
  end;
  Result := (UInt64(LHigh) shl 32) or UInt64(LLow);
end;

public procedure ProfileBegin(const AName: PChar);
var
  I: Int32;
  LEntry: ^TProfileEntry;
begin
  // Find existing entry or create new one
  for I := 0 to GProfileCount - 1 do
  begin
    if StrComp(@GProfileEntries[I].Name[0], AName) = 0 then
    begin
      GProfileEntries[I].StartTime := GetHighPrecisionTime();
      exit;
    end;
  end;
  
  // Create new entry
  if GProfileCount < 100 then
  begin
    LEntry := @GProfileEntries[GProfileCount];
    StrCopy(@LEntry^.Name[0], AName);
    LEntry^.StartTime := GetHighPrecisionTime();
    LEntry^.TotalTime := 0;
    LEntry^.CallCount := 0;
    Inc(GProfileCount);
  end;
end;

public procedure ProfileEnd(const AName: PChar);
var
  I: Int32;
  LEndTime: UInt64;
begin
  LEndTime := GetHighPrecisionTime();
  
  for I := 0 to GProfileCount - 1 do
  begin
    if StrComp(@GProfileEntries[I].Name[0], AName) = 0 then
    begin
      GProfileEntries[I].TotalTime += LEndTime - GProfileEntries[I].StartTime;
      Inc(GProfileEntries[I].CallCount);
      exit;
    end;
  end;
end;

public procedure ProfileReport();
var
  I: Int32;
  LEntry: ^TProfileEntry;
begin
  printf("Profile Report:\n");
  printf("%-20s %10s %10s %15s\n", "Function", "Calls", "Total", "Avg/Call");
  printf("------------------------------------------------------------\n");
  
  for I := 0 to GProfileCount - 1 do
  begin
    LEntry := @GProfileEntries[I];
    printf("%-20s %10u %10llu %15.2f\n",
           @LEntry^.Name[0],
           LEntry^.CallCount,
           LEntry^.TotalTime,
           Single(LEntry^.TotalTime) / LEntry^.CallCount);
  end;
end;

// External string functions
function StrComp(const AStr1, AStr2: PChar): Int32; external;
function StrCopy(const ADest, ASrc: PChar): PChar; external;

end.
```

#### 10.2.3 Memory Leak Detection

```cpascal
// memory_debug.cpas
module MemoryDebug;

type
  TAllocation = packed record
    Ptr: Pointer;
    Size: NativeUInt;
    FileName: PChar;
    LineNumber: Int32;
    Next: ^TAllocation;
  end;

var
  GAllocations: ^TAllocation = nil;
  GAllocationCount: Int32 = 0;
  GTotalAllocated: NativeUInt = 0;

function DebugGetMem(const ASize: NativeUInt; const AFileName: PChar; const ALine: Int32): Pointer;
var
  LAlloc: ^TAllocation;
  LPtr: Pointer;
begin
  LPtr := GetMem(ASize);
  if LPtr = nil then
    exit(nil);
  
  LAlloc := GetMem(SizeOf(TAllocation));
  if LAlloc <> nil then
  begin
    LAlloc^.Ptr := LPtr;
    LAlloc^.Size := ASize;
    LAlloc^.FileName := AFileName;
    LAlloc^.LineNumber := ALine;
    LAlloc^.Next := GAllocations;
    GAllocations := LAlloc;
    Inc(GAllocationCount);
    GTotalAllocated += ASize;
  end;
  
  Result := LPtr;
end;

procedure DebugFreeMem(const APtr: Pointer);
var
  LCurrent, LPrev: ^TAllocation;
begin
  LPrev := nil;
  LCurrent := GAllocations;
  
  while LCurrent <> nil do
  begin
    if LCurrent^.Ptr = APtr then
    begin
      // Remove from list
      if LPrev <> nil then
        LPrev^.Next := LCurrent^.Next
      else
        GAllocations := LCurrent^.Next;
      
      GTotalAllocated -= LCurrent^.Size;
      Dec(GAllocationCount);
      
      FreeMem(LCurrent);
      FreeMem(APtr);
      exit;
    end;
    
    LPrev := LCurrent;
    LCurrent := LCurrent^.Next;
  end;
  
  printf("WARNING: Attempt to free untracked pointer %p\n", APtr);
end;

public procedure ReportLeaks();
var
  LCurrent: ^TAllocation;
begin
  if GAllocationCount = 0 then
  begin
    printf("No memory leaks detected.\n");
    exit;
  end;
  
  printf("MEMORY LEAKS DETECTED:\n");
  printf("Total leaked: %zu bytes in %d allocations\n", 
         GTotalAllocated, GAllocationCount);
  printf("\nLeak details:\n");
  
  LCurrent := GAllocations;
  while LCurrent <> nil do
  begin
    printf("  %p: %zu bytes allocated at %s:%d\n",
           LCurrent^.Ptr, LCurrent^.Size, 
           LCurrent^.FileName, LCurrent^.LineNumber);
    LCurrent := LCurrent^.Next;
  end;
end;

end.

// Usage macros (would be implemented as compiler intrinsics)
// #define DEBUG_GETMEM(size) DebugGetMem(size, __FILE__, __LINE__)
// #define DEBUG_FREEMEM(ptr) DebugFreeMem(ptr)
```

### 10.3 Migration Validation

#### 10.3.1 Functional Equivalence Testing

```cpascal
// validation.cpas
program ValidationSuite;

import OriginalCLib, MigratedCPascalLib;

type
  TTestCase = packed record
    Name: array[0..63] of Char;
    InputData: Pointer;
    InputSize: NativeUInt;
    ExpectedOutput: Pointer;
    ExpectedSize: NativeUInt;
  end;

function RunValidationTest(const ATestCase: ^TTestCase): Boolean;
var
  LCResult, LCPascalResult: Pointer;
  LCResultSize, LCPascalResultSize: NativeUInt;
begin
  // Run original C version
  LCResult := OriginalCLib.ProcessData(ATestCase^.InputData, ATestCase^.InputSize, @LCResultSize);
  
  // Run migrated CPascal version
  LCPascalResult := MigratedCPascalLib.ProcessData(ATestCase^.InputData, ATestCase^.InputSize, @LCPascalResultSize);
  
  // Compare results
  if LCResultSize <> LCPascalResultSize then
  begin
    printf("FAIL: %s - Size mismatch (C: %zu, CPascal: %zu)\n", 
           @ATestCase^.Name[0], LCResultSize, LCPascalResultSize);
    Result := false;
    exit;
  end;
  
  if memcmp(LCResult, LCPascalResult, LCResultSize) <> 0 then
  begin
    printf("FAIL: %s - Data mismatch\n", @ATestCase^.Name[0]);
    Result := false;
    exit;
  end;
  
  printf("PASS: %s\n", @ATestCase^.Name[0]);
  Result := true;
end;

// External memory comparison
function memcmp(const A, B: Pointer; const ASize: NativeUInt): Int32; external;

var
  LTestCases: array[0..9] of TTestCase;
  LTestCount: Int32;
  I, LPassed: Int32;

begin
  // Initialize test cases
  // ... (setup test data)
  
  LPassed := 0;
  for I := 0 to LTestCount - 1 do
  begin
    if RunValidationTest(@LTestCases[I]) then
      Inc(LPassed);
  end;
  
  printf("\nValidation Results: %d/%d tests passed\n", LPassed, LTestCount);
  
  if LPassed = LTestCount then
    printf("All tests passed! Migration appears successful.\n")
  else
    printf("Some tests failed. Review migration implementation.\n");
end.
```

## Conclusion

This comprehensive migration guide provides the foundation for successfully transitioning from C to CPascal while maintaining binary compatibility and performance. The key principles for successful migration are:

1. **Start Small**: Begin with simple, isolated modules
2. **Test Extensively**: Verify binary compatibility and functional equivalence
3. **Maintain Compatibility**: Keep existing C interfaces working during transition
4. **Document Everything**: Track changes and migration decisions
5. **Performance Monitor**: Ensure no regressions in critical code paths

CPascal's design as "C with Pascal syntax" makes it an ideal modernization path for C codebases, providing improved readability and maintainability while preserving the performance and control that C developers expect.

Remember: Migration is a process, not an event. Take time to learn CPascal idioms and best practices as you progress through your codebase transformation.