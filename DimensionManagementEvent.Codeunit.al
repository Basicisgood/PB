codeunit 50146 DimensionManagementEvent
{
    local procedure ValidateDimValueCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]; var GLSetupShortcutDimCode2: array[15]of Code[20])
    var
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
    begin
        GetGLSetup(GLSetupShortcutDimCode2);
        if(GLSetupShortcutDimCode2[FieldNumber] = '') and (ShortcutDimCode <> '')then Error(Text002, GLSetup.TableCaption());
        DimVal.SetRange("Dimension Code", GLSetupShortcutDimCode2[FieldNumber]);
        if ShortcutDimCode <> '' then begin
            DimVal.SetRange(Code, ShortcutDimCode);
            if not DimVal.FindFirst()then begin
                DimVal.SetFilter(Code, StrSubstNo('%1*', ShortcutDimCode));
                if DimVal.FindFirst()then ShortcutDimCode:=DimVal.Code
                else
                    Error(Text003, ShortcutDimCode, DimVal.FieldCaption(Code));
            end;
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, 'OnBeforeValidateShortcutDimValues', '', false, false)]
    local procedure OnBeforeValidateShortcutDimValues(var IsHandled: Boolean; var DimVal: Record "Dimension Value"; FieldNumber: Integer; var ShortcutDimCode: Code[20]; var DimSetID: Integer)
    var
        GLSetupShortcutDimCode2: array[15]of Code[20];
        DimenMgmt: Codeunit DimensionManagement;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        ValidateDimValueCode(FieldNumber, ShortcutDimCode, GLSetupShortcutDimCode2);
        DimVal."Dimension Code":=GLSetupShortcutDimCode2[FieldNumber];
        if ShortcutDimCode <> '' then begin
            DimVal.Get(DimVal."Dimension Code", ShortcutDimCode);
            if not DimenMgmt.CheckDim(DimVal."Dimension Code")then Error(DimenMgmt.GetDimErr());
            if not DimenMgmt.CheckDimValue(DimVal."Dimension Code", ShortcutDimCode)then Error(DimenMgmt.GetDimErr());
        end;
        DimenMgmt.GetDimensionSet(TempDimSetEntry, DimSetID);
        if TempDimSetEntry.Get(TempDimSetEntry."Dimension Set ID", DimVal."Dimension Code")then if TempDimSetEntry."Dimension Value Code" <> ShortcutDimCode then TempDimSetEntry.Delete();
        if ShortcutDimCode <> '' then begin
            TempDimSetEntry."Dimension Code":=DimVal."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimVal.Code;
            TempDimSetEntry."Dimension Value ID":=DimVal."Dimension Value ID";
            if TempDimSetEntry.Insert()then;
        end;
        DimSetID:=DimenMgmt.GetDimensionSetID(TempDimSetEntry);
        IsHandled:=true;
    end;
    local procedure GetGLSetup(var GLSetupShortcutDimCode: array[15]of Code[20])
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        GLSetupShortcutDimCode[1]:=GLSetup."Shortcut Dimension 1 Code";
        GLSetupShortcutDimCode[2]:=GLSetup."Shortcut Dimension 2 Code";
        GLSetupShortcutDimCode[3]:=GLSetup."Shortcut Dimension 3 Code";
        GLSetupShortcutDimCode[4]:=GLSetup."Shortcut Dimension 4 Code";
        GLSetupShortcutDimCode[5]:=GLSetup."Shortcut Dimension 5 Code";
        GLSetupShortcutDimCode[6]:=GLSetup."Shortcut Dimension 6 Code";
        GLSetupShortcutDimCode[7]:=GLSetup."Shortcut Dimension 7 Code";
        GLSetupShortcutDimCode[8]:=GLSetup."Shortcut Dimension 8 Code";
        GLSetupShortcutDimCode[9]:=GLSetup."Shortcut Dimension 9 Code";
        GLSetupShortcutDimCode[10]:=GLSetup."Shortcut Dimension 10 Code";
        GLSetupShortcutDimCode[11]:=GLSetup."Shortcut Dimension 11 Code";
        GLSetupShortcutDimCode[12]:=GLSetup."Shortcut Dimension 12 Code";
        GLSetupShortcutDimCode[13]:=GLSetup."Shortcut Dimension 13 Code";
        GLSetupShortcutDimCode[14]:=GLSetup."Shortcut Dimension 14 Code";
        GLSetupShortcutDimCode[15]:=GLSetup."Shortcut Dimension 15 Code";
    end;
    // [EventSubscriber(ObjectType::Table, Database::81, 'Onaf', 'ElementName', SkipOnMissingLicense, SkipOnMissingPermission)]
    // local procedure MyProcedure()
    // begin
    // end;
    /*
        [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", OnAfterInsertEvent, '', false, false)]
        local procedure OnGJLInsert(var Rec: Record "Gen. Journal Line")

        var
            L_DimSetEntry: Record "Dimension Set Entry";
            DimNo: Integer;
        begin
            IF rec.IsTemporary then
                exit;

            IF rec."Dimension Set ID" = 0 then
                exit;

            L_DimSetEntry.reset;
            L_DimSetEntry.SetRange("Dimension Set ID", rec."Dimension Set ID");
            IF L_DimSetEntry.FindFirst() then
                repeat
                    DimNo := 0;
                    DimNo := GetDimensionNo(L_DimSetEntry."Dimension Code");
                    if DimNo = 3 then
                        Rec."Shortcut Dimension 3 Code" := L_DimSetEntry."Dimension Value Code";
                    if DimNo = 4 then
                        Rec."Shortcut Dimension 4 Code" := L_DimSetEntry."Dimension Value Code";
                    if DimNo = 5 then
                        Rec."Shortcut Dimension 5 Code" := L_DimSetEntry."Dimension Value Code";
                    if DimNo = 6 then
                        Rec."Shortcut Dimension 6 Code" := L_DimSetEntry."Dimension Value Code";
                    if DimNo = 7 then
                        Rec."Shortcut Dimension 7 Code" := L_DimSetEntry."Dimension Value Code";
                    if DimNo = 8 then
                        Rec."Shortcut Dimension 8 Code" := L_DimSetEntry."Dimension Value Code";
                    if DimNo = 9 then
                        Rec."Shortcut Dimension 9 Code" := L_DimSetEntry."Dimension Value Code";
                    if DimNo = 10 then
                        Rec."Shortcut Dimension 10 Code" := L_DimSetEntry."Dimension Value Code";
                    if DimNo = 11 then
                        Rec."Shortcut Dimension 11 Code" := L_DimSetEntry."Dimension Value Code";
                    if DimNo = 12 then
                        Rec."Shortcut Dimension 12 Code" := L_DimSetEntry."Dimension Value Code";
                    if DimNo = 13 then
                        Rec."Shortcut Dimension 13 Code" := L_DimSetEntry."Dimension Value Code";
                    if DimNo = 14 then
                        Rec."Shortcut Dimension 14 Code" := L_DimSetEntry."Dimension Value Code";
                    if DimNo = 15 then
                        Rec."Shortcut Dimension 15 Code" := L_DimSetEntry."Dimension Value Code";
                until L_DimSetEntry.Next() = 0;
            rec.Modify();
        end;
    */
    [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", OnAfterCreateDim, '', false, false)]
    local procedure OnGJLdefaultDim(var GenJournalLine: Record "Gen. Journal Line")
    var
        L_DimSetEntry: Record "Dimension Set Entry";
        DimNo: Integer;
    begin
        IF GenJournalLine."Dimension Set ID" = 0 then exit;
        GenJournalLine."Shortcut Dimension 3 Code":='';
        GenJournalLine."Shortcut Dimension 4 Code":='';
        GenJournalLine."Shortcut Dimension 5 Code":='';
        GenJournalLine."Shortcut Dimension 6 Code":='';
        GenJournalLine."Shortcut Dimension 7 Code":='';
        GenJournalLine."Shortcut Dimension 8 Code":='';
        GenJournalLine."Shortcut Dimension 9 Code":='';
        GenJournalLine."Shortcut Dimension 10 Code":='';
        GenJournalLine."Shortcut Dimension 11 Code":='';
        GenJournalLine."Shortcut Dimension 12 Code":='';
        GenJournalLine."Shortcut Dimension 13 Code":='';
        GenJournalLine."Shortcut Dimension 14 Code":='';
        GenJournalLine."Shortcut Dimension 15 Code":='';
        L_DimSetEntry.reset;
        L_DimSetEntry.SetRange("Dimension Set ID", GenJournalLine."Dimension Set ID");
        IF L_DimSetEntry.FindFirst()then repeat DimNo:=0;
                DimNo:=GetDimensionNo(L_DimSetEntry."Dimension Code");
                if DimNo = 3 then GenJournalLine."Shortcut Dimension 3 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 4 then GenJournalLine."Shortcut Dimension 4 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 5 then GenJournalLine."Shortcut Dimension 5 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 6 then GenJournalLine."Shortcut Dimension 6 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 7 then GenJournalLine."Shortcut Dimension 7 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 8 then GenJournalLine."Shortcut Dimension 8 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 9 then GenJournalLine."Shortcut Dimension 9 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 10 then GenJournalLine."Shortcut Dimension 10 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 11 then GenJournalLine."Shortcut Dimension 11 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 12 then GenJournalLine."Shortcut Dimension 12 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 13 then GenJournalLine."Shortcut Dimension 13 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 14 then GenJournalLine."Shortcut Dimension 14 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 15 then GenJournalLine."Shortcut Dimension 15 Code":=L_DimSetEntry."Dimension Value Code";
            until L_DimSetEntry.Next() = 0;
    //GenJournalLine.Modify();
    end;
    [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", OnAfterShowDimensions, '', false, false)]
    local procedure OnAfterShowDimensions(var GenJournalLine: Record "Gen. Journal Line"; var IsChanged: Boolean)
    var
        L_DimSetEntry: Record "Dimension Set Entry";
        DimNo: Integer;
    begin
        IF not IsChanged then exit;
        IF GenJournalLine."Dimension Set ID" = 0 then exit;
        GenJournalLine."Shortcut Dimension 3 Code":='';
        GenJournalLine."Shortcut Dimension 4 Code":='';
        GenJournalLine."Shortcut Dimension 5 Code":='';
        GenJournalLine."Shortcut Dimension 6 Code":='';
        GenJournalLine."Shortcut Dimension 7 Code":='';
        GenJournalLine."Shortcut Dimension 8 Code":='';
        GenJournalLine."Shortcut Dimension 9 Code":='';
        GenJournalLine."Shortcut Dimension 10 Code":='';
        GenJournalLine."Shortcut Dimension 11 Code":='';
        GenJournalLine."Shortcut Dimension 12 Code":='';
        GenJournalLine."Shortcut Dimension 13 Code":='';
        GenJournalLine."Shortcut Dimension 14 Code":='';
        GenJournalLine."Shortcut Dimension 15 Code":='';
        L_DimSetEntry.reset;
        L_DimSetEntry.SetRange("Dimension Set ID", GenJournalLine."Dimension Set ID");
        IF L_DimSetEntry.FindFirst()then repeat DimNo:=0;
                DimNo:=GetDimensionNo(L_DimSetEntry."Dimension Code");
                if DimNo = 3 then GenJournalLine."Shortcut Dimension 3 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 4 then GenJournalLine."Shortcut Dimension 4 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 5 then GenJournalLine."Shortcut Dimension 5 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 6 then GenJournalLine."Shortcut Dimension 6 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 7 then GenJournalLine."Shortcut Dimension 7 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 8 then GenJournalLine."Shortcut Dimension 8 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 9 then GenJournalLine."Shortcut Dimension 9 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 10 then GenJournalLine."Shortcut Dimension 10 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 11 then GenJournalLine."Shortcut Dimension 11 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 12 then GenJournalLine."Shortcut Dimension 12 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 13 then GenJournalLine."Shortcut Dimension 13 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 14 then GenJournalLine."Shortcut Dimension 14 Code":=L_DimSetEntry."Dimension Value Code";
                if DimNo = 15 then GenJournalLine."Shortcut Dimension 15 Code":=L_DimSetEntry."Dimension Value Code";
            until L_DimSetEntry.Next() = 0;
        GenJournalLine.Modify();
    end;
    procedure GetDimensionNo(P_DimCode: Code[20]): Integer var
        DimCodeArr: array[15]of Code[20];
        GLSetup: Record "General Ledger Setup";
        i: Integer;
    begin
        GLSetup.GET;
        DimCodeArr[1]:=GLSetup."Shortcut Dimension 1 Code";
        DimCodeArr[2]:=GLSetup."Shortcut Dimension 2 Code";
        DimCodeArr[3]:=GLSetup."Shortcut Dimension 3 Code";
        DimCodeArr[4]:=GLSetup."Shortcut Dimension 4 Code";
        DimCodeArr[5]:=GLSetup."Shortcut Dimension 5 Code";
        DimCodeArr[6]:=GLSetup."Shortcut Dimension 6 Code";
        DimCodeArr[7]:=GLSetup."Shortcut Dimension 7 Code";
        DimCodeArr[8]:=GLSetup."Shortcut Dimension 8 Code";
        DimCodeArr[9]:=GLSetup."Shortcut Dimension 9 Code";
        DimCodeArr[10]:=GLSetup."Shortcut Dimension 10 Code";
        DimCodeArr[11]:=GLSetup."Shortcut Dimension 11 Code";
        DimCodeArr[12]:=GLSetup."Shortcut Dimension 12 Code";
        DimCodeArr[13]:=GLSetup."Shortcut Dimension 13 Code";
        DimCodeArr[14]:=GLSetup."Shortcut Dimension 14 Code";
        DimCodeArr[15]:=GLSetup."Shortcut Dimension 15 Code";
        for i:=3 to 15 Do begin
            case DimCodeArr[i]OF P_DimCode: begin
                exit(i);
            end;
            END;
        end;
    end;
    //OnAfterCreateDim(Rec, CurrFieldNo, xRec, OldDimSetID, DefaultDimSource);
    var Text002: Label 'This Shortcut Dimension is not defined in the %1.';
    Text003: Label '%1 is not an available %2 for that dimension.';
}
