table 50144 "PB Purchase Inv. Line Dim Inb"
{
    Caption = 'Purchase Invoice Line Dimension Inbound';
    DataClassification = ToBeClassified;

    fields
    {
        field(2; "Purch Inv Entry No."; Integer)
        {
        }
        field(5; "Purch Inv Line LineNo."; Integer)
        {
        }
        field(10; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(12; LineId; Guid)
        {
            TableRelation = "PB Purchase Invoice Line Inb".SystemId;
        }
        field(48; "Code 2"; Text[25])
        {
        }
        field(50; "Name"; Text[100])
        {
        }
        field(52; "Dimension Code"; Text[25])
        {
        }
        field(54; "Ship Manager Id"; Text[255])
        {
        }
    }
    keys
    {
        key(PK; "Purch Inv Entry No.", "Purch Inv Line LineNo.", "Line No.")
        {
            Clustered = true;
        }
    }
}
