page 50103 "Allocation Destination"
{
    ApplicationArea = All;
    Caption = 'Allocation Destination';
    PageType = List;
    SourceTable = "Allocation Destination";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Visible = true;

                field(Company; Rec.Company)
                {
                    ToolTip = 'Specifies the value of the Company field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Current Company"; Rec."Current Company")
                {
                    ApplicationArea = All;
                }
                field("Same as Source"; Rec."Same as Source")
                {
                    ApplicationArea = All;
                }
                field("To Account"; Rec."To Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Account field.', Comment = '%';
                }
                field("Fixed Percentage"; Rec."Fixed Percentage")
                {
                    ApplicationArea = All;
                    Visible = g_bol_ShowPercentage;
                }
                field("Fixed Weight"; Rec."Fixed Weight")
                {
                    ApplicationArea = All;
                    Visible = g_bol_ShowWeight;
                }
                field("Last Destination Amount get"; Rec."Last Destination Amount get")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = g_bol_ShowAmount;
                }
                field("Last Destination Ratio"; Rec."Last Destination Ratio")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = g_bol_ShowRatio;
                }
                field("Last Destination PointXDays"; Rec."Last Destination PointXDays")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = g_bol_ShowPoint;
                }
                field("Last Destination Factor Amt"; Rec."Last Destination Factor Amt")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Last Min Curr. Period Amt"; Rec."Last Min Curr. Period Amt")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = g_bol_ShowMinCol;
                }
                field("Last Min Prev. Period Amt"; Rec."Last Min Prev. Period Amt")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = g_bol_ShowMinCol;
                }
            }
            part("Allocation Dest. Ratio"; "Allocation Dest. Ratio G/L")
            {
                Caption = 'Ratio G/L Setup';
                SubPageLink = Rule=Field(Rule), Company=Field(Company), "To Account"=Field("To Account");
                Visible = g_bol_ShowRatio;
                ApplicationArea = All;
            }
            part("Allocation Default Dimension"; "Allocation Default Dimension")
            {
                Caption = 'Offset Dimension';
                SubPageLink = Rule=Field(Rule), Type=Const(Destination), Company=Field(Company), "To Account"=Field("To Account");
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Distribution)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = g_bol_ShowPoint;
                Caption = 'Distribution';
                Image = ViewSourceDocumentLine;

                trigger OnAction()
                var
                    l_Rec_AllcoationRule: Record "Allocation Rule";
                    l_pag_PoolDistribution: Page "Pool Distribution List";
                    l_pag_ManagementDistribution: Page "Management Fee Dist. List";
                    l_Rec_PoolDistribution: Record "Pool Distribution";
                    l_rec_ManagementDistribution: Record "Management Fee Distribution";
                begin
                    IF l_Rec_AllcoationRule.GET(Rec.Rule)THEN begin
                        CLEAR(l_pag_PoolDistribution);
                        CLEAR(l_pag_ManagementDistribution);
                        IF l_Rec_AllcoationRule."Point Calculation Day Type" = l_Rec_AllcoationRule."Point Calculation Day Type"::"Revenue Days" THEN begin
                            l_Rec_PoolDistribution.RESET;
                            l_Rec_PoolDistribution.SETRANGE("Source Date", l_Rec_AllcoationRule."Date Last Run");
                            IF l_Rec_PoolDistribution.FINDSET THEN begin
                                l_pag_PoolDistribution.SetTableView(l_Rec_PoolDistribution);
                                l_pag_PoolDistribution.Run();
                            end;
                        end
                        ELSE
                        begin
                            l_rec_ManagementDistribution.RESET;
                            l_rec_ManagementDistribution.SETRANGE("Source Date", l_Rec_AllcoationRule."Date Last Run");
                            IF l_rec_ManagementDistribution.FINDSET THEN begin
                                l_pag_ManagementDistribution.SetTableView(l_rec_ManagementDistribution);
                                l_pag_ManagementDistribution.Run();
                            end;
                        end;
                    end;
                end;
            }
        }
    }
    var g_bol_ShowPercentage: Boolean;
    g_bol_ShowWeight: Boolean;
    g_dec_TotalWeight: Decimal;
    g_bol_ShowPoint: Boolean;
    g_bol_ShowRatio: BOolean;
    g_bol_ShowAmount: Boolean;
    g_bol_ShowMinCol: Boolean;
    trigger OnOpenPage()
    var
        l_Rec_AllocationRule: REcord "Allocation Rule";
    begin
        g_bol_ShowPercentage:=false;
        g_bol_ShowWeight:=false;
        IF l_Rec_AllocationRule.GET(Rec.Rule)THEN;
        CASE l_rec_AllocationRule."Allocation Method" of l_Rec_AllocationRule."Allocation Method"::Percentage: g_bol_ShowPercentage:=TRUE;
        l_Rec_AllocationRule."Allocation Method"::Weight: g_bol_ShowWeight:=true;
        l_Rec_AllocationRule."Allocation Method"::Ratio: g_bol_ShowRatio:=TRUE;
        l_Rec_AllocationRule."Allocation Method"::Point: g_bol_ShowPoint:=TRUE;
        END;
        IF l_Rec_AllocationRule."Date Interval Code" = l_Rec_AllocationRule."Date Interval Code"::Min THEN begin
            g_bol_ShowMinCol:=TRUE;
        end;
        IF g_bol_ShowPoint THEN g_bol_ShowAmount:=false
        ELSE
            g_bol_ShowAmount:=TRUE;
    end;
}
