table 50222 "DBase Setup"
{
    Caption = 'DBase Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; DBase; Text[250])
        {
            Caption = 'DBase';
        }
    }
    keys
    {
        key(PK; DBase)
        {
            Clustered = true;
        }
    }
}
