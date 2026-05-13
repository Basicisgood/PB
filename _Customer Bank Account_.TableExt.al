tableextension 50123 "Customer Bank Account" extends "Customer Bank Account"
{
    fields
    {
        field(50017; "Email Address 1"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Email Address 2"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Email Address 3"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Email Address 4"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50021; "Email Address 5"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50022; "Charge Bearer"; Option)
        {
            OptionMembers = "SHA", "OUR", "BEN";
            OptionCaption = 'SHA,OUR,BEN';
            DataClassification = ToBeClassified;
        }
        field(50025; "Email Address 6"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Address 3"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50027; "Address 4"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50028; "Bene Bank Address 1"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50029; "Bene Bank Address 2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        //#242 TEC.VJ 03MARCH2025>>>>
        field(50030; "IFSC Code"; Code[20])
        {
            Caption = 'IFSC Code';
            DataClassification = ToBeClassified;
        }
        field(50031; "Payment Purpose"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50032; "CNAPS No."; Text[12])
        {
        }
        field(50033; "UK Clearing Code"; Text[27])
        {
        }
        field(50034; "Correspon. Bank Charges Method"; code[1])
        {
            DataClassification = ToBeClassified;
            InitValue = 'A';
            Caption = 'Correspondent Bank Charges Method';
        }
        field(50035; "bank Code"; Code[50])
        {
            Caption = 'Bank Code';
        }
        field(50037; "Email Name 1"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50038; "Email Name 2"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50039; "Email Name 3"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50040; "Email Name 4"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50041; "Email Name 5"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50045; "Email Name 6"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        // field(50046; "Vendor Type"; Enum VendBankType)
        // {
        //     DataClassification = ToBeClassified;
        //     trigger OnValidate()
        //     var
        //         Vendor: record Vendor;
        //     begin
        //         if (rec."Vendor Type" = rec."Vendor Type"::IMOS) or (rec."Vendor Type" = rec."Vendor Type"::BOTH) then begin
        //             Vendor.get(Rec." No.");
        //             Vendor.CalcFields("Max Bank Ref ID");
        //             if Vendor."Max Bank Ref ID" = '' then
        //                 rec."IMOS Ext Ref" := 'B1'
        //             else begin
        //                 Rec."IMOS Ext Ref" := IncStr(Vendor."Max Bank Ref ID");
        //             end;
        //         end;
        //     end;
        // }
        field(50047; "Default Pay Method"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50048; "Beneficiary Name 2"; Text[35])
        {
            Caption = 'Beneficiary Name 2';
            DataClassification = ToBeClassified;
        }
        field(50049; "Beneficiary Name 3"; Text[35])
        {
            Caption = 'Beneficiary Name 3';
            DataClassification = ToBeClassified;
        }
        field(50100; "Beneficiary Name"; Text[35]) //Changed length to 35 from 100
        {
            Caption = 'Beneficiary Name';
            DataClassification = ToBeClassified;
        }
        field(50101; "ABA/BSB No."; Text[100])
        {
            Caption = 'ABA/BSB No.';
            DataClassification = ToBeClassified;
        }
        field(50102; "IMOS Ext Ref"; code[5])
        {
            Caption = 'IMOS Ext Ref';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50103; "Correspondent Bank Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Correspondent Branch"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "Correspondent Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        //  Caption = 'Address';
        }
        field(50107; "Corresp. Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(50108; "Correspondent Swift Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "SWIFT Code";
        }
        field(50109; "Correspondent Bank Account No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50110; "Correspondent IBAN No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50111; "Correspondent ABA/BSB No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50112; "Branch"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50113; "Res. PB"; Boolean)
        {
            Caption = 'Res. PB';
            DataClassification = ToBeClassified;
        }
        field(50114; Inact; Boolean)
        {
            Caption = 'Inact';
            DataClassification = ToBeClassified;
        }
        field(50115; "Is Inactive"; Boolean)
        {
            Caption = 'Is Inactive';
            DataClassification = ToBeClassified;
        }
        field(50116; "Is Default"; Boolean)
        {
            Caption = 'Is Default';
            DataClassification = ToBeClassified;
        }
        modify("Address 2")
        {
        trigger OnBeforeValidate()
        begin
            IF StrLen("Address 2") > 35 then Error('Address 2 String length %1 must be less then 35 charactor.', StrLen("Address 2"));
        end;
        }
        modify(Address)
        {
        trigger OnBeforeValidate()
        begin
            IF StrLen(Address) > 35 then Error('Address String length %1 must be less then 35 charactor.', StrLen(Address));
        end;
        }
    }
    //TEC.VJ 10092024>>
    trigger OnModify()
    begin
    //        CreateOutboundLogForIMOS(1);
    end;
    procedure CreateOutboundLogForIMOS(P_Type: Option Insert, Update)
    var
        IMOSOutboundLog: Record "IMOS API Log";
        Log: Record "IMOS API Log";
    begin
        Log.reset;
        Log.SetCurrentKey("Table No.", "Primary key", Status);
        Log.SetRange("Table No.", Database::"Customer Bank Account");
        Log.SetRange("Primary key 2", Rec."Customer No.");
        Log.SetRange("Primary key 3", Rec.Code);
        Log.SetFilter(Status, '<>%1', Log.Status::Success);
        IF Not Log.FindFirst()then begin
            IMOSOutboundLog.Init();
            IMOSOutboundLog."Table No.":=Database::"Customer Bank Account";
            IMOSOutboundLog."Primary key 2":=Rec."Customer No.";
            IMOSOutboundLog."Primary key 3":=Rec.Code;
            IMOSOutboundLog."Entry Type":=P_Type;
            IMOSOutboundLog.Status:=IMOSOutboundLog.Status::Pending;
            IMOSOutboundLog.Insert(true);
        End;
    end;
//TEC.VJ 10092024<<
}
