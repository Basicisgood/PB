table 50202 "Allocation Default Dimension"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Rule; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Type;Enum "Allocation Rule Type ENum")
        {
        }
        field(3; Company; Code[50])
        {
            Caption = 'Company';
            TableRelation = "IC Partner".Code;
            NotBlank = true;
        }
        field(4; "To Account"; Code[20])
        {
            Caption = 'To Account';
            TableRelation = "IC G/L Account";
        }
        field(5; "Line No."; Integer)
        {
        }
        field(6; "Dimension Code"; Code[20])
        {
            // TableRelation = Dimension.Code;
            trigger OnLookup()
            var
                l_rec_Dimension: Record Dimension;
            begin
                l_rec_Dimension.Reset();
                if(Company <> '') and (Type = Type::Destination)then l_rec_Dimension.ChangeCompany(Company);
                if Page.RunModal(Page::Dimensions, l_rec_Dimension) = Action::LookupOK then "Dimension Code":=l_rec_Dimension.Code;
            end;
        }
        field(7; "Dimension Value Code"; Code[20])
        {
            // TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Code"),
            //                                              Blocked = const(false));
            trigger OnLookup()
            var
                l_rec_DimenValue: Record "Dimension Value";
            begin
                l_rec_DimenValue.Reset();
                if(Company <> '') and (Type = Type::Destination)then l_rec_DimenValue.ChangeCompany(Company);
                l_rec_DimenValue.SetRange("Dimension Code", "Dimension Code");
                l_rec_DimenValue.SetRange(Blocked, false);
                if l_rec_DimenValue.FindSet()then;
                if Page.RunModal(Page::"Dimension Values", l_rec_DimenValue) = Action::LookupOK then "Dimension Value Code":=l_rec_DimenValue.Code;
            end;
        }
    }
    keys
    {
        key(Key1; "Rule", "Type", "Company", "To Account", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    // Add changes to field groups here
    }
    var myInt: Integer;
    trigger OnInsert()
    begin
    end;
    trigger OnModify()
    begin
    end;
    trigger OnDelete()
    begin
    end;
    trigger OnRename()
    begin
    end;
}
