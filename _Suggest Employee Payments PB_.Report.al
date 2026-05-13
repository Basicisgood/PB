report 50160 "Suggest Employee Payments PB"
{
    Caption = 'Suggest Employee Payments PB';
    ProcessingOnly = true;
    Permissions = tabledata "Employee Ledger Entry"=rm;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = sorting("No.")where("Privacy Blocked"=const(false)); //, "Balance" = filter(> 0));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                Clear(EmployeeBalance);
                //CalcFields(Balance);
                //EmployeeBalance := Balance;
                if StopPayments then CurrReport.Break();
                Window.Update(1, "No.");
                if 1 > 0 then begin
                    //if EmployeeBalance > 0 then begin
                    GetEmplLedgEntries(true);
                    GetEmplLedgEntries(false);
                    CheckAmounts();
                    ClearNegative();
                end;
            end;
            trigger OnPostDataItem()
            begin
                if FindSet()then repeat ClearNegative();
                    until Next() = 0;
                DimSetEntry.LockTable();
                GenJnlLine.LockTable();
                GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
                GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                GenJnlLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                GenJnlLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                if GenJnlLine.FindLast()then begin
                    LastLineNo:=GenJnlLine."Line No.";
                    GenJnlLine.Init();
                end;
                Window2.Open(InsertingJournalLinesMsg);
                TempPayableEmployeeLedgerEntry.Reset();
                MakeGenJnlLines();
                TempPayableEmployeeLedgerEntry.Reset();
                TempPayableEmployeeLedgerEntry.DeleteAll();
                Window2.Close();
                Window.Close();
                ShowMessage(MessageText);
            end;
            trigger OnPreDataItem()
            begin
                if PostingDateReq = 0D then Error(PostingDateRequiredErr);
                BankPmtType:=GenJnlLine2."Bank Payment Type";
                BalAccType:=GenJnlLine2."Bal. Account Type";
                BalAccNo:=GenJnlLine2."Bal. Account No.";
                GenJnlLineInserted:=false;
                MessageText:='';
                if((BankPmtType = GenJnlLine2."Bank Payment Type"::" ") or SummarizePerEmpl) and (NextDocNo = '')then Error(StartingDocNoErr);
                if((BankPmtType = GenJnlLine2."Bank Payment Type"::"Manual Check") and not SummarizePerEmpl and not DocNoPerLine)then Error(ManualCheckErr);
                Empl2.CopyFilters(Employee);
                OriginalAmtAvailable:=AmountAvailable;
                Window.Open(ProcessingEmployeesMsg);
                SelectedDim.SetRange("User ID", UserId);
                SelectedDim.SetRange("Object Type", 3);
                SelectedDim.SetRange("Object ID", REPORT::"Suggest Employee Payments");
                SummarizePerDim:=SelectedDim.Find('-') and SummarizePerEmpl;
                NextEntryNo:=1;
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    group("Find Payments")
                    {
                        Caption = 'Find Payments';

                        field("Available Amount (LCY)"; AmountAvailable)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Available Amount (LCY)';
                            Importance = Additional;
                            ToolTip = 'Specifies a maximum amount (in LCY) that is available for payments.';
                        }
                        field(SkipExportedPayments; SkipExportPayments)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Skip Exported Payments';
                            Importance = Additional;
                            ToolTip = 'Specifies if you do not want the batch job to insert payment journal lines for documents for which payments have already been exported to a bank file.';
                        }
                    }
                    group("Summarize Results")
                    {
                        Caption = 'Summarize Results';

                        field(SummarizePerEmployee; SummarizePerEmpl)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Summarize per Employee';
                            ToolTip = 'Specifies if you want the batch job to make one line per employee';
                            Editable = false;
                        }
                        field(SummarizePerDimText; SummarizePerDimTextReq)
                        {
                            ApplicationArea = Dimensions;
                            Caption = 'By Dimension';
                            Editable = false;
                            Enabled = SummarizePerDimTextEnable;
                            Importance = Additional;
                            ToolTip = 'Specifies the dimensions that you want the batch job to consider.';

                            trigger OnAssistEdit()
                            var
                                DimSelectionBuf: Record "Dimension Selection Buffer";
                            begin
                                DimSelectionBuf.SetDimSelectionMultiple(3, REPORT::"Suggest Employee Payments", SummarizePerDimTextReq);
                            end;
                        }
                    }
                    group("Fill in Journal Lines")
                    {
                        Caption = 'Fill in Journal Lines';

                        field(PostingDate; PostingDateReq)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posting Date';
                            Importance = Promoted;
                            ToolTip = 'Specifies the date for the posting of this batch job. By default, the working date is entered, but you can change it.';

                            trigger OnValidate()
                            begin
                                ValidatePostingDate();
                            end;
                        }
                        field(StartingDocumentNo; NextDocNo)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Starting Document No.';
                            ToolTip = 'Specifies the next available number in the number series for the journal batch that is linked to the payment journal. When you run the batch job, this is the document number that appears on the first payment journal line. You can also fill in this field manually.';

                            trigger OnValidate()
                            begin
                                if NextDocNo <> '' then if IncStr(NextDocNo) = '' then Error(StartingDocumentNoErr);
                            end;
                        }
                        field(NewDocNoPerLine; DocNoPerLine)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'New Doc. No. per Line';
                            Importance = Additional;
                            ToolTip = 'Specifies if you want the batch job to fill in the payment journal lines with consecutive document numbers, starting with the document number specified in the Starting Document No. field.';
                        }
                        field(BalAccountType; GenJnlLine2."Bal. Account Type")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bal. Account Type';
                            Importance = Additional;
                            ToolTip = 'Specifies the balancing account type that payments on the payment journal are posted to.';

                            trigger OnValidate()
                            begin
                                if not(GenJnlLine2."Bal. Account Type" in[GenJnlLine2."Bal. Account Type"::"Bank Account", GenJnlLine2."Bal. Account Type"::"G/L Account"])then error(BalAccountTypeErr, GenJnlLine2."Bal. Account Type"::"Bank Account", GenJnlLine2."Bal. Account Type"::"G/L Account");
                                GenJnlLine2."Bal. Account No.":='';
                            end;
                        }
                        field(BalAccountNo; GenJnlLine2."Bal. Account No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bal. Account No.';
                            Importance = Additional;
                            ToolTip = 'Specifies the balancing account number that payments on the payment journal are posted to.';

                            trigger OnLookup(var Text: Text): Boolean begin
                                case GenJnlLine2."Bal. Account Type" of GenJnlLine2."Bal. Account Type"::"G/L Account": if PAGE.RunModal(0, GLAcc) = ACTION::LookupOK then GenJnlLine2."Bal. Account No.":=GLAcc."No.";
                                GenJnlLine2."Bal. Account Type"::Customer, GenJnlLine2."Bal. Account Type"::Vendor, GenJnlLine2."Bal. Account Type"::Employee: Error(AccountTypeErr, GenJnlLine2.FieldCaption("Bal. Account Type"));
                                GenJnlLine2."Bal. Account Type"::"Bank Account": if PAGE.RunModal(0, BankAcc) = ACTION::LookupOK then GenJnlLine2."Bal. Account No.":=BankAcc."No.";
                                end;
                            end;
                            trigger OnValidate()
                            begin
                                if GenJnlLine2."Bal. Account No." <> '' then case GenJnlLine2."Bal. Account Type" of GenJnlLine2."Bal. Account Type"::"G/L Account": GLAcc.Get(GenJnlLine2."Bal. Account No.");
                                    GenJnlLine2."Bal. Account Type"::Customer, GenJnlLine2."Bal. Account Type"::Vendor, GenJnlLine2."Bal. Account Type"::Employee: Error(AccountTypeErr, GenJnlLine2.FieldCaption("Bal. Account Type"));
                                    GenJnlLine2."Bal. Account Type"::"Bank Account": BankAcc.Get(GenJnlLine2."Bal. Account No.");
                                    end;
                            end;
                        }
                        field(BankPaymentType; GenJnlLine2."Bank Payment Type")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = ' Type';
                            Importance = Additional;
                            ToolTip = 'Specifies the check type to be used, if you use Bank Account as the balancing account type.';

                            trigger OnValidate()
                            begin
                                if(GenJnlLine2."Bal. Account Type" <> GenJnlLine2."Bal. Account Type"::"Bank Account") and (GenJnlLine2."Bank Payment Type" <> GenJnlLine2."Bank Payment Type"::" ")then Error(BankPaymentTypeErr);
                            end;
                        }
                    }
                    group(DimensionsFilter)
                    {
                        // ShowCaption = false;
                        Caption = 'Dimension Filter';

                        field(ShortcutDim3Filter; ShortcutDim3)
                        {
                            ApplicationArea = all;
                            CaptionClass = '1,2,3';
                            Caption = 'Shortcut Dimension 3 Filter';
                            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(3));
                        }
                        field(ShortcutDim4Filter; ShortcutDim4)
                        {
                            ApplicationArea = all;
                            CaptionClass = '1,2,4';
                            Caption = 'Shortcut Dimension 4 Filter';
                            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(4));
                        }
                        field(ShortcutDim5Filter; ShortcutDim5)
                        {
                            ApplicationArea = all;
                            CaptionClass = '1,2,5';
                            Caption = 'Shortcut Dimension 5 Filter';
                            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(5));
                        }
                        field(ShortcutDim6Filter; ShortcutDim6)
                        {
                            ApplicationArea = all;
                            CaptionClass = '1,2,6';
                            Caption = 'Shortcut Dimension 6 Filter';
                            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(6));
                        }
                        field(ShortcutDim7Filter; ShortcutDim7)
                        {
                            ApplicationArea = all;
                            CaptionClass = '1,2,7';
                            Caption = 'Shortcut Dimension 7 Filter';
                            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(7));
                        }
                        field(ShortcutDim8Filter; ShortcutDim8)
                        {
                            ApplicationArea = all;
                            CaptionClass = '1,2,8';
                            Caption = 'Shortcut Dimension 8 Filter';
                            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(8));
                        }
                        field(ShortcutDim9Filter; ShortcutDim9)
                        {
                            ApplicationArea = all;
                            CaptionClass = '1,2,9';
                            Caption = 'Shortcut Dimension 9 Filter';
                            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(9));
                        }
                        field(ShortcutDim10Filter; ShortcutDim10)
                        {
                            ApplicationArea = all;
                            CaptionClass = '1,2,10';
                            Caption = 'Shortcut Dimension 10 Filter';
                            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(10));
                        }
                        field(ShortcutDim11Filter; ShortcutDim11)
                        {
                            ApplicationArea = all;
                            CaptionClass = '1,2,11';
                            Caption = 'Shortcut Dimension 11 Filter';
                            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(11));
                        }
                        field(ShortcutDim12Filter; ShortcutDim12)
                        {
                            ApplicationArea = all;
                            CaptionClass = '1,2,12';
                            Caption = 'Shortcut Dimension 12 Filter';
                            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(12));
                        }
                        field(ShortcutDim13Filter; ShortcutDim13)
                        {
                            ApplicationArea = all;
                            CaptionClass = '1,2,13';
                            Caption = 'Shortcut Dimension 13 Filter';
                            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(13));
                        }
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnInit()
        begin
            SummarizePerDimTextEnable:=true;
            SkipExportPayments:=true;
            SummarizePerEmpl:=true; //Sgarg- Added
        end;
        trigger OnOpenPage()
        begin
            PostingDateReq:=WorkDate();
            ValidatePostingDate();
            SetDefaults();
        end;
    }
    labels
    {
    }
    trigger OnPostReport()
    begin
        Commit();
        if not TempEmployeeLedgerEntry.IsEmpty()then if Confirm(UnprocessedEntriesQst)then PAGE.RunModal(0, TempEmployeeLedgerEntry);
    end;
    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        TempEmployeeLedgerEntry.DeleteAll();
        ShowPostingDateWarning:=false;
    end;
    var Empl2: Record Employee;
    GenJnlTemplate: Record "Gen. Journal Template";
    GenJnlBatch: Record "Gen. Journal Batch";
    GenJnlLine: Record "Gen. Journal Line";
    DimSetEntry: Record "Dimension Set Entry";
    GenJnlLine2: Record "Gen. Journal Line";
    //  EmployeeLedgerEntry: Record "Employee Ledger Entry";
    EmployeeLedgerEntry: Record "Global Employee Ledger Entry";
    GLAcc: Record "G/L Account";
    BankAcc: Record "Bank Account";
    TempPayableEmployeeLedgerEntry: Record "Payable Employee Ledger Entry" temporary;
    CompanyInformation: Record "Company Information";
    TempEmplPaymentBuffer: Record "Employee Payment Buffer" temporary;
    TempEmployeePaymentBufferOld: Record "Employee Payment Buffer" temporary;
    SelectedDim: Record "Selected Dimension";
    // TempEmployeeLedgerEntry: Record "Employee Ledger Entry" temporary;
    TempEmployeeLedgerEntry: Record "Global Employee Ledger Entry" temporary;
    DimMgt: Codeunit DimensionManagement;
    DimBufMgt: Codeunit "Dimension Buffer Management";
    Window: Dialog;
    Window2: Dialog;
    PostingDateReq: Date;
    NextDocNo: Code[20];
    AmountAvailable: Decimal;
    OriginalAmtAvailable: Decimal;
    SummarizePerEmpl: Boolean;
    SummarizePerDim: Boolean;
    SummarizePerDimTextReq: Text[250];
    LastLineNo: Integer;
    NextEntryNo: Integer;
    StopPayments: Boolean;
    DocNoPerLine: Boolean;
    BankPmtType: Enum "Bank Payment Type";
    BalAccType: Enum "Gen. Journal Account Type";
    BalAccNo: Code[20];
    MessageText: Text;
    GenJnlLineInserted: Boolean;
    SummarizePerDimTextEnable: Boolean;
    ShowPostingDateWarning: Boolean;
    EmployeeBalance: Decimal;
    SkipExportPayments: Boolean;
    ShortcutDim3: Code[20];
    ShortcutDim4: Code[20];
    ShortcutDim5: Code[20];
    ShortcutDim6: Code[20];
    ShortcutDim7: Code[20];
    ShortcutDim8: Code[20];
    ShortcutDim9: Code[20];
    ShortcutDim10: Code[20];
    ShortcutDim11: Code[20];
    ShortcutDim12: Code[20];
    ShortcutDim13: Code[20];
    PostingDateRequiredErr: Label 'In the Posting Date field, specify the date that will be used as the posting date for the journal entries.';
    StartingDocNoErr: Label 'In the Starting Document No. field, specify the first document number to be used.';
    ProcessingEmployeesMsg: Label 'Processing employees     #1##########', Comment = '#1########## is for the progress dialog. Don''t translate that part of the string';
    InsertingJournalLinesMsg: Label 'Inserting payment journal lines #1##########', Comment = '#1########## is for the progress dialog. Don''t translate that part of the string';
    AccountTypeErr: Label '%1 must be G/L Account or Bank Account.', Comment = '%1 - balancing account type';
    BankPaymentTypeErr: Label ' Type field must be filled only when Bal. Account Type is set to Bank Account.';
    BalAccountTypeErr: label 'Balancing account must be %1 or %2.', Comment = '%1 - Bank Account, %2 - G/L Account';
    ManualCheckErr: Label 'If  type is set to Manual Check, and you have not selected the Summarize per Employee field,\ then you must select the New Doc. No. per Line.';
    EmployeePaymentLinesCreatedTxt: Label 'You have created suggested employee payment lines.';
    UnprocessedEntriesQst: Label 'There are one or more entries for which no payment suggestions have been made because the posting dates of the entries are later than the requested posting date. Do you want to see the entries?';
    ReplacePostingDateMsg: Label 'For one or more entries, the requested posting date is before the work date.\\These posting dates will use the work date.';
    StartingDocumentNoErr: Label 'The value in the Starting Document No. field must have a number so that we can assign the next number in the series.';
    UnsupportedCurrencyErr: Label 'The balancing bank account must have local currency.';
    NextBankDocNo: CODE[20]; //#179 TEC.VJ 22012025
    l_GLSetup: Record "General Ledger Setup"; //#179 TEC.VJ 22012025
    procedure SetGenJnlLine(NewGenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine:=NewGenJnlLine;
    end;
    local procedure ValidatePostingDate()
    var
        NoSeries: Codeunit "No. Series";
        l_GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        if GenJnlBatch."No. Series" = '' then begin
            NextDocNo:='';
            NextBankDocNo:=''; //#179 TEC.VJ 
        end
        else
        begin
            NextDocNo:=NoSeries.PeekNextNo(GenJnlBatch."No. Series", PostingDateReq);
            //#179 TEC.VJ>>
            l_GLSetup.Get();
            l_GLSetup.TestField("Bank Document Nos.");
            NextBankDocNo:=NoSeries.PeekNextNo(l_GLSetup."Bank Document Nos.", PostingDateReq);
        //NextBankDocNo := NoSeries.GetNextNo(l_GLSetup."Bank Document Nos.");
        //#179 TEC.VJ<<
        end;
        //#234 VJ 21Feb2025
        l_GenJnlLine.Reset();
        l_GenJnlLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        l_GenJnlLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        l_GenJnlLine.SetFilter("Line No.", '>0');
        if l_GenJnlLine.FindLast()then NextDocNo:=IncStr(l_GenJnlLine."Document No.");
    //#234 VJ 21Feb2025
    end;
    procedure InitializeRequest(NewAvailableAmount: Decimal; NewSkipExportedPayments: Boolean; NewPostingDate: Date; NewStartDocNo: Code[20]; NewSummarizePerEmpl: Boolean; BalAccType: Enum "Gen. Journal Account Type"; BalAccNo: Code[20]; BankPmtType: Enum "Bank Payment Type")
    begin
        AmountAvailable:=NewAvailableAmount;
        SkipExportPayments:=NewSkipExportedPayments;
        PostingDateReq:=NewPostingDate;
        NextDocNo:=NewStartDocNo;
        SummarizePerEmpl:=NewSummarizePerEmpl;
        GenJnlLine2."Bal. Account Type":=BalAccType;
        GenJnlLine2."Bal. Account No.":=BalAccNo;
        GenJnlLine2."Bank Payment Type":=BankPmtType;
    end;
    local procedure GetEmplLedgEntries(Positive: Boolean)
    var
        RecCompMap: Record "Company Name Mapping"; //Sgarg
    begin
        RecCompMap.Get(CompanyName); //Sgarg
        EmployeeLedgerEntry.Reset();
        EmployeeLedgerEntry.SetCurrentKey("Employee No.", Open, Positive);
        //Sgarg >>
        IF RecCompMap."Central payment company" <> '' then EmployeeLedgerEntry.SetFilter("Company Code", RecCompMap."Central payment company")
        else
            EmployeeLedgerEntry.SetRange("Company Code", CompanyName);
        //Sgarg <<
        // EmployeeLedgerEntry.compa
        EmployeeLedgerEntry.SetRange("Employee No.", Employee."No.");
        EmployeeLedgerEntry.SetRange(Open, true);
        EmployeeLedgerEntry.SetRange(Positive, Positive);
        EmployeeLedgerEntry.SetRange("Applies-to ID", '');
        if SkipExportPayments then EmployeeLedgerEntry.SetRange("Exported to Payment File", false);
        EmployeeLedgerEntry.SetFilter("Global Dimension 1 Code", Employee.GetFilter("Global Dimension 1 Filter"));
        EmployeeLedgerEntry.SetFilter("Global Dimension 2 Code", Employee.GetFilter("Global Dimension 2 Filter"));
        //Sgarg >>
        IF NOT(ShortcutDim3 = '')then EmployeeLedgerEntry.SetFilter("Shortcut Dimension 3 Code_PB", ShortcutDim3);
        IF NOT(ShortcutDim4 = '')then EmployeeLedgerEntry.SetFilter("Shortcut Dimension 4 Code_PB", ShortcutDim4);
        IF NOT(ShortcutDim5 = '')then EmployeeLedgerEntry.SetFilter("Shortcut Dimension 5 Code_PB", ShortcutDim5);
        IF NOT(ShortcutDim6 = '')then EmployeeLedgerEntry.SetFilter("Shortcut Dimension 6 Code_PB", ShortcutDim6);
        IF NOT(ShortcutDim7 = '')then EmployeeLedgerEntry.SetFilter("Shortcut Dimension 7 Code_PB", ShortcutDim7);
        IF NOT(ShortcutDim8 = '')then EmployeeLedgerEntry.SetFilter("Shortcut Dimension 8 Code_PB", ShortcutDim8);
        IF NOT(ShortcutDim9 = '')then EmployeeLedgerEntry.SetFilter("Shortcut Dimension 9 Code_PB", ShortcutDim9);
        IF NOT(ShortcutDim10 = '')then EmployeeLedgerEntry.SetFilter("Shortcut Dimension 10 Code_PB", ShortcutDim10);
        IF NOT(ShortcutDim11 = '')then EmployeeLedgerEntry.SetFilter("Shortcut Dimension 11 Code_PB", ShortcutDim11);
        IF NOT(ShortcutDim12 = '')then EmployeeLedgerEntry.SetFilter("Shortcut Dimension 12 Code_PB", ShortcutDim12);
        IF NOT(ShortcutDim13 = '')then EmployeeLedgerEntry.SetFilter("Shortcut Dimension 13 Code_PB", ShortcutDim13);
        //Sgarg <<
        //OnGetEmplLedgEntriesOnAfterSetFilters(EmployeeLedgerEntry, Positive, SkipExportPayments);
        if EmployeeLedgerEntry.FindSet()then repeat SaveAmount();
            until EmployeeLedgerEntry.Next() = 0;
    end;
    local procedure SaveAmount()
    begin
        GenJnlLine.Init();
        GenJnlLine.Validate("Posting Date", PostingDateReq);
        GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
        GenJnlLine."Account Type":=GenJnlLine."Account Type"::Employee;
        Empl2.Get(EmployeeLedgerEntry."Employee No.");
        GenJnlLine.Description:=CopyStr(Empl2.FullName(), 1, MaxStrLen(GenJnlLine.Description));
        GenJnlLine."Posting Group":=Empl2."Employee Posting Group";
        GenJnlLine."Salespers./Purch. Code":=Empl2."Salespers./Purch. Code";
        GenJnlLine.Validate("Bill-to/Pay-to No.", GenJnlLine."Account No.");
        GenJnlLine.Validate("Sell-to/Buy-from No.", GenJnlLine."Account No.");
        GenJnlLine."Gen. Posting Type":=GenJnlLine."Gen. Posting Type"::" ";
        GenJnlLine."Gen. Prod. Posting Group":='';
        GenJnlLine."Gen. Bus. Posting Group":='';
        GenJnlLine."VAT Bus. Posting Group":='';
        GenJnlLine."VAT Prod. Posting Group":='';
        GenJnlLine.Validate("Currency Code", EmployeeLedgerEntry."Currency Code");
        EmployeeLedgerEntry.CalcFields("Remaining Amount");
        GenJnlLine.Amount:=-EmployeeLedgerEntry."Remaining Amount";
        GenJnlLine.Validate(Amount);
        TempPayableEmployeeLedgerEntry."Employee No.":=EmployeeLedgerEntry."Employee No.";
        TempPayableEmployeeLedgerEntry."Entry No.":=NextEntryNo;
        TempPayableEmployeeLedgerEntry."Employee Ledg. Entry No.":=EmployeeLedgerEntry."Entry No.";
        TempPayableEmployeeLedgerEntry.Amount:=GenJnlLine.Amount;
        TempPayableEmployeeLedgerEntry.Positive:=(TempPayableEmployeeLedgerEntry.Amount > 0);
        TempPayableEmployeeLedgerEntry."Currency Code":=EmployeeLedgerEntry."Currency Code";
        TempPayableEmployeeLedgerEntry."Company Code":=EmployeeLedgerEntry."Company Code"; //Sgarg - Added
        TempPayableEmployeeLedgerEntry.Insert();
        NextEntryNo:=NextEntryNo + 1;
    end;
    local procedure CheckAmounts()
    var
        CurrencyBalance: Decimal;
        PrevCurrency: Code[10];
    begin
        TempPayableEmployeeLedgerEntry.SetRange("Employee No.", Employee."No.");
        PrevCurrency:='';
        CurrencyBalance:=0;
        if TempPayableEmployeeLedgerEntry.Find('-')then begin
            repeat if TempPayableEmployeeLedgerEntry."Currency Code" <> PrevCurrency then begin
                    if CurrencyBalance > 0 then AmountAvailable:=AmountAvailable - CurrencyBalance;
                    CurrencyBalance:=0;
                    PrevCurrency:=TempPayableEmployeeLedgerEntry."Currency Code";
                end;
                if(OriginalAmtAvailable = 0) or (AmountAvailable >= CurrencyBalance + TempPayableEmployeeLedgerEntry.Amount)then CurrencyBalance:=CurrencyBalance + TempPayableEmployeeLedgerEntry.Amount
                else
                    TempPayableEmployeeLedgerEntry.Delete();
            until TempPayableEmployeeLedgerEntry.Next() = 0;
            if OriginalAmtAvailable > 0 then AmountAvailable:=AmountAvailable - CurrencyBalance;
            if(OriginalAmtAvailable > 0) and (AmountAvailable <= 0)then StopPayments:=true;
        end;
        TempPayableEmployeeLedgerEntry.Reset();
    end;
    local procedure MakeGenJnlLines()
    var
        RemainingAmtAvailable: Decimal;
    begin
        TempEmplPaymentBuffer.Reset();
        TempEmplPaymentBuffer.DeleteAll();
        if BalAccType = BalAccType::"Bank Account" then CheckCurrencies(BalAccType, BalAccNo);
        if OriginalAmtAvailable <> 0 then begin
            RemainingAmtAvailable:=OriginalAmtAvailable;
            RemovePaymentsAboveLimit(TempPayableEmployeeLedgerEntry, RemainingAmtAvailable);
        end;
        CopyEmployeeLedgerEntriesToTempEmplPaymentBuffer(RemainingAmtAvailable);
        CopyTempEmpPaymentBuffersToGenJnlLines();
    end;
    local procedure CopyEmployeeLedgerEntriesToTempEmplPaymentBuffer(RemainingAmtAvailable: Decimal)
    var
        DimBuf: Record "Dimension Buffer";
        NoSeriesBatch: Codeunit "No. Series - Batch";
        L_ELE: Record "Employee Ledger Entry"; //TEC-SGarg
        NoSeries: Codeunit "No. Series";
        NoofPaymentBuffer: Integer;
        LineNo: Integer;
    begin
        NoofPaymentBuffer:=TempPayableEmployeeLedgerEntry.Count; //TEC.VJ
        if TempPayableEmployeeLedgerEntry.Find('-')then repeat TempPayableEmployeeLedgerEntry.SetRange("Employee No.", TempPayableEmployeeLedgerEntry."Employee No.");
                TempPayableEmployeeLedgerEntry.Find('-');
                repeat LineNo+=1; //TEC.VJ
                    // EmployeeLedgerEntry.Get(TempPayableEmployeeLedgerEntry."Employee Ledg. Entry No.");  //Sgarg- Commented
                    EmployeeLedgerEntry.Get(TempPayableEmployeeLedgerEntry."Employee Ledg. Entry No.", TempPayableEmployeeLedgerEntry."Company Code");
                    TempEmplPaymentBuffer."Employee No.":=EmployeeLedgerEntry."Employee No.";
                    TempEmplPaymentBuffer."Currency Code":=EmployeeLedgerEntry."Currency Code";
                    TempEmplPaymentBuffer."Payment Method Code":=EmployeeLedgerEntry."Payment Method Code";
                    TempEmplPaymentBuffer."Creditor No.":=EmployeeLedgerEntry."Creditor No.";
                    TempEmplPaymentBuffer."Payment Reference":=EmployeeLedgerEntry."Payment Reference";
                    TempEmplPaymentBuffer."Exported to Payment File":=EmployeeLedgerEntry."Exported to Payment File";
                    SetTempEmplPaymentBufferDims(DimBuf);
                    EmployeeLedgerEntry.CalcFields("Remaining Amount");
                    if SummarizePerEmpl then begin
                        TempEmplPaymentBuffer."Employee Ledg. Entry No.":=0;
                        if TempEmplPaymentBuffer.Find()then begin
                            TempEmplPaymentBuffer.Amount:=TempEmplPaymentBuffer.Amount + TempPayableEmployeeLedgerEntry.Amount;
                            TempEmplPaymentBuffer.Modify();
                        end
                        else
                        begin
                            TempEmplPaymentBuffer."Document No.":=NextDocNo;
                            //#179 VJ 22012025>>
                            TempEmplPaymentBuffer."Bank Document No. Applied":=NextBankDocNo; //
                            // if DocNoPerLine then
                            //     NextDocNo := NoSeriesBatch.SimulateGetNextNo(GenJnlBatch."No. Series", GenJnlLine."Posting Date", NextDocNo);
                            if DocNoPerLine then begin
                                NextDocNo:=NoSeriesBatch.SimulateGetNextNo(GenJnlBatch."No. Series", GenJnlLine."Posting Date", NextDocNo);
                                if NoofPaymentBuffer <> LineNo then NextBankDocNo:=NoSeries.GetNextNo(l_GLSetup."Bank Document Nos.", GenJnlLine."Posting Date", true);
                                if LineNo = 1 then NextBankDocNo:=NoSeries.GetNextNo(l_GLSetup."Bank Document Nos.", GenJnlLine."Posting Date", true);
                            end;
                            //#179 VJ 22012025<<
                            TempEmplPaymentBuffer.Amount:=TempPayableEmployeeLedgerEntry.Amount;
                            Window2.Update(1, EmployeeLedgerEntry."Employee No.");
                            TempEmplPaymentBuffer.Insert();
                        end;
                        EmployeeLedgerEntry."Applies-to ID":=TempEmplPaymentBuffer."Document No.";
                    end
                    else if not IsEntryAlreadyApplied(GenJnlLine, EmployeeLedgerEntry)then begin
                            TempEmplPaymentBuffer."Employee Ledg. Entry Doc. Type":=EmployeeLedgerEntry."Document Type";
                            TempEmplPaymentBuffer."Employee Ledg. Entry Doc. No.":=EmployeeLedgerEntry."Document No.";
                            TempEmplPaymentBuffer."Global Dimension 1 Code":=EmployeeLedgerEntry."Global Dimension 1 Code";
                            TempEmplPaymentBuffer."Global Dimension 2 Code":=EmployeeLedgerEntry."Global Dimension 2 Code";
                            TempEmplPaymentBuffer."Dimension Set ID":=EmployeeLedgerEntry."Dimension Set ID";
                            TempEmplPaymentBuffer."Employee Ledg. Entry No.":=EmployeeLedgerEntry."Entry No.";
                            TempEmplPaymentBuffer.Amount:=TempPayableEmployeeLedgerEntry.Amount;
                            Window2.Update(1, EmployeeLedgerEntry."Employee No.");
                            TempEmplPaymentBuffer.Insert();
                        end;
                    EmployeeLedgerEntry."Amount to Apply":=EmployeeLedgerEntry."Remaining Amount";
                    EmployeeLedgerEntry."Bank Document No. Applied":=TempEmplPaymentBuffer."Bank Document No. Applied"; //#179 VJ 22Jan2025
                    //TEC-SGarg- Added>>
                    if UpperCase(EmployeeLedgerEntry."Company Code") = UpperCase(CompanyName)then begin
                        L_ELE.Get(EmployeeLedgerEntry."Entry No.");
                        L_ELE."Applies-to ID":=EmployeeLedgerEntry."Applies-to ID";
                        L_ELE."Amount to Apply":=EmployeeLedgerEntry."Amount to Apply";
                        L_ELE."Applying Entry":=EmployeeLedgerEntry."Applying Entry";
                        L_ELE."Bank Document No. Applied":=EmployeeLedgerEntry."Bank Document No. Applied"; //#179 VJ 22Jan2025
                        L_ELE.Modify();
                    END;
                    //TEC-SGarg- Added<<
                    // CODEUNIT.Run(CODEUNIT::"Empl. Entry-Edit", EmployeeLedgerEntry);
                    CODEUNIT.Run(CODEUNIT::"Global Empl. Entry-Edit", EmployeeLedgerEntry);
                    TempPayableEmployeeLedgerEntry.Delete();
                    if OriginalAmtAvailable <> 0 then begin
                        RemainingAmtAvailable:=RemainingAmtAvailable - TempPayableEmployeeLedgerEntry.Amount;
                        RemovePaymentsAboveLimit(TempPayableEmployeeLedgerEntry, RemainingAmtAvailable);
                    end;
                until not TempPayableEmployeeLedgerEntry.FindSet();
                TempPayableEmployeeLedgerEntry.DeleteAll();
                TempPayableEmployeeLedgerEntry.SetRange("Employee No.");
            until not TempPayableEmployeeLedgerEntry.Find('-');
    end;
    local procedure CopyTempEmpPaymentBuffersToGenJnlLines()
    var
        Employee: Record Employee;
        NoSeriesBatch: Codeunit "No. Series - Batch";
        NoSeries: Codeunit "No. Series";
        GJB: Record "Gen. Journal Batch";
        EmpBankAcc: Record "Employee Bank Account";
        PM: Record "Payment Method";
        GlobalGenJnl: Codeunit "Global Gen. Jnl.-Apply"; //TEC.VJ
        NoofPaymentBuffer: Integer;
        LineNo: Integer;
    begin
        Clear(TempEmployeePaymentBufferOld);
        Clear(LineNo);
        TempEmplPaymentBuffer.SetCurrentKey("Document No.");
        TempEmplPaymentBuffer.SetFilter("Employee Ledg. Entry Doc. Type", '<>%1&<>%2', TempEmplPaymentBuffer."Employee Ledg. Entry Doc. Type"::Refund, TempEmplPaymentBuffer."Employee Ledg. Entry Doc. Type"::Payment);
        NoofPaymentBuffer:=TempEmplPaymentBuffer.Count;
        if TempEmplPaymentBuffer.FindSet()then repeat LineNo:=LineNo + 1;
                GenJnlLine.Init();
                Window2.Update(1, TempEmplPaymentBuffer."Employee No.");
                LastLineNo:=LastLineNo + 10000;
                GenJnlLine."Line No.":=LastLineNo;
                GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                GenJnlLine."Posting No. Series":=GenJnlBatch."Posting No. Series";
                if SummarizePerEmpl then begin
                    GenJnlLine."Document No.":=TempEmplPaymentBuffer."Document No.";
                    GenJnlLine."Bank Document No.":=TempEmplPaymentBuffer."Bank Document No. Applied" //TEC.VJ 23012025
 end
                else if DocNoPerLine then begin
                        if TempEmplPaymentBuffer.Amount < 0 then GenJnlLine."Document Type":=GenJnlLine."Document Type"::Refund;
                        GenJnlLine."Document No.":=NextDocNo;
                        GenJnlLine."Bank Document No.":=NextBankDocNo; //TEC.VJ 23012025
                        NextDocNo:=NoSeriesBatch.SimulateGetNextNo(GenJnlBatch."No. Series", GenJnlLine."Posting Date", NextDocNo);
                        if NoofPaymentBuffer <> LineNo then //TEC.VJ 23012025
 NextBankDocNo:=NoSeries.GetNextNo(l_GLSetup."Bank Document Nos.", GenJnlLine."Posting Date", true);
                    end
                    else if(TempEmplPaymentBuffer."Employee No." = TempEmployeePaymentBufferOld."Employee No.") and (TempEmplPaymentBuffer."Currency Code" = TempEmployeePaymentBufferOld."Currency Code")then begin
                            GenJnlLine."Document No.":=TempEmployeePaymentBufferOld."Document No.";
                            GenJnlLine."Bank Document No.":=TempEmployeePaymentBufferOld."Bank Document No."; //TEC.VJ 23012025
                        end
                        else
                        begin
                            GenJnlLine."Document No.":=NextDocNo;
                            GenJnlLine."Bank Document No.":=NextBankDocNo; //TEC.VJ 23012025
                            NextDocNo:=NoSeriesBatch.SimulateGetNextNo(GenJnlBatch."No. Series", GenJnlLine."Posting Date", NextDocNo);
                            if NoofPaymentBuffer <> LineNo then //TEC.VJ 23012025
 NextBankDocNo:=NoSeries.GetNextNo(l_GLSetup."Bank Document Nos.", GenJnlLine."Posting Date", true);
                            TempEmployeePaymentBufferOld:=TempEmplPaymentBuffer;
                            TempEmployeePaymentBufferOld."Document No.":=GenJnlLine."Document No.";
                            TempEmployeePaymentBufferOld."Bank Document No.":=GenJnlLine."Bank Document No."; //TEC.VJ 23012025
                        end;
                GenJnlLine."Account Type":=GenJnlLine."Account Type"::Employee;
                GenJnlLine.SetHideValidation(true);
                GenJnlLine.Validate("Posting Date", PostingDateReq);
                GenJnlLine.Validate("Account No.", TempEmplPaymentBuffer."Employee No.");
                //GenJnlLine.Validate("Recipient Bank Account", TempEmplPaymentBuffer."Employee No.");//VJ 23Jan2025 Commented
                Employee.Get(TempEmplPaymentBuffer."Employee No.");
                GenJnlLine."Bal. Account Type":=BalAccType;
                GenJnlLine.Validate("Bal. Account No.", BalAccNo);
                GenJnlLine.Validate("Currency Code", TempEmplPaymentBuffer."Currency Code");
                //GenJnlLine."Message to Recipient" := CompanyInformation.Name;//VJ 23Jan2025 Commented
                GenJnlLine."Bank Payment Type":=BankPmtType;
                if SummarizePerEmpl then GenJnlLine."Applies-to ID":=GenJnlLine."Document No.";
                GenJnlLine.Description:=CopyStr(Employee.FullName(), 1, MaxStrLen(GenJnlLine.Description));
                GenJnlLine."Source Line No.":=TempEmplPaymentBuffer."Employee Ledg. Entry No.";
                GenJnlLine."Shortcut Dimension 1 Code":=TempEmplPaymentBuffer."Global Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code":=TempEmplPaymentBuffer."Global Dimension 2 Code";
                GenJnlLine."Dimension Set ID":=TempEmplPaymentBuffer."Dimension Set ID";
                GenJnlLine."Source Code":=GenJnlTemplate."Source Code";
                GenJnlLine."Reason Code":=GenJnlBatch."Reason Code";
                GenJnlLine.Validate(Amount, TempEmplPaymentBuffer.Amount);
                GenJnlLine."Applies-to Doc. Type":=TempEmplPaymentBuffer."Employee Ledg. Entry Doc. Type";
                GenJnlLine."Applies-to Doc. No.":=TempEmplPaymentBuffer."Employee Ledg. Entry Doc. No.";
                //GenJnlLine."Payment Method Code" := TempEmplPaymentBuffer."Payment Method Code";
                //GenJnlLine."Payment Method Code" := GenJnlBatch."Payment Method Code"; //Sgarg- Added
                GenJnlLine.Validate("Payment Method Code", GenJnlBatch."Payment Method Code"); //VJ 23Jan2025- Added
                GenJnlLine."Creditor No.":=CopyStr(TempEmplPaymentBuffer."Creditor No.", 1, MaxStrLen(GenJnlLine."Creditor No."));
                GenJnlLine."Payment Reference":=CopyStr(TempEmplPaymentBuffer."Payment Reference", 1, MaxStrLen(GenJnlLine."Payment Reference"));
                GenJnlLine."Exported to Payment File":=TempEmplPaymentBuffer."Exported to Payment File";
                GenJnlLine."Applies-to Ext. Doc. No.":=TempEmplPaymentBuffer."Applies-to Ext. Doc. No.";
                /* //VJ 23Jan2025 moved the code in the gne jornal on payment method validation
                //TEC.VT 16JAN2024 >>
                PM.Reset();
                GJB.Reset();
                if GJB.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name") then begin
                    if PM.Get(GJB."Payment Method Code") then begin
                        //if (PM."Transaction Type" = PM."Transaction Type"::"Telegraphic Transfer") OR (PM."Transaction Type" = PM."Transaction Type"::"BOC Remittance Plus") then begin
                        if (PM."Transaction Type" = PM."Transaction Type"::"BOC Remittance Plus") then begin//VJ 23Jan changed
                            if EmpBankAcc.Get(GenJnlLine."Account No.", GenJnlLine."Employee Bank Account") then begin

                                GenJnlLine."Payment Purpose" := EmpBankAcc."Payment Purpose";
                                GenJnlLine."Message to Recipient" := EmpBankAcc."Payment Purpose";
                            end;
                        end;
                        //VJ 23Jan added
                        if PM."Transaction Type" = PM."Transaction Type"::"Telegraphic Transfer" then begin
                            if EmpBankAcc.Get(GenJnlLine."Account No.", GenJnlLine."Employee Bank Account") then begin

                                GenJnlLine."Message to Recipient" := 'IFSC Code ' + EmpBankAcc."IFSC Code";
                            end;
                        end;
                        //VJ 23Jan added
                    end;
                end;

                //TEC.VT 16JAN2024 <<
                */
                // CommonFunc.CreateBankDocuemntNo(GenJnlLine);//#169 TEC.VJ 17012025
                // GenJnlLine."Bank Document No." := TempEmplPaymentBuffer."Bank Document No. Applied";//#179 TEC.VJ
                GlobalGenJnl.UpdateAppliedAmountForEmployee(GenJnlLine); //TEC.VJ 23012025
                OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(GenJnlLine, TempEmplPaymentBuffer);
                UpdateDimensions(GenJnlLine);
                GenJnlLine.Insert();
                GenJnlLineInserted:=true;
            until TempEmplPaymentBuffer.Next() = 0;
    end;
    local procedure UpdateDimensions(var GenJnlLine3: Record "Gen. Journal Line")
    var
        DimBuf: Record "Dimension Buffer";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        TempDimSetEntry2: Record "Dimension Set Entry" temporary;
        DimVal: Record "Dimension Value";
        NewDimensionID: Integer;
        DimSetIDArr: array[10]of Integer;
    begin
        NewDimensionID:=GenJnlLine3."Dimension Set ID";
        if SummarizePerEmpl then begin
            DimBuf.Reset();
            DimBuf.DeleteAll();
            DimBufMgt.GetDimensions(TempEmplPaymentBuffer."Dimension Entry No.", DimBuf);
            if DimBuf.FindSet()then repeat DimVal.Get(DimBuf."Dimension Code", DimBuf."Dimension Value Code");
                    TempDimSetEntry."Dimension Code":=DimBuf."Dimension Code";
                    TempDimSetEntry."Dimension Value ID":=DimVal."Dimension Value ID";
                    TempDimSetEntry."Dimension Value Code":=DimBuf."Dimension Value Code";
                    TempDimSetEntry.Insert();
                until DimBuf.Next() = 0;
            NewDimensionID:=DimMgt.GetDimensionSetID(TempDimSetEntry);
            GenJnlLine3."Dimension Set ID":=NewDimensionID;
        end;
        GenJnlLine3.CreateDimFromDefaultDim(0);
        if NewDimensionID <> GenJnlLine3."Dimension Set ID" then begin
            DimSetIDArr[2]:=NewDimensionID;
            DimSetIDArr[1]:=GenJnlLine3."Dimension Set ID";
            GenJnlLine3."Dimension Set ID":=DimMgt.GetCombinedDimensionSetID(DimSetIDArr, GenJnlLine3."Shortcut Dimension 1 Code", GenJnlLine3."Shortcut Dimension 2 Code");
        end;
        if SummarizePerEmpl then begin
            DimMgt.GetDimensionSet(TempDimSetEntry, GenJnlLine3."Dimension Set ID");
            if AdjustAgainstSelectedDim(TempDimSetEntry, TempDimSetEntry2)then GenJnlLine3."Dimension Set ID":=DimMgt.GetDimensionSetID(TempDimSetEntry2);
            DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine3."Dimension Set ID", GenJnlLine3."Shortcut Dimension 1 Code", GenJnlLine3."Shortcut Dimension 2 Code");
        end;
        OnAfterUpdateDimensions(GenJnlLine, SummarizePerEmpl);
    end;
    local procedure ShowMessage(Text: Text)
    begin
        if GenJnlLineInserted then begin
            if ShowPostingDateWarning then Text+=ReplacePostingDateMsg;
            if Text <> '' then Message(Text);
        end;
    end;
    local procedure CheckCurrencies(BalAccType: Enum "Gen. Journal Account Type"; BalAccNo: Code[20])
    var
        BankAcc2: Record "Bank Account";
    begin
        if BalAccType = BalAccType::"Bank Account" then if BalAccNo <> '' then begin
                BankAcc2.Get(BalAccNo);
                if BankAcc2."Currency Code" <> '' then Error(UnsupportedCurrencyErr);
                MessageText:=EmployeePaymentLinesCreatedTxt;
            end;
    end;
    local procedure ClearNegative()
    var
        TempCurrency: Record Currency temporary;
        TempPayableEmplLedgEntry2: Record "Payable Employee Ledger Entry" temporary;
        CurrencyBalance: Decimal;
    begin
        Clear(TempPayableEmployeeLedgerEntry);
        TempPayableEmployeeLedgerEntry.SetRange("Employee No.", Employee."No.");
        while TempPayableEmployeeLedgerEntry.Next() <> 0 do begin
            TempCurrency.Code:=TempPayableEmployeeLedgerEntry."Currency Code";
            CurrencyBalance:=0;
            if TempCurrency.Insert()then begin
                TempPayableEmplLedgEntry2:=TempPayableEmployeeLedgerEntry;
                TempPayableEmplLedgEntry2.SetRange("Currency Code", TempPayableEmployeeLedgerEntry."Currency Code");
                repeat CurrencyBalance:=CurrencyBalance + TempPayableEmployeeLedgerEntry.Amount until TempPayableEmployeeLedgerEntry.Next() = 0;
                if CurrencyBalance < 0 then begin
                    TempPayableEmployeeLedgerEntry.DeleteAll();
                    AmountAvailable+=CurrencyBalance;
                end;
                TempPayableEmployeeLedgerEntry.SetRange("Currency Code");
                TempPayableEmployeeLedgerEntry:=TempPayableEmplLedgEntry2;
            end;
        end;
        TempPayableEmployeeLedgerEntry.Reset();
    end;
    local procedure DimCodeIsInDimBuf(DimCode: Code[20]; DimBuf: Record "Dimension Buffer"): Boolean begin
        DimBuf.Reset();
        DimBuf.SetRange("Dimension Code", DimCode);
        exit(not DimBuf.IsEmpty);
    end;
    local procedure RemovePaymentsAboveLimit(var PayableEmplLedgEntry: Record "Payable Employee Ledger Entry"; RemainingAmtAvailable: Decimal)
    begin
        PayableEmplLedgEntry.SetFilter(Amount, '>%1', RemainingAmtAvailable);
        PayableEmplLedgEntry.DeleteAll();
        PayableEmplLedgEntry.SetRange(Amount);
    end;
    local procedure InsertDimBuf(var DimBuf: Record "Dimension Buffer"; TableID: Integer; EntryNo: Integer; DimCode: Code[20]; DimValue: Code[20])
    begin
        DimBuf.Init();
        DimBuf."Table ID":=TableID;
        DimBuf."Entry No.":=EntryNo;
        DimBuf."Dimension Code":=DimCode;
        DimBuf."Dimension Value Code":=DimValue;
        DimBuf.Insert();
    end;
    local procedure AdjustAgainstSelectedDim(var TempDimSetEntry: Record "Dimension Set Entry" temporary; var TempDimSetEntry2: Record "Dimension Set Entry" temporary): Boolean begin
        if SelectedDim.FindSet()then begin
            repeat TempDimSetEntry.SetRange("Dimension Code", SelectedDim."Dimension Code");
                if TempDimSetEntry.FindFirst()then begin
                    TempDimSetEntry2.TransferFields(TempDimSetEntry, true);
                    TempDimSetEntry2.Insert();
                end;
            until SelectedDim.Next() = 0;
            exit(true);
        end;
        exit(false);
    end;
    local procedure SetTempEmplPaymentBufferDims(var DimBuf: Record "Dimension Buffer")
    var
        GLSetup: Record "General Ledger Setup";
        EntryNo: Integer;
    begin
        if SummarizePerDim then begin
            DimBuf.Reset();
            DimBuf.DeleteAll();
            if SelectedDim.Find('-')then repeat if DimSetEntry.Get(EmployeeLedgerEntry."Dimension Set ID", SelectedDim."Dimension Code")then InsertDimBuf(DimBuf, DATABASE::"Dimension Buffer", 0, DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code");
                until SelectedDim.Next() = 0;
            EntryNo:=DimBufMgt.FindDimensions(DimBuf);
            if EntryNo = 0 then EntryNo:=DimBufMgt.InsertDimensions(DimBuf);
            TempEmplPaymentBuffer."Dimension Entry No.":=EntryNo;
            if TempEmplPaymentBuffer."Dimension Entry No." <> 0 then begin
                GLSetup.Get();
                if DimCodeIsInDimBuf(GLSetup."Global Dimension 1 Code", DimBuf)then TempEmplPaymentBuffer."Global Dimension 1 Code":=EmployeeLedgerEntry."Global Dimension 1 Code"
                else
                    TempEmplPaymentBuffer."Global Dimension 1 Code":='';
                if DimCodeIsInDimBuf(GLSetup."Global Dimension 2 Code", DimBuf)then TempEmplPaymentBuffer."Global Dimension 2 Code":=EmployeeLedgerEntry."Global Dimension 2 Code"
                else
                    TempEmplPaymentBuffer."Global Dimension 2 Code":='';
            end
            else
            begin
                TempEmplPaymentBuffer."Global Dimension 1 Code":='';
                TempEmplPaymentBuffer."Global Dimension 2 Code":='';
            end;
            TempEmplPaymentBuffer."Dimension Set ID":=EmployeeLedgerEntry."Dimension Set ID";
        end
        else
        begin
            TempEmplPaymentBuffer."Dimension Entry No.":=0;
            TempEmplPaymentBuffer."Global Dimension 1 Code":='';
            TempEmplPaymentBuffer."Global Dimension 2 Code":='';
            TempEmplPaymentBuffer."Dimension Set ID":=0;
        end;
    end;
    local procedure IsEntryAlreadyApplied(GenJnlLine3: Record "Gen. Journal Line"; EmplLedgEntry2: Record "Global Employee Ledger Entry"): Boolean var
        GenJnlLine4: Record "Gen. Journal Line";
    begin
        GenJnlLine4.SetRange("Journal Template Name", GenJnlLine3."Journal Template Name");
        GenJnlLine4.SetRange("Journal Batch Name", GenJnlLine3."Journal Batch Name");
        GenJnlLine4.SetRange("Account Type", GenJnlLine4."Account Type"::Employee);
        GenJnlLine4.SetRange("Account No.", EmplLedgEntry2."Employee No.");
        GenJnlLine4.SetRange("Applies-to Doc. Type", EmplLedgEntry2."Document Type");
        GenJnlLine4.SetRange("Applies-to Doc. No.", EmplLedgEntry2."Document No.");
        exit(not GenJnlLine4.IsEmpty);
    end;
    local procedure SetDefaults()
    begin
        GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        GenJnlLine2."Bal. Account Type":=GenJnlBatch."Bal. Account Type";
        GenJnlLine2."Bal. Account No.":=GenJnlBatch."Bal. Account No.";
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateDimensions(var GenJournalLine: Record "Gen. Journal Line"; SummarizePerEmpl: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(var GenJournalLine: Record "Gen. Journal Line"; TempEmplPaymentBuffer: Record "Employee Payment Buffer" temporary)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnCopyEmployeeLedgerEntriesToTempEmplPaymentBufferOnAfterCopyEmployeeLedgerEntryFields(var TempEmplPaymentBuffer: Record "Employee Payment Buffer" temporary; EmployeeLedgerEntry: Record "Employee Ledger Entry")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnGetEmplLedgEntriesOnAfterSetFilters(var EmployeeLedgerEntry: Record "Employee Ledger Entry"; Positive: Boolean; SkipExportedPayments: Boolean);
    begin
    end;
}
