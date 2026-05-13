codeunit 50130 "Replication Management"
{
    trigger OnRun()
    begin
    end;
    Procedure ReplicateMasters(TableID: Integer; PrimaryKeyFldCount: Integer; PrimaryKeyRef: KeyRef)
    var
        PrimaryKeyFldRef: array[3]of FieldRef;
        PrimaryKeyFldValue: array[3]of Code[20];
        i: Integer;
        ReplicateMasters: Record "Replicate Masters";
        ReplicateMasters2: Record "Replicate Masters";
        Company: Record Company;
    begin
        FOR i:=1 TO PrimaryKeyFldCount DO BEGIN
            PrimaryKeyFldRef[i]:=PrimaryKeyRef.FIELDINDEX(i);
            PrimaryKeyFldValue[i]:=PrimaryKeyFldRef[i].VALUE;
        END;
        ReplicateMasters.RESET;
        ReplicateMasters.SETRANGE("Table ID", TableID);
        ReplicateMasters.SETRANGE("No.", PrimaryKeyFldValue[1]);
        ReplicateMasters.SETRANGE("No. 2", PrimaryKeyFldValue[2]);
        ReplicateMasters.SETRANGE("No. 3", PrimaryKeyFldValue[3]);
        IF ReplicateMasters.FINDFIRST THEN ReplicateMasters.DELETEALL;
        Company.RESET;
        Company.SETFILTER(Name, '<>%1', COMPANYNAME);
        IF Company.FINDSET THEN REPEAT ReplicateMasters.INIT;
                ReplicateMasters."Table ID":=TableID;
                ReplicateMasters."No.":=PrimaryKeyFldValue[1];
                ReplicateMasters."No. 2":=PrimaryKeyFldValue[2];
                ReplicateMasters."No. 3":=PrimaryKeyFldValue[3];
                ReplicateMasters.Company:=Company.Name;
                ReplicateMasters."Primary Key Field Count":=PrimaryKeyFldCount;
                ReplicateMasters.INSERT(TRUE);
            UNTIL Company.NEXT = 0;
        Commit;
        ReplicateMasters.RESET;
        ReplicateMasters.FILTERGROUP(2);
        ReplicateMasters.SETRANGE("Table ID", TableID);
        ReplicateMasters.SETRANGE("No.", PrimaryKeyFldValue[1]);
        ReplicateMasters.SETRANGE("No. 2", PrimaryKeyFldValue[2]);
        ReplicateMasters.SETRANGE("No. 3", PrimaryKeyFldValue[3]);
        ReplicateMasters.FILTERGROUP(0);
        IF PAGE.RUNMODAL(PAGE::"Replicate Masters", ReplicateMasters) = ACTION::LookupOK THEN BEGIN
            ReplicateMasters2.RESET;
            ReplicateMasters2.COPYFILTERS(ReplicateMasters);
            ReplicateMasters2.SetRange(Replicate, true);
            IF ReplicateMasters2.FINDSET THEN REPEAT //  Message('In');
                    CreateAndUpdateMaster(ReplicateMasters2.Company, ReplicateMasters2."Table ID", ReplicateMasters2."Primary Key Field Count", ReplicateMasters2."No.", ReplicateMasters2."No. 2", ReplicateMasters2."No. 3");
                until ReplicateMasters2.Next() = 0;
        end;
    end;
    procedure CreateAndUpdateMaster(CompanyToReplicate: Text[30]; TableID: Integer; PrimaryKeyFldCount: Integer; AccountNo: Code[20]; AccountNo2: Code[20]; AccountNo3: Code[20])
    var
        RecRef: RecordRef;
        RecRef2: RecordRef;
        PrimaryFldRef: array[3]of FieldRef;
        i: Integer;
        FldRef: FieldRef;
        FldRef2: FieldRef;
    begin
        RecRef.OPEN(TableID, FALSE, COMPANYNAME);
        CASE PrimaryKeyFldCount OF 1: BEGIN
            PrimaryFldRef[1]:=RecRef.FIELDINDEX(1);
            PrimaryFldRef[1].SETRANGE(AccountNo);
        END;
        2: BEGIN
            PrimaryFldRef[1]:=RecRef.FIELDINDEX(1);
            PrimaryFldRef[1].SETRANGE(AccountNo);
            PrimaryFldRef[2]:=RecRef.FIELDINDEX(2);
            PrimaryFldRef[2].SETRANGE(AccountNo2);
        END;
        3: BEGIN
            PrimaryFldRef[1]:=RecRef.FIELDINDEX(1);
            PrimaryFldRef[1].SETRANGE(AccountNo);
            PrimaryFldRef[2]:=RecRef.FIELDINDEX(2);
            PrimaryFldRef[2].SETRANGE(AccountNo2);
            PrimaryFldRef[3]:=RecRef.FIELDINDEX(3);
            PrimaryFldRef[3].SETRANGE(AccountNo3);
        END;
        END;
        IF RecRef.FINDFIRST THEN BEGIN
            RecRef2.OPEN(TableID, FALSE, CompanyToReplicate);
            RecRef2.INIT;
            FOR i:=1 TO RecRef.FIELDCOUNT DO BEGIN
                FldRef:=RecRef.FIELDINDEX(i);
                FldRef2:=RecRef2.FIELDINDEX(i);
                FldRef2.VALUE:=FldRef.VALUE;
            END;
            IF NOT RecRef2.INSERT then RecRef2.Modify();
            RecRef2.CLOSE;
        end;
        CASE TableID OF 18: BEGIN
            ReplicateDefaultDimensions(CompanyToReplicate, TableID, AccountNo);
        END;
        23: begin
            ReplicateDefaultDimensions(CompanyToReplicate, TableID, AccountNo);
            ReplicateVendorBankAccounts(CompanyToReplicate, AccountNo);
        end;
        end;
        RecRef.CLOSE;
    end;
    procedure ReplicateVendorBankAccounts(CompanyToReplicate: Text[30]; AccountNo: Code[20])
    var
        VendBankAcc: Record "Vendor Bank Account";
        VendBankAcc2: Record "Vendor Bank Account";
    begin
        VendBankAcc.SETRANGE(VendBankAcc."Vendor No.", AccountNo);
        IF VendBankAcc.FINDSET THEN REPEAT VendBankAcc2.CHANGECOMPANY(CompanyToReplicate);
                IF VendBankAcc2.GET(VendBankAcc."Vendor No.", VendBankAcc.Code)THEN BEGIN
                    VendBankAcc2.TRANSFERFIELDS(VendBankAcc, FALSE);
                    VendBankAcc2.MODIFY;
                END
                ELSE
                BEGIN
                    VendBankAcc2.TRANSFERFIELDS(VendBankAcc);
                    VendBankAcc2.INSERT;
                END;
            UNTIL VendBankAcc.NEXT = 0;
    end;
    procedure ReplicateDefaultDimensions(CompanyToReplicate: Text[30]; TableID: Integer; AccountNo: Code[20])
    var
        DefaultDim: Record "Default Dimension";
        DefaultDim2: Record "Default Dimension";
    begin
        DefaultDim.SETRANGE(DefaultDim."Table ID", TableID);
        DefaultDim.SETRANGE(DefaultDim."No.", AccountNo);
        IF DefaultDim.FINDSET THEN REPEAT CreateDimensions(CompanyToReplicate, DefaultDim."Dimension Code");
                IF DefaultDim."Dimension Value Code" <> '' THEN CreateDimensionValues(CompanyToReplicate, DefaultDim."Dimension Code", DefaultDim."Dimension Value Code");
                DefaultDim2.CHANGECOMPANY(CompanyToReplicate);
                IF DefaultDim2.GET(DefaultDim."Table ID", DefaultDim."No.", DefaultDim."Dimension Code")THEN BEGIN
                    DefaultDim2.TRANSFERFIELDS(DefaultDim, FALSE);
                    DefaultDim2.MODIFY;
                END
                ELSE
                BEGIN
                    DefaultDim2.TRANSFERFIELDS(DefaultDim);
                    DefaultDim2.INSERT;
                END;
            UNTIL DefaultDim.NEXT = 0;
    end;
    procedure CreateDimensions(CompanyToReplicate: Text[30]; DimCode: Code[20])
    var
        Dim: Record Dimension;
        Dim2: Record Dimension;
    begin
        Dim.GET(DimCode);
        Dim2.CHANGECOMPANY(CompanyToReplicate);
        IF NOT Dim2.GET(DimCode)THEN BEGIN
            Dim2.TRANSFERFIELDS(Dim);
            Dim2.INSERT;
        END;
    end;
    procedure CreateDimensionValues(CompanyToReplicate: Text[30]; DimCode: Code[20]; DimValueCode: Code[20])
    var
        DimValue: Record "Dimension Value";
        DimValue2: Record "Dimension Value";
    begin
        DimValue.GET(DimCode, DimValueCode);
        DimValue2.CHANGECOMPANY(CompanyToReplicate);
        IF NOT DimValue2.GET(DimCode, DimValueCode)THEN BEGIN
            DimValue2.TRANSFERFIELDS(DimValue);
            DimValue2.INSERT;
        END;
    end;
}
