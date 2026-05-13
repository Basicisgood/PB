tableextension 50139 EmployeeLedgerEntry extends "Employee Ledger Entry"
{ //PS006
    fields
    {
        field(50100; "Record Type"; Text[10])
        {
            DataClassification = ToBeClassified;
        //Editable = false;
        }
        field(50101; "Exported to Concur"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(50102; "PB Concur Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        //Editable = false;
        }
        field(50105; "Shortcut Dimension 3 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(3));
        }
        field(50106; "Shortcut Dimension 4 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(4));
        }
        field(50107; "Shortcut Dimension 5 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(5));
        }
        field(50108; "Shortcut Dimension 6 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(6));
        }
        field(50109; "Shortcut Dimension 7 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(7));
        }
        field(50110; "Shortcut Dimension 8 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(8));
        }
        field(50111; "Shortcut Dimension 9 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,9';
            Caption = 'Shortcut Dimension 9 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(9));
        }
        field(50112; "Shortcut Dimension 10 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,10';
            Caption = 'Shortcut Dimension 10 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(10));
        }
        field(50113; "Shortcut Dimension 11 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,11';
            Caption = 'Shortcut Dimension 11 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(11));
        }
        field(50114; "Shortcut Dimension 12 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,12';
            Caption = 'Shortcut Dimension 12 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(12));
        }
        field(50115; "Shortcut Dimension 13 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,13';
            Caption = 'Shortcut Dimension 13 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(13));
        }
        field(50116; "Shortcut Dimension 14 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,14';
            Caption = 'Shortcut Dimension 14 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(14));
        }
        field(50117; "Shortcut Dimension 15 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,15';
            Caption = 'Shortcut Dimension 15 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(15));
        }
        //VJ#68
        field(50121; "Receipt image ID"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        //VJ#68
        //PS008 Start
        field(50122; "External Document No."; code[35])
        {
            DataClassification = ToBeClassified;
        }
        //PS008 End
        //VT20-12-2024 >>
        field(50123; "Concur ID"; text[100])
        {
            Caption = 'Concur ID';
            DataClassification = ToBeClassified;
        }
        field(50124; "Entry Id"; Text[100])
        {
            Caption = 'Entry Id';
        }
        //VT20-12-2024 <<
        field(50125; "ConfirmationResult"; Text[2048])
        {
            Caption = 'ConfirmationResult';
        }
        field(50126; "PaymentConfirmationResult"; Text[2048])
        {
            Caption = 'PaymentConfirmationResult';
        }
        field(50127; "errorMessage"; Text[2048])
        {
            Caption = 'errorMessage';
        }
        field(50128; "Report ID"; text[100])
        {
            Caption = 'Report ID';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50129; "Bank Document No. Applied"; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50130; "Bank Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50162; "Cash Advance"; Boolean)
        { //TEC.VJ 14MAY2025 
        }
        field(50236; "Employee Bank Account"; Code[20]) //NT_ 13-02-2025
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50237; "Payment Confirmed in Concur"; Boolean)
        {
            DataClassification = ToBeClassified; //#372 VJ 18June2025
        }
    }
    keys
    {
    // Add changes to keys here
    }
    fieldgroups
    {
    // Add changes to field groups here
    }
    var myInt: Integer;
}
