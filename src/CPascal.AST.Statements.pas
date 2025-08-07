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

unit CPascal.AST.Statements;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  CPascal.Exception,
  CPascal.Lexer,
  CPascal.AST,
  CPascal.AST.Expressions;

type
  { TCPStatementNode }
  TCPStatementNode = class(TCPASTNode)
  public
    constructor Create(const ANodeKind: TCPNodeKind; const ALocation: TCPSourceLocation);
  end;

  { TCPAssignmentStatementNode }
  TCPAssignmentStatementNode = class(TCPStatementNode)
  private
    FVariableList: TCPASTNodeList;
    FAssignmentOperator: TCPTokenKind;
    FExpressionList: TCPASTNodeList;

  public
    constructor Create(const ALocation: TCPSourceLocation; const AAssignmentOperator: TCPTokenKind);
    destructor Destroy; override;

    procedure AddVariable(const AVariable: TCPASTNode);
    procedure AddExpression(const AExpression: TCPASTNode);
    function GetVariable(const AIndex: Integer): TCPASTNode;
    function GetExpression(const AIndex: Integer): TCPASTNode;
    function VariableCount(): Integer;
    function ExpressionCount(): Integer;

    property VariableList: TCPASTNodeList read FVariableList;
    property AssignmentOperator: TCPTokenKind read FAssignmentOperator write FAssignmentOperator;
    property ExpressionList: TCPASTNodeList read FExpressionList;
  end;

  { TCPIfStatementNode }
  TCPIfStatementNode = class(TCPStatementNode)
  private
    FConditionExpression: TCPExpressionNode;
    FThenStatement: TCPStatementNode;
    FElseStatement: TCPStatementNode; // Optional

  public
    constructor Create(const ALocation: TCPSourceLocation; 
                       const ACondition: TCPExpressionNode; 
                       const AThenStatement: TCPStatementNode;
                       const AElseStatement: TCPStatementNode = nil);
    destructor Destroy; override;

    property ConditionExpression: TCPExpressionNode read FConditionExpression;
    property ThenStatement: TCPStatementNode read FThenStatement;
    property ElseStatement: TCPStatementNode read FElseStatement;
    function HasElseClause(): Boolean;
  end;

  { TCPWhileStatementNode }
  TCPWhileStatementNode = class(TCPStatementNode)
  private
    FConditionExpression: TCPExpressionNode;
    FBodyStatement: TCPStatementNode;

  public
    constructor Create(const ALocation: TCPSourceLocation; 
                       const ACondition: TCPExpressionNode; 
                       const ABodyStatement: TCPStatementNode);
    destructor Destroy; override;

    property ConditionExpression: TCPExpressionNode read FConditionExpression;
    property BodyStatement: TCPStatementNode read FBodyStatement;
  end;

  { TCPForStatementNode }
  TCPForStatementNode = class(TCPStatementNode)
  private
    FControlVariable: string;
    FStartExpression: TCPExpressionNode;
    FEndExpression: TCPExpressionNode;
    FIsDownto: Boolean; // True for downto, False for to
    FBodyStatement: TCPStatementNode;

  public
    constructor Create(const ALocation: TCPSourceLocation;
                       const AControlVariable: string;
                       const AStartExpression: TCPExpressionNode;
                       const AEndExpression: TCPExpressionNode;
                       const AIsDownto: Boolean;
                       const ABodyStatement: TCPStatementNode);
    destructor Destroy; override;

    property ControlVariable: string read FControlVariable;
    property StartExpression: TCPExpressionNode read FStartExpression;
    property EndExpression: TCPExpressionNode read FEndExpression;
    property IsDownto: Boolean read FIsDownto;
    property BodyStatement: TCPStatementNode read FBodyStatement;
  end;

  { TCPCaseBranch }
  TCPCaseBranch = class
  private
    FLabelList: TCPASTNodeList; // List of constant expressions (case labels)
    FStatement: TCPStatementNode;

  public
    constructor Create();
    destructor Destroy; override;

    procedure AddLabel(const ALabel: TCPExpressionNode);
    procedure SetStatement(const AStatement: TCPStatementNode);
    function GetLabel(const AIndex: Integer): TCPExpressionNode;
    function LabelCount(): Integer;

    property LabelList: TCPASTNodeList read FLabelList;
    property Statement: TCPStatementNode read FStatement;
  end;

  { TCPCaseStatementNode }
  TCPCaseStatementNode = class(TCPStatementNode)
  private
    FCaseExpression: TCPExpressionNode;
    FBranches: TObjectList<TCPCaseBranch>;
    FElseStatement: TCPStatementNode; // Optional

  public
    constructor Create(const ALocation: TCPSourceLocation;
                       const ACaseExpression: TCPExpressionNode;
                       const AElseStatement: TCPStatementNode = nil);
    destructor Destroy; override;

    procedure AddBranch(const ABranch: TCPCaseBranch);
    procedure SetElseStatement(const AElseStatement: TCPStatementNode);
    function GetBranch(const AIndex: Integer): TCPCaseBranch;
    function BranchCount(): Integer;
    function HasElseClause(): Boolean;

    property CaseExpression: TCPExpressionNode read FCaseExpression;
    property Branches: TObjectList<TCPCaseBranch> read FBranches;
    property ElseStatement: TCPStatementNode read FElseStatement;
  end;

  { TCPReturnStatementNode }
  TCPReturnStatementNode = class(TCPStatementNode)
  private
    FReturnExpression: TCPExpressionNode; // Optional - nil for procedures

  public
    constructor Create(const ALocation: TCPSourceLocation; const AReturnExpression: TCPExpressionNode = nil);
    destructor Destroy; override;

    property ReturnExpression: TCPExpressionNode read FReturnExpression;
    function HasReturnValue(): Boolean;
  end;

  { TCPCompoundStatementNode }
  TCPCompoundStatementNode = class(TCPStatementNode)
  private
    FStatements: TCPASTNodeList;

  public
    constructor Create(const ALocation: TCPSourceLocation);
    destructor Destroy; override;

    procedure AddStatement(const AStatement: TCPStatementNode);
    function GetStatement(const AIndex: Integer): TCPStatementNode;
    function StatementCount(): Integer;

    property Statements: TCPASTNodeList read FStatements;
  end;

