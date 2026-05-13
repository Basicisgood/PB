table 50102 "Allocation Destination"
{
    Caption = 'Allocation Destination';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Rule; Code[20])
        {
            Caption = 'Rule';
            DataClassification = CustomerContent;
            TableRelation = "Allocation Rule";
        }
        field(5; Company; Code[50])
        {
            Caption = 'Company';
            TableRelation = "IC Partner".Code;
        }
        field(6; "Current Company"; boolean)
        {
            trigger OnValidate()
            begin
                IF "Current Company" then Company:='';
            end;
        }
        field(9; "Basis ID"; Code[20])
        {
            Caption = 'Basic ID';
        }
        field(10; "To Account"; Code[20])
        {
            Caption = 'To Account';
            TableRelation = "IC G/L Account";
        }
        field(11; "Fixed Percentage"; integer)
        {
        }
        field(12; "Fixed Weight"; Decimal)
        {
        }
        field(13; "Same as Source"; Boolean)
        {
        }
        field(34; "Last Destination Amount get"; decimal)
        {
        }
        field(35; "Last Destination Factor Amt"; Decimal)
        {
        }
        field(36; "Last Destination Ratio"; Decimal)
        {
        }
        field(37; "Last Destination PointXDays"; DEcimal)
        {
        }
        field(38; "Last Min Curr. Period Amt"; Decimal)
        {
        }
        field(39; "Last Min Prev. Period Amt"; Decimal)
        {
        }
    }
    keys
    {
        key(PK; Rule, Company, "Current Company", "To Account")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        CheckPercentage;
    end;
    trigger OnModify()
    begin
        CheckPercentage;
    end;
    procedure CheckPercentage()
    var
        l_Rec_AllocationDestination: Record "Allocation Destination";
        l_int_Percentage: Integer;
    begin
        l_Rec_AllocationDestination.RESET;
        l_Rec_AllocationDestination.SetRange(Rule, Rule);
        IF l_Rec_AllocationDestination.FINDSET THEN repeat IF(l_Rec_AllocationDestination.Company = Rec.Company) AND (l_Rec_AllocationDestination."To Account" = Rec."To Account")THEN begin
                    l_int_Percentage+=Rec."Fixed Percentage";
                end
                ELSE
                begin
                    l_int_Percentage+=l_Rec_AllocationDestination."Fixed Percentage";
                end;
            UNTIl l_Rec_AllocationDestination.NEXT = 0;
        IF l_int_Percentage > 100 then ERROR('Percentage exceeded 100%');
    end;
}
