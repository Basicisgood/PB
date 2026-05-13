pageextension 50115 "Customer Card" extends "Customer Card"
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
            field("Name of Shareholder"; Rec."Name of Shareholder")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Name of Shareholder field.', Comment = '%';
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
        addafter(Contact)
        {
            // action("Replicate Customer")
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
            action(CopyAddressFromVendor)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Caption = 'Copy Address From Vendor';

                trigger OnAction()
                var
                    CopyAddressCustomerVendor: Codeunit CopyAddressCustomerVendor;
                begin
                    CopyAddressCustomerVendor.CopyAddressFromVendor(Rec);
                    CurrPage.Update();
                end;
            }
            action("Company Dimension Mapping")
            {
                ApplicationArea = All;
                Caption = 'Counter Party';
                Image = CreateForm;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

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
        }
    }
}