implementation



{ TCPStatementNode }
constructor TCPStatementNode.Create(const ANodeKind: TCPNodeKind; const ALocation: TCPSourceLocation);
begin
  inherited Create(ANodeKind, ALocation);
end;

{ TCPAssignmentStatementNode }
constructor TCPAssignmentStatementNode.Create(const ALocation: TCPSourceLocation; const AAssignmentOperator: TCPTokenKind);
begin
  inherited Create(nkAssignmentStatement, ALocation);
  FAssignmentOperator := AAssignmentOperator;
  FVariableList := TCPASTNodeList.Create(True); // Owns objects
  FExpressionList := TCPASTNodeList.Create(True); // Owns objects
end;

destructor TCPAssignmentStatementNode.Destroy;
begin
  FVariableList.Free;
  FExpressionList.Free;
  inherited Destroy;
end;

procedure TCPAssignmentStatementNode.AddVariable(const AVariable: TCPASTNode);
begin
  if Assigned(AVariable) then
    FVariableList.Add(AVariable);
end;

procedure TCPAssignmentStatementNode.AddExpression(const AExpression: TCPASTNode);
begin
  if Assigned(AExpression) then
    FExpressionList.Add(AExpression);
end;

function TCPAssignmentStatementNode.GetVariable(const AIndex: Integer): TCPASTNode;
begin
  if (AIndex >= 0) and (AIndex < FVariableList.Count) then
    Result := FVariableList[AIndex]
  else
    Result := nil;
end;

function TCPAssignmentStatementNode.GetExpression(const AIndex: Integer): TCPASTNode;
begin
  if (AIndex >= 0) and (AIndex < FExpressionList.Count) then
    Result := FExpressionList[AIndex]
  else
    Result := nil;
end;

function TCPAssignmentStatementNode.VariableCount(): Integer;
begin
  Result := FVariableList.Count;
end;

function TCPAssignmentStatementNode.ExpressionCount(): Integer;
begin
  Result := FExpressionList.Count;
end;

{ TCPIfStatementNode }
constructor TCPIfStatementNode.Create(const ALocation: TCPSourceLocation; 
                                       const ACondition: TCPExpressionNode; 
                                       const AThenStatement: TCPStatementNode;
                                       const AElseStatement: TCPStatementNode = nil);
begin
  inherited Create(nkIfStatement, ALocation);
  FConditionExpression := ACondition;
  FThenStatement := AThenStatement;
  FElseStatement := AElseStatement;
end;

destructor TCPIfStatementNode.Destroy;
begin
  FConditionExpression.Free;
  FThenStatement.Free;
  FElseStatement.Free;
  inherited Destroy;
end;

function TCPIfStatementNode.HasElseClause(): Boolean;
begin
  Result := Assigned(FElseStatement);
end;

{ TCPWhileStatementNode }
constructor TCPWhileStatementNode.Create(const ALocation: TCPSourceLocation; 
                                          const ACondition: TCPExpressionNode; 
                                          const ABodyStatement: TCPStatementNode);
begin
  inherited Create(nkWhileStatement, ALocation);
  FConditionExpression := ACondition;
  FBodyStatement := ABodyStatement;
end;

destructor TCPWhileStatementNode.Destroy;
begin
  FConditionExpression.Free;
  FBodyStatement.Free;
  inherited Destroy;
end;

