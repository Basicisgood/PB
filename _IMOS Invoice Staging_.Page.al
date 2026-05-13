page 50229 "IMOS Invoice Staging"
{
    ApplicationArea = All;
    Caption = 'IMOS Invoice Staging';
    PageType = List;
    SourceTable = "IMOS Invoice Staging Table";
    UsageCategory = Lists;
    CardPageId = 50166;
    //Editable = false;
    InsertAllowed = false;
    //ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(transNo; Rec.transNo)
                {
                    ApplicationArea = All;
                }
                field(transType; Rec.transType)
                {
                    ApplicationArea = All;
                }
                field("BC Company Code"; Rec."BC Company Code")
                {
                    ApplicationArea = All;
                }
                field("IC Transaction"; Rec."IC Transaction")
                {
                    ApplicationArea = All;
                }
                field("Posted Document No"; Rec."Posted Document No")
                {
                    ApplicationArea = All;
                }
                field("BC Status"; Rec."BC Status")
                {
                    ApplicationArea = All;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = All;
                }
                field("Reversed in BC"; Rec."Reversed in BC")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Cancelled By"; Rec."Cancelled By")
                {
                    ApplicationArea = All;
                }
                field("Cancelled Datetime"; Rec."Cancelled Datetime")
                {
                    ApplicationArea = All;
                }
                field("No of Lines in BC"; Rec."No of Lines in BC")
                {
                    ApplicationArea = all;
                }
                field("No of Lines in IMOS"; Rec."No of Lines in IMOS")
                {
                    ApplicationArea = all;
                }
                field("Amount Posted in BC"; Rec."Amount Posted in BC")
                {
                    ApplicationArea = all;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(_action; Rec._action)
                {
                    ToolTip = 'Specifies the value of the Action field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(actDate; Rec.actDate)
                {
                    ToolTip = 'Specifies the value of the actDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(aparCode; Rec.aparCode)
                {
                    ToolTip = 'Specifies the value of the aparCode field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(approval; Rec.approval)
                {
                    ToolTip = 'Specifies the value of the approval field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(approvalComments; Rec.approvalComments)
                {
                    ToolTip = 'Specifies the value of the approvalComments field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(approvalComments2; Rec.approvalComments2)
                {
                    ToolTip = 'Specifies the value of the approvalComments2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(approvalComments3; Rec.approvalComments3)
                {
                    ToolTip = 'Specifies the value of the approvalComments3 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(approvalDate; Rec.approvalDate)
                {
                    ToolTip = 'Specifies the value of the approvalDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(approvalDate2; Rec.approvalDate2)
                {
                    ToolTip = 'Specifies the value of the approvalDate2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(approvalDate3; Rec.approvalDate3)
                {
                    ToolTip = 'Specifies the value of the approvalDate3 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(baseCurrencyAmount; Rec.baseCurrencyAmount)
                {
                    ToolTip = 'Specifies the value of the baseCurrencyAmount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(billExternalRef; Rec.billExternalRef)
                {
                    ToolTip = 'Specifies the value of the billExternalRef field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(billRemarks; Rec.billRemarks)
                {
                    ToolTip = 'Specifies the value of the billRemarks field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(companyBU; Rec.companyBU)
                {
                    ToolTip = 'Specifies the value of the companyBU field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(counterpartyBU; Rec.counterpartyBU)
                {
                    ToolTip = 'Specifies the value of the counterpartyBU field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(cpDate; Rec.cpDate)
                {
                    ToolTip = 'Specifies the value of the cpDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(currency; Rec.currency)
                {
                    ToolTip = 'Specifies the value of the currency field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(currencyAmount; Rec.currencyAmount)
                {
                    ToolTip = 'Specifies the value of the currencyAmount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(docNo; Rec.docNo)
                {
                    ToolTip = 'Specifies the value of the docNo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(dueDate; Rec.dueDate)
                {
                    ToolTip = 'Specifies the value of the dueDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(entryDate; Rec.entryDate)
                {
                    ToolTip = 'Specifies the value of the entryDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(exchangeRate; Rec.exchangeRate)
                {
                    ToolTip = 'Specifies the value of the exchangeRate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(exchangeRateDate; Rec.exchangeRateDate)
                {
                    ToolTip = 'Specifies the value of the exchangeRateDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(externalRefId; Rec.externalRefId)
                {
                    ToolTip = 'Specifies the value of the externalRefId field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(invoiceDate; Rec.invoiceDate)
                {
                    ToolTip = 'Specifies the value of the invoiceDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(invoiceNo; Rec.invoiceNo)
                {
                    ToolTip = 'Specifies the value of the invoiceNo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(lastModifiedDate; Rec.lastModifiedDate)
                {
                    ToolTip = 'Specifies the value of the lastModifiedDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(lastUserId; Rec.lastUserId)
                {
                    ToolTip = 'Specifies the value of the lastUserId field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(memo; Rec.memo)
                {
                    ToolTip = 'Specifies the value of the memo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(oprBillSource; Rec.oprBillSource)
                {
                    ToolTip = 'Specifies the value of the oprBillSource field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(oprTransNo; Rec.oprTransNo)
                {
                    ToolTip = 'Specifies the value of the oprTransNo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(paymentAccountNo; Rec.paymentAccountNo)
                {
                    ToolTip = 'Specifies the value of the paymentAccountNo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(paymentBank; Rec.paymentBank)
                {
                    ToolTip = 'Specifies the value of the paymentBank field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(paymentBankCode; Rec.paymentBankCode)
                {
                    ToolTip = 'Specifies the value of the paymentBankCode field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(paymentTermsCode; Rec.paymentTermsCode)
                {
                    ToolTip = 'Specifies the value of the paymentTermsCode field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(purchaseOrderNo; Rec.purchaseOrderNo)
                {
                    ToolTip = 'Specifies the value of the purchaseOrderNo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(receivedDate; Rec.receivedDate)
                {
                    ToolTip = 'Specifies the value of the receivedDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(remarks; Rec.remarks)
                {
                    ToolTip = 'Specifies the value of the remarks field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(remittanceAccountNo; Rec.remittanceAccountNo)
                {
                    ToolTip = 'Specifies the value of the remittanceAccountNo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(remittanceBankName; Rec.remittanceBankName)
                {
                    ToolTip = 'Specifies the value of the remittanceBankName field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(remittanceCompNo; Rec.remittanceCompNo)
                {
                    ToolTip = 'Specifies the value of the remittanceCompNo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(remittanceExternalRef; Rec.remittanceExternalRef)
                {
                    ToolTip = 'Specifies the value of the remittanceExternalRef field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(remittanceFullName; Rec.remittanceFullName)
                {
                    ToolTip = 'Specifies the value of the remittanceFullName field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(remittanceIban; Rec.remittanceIban)
                {
                    ToolTip = 'Specifies the value of the remittanceIban field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(remittanceSeq; Rec.remittanceSeq)
                {
                    ToolTip = 'Specifies the value of the remittanceSeq field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(remittanceSwiftCode; Rec.remittanceSwiftCode)
                {
                    ToolTip = 'Specifies the value of the remittanceSwiftCode field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(revInvoiceNo; Rec.revInvoiceNo)
                {
                    ToolTip = 'Specifies the value of the revInvoiceNo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(vatCurr; Rec.vatCurr)
                {
                    ToolTip = 'Specifies the value of the vatCurr field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(tcCode; Rec.tcCode)
                {
                    ApplicationArea = all;
                }
                field(vatExchangeRate; Rec.vatExchangeRate)
                {
                    ToolTip = 'Specifies the value of the vatExchangeRate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(vatExchangeRateDate; Rec.vatExchangeRateDate)
                {
                    ToolTip = 'Specifies the value of the vatExchangeRateDate field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(vendorCareOf; Rec.vendorCareOf)
                {
                    ToolTip = 'Specifies the value of the vendorCareOf field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(vendorCareOfCountryCode; Rec.vendorCareOfCountryCode)
                {
                    ToolTip = 'Specifies the value of the vendorCareOfCountryCode field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(vendorCareOfRef; Rec.vendorCareOfRef)
                {
                    ToolTip = 'Specifies the value of the vendorCareOfRef field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(vendorCountryCode; Rec.vendorCountryCode)
                {
                    ToolTip = 'Specifies the value of the vendorCountryCode field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(vendorCrossRef; Rec.vendorCrossRef)
                {
                    ToolTip = 'Specifies the value of the vendorCrossRef field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(vendorExternalRef; Rec.vendorExternalRef)
                {
                    ToolTip = 'Specifies the value of the vendorExternalRef field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(vendorName; Rec.vendorName)
                {
                    ToolTip = 'Specifies the value of the vendorName field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(vendorNo; Rec.vendorNo)
                {
                    ToolTip = 'Specifies the value of the vendorNo field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(vendorReferenceCode; Rec.vendorReferenceCode)
                {
                    ToolTip = 'Specifies the value of the vendorReferenceCode field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(vendorShortName; Rec.vendorShortName)
                {
                    ToolTip = 'Specifies the value of the vendorShortName field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(vendorType; Rec.vendorType)
                {
                    ToolTip = 'Specifies the value of the vendorType field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ProcessLine)
            {
                ApplicationArea = All;
                Caption = 'Process Line';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    IMOSInoiceStaging: Record "IMOS Invoice Staging Table";
                    IMOSInvpoiceStagingLine: record "IMOS Invoice Line";
                    CU_IMOSPost: Codeunit 50174;
                begin
                    if rec."BC Company Code" = CompanyName then begin
                        if(rec."BC Status" = rec."BC Status"::Error) or (rec."BC Status" = rec."BC Status"::Pending)then CU_IMOSPost.Run(Rec);
                    end;
                end;
            }
        }
    }
}
