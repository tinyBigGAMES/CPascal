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

unit CPascal;

{$I CPascal.Defines.inc}

interface

uses
  CPascal.Platform,
  CPascal.Common,
  CPascal.Expressions,
  CPascal.Builder,
  CPascal.Builder.Interfaces;

// === ZERO-OVERHEAD TYPE ALIASES ===
// Platform abstraction re-exports
type
  TCPPlatformTarget = CPascal.Platform.TCPPlatformTarget;
  TCPPlatformInitResult = CPascal.Platform.TCPPlatformInitResult;

  // Common types re-exports
  TCPSourceLocation = CPascal.Common.TCPSourceLocation;
  ECPException = CPascal.Common.ECPException;

  // Expression system re-exports
  ICPExpression = CPascal.Expressions.ICPExpression;
  ICPIdentifier = CPascal.Expressions.ICPIdentifier;
  ICPType = CPascal.Expressions.ICPType;
  TCPBinaryOperator = CPascal.Expressions.TCPBinaryOperator;
  TCPUnaryOperator = CPascal.Expressions.TCPUnaryOperator;
  TCPBuiltInType = CPascal.Expressions.TCPBuiltInType;
  TCPExpression = CPascal.Expressions.TCPExpression;
  TCPLiteral = CPascal.Expressions.TCPLiteral;
  TCPIdentifier = CPascal.Expressions.TCPIdentifier;
  TCPVariable = CPascal.Expressions.TCPVariable;
  TCPBinaryOp = CPascal.Expressions.TCPBinaryOp;
  TCPUnaryOp = CPascal.Expressions.TCPUnaryOp;
  TCPFunctionCall = CPascal.Expressions.TCPFunctionCall;
  TCPArrayAccess = CPascal.Expressions.TCPArrayAccess;
  TCPFieldAccess = CPascal.Expressions.TCPFieldAccess;
  TCPTypecast = CPascal.Expressions.TCPTypecast;
  TCPTernaryOp = CPascal.Expressions.TCPTernaryOp;
  TCPType = CPascal.Expressions.TCPType;
  TCPTypeRegistry = CPascal.Expressions.TCPTypeRegistry;

  // Builder system re-exports from CPascal.Builder
  TCPBuilder = CPascal.Builder.TCPBuilder;

  // Builder interfaces re-exports from CPascal.Builder.Interfaces
  ICPBuilder = CPascal.Builder.Interfaces.ICPBuilder;
  ICPSourceGenerator = CPascal.Builder.Interfaces.ICPSourceGenerator;
  ICPIRGenerator = CPascal.Builder.Interfaces.ICPIRGenerator;
  TCPCommentStyle = CPascal.Builder.Interfaces.TCPCommentStyle;
  TCPAppType = CPascal.Builder.Interfaces.TCPAppType;

// === ZERO-OVERHEAD FUNCTION ALIASES ===
// Function variables for true zero-overhead forwarding
var
  // Platform initialization and management
  CPInitLLVMPlatform: function(): TCPPlatformInitResult;
  CPGetPlatformTargetTriple: function(): string;
  CPGetPlatformTarget: function(): TCPPlatformTarget;
  CPInitLLVMForTarget: function(const ATarget: TCPPlatformTarget): TCPPlatformInitResult;
  CPInitConsole: procedure();
  CPIsPlatformInitialized: function(): Boolean;
  CPGetPlatformInitResult: function(): TCPPlatformInitResult;

  // Builder factory function
  CPCreateBuilder: function(): ICPBuilder;

// === ZERO-OVERHEAD CONSTANT ALIASES ===
// Platform target constants - true aliases (same names)
const
  ptX86_64      = CPascal.Platform.ptX86_64;
  ptAArch64     = CPascal.Platform.ptAArch64;
  ptWebAssembly = CPascal.Platform.ptWebAssembly;
  ptRISCV       = CPascal.Platform.ptRISCV;

  // Binary operator constants - true aliases (same names)
  cpOpAdd = CPascal.Expressions.cpOpAdd;
  cpOpSub = CPascal.Expressions.cpOpSub;
  cpOpMul = CPascal.Expressions.cpOpMul;
  cpOpDiv = CPascal.Expressions.cpOpDiv;
  cpOpMod = CPascal.Expressions.cpOpMod;
  cpOpAnd = CPascal.Expressions.cpOpAnd;
  cpOpOr  = CPascal.Expressions.cpOpOr;
  cpOpXor = CPascal.Expressions.cpOpXor;
  cpOpShl = CPascal.Expressions.cpOpShl;
  cpOpShr = CPascal.Expressions.cpOpShr;
  cpOpEQ  = CPascal.Expressions.cpOpEQ;
  cpOpNE  = CPascal.Expressions.cpOpNE;
  cpOpLT  = CPascal.Expressions.cpOpLT;
  cpOpLE  = CPascal.Expressions.cpOpLE;
  cpOpGT  = CPascal.Expressions.cpOpGT;
  cpOpGE  = CPascal.Expressions.cpOpGE;

  // Unary operator constants - true aliases (same names)
  cpOpNeg   = CPascal.Expressions.cpOpNeg;
  cpOpNot   = CPascal.Expressions.cpOpNot;
  cpOpAddr  = CPascal.Expressions.cpOpAddr;
  cpOpDeref = CPascal.Expressions.cpOpDeref;

  // Comment style constants - true aliases (same names)
  csLine  = CPascal.Builder.Interfaces.csLine;
  csBlock = CPascal.Builder.Interfaces.csBlock;
  csBrace = CPascal.Builder.Interfaces.csBrace;

  // Application type constants - true aliases (same names)
  atConsole = CPascal.Builder.Interfaces.atConsole;
  atWindows = CPascal.Builder.Interfaces.atWindows;
  atService = CPascal.Builder.Interfaces.atService;
  atDLL     = CPascal.Builder.Interfaces.atDLL;

  // Built-in type constants - true aliases (same names)
  cptInt8     = CPascal.Expressions.cptInt8;
  cptInt16    = CPascal.Expressions.cptInt16;
  cptInt32    = CPascal.Expressions.cptInt32;
  cptInt64    = CPascal.Expressions.cptInt64;
  cptUInt8    = CPascal.Expressions.cptUInt8;
  cptUInt16   = CPascal.Expressions.cptUInt16;
  cptUInt32   = CPascal.Expressions.cptUInt32;
  cptUInt64   = CPascal.Expressions.cptUInt64;
  cptFloat32  = CPascal.Expressions.cptFloat32;
  cptFloat64  = CPascal.Expressions.cptFloat64;
  cptBoolean  = CPascal.Expressions.cptBoolean;
  cptString   = CPascal.Expressions.cptString;
  cptChar     = CPascal.Expressions.cptChar;

implementation

initialization
  // Assign function pointers for zero-overhead aliasing
  // Platform functions
  CPInitLLVMPlatform := CPascal.Platform.CPInitLLVMPlatform;
  CPGetPlatformTargetTriple := CPascal.Platform.CPGetPlatformTargetTriple;
  CPGetPlatformTarget := CPascal.Platform.CPGetPlatformTarget;
  CPInitLLVMForTarget := CPascal.Platform.CPInitLLVMForTarget;
  CPInitConsole := CPascal.Platform.CPInitConsole;
  CPIsPlatformInitialized := CPascal.Platform.CPIsPlatformInitialized;
  CPGetPlatformInitResult := CPascal.Platform.CPGetPlatformInitResult;
  
  // Builder factory function
  CPCreateBuilder := CPascal.Builder.CPCreateBuilder;

end.
