report 50168 "Update GLE Application"
{
    ApplicationArea = All;
    Caption = 'Update GLE Application';
    UsageCategory = ReportsAndAnalysis;
    //  UseRequestPage = false;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Company; Company)
        {
            RequestFilterFields = Name;
            DataItemTableView = sorting(Name);

            trigger OnAfterGetRecord()
            begin
                Win.Update(1, Company.Name);
                GLE.ChangeCompany(Company.Name);
                DGLE.ChangeCompany(Company.Name);
                GLE.reset;
                GLE.SetFilter("Posting Date", '>%1', PDate);
                IF GLE.FindFirst()then repeat DGLE.reset;
                        DGLE.SetRange("G/L Entry No.", GLE."Entry No.");
                        DGLE.SetRange("Entry Type", DGLE."Entry Type"::"Initial Entry");
                        IF DGLE.FindFirst()then begin
                            DGLE.Amount:=GLE."Original Amount PB";
                            DGLE."Amount (LCY)":=GLE.Amount;
                            DGLE.Modify();
                        End;
                    until GLE.Next() = 0;
                Commit();
                GLE.ChangeCompany(Company.Name);
                DGLE.ChangeCompany(Company.Name);
                DGLE2.ChangeCompany(Company.Name);
                DGLE.Reset();
                DGLE.SetRange("Entry Type", DGLE."Entry Type"::Application);
                DGLE.SetRange("Amount (LCY)", 0);
                IF DGLE.FindFirst()then repeat DGLE2.GET(DGLE."Entry No.");
                        DGLE2."Amount Before Patch":=DGLE.Amount;
                        DGLE2."Amount(LCY) Before Patch":=DGLE."Amount (LCY)";
                        DGLE2."Amount (LCY)":=DGLE.Amount;
                        GLE.GET(DGLE."G/L Entry No.");
                        DGLE2.Amount:=DGLE.Amount * GLE."Original Currency Factor PB";
                        DGLE2.Modify();
                    until DGLE.Next() = 0;
            end;
            trigger OnPreDataItem()
            begin
                PDate:=20250331D;
                Win.Open('#1##################');
            end;
            trigger OnPostDataItem()
            begin
                win.Close();
                Message('Patch Done');
            end;
        }
    }
    var PDate: date;
    GLE: Record "G/L Entry";
    DGLE: Record "Detailed G/L Entry PB";
    DGLE2: Record "Detailed G/L Entry PB";
    Win: Dialog;
}
