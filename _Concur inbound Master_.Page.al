page 50260 "Concur inbound Master"
{
    ApplicationArea = All;
    Caption = 'Concur inbound Master';
    PageType = List;
    SourceTable = "Concur Inbound Master";
    SourceTableView = sorting("Report ID", "External Doc No.")order(descending);
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                //field("Entry no."; Rec."Entry no.")
                //{ }
                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = All;
                }
                field("External Doc No."; Rec."External Doc No.")
                {
                    ApplicationArea = All;
                }
                field("Payment Date"; Rec."Payment Date")
                {
                    ApplicationArea = All;
                }
                field("Emp Id"; Rec."Emp Id")
                {
                    ApplicationArea = All;
                }
                field("Report Currency"; Rec."Report Currency")
                {
                    ApplicationArea = All;
                }
                field("Cash Ledger"; Rec."Cash Ledger")
                {
                    ApplicationArea = All;
                }
                field("Fin Company Code"; Rec."Fin Company Code")
                {
                    ApplicationArea = All;
                }
                field("Ship Company Code"; Rec."Ship Company Code")
                {
                    ApplicationArea = All;
                }
                field("Create DateTime"; Rec."Create DateTime")
                {
                    ApplicationArea = All;
                }
                field("Posted Doc No. Fin Company"; Rec."Posted Doc No. Fin Company")
                {
                    ApplicationArea = All;
                }
                field("Posted Doc No. Ship Company"; Rec."Posted Doc No. Ship Company")
                {
                    ApplicationArea = All;
                }
                field("Fin Company Posted Doc No."; Rec."Fin Company Posted Doc No.")
                {
                    ApplicationArea = All;
                }
                field("Ship Company Posted Doc No."; Rec."Ship Company Posted Doc No.")
                {
                    ApplicationArea = All;
                }
                field("Fin Status "; Rec."Fin Status")
                {
                    ApplicationArea = All;
                }
                field("Ship Status "; Rec."Ship Status")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Details")
            {
                ApplicationArea = All;
                Image = RelatedInformation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    P_50217: Page "Concur inbound financial Expen";
                    ConCurFin: Record "Concur inbound financial Expen";
                begin
                    Clear(P_50217);
                    ConCurFin.reset;
                    ConCurFin.SetRange("Report ID", Rec."Report ID");
                    ConCurFin.SetRange("Report Key", Rec."External Doc No.");
                    IF ConCurFin.FindSet()then begin
                        P_50217.SetTableView(ConCurFin);
                        P_50217.RunModal();
                    end;
                end;
            }
            action("Create General Journal")
            {
                ApplicationArea = All;
                Caption = 'Create General Journal';
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ConcurFinExpProcessNew: Codeunit Concur_FinExpenseProcessNew;
                begin
                    clear(ConcurFinExpProcessNew);
                    ConcurFinExpProcessNew.Run();
                end;
            }
        }
    }
}
