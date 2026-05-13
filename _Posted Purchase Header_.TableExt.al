tableextension 50120 "Posted Purchase Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(50101; "Invoice Link"; Text[1024])
        {
            Caption = 'Invoice Link';
            DataClassification = CustomerContent;
        }
        field(50201; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(3), Blocked=const(false));
        }
        field(50202; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(4), Blocked=const(false));
        }
        field(50203; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(5), Blocked=const(false));
        }
        field(50204; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(6), Blocked=const(false));
        }
        field(50205; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(7), Blocked=const(false));
        }
        field(50206; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(8), Blocked=const(false));
        }
        field(50207; "Shortcut Dimension 9 Code"; Code[20])
        {
            CaptionClass = '1,2,9';
            Caption = 'Shortcut Dimension 9 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(9), Blocked=const(false));
        }
        field(50208; "Shortcut Dimension 10 Code"; Code[20])
        {
            CaptionClass = '1,2,10';
            Caption = 'Shortcut Dimension 10 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(10), Blocked=const(false));
        }
        field(50209; "Shortcut Dimension 11 Code"; Code[20])
        {
            CaptionClass = '1,2,11';
            Caption = 'Shortcut Dimension 11 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(11), Blocked=const(false));
        }
        field(50210; "Shortcut Dimension 12 Code"; Code[20])
        {
            CaptionClass = '1,2,12';
            Caption = 'Shortcut Dimension 12 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(12), Blocked=const(false));
        }
        field(50211; "Shortcut Dimension 13 Code"; Code[20])
        {
            CaptionClass = '1,2,13';
            Caption = 'Shortcut Dimension 13 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(13), Blocked=const(false));
        }
        field(50212; "Shortcut Dimension 14 Code"; Code[20])
        {
            CaptionClass = '1,2,14';
            Caption = 'Shortcut Dimension 14 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(14), Blocked=const(false));
        }
        field(50213; "Shortcut Dimension 15 Code"; Code[20])
        {
            CaptionClass = '1,2,15';
            Caption = 'Shortcut Dimension 15 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(15), Blocked=const(false));
        }
        field(50214; "PB DNV invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50215; "DNV Approved At"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50216; "DNV Approved By"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50217; "PB Ship Manager ID"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        Field(50218; "DNV Staging Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
}
