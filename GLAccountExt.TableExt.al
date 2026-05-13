tableextension 50107 GLAccountExt extends "G/L Account"
{
    fields
    {
        field(50000; "Remarks"; Text[250])
        {
        }
        field(50001; "Include Revaluation"; Boolean)
        {
            Caption = 'Include Revaluation';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                BPG: Record "Bank Account Posting Group";
                CPG: Record "Customer Posting Group";
                VPG: Record "Vendor Posting Group";
            begin
                if "Include Revaluation" then begin
                    bpg.Reset();
                    bpg.SetRange("G/L Account No.", Rec."No.");
                    if BPG.FindFirst()then Error('Not allowed to enable, G/L account No. %1 found in Bank Account Posting Group.', rec."No.");
                    cpg.Reset();
                    cpg.SetRange("Receivables Account", Rec."No.");
                    if cPG.FindFirst()then Error('Not allowed to enable, G/L account No. %1 found in Customer Posting Group.', rec."No.");
                    vpg.Reset();
                    vpg.SetRange("Payables Account", Rec."No.");
                    if vPG.FindFirst()then Error('Not allowed to enable, G/L account No. %1 found in Vendor Posting Group.', rec."No.");
                end;
            end;
        }
        //PS010 Start
        field(50002; "Account Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Account Group";

            trigger OnValidate()
            var
                CompanyMapping: Record "Company Name Mapping";
            begin
                CompanyMapping.get(CompanyName);
                CompanyMapping.TestField("Master Data Company", true);
            end;
        }
        field(50003; RMT1; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = RMT1;
        }
        field(50004; RMT2; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = RMT2;
        }
        field(50005; RMT3; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = RMT3;
        }
        field(50006; RMT4; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = RMT4;
        }
        field(50007; RMT5; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = RMT5;
        }
    }
    // trigger OnInsert()
    // begin
    //     if not DNVSetup.get then exit;
    //     DNVSetup.TestField("G/L Account Initials Sync");
    //     IF StrPos(rec."No.", DNVSetup."G/L Account Initials Sync") = 1 then
    //         CreateOutboundLog(0);
    // end;
    // trigger OnModify()
    // begin
    //     if not DNVSetup.get then exit;
    //     DNVSetup.TestField("G/L Account Initials Sync");
    //     IF StrPos(rec."No.", DNVSetup."G/L Account Initials Sync") = 1 then
    //         CreateOutboundLog(1);
    // end;
    procedure CreateOutboundLog(P_Type: Option Insert, Update)
    var
        OutboundLog: Record "DNV Outbound Log";
        Log: Record "DNV Outbound Log";
    begin
        if not DNVSetup.get then exit;
        DNVSetup.TestField("G/L Account Initials Sync");
        IF StrPos(rec."No.", DNVSetup."G/L Account Initials Sync") = 1 then begin
            Log.reset;
            Log.SetCurrentKey("Table No.", "Primary key", Status);
            Log.SetRange("Table No.", 15);
            Log.SetRange("Primary key", Rec."No.");
            if P_Type = P_Type::Insert then Log.SetRange("Entry Type", Log."Entry Type"::Insert);
            if P_Type = P_Type::Update then Log.SetRange("Entry Type", Log."Entry Type"::Update);
            Log.SetFilter(Status, '<>%1', Log.Status::Success);
            IF Not Log.FindFirst()then begin
                OutboundLog.Init();
                OutboundLog."Table No.":=15;
                OutboundLog."Primary key":=rec."No.";
                OutboundLog."Entry Type":=P_Type;
                OutboundLog.Status:=OutboundLog.Status::Pending;
                OutboundLog."Company Name":=CompanyName;
                OutboundLog.Insert(true);
            End;
        end;
    end;
    var DNVSetup: Record "DNV Integration Setup";
}
