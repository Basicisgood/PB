page 50131 "Purchase Invoice Inbound List"
{
    ApplicationArea = All;
    Caption = 'DNV Invoice Inbound Data List';
    PageType = List;
    SourceTable = "PB Purchase Invoice Inbound";
    UsageCategory = Lists;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("Finance Company No"; Rec."Finance Company No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Finance Company No field.';
                }
                field("Ship Sign Company No"; Rec."Ship Sign Company No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship Sign Company No field.';
                }
                field("GL Code"; Rec."GL Code")
                {
                    ApplicationArea = all;
                }
                field("Booking Date"; Rec."Booking Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Booking Date field.';
                }
                field("Approved At"; Rec."Approved At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approved At field.';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approved By field.';
                }
                field("Original Invoice No"; Rec."Original Invoice No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Original Invoice No field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Currency Exchange Rate"; Rec."Currency Exchange Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Exchange Rate field.';
                }
                field("Discount %"; Rec."Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discount % field.';
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice Date field.';
                }
                field("Maturity Date"; Rec."Maturity Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maturity Date field.';
                }
                field("Ship Manager"; Rec."Ship Manager")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship Manager field.';
                }
                field("Invoice-Status"; Rec."Invoice-Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice-Status field.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field("Order Code"; Rec."Order Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order Code field.';
                }
                field("Posted Document No Fin Company"; Rec."Posted Document No Fin Company")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Document No Fin Company field.';
                }
                field("Posted Document No Shp Company"; Rec."Posted Document No Shp Company")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Document No Ship Company field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Paid; Rec.Paid)
                {
                    ToolTip = 'Specifies the value of the Paid field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ToolTip = 'Specifies the value of the Error Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Cancelled by User"; Rec."Cancelled by User")
                {
                    ToolTip = 'Specifies the value of the Cancelled by User field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Cancelled Date time"; Rec."Cancelled Date time")
                {
                    ToolTip = 'Specifies the value of the Cancelled Date time field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ToolTip = 'Specifies the value of the Purchase Order No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Posted in Fin Company"; Rec."Posted in Fin Company")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posted in Fin Company field.';
                }
                field("Posted in Ship Company"; Rec."Posted in Ship Company")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posted in Ship Company field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
            }
            part(purchaseInvLine; "Purchase Invoice Line Inb List")
            {
                Caption = 'Invoice Lines';
                // EntityName = 'CommittedCostInbdim';
                // EntitySetName = 'CommittedCostInbdim';
                SubPageLink = "Purch Inv Entry No."=Field("Entry No.");
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Purchase Invoice")
            {
                ApplicationArea = All;
                Caption = 'Create General Journal';
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Create General Journal action.';
                Visible = false;

                trigger OnAction()
                var
                    CreatePurchaseInvoiceAPI: Codeunit "Create Purchase Invoice";
                    CU50143: Codeunit 50143;
                begin
                //CreatePurchaseInvoiceAPI.Run();
                //CU50143.Run();
                end;
            }
            action("Delete All Records")
            {
                ApplicationArea = All;
                Caption = 'Delete All records';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Delete All records action.';
                Visible = false;

                trigger OnAction()
                var
                    DNVInvHeadr: Record "PB Purchase Invoice Inbound";
                    DNVInvLine: record "PB Purchase Invoice Line Inb";
                begin
                    DNVInvHeadr.Reset();
                    if DNVInvHeadr.FindSet()then DNVInvHeadr.DeleteAll();
                    DNVInvLine.Reset();
                    if DNVInvLine.FindSet()then DNVInvLine.DeleteAll();
                    Message('Deleted');
                end;
            }
            action("Update Vendor")
            {
                ApplicationArea = All;
                Caption = 'Update Vendor';
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = false;
                PromotedIsBig = true;
                ToolTip = 'Executes the Update Vendor action.';

                trigger OnAction()
                var
                    PBPurchInvInb: Record "PB Purchase Invoice Inbound";
                    Vendor: Record Vendor;
                begin
                    PBPurchInvInb.Reset();
                    PBPurchInvInb.SetFilter("Vendor No.", '<>%1', '');
                    PBPurchInvInb.SetRange("Finance Company No", CompanyName);
                    if PBPurchInvInb.FindSet()then repeat Vendor.Reset();
                            Vendor.SetRange("DNV Vendor No.", PBPurchInvInb."Vendor No.");
                            if not Vendor.FindSet()then begin
                                Vendor.Reset();
                                Vendor.SetFilter("DNV Vendor No.", '=%1', '');
                                Vendor.FindSet();
                                Vendor."DNV Vendor No.":=PBPurchInvInb."Vendor No.";
                                Vendor.Modify();
                            end
                            else
                            begin
                                Vendor.Blocked:=vendor.Blocked::" ";
                                Vendor.Modify();
                            end;
                        until PBPurchInvInb.Next() = 0;
                    Message('Updated');
                end;
            }
            action("Cancel Records")
            {
                ApplicationArea = All;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cancel Records action.';

                trigger OnAction()
                var
                    PBPurchInvInb: Record "PB Purchase Invoice Inbound";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                    SelectedFilter: Boolean;
                    Text001: Label 'Do you want to Cancel all Selected records in the Purchase Invoice Inbound List?';
                    ConfirmManagement: Codeunit "Confirm Management";
                begin
                    PBPurchInvInb.Reset();
                    CurrPage.SetSelectionFilter(PBPurchInvInb);
                    if ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text001), true)then begin
                        if PBPurchInvInb.FindSet()then repeat if(PBPurchInvInb.Status = PBPurchInvInb.Status::Processed) or (PBPurchInvInb.Status = PBPurchInvInb.Status::"Finanace Company Processed") or (PBPurchInvInb.Status = PBPurchInvInb.Status::"Ship Shop Company Processed")then error('The Line is Processed/Partially Pricessed.');
                                //if PBPurchInvInb.Status <> PBPurchInvInb.Status::Cancel then begin
                                PBPurchInvInb.Status:=PBPurchInvInb.Status::Cancel;
                                PBPurchInvInb."Cancelled by User":=UserId;
                                PBPurchInvInb."Cancelled Date time":=CreateDateTime(Today, Time);
                                PBPurchInvInb."Posted Document No Fin Company":='CANCELLED';
                                PBPurchInvInb."Posted Document No Shp Company":='CANCELLED';
                                PBPurchInvInb.Modify()//end;
                            until PBPurchInvInb.Next() = 0;
                    end;
                end;
            }
            action("Reset Records")
            {
                ApplicationArea = All;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Reset Records action.';

                trigger OnAction()
                var
                    PBPurchInvInb: Record "PB Purchase Invoice Inbound";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                    SelectedFilter: Boolean;
                    Text001: Label 'Do you want to reset all Selected records in the Purchase Invoice Inbound List?';
                    ConfirmManagement: Codeunit "Confirm Management";
                begin
                    PBPurchInvInb.Reset();
                    CurrPage.SetSelectionFilter(PBPurchInvInb);
                    if ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text001), true)then begin
                        if PBPurchInvInb.FindSet()then repeat if(PBPurchInvInb.Status = PBPurchInvInb.Status::Processed) or (PBPurchInvInb.Status = PBPurchInvInb.Status::"Finanace Company Processed") or (PBPurchInvInb.Status = PBPurchInvInb.Status::"Ship Shop Company Processed")then begin
                                    PBPurchInvInb.Status:=PBPurchInvInb.Status::Pending;
                                    PBPurchInvInb."Cancelled by User":='';
                                    PBPurchInvInb."Cancelled Date time":=0DT;
                                    PBPurchInvInb."Posted Document No Fin Company":='';
                                    PBPurchInvInb."Posted Document No Shp Company":='';
                                    PBPurchInvInb."Error Description":='';
                                    PBPurchInvInb."Posted in Ship Company":=false;
                                    PBPurchInvInb."Posted in Fin Company":=false;
                                    PBPurchInvInb.Modify()end;
                            until PBPurchInvInb.Next() = 0;
                    end;
                end;
            }
        }
        area(Navigation)
        {
            action("Inbound Error Log")
            {
                ApplicationArea = all;
                Image = ErrorLog;
                RunObject = page "Inbound Error Log Entry";
                RunPageLink = "Inbound Table"=filter(50131);
                RunPageMode = View;
                RunPageView = sorting("Inbound Table", "Inbound Entry No.")where("Inbound Table"=filter(50131));
                ToolTip = 'Executes the Inbound Error Log action.';
            }
            action("Related Purchase Invoice")
            {
                ApplicationArea = all;
                Image = PurchaseInvoice;
                RunObject = page "Purchase Invoice";
                RunPageLink = "No."=field("Purchase Order No.");
                RunPageMode = Edit;
                RunPageView = sorting("Document Type", "No.");
                ToolTip = 'Executes the Related Purchase Invoice action.';
            }
            action("Related Posted Purchase Invoice")
            {
                ApplicationArea = all;
                Image = PostedTaxInvoice;
                RunObject = page "Posted Purchase Invoice";
                RunPageLink = "Order No."=field("Purchase Order No.");
                RunPageMode = Edit;
                RunPageView = sorting("No.");
                ToolTip = 'Executes the Related Posted Purchase Invoice action.';
            }
        }
    }
}
