page 50274 "GlobalHSBCOutSentOrError"
{
    ApplicationArea = All;
    Caption = 'GlobalHSBCOutSentOrError';
    PageType = List;
    SourceTable = "HSBC Outbound Staging Table";
    UsageCategory = Lists;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(G1)
            {
                Caption = '';

                field("From Date"; g_dat_FromDate)
                {
                    ApplicationArea = all;
                }
                field("To Date"; g_dat_ToDate)
                {
                    ApplicationArea = ALl;
                }
                field("Company Filter"; g_txt_CompanyList)
                {
                    ApplicationArea = All;
                }
            }
            repeater(General)
            {
                field("ACH Payment Set Code"; Rec."ACH Payment Set Code")
                {
                    ToolTip = 'Specifies the value of the ACH Payment Set Code field.', Comment = '%';
                }
                field("API Information"; Rec."API Information")
                {
                    ToolTip = 'Specifies the value of the API Information field.';
                }
                field("API Status"; Rec."API Status")
                {
                    ToolTip = 'Specifies the value of the API Status field.', Comment = '%';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Applied Entries to XML"; Rec."Applied Entries to XML")
                {
                    ToolTip = 'Specifies the value of the Applied Entries to XML field.', Comment = '%';
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ToolTip = 'Specifies the value of the Bal. Account No. field.', Comment = '%';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ToolTip = 'Specifies the value of the Bal. Account Type field.', Comment = '%';
                }
                field("Bank Document No."; Rec."Bank Document No.")
                {
                    ToolTip = 'Specifies the value of the Bank Document No. field.', Comment = '%';
                }
                field("Bank Integration Type"; Rec."Bank Integration Type")
                {
                    ToolTip = 'Specifies the value of the Bank Integration Type field.', Comment = '%';
                }
                field("Batch Id"; Rec."Batch Id")
                {
                    ToolTip = 'Specifies the value of the Batch Id field.', Comment = '%';
                }
                field("Batch Type"; Rec."Batch Type")
                {
                    ToolTip = 'Specifies the value of the Batch Type field.', Comment = '%';
                }
                field("Charges Bearer"; Rec."Charges Bearer")
                {
                    ToolTip = 'Specifies the value of the Charge Bearer field.', Comment = '%';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Code field.', Comment = '%';
                }
                field("Create Date"; Rec."Create Date")
                {
                    ToolTip = 'Specifies the value of the Create Date field.', Comment = '%';
                }
                field("Creditor ABA/BSB No."; Rec."Creditor ABA/BSB No.")
                {
                    ToolTip = 'Specifies the value of the ABA/BSB No. field.', Comment = '%';
                }
                field("Creditor Address"; Rec."Creditor Address")
                {
                    ToolTip = 'Specifies the value of the Creditor Address field.', Comment = '%';
                }
                field("Creditor Address 2"; Rec."Creditor Address 2")
                {
                    ToolTip = 'Specifies the value of the Creditor Address 2 field.', Comment = '%';
                }
                field("Creditor Address 3"; Rec."Creditor Address 3")
                {
                    ToolTip = 'Specifies the value of the Creditor Address 3 field.', Comment = '%';
                }
                field("Creditor Bank Acc Name"; Rec."Creditor Bank Acc Name")
                {
                    ToolTip = 'Specifies the value of the Creditor Bank Acc Name field.', Comment = '%';
                }
                field("Creditor Bank Account"; Rec."Creditor Bank Account")
                {
                    ToolTip = 'Specifies the value of the Creditor Bank Account field.', Comment = '%';
                }
                field("Creditor Bank Branch Code"; Rec."Creditor Bank Branch Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Bank Branch Code field.', Comment = '%';
                }
                field("Creditor Bank Clearing Code"; Rec."Creditor Bank Clearing Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Bank Clearing Code field.', Comment = '%';
                }
                field("Creditor Country"; Rec."Creditor Country")
                {
                    ToolTip = 'Specifies the value of the Creditor Country field.', Comment = '%';
                }
                field("Creditor Currency Code"; Rec."Creditor Currency Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Currency Code field.', Comment = '%';
                }
                field("Creditor Email Address 1"; Rec."Creditor Email Address 1")
                {
                    ToolTip = 'Specifies the value of the Creditor Email Address 1 field.', Comment = '%';
                }
                field("Creditor Email Address 2"; Rec."Creditor Email Address 2")
                {
                    ToolTip = 'Specifies the value of the Creditor Email Address 2 field.', Comment = '%';
                }
                field("Creditor Email Address 3"; Rec."Creditor Email Address 3")
                {
                    ToolTip = 'Specifies the value of the Creditor Email Address 3 field.', Comment = '%';
                }
                field("Creditor Email Address 4"; Rec."Creditor Email Address 4")
                {
                    ToolTip = 'Specifies the value of the Creditor Email Address 4 field.', Comment = '%';
                }
                field("Creditor Email Address 5"; Rec."Creditor Email Address 5")
                {
                    ToolTip = 'Specifies the value of the Creditor Email Address 5 field.', Comment = '%';
                }
                field("Creditor Email Address 6"; Rec."Creditor Email Address 6")
                {
                    ToolTip = 'Specifies the value of the Creditor Email Address 6 field.', Comment = '%';
                }
                field("Creditor IBAN Account"; Rec."Creditor IBAN Account")
                {
                    ToolTip = 'Specifies the value of the Creditor IBAN Account field.', Comment = '%';
                }
                field("Creditor IFSC Code"; Rec."Creditor IFSC Code")
                {
                    ToolTip = 'Specifies the value of the Creditor IFSC Code field.', Comment = '%';
                }
                field("Creditor Inter. Bank Acc. No"; Rec."Creditor Inter. Bank Acc. No")
                {
                    ToolTip = 'Specifies the value of the Creditor Intermediary Bank Account No field.', Comment = '%';
                }
                field("Creditor Inter. Bank Country"; Rec."Creditor Inter. Bank Country")
                {
                    ToolTip = 'Specifies the value of the Creditor Intermediary Bank Country field.', Comment = '%';
                }
                field("Creditor Inter. Bank SWIFT"; Rec."Creditor Inter. Bank SWIFT")
                {
                    ToolTip = 'Specifies the value of the Creditor Intermediary Bank SWIFT field.', Comment = '%';
                }
                field("Creditor Post Code"; Rec."Creditor Post Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Post Code field.', Comment = '%';
                }
                field("Creditor Swift Code"; Rec."Creditor Swift Code")
                {
                    ToolTip = 'Specifies the value of the Creditor Swift Code field.', Comment = '%';
                }
                field(Currency; Rec.Currency)
                {
                    ToolTip = 'Specifies the value of the Currency field.', Comment = '%';
                }
                field("Debtor ABA Routing Code"; Rec."Debtor ABA Routing Code")
                {
                    ToolTip = 'Specifies the value of the Debtor ABA Routing Code field.', Comment = '%';
                }
                field("Debtor ACH ID"; Rec."Debtor ACH ID")
                {
                    ToolTip = 'Specifies the value of the Debtor ACH ID field.', Comment = '%';
                }
                field("Debtor Address"; Rec."Debtor Address")
                {
                    ToolTip = 'Specifies the value of the Debtor Address field.', Comment = '%';
                }
                field("Debtor Address 2"; Rec."Debtor Address 2")
                {
                    ToolTip = 'Specifies the value of the Debtor Address 2 field.', Comment = '%';
                }
                field("Debtor Bank Acc Name"; Rec."Debtor Bank Acc Name")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Acc Name field.', Comment = '%';
                }
                field("Debtor Bank Account"; Rec."Debtor Bank Account")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Account field.', Comment = '%';
                }
                field("Debtor Bank Address"; Rec."Debtor Bank Address")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Address field.', Comment = '%';
                }
                field("Debtor Bank Address 2"; Rec."Debtor Bank Address 2")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Address 2 field.', Comment = '%';
                }
                field("Debtor Bank Clearing Code"; Rec."Debtor Bank Clearing Code")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Clearing Code field.', Comment = '%';
                }
                field("Debtor Bank Country"; Rec."Debtor Bank Country")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Country field.', Comment = '%';
                }
                field("Debtor Bank Post Code"; Rec."Debtor Bank Post Code")
                {
                    ToolTip = 'Specifies the value of the Debtor Bank Post Code field.', Comment = '%';
                }
                field("Debtor Country"; Rec."Debtor Country")
                {
                    ToolTip = 'Specifies the value of the Debtor Country field.', Comment = '%';
                }
                field("Debtor Currency Code"; Rec."Debtor Currency Code")
                {
                    ToolTip = 'Specifies the value of the Debtor Currency Code field.', Comment = '%';
                }
                field("Debtor Name"; Rec."Debtor Name")
                {
                    ToolTip = 'Specifies the value of the Debtor  Name field.', Comment = '%';
                }
                field("Debtor Post Code"; Rec."Debtor Post Code")
                {
                    ToolTip = 'Specifies the value of the Debtor Post Code field.', Comment = '%';
                }
                field("Debtor SWIFT Code"; Rec."Debtor SWIFT Code")
                {
                    ToolTip = 'Specifies the value of the Debtor SWIFT Code field.', Comment = '%';
                }
                field("Debtor To Receipt"; Rec."Debtor To Receipt")
                {
                    ToolTip = 'Specifies the value of the Message To Receipt field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ToolTip = 'Specifies the value of the Exchange Rate field.', Comment = '%';
                }
                field("FPS No."; Rec."FPS No.")
                {
                    ToolTip = 'Specifies the value of the FPS No. field.', Comment = '%';
                }
                field("FPS Type"; Rec."FPS Type")
                {
                    ToolTip = 'Specifies the value of the FPS Type field.', Comment = '%';
                }
                field(Identification; Rec.Identification)
                {
                    ToolTip = 'Specifies the value of the Identification field.', Comment = '%';
                }
                field("Instruction to Bank"; Rec."Instruction to Bank")
                {
                    ToolTip = 'Specifies the value of the Instruction to Bank field.', Comment = '%';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ToolTip = 'Specifies the value of the Journal Template Name field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ToolTip = 'Specifies the value of the Payment Method field.', Comment = '%';
                }
                field("Payment Method Bank XML"; Rec."Payment Method Bank XML")
                {
                    ToolTip = 'Specifies the value of the Payment Method Bank XML field.', Comment = '%';
                }
                field("Payment Purpose"; Rec."Payment Purpose")
                {
                    ToolTip = 'Specifies the value of the Payment Purpose field.', Comment = '%';
                }
                field("Payment Reference No."; Rec."Payment Reference No.")
                {
                    ToolTip = 'Specifies the value of the Payment Reference No. field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Purpose Code"; Rec."Purpose Code")
                {
                    ToolTip = 'Specifies the value of the Purpose Code field.', Comment = '%';
                }
                field("Remittance Email 6"; Rec."Remittance Email 6")
                {
                    ToolTip = 'Specifies the value of the Remittance Email 6 field.', Comment = '%';
                }
                field("Service Level"; Rec."Service Level")
                {
                    ToolTip = 'Specifies the value of the Service Level field.', Comment = '%';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ToolTip = 'Specifies the value of the Source Code field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Trans. Amt."; Rec."Trans. Amt.")
                {
                    ToolTip = 'Specifies the value of the Trans. Amt. field.', Comment = '%';
                }
                field("Trans. Currency"; Rec."Trans. Currency")
                {
                    ToolTip = 'Specifies the value of the Trans. Currency field.', Comment = '%';
                }
                field("Trigger API"; Rec."Trigger API")
                {
                    ToolTip = 'Specifies the value of the Trigger API field.', Comment = '%';
                }
                field("Word Link"; Rec."Word Link")
                {
                    ToolTip = 'Specifies the value of the Word Link field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Refresh)
            {
                trigger OnAction()
                begin
                    RefreshList();
                end;
            }
        }
    }
    local procedure RefreshList(): integer var
        myInt: Integer;
        l_Rec_Company: Record Company;
        l_rec_Outbound: Record "HSBC Outbound Staging Table";
        l_int_EntryNo: integer;
    begin
        Rec.RESET;
        REC.DELETEALL;
        l_Rec_Company.RESET;
        IF g_txt_CompanyList <> '' THEN l_Rec_Company.SETFILTER(Name, g_txt_CompanyList);
        IF l_Rec_Company.FINDSET THEN repeat l_rec_Outbound.RESET;
                l_rec_Outbound.ChangeCompany(l_Rec_Company.Name);
                l_rec_Outbound.SETRANGE("Create Date", g_dat_FromDate, g_dat_ToDate);
                l_rec_Outbound.SETFILTER(Status, '%1|%2|%3', l_rec_Outbound.Status::Sent, l_rec_Outbound.Status::Fail, l_rec_Outbound.Status::Rejected);
                IF l_rec_Outbound.FINDSET THEN repeat IF not g_bol_CheckCountOnly THEN BEGIN
                            REc:=l_rec_Outbound;
                            IF Rec.INSERT THEN;
                        END;
                        l_int_EntryNo+=1;
                    UNTIL l_rec_Outbound.NEXT = 0;
            UNTIL l_Rec_Company.NEXT = 0;
        EXIT(l_int_EntryNo);
    end;
    procedure CountRecords(CountOnly: Boolean): integer var
        l_rec_BankAPISetup: Record "Bank API Setup";
    begin
        IF l_rec_BankAPISetup.GET THEN;
        g_bol_CheckCountOnly:=CountOnly;
        IF g_dat_FromDate = 0D THEN begin
            g_dat_FromDate:=CalcDate(l_rec_BankAPISetup."Bank API List Date Formula", TODAY);
            g_dat_ToDate:=TODAY;
        end;
        g_txt_CompanyList:=l_rec_BankAPISetup."Company Code Filter list";
        EXIT(RefreshList);
    end;
    trigger OnOpenPage()
    var
    begin
        //g_dat_FromDate := CALCDATE('<-1W>', TODAY);
        //g_dat_ToDate := TODAY;
        CountRecords(FALSE);
    end;
    var g_txt_CompanyList: Text;
    g_bol_CheckCountOnly: boolean;
    g_dat_FromDate: Date;
    g_dat_ToDate: Date;
}
