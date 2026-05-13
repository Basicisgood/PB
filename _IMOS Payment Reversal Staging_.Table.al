table 50193 "IMOS Payment Reversal Staging"
{
    Caption = 'IMOS Payment Reversal Staging';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Payment Transaction No."; Code[20])
        {
            Caption = 'Payment Transaction No.';
        }
        field(3; "Payment Transaction Type"; Integer)
        {
            Caption = 'Payment Transaction Type';
        }
        field(4; "Payment Mode"; Text[10])
        {
            Caption = 'Payment Mode';
        }
        field(5; "Payment Mode No"; Text[20])
        {
            Caption = 'Payment Mode No';
        }
        field(6; "External Reference Id"; Text[30])
        {
            Caption = 'External Reference Id';
        }
        field(7; "Vendor No"; Code[30])
        {
            Caption = 'Vendor No';
        }
        field(8; "Vendor Name"; Code[100])
        {
            Caption = 'Vendor Name';
        }
        field(9; "Vendor External Reference"; Code[30])
        {
            Caption = 'Vendor External Reference';
        }
        field(10; "Vendor Reference Code"; Code[30])
        {
            Caption = 'Vendor Reference Code';
        }
        field(11; "Vendor Counry"; Text[30])
        {
            Caption = 'Vendor Counry';
        }
        field(12; "Vendor Country Code"; Code[10])
        {
            Caption = 'Vendor Country Code';
        }
        field(13; Memo; Text[100])
        {
            Caption = 'Memo';
        }
        field(14; Approval; Text[100])
        {
            Caption = 'Approval';
        }
        field(15; "Entry Date"; DateTime)
        {
            Caption = 'Entry Date';
        }
        field(16; "Act Date"; Date)
        {
            Caption = 'Act Date';
        }
        field(17; "Currency Amount"; Decimal)
        {
            Caption = 'Currency Amount';
        }
        field(18; Currency; Code[10])
        {
            Caption = 'Currency';
        }
        field(19; "Base Currency Amount"; Decimal)
        {
            Caption = 'Base Currency Amount';
        }
        field(20; "Last User ID"; Text[100])
        {
            Caption = 'Last User ID';
        }
        field(21; "Bank Code"; Text[20])
        {
            Caption = 'Bank Code';
        }
        field(22; "Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
        }
        field(23; "Bank Short Name"; Text[50])
        {
            Caption = 'Bank Short Name';
        }
        field(24; "Bank Charge"; Decimal)
        {
            Caption = 'Bank Charge';
        }
        field(25; "Exchage Rate Date"; Date)
        {
            Caption = 'Exchage Rate Date';
        }
        field(26; "Other Charges"; Decimal)
        {
            Caption = 'Other Charges';
        }
        field(27; "Other Charges Code"; Text[10])
        {
            Caption = 'Other Charges Code';
        }
        field(28; "Bank Currency"; Code[10])
        {
            Caption = 'Bank Currency';
        }
        field(29; "Bank Amount"; Decimal)
        {
            Caption = 'Bank Amount';
        }
        field(30; "Bank Exch Rate"; Decimal)
        {
            Caption = 'Bank Exch Rate';
        }
        field(31; "Intercompany Code"; Code[10])
        {
            Caption = 'Intercompany Code';
        }
        field(32; "Vendor Coross Reference"; Code[20])
        {
            Caption = 'Vendor Coross Reference';
        }
        field(33; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate';
        }
        field(34; Status;Enum EnumStatus)
        {
            Caption = 'Status';
        }
        field(35; "Cancelled by user"; Code[50])
        {
            Caption = 'Cancelled by user';
        }
        field(36; "Cancelled Datentime"; DateTime)
        {
            Caption = 'Cancelled Datentime';
        }
        field(37; "Posted Document No"; Code[20])
        {
            Caption = 'Posted Document No';
        }
        field(38; "Bank Charge Code"; Code[20])
        {
        }
        field(39; "Error Description"; Text[500])
        {
            Editable = false;
        }
        field(40; "BC Company Code"; Text[50])
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        IMOSPayRevLines: Record "IMOS Payment Reversal Line";
        IMOSPayRevDetails: Record "IMOS Pay Reversal Details";
    begin
        IMOSPayRevLines.Reset();
        IMOSPayRevLines.SetRange("Reverse Entry No.", Rec."Entry No.");
        if IMOSPayRevLines.FindSet()then IMOSPayRevLines.DeleteAll(true);
        IMOSPayRevDetails.Reset();
        IMOSPayRevDetails.SetRange("Entry No.", Rec."Entry No.");
        if IMOSPayRevDetails.FindSet()then IMOSPayRevDetails.DeleteAll(true);
    end;
}
