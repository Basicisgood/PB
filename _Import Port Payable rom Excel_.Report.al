report 50126 "Import Port Payable rom Excel"
{
    Caption = 'Import Port Payable from Excel';
    ProcessingOnly = true;
    UseRequestPage = false;
    ApplicationArea = All;

    dataset
    {
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        ImportFromExcel();
    end;
    local procedure ImportFromExcel()
    var
        ExcelImportFunctions: Codeunit "Excel Custom Functions";
        ExcelBuffer: Record "Excel Buffer" temporary;
        StagingTable: Record "Port Payable Staging";
        InS: InStream;
        Filename: Text;
        Row: Integer;
        LastRow: Integer;
        AccountTypeText: Text;
        FAPostingTypeTxt: Text;
        EntryNo_: Integer;
        AmtLCY: Decimal;
    begin
        if UploadIntoStream('Upload Excel File', '', '', Filename, InS)then begin
            ExcelBuffer.OpenBookStream(InS, 'Sheet1');
            ExcelBuffer.ReadSheet();
            // ExcelBuffer.setrange("Column No.", 4);
            ExcelBuffer.FindLast();
            LastRow:=ExcelBuffer."Row No.";
            ExcelBuffer.Reset();
            StagingTable.Reset();
            IF StagingTable.FindLast()then EntryNo_:=StagingTable."Entry No." + 1
            else
                EntryNo_:=1;
            for row:=2 to LastRow do begin
                EntryNo_+=1;
                StagingTable.Init();
                StagingTable."Entry No.":=0;
                StagingTable."Journal Template Name":=ExcelImportFunctions.GetText(ExcelBuffer, 'A', row);
                StagingTable."Journal Batch Name":=ExcelImportFunctions.GetText(ExcelBuffer, 'B', row);
                StagingTable."BC Bank Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'C', row);
                StagingTable."IMOS Bank ID":=ExcelImportFunctions.GetText(ExcelBuffer, 'D', row);
                StagingTable."Line No":=ExcelImportFunctions.Gettext(ExcelBuffer, 'E', row);
                AccountTypeText:=ExcelImportFunctions.Gettext(ExcelBuffer, 'F', row);
                GetAccountType(StagingTable, AccountTypeText);
                StagingTable."Account No.":=ExcelImportFunctions.GetText(ExcelBuffer, 'G', row);
                StagingTable."Posting Date":=ExcelImportFunctions.GetDate(ExcelBuffer, 'H', row);
                StagingTable."Document Date":=StagingTable."Posting Date";
                AccountTypeText:='';
                AccountTypeText:=ExcelImportFunctions.GetText(ExcelBuffer, 'I', row);
                GetDocumentType(StagingTable, AccountTypeText);
                StagingTable.Description:=ExcelImportFunctions.GetText(ExcelBuffer, 'K', row);
                StagingTable."Currency Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'L', row);
                StagingTable.Amount:=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'M', row);
                StagingTable."Amount (Lcy)":=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'N', row);
                StagingTable."Currency Factor":=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'O', row);
                AccountTypeText:='';
                AccountTypeText:=ExcelImportFunctions.GetText(ExcelBuffer, 'P', row); //Map
                GetAppliesDocumentType(StagingTable, AccountTypeText);
                StagingTable."IMOS Transaction No":=ExcelImportFunctions.GetText(ExcelBuffer, 'Q', row);
                StagingTable."Applies-to Doc. No.":=ExcelImportFunctions.GetText(ExcelBuffer, 'R', row);
                StagingTable."External Document No.":=ExcelImportFunctions.GetText(ExcelBuffer, 'S', row);
                StagingTable."Company Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'T', row);
                StagingTable.FD1_Subsegment:=ExcelImportFunctions.GetText(ExcelBuffer, 'U', row);
                StagingTable.FD2_VesselName:=ExcelImportFunctions.GetText(ExcelBuffer, 'V', row);
                StagingTable.FD3_VoyageNumber:=ExcelImportFunctions.GetText(ExcelBuffer, 'W', row);
                StagingTable.FD4_CharterIn:=ExcelImportFunctions.GetText(ExcelBuffer, 'X', row);
                StagingTable.FD5_Department:=ExcelImportFunctions.GetText(ExcelBuffer, 'Y', row);
                StagingTable.FD6_Employee:=ExcelImportFunctions.GetText(ExcelBuffer, 'Z', row);
                StagingTable.FD7_Location:=ExcelImportFunctions.GetText(ExcelBuffer, 'AA', row);
                StagingTable.FD8_Company:=ExcelImportFunctions.GetText(ExcelBuffer, 'AB', row);
                StagingTable.FD9_CounterParty:=ExcelImportFunctions.GetText(ExcelBuffer, 'AC', row);
                StagingTable.FD10_JType:=ExcelImportFunctions.GetText(ExcelBuffer, 'AD', row);
                StagingTable."DNV Ship Manager ID":=ExcelImportFunctions.GetText(ExcelBuffer, 'AE', row);
                StagingTable."Import Date n Time":=CurrentDateTime;
                StagingTable."Imported By":=UserId; //Sgarg - Added
                StagingTable."File Name":=Filename;
                StagingTable.Insert();
            end;
        end;
    end;
    local procedure GetDocumentType(var StagingTable: Record "Port Payable Staging"; AccountTypeText: Text)
    begin
        case AccountTypeText of ' ': StagingTable."Document Type":=StagingTable."Document Type"::" ";
        'Payment': StagingTable."Document Type":=StagingTable."Document Type"::Payment;
        'Invoice': StagingTable."Document Type":=StagingTable."Document Type"::Invoice;
        'Credit Memo': StagingTable."Document Type":=StagingTable."Document Type"::"Credit Memo";
        'Finance Charge Memo': StagingTable."Document Type":=StagingTable."Document Type"::"Finance Charge Memo";
        'Reminder': StagingTable."Document Type":=StagingTable."Document Type"::Reminder;
        'Refund': StagingTable."Document Type":=StagingTable."Document Type"::Refund;
        end;
    end;
    local procedure GetAppliesDocumentType(var StagingTable: Record "Port Payable Staging"; AccountTypeText: Text)
    begin
        case AccountTypeText of ' ': StagingTable."Document Type":=StagingTable."Document Type"::" ";
        'Payment': StagingTable."Document Type":=StagingTable."Document Type"::Payment;
        'Invoice': StagingTable."Document Type":=StagingTable."Document Type"::Invoice;
        'Credit Memo': StagingTable."Document Type":=StagingTable."Document Type"::"Credit Memo";
        'Finance Charge Memo': StagingTable."Document Type":=StagingTable."Document Type"::"Finance Charge Memo";
        'Reminder': StagingTable."Document Type":=StagingTable."Document Type"::Reminder;
        'Refund': StagingTable."Document Type":=StagingTable."Document Type"::Refund;
        end;
    end;
    local procedure GetAccountType(var StagingTable: Record "Port Payable Staging"; AccountTypeText: Text)
    begin
        case AccountTypeText of 'G/L Account': StagingTable."Account Type":=StagingTable."Account Type"::"G/L Account";
        'Customer': StagingTable."Account Type":=StagingTable."Account Type"::Customer;
        'Vendor': StagingTable."Account Type":=StagingTable."Account Type"::Vendor;
        'Bank Account': StagingTable."Account Type":=StagingTable."Account Type"::"Bank Account";
        'Fixed Asset': StagingTable."Account Type":=StagingTable."Account Type"::"Fixed Asset";
        'IC Partner': StagingTable."Account Type":=StagingTable."Account Type"::"IC Partner";
        'Employee': StagingTable."Account Type":=StagingTable."Account Type"::Employee;
        'Allocation Account': StagingTable."Account Type":=StagingTable."Account Type"::"Allocation Account";
        end;
    end;
}
