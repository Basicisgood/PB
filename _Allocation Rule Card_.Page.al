page 50101 "Allocation Rule Card"
{
    ApplicationArea = All;
    Caption = 'Allocation Rule Card';
    PageType = Card;
    SourceTable = "Allocation Rule";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Rule; Rec.Rule)
                {
                    ToolTip = 'Specifies the value of the Rule field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies the value of the Active field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Date Last Run"; Rec."Date Last Run")
                {
                    ToolTip = 'Specifies the value of the Date Last Run field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ToolTip = 'Specifies the value of the Expiration Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Execute Run System Date"; Rec."Execute Run System Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                group(Journal)
                {
                    Caption = 'Journal Setup';

                    field("Intercompany Rule"; Rec."Intercompany Rule")
                    {
                        ToolTip = 'Specifies the value of the Intercompany Rule field.', Comment = '%';
                        ApplicationArea = All;
                    }
                    field("Journal Template Name"; Rec."Journal Template Name")
                    {
                        ApplicationArea = all;
                    // Visible = false;
                    }
                    field("Journal Batch Name"; Rec."Journal Batch Name")
                    {
                        ApplicationArea = All;
                    }
                    field("No. Series"; Rec."No. Series")
                    {
                        ApplicationArea = All;
                    }
                }
                Group(Calculation)
                {
                    field("Allocation method"; Rec."Allocation method")
                    {
                        ApplicationArea = All;
                    }
                    field("Data Source"; Rec."Data Source")
                    {
                        ApplicationArea = All;
                    }
                    field("Fixed Amount"; Rec."Fixed Amount")
                    {
                        ApplicationArea = All;
                    }
                    field("Date Interval Code"; Rec."Date Interval Code")
                    {
                        ApplicationArea = All;
                    }
                    field(MathCalculation; Rec.MathCalculation)
                    {
                        ApplicationArea = All;
                    }
                    field("Math Ratio"; Rec."Math Ratio")
                    {
                        ApplicationArea = All;
                    }
                    field("Calc Total Weight"; Rec."Calc Total Weight")
                    {
                        Visible = g_bol_ShowWeight;
                        ApplicationArea = All;
                    }
                    field("Calc Total Percentage"; Rec."Calc Total Percentage")
                    {
                        Visible = g_bol_ShowPercentage;
                        ApplicationArea = All;
                    }
                    field("Last Source Amount to Split"; Rec."Last Source Amount to Split")
                    {
                        ApplicationArea = All;
                    }
                    field("Last Dest. Total PointXDays"; Rec."Last Dest. Total PointXDays")
                    {
                        ApplicationArea = All;
                    }
                    field("Point Calculation Day Type"; Rec."Point Calculation Day Type")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            Group(Offset)
            {
                field("OFfset Account From"; Rec."Offset Account From")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Rec."Offset Account From" = Rec."Offset Account From"::Source then g_bol_AccNoEditable:=false
                        else
                            g_bol_AccNoEditable:=true;
                    end;
                }
                field("Offset Account No."; Rec."Offset Account No.")
                {
                    ApplicationArea = All;
                    Editable = g_bol_AccNoEditable;
                }
                field("Offset Dimension From"; Rec."Offset Dimension From")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Rec."Offset Dimension From" = Rec."Offset Dimension From"::Source then g_bol_OffsetDimEditable:=false
                        else
                            g_bol_OffsetDimEditable:=true;
                    end;
                }
                part("Allocation Default Dimension"; "Allocation Default Dimension")
                {
                    Caption = 'Offset Dimension';
                    SubPageLink = Rule=Field(Rule), Type=Const(Offset);
                    ApplicationArea = All;
                    Editable = g_bol_OffsetDimEditable;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Source)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Source';
                Image = ViewSourceDocumentLine;
                RunObject = page "Allocation Rule Source";
                RunPageLink = Rule=field(Rule);
            }
            action(Destination)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Caption = 'Destination';
                Image = CreditMemo;
                RunObject = page "Allocation Destination";
                RunPageLink = Rule=field(Rule);
            }
            action(ExecuteRule)
            {
                ApplicationArea = All;
                Caption = 'Execute Rule';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Image = Process;

                trigger OnAction()
                var
                    ProcessAllocationRules: Report "Process Allocation Rule Report";
                    l_Rec_AllocationRule: Record "Allocation Rule";
                begin
                    l_Rec_AllocationRule.RESET;
                    l_Rec_AllocationRule.SETRANGE("Rule", Rec."Rule");
                    IF l_Rec_AllocationRule.FINDSET THEN;
                    CLEAR(ProcessAllocationRules);
                    ProcessAllocationRules.SetTableView(l_REc_AllocationRule);
                    ProcessAllocationRules.RUN;
                end;
            }
            action(ProcessRule)
            {
                Visible = false;
                ApplicationArea = All;
                Caption = 'Process Rule';
                Image = Process;

                trigger OnAction()
                var
                    ProcessAllocationRules: Codeunit "Process Allocation Rules";
                begin
                    ProcessAllocationRules.Run(Rec);
                end;
            }
            action(AllocationLogEntry)
            {
                ApplicationArea = all;
                Caption = 'Allocation Generation Log';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Image = Process;
                RunObject = page "Allocation Entry Log";
                RunPageLink = "Rule No."=field(Rule);
            }
            action(OpenJournal)
            {
                ApplicationArea = all;
                Caption = 'Open Journal';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Image = OpenJournal;

                trigger OnAction()
                var
                    l_pag_ICJournal: Page "IC General Journal";
                    l_pag_GenJnl: Page "General Journal";
                    l_Rec_GenJnl: Record "Gen. Journal Line";
                    l_cdu_JnlMgt: Codeunit GenJnlManagement;
                    l_Rec_GenBatch: Record "Gen. Journal Batch";
                begin
                    l_Rec_GenBatch.RESET;
                    l_Rec_GenBatch.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    l_Rec_GenBatch.SETRANGE(Name, Rec."Journal Batch Name");
                    IF l_Rec_GenBatch.FINDSET THEN l_cdu_JnlMgt.TemplateselectionFromBatch(l_Rec_GenBatch);
                End;
            }
        }
    }
    trigger OnOpenPage()
    begin
        g_bol_ShowPercentage:=false;
        g_bol_ShowWeight:=false;
        CASE Rec."Allocation Method" of Rec."Allocation Method"::Percentage: g_bol_ShowPercentage:=TRUE;
        Rec."Allocation Method"::Weight: g_bol_ShowWeight:=true;
        END;
        g_bol_AccNoEditable:=false;
        g_bol_OffsetDimEditable:=false;
        if Rec."Offset Account From" = Rec."Offset Account From"::"User Specified" then g_bol_AccNoEditable:=true;
        if Rec."Offset Dimension From" = Rec."Offset Dimension From"::"User Specified" then g_bol_OffsetDimEditable:=true;
    end;
    var g_bol_ShowPercentage: Boolean;
    g_bol_ShowWeight: Boolean;
    g_bol_ShowPoint: Boolean;
    g_bol_AccNoEditable: Boolean;
    g_bol_OffsetDimEditable: Boolean;
}