{ TCPForStatementNode }
constructor TCPForStatementNode.Create(const ALocation: TCPSourceLocation;
                                        const AControlVariable: string;
                                        const AStartExpression: TCPExpressionNode;
                                        const AEndExpression: TCPExpressionNode;
                                        const AIsDownto: Boolean;
                                        const ABodyStatement: TCPStatementNode);
begin
  inherited Create(nkForStatement, ALocation);
  FControlVariable := AControlVariable;
  FStartExpression := AStartExpression;
  FEndExpression := AEndExpression;
  FIsDownto := AIsDownto;
  FBodyStatement := ABodyStatement;
end;

destructor TCPForStatementNode.Destroy;
begin
  FStartExpression.Free;
  FEndExpression.Free;
  FBodyStatement.Free;
  inherited Destroy;
end;

{ TCPCompoundStatementNode }
constructor TCPCompoundStatementNode.Create(const ALocation: TCPSourceLocation);
begin
  inherited Create(nkCompoundStatement, ALocation);
  FStatements := TCPASTNodeList.Create(True); // Owns objects
end;

destructor TCPCompoundStatementNode.Destroy;
begin
  FStatements.Free;
  inherited Destroy;
end;

procedure TCPCompoundStatementNode.AddStatement(const AStatement: TCPStatementNode);
begin
  if Assigned(AStatement) then
    FStatements.Add(AStatement);
end;

function TCPCompoundStatementNode.GetStatement(const AIndex: Integer): TCPStatementNode;
begin
  if (AIndex >= 0) and (AIndex < FStatements.Count) then
    Result := TCPStatementNode(FStatements[AIndex])
  else
    Result := nil;
end;

function TCPCompoundStatementNode.StatementCount(): Integer;
begin
  Result := FStatements.Count;
end;

{ TCPCaseBranch }
constructor TCPCaseBranch.Create();
begin
  inherited Create;
  FLabelList := TCPASTNodeList.Create(True); // Owns objects
  FStatement := nil;
end;

destructor TCPCaseBranch.Destroy;
begin
  FLabelList.Free;
  FStatement.Free;
  inherited Destroy;
end;

procedure TCPCaseBranch.AddLabel(const ALabel: TCPExpressionNode);
begin
  if Assigned(ALabel) then
    FLabelList.Add(ALabel);
end;

procedure TCPCaseBranch.SetStatement(const AStatement: TCPStatementNode);
begin
  if Assigned(FStatement) then
    FStatement.Free;
  FStatement := AStatement;
end;

function TCPCaseBranch.GetLabel(const AIndex: Integer): TCPExpressionNode;
begin
  if (AIndex >= 0) and (AIndex < FLabelList.Count) then
    Result := TCPExpressionNode(FLabelList[AIndex])
  else
    Result := nil;
end;

function TCPCaseBranch.LabelCount(): Integer;
begin
  Result := FLabelList.Count;
end;

{ TCPCaseStatementNode }
constructor TCPCaseStatementNode.Create(const ALocation: TCPSourceLocation;
                                         const ACaseExpression: TCPExpressionNode;
                                         const AElseStatement: TCPStatementNode = nil);
begin
  inherited Create(nkCaseStatement, ALocation);
  FCaseExpression := ACaseExpression;
  FBranches := TObjectList<TCPCaseBranch>.Create(True); // Owns objects
  FElseStatement := AElseStatement;
end;

destructor TCPCaseStatementNode.Destroy;
begin
  FCaseExpression.Free;
  FBranches.Free;
  FElseStatement.Free;
  inherited Destroy;
end;

procedure TCPCaseStatementNode.AddBranch(const ABranch: TCPCaseBranch);
begin
  if Assigned(ABranch) then
    FBranches.Add(ABranch);
end;

procedure TCPCaseStatementNode.SetElseStatement(const AElseStatement: TCPStatementNode);
begin
  if Assigned(FElseStatement) then
    FElseStatement.Free;
  FElseStatement := AElseStatement;
end;

function TCPCaseStatementNode.GetBranch(const AIndex: Integer): TCPCaseBranch;
begin
  if (AIndex >= 0) and (AIndex < FBranches.Count) then
    Result := FBranches[AIndex]
  else
    Result := nil;
end;

function TCPCaseStatementNode.BranchCount(): Integer;
begin
  Result := FBranches.Count;
end;

function TCPCaseStatementNode.HasElseClause(): Boolean;
begin
  Result := Assigned(FElseStatement);
end;

{ TCPReturnStatementNode }
constructor TCPReturnStatementNode.Create(const ALocation: TCPSourceLocation; const AReturnExpression: TCPExpressionNode = nil);
begin
  inherited Create(nkReturnStatement, ALocation);
  FReturnExpression := AReturnExpression;
end;

destructor TCPReturnStatementNode.Destroy;
begin
  FReturnExpression.Free;
  inherited Destroy;
end;

function TCPReturnStatementNode.HasReturnValue(): Boolean;
begin
  Result := Assigned(FReturnExpression);
end;

end.
