codeunit 50170 "Concur Outbound Emp. Ins./Upd."
{ //PS005
    trigger OnRun()
    begin
        concurOutbound.reset;
        concurOutbound.SetRange("Table No.", 5200);
        //concurOutbound.SetRange("Entry Type", concurOutbound."Entry Type"::Insert);
        concurOutbound.SetFilter(Status, '<>%1&<>%2', concurOutbound.Status::Success, concurOutbound.Status::Cancel);
        IF concurOutbound.Findset()then begin
            repeat if concurOutbound."Entry Type" = concurOutbound."Entry Type"::Insert then EmployeeInsertUpdate(0);
                if concurOutbound."Entry Type" = concurOutbound."Entry Type"::Update then EmployeeInsertUpdate(1);
            until concurOutbound.Next() = 0;
        end;
    //Sleep(1000);
    //EmployeeInsert(1);
    end;
    procedure EmployeeInsertUpdate(P_Type: Option Insert, Update): Text var
        TokenUrl: Text[1024];
        ClientId: Text[1024];
        ClientSecret: Text[1024];
        Resource: Text[1024];
        HttpClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeader: HttpHeaders;
        Content: HttpContent;
        TempBlob: Codeunit "Temp Blob";
        Outstr: OutStream;
        Instr: InStream;
        APIResult: Text;
        ResponseJsonObject: JsonObject;
        ResponseJsonToken: JsonToken;
        AccessTokenErr: Text;
        AccessToken: Text;
        NewAccessToken: Text;
        JsonResponseTxt: Text;
        Employee: Record Employee;
    begin
        APISetup.GET;
        APISetup.TestField("Enable Outbound Integration", true);
        APISetup.TestField("Employee URL");
        APISetup.TestField("Company ID");
        //IF P_Type = 0 then begin
        //    APISetup.TestField("Employee URL");
        TokenUrl:=APISetup."Employee URL";
        //end else if P_Type = 1 then begin
        //    APISetup.TestField("Contact Update URL");
        //    TokenUrl := APISetup."Contact Update URL";
        //end;
        AccessToken:=GenerateRefreshToken();
        IF AccessToken = '' then Error('No Access Token generated');
        HttpClient.DefaultRequestHeaders().Add('Authorization', AccessToken);
        Content.GetHeaders(RequestHeader);
        RequestHeader.Clear();
        if P_Type = P_Type::Insert then begin
            HttpClient.SetBaseAddress(TokenURL);
            RequestMessage.Method('POST');
        end
        else
        begin
            Employee.get(concurOutbound."Primary key");
            HttpClient.SetBaseAddress(TokenURL + Employee."Concur ID");
            RequestMessage.Method('PATCH');
        end;
        RequestHeader.Remove('Content-Type');
        RequestHeader.Add('Content-Type', 'application/json');
        Clear(TempBlob);
        TempBlob.CreateOutStream(Outstr);
        Outstr.WriteText(PrepareBody(P_Type));
        TempBlob.CreateInStream(Instr);
        Content.WriteFrom(Instr);
        RequestMessage.Content(Content);
        HttpClient.Send(RequestMessage, ResponseMessage);
        IF ResponseMessage.IsSuccessStatusCode()THEN BEGIN
            //Message('Success');
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            ProcessJasonresponse(JsonResponseTxt, true, ResponseMessage.HttpStatusCode);
        //Message('%1', JsonResponseTxt);
        end
        else
        begin
            ResponseMessage.Content().ReadAs(JsonResponseTxt);
            ProcessJasonresponse(JsonResponseTxt, false, ResponseMessage.HttpStatusCode);
        //Message('JsonResponse Text%1', JsonResponseTxt);
        // message('Error %1', CopyStr(GetLastErrorText(), 1, 100));
        end;
    end;
    procedure PrepareBody(P_Type: Option Insert, Update): Text var
        RecVend: Record Vendor;
        OutStr: OutStream;
        DefaultDim: Record "Default Dimension";
        RecEmployee: Record Employee;
        JArray: JsonArray;
        JArray2: JsonArray;
        JArray1: JsonArray;
        GLObject: JsonObject;
        GLObject1: JsonObject;
        GLObject2: JsonObject;
        GLObject3: JsonObject;
        DefDimObject: JsonObject;
        JsonData: Text;
        DVNOutbound: Record "DNV Outbound Log";
        GLSetup: Record "General Ledger Setup";
        CompNameMapping: Record "Company Name Mapping";
    begin
        clear(JArray);
        APISetup.get;
        //Clear(GLObject);
        TempOutboundLog.DeleteAll();
        GLSetup.get;
        //concurOutbound.reset;
        //concurOutbound.SetRange("Table No.", 5200);
        //concurOutbound.SetRange("Entry Type", P_Type);
        //concurOutbound.SetFilter(Status, '<>%1', concurOutbound.Status::Success);
        //IF concurOutbound.Findset() then begin
        //  repeat
        RecEmployee.Reset();
        RecEmployee.SetRange("No.", concurOutbound."Primary key");
        //RecEmployee.SetRange("Integrate to Concur", true);
        //RecEmployee.Setfilter(Company, '%1|%2|%3|%4|%5|%6|%7|%8|%9|%10|%11|%12', '209', '210', '214', '215', '217', '222', '232', '233', '234', '236', '245', '247');
        if Recemployee.Findfirst()then begin
            RecEmployee.TestField(Company);
            if P_Type = 0 then begin
                clear(GLObject);
                clear(JArray2);
                Clear(GLObject1);
                JArray2.Add('urn:ietf:params:scim:schemas:core:2.0:User');
                Globject.add('schemas', JArray2);
                //GLObject.Add('schemas', '[urn:ietf:params:scim:schemas:core:2.0:User]');
                if RecEmployee."Login ID" <> '' then GLObject.Add('userName', RecEmployee."Login ID")
                else
                    GLObject.Add('userName', RecEmployee."Company E-Mail");
                if RecEmployee.Status = RecEmployee.Status::Active then GLObject.Add('active', true)
                else
                    GLObject.Add('active', false);
                Clear(GLObject1);
                GLObject1.Add('givenName', RecEmployee."First Name");
                //GLObject1.Add('middleName', RecEmployee."Middle Name");
                GLObject1.Add('familyName', RecEmployee."Last Name");
                GLObject.Add('name', GLObject1);
                Clear(GLObject1);
                GLObject1.Add('value', RecEmployee."Company E-Mail");
                GLObject1.Add('type', 'work');
                Clear(JArray2);
                JArray2.add(GLObject1);
                GLObject.Add('emails', JArray2);
                //if RecEmployee."Expense Report Submitter" then
                Clear(JArray2);
                JArray2.Add('Expense');
                GLObject.Add('entitlements', JArray2);
                //else
                //    GLObject.Add('entitlements', '[Request]');
                Clear(GLObject1);
                GLObject1.Add('employeeNumber', RecEmployee."No.");
                GLObject1.Add('companyId', APISetup."Company ID");
                GLObject.Add('urn:ietf:params:scim:schemas:extension:enterprise:2.0:User', GLObject1);
                Clear(GLObject1);
                GLObject1.Add('locale', format(RecEmployee."Locale Code"));
                GLObject1.Add('country', RecEmployee."Country/Region Code");
                GLObject1.Add('ledgerCode', '400');
                GLObject1.Add('reimbursementCurrency', RecEmployee."Currency Code");
                if RecEmployee."Concur Cash Adv. Account code" <> '' then GLObject1.Add('cashAdvanceAccountCode', RecEmployee."Concur Cash Adv. Account code")
                else
                    GLObject1.Add('cashAdvanceAccountCode', RecEmployee."No.");
                Clear(GLObject2);
                Clear(JArray2);
                GLObject2.Add('id', 'orgUnit1');
                GLObject2.Add('value', format(RecEmployee.Region));
                JArray2.Add(GLObject2);
                //if DefaultDim.get(5200, RecEmployee."No.", GLSetup."Shortcut Dimension 8 Code") then begin
                //    APISetup.get;
                //    if (APISetup."Company Code Prefix" <> '') and (APISetup."Company Code Prefix" = copystr(DefaultDim."Dimension Value Code", 1, 1)) then begin
                Clear(GLObject2);
                GLObject2.Add('id', 'orgUnit3');
                // GLObject2.Add('value', copystr(RecEmployee.Company, 2)); //TEC.VJ 19Nov2025---
                GLObject2.Add('value', CompNameMapping.GetConcurCompCode(RecEmployee.Company)); //TEC.VJ 19Nov2025+++
                JArray2.Add(GLObject2);
                //    end;
                //end;
                if DefaultDim.get(5200, RecEmployee."No.", GLSetup."Shortcut Dimension 5 Code")then begin
                    Clear(GLObject2);
                    GLObject2.Add('id', 'orgUnit4');
                    GLObject2.Add('value', CopyStr(DefaultDim."Dimension Value Code", 1, 3));
                    JArray2.Add(GLObject2);
                    Clear(GLObject2);
                    GLObject2.Add('id', 'custom12');
                    GLObject2.Add('value', DefaultDim."Dimension Value Code");
                    JArray2.Add(GLObject2);
                end;
                Clear(GLObject2);
                if RecEmployee."Concur Corp Card ID" <> '' then begin
                    GLObject2.Add('id', 'custom13');
                    GLObject2.Add('value', RecEmployee."Concur Corp Card ID");
                end
                else
                begin
                    GLObject2.Add('id', 'custom13');
                    GLObject2.Add('value', '');
                end;
                JArray2.Add(GLObject2);
                Clear(GLObject2);
                if RecEmployee."Concur Personal Emp ID" <> '' then begin
                    GLObject2.Add('id', 'custom14');
                    GLObject2.Add('value', RecEmployee."Concur Personal Emp ID");
                end
                else
                begin
                    GLObject2.Add('id', 'custom14');
                    GLObject2.Add('value', RecEmployee."No.");
                end;
                JArray2.Add(GLObject2);
                Clear(GLObject2);
                if RecEmployee."Concur Vendor ID" <> '' then begin
                    GLObject2.Add('id', 'custom17');
                    GLObject2.Add('value', RecEmployee."Concur Vendor ID");
                end
                else
                begin
                    GLObject2.Add('id', 'custom17');
                    GLObject2.Add('value', RecEmployee."No.");
                end;
                JArray2.Add(GLObject2);
                Clear(GLObject2);
                GLObject2.Add('id', 'custom21');
                GLObject2.Add('value', format(RecEmployee."Employee Group"));
                JArray2.Add(GLObject2);
                GLObject1.Add('customData', JArray2);
                GLObject.Add('urn:ietf:params:scim:schemas:extension:spend:2.0:User', GLObject1);
                Clear(GLObject1);
                Clear(GLObject2);
                Clear(JArray2);
                Clear(GLObject3);
                GLObject3.Add('employeeNumber', RecEmployee."Emp. ID Exp. Rep. Approver");
                GLObject2.Add('approver', GLObject3);
                GLObject2.Add('primary', 'true');
                JArray2.Add(GLObject2);
                GLObject1.Add('report', JArray2);
                Clear(GLObject2);
                Clear(JArray2);
                Clear(GLObject3);
                GLObject3.Add('employeeNumber', RecEmployee."Emp. ID Cash Adv. Approver");
                GLObject2.Add('approver', GLObject3);
                GLObject2.Add('primary', 'true');
                JArray2.Add(GLObject2);
                GLObject1.Add('cashAdvance', JArray2);
                GLObject.Add('urn:ietf:params:scim:schemas:extension:spend:2.0:Approver', GLObject1);
                Clear(GLObject1);
                Clear(JArray2);
                Clear(GLObject2);
                if(RecEmployee."Expense Report Submitter") or (RecEmployee.Approver)then begin
                    if RecEmployee."Expense Report Submitter" then begin
                        GLObject2.Add('roleName', 'EXP_TRAVEL_AND_EXPENSE_USER');
                        JArray2.Add(GLObject2);
                        Clear(GLObject2);
                        GLObject2.Add('roleName', 'EXP_USER');
                        JArray2.Add(GLObject2);
                        Clear(GLObject2);
                    end;
                    if RecEmployee.Approver then begin
                        GLObject2.Add('roleName', 'EXP_APPROVER');
                        JArray2.Add(GLObject2);
                    end;
                    GLObject1.Add('roles', JArray2);
                    GLObject.Add('urn:ietf:params:scim:schemas:extension:spend:2.0:Role', GLObject1);
                end;
            end;
            if P_Type = 1 then begin
                clear(GLObject);
                clear(JArray2);
                JArray2.Add('urn:ietf:params:scim:api:messages:2.0:PatchOp');
                Globject.add('schemas', JArray2);
                Clear(JArray2);
                /*
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'userName');
                if RecEmployee."Login ID" <> '' then
                    GLObject1.Add('value', RecEmployee."Login ID")
                else
                    GLObject1.Add('value', RecEmployee."Company E-Mail");
                JArray2.Add(GLObject1);
                */
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'active');
                if RecEmployee.Status = RecEmployee.Status::Active then GLObject1.Add('value', true)
                else
                    GLObject1.Add('value', false);
                JArray2.Add(GLObject1);
                /*
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'name:givenName');
                GLObject1.Add('value', RecEmployee."First Name");
                JArray2.Add(GLObject1);

                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'name:familyName');
                GLObject1.Add('value', RecEmployee."Last Name");
                JArray2.Add(GLObject1);
                */
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'emails[type eq ' + '"' + 'work' + '"' + '].value');
                GLObject1.Add('value', RecEmployee."Company E-Mail");
                JArray2.Add(GLObject1);
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:employeeNumber');
                GLObject1.Add('value', RecEmployee."No.");
                JArray2.Add(GLObject1);
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:companyId');
                GLObject1.Add('value', APISetup."Company ID");
                JArray2.Add(GLObject1);
                if RecEmployee."Termination Date" <> 0D then begin
                    Clear(GLObject1);
                    GLObject1.Add('op', 'replace');
                    GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:terminationDate');
                    GLObject1.Add('value', format(RecEmployee."Termination Date", 0, '<Year4>-<Month,2>-<Day,2>') + 'T11:00:00.000');
                    JArray2.Add(GLObject1);
                //GLObject.Add('schemas', '[urn:ietf:params:scim:schemas:core:2.0:User]');
                end;
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:locale');
                GLObject1.Add('value', format(RecEmployee."Locale Code"));
                JArray2.Add(GLObject1);
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:country');
                GLObject1.Add('value', RecEmployee."Country/Region Code");
                JArray2.Add(GLObject1);
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:reimbursementCurrency');
                GLObject1.Add('value', RecEmployee."Currency Code");
                JArray2.Add(GLObject1);
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:cashAdvanceAccountCode');
                if RecEmployee."Concur Cash Adv. Account code" <> '' then GLObject1.Add('value', RecEmployee."Concur Cash Adv. Account code")
                else
                    GLObject1.Add('value', RecEmployee."No.");
                JArray2.Add(GLObject1);
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:customData[id eq ' + '"' + 'orgUnit1' + '"' + '].value');
                GLObject1.Add('value', format(RecEmployee.Region));
                JArray2.Add(GLObject1);
                if DefaultDim.get(5200, RecEmployee."No.", GLSetup."Shortcut Dimension 8 Code")then begin
                    Clear(GLObject1);
                    //APISetup.get;
                    //if (APISetup."Company Code Prefix" <> '') and (APISetup."Company Code Prefix" = copystr(DefaultDim."Dimension Value Code", 1, 1)) then begin
                    GLObject1.Add('op', 'replace');
                    GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:customData[id eq ' + '"' + 'orgUnit3' + '"' + '].value');
                    //GLObject1.Add('value', copystr(RecEmployee.Company, 2));//TEC.VJ 19Nov2025---
                    GLObject1.Add('value', CompNameMapping.GetConcurCompCode(RecEmployee.Company)); //TEC.VJ 19Nov2025+++
                    JArray2.Add(GLObject1);
                //end;
                end;
                if DefaultDim.get(5200, RecEmployee."No.", GLSetup."Shortcut Dimension 5 Code")then begin
                    Clear(GLObject1);
                    GLObject1.Add('op', 'replace');
                    GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:customData[id eq ' + '"' + 'orgUnit4' + '"' + '].value');
                    GLObject1.Add('value', copystr(DefaultDim."Dimension Value Code", 1, 3));
                    JArray2.Add(GLObject1);
                    Clear(GLObject1);
                    GLObject1.Add('op', 'replace');
                    GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:customData[id eq ' + '"' + 'custom12' + '"' + '].value');
                    GLObject1.Add('value', DefaultDim."Dimension Value Code");
                    JArray2.Add(GLObject1);
                end;
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:customData[id eq ' + '"' + 'custom13' + '"' + '].value');
                if RecEmployee."Concur Corp Card ID" <> '' then GLObject1.Add('value', RecEmployee."Concur Corp Card ID")
                else
                    GLObject1.Add('value', '');
                JArray2.Add(GLObject1);
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:customData[id eq ' + '"' + 'custom14' + '"' + '].value');
                if RecEmployee."Concur Personal Emp ID" <> '' then GLObject1.Add('value', RecEmployee."Concur Personal Emp ID")
                else
                    GLObject1.Add('value', RecEmployee."No.");
                JArray2.Add(GLObject1);
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:customData[id eq ' + '"' + 'custom17' + '"' + '].value');
                if RecEmployee."Concur Vendor ID" <> '' then GLObject1.Add('value', RecEmployee."Concur Vendor ID")
                else
                    GLObject1.Add('value', RecEmployee."No.");
                JArray2.Add(GLObject1);
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:customData[id eq ' + '"' + 'custom21' + '"' + '].value');
                GLObject1.Add('value', format(RecEmployee."Employee Group"));
                JArray2.Add(GLObject1);
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:spend:2.0:Approver:report');
                Clear(GLObject3);
                GLObject3.Add('employeeNumber', RecEmployee."Emp. ID Exp. Rep. Approver");
                Clear(GLObject2);
                GLObject2.Add('approver', GLObject3);
                GLObject2.Add('primary', 'true');
                Clear(JArray);
                JArray.Add(GLObject2);
                GLObject1.Add('value', JArray);
                JArray2.Add(GLObject1);
                Clear(GLObject1);
                GLObject1.Add('op', 'replace');
                GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:spend:2.0:Approver:cashAdvance');
                Clear(GLObject3);
                GLObject3.Add('employeeNumber', RecEmployee."Emp. ID Cash Adv. Approver");
                Clear(GLObject2);
                GLObject2.Add('approver', GLObject3);
                GLObject2.Add('primary', 'true');
                Clear(JArray);
                JArray.Add(GLObject2);
                GLObject1.Add('value', JArray);
                JArray2.Add(GLObject1);
                if(RecEmployee."Expense Report Submitter") or (RecEmployee.Approver)then begin
                    Clear(GLObject1);
                    Clear(JArray);
                    GLObject1.Add('op', 'add');
                    GLObject1.Add('path', 'urn:ietf:params:scim:schemas:extension:spend:2.0:Role:roles');
                    if RecEmployee."Expense Report Submitter" then begin
                        Clear(GLObject2);
                        GLObject2.Add('roleName', 'EXP_TRAVEL_AND_EXPENSE_USER');
                        JArray.Add(GLObject2);
                        Clear(GLObject2);
                        GLObject2.Add('roleName', 'EXP_USER');
                        JArray.Add(GLObject2);
                    end;
                    if RecEmployee.Approver then begin
                        Clear(GLObject2);
                        GLObject2.Add('roleName', 'EXP_APPROVER');
                        JArray.Add(GLObject2);
                    end;
                    GLObject1.Add('value', JArray);
                    JArray2.Add(GLObject1);
                end;
                GLObject.Add('Operations', JArray2);
            end;
        end
        else
        begin
            concurOutbound.Status:=DVNOutbound.Status::Error;
            concurOutbound."Error Message":='Employee Not found';
            concurOutbound.Modify();
        end;
        //until concurOutbound.Next() = 0;
        //end;
        //JArray2.WriteTo(JsonData);
        GLObject.WriteTo(JsonData);
        Clear(outstr);
        concurOutbound."Request Body".CreateOutStream(outstr);
        OutStr.Write(JsonData);
        concurOutbound.Modify();
        //Error('Request :%1', JsonData);
        Exit(JsonData);
    end;
    procedure ProcessJasonresponse(P_Jason: Text; IsSuccess: Boolean; HttpStatusCode: Integer)
    var
        Jmgt: Codeunit "JSON Management";
        JsonBuffer: Record "JSON Buffer";
        JsonBuffer2: Record "JSON Buffer" temporary;
        PartNo: Text;
        DocNo: Text;
        JPage: Page "JSon Buffer List";
        i: Integer;
        TotalObjectNo: Integer;
        CurrencyCode: code[20];
        ErrorText: Text[1000];
        PKEntryNo: Integer;
        PKEntryNo2: Integer;
        ExchangeRateDate: Text;
        ExchangeDateTime: DateTime;
        ExchangeDate: Date;
        OverallStatusVal: Text[30];
        OverallStatusMsg: Text[100];
        // ExchangeRateDateTxt : 
        Statusurl: Text[500];
        ProvisionID: Text[100];
        ConcurID: Text[100];
        StatusCode: Code[10];
        StartDate: text[20];
        CurrCode: Code[10];
        EmployeeNo: Code[20];
        EmployeeRec: Record Employee;
    begin
        //Message('Temp Count %1', TempOutboundLog.Count);
        JsonBuffer.DeleteAll();
        //Message('response...%1', P_Jason);
        JsonBuffer2.ReadFromText(P_Jason);
        //Page.Run(Page::"JSon Buffer List", JsonBuffer2);
        //Message('%1..Json Count', JsonBuffer2.Count);
        i:=0;
        EmployeeNo:='';
        Statusurl:='';
        ProvisionID:='';
        ConcurID:='';
        g_APISetup.Get();
        if IsSuccess then begin
            JsonBuffer2.reset;
            JsonBuffer2.SetFilter("Token type", '<>%1', JsonBuffer2."Token type"::"Property Name");
            JsonBuffer2.SetRange(Depth, 2);
            if JsonBuffer2.Findset()then begin
                repeat if(JsonBuffer2."Token type" = JsonBuffer2."Token type"::String) and (JsonBuffer2.Path = 'meta.statusUrl')then Statusurl:=JsonBuffer2.Value;
                    if(JsonBuffer2."Token type" = JsonBuffer2."Token type"::String) and (JsonBuffer2.Path = 'meta.provisionId')then ProvisionID:=JsonBuffer2.Value;
                //if (JsonBuffer2."Token type" = JsonBuffer2."Token type"::String)
                //and (StrPos(JsonBuffer2.Path, 'employeeNumber') <> 0) then begin
                //    EmployeeNo := JsonBuffer2.Value;
                //ConcurOutboundLog.Reset();
                //ConcurOutboundLog.SetRange("Primary key", EmployeeNo);
                //ConcurOutboundLog.Setfilter(Status, '<>%1', ConcurOutboundLog.Status::Success);
                //if ConcurOutboundLog.findlast then begin
                //end;
                //end;
                until JsonBuffer2.Next() = 0;
                ConcurOutbound."Status Code":=format(HttpStatusCode);
                ConcurOutbound."Status URL":=Statusurl;
                ConcurOutbound."Privision ID":=ProvisionID;
                ConcurOutbound."Status Message":='Success';
                ConcurOutbound."Sent Date Time":=CurrentDateTime;
                ConcurOutbound.Path:=g_APISetup."Employee URL";
                concurOutbound."Error Message":='';
                ConcurOutbound.Modify();
            end;
            JsonBuffer2.reset;
            JsonBuffer2.Setrange("Token type", JsonBuffer2."Token type"::String);
            JsonBuffer2.SetRange(Depth, 1);
            JsonBuffer2.SetRange(Path, 'id');
            if JsonBuffer2.Findfirst()then begin
                //ConcurOutboundLog.Reset();
                //ConcurOutboundLog.SetRange("Primary key", EmployeeNo);
                //ConcurOutboundLog.Setfilter(Status, '<>%1', ConcurOutboundLog.Status::Success);
                //if ConcurOutboundLog.findlast then begin
                ConcurOutbound."Concur ID":=JsonBuffer2.Value;
                ConcurOutbound.Status:=ConcurOutboundLog.Status::Success;
                concurOutbound."Error Message":='';
                ConcurOutbound.Modify();
                //end;
                if EmployeeRec.Get(concurOutbound."Primary key")then begin
                    EmployeeRec."Concur ID":=JsonBuffer2.Value;
                    EmployeeRec.Modify();
                end;
            end;
        end
        else
        begin
            JsonBuffer2.reset;
            JsonBuffer2.Setrange("Token type", JsonBuffer2."Token type"::String);
            JsonBuffer2.SetRange(Depth, 1);
            JsonBuffer2.SetRange(Path, 'detail');
            if JsonBuffer2.Findfirst()then begin
                //ConcurOutboundLog.Reset();
                //ConcurOutboundLog.SetRange("Primary key", concurOutbound."Primary key");
                //ConcurOutboundLog.SetFilter(Status, '<>%1', ConcurOutboundLog.Status::Success);
                //if ConcurOutboundLog.findlast then begin
                ConcurOutbound."Status Code":=format(HttpStatusCode);
                ConcurOutbound."Status Message":='Failed';
                ConcurOutbound."Error Message":=JsonBuffer2.Value;
                ConcurOutbound.Status:=ConcurOutboundLog.Status::Error;
                ConcurOutbound.Modify();
            //end;
            end;
        end;
    end;
    procedure GenerateRefreshToken(): Text var
        TokenURL: Text[1024];
        ClientId: Text[1024];
        ClientSecret: Text[1024];
        Resource: Text[1024];
        //  RequestBody: Label 'grant_type=client_credentials&client_id=%1&client_secret=%2&scope=%3';
        RequestBody: Label 'client_id=d4b0bf5d-9021-4ff7-bc48-b6c0ce512d9c&client_secret=2280ce1d-85a5-4ac0-989c-2073c3c809f0&grant_type=refresh_token&refresh_token=i5jzxuuhpxm5yafvw8olksu58mq'; /////this is also used for token generation in postman body
        HttpClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeader: HttpHeaders;
        Content: HttpContent;
        TempBlob: Codeunit "Temp Blob";
        Outstr: OutStream;
        Instr: InStream;
        APIResult: Text;
        ResponseJsonObject: JsonObject;
        ResponseJsonToken: JsonToken;
        AccessTokenErr: Text;
        AccessToken: Text;
        NewAccessToken: Text;
        APISetup: Record "Concur API Setup";
    begin
        APISetup.Get();
        // APISetup.TestField("Is Enable", true);
        APISetup.TestField("Token URL");
        APISetup.TestField("Client ID");
        APISetup.TestField("Client Secret");
        APISetup.TestField("Refresh Token");
        // APISetup.TestField("User Id");
        // APISetup.TestField(Password);
        AccessTokenErr:='';
        AccessToken:='';
        TokenURL:=APISetup."Token URL";
        RequestHeader:=HttpClient.DefaultRequestHeaders;
        RequestHeader.Add('User-Agent', 'Dynamics 365');
        AddHttpBasicAuthHeader(APISetup."User ID", APISetup.Password, HttpClient);
        Content.GetHeaders(RequestHeader);
        RequestHeader.Clear();
        HttpClient.SetBaseAddress(TokenURL);
        RequestMessage.Method('POST');
        RequestHeader.Remove('Content-Type');
        RequestHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        Clear(TempBlob);
        TempBlob.CreateOutStream(Outstr);
        //Outstr.WriteText(StrSubstNo(RequestBody));
        Outstr.WriteText(StrSubstNo('client_id=' + APISetup."Client ID" + '&client_secret=' + APISetup."Client Secret" + '&grant_type=refresh_token&refresh_token=' + APISetup."Refresh Token"));
        TempBlob.CreateInStream(Instr);
        Content.WriteFrom(Instr);
        RequestMessage.Content(Content);
        HttpClient.Send(RequestMessage, ResponseMessage);
        IF ResponseMessage.IsSuccessStatusCode()THEN BEGIN
            ResponseMessage.Content().ReadAs(APIResult);
            ResponseJsonObject.ReadFrom(APIResult);
            ResponseJsonObject.GET('access_token', ResponseJsonToken);
            AccessToken:='Bearer ' + ResponseJsonToken.AsValue().AsText();
        END
        ELSE
            AccessTokenErr:=CopyStr(GetLastErrorText(), 1, 100);
        //Message('%1', AccessToken);
        //APISetup.SetAccessToken(AccessToken);
        //APISetup.Modify();
        exit(AccessToken);
    end;
    procedure AddHttpBasicAuthHeader(UserName: Text[50]; Password: Text[50]; var HttpClient: HttpClient);
    var
        AuthString: Text;
        Base64Helpers: Codeunit "Base64 Convert";
    begin
        AuthString:=STRSUBSTNO('%1:%2', UserName, Password);
        AuthString:=Base64Helpers.ToBase64(AuthString);
        AuthString:=STRSUBSTNO('Basic %1', AuthString);
        HttpClient.DefaultRequestHeaders().Add('Authorization', AuthString);
    end;
    var Client: HttpClient;
    Request: HttpRequestMessage;
    Response: HttpResponseMessage;
    ContentHeaders: HttpHeaders;
    Content: HttpContent;
    Result: text;
    ActionResponse: Text;
    JLinesToken: JsonToken;
    Custom_JsonObject: JsonObject;
    JsonBuffer: Record "JSON Buffer" temporary;
    JsonBufferValue: Text;
    ArrayResult: Decimal;
    JsonManag: codeunit "JSON Management";
    APISetup: Record "Concur API Setup";
    ShowMess: Boolean;
    CU_TokenRequest: Codeunit "API Token Request";
    TempOutboundLog: Record "Concur Outbound Log" temporary;
    DNVOutboundLog: Record "Concur Outbound Log";
    g_APISetup: Record "Concur API Setup";
    ConcurOutboundLog: Record "Concur Outbound Log";
    concurOutbound: Record "Concur Outbound Log";
}
