table 50135 "Consolidate Elimination"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Consolidate No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Consolidate;
        }
        field(2; Rule; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Elimination Rule Header";

            trigger OnValidate()
            var
                EliminationRule_l: Record "Elimination Rule Header";
            begin
                if EliminationRule_l.get(Rule)then begin
                    Description:=EliminationRule_l.Description;
                    "Journal Name":=EliminationRule_l."Journal Name";
                    "Date Last Run":=EliminationRule_l."Date Last Run";
                end;
            end;
        }
        field(3; Description; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Journal Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Date Last Run"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "Consolidate No.", Rule)
        {
            Clustered = true;
        }
    }
}
