tableextension 50121 "Customer Ext." extends Customer
{
    fields
    {
        field(50014; "Reference Code"; Code[20])
        {
            Caption = 'Reference Code';
            DataClassification = ToBeClassified;
        }
        field(51016; "Parent Company"; code[20])
        {
            Caption = 'Parent Company';
            DataClassification = ToBeClassified;
            TableRelation = if("Parent Company Type"=const(Customer))Customer
            else if("Parent Company Type"=const(Vendor))Vendor;
        }
        field(51017; "Name of Shareholder"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52000; "Parent Company Type"; Option)
        {
            OptionMembers = " ", "Customer", "Vendor";
        }
        field(52001; "Short Name"; Text[50])
        {
            Caption = 'Short Name';
        }
        field(52003; "Parent Company CP Type"; Code[20])
        {
            Caption = 'Parent Company Counter Party Type';
            TableRelation = "Vendor Type Mapping"."Vendor Type" where("Vendor/Customer No."=field("Parent Company"), "Company Type"=filter('IMOS'));
        }
        Field(52010; "Max Bank Ref ID"; code[5])
        {
            FieldClass = FlowField;
            CalcFormula = max("Customer Bank Account"."IMOS Ext Ref" where("Customer No."=field("No.")));
            Editable = false;
        }
        //TEC.VJ 17DEC2024>>
        field(52011; "Äddress 3"; Text[100])
        {
            Caption = 'Address 3';
            DataClassification = ToBeClassified;
        }
        field(52012; "Address 4"; Text[100])
        {
            Caption = 'Address 4';
        }
    }
    fieldgroups
    {
    addlast(DropDown;
    "Short Name")
    {
    }
    }
    //TEC.VJ 10092024>>
    trigger OnModify()
    begin
        UpdateCompanyDimensionMap();
    end;
    procedure UpdateCompanyDimensionMap()
    var
        ComDimMapp: Record "Vendor Type Mapping";
    begin
        ComDimMapp.Reset();
        ComDimMapp.SetRange("Type", ComDimMapp."Type"::Customer);
        ComDimMapp.SetRange("Vendor/Customer No.", Rec."No.");
        if ComDimMapp.FindSet()then begin
            ComDimMapp.ModifyAll(Sync, false, true);
        end;
    end;
//TEC.VJ 10092024<<
}
