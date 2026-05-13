pageextension 50134 ExtVendorList extends "Vendor List"
{
    layout
    {
        addbefore(Blocked)
        {
            field("IMOS Vendor"; Rec."IMOS Vendor")
            {
                ApplicationArea = all;
            }
            field("DNV Vendor"; Rec."DNV Vendor")
            {
                ApplicationArea = all;
            }
            field("GNA Vendor"; Rec."GNA Vendor")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("Sent Emails")
        {
            action(SyncVendors)
            {
                ApplicationArea = all;
                Caption = 'Sync Vendors';
                PromotedCategory = Process;
                Promoted = true;
                Ellipsis = true;
                Image = UpdateDescription;
                ToolTip = 'Sync Vendors';
                Visible = ISMasterCompany;

                trigger OnAction()
                var
                    Log: Record "IMOS API Log";
                    VendorTypeMapping: record "Vendor Type Mapping";
                    Vendor2: record Vendor;
                    CompMapping: record "Company Name Mapping";
                    Vendor: record Vendor;
                    MasterDataSync: Record "Temp Master Data Sync" temporary;
                    DefaultDimension: record "Default Dimension";
                    DefaultDimension2: record "Default Dimension";
                    MasterSyncDetails: Record "Master Sync Details";
                    VendorBankAccounts: Record "Vendor Bank Account";
                    VendorBankAccounts2: Record "Vendor Bank Account";
                    RecDim: Record Dimension;
                //Vendor: record Vendor;
                begin
                    Vendor2.Reset();
                    Vendor2.copy(Rec);
                    SetSelectionFilter(Vendor2);
                    if Vendor2.FindSet()then repeat MasterDataSync.Reset();
                            if MasterDataSync.FindSet()then MasterDataSync.DeleteAll();
                            VendorTypeMapping.Reset();
                            VendorTypeMapping.SetRange("Vendor/Customer No.", Vendor2."No.");
                            if VendorTypeMapping.FindSet()then repeat if(VendorTypeMapping.Type = VendorTypeMapping.Type::Vendor) and (VendorTypeMapping."Company Type" = VendorTypeMapping."Company Type"::IMOS)then begin
                                        //    Vendor2.CreateOutboundLog(0);//TEC.VJ 11082024
                                        vendor2.TestField("Short Name");
                                        VendorTypeMapping.CreateOutboundLogForIMOS(0);
                                        CompMapping.Reset();
                                        CompMapping.SetRange("IMOS Company", true);
                                        if CompMapping.FindSet()then repeat MasterDataSync.Init();
                                                MasterDataSync.No:=vendor2."No.";
                                                MasterDataSync."Company Code":=CompMapping."BC Company Name";
                                                if MasterDataSync.Insert()then;
                                            until CompMapping.Next() = 0;
                                    end;
                                    if(VendorTypeMapping.Type = VendorTypeMapping.Type::Vendor) and (VendorTypeMapping."Company Type" = VendorTypeMapping."Company Type"::DNV)then begin
                                        Vendor2.CreateOutboundLog(0); //TEC.VJ 11082024
                                        Vendor2.CreateOutboundLog(1); //TEC.VJ 11082024
                                        //  VendorTypeMapping.CreateOutboundLogForIMOS(0);
                                        CompMapping.Reset();
                                        CompMapping.SetRange("DNV Company", true);
                                        if CompMapping.FindSet()then repeat MasterDataSync.Init();
                                                MasterDataSync.No:=vendor2."No.";
                                                MasterDataSync."Company Code":=CompMapping."BC Company Name";
                                                if MasterDataSync.Insert()then;
                                            until CompMapping.Next() = 0;
                                    end;
                                    if(VendorTypeMapping.Type = VendorTypeMapping.Type::Vendor) and (VendorTypeMapping."Company Type" = VendorTypeMapping."Company Type"::OTHERS)then begin
                                        CompMapping.Reset();
                                        CompMapping.SetRange("GNA Company", true);
                                        if CompMapping.FindSet()then repeat MasterDataSync.Init();
                                                MasterDataSync.No:=vendor2."No.";
                                                MasterDataSync."Company Code":=CompMapping."BC Company Name";
                                                if MasterDataSync.Insert()then;
                                            until CompMapping.Next() = 0;
                                    end;
                                until VendorTypeMapping.Next() = 0;
                            // Vendor Sync in companies
                            MasterDataSync.Reset();
                            if MasterDataSync.FindFirst()then repeat Vendor.Reset();
                                    Vendor.ChangeCompany(MasterDataSync."Company Code");
                                    Vendor.Init();
                                    Vendor.TransferFields(Vendor2, false);
                                    Vendor."No.":=Vendor2."No.";
                                    if not Vendor.Insert()then Vendor.Modify();
                                    //Vendor Bank accounts
                                    VendorBankAccounts.Reset();
                                    VendorBankAccounts.SetRange("Vendor No.", MasterDataSync.No);
                                    //VendorBankAccounts.SetFilter("Vendor Type", '=%1|%2', VendorBankAccounts."Vendor Type"::BOTH, //VendorBankAccounts."Vendor Type"::IMOS);
                                    if VendorBankAccounts.FindSet()then repeat VendorBankAccounts2.Reset();
                                            VendorBankAccounts2.ChangeCompany((MasterDataSync."Company Code"));
                                            VendorBankAccounts2.Init();
                                            VendorBankAccounts2.TransferFields(VendorBankAccounts, false);
                                            VendorBankAccounts2."Vendor No.":=VendorBankAccounts."Vendor No.";
                                            VendorBankAccounts2.Code:=VendorBankAccounts.Code;
                                            if not VendorBankAccounts2.Insert()then VendorBankAccounts2.Modify();
                                        until VendorBankAccounts.Next() = 0;
                                    //default dimensions
                                    DefaultDimension.Reset();
                                    DefaultDimension.SetRange("Table ID", 23);
                                    DefaultDimension.SetRange("No.", Vendor2."No.");
                                    if DefaultDimension.FindSet()then repeat RecDim.GET(DefaultDimension."Dimension Code"); //TEC-Sgarg- Added
                                            IF NOT RecDim."Sync Not Required" then begin //TEC-Sgarg- Added
                                                DefaultDimension2.Reset();
                                                DefaultDimension2.ChangeCompany(MasterDataSync."Company Code");
                                                DefaultDimension2.Init();
                                                DefaultDimension2."Table ID":=DefaultDimension."Table ID";
                                                DefaultDimension2."No.":=DefaultDimension."No.";
                                                DefaultDimension2."Dimension Code":=DefaultDimension."Dimension Code";
                                                DefaultDimension2."Dimension Value Code":=DefaultDimension."Dimension Value Code";
                                                DefaultDimension2."Value Posting":=DefaultDimension."Value Posting";
                                                if not DefaultDimension2.Insert()then DefaultDimension2.Modify();
                                            end;
                                        until DefaultDimension.Next() = 0;
                                    MasterSyncDetails.Reset();
                                    MasterSyncDetails."Entry No.":=0;
                                    MasterSyncDetails.Code:=MasterDataSync.No;
                                    MasterSyncDetails."Company Name":=MasterDataSync."Company Code";
                                    MasterSyncDetails."Sync DateTime":=CurrentDateTime;
                                    MasterSyncDetails."User ID":=UserId;
                                    MasterSyncDetails.Insert();
                                until MasterDataSync.Next() = 0;
                        until Vendor2.Next() = 0;
                    Vendor2.Reset();
                    clear(Vendor2);
                    CurrPage.SetSelectionFilter(Vendor2);
                    Message('Sync Completed');
                end;
            }
            action(SyncVendorsLog)
            {
                ApplicationArea = all;
                Caption = 'Sync Vendors Log';
                PromotedCategory = Process;
                Promoted = true;
                Ellipsis = true;
                Image = UpdateDescription;
                ToolTip = 'Sync Vendors Log';
                RunObject = page "Master Sync Details";
                RunPageLink = Code=field("No.");

                trigger OnAction()
                var
                begin
                end;
            }
        }
        addlast(navigation)
        {
            action("Company Dimension Mapping")
            {
                ApplicationArea = All;
                Caption = 'Company Dimension Mapping';
                Image = CreateForm;
                Promoted = true;
                PromotedCategory = New;

                trigger OnAction()
                var
                    CompDimMapPage: Page "Company Dimension Mapping";
                    ComDimMap: Record "Vendor Type Mapping";
                    IMOSSetup: Record "IMOS Setup";
                begin
                    IMOSSetup.Get();
                    ComDimMap.Reset();
                    ComDimMap.SetRange("Type", ComDimMap."Type"::Vendor);
                    ComDimMap.SetRange("Vendor/Customer No.", Rec."No.");
                    ComDimMap.SetRange("Vendor Type Dimension", IMOSSetup."Vendor Type Dimension");
                    CompDimMapPage.SetTableView(ComDimMap);
                    CompDimMapPage.LookupMode(true);
                    CompDimMapPage.Run();
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        ISMasterCompany:=CuCommonFunction.IsMasterCompany;
    end;
    var ISMasterCompany: Boolean;
    CuCommonFunction: codeunit 50100;
}
