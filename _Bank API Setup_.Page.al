page 50142 "Bank API Setup"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Bank API Setup';
    PageType = Card;
    SourceTable = "Bank API Setup";
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("PGP Base API Url"; Rec."PGP Base API Url")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PGP Base API Url field.';
                }
                field("Company Code Filter list"; Rec."Company Code Filter list")
                {
                    ApplicationArea = all;
                }
                field("Bank API List Date Formula"; Rec."Bank API List Date Formula")
                {
                    ApplicationArea = All;
                }
            }
            group("HSBC HK")
            {
                field("HSBC Base API Url"; Rec."HSBC HK Base API Url")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HSBC HK Base API Url field.';
                }
                field("HSBC Password"; Rec."HSBC HK Private Key Password")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HSBC HK Private Key Password field.';
                }
                field("HSBC HK Private Key"; HSBCPrivKey)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the HSBCPrivKey field.';
                    Caption = 'PB Private Key';

                    trigger OnValidate()
                    var
                        OutStream: OutStream;
                    begin
                        Rec."HSBC HK Private Key".CreateOutStream(OutStream);
                        OutStream.Write(HSBCPrivKey);
                        Rec.Modify();
                    end;
                }
                field("HSBC HK Public Key"; HSBCPubKey)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the HSBCPubKey field.';
                    Caption = 'HSBC Public Key';

                    trigger OnValidate()
                    var
                        OutStream: OutStream;
                    begin
                        Rec."HSBC HK Public Key".CreateOutStream(OutStream);
                        OutStream.Write(HSBCPubKey);
                        Rec.Modify();
                    end;
                }
                field("x-hsbc-profile-id"; Rec."x-hsbc-profile-id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the x-hsbc-profile-id field.';
                }
                field("x-hsbc-client-id"; Rec."x-hsbc-client-id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the x-hsbc-client-id field.';
                }
                field("x-hsbc-client-secret"; Rec."x-hsbc-client-secret")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the x-hsbc-client-secret field.';
                }
                field("x-payload-type"; Rec."x-payload-type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the x-payload-type field.';
                }
                field("HSBC Single Payment Endpoint"; Rec."HSBC Bulk Payment Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HSBC Bulk Payment Endpoint field.';
                }
                field("HSBC Statement Endpoint"; Rec."HSBC Statement Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HSBC Statement Endpoint field.';
                }
                field("HSBC Payment Status Endpoint"; Rec."HSBC Payment Status Endpoint")
                {
                    ToolTip = 'Specifies the value of the HSBC Payment Status Endpoint field.';
                    ApplicationArea = All;
                }
                /* field("HSBC Last Statement DateTime"; Rec."HSBC Last Statement DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HSBC Last Statement DateTime field.';
                } */
                field("HSBC Account Number"; Rec."HSBC Account Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HSBC Account Number field.';
                }
                field("HSBC Account Country"; Rec."HSBC Account Country")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HSBC Account Country field.';
                }
                field("HSBC Institution Code"; Rec."HSBC Institution Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HSBC Institution Code field.';
                }
                field("HSBC Account Type"; Rec."HSBC Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HSBC Account Type field.';
                }
                field("Bank Charge Account No."; Rec."Bank Charge Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Charge Account No. field.', Comment = '%';
                }
                field("Bank Charge Template Name"; Rec."Bank Charge Template Name")
                {
                    ToolTip = 'Specifies the value of the Bank Charge Template Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Charge Batch Name"; Rec."Bank Charge Batch Name")
                {
                    ToolTip = 'Specifies the value of the Bank Charge Batch Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                group("Inbound Template & Batch")
                {
                    Caption = 'Inbound Template & Batch';

                    field("CaschRcpt Template Name"; Rec."CaschRcpt Template Name")
                    {
                        ToolTip = 'Specifies the value of the CaschRcpt Template Name field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    field("CaschRcpt Batch Name"; Rec."CaschRcpt Batch Name")
                    {
                        ToolTip = 'Specifies the value of the CaschRcpt Batch Name field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    field("General Jnl. Template Name"; Rec."General Jnl. Template Name")
                    {
                        ToolTip = 'Specifies the value of the General Jnl. Template Name field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    field("General Jnl. Batch Name"; Rec."General Jnl. Batch Name")
                    {
                        ToolTip = 'Specifies the value of the General Jnl. Batch Name field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    field("Payment Jnl. Template Name"; Rec."Payment Jnl. Template Name")
                    {
                        ToolTip = 'Specifies the value of the Payment Jnl. Template Name field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    field("Payment Jnl. Batch Name"; Rec."Payment Jnl. Batch Name")
                    {
                        ToolTip = 'Specifies the value of the Payment Jnl. Batch Name field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    //#189 TEC.VJ 25012025>>
                    field("TRP Payment Jnl. Template Name"; Rec."TRP Payment Jnl. Template Name")
                    {
                        ToolTip = 'Specifies the value of the TRP Payment Jnl. Template Name field.', Comment = '%';
                        ApplicationArea = ALL;
                    }
                    field("TRP Payment Jnl. Batch Name"; Rec."TRP Payment Jnl. Batch Name")
                    {
                        ToolTip = 'Specifies the value of the TRP Payment Jnl. Batch Name field.', Comment = '%';
                        ApplicationArea = ALL;
                    }
                    field("Return Template Name"; Rec."Return Template Name")
                    {
                        ToolTip = 'Specifies the value of the Return Template Name field.', Comment = '%';
                        ApplicationArea = ALL;
                    }
                    field("Return Batch Name"; Rec."Return Batch Name")
                    {
                        ToolTip = 'Specifies the value of the Return Batch Name field.', Comment = '%';
                        ApplicationArea = ALL;
                    }
                    field("Bank Transfer Template Name"; Rec."Bank Transfer Template Name")
                    {
                        ToolTip = 'Specifies the value of the Bank Transfer Template Name field.', Comment = '%';
                        ApplicationArea = ALL;
                    }
                    field("Bank Transfer Batch Name"; Rec."Bank Transfer Batch Name")
                    {
                        ToolTip = 'Specifies the value of the Bank Transfer Batch Name field.', Comment = '%';
                        ApplicationArea = ALL;
                    }
                    //#189 TEC.VJ 25012025<<
                    field("Dummy GL Account"; Rec."Dummy GL Account")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Dummy G/L Account field.', Comment = '%';
                    }
                    //#293 TEC.VJ>> 
                    field("API Bank Dummy Account"; Rec."API Bank Dummy Account")
                    {
                        ToolTip = 'Specifies the value of the API Bank Dummy Account field.', Comment = '%';
                        ApplicationArea = All;
                    }
                    //#293 TEC.VJ<<
                    // field("Auto Post"; Rec."Auto Post")
                    // {
                    //     ToolTip = 'Specifies the value of the Auto Post field.', Comment = '%';
                    //     ApplicationArea = All;
                    // }
                    field("Batch Name No. Series"; Rec."Batch Name No. Series")
                    {
                        ToolTip = 'Specifies the value of the Batch Name No. Series field.', Comment = '%';
                        ApplicationArea = all;
                    }
                    field("Rejection Payment Jnl. NoS."; Rec."Rejection Payment Jnl. NoS.")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Rejection Payment Jnl. No. Series field.', Comment = '%';
                    }
                    field("Rejection IC Jnl. NoS."; Rec."Rejection IC Jnl. NoS.")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Rejection IC Jnl. No. Series field.', Comment = '%';
                    }
                    field("Split Inbound Date Wise"; Rec."Split Inbound Date Wise")
                    {
                        ToolTip = 'Split inbound entries into multiple batches based on Batch No. series fields by grouping posting dates.', Comment = '%';
                        ApplicationArea = all;
                    }
                }
            }
            /* group(BOC)
            {
                field("BOC API Base URL"; Rec."BOC API Base URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BOC API Base URL field.';
                }
                field("BOC Pre E2EE Endpoint"; Rec."BOC Pre E2EE Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BOC Pre E2EE Endpoint field.';
                }
                field("BOC platformAc"; Rec."BOC platformAc")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BOC platformAc field.';
                }
                field("BOC keyName"; Rec."BOC keyName")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BOC keyName field.';
                }
                field("BOC Private Key Password"; Rec."BOC Private Key Password")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BOC Private Key Password field.';
                }
                field("BOC Private Key"; BOCPrivKey)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the BOCPrivKey field.';
                    trigger OnValidate()
                    var
                        OutStream: OutStream;
                    begin
                        Rec."BOC Private Key".CreateOutStream(OutStream);
                        OutStream.Write(BOCPrivKey);
                        Rec.Modify();
                    end;
                }
                field("BOC Public Key"; BOCPubKey)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the BOCPubKey field.';
                    trigger OnValidate()
                    var
                        OutStream: OutStream;
                    begin
                        Rec."BOC Public Key".CreateOutStream(OutStream);
                        OutStream.Write(BOCPubKey);
                        Rec.Modify();
                    end;
                }
            } */
            group(Citi)
            {
                field("Citi API Base URL"; Rec."Citi API Base URL")
                {
                    ToolTip = 'Specifies the value of the Citi API Base URL field.';
                    ApplicationArea = All;
                }
                field("Citi Token Endpoint"; Rec."Citi Token Endpoint")
                {
                    ToolTip = 'Specifies the value of the Citi Token Endpoint field.';
                    ApplicationArea = All;
                }
                field("Citi Statement Token Endpoint"; Rec."Citi Statement Token Endpoint")
                {
                    ToolTip = 'Specifies the value of the Citi Statement Token Endpoint field.';
                    ApplicationArea = All;
                }
                field("Citi Payment Endpoint"; Rec."Citi Payment Endpoint")
                {
                    ToolTip = 'Specifies the value of the Citi Payment Endpoint field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Citi Statment Init Endpoint"; Rec."Citi Statment Init Endpoint")
                {
                    ToolTip = 'Specifies the value of the Citi Statment Init Endpoint field.';
                    ApplicationArea = All;
                }
                field("Citi Statment Retriv. Endpoint"; Rec."Citi Statment Retriv. Endpoint")
                {
                    ToolTip = 'Specifies the value of the Citi Statment Retriv. Endpoint field.';
                    ApplicationArea = All;
                }
                field("Citi Payment Status Endpoint"; Rec."Citi Payment Status Endpoint")
                {
                    ToolTip = 'Specifies the value of the Citi Payment Status Endpoint field.';
                    ApplicationArea = All;
                }
                field("Citi Client Id"; Rec."Citi Client Id")
                {
                    ToolTip = 'Specifies the value of the Citi Client Id field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Citi Client Secret"; Rec."Citi Client Secret")
                {
                    ToolTip = 'Specifies the value of the Citi Client Secret field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Citi WL ID + Branch Code"; Rec."Citi WL ID + Branch Code")
                {
                    ToolTip = 'Specifies the value of the Citi WL ID + Branch Code field.';
                    ApplicationArea = All;
                }
                field("Citi Encryption Cert"; CitiEnKey)
                {
                    ToolTip = 'Specifies the value of the Citi Encryption Cert field.', Comment = '%';
                    ApplicationArea = All;
                    MultiLine = true;

                    trigger OnValidate()
                    var
                        OutStream: OutStream;
                    begin
                        Rec."Citi Encryption Cert".CreateOutStream(OutStream);
                        OutStream.Write(CitiEnKey);
                        Rec.Modify();
                    end;
                }
                field("Citi Signing Cert"; CitiSignKey)
                {
                    ToolTip = 'Specifies the value of the Citi Signing Cert field.', Comment = '%';
                    ApplicationArea = All;
                    MultiLine = true;

                    trigger OnValidate()
                    var
                        OutStream: OutStream;
                    begin
                        Rec."Citi Signing Cert".CreateOutStream(OutStream);
                        OutStream.Write(CitiSignKey);
                        Rec.Modify();
                    end;
                }
                field("Citi Client SSL Cert"; CitiClientSslKey)
                {
                    ToolTip = 'Specifies the value of the Citi Client SSL Cert field.', Comment = '%';
                    ApplicationArea = All;
                    MultiLine = true;
                    Editable = false;
                }
                field("Citi Client SSL Password"; Rec."Citi Client SSL Password")
                {
                    ToolTip = 'Specifies the value of the Citi Client SSL Password field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Citi Client Encryption Cert"; CitiClientEncryptKey)
                {
                    ToolTip = 'Specifies the value of the Citi Client Encryption Cert field.', Comment = '%';
                    ApplicationArea = All;
                    MultiLine = true;
                    Editable = false;
                }
                field("Citi Client Encrypt Password"; Rec."Citi Client Encrypt Password")
                {
                    ToolTip = 'Specifies the value of the Citi Client Encrypt Password field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Citi Client Sign Cert"; CitiClientSignKey)
                {
                    ToolTip = 'Specifies the value of the Citi Client Sign Cert field.', Comment = '%';
                    ApplicationArea = All;
                    MultiLine = true;
                    Editable = false;
                }
                field("Citi Client Sign Password"; Rec."Citi Client Sign Password")
                {
                    ToolTip = 'Specifies the value of the Citi Client Sign Password field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
            group("Batch No. Series")
            {
                Caption = 'Batch No. Series';

                field("HKLV No. Series"; Rec."HKLV No. Series")
                {
                    ToolTip = 'Specifies the value of the HKLV No. Series field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("HKUV No. Series"; Rec."HKUV No. Series")
                {
                    ToolTip = 'Specifies the value of the HKUV No. Series field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("USLV No. Series"; Rec."USLV No. Series")
                {
                    ToolTip = 'Specifies the value of the USLV No. Series field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("USUV No. Series"; Rec."USUV No. Series")
                {
                    ToolTip = 'Specifies the value of the USUV No. Series field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(WL395; Rec.WL395)
                {
                    ToolTip = 'Specifies the value of the WL395 field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(DO391; Rec.DO391)
                {
                    ToolTip = 'Specifies the value of the DO391 field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(CB392; Rec.CB392)
                {
                    ToolTip = 'Specifies the value of the CB392 field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(BT393; Rec.BT393)
                {
                    ToolTip = 'Specifies the value of the BT393 field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(FP403; Rec.FP403)
                {
                    ToolTip = 'Specifies the value of the FP403 field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(CITI949; Rec.CITI949)
                {
                    ToolTip = 'Specifies the value of the CITI949 field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(CITI391; Rec.CITI391)
                {
                    ToolTip = 'Specifies the value of the CITI391 field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(CITI392; Rec.CITI392)
                {
                    ToolTip = 'Specifies the value of the CITI392 field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(CITI393; Rec.CITI393)
                {
                    ToolTip = 'Specifies the value of the CITI393 field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(CITI403; Rec.CITI403)
                {
                    ToolTip = 'Specifies the value of the CITI403 field.', Comment = '%';
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("client.ssl")
            {
                ToolTip = 'Executes the client.ssl action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    FileName: Text;
                    InStream: InStream;
                    OutStream: OutStream;
                    Base64: Codeunit "Base64 Convert";
                begin
                    if UploadIntoStream('', '', '', FileName, InStream)then begin
                        Rec."Citi Client SSL Cert".CreateOutStream(OutStream);
                        OutStream.Write(Base64.ToBase64(InStream));
                        rec.modify();
                    end;
                end;
            }
            action("client.signing")
            {
                ToolTip = 'Executes the client.signing action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    FileName: Text;
                    InStream: InStream;
                    OutStream: OutStream;
                    Base64: Codeunit "Base64 Convert";
                begin
                    if UploadIntoStream('', '', '', FileName, InStream)then begin
                        Rec."Citi Client Sign Cert".CreateOutStream(OutStream);
                        OutStream.Write(Base64.ToBase64(InStream));
                        rec.modify();
                    end;
                end;
            }
            action("client.encryption")
            {
                ToolTip = 'Executes the client.encryption action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    FileName: Text;
                    InStream: InStream;
                    OutStream: OutStream;
                    Base64: Codeunit "Base64 Convert";
                begin
                    if UploadIntoStream('', '', '', FileName, InStream)then begin
                        Rec."Citi Client Encryption Cert".CreateOutStream(OutStream);
                        OutStream.Write(Base64.ToBase64(InStream));
                        rec.modify();
                    end;
                end;
            }
        }
    }
    var HSBCPubKey: Text;
    HSBCPrivKey: Text;
    BOCPubKey: Text;
    BOCPrivKey: Text;
    CitiEnKey: Text;
    CitiSignKey: Text;
    CitiClientSslKey: Text;
    CitiClientEncryptKey: Text;
    CitiClientSignKey: Text;
    trigger OnOpenPage()
    begin
        if Rec.Count < 1 then begin
            Rec.Init();
            Rec."No.":=0;
            Rec.Insert();
        end;
    end;
    trigger OnAfterGetRecord()
    begin
        GetBlobValues();
    end;
    local procedure GetBlobValues()
    var
        InStream: InStream;
    begin
        Rec.CalcFields("HSBC HK Public Key", "HSBC HK Private Key", "BOC Private Key", "BOC Public Key", "Citi Encryption Cert", "Citi Signing Cert", "Citi Client SSL Cert", "Citi Client Encryption Cert", "Citi Client Sign Cert");
        Clear(InStream);
        Rec."HSBC HK Public Key".CreateInStream(InStream);
        InStream.Read(HSBCPubKey);
        Clear(InStream);
        Rec."HSBC HK Private Key".CreateInStream(InStream);
        InStream.Read(HSBCPrivKey);
        Clear(InStream);
        Rec."BOC Private Key".CreateInStream(InStream);
        InStream.Read(BOCPrivKey);
        Clear(InStream);
        Rec."BOC Public Key".CreateInStream(InStream);
        InStream.Read(BOCPubKey);
        Clear(InStream);
        Rec."Citi Encryption Cert".CreateInStream(InStream);
        InStream.Read(CitiEnKey);
        Clear(InStream);
        Rec."Citi Signing Cert".CreateInStream(InStream);
        InStream.Read(CitiSignKey);
        Clear(InStream);
        Rec."Citi Client SSL Cert".CreateInStream(InStream);
        InStream.Read(CitiClientSslKey);
        Clear(InStream);
        Rec."Citi Client Encryption Cert".CreateInStream(InStream);
        InStream.Read(CitiClientEncryptKey);
        Clear(InStream);
        Rec."Citi Client Sign Cert".CreateInStream(InStream);
        InStream.Read(CitiClientSignKey);
    end;
}
