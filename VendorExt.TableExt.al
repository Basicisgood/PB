tableextension 50108 VendorExt extends "Vendor"
{
    fields
    {
        field(50000; "Is Agent"; Boolean)
        {
        }
        field(50001; "Is Delivery Address"; Boolean)
        {
        }
        field(50002; "Is Dockyard"; Boolean)
        {
            Caption = 'Is Shipyard';
        }
        field(50003; "Is Manufacturer"; Boolean)
        {
        }
        field(50004; "Is Service"; Boolean)
        {
        }
        field(50005; "Is Supplier"; Boolean)
        {
            InitValue = true;
        }
        field(50006; "Is Invoice Address"; Boolean)
        {
        }
        field(50007; "InActive Date"; Date)
        {
        }
        field(50008; "Transmission Format"; Option)
        {
            OptionMembers = "ShipServ", "Telex", "Web Portal", "Excel", "Phone";
        }
        field(50012; "Remarks"; Text[250])
        {
        }
        field(50013; "Area"; Text[250])
        {
        }
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
        field(52002; "DNV Vendor No."; Text[20])
        {
            Caption = 'DNV Vendor No.';
        }
        field(52003; "Parent Company CP Type"; Code[20])
        {
            Caption = 'Parent Company Counter Party Type';
            TableRelation = "Vendor Type Mapping"."Vendor Type" where("Vendor/Customer No."=field("Parent Company"), "Company Type"=filter('IMOS'));
        }
        field(52004; "IMOS Vendor"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Vendor Type Mapping" where("Vendor/Customer No."=field("No."), "Company Type"=filter('IMOS')));
            Editable = false;
        }
        field(52005; "DNV Vendor"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Vendor Type Mapping" where("Vendor/Customer No."=field("No."), "Company Type"=filter('DNV')));
            Editable = false;
        }
        field(52006; "GNA Vendor"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Vendor Type Mapping" where("Vendor/Customer No."=field("No."), "Company Type"=filter('OTHERS')));
            Editable = false;
        }
        Field(52010; "Max Bank Ref ID"; code[5])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = max("Vendor Bank Account"."IMOS Ext Ref" where("Vendor No."=field("No."), "Vendor Type"=filter('IMOS|BOTH')));
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
        //TEC.VJ 17DEC2024<<
        field(52013; "e-Commerce ID"; Text[7])
        {
            Caption = 'e-Commerce ID';
        }
    }
    fieldgroups
    {
    addlast(DropDown;
    "Short Name")
    {
    }
    }
    //TEC.VJ 11082024
    // trigger OnInsert()
    // begin
    //     CreateOutboundLog(0);
    // end;
    trigger OnModify()
    begin
        // CreateOutboundLog(1);
        UpdateCompanyDimensionMap(); //TEC.VJ 10092024
    end;
    procedure CreateOutboundLog(P_Type: Option Insert, Update)
    var
        OutboundLog: Record "DNV Outbound Log";
        Log: Record "DNV Outbound Log";
    begin
        //Log.reset;
        //Log.SetCurrentKey("Table No.", "Primary key", Status);
        //Log.SetRange("Table No.", 23);
        //Log.SetRange("Primary key", Rec."No.");
        //if P_Type = P_Type::Insert then
        //  Log.SetRange("Entry Type", Log."Entry Type"::Insert);
        //if P_Type = P_Type::Update then
        //  Log.SetRange("Entry Type", Log."Entry Type"::Update);
        //Log.SetFilter(Status, '<>%1', Log.Status::Success);  // temp blocked
        //IF Not Log.FindFirst() then begin
        OutboundLog.Init();
        OutboundLog."Table No.":=23;
        if Rec."DNV Vendor No." = '' then OutboundLog."Primary key":=rec."No."
        else
            OutboundLog."Primary key":=rec."DNV Vendor No.";
        OutboundLog."Entry Type":=P_Type;
        OutboundLog.Status:=OutboundLog.Status::Pending;
        OutboundLog."Company Name":=CompanyName;
        OutboundLog.Insert(true);
    //End;
    end;
    //TEC.VJ 10092024>>
    procedure UpdateCompanyDimensionMap()
    var
        ComDimMapp: Record "Vendor Type Mapping";
    begin
        ComDimMapp.Reset();
        ComDimMapp.SetRange("Type", ComDimMapp."Type"::Vendor);
        ComDimMapp.SetRange("Vendor/Customer No.", Rec."No.");
        if ComDimMapp.FindSet()then begin
            ComDimMapp.ModifyAll(Sync, false, true);
        end;
    end;
//TEC.VJ 10092024<<
}
