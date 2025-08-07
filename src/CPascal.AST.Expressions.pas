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

unit CPascal.AST.Expressions;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  CPascal.Exception,
  CPascal.Lexer,
  CPascal.AST;

type

  { TCPExpressionNode }
  TCPExpressionNode = class(TCPASTNode)
  public
    constructor Create(const ANodeKind: TCPNodeKind; const ALocation: TCPSourceLocation);
  end;

  { TCPIdentifierNode }
  TCPIdentifierNode = class(TCPExpressionNode)
  private
    FIdentifierName: string;

  public
    constructor Create(const ALocation: TCPSourceLocation; const AIdentifierName: string);
    property IdentifierName: string read FIdentifierName;
  end;

  { TCPLiteralNode }
  TCPLiteralNode = class(TCPExpressionNode)
  private
    FLiteralValue: string;

  public
    constructor Create(const ANodeKind: TCPNodeKind; const ALocation: TCPSourceLocation; const AValue: string);
    property LiteralValue: string read FLiteralValue;
  end;

  { TCPFunctionCallNode }
  TCPFunctionCallNode = class(TCPExpressionNode)
  private
    FFunctionName: string;
    FArguments: TCPASTNodeList;

  public
    constructor Create(const ALocation: TCPSourceLocation; const AFunctionName: string);
    destructor Destroy; override;

    procedure AddArgument(const AArgument: TCPExpressionNode);
    function GetArgument(const AIndex: Integer): TCPExpressionNode;
    function ArgumentCount(): Integer;

    property FunctionName: string read FFunctionName;
    property Arguments: TCPASTNodeList read FArguments;
  end;

  { TCPUnaryOperationNode }
  TCPUnaryOperationNode = class(TCPExpressionNode)
  private
    FOperator: TCPTokenKind;
    FOperand: TCPExpressionNode;

  public
    constructor Create(const ALocation: TCPSourceLocation; const AOperator: TCPTokenKind;
      const AOperand: TCPExpressionNode);
    destructor Destroy; override;

    property Operator: TCPTokenKind read FOperator;
    property Operand: TCPExpressionNode read FOperand;
  end;

  { TCPBinaryOperationNode }
  TCPBinaryOperationNode = class(TCPExpressionNode)
  private
    FOperator: TCPTokenKind;
    FLeftOperand: TCPExpressionNode;
    FRightOperand: TCPExpressionNode;

  public
    constructor Create(const ALocation: TCPSourceLocation; const AOperator: TCPTokenKind;
      const ALeftOperand: TCPExpressionNode; const ARightOperand: TCPExpressionNode);
    destructor Destroy; override;

    property Operator: TCPTokenKind read FOperator;
    property LeftOperand: TCPExpressionNode read FLeftOperand;
    property RightOperand: TCPExpressionNode read FRightOperand;
  end;

  { TCPArrayAccessNode }
  TCPArrayAccessNode = class(TCPExpressionNode)
  private
    FArrayExpression: TCPExpressionNode;
    FIndexExpression: TCPExpressionNode;

  public
    constructor Create(const ALocation: TCPSourceLocation; const AArrayExpression: TCPExpressionNode;
      const AIndexExpression: TCPExpressionNode);
    destructor Destroy; override;

    property ArrayExpression: TCPExpressionNode read FArrayExpression;
    property IndexExpression: TCPExpressionNode read FIndexExpression;
  end;


implementation

{ TCPExpressionNode }
constructor TCPExpressionNode.Create(const ANodeKind: TCPNodeKind; const ALocation: TCPSourceLocation);
begin
  inherited Create(ANodeKind, ALocation);
end;

{ TCPIdentifierNode }
constructor TCPIdentifierNode.Create(const ALocation: TCPSourceLocation; const AIdentifierName: string);
begin
  inherited Create(nkIdentifier, ALocation);
  FIdentifierName := AIdentifierName;
end;

{ TCPLiteralNode }
constructor TCPLiteralNode.Create(const ANodeKind: TCPNodeKind; const ALocation: TCPSourceLocation; const AValue: string);
begin
  inherited Create(ANodeKind, ALocation);
  FLiteralValue := AValue;
end;

{ TCPFunctionCallNode }
constructor TCPFunctionCallNode.Create(const ALocation: TCPSourceLocation; const AFunctionName: string);
begin
  inherited Create(nkFunctionCall, ALocation);
  FFunctionName := AFunctionName;
  FArguments := TCPASTNodeList.Create(True); // Owns objects
end;

destructor TCPFunctionCallNode.Destroy;
begin
  FArguments.Free;
  inherited Destroy;
end;

procedure TCPFunctionCallNode.AddArgument(const AArgument: TCPExpressionNode);
begin
  if Assigned(AArgument) then
    FArguments.Add(AArgument);
end;

function TCPFunctionCallNode.GetArgument(const AIndex: Integer): TCPExpressionNode;
begin
  if (AIndex >= 0) and (AIndex < FArguments.Count) then
    Result := TCPExpressionNode(FArguments[AIndex])
  else
    Result := nil;
end;

function TCPFunctionCallNode.ArgumentCount(): Integer;
begin
  Result := FArguments.Count;
end;

{ TCPUnaryOperationNode }
constructor TCPUnaryOperationNode.Create(const ALocation: TCPSourceLocation; 
  const AOperator: TCPTokenKind; const AOperand: TCPExpressionNode);
begin
  inherited Create(nkUnaryOperation, ALocation);
  FOperator := AOperator;
  FOperand := AOperand;
end;

destructor TCPUnaryOperationNode.Destroy;
begin
  FOperand.Free;
  inherited Destroy;
end;

{ TCPBinaryOperationNode }
constructor TCPBinaryOperationNode.Create(const ALocation: TCPSourceLocation; const AOperator: TCPTokenKind;
  const ALeftOperand: TCPExpressionNode; const ARightOperand: TCPExpressionNode);
begin
  inherited Create(nkBinaryOperation, ALocation);
  FOperator := AOperator;
  FLeftOperand := ALeftOperand;
  FRightOperand := ARightOperand;
end;

destructor TCPBinaryOperationNode.Destroy;
begin
  FLeftOperand.Free;
  FRightOperand.Free;
  inherited Destroy;
end;

{ TCPArrayAccessNode }
constructor TCPArrayAccessNode.Create(const ALocation: TCPSourceLocation; const AArrayExpression: TCPExpressionNode;
  const AIndexExpression: TCPExpressionNode);
begin
  inherited Create(nkArrayAccess, ALocation);
  FArrayExpression := AArrayExpression;
  FIndexExpression := AIndexExpression;
end;

destructor TCPArrayAccessNode.Destroy;
begin
  FArrayExpression.Free;
  FIndexExpression.Free;
  inherited Destroy;
end;

end.
