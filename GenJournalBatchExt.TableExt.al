tableextension 50103 GenJournalBatchExt extends "Gen. Journal Batch"
{
    fields
    {
        field(50100; "Reviewer User"; Code[50])
        {
            Caption = 'Reviewer User';
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID" where("User Type"=const(Reviewer));
            ValidateTableRelation = false;
        }
        field(50101; "Review Status";Enum "Review Status")
        {
            Caption = 'Review Status';
            DataClassification = CustomerContent;
        }
        field(50102; "Review Comments"; Text[250])
        {
            Caption = 'Review Comments';
            DataClassification = CustomerContent;
        }
        field(50105; "Prepare User"; Code[50])
        {
            Caption = 'Prepare User';
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID" where("User Type"=const(Preparer));
            ValidateTableRelation = false;
        }
        field(50106; "Approver A Grp User"; Code[50])
        {
            Caption = 'Approver A Group User';
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID" where("User Type"=filter("Approver A group"|"Approver B group"));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                UpdateApproverABUser(Rec);
            end;
        }
        field(50107; "Approver B Grp User"; Code[50])
        {
            Caption = 'Approver B Group User';
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID" where("User Type"=filter("Approver A group"));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                UpdateApproverABUser(Rec);
            end;
        }
        field(50108; "Payment Method Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";

            trigger OnValidate()
            var
                PM: Record "Payment Method";
            begin
                PM.Reset();
                if PM.Get(Rec."Payment Method Code")then Rec."Export ifile":=PM."Export ifile";
            end;
        }
        //TEC.VJ 17DEC2042>>
        field(50109; "No. of Pending"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50110; "No. of Approved"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50111; "No. of Rejected"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        //TEC.VJ 17DEC2042<<
        //PS008 Start
        field(50112; "Value Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        //PS008 End
        //VT27122024 >>
        field(50113; "Export ifile"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //VT27122024 <<
        //#188 TEC.VJ >>
        field(50114; "Total No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        //#188 TEC.VJ <<
        //#191 TEC.VJ 29012025>>
        field(50115; "Reviewed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50116; "Staging EntryValueDate"; Date)
        {
            DataClassification = ToBeClassified;
        }
        //#191 TEC.VJ 29012025<<
        //#226 TEC.VJ 21022025>>
        field(50117; "Bypass API"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50118; "Bank Transfer"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Bank Transfer" then UpdateNoseries(Rec);
            end;
        }
        //#226 TEC.VJ 21022025<<
        //#280 TEC.VJ 20032025>>
        field(50119; "No Deletion After Post"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //#280 TEC.VJ 20032025<<
        //TEC.VJ 01042025<<
        field(50120; "Partially Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    //>>VJ 25mar2025 put from page 
    // trigger OnAfterInsert()
    // begin
    //     if StrLen(Rec.Name) > 7 then Error('Name Should be <=7 chars');
    // end;
    //VJ Commented on 28MAR2025
    //>>VJ 25mar2025 put from page 
    //RC No series logic chanee 20may2025
    trigger OnAfterInsert()
    var
        GenJournalTemp: record "Gen. Journal Template";
    begin
        GenJournalTemp.Reset();
        GenJournalTemp.Get(Rec."Journal Template Name");
        if(GenJournalTemp.Type = GenJournalTemp.Type::Payments)then begin
            UpdateNoseries(Rec)end;
    end;
    procedure UpdateNoseries(var GenJnlBatch_p: Record "Gen. Journal Batch")
    var
        Noseries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        GenJournalTemp: record "Gen. Journal Template";
        NoseriesStartingNo: Code[20];
        NoSeriesCode: Code[20];
        StartingNo: Code[10];
        page456: page 456;
        P457: page 457;
        //NoSeriesSetupImpl: Codeunit "No. Series - Setup Impl.";
        Implementation: Enum "No. Series Implementation";
    begin
        //VJ 23062025 Add code to handle no. series error when posting payment journal from inbound entry while inserting temp batchs to update no. of count fields in batch
        if GenJnlBatch_p.IsTemporary then exit;
        //VJ 23062025 Add
        GenJournalTemp.Reset();
        GenJournalTemp.Get(GenJnlBatch_p."Journal Template Name");
        StartingNo:='0001';
        NoseriesStartingNo:=CompanyName + '-' + GenJnlBatch_p.Name + '-' + StartingNo;
        NoSeriesCode:=Rec.Name;
        Noseries.Reset();
        Noseries.SetRange(Code, NoSeriesCode);
        if not Noseries.FindSet()then begin
            Noseries.Reset();
            Noseries.Init();
            Noseries.Code:=NoSeriesCode;
            Noseries.Description:=GenJournalTemp.Description;
            Noseries."Default Nos.":=true;
            Noseries."Manual Nos.":=true;
            Noseries.Insert();
        // NoSeriesSetupImpl.SetImplementation(Noseries, Implementation);
        end;
        NoSeriesLine.Reset();
        NoSeriesLine.SetRange("Series Code", NoSeriesCode);
        if not NoSeriesLine.FindSet()then begin
            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code":=NoSeriesCode;
            NoSeriesLine."Line No.":=10000;
            NoSeriesLine.validate("Starting No.", NoseriesStartingNo);
            NoSeriesLine."Increment-by No.":=1;
            NoSeriesLine.Open:=true;
            NoSeriesLine.Validate(Implementation, NoSeriesLine.Implementation::Sequence);
            NoSeriesLine."Sequence Name":=Format(CreateGuid(), 0, 4);
            NoSeriesLine."Starting Sequence No.":=1;
            NoSeriesLine.Insert();
        end;
        GenJnlBatch_p."No. Series":=NoSeriesCode;
    end;
    //>>VJ 28mar2025 add code
    trigger OnRename()
    begin
        if StrLen(Rec.Name) > 7 then Error('Name Should be <=7 chars');
    end;
    //<<VJ 28mar2025 add code
    procedure UpdateApproverABUser(GenJnlBatch_p: Record "Gen. Journal Batch")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GLSetup: record "General Ledger Setup";
    begin
        GLSetup.Get();
        GLSetup.TestField("Payment Jnl Approver1 Limit");
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", GenJnlBatch_p."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch_p.Name);
        IF GenJnlLine.FindSet()then repeat If GLSetup."Payment Jnl Approver1 Limit" > GenJnlLine."Amount (LCY)" then begin
                    If GenJnlBatch_p."Approver A Grp User" <> '' then GenJnlLine."Approver A Grp User":=GenJnlBatch_p."Approver A Grp User";
                    If GenJnlBatch_p."Approver B Grp User" <> '' then GenJnlLine."Approver B Grp User":=GenJnlBatch_p."Approver B Grp User";
                end
                Else
                begin
                    If GenJnlBatch_p."Approver A Grp User" <> '' then GenJnlLine."Approver A Grp User":=GenJnlBatch_p."Approver A Grp User";
                end;
                GenJnlLine.Modify();
            Until GenJnlLine.Next() = 0;
    end;
// trigger OnBeforeInsert()
// begin
//     if rec.Name <> 'DEFAULT' THEN
//         Rec."No Deletion After Post" := false;//#336 TEC.VJ 16052025
// end;
}
