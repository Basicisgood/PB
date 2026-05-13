table 50146 "IMOS Vessel type FD1 Linkage"
{
    Caption = 'IMOS Vessel type FD1 Linkage';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Vessel Type"; Text[20])
        {
            Caption = 'Vessel Type';
        }
        field(2; "FD1 Dimension Value"; Code[20])
        {
            Caption = 'FD1 Dimension Value';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(1));
        }
    }
    keys
    {
        key(PK; "Vessel Type")
        {
            Clustered = true;
        }
    }
}
