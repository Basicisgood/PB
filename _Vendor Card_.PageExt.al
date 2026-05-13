pageextension 50109 "Vendor Card" extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            field("Reference Code"; Rec."Reference Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reference Code field.', Comment = '%';
            }
            field("InActive Date"; Rec."InActive Date")
            {
                ApplicationArea = all;
            }
            field("Parent Company Type"; Rec."Parent Company Type")
            {
                ApplicationArea = all;
            }
            field("Parent Company"; Rec."Parent Company")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Parent Company field.', Comment = '%';
            }
            field("Parent Company CP Type"; Rec."Parent Company CP Type")
            {
                ApplicationArea = all;
            }
            field("Short Name"; Rec."Short Name")
            {
                ApplicationArea = All;
            }
            field("DNV Vendor No."; Rec."DNV Vendor No.")
            {
                ApplicationArea = all;
            }
            field("Name of Shareholder"; Rec."Name of Shareholder")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Name of Shareholder field.', Comment = '%';
            }
        }
        //
        addafter(Invoicing)
        {
            group("DNV Integration")
            {
                field("Telex No."; Rec."Telex No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Telex No. field.', Comment = '%';
                }
                field("Area"; Rec."Area")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Area field.', Comment = '%';
                }
                field("Is Agent"; Rec."Is Agent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is Agent field.', Comment = '%';
                }
                field("Is Delivery Address"; Rec."Is Delivery Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is Delivery Address field.', Comment = '%';
                }
                field("Is Dockyard"; Rec."Is Dockyard")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is Dockyard field.', Comment = '%';
                    Caption = 'Is Shipyard';
                }
                field("Is Manufacturer"; Rec."Is Manufacturer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is Manufacturer field.', Comment = '%';
                }
                field("Is Service"; Rec."Is Service")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is Service field.', Comment = '%';
                }
                field("Is Supplier"; Rec."Is Supplier")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is Supplier field.', Comment = '%';
                }
                //DNV Integration
                field("Transmission Format"; Rec."Transmission Format")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transmission Format field.', Comment = '%';
                }
                field("e-Commerce ID"; Rec."e-Commerce ID")
                {
                    ApplicationArea = all;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                }
            }
        }
        addafter("Address 2")
        {
            field("Äddress 3"; Rec."Äddress 3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address 3 field.', Comment = '%';
            }
            field("Address 4"; Rec."Address 4")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address 4 field.', Comment = '%';
            }
        }
    }
    actions
    {
        addafter(ApplyTemplate)
        {
            // action("Replicate Vendor")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedIsBig = true;
            //     PromotedCategory = Process;
            //     trigger OnAction()
            //     var
            //         RecRef: RecordRef;
            //         PrimaryKeyRef: KeyRef;
            //         PrimaryKeyFldCount: Integer;
            //         ReplicateMgmt: Codeunit "Replication Management";
            //     begin
            //         clear(ReplicateMgmt);
            //         RecRef.GETTABLE(Rec);
            //         PrimaryKeyRef := RecRef.KEYINDEX(1);
            //         PrimaryKeyFldCount := PrimaryKeyRef.FIELDCOUNT;
            //         ReplicateMgmt.ReplicateMasters(RecRef.NUMBER, PrimaryKeyFldCount, PrimaryKeyRef);
            //     end;
            // }
            action(CopyAddressFromCustomer)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Caption = 'Copy Address From Customer';

                trigger OnAction()
                var
                    CopyAddressCustomerVendor: Codeunit CopyAddressCustomerVendor;
                begin
                    CopyAddressCustomerVendor.CopyAddressFromCustomer(Rec);
                    CurrPage.Update();
                end;
            }
            action("Vendor Type")
            {
                ApplicationArea = All;
                Caption = 'Vendor Type';
                Image = CreateForm;
                Promoted = true;
                PromotedCategory = Process;

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
}
