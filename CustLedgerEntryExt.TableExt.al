tableextension 50106 CustLedgerEntryExt extends "Cust. Ledger Entry"
{
    fields
    {
        field(50110; "Shortcut Dimension 3 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(3));
        }
        field(50111; "Shortcut Dimension 4 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(4));
        }
        field(50112; "Shortcut Dimension 5 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(5));
        }
        field(50113; "Shortcut Dimension 6 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(6));
        }
        field(50114; "Shortcut Dimension 7 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(7));
        }
        field(50115; "Shortcut Dimension 8 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(8));
        }
        field(50116; "Shortcut Dimension 9 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,9';
            Caption = 'Shortcut Dimension 9 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(9));
        }
        field(50117; "Shortcut Dimension 10 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,10';
            Caption = 'Shortcut Dimension 10 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(10));
        }
        field(50118; "Shortcut Dimension 11 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,11';
            Caption = 'Shortcut Dimension 11 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(11));
        }
        field(50119; "Shortcut Dimension 12 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,12';
            Caption = 'Shortcut Dimension 12 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(12));
        }
        field(50120; "Shortcut Dimension 13 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,13';
            Caption = 'Shortcut Dimension 13 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(13));
        }
        field(50121; "Shortcut Dimension 14 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,14';
            Caption = 'Shortcut Dimension 14 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(14));
        }
        field(50122; "Shortcut Dimension 15 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,15';
            Caption = 'Shortcut Dimension 15 Code_pb';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(15));
        }
        field(50400; "IMOS Transaction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50401; "IMOS Transaction No"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50402; "Remittance Company No"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50403; "Remittance Account No"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50404; "Remittance Full Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50405; "IMOS Bank ID"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        //TEC.VJ 06MAR2025>>
        field(50406; "Bank Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50407; "Bank Document No. Applied"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(60006; "Over Receipt"; Boolean)
        {
            Caption = 'Over Receipt';
            DataClassification = ToBeClassified;
        }
        field(60007; "Over Receipt Amount"; Decimal)
        {
            Caption = 'Over Receipt Amount';
            DataClassification = ToBeClassified;
        }
        field(60008; "Bank Charges Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60009; "CP External Document No"; Text[35])
        {
            DataClassification = ToBeClassified;
        }
    }
}
