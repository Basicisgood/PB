report 50107 "Import DaySource from Excel"
{
    Caption = 'Import Daysource from Excel';
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
        DaySourceTable: Record DAYSOURCE;
        InS: InStream;
        Filename: Text;
        Row: Integer;
        LastRow: Integer;
        AccountTypeText: Text;
        EntryNo_: Integer;
        l_rpt_RefreshData: Report DaySourcePatch;
        l_rec_Daysource: Record Daysource;
        FromNo: Integer;
        ToNo: Integer;
    begin
        if UploadIntoStream('Upload Excel File', '', '', Filename, InS)then begin
            ExcelBuffer.OpenBookStream(InS, 'DAYSOURCE');
            ExcelBuffer.ReadSheet();
            ExcelBuffer.FindLast();
            LastRow:=ExcelBuffer."Row No.";
            ExcelBuffer.Reset();
            DaySourceTable.Reset();
            IF DaySourceTable.FindLast()then EntryNo_:=DaySourceTable."Entry No." + 1
            else
                EntryNo_:=1;
            FromNo:=EntryNo_;
            for row:=2 to LastRow do begin
                EntryNo_+=1;
                DaySourceTable.Init();
                DaySourceTable."Entry No.":=EntryNo_;
                //DaySourceTable.T1 := ExcelImportFunctions.GetText(ExcelBuffer, 'A', row);
                DaySourceTable.VALIDATE(T1, ExcelImportFunctions.GetText(ExcelBuffer, 'A', row));
                DaySourceTable.T3:=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'B', row);
                DaySourceTable."Days Type":=ExcelImportFunctions.GetText(ExcelBuffer, 'C', row);
                DaySourceTable."Contract Type":=ExcelImportFunctions.GetText(ExcelBuffer, 'D', row);
                //DaySourceTable.Period := ExcelImportFunctions.GetText(ExcelBuffer, 'E', row);
                DaySourceTable.VALIDATE(Period, ExcelImportFunctions.GetText(ExcelBuffer, 'E', row));
                DaySourceTable.Days:=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'F', row);
                DaySourceTable."TCI Code":=ExcelImportFunctions.GetText(ExcelBuffer, 'G', row);
                DaySourceTable."Vessel Type":=ExcelImportFunctions.GetText(ExcelBuffer, 'H', row);
                DaySourceTable.Vessel:=ExcelImportFunctions.GetText(ExcelBuffer, 'I', row);
                DaySourceTable.VoyNo:=ExcelImportFunctions.GetText(ExcelBuffer, 'J', Row);
                DaySourceTable.T2:=ExcelImportFunctions.GetText(ExcelBuffer, 'K', row);
                DaySourceTable.vslType:=ExcelImportFunctions.GetText(ExcelBuffer, 'L', row);
                DaySourceTable."Head Company":=ExcelImportFunctions.GetText(ExcelBuffer, 'M', row);
                DaySourceTable."Pool Points":=ExcelImportFunctions.GetDecimal(ExcelBuffer, 'N', row);
                DaySourceTable.Insert(TRUE);
            end;
            ToNo:=EntryNo_;
            l_rec_Daysource.RESET;
            l_rec_Daysource.SETRANGE("Entry No.", FromNo, ToNo);
            IF l_rec_Daysource.FINDSET THEN;
            CLEAR(l_rpt_RefreshData);
            l_rpt_RefreshData.SetTableView(l_rec_Daysource);
            l_rpt_RefreshData.UseRequestPage:=false;
            l_rpt_RefreshData.RUn;
        end;
    end;
}
