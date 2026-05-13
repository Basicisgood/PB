page 50217 "Concur inbound financial Expen"
{
    ApplicationArea = All;
    Caption = 'Concur inbound financial Expen';
    PageType = List;
    SourceTable = "Concur inbound financial Expen";
    SourceTableView = sorting("Entry no.")order(descending);
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry no."; Rec."Entry no.")
                {
                    ToolTip = 'Specifies the value of the Entry no. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Concur ID"; Rec."Concur ID")
                {
                    ToolTip = 'Specifies the value of the Batch ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Batch Date"; Rec."Batch Date")
                {
                    ToolTip = 'Specifies the value of the Batch Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Sequence Number"; Rec."Sequence Number")
                {
                    ToolTip = 'Specifies the value of the Sequence Number field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("EMP ID"; Rec."EMP ID")
                {
                    ToolTip = 'Specifies the value of the EMP ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the value of the Last Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the value of the First Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Group ID"; Rec."Group ID")
                {
                    ToolTip = 'Specifies the value of the Group ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Org Unit 1 Region"; Rec."Employee Org Unit 1 Region")
                {
                    ToolTip = 'Specifies the value of the Employee Org Unit 1 Region field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Org Unit 3  "; Rec."Employee Org Unit 3")
                {
                    ToolTip = 'Specifies the value of the Employee Org Unit 3 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Org Unit 4-FD5"; Rec."Employee Org Unit 4-FD5")
                {
                    ToolTip = 'Specifies the value of the Employee Org Unit 4-FD5 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("New FD5"; Rec."New FD5")
                {
                    ToolTip = 'Specifies the value of the New FD5 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report ID"; Rec."Report ID")
                {
                    ToolTip = 'Specifies the value of the Report ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                //PS009 Start
                field(UUID; Rec.UUID)
                {
                    ToolTip = 'Specifies the value of the UUID field.', Comment = '%';
                    ApplicationArea = All;
                }
                //PS009 End
                field("Report Key"; Rec."Report Key")
                {
                    ToolTip = 'Specifies the value of the Report Key field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Ledger; Rec.Ledger)
                {
                    ToolTip = 'Specifies the value of the Ledger field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Reimbursement Currency Alpha ISE"; Rec."reimb. Currency Alpha ISE")
                {
                    ToolTip = 'Specifies the value of the Reimbursement Currency Alpha ISE field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Home Country"; Rec."Home Country")
                {
                    ToolTip = 'Specifies the value of the Home Country field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Submit Date"; Rec."Report Submit Date")
                {
                    ToolTip = 'Specifies the value of the Report Submit Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report User Defined Date"; Rec."Report User Defined Date")
                {
                    ToolTip = 'Specifies the value of the Report User Defined Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Payment Processing Date"; Rec."Report Payment Processing Date")
                {
                    ToolTip = 'Specifies the value of the Report Payment Processing Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Name"; Rec."Report Name")
                {
                    ToolTip = 'Specifies the value of the Report Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report image required"; Rec."Report image required")
                {
                    ToolTip = 'Specifies the value of the Report image required field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report has VAT entry"; Rec."Report has VAT entry")
                {
                    ToolTip = 'Specifies the value of the Report has VAT entry field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report has TA entry"; Rec."Report has TA entry")
                {
                    ToolTip = 'Specifies the value of the Report has TA entry field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Total Post Amount"; Rec."Report Total Post Amount")
                {
                    ToolTip = 'Specifies the value of the Report Total Post Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Total Approved Amount"; Rec."Report Total Approved Amount")
                {
                    ToolTip = 'Specifies the value of the Report Total Approved Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Policy Name"; Rec."Report Policy Name")
                {
                    ToolTip = 'Specifies the value of the Report Policy Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Org Unit 3   Division"; Rec."Report Org Unit 3   Division")
                {
                    ToolTip = 'Specifies the value of the Report Org Unit 3   Division field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Org Unit 4   Company"; Rec."Report Org Unit 4   Company")
                {
                    ToolTip = 'Specifies the value of the Report Org Unit 4   Company field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Custom 12   "; Rec."Report Custom 12   ")
                {
                    ToolTip = 'Specifies the value of the Report Custom 12 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Custom 13-Corp Card accounts Code"; Rec."Custom 13-Corp Card acc Code")
                {
                    ToolTip = 'Specifies the value of the Custom 13-Corp Card accounts Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Custom 14-Employee Account code"; Rec."Custom 14-Employee Acc code")
                {
                    ToolTip = 'Specifies the value of the Custom 14-Employee Account code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Custom 17  "; Rec."Report Custom 17  ")
                {
                    ToolTip = 'Specifies the value of the Report Custom 17 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Id"; Rec."Entry Id")
                {
                    Caption = 'Entry Id';
                    ToolTip = 'Specifies the value of the Entry Id field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Transaction Type"; Rec."Entry Transaction Type")
                {
                    ToolTip = 'Specifies the value of the Entry Transaction Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Expense Type Name"; Rec."Expense Type Name")
                {
                    ToolTip = 'Specifies the value of the Expense Type Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Transaction Date"; Rec."Entry Transaction Date")
                {
                    ToolTip = 'Specifies the value of the Entry Transaction Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Spend Currency Alpha ISO"; Rec."Spend Currency Alpha ISO")
                {
                    ToolTip = 'Specifies the value of the Spend Currency Alpha ISO field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Currency Exchange Rate"; Rec."Currency Exchange Rate")
                {
                    ToolTip = 'Specifies the value of the Currency Exchange Rate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Exchange Rate Direction"; Rec."Exchange Rate Direction")
                {
                    ToolTip = 'Specifies the value of the Exchange Rate Direction field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Personal"; Rec."Is Personal")
                {
                    ToolTip = 'Specifies the value of the Is Personal field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Description"; Rec."Entry Description")
                {
                    ToolTip = 'Specifies the value of the Entry Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vendor Description"; Rec."Vendor Description")
                {
                    ToolTip = 'Specifies the value of the Vendor Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Receipt Received"; Rec."Receipt Received")
                {
                    ToolTip = 'Specifies the value of the Receipt Received field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Receipt Type"; Rec."Receipt Type")
                {
                    ToolTip = 'Specifies the value of the Receipt Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Total Employee Attendee"; Rec."Total Employee Attendee")
                {
                    ToolTip = 'Specifies the value of the Total Employee Attendee field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Attendee count spouse"; Rec."Attendee count spouse")
                {
                    ToolTip = 'Specifies the value of the Attendee count spouse field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Attendee count business"; Rec."Attendee count business")
                {
                    ToolTip = 'Specifies the value of the Attendee count business field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Entry Custom 1   Project Code"; Rec."Report Entry Custom1 Proj Code")
                {
                    ToolTip = 'Specifies the value of the Report Entry Custom 1   Project Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Entry Custom 2   (DOC code)"; Rec."Report Entry Custom2(DOC code)")
                {
                    ToolTip = 'Specifies the value of the Report Entry Custom 2   (DOC code) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Entry Custom 3   Client Travelling"; Rec."Report Entry Custom3 CT trvl")
                {
                    ToolTip = 'Specifies the value of the Report Entry Custom 3   Client Travelling field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Custom 35-Tax Reclaim Country"; Rec."Custom 35-Tax Reclaim Country")
                {
                    ToolTip = 'Specifies the value of the Custom 35-Tax Reclaim Country field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Custom 39-Tax Reclaim Amount"; Rec."Custom 39-Tax Reclaim Amount")
                {
                    ToolTip = 'Specifies the value of the Custom 39-Tax Reclaim Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Custom 40-Net of Tax Amount"; Rec."Custom 40-Net of Tax Amount")
                {
                    ToolTip = 'Specifies the value of the Custom 40-Net of Tax Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Foreign Entry Transaction Amount"; Rec."Foreign Entry Trans. Amount")
                {
                    ToolTip = 'Specifies the value of the Foreign Entry Transaction Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Posted Amount (Incl GST)"; Rec."Entry Posted Amount (Incl GST)")
                {
                    ToolTip = 'Specifies the value of the Entry Posted Amount (Incl GST) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Approved Amount"; Rec."Entry Approved Amount")
                {
                    ToolTip = 'Specifies the value of the Entry Approved Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Payment Code "; Rec."Entry Payment Code ")
                {
                    ToolTip = 'Specifies the value of the Entry Payment Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Payment Code Name"; Rec."Entry Payment Code Name")
                {
                    ToolTip = 'Specifies the value of the Entry Payment Code Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Country"; Rec."Entry Country")
                {
                    ToolTip = 'Specifies the value of the Entry Country field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Country Sub"; Rec."Entry Country Sub")
                {
                    ToolTip = 'Specifies the value of the Entry Country Sub field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Domestic Foreign"; Rec."Domestic Foreign")
                {
                    ToolTip = 'Specifies the value of the Domestic Foreign field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(PayerPayType; Rec.PayerPayType)
                {
                    ToolTip = 'Specifies the value of the PayerPayType field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(PayeePayType; Rec.PayeePayType)
                {
                    ToolTip = 'Specifies the value of the PayeePayType field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(PayeePayCode; Rec.PayeePayCode)
                {
                    ToolTip = 'Specifies the value of the PayeePayCode field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(DRCR; Rec.DRCR)
                {
                    ToolTip = 'Specifies the value of the DRCR field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(JournalAmt; Rec.JournalAmt)
                {
                    ToolTip = 'Specifies the value of the JournalAmt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Journal Key"; Rec."Journal Key")
                {
                    ToolTip = 'Specifies the value of the Journal Key field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Allocation Alloc Key"; Rec."Allocation Alloc Key")
                {
                    ToolTip = 'Specifies the value of the Allocation Alloc Key field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Allocation Percentage"; Rec."Allocation Percentage")
                {
                    ToolTip = 'Specifies the value of the Allocation Percentage field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Future Use - RES for Bank Account"; Rec."Future Use-RES for Bank Acc")
                {
                    ToolTip = 'Specifies the value of the Future Use - RES for Bank Account field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Future Use - RES for Routing Number"; Rec."Future Use-RES for Rtn Number")
                {
                    ToolTip = 'Specifies the value of the Future Use - RES for Routing Number field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Tax authority name"; Rec."Tax authority name")
                {
                    ToolTip = 'Specifies the value of the Tax authority name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Tax label"; Rec."Tax label")
                {
                    ToolTip = 'Specifies the value of the Tax label field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Tax transaction amount"; Rec."Tax transaction amount")
                {
                    ToolTip = 'Specifies the value of the Tax transaction amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Tax posted amount"; Rec."Tax posted amount")
                {
                    ToolTip = 'Specifies the value of the Tax posted amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Tax source"; Rec."Tax source")
                {
                    ToolTip = 'Specifies the value of the Tax source field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Tax reclaim transaction amount"; Rec."Tax reclaim transaction amount")
                {
                    ToolTip = 'Specifies the value of the Tax reclaim transaction amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Tax reclaim posted amount"; Rec."Tax reclaim posted amount")
                {
                    ToolTip = 'Specifies the value of the Tax reclaim posted amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Reclaim Domestic Flag"; Rec."Reclaim Domestic Flag")
                {
                    ToolTip = 'Specifies the value of the Reclaim Domestic Flag field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Entry Tax Adjusted Amount"; Rec."Report Entry Tax Adj. Amount")
                {
                    ToolTip = 'Specifies the value of the Report Entry Tax Adjusted Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Entry Tax Reclaim Adjusted Amount "; Rec."Report Entry Tax Reclm Adj.Amt")
                {
                    ToolTip = 'Specifies the value of the Report Entry Tax Reclaim Adjusted Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Entry Tax Reclaim Transaction Adjusted Amount"; Rec."Report Entry Tax Rec T_Adj.Amt")
                {
                    ToolTip = 'Specifies the value of the Report Entry Tax Reclaim Transaction Adjusted Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Net Tax Amount"; Rec."Net Tax Amount")
                {
                    ToolTip = 'Specifies the value of the Net Tax Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Entry Total Reclaim Adjusted Amount"; Rec."Report Entry Tax Reclm Adj.Amt")
                {
                    ToolTip = 'Specifies the value of the Report Entry Total Reclaim Adjusted Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Net adjusted Reclaim Amount"; Rec."Net adjusted Reclaim Amount")
                {
                    ToolTip = 'Specifies the value of the Net adjusted Reclaim Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ToolTip = 'Specifies the value of the Payment Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Cashledger Employee Name"; Rec."Cashledger Employee Name")
                {
                    ToolTip = 'Specifies the value of the Cashledger Employee Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code (FD1_Subsegment)"; Rec."Global Dim 1 Code (FD1_Subseg)")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code (FD1_Subsegment) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code (FD10_JType)"; Rec."Global Dim 2 Code (FD10_JType)")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code (FD10_JType) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5 Code FD5_Department "; Rec."Shortcut Dim 5 Code FD5_Dept ")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code FD5_Department field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 6 Code FD6_Employee"; Rec."Shortcut Dim 6 Code FD6_Emp")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 6 Code FD6_Employee field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 8 Code FD8_Company"; Rec."Shortcut Dim 8 Code FD8_Comp")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 8 Code FD8_Company field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Report Org Unit 3"; Rec."Report Org Unit 3")
                {
                    ApplicationArea = all;
                }
                field("Status "; Rec."Status ")
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Description (Error message)"; Rec."Description (Error message)")
                {
                    ToolTip = 'Specifies the value of the Description (Error message) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Creation date/time "; Rec."Creation date/time ")
                {
                    ToolTip = 'Specifies the value of the Creation date/time field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Processed date/time "; Rec."Processed date/time ")
                {
                    ToolTip = 'Specifies the value of the Processed date/time field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Process status "; Rec."Process status ")
                {
                    ToolTip = 'Specifies the value of the Process status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Process error message "; Rec."Process error message ")
                {
                    ToolTip = 'Specifies the value of the Process error message field.', Comment = '%';
                    ApplicationArea = All;
                }
                //
                field("Journal Type"; Rec."Journal Type")
                {
                    ApplicationArea = All;
                }
                field("Report Currency"; Rec."Report Currency")
                {
                    ApplicationArea = All;
                }
                field(Shipsign; Rec.Shipsign)
                {
                    ApplicationArea = All;
                }
                field("Entry Custom 2(DOC Code)"; Rec."Entry Custom 2(DOC Code)")
                {
                    Caption = 'DOC Code';
                    ApplicationArea = All;
                }
                field("Employee name"; Rec."Employee name")
                {
                    Caption = 'Employee Id (Cash Ledger)';
                    ApplicationArea = All;
                }
                field("Journal Tax Amount"; Rec."Journal Tax Amount")
                {
                    ApplicationArea = All;
                }
                field("Journal Net Amount"; Rec."Journal Net Amount")
                {
                    Caption = 'Journal Net Amount(ecl Tax)';
                    ApplicationArea = All;
                }
                field("Calculated Tax Amount"; Rec."Calculated Tax Amount")
                {
                    ApplicationArea = All;
                }
                field("Entry Date"; Rec."Entry Date")
                {
                    Caption = 'Transactions date';
                    ApplicationArea = All;
                }
                field("Tax id"; Rec."Tax id")
                {
                    ApplicationArea = All;
                }
                //PS006 Start
                // field("Expense Status"; Rec."Expense Status")
                // {
                //     ApplicationArea = all;
                // }
                // field("Finance Company No"; Rec."Finance Company No")
                // {
                //     ApplicationArea = all;
                // }
                // field("Ship Sign Company No"; Rec."Ship Sign Company No")
                // {
                //     ApplicationArea = all;
                // }
                // field("Posted Document No Fin Company"; Rec."Posted Document No Fin Company")
                // {
                //     ApplicationArea = all;
                // }
                // field("Posted Document No Shp Company"; Rec."Posted Document No Shp Company")
                // {
                //     ApplicationArea = all;
                // }
                // field("Error Description"; Rec."Error Description")
                // {
                //     ApplicationArea = all;
                // }
                field("Cancelled by User"; Rec."Cancelled by User")
                {
                    ApplicationArea = all;
                }
                field("Cancelled Date time"; Rec."Cancelled Date time")
                {
                    ApplicationArea = all;
                }
                //PS006 End
                field("Receipt image ID"; Rec."Receipt image ID")
                {
                    ToolTip = 'Specifies the value of the Receipt image ID field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create General Journal")
            {
                ApplicationArea = All;
                Caption = 'Create General Journal';
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    ConcurFinExpProcess: Codeunit Concur_FinExpenseProcess;
                begin
                    ConcurFinExpProcess.Run();
                // CU50143.Run();
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

                trigger OnAction()
                var
                    ConcurFinExpen: Record "Concur inbound financial Expen";
                begin
                    ConcurFinExpen.Reset();
                    if ConcurFinExpen.FindSet()then ConcurFinExpen.DeleteAll();
                    Message('Deleted');
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

                trigger OnAction()
                var
                    ConcurFinExpInb: Record "Concur inbound financial Expen";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                    SelectedFilter: Boolean;
                    Text001: Label 'Do you want to Cancel all Selected records in the Purchase Invoice Inbound List?';
                    ConfirmManagement: Codeunit "Confirm Management";
                begin
                    ConcurFinExpInb.Reset();
                    CurrPage.SetSelectionFilter(ConcurFinExpInb);
                    if ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text001), true)then begin
                        if ConcurFinExpInb.FindSet()then repeat if(ConcurFinExpInb."Expense Status" = ConcurFinExpInb."Expense Status"::Processed) or (ConcurFinExpInb."Expense Status" = ConcurFinExpInb."Expense Status"::"Finanace Company Processed") or (ConcurFinExpInb."Expense Status" = ConcurFinExpInb."Expense Status"::"Ship Shop Company Processed")then error('The Line is Processed/Partially Pricessed.');
                                //if PBPurchInvInb.Status <> PBPurchInvInb.Status::Cancel then begin
                                ConcurFinExpInb."Expense Status":=ConcurFinExpInb."Expense Status"::Cancel;
                                ConcurFinExpInb."Cancelled by User":=UserId;
                                ConcurFinExpInb."Cancelled Date time":=CreateDateTime(Today, Time);
                                ConcurFinExpInb."Posted Document No Fin Company":='CANCELLED';
                                ConcurFinExpInb."Posted Document No Shp Company":='CANCELLED';
                                ConcurFinExpInb.Modify()//end;
                            until ConcurFinExpInb.Next() = 0;
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

                trigger OnAction()
                var
                    ConcurFinExpInb: Record "Concur inbound financial Expen";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                    SelectedFilter: Boolean;
                    Text001: Label 'Do you want to reset all Selected records in the Purchase Invoice Inbound List?';
                    ConfirmManagement: Codeunit "Confirm Management";
                begin
                    ConcurFinExpInb.Reset();
                    CurrPage.SetSelectionFilter(ConcurFinExpInb);
                    if ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text001), true)then begin
                        if ConcurFinExpInb.FindSet()then repeat if(ConcurFinExpInb."Expense Status" = ConcurFinExpInb."Expense Status"::Processed) or (ConcurFinExpInb."Expense Status" = ConcurFinExpInb."Expense Status"::"Finanace Company Processed") or (ConcurFinExpInb."Expense Status" = ConcurFinExpInb."Expense Status"::"Ship Shop Company Processed") or (ConcurFinExpInb."Expense Status" = ConcurFinExpInb."Expense Status"::Error)then begin
                                    ConcurFinExpInb."Expense Status":=ConcurFinExpInb."Expense Status"::Pending;
                                    ConcurFinExpInb."Cancelled by User":='';
                                    ConcurFinExpInb."Cancelled Date time":=0DT;
                                    ConcurFinExpInb."Posted Document No Fin Company":='';
                                    ConcurFinExpInb."Posted Document No Shp Company":='';
                                    ConcurFinExpInb."Error Description":='';
                                    ConcurFinExpInb.Modify()end;
                            until ConcurFinExpInb.Next() = 0;
                    end;
                end;
            }
            action("Delete Cancel Records")
            {
                ApplicationArea = All;
                Image = Cancel;
                Caption = 'Delete all Cancel Records';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ConcurFinExpen: Record "Concur inbound financial Expen";
                begin
                    ConcurFinExpen.Reset();
                    ConcurFinExpen.SetRange("Expense Status", ConcurFinExpen."Expense Status"::Cancel);
                    if ConcurFinExpen.FindSet()then ConcurFinExpen.DeleteAll();
                    Message('Deleted');
                end;
            }
            //PS009 Start
            action("Get Identity and Attendee")
            {
                ApplicationArea = all;

                trigger OnAction()
                var
                    GetIdentity: Codeunit "Concur Get Identity";
                    GetAttendee: Codeunit "Concur Expense Attendee Resp.";
                    GetAttendeeInfo: Codeunit "Concur Get Attendee Info";
                    AttendeeID: text[500];
                begin
                    GetIdentity.GetIdentity(true, Rec);
                    attendeeid:=GetAttendee.GetExpenseAttendee(true, Rec);
                    if AttendeeID <> '' then GetAttendeeInfo.GetAttendeeInfo(true, AttendeeID);
                end;
            }
        //PS009 End
        }
    }
    trigger OnOpenPage()
    begin
    // Rec.SetAscending("Entry no.", false);
    end;
}
