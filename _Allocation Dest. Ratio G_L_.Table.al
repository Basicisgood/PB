table 50206 "Allocation Dest. Ratio G/L"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Rule; Code[20])
        {
            Caption = 'Rule';
            DataClassification = CustomerContent;
            TableRelation = "Allocation Rule";
        }
        field(2; Company; Code[50])
        {
            Caption = 'Company';
            TableRelation = "IC Partner".Code;
            NotBlank = true;
        }
        field(3; "To Account"; Code[20])
        {
            Caption = 'To Account';
            TableRelation = "IC G/L Account";
        }
        field(4; "Line No."; Integer)
        {
        }
        field(5; "Field Setting"; Option)
        {
            Caption = 'Field Setting';
            DataClassification = CustomerContent;
            OptionMembers = "Main Account", "Financial Dimension";
            OptionCaption = 'Main Account,Financial Dimension';
        }
        field(6; Name; Code[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
            TableRelation = If("Field Setting"=const("Financial Dimension"))"Dimension";
        }
        field(7; "Source Criteria"; Text[250])
        {
            Caption = 'Source Criteria';
            DataClassification = CustomerContent;
            TableRelation = if("Field Setting"=const("Main Account"))"G/L Account"
            else if("Field Setting"=const("Financial Dimension"))"Dimension Value".Code where("Dimension Code"=field(Name));
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                l_rec_GLList: Record "G/L Account";
                l_pag_GLList: Page "Chart of Accounts (G/L)";
                l_Rec_DimList: Record "Dimension Value";
                l_pag_DimList: Page "Dimension Value List";
            begin
                CASE "Field Setting" of "Field Setting"::"Main Account": begin
                    CLEAR(l_pag_GLList);
                    l_pag_GLList.LookupMode:=TRUE;
                    IF l_pag_GLList.RunModal() = Action::LookupOK THEN begin
                        "Source Criteria":=l_pag_GLList.GetSelectionFilter();
                    end;
                end;
                "Field Setting"::"Financial Dimension": begin
                    TESTFIELD(Name);
                    l_Rec_DimList.RESET;
                    l_Rec_DimList.SETRANGE("Dimension Code", Name);
                    IF l_Rec_DimList.FINDSET THEN;
                    CLEAR(l_pag_DimList);
                    l_pag_DImList.SetTableView(l_Rec_DimList);
                    l_pag_DimList.LookupMode:=TRUE;
                    IF l_pag_DimList.RunModal() = Action::LookupOK THEN begin
                        "Source Criteria":=l_pag_DimList.GetSelectionFilter;
                    end;
                end;
                END;
            end;
        }
        field(8; "Subtraction"; boolean)
        {
        }
    }
    keys
    {
        key(PK; Rule, Company, "To Account", "Line No.")
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
