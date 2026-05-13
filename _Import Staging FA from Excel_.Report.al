report 50103 "Import Staging FA from Excel"
{
    Caption = 'Import Staging FA Journal from Excel';
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
            for row:=4 to LastRow do begin
                EntryNo_+=1;
                StagingTable.Init();
                StagingTable."Entry No.":=EntryNo_;
                StagingTable."Company Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'A', row);
                StagingTable."Journal Template":=ExcelImportFunctions.GetText(ExcelBuffer, 'B', row);
                StagingTable."Journal Batch":=ExcelImportFunctions.GetText(ExcelBuffer, 'C', row);
                StagingTable."Batch Description":=ExcelImportFunctions.GetText(ExcelBuffer, 'C', row);
                StagingTable."Document No.":=ExcelImportFunctions.GetText(ExcelBuffer, 'E', row);
                StagingTable."Posting Date":=ExcelImportFunctions.GetDate(ExcelBuffer, 'F', row);
                StagingTable."FA Posting Date":=ExcelImportFunctions.GetDate(ExcelBuffer, 'G', row);
                AccountTypeText:=ExcelImportFunctions.GetText(ExcelBuffer, 'H', row);
                GetAccountType(StagingTable, AccountTypeText);
                StagingTable."Account No.":=ExcelImportFunctions.GetText(ExcelBuffer, 'I', row);
                // StagingTable."Depreciation Book Code" := ExcelImportFunctions.GetText(ExcelBuffer, 'H', row);
                FAPostingTypeTxt:=ExcelImportFunctions.GetText(ExcelBuffer, 'J', row);
                GetFAType(StagingTable, FAPostingTypeTxt);
                //StagingTable."Depreciation Book Code" := ExcelImportFunctions.GetText(ExcelBuffer, 'J', row);
                StagingTable."External Doc No.":=ExcelImportFunctions.GetText(ExcelBuffer, 'K', row);
                StagingTable.Description:=ExcelImportFunctions.GetText(ExcelBuffer, 'L', row);
                StagingTable."Currency Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'M', row);
                StagingTable.Amount:=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'N', row);
                StagingTable."Amount LCY":=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'O', row);
                StagingTable."Salvage Value":=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'P', row);
                AccountTypeText:='';
                AccountTypeText:=ExcelImportFunctions.GetText(ExcelBuffer, 'Q', row);
                GetBalAccountType(StagingTable, AccountTypeText);
                StagingTable."Bal. Acc. No.":=ExcelImportFunctions.GetText(ExcelBuffer, 'R', Row);
                StagingTable."Global Dimension 1":=ExcelImportFunctions.GetText(ExcelBuffer, 'S', row);
                StagingTable."Global Dimension 2":=ExcelImportFunctions.GetText(ExcelBuffer, 'T', row);
                StagingTable."Shortcut Dimension 3":=ExcelImportFunctions.GetText(ExcelBuffer, 'U', row);
                StagingTable."Shortcut Dimension 4":=ExcelImportFunctions.GetText(ExcelBuffer, 'V', row);
                StagingTable."Shortcut Dimension 5":=ExcelImportFunctions.GetText(ExcelBuffer, 'W', row);
                StagingTable."Shortcut Dimension 6":=ExcelImportFunctions.GetText(ExcelBuffer, 'X', row);
                StagingTable."Shortcut Dimension 7":=ExcelImportFunctions.GetText(ExcelBuffer, 'Y', row);
                StagingTable."Shortcut Dimension 8":=ExcelImportFunctions.GetText(ExcelBuffer, 'Z', row);
                StagingTable."Shortcut Dimension 9":=ExcelImportFunctions.GetText(ExcelBuffer, 'AA', row);
                StagingTable."Shortcut Dimension 10":=ExcelImportFunctions.GetText(ExcelBuffer, 'AB', row);
                StagingTable."Shortcut Dimension 11":=ExcelImportFunctions.GetText(ExcelBuffer, 'AC', row);
                StagingTable."Shortcut Dimension 12":=ExcelImportFunctions.GetText(ExcelBuffer, 'AD', row);
                StagingTable."Import Type":=StagingTable."Import Type"::FixedAsset;
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
    local procedure GetFAType(var StagingTable: Record "Import Staging"; FATypeText: Text)
    begin
        case FATypeText of 'Acquisition Cost': StagingTable."FA Posting Type":=StagingTable."FA Posting Type"::"Acquisition Cost";
        'Depreciation': StagingTable."FA Posting Type":=StagingTable."FA Posting Type"::Depreciation;
        'Write-Down': StagingTable."FA Posting Type":=StagingTable."FA Posting Type"::"Write-Down";
        'Appreciation': StagingTable."FA Posting Type":=StagingTable."FA Posting Type"::Appreciation;
        'Custom 1': StagingTable."FA Posting Type":=StagingTable."FA Posting Type"::"Custom 1";
        'Custom 2': StagingTable."FA Posting Type":=StagingTable."FA Posting Type"::"Custom 2";
        'Disposal': StagingTable."FA Posting Type":=StagingTable."FA Posting Type"::Disposal;
        'Maintenance': StagingTable."FA Posting Type":=StagingTable."FA Posting Type"::Maintenance;
        end;
    end;
}
