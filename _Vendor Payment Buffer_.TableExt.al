tableextension 50144 "Vendor Payment Buffer" extends "Vendor Payment Buffer"
{
    fields
    {
        field(50100; "Bank Document No. Applied"; Code[20])
        { //#179 TEC.VJ 22012025
            Caption = 'Bank Document No. Applied';
            DataClassification = ToBeClassified;
        }
        field(50101; "Bank Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}
