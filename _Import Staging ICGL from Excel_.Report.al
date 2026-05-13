report 50104 "Import Staging ICGL from Excel"
{
    Caption = 'Import Staging IC Gen Jnl from Excel';
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
        StagingTable: Record "Import Staging";
        InS: InStream;
        Filename: Text;
        Row: Integer;
        LastRow: Integer;
        AccountTypeText: Text;
        BalAccTypeText: Text;
        ICAccountTypeText: Text;
        EntryNo_: Integer;
        DocTypeText: Text;
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
            for row:=4 to LastRow do begin
                EntryNo_+=1;
                StagingTable.Init();
                StagingTable."Entry No.":=EntryNo_;
                StagingTable."Company Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'A', row);
                StagingTable."Journal Template":=ExcelImportFunctions.GetText(ExcelBuffer, 'B', row);
                StagingTable."Journal Batch":=ExcelImportFunctions.GetText(ExcelBuffer, 'C', row);
                StagingTable."Batch Description":=ExcelImportFunctions.GetText(ExcelBuffer, 'D', row);
                StagingTable."Document No.":=ExcelImportFunctions.GetText(ExcelBuffer, 'E', row);
                DocTypeText:='';
                DocTypeText:=ExcelImportFunctions.GetText(ExcelBuffer, 'F', row);
                GetDocumentType(StagingTable, DocTypeText);
                StagingTable."Posting Date":=ExcelImportFunctions.GetDate(ExcelBuffer, 'G', row);
                StagingTable."Document Date":=ExcelImportFunctions.GetDate(ExcelBuffer, 'H', row);
                StagingTable."External Doc No.":=ExcelImportFunctions.GetText(ExcelBuffer, 'I', row);
                AccountTypeText:='';
                AccountTypeText:=ExcelImportFunctions.GetText(ExcelBuffer, 'J', row);
                GetAccountType(StagingTable, AccountTypeText);
                StagingTable."Account No.":=ExcelImportFunctions.GetText(ExcelBuffer, 'K', row);
                StagingTable.Description:=ExcelImportFunctions.GetText(ExcelBuffer, 'L', row);
                StagingTable."Currency Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'M', row);
                StagingTable.Amount:=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'N', row);
                StagingTable."Amount LCY":=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'O', row);
                // BalAccTypeText := '';
                // BalAccTypeText := ExcelImportFunctions.GetText(ExcelBuffer, 'P', row);
                // GetBalAccountType(StagingTable, BalAccTypeText);
                // StagingTable."Bal. Acc. No." := ExcelImportFunctions.GetText(ExcelBuffer, 'Q', Row);
                ICAccountTypeText:='';
                ICAccountTypeText:=ExcelImportFunctions.GetText(ExcelBuffer, 'P', row);
                GetICAccountType(StagingTable, ICAccountTypeText);
                // if (StagingTable."Account Type" = StagingTable."Account Type"::"G/L Account") and (StagingTable."Account No." <> '') then
                //     StagingTable."IC Account No." := StagingTable."Account No.";
                StagingTable."PB IC Account No.":=ExcelImportFunctions.GetText(ExcelBuffer, 'Q', Row);
                StagingTable."IC Global Dimension 1":=ExcelImportFunctions.GetText(ExcelBuffer, 'R', row);
                StagingTable."IC Global Dimension 2":=ExcelImportFunctions.GetText(ExcelBuffer, 'S', row);
                StagingTable."IC Shortcut Dimension 3":=ExcelImportFunctions.GetText(ExcelBuffer, 'T', row);
                StagingTable."IC Shortcut Dimension 4":=ExcelImportFunctions.GetText(ExcelBuffer, 'U', row);
                StagingTable."IC Shortcut Dimension 5":=ExcelImportFunctions.GetText(ExcelBuffer, 'V', row);
                StagingTable."IC Shortcut Dimension 6":=ExcelImportFunctions.GetText(ExcelBuffer, 'W', row);
                StagingTable."IC Shortcut Dimension 7":=ExcelImportFunctions.GetText(ExcelBuffer, 'X', row);
                StagingTable."IC Shortcut Dimension 8":=ExcelImportFunctions.GetText(ExcelBuffer, 'Y', row);
                StagingTable."IC Shortcut Dimension 9":=ExcelImportFunctions.GetText(ExcelBuffer, 'Z', row);
                StagingTable."IC Shortcut Dimension 10":=ExcelImportFunctions.GetText(ExcelBuffer, 'AA', row);
                StagingTable."IC Shortcut Dimension 11":=ExcelImportFunctions.GetText(ExcelBuffer, 'AB', row);
                StagingTable."IC Shortcut Dimension 12":=ExcelImportFunctions.GetText(ExcelBuffer, 'AC', row);
                StagingTable."Global Dimension 1":=ExcelImportFunctions.GetText(ExcelBuffer, 'AD', row);
                StagingTable."Global Dimension 2":=ExcelImportFunctions.GetText(ExcelBuffer, 'AE', row);
                StagingTable."Shortcut Dimension 3":=ExcelImportFunctions.GetText(ExcelBuffer, 'AF', row);
                StagingTable."Shortcut Dimension 4":=ExcelImportFunctions.GetText(ExcelBuffer, 'AG', row);
                StagingTable."Shortcut Dimension 5":=ExcelImportFunctions.GetText(ExcelBuffer, 'AH', row);
                StagingTable."Shortcut Dimension 6":=ExcelImportFunctions.GetText(ExcelBuffer, 'AI', row);
                StagingTable."Shortcut Dimension 7":=ExcelImportFunctions.GetText(ExcelBuffer, 'AJ', row);
                StagingTable."Shortcut Dimension 8":=ExcelImportFunctions.GetText(ExcelBuffer, 'AK', row);
                StagingTable."Shortcut Dimension 9":=ExcelImportFunctions.GetText(ExcelBuffer, 'AL', row);
                StagingTable."Shortcut Dimension 10":=ExcelImportFunctions.GetText(ExcelBuffer, 'AM', row);
                StagingTable."Shortcut Dimension 11":=ExcelImportFunctions.GetText(ExcelBuffer, 'AN', row);
                StagingTable."Shortcut Dimension 12":=ExcelImportFunctions.GetText(ExcelBuffer, 'AO', row);
                StagingTable."Import Type":=StagingTable."Import Type"::ICJournal;
                StagingTable."Import TimeStamp":=CurrentDateTime;
                StagingTable."Created By":=UserId; //Sgarg - Added
                StagingTable.Insert();
            end;
        end;
    end;
    local procedure GetAccountType(var StagingTable: Record "Import Staging"; AccountTypeText: Text)
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
    local procedure GetBalAccountType(var StagingTable: Record "Import Staging"; AccountTypeText: Text)
    begin
        case AccountTypeText of 'G/L Account': StagingTable."Bal. Acc. Type":=StagingTable."Bal. Acc. Type"::"G/L Account";
        'Customer': StagingTable."Bal. Acc. Type":=StagingTable."Bal. Acc. Type"::Customer;
        'Vendor': StagingTable."Bal. Acc. Type":=StagingTable."Bal. Acc. Type"::Vendor;
        'Bank Account': StagingTable."Bal. Acc. Type":=StagingTable."Bal. Acc. Type"::"Bank Account";
        'Fixed Asset': StagingTable."Bal. Acc. Type":=StagingTable."Bal. Acc. Type"::"Fixed Asset";
        'IC Partner': StagingTable."Bal. Acc. Type":=StagingTable."Bal. Acc. Type"::"IC Partner";
        'Employee': StagingTable."Bal. Acc. Type":=StagingTable."Bal. Acc. Type"::Employee;
        'Allocation Account': StagingTable."Bal. Acc. Type":=StagingTable."Bal. Acc. Type"::"Allocation Account";
        end;
    end;
    local procedure GetICAccountType(var StagingTable: Record "Import Staging"; AccountTypeText: Text)
    begin
        case AccountTypeText of 'G/L Account': StagingTable."PB IC Account Type":=StagingTable."PB IC Account Type"::"G/L Account";
        'Bank Account': StagingTable."PB IC Account Type":=StagingTable."PB IC Account Type"::"Bank Account";
        //StagingTable.P
        end;
    end;
    local procedure GetDocumentType(var StagingTable: Record "Import Staging"; DocTypeText: Text)
    begin
        // ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund
        case DocTypeText of '': StagingTable."Document Type":=StagingTable."Document Type"::" ";
        'Payment': StagingTable."Document Type":=StagingTable."Document Type"::Payment;
        'Invoice': StagingTable."Document Type":=StagingTable."Document Type"::Invoice;
        'Credit Memo': StagingTable."Document Type":=StagingTable."Document Type"::"Credit Memo";
        'Finance Charge Memo': StagingTable."Document Type":=StagingTable."Document Type"::"Finance Charge Memo";
        'Reminder': StagingTable."Document Type":=StagingTable."Document Type"::Reminder;
        'Refund': StagingTable."Document Type":=StagingTable."Document Type"::Refund;
        end;
    end;
}
