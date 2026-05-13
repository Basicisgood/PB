pageextension 50117 "Customer List Ext." extends "Customer List"
{
    actions
    {
        addafter("Sent Emails")
        {
            action("Counter Party Mapping")
            {
                ApplicationArea = All;
                Caption = 'Counter Party Mapping';
                Image = CreateForm;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Visible = ISMasterCompany;

                trigger OnAction()
                var
                    CompDimMapPage: Page "Company Dimension Mapping";
                    ComDimMap: Record "Vendor Type Mapping";
                    IMOSSetup: Record "IMOS Setup";
                begin
                    IMOSSetup.Get();
                    ComDimMap.Reset();
                    ComDimMap.SetRange("Type", ComDimMap."Type"::Customer);
                    ComDimMap.SetRange("Vendor/Customer No.", Rec."No.");
                    ComDimMap.SetRange("Vendor Type Dimension", IMOSSetup."Vendor Type Dimension");
                    CompDimMapPage.SetTableView(ComDimMap);
                    CompDimMapPage.LookupMode(true);
                    CompDimMapPage.Run();
                end;
            }
            action(SyncCustomers)
            {
                ApplicationArea = all;
                Caption = 'Sync Customer';
                PromotedCategory = Process;
                Promoted = true;
                Ellipsis = true;
                Image = UpdateDescription;
                ToolTip = 'Sync Customer';
                Visible = ISMasterCompany;

                trigger OnAction()
                var
                    Log: Record "IMOS API Log";
                    VendorTypeMapping: record "Vendor Type Mapping";
                    Customer2: record Customer;
                    CompMapping: record "Company Name Mapping";
                    Customer: record Customer;
                    MasterDataSync: Record "Temp Master Data Sync" temporary;
                    DefaultDimension: record "Default Dimension";
                    DefaultDimension2: record "Default Dimension";
                    MasterSyncDetails: Record "Master Sync Details";
                    CustomerBankAccounts: Record "Customer Bank Account";
                    CustomerBankAccounts2: Record "Customer Bank Account";
                    RecDim: Record Dimension;
                //Vendor: record Vendor;
                begin
                    Customer2.Reset();
                    SetSelectionFilter(Customer2);
                    if Customer2.FindSet()then repeat MasterDataSync.Reset();
                            if MasterDataSync.FindSet()then MasterDataSync.DeleteAll();
                            VendorTypeMapping.Reset();
                            VendorTypeMapping.SetRange("Vendor/Customer No.", Customer2."No.");
                            if VendorTypeMapping.FindSet()then repeat if(VendorTypeMapping.Type = VendorTypeMapping.Type::Customer) and (VendorTypeMapping."Company Type" = VendorTypeMapping."Company Type"::IMOS)then begin
                                        VendorTypeMapping.CreateOutboundLogForIMOS(0);
                                        CompMapping.Reset();
                                        CompMapping.SetRange("IMOS Company", true);
                                        if CompMapping.FindSet()then repeat MasterDataSync.Init();
                                                MasterDataSync.No:=Customer2."No.";
                                                MasterDataSync."Company Code":=CompMapping."BC Company Name";
                                                if MasterDataSync.Insert()then;
                                            until CompMapping.Next() = 0;
                                    end;
                                    if(VendorTypeMapping.Type = VendorTypeMapping.Type::Customer) and (VendorTypeMapping."Company Type" = VendorTypeMapping."Company Type"::DNV)then begin
                                        VendorTypeMapping.CreateOutboundLog(0);
                                        CompMapping.Reset();
                                        CompMapping.SetRange("DNV Company", true);
                                        if CompMapping.FindSet()then repeat MasterDataSync.Init();
                                                MasterDataSync.No:=Customer2."No.";
                                                MasterDataSync."Company Code":=CompMapping."BC Company Name";
                                                if MasterDataSync.Insert()then;
                                            until CompMapping.Next() = 0;
                                    end;
                                    if(VendorTypeMapping.Type = VendorTypeMapping.Type::Customer) and (VendorTypeMapping."Company Type" = VendorTypeMapping."Company Type"::OTHERS)then begin
                                        CompMapping.Reset();
                                        CompMapping.SetRange("GNA Company", true);
                                        if CompMapping.FindSet()then repeat MasterDataSync.Init();
                                                MasterDataSync.No:=Customer2."No.";
                                                MasterDataSync."Company Code":=CompMapping."BC Company Name";
                                                if MasterDataSync.Insert()then;
                                            until CompMapping.Next() = 0;
                                    end;
                                until VendorTypeMapping.Next() = 0;
                            // Vendor Sync in companies
                            MasterDataSync.Reset();
                            if MasterDataSync.FindSet()then repeat Customer.Reset();
                                    Customer.ChangeCompany(MasterDataSync."Company Code");
                                    Customer.Init();
                                    Customer.TransferFields(Customer2, false);
                                    Customer."No.":=Customer2."No.";
                                    if not Customer.Insert()then Customer.Modify();
                                    //Vendor Bank accounts
                                    CustomerBankAccounts.Reset();
                                    CustomerBankAccounts.SetRange("Customer No.", MasterDataSync.No);
                                    if CustomerBankAccounts.FindSet()then repeat CustomerBankAccounts2.Reset();
                                            CustomerBankAccounts2.ChangeCompany((MasterDataSync."Company Code"));
                                            CustomerBankAccounts2.Init();
                                            CustomerBankAccounts2.TransferFields(CustomerBankAccounts, false);
                                            CustomerBankAccounts2."Customer No.":=CustomerBankAccounts."Customer No.";
                                            CustomerBankAccounts2.Code:=CustomerBankAccounts.Code;
                                            if not CustomerBankAccounts2.Insert()then CustomerBankAccounts2.Modify();
                                        until CustomerBankAccounts.Next() = 0;
                                    //default dimensions
                                    DefaultDimension.Reset();
                                    DefaultDimension.SetRange("Table ID", 18);
                                    DefaultDimension.SetRange("No.", Customer2."No.");
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
                        until Customer2.Next() = 0;
                    Message('Sync Completed');
                end;
            }
            action(SyncCustomersLog)
            {
                ApplicationArea = all;
                Caption = 'Sync Customers Log';
                PromotedCategory = Process;
                Promoted = true;
                Ellipsis = true;
                Image = UpdateDescription;
                ToolTip = 'Sync Customers Log';
                RunObject = page "Master Sync Details";
                RunPageLink = Code=field("No.");

                trigger OnAction()
                var
                begin
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
