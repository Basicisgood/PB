report 50111 "Parse Vessel XML"
{
    Caption = 'Parse Vessel XML';
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    UseRequestPage = false;

    dataset
    {
        dataitem("Vessel Export Inbound"; "Vessel Export Inbound")
        {
            DataItemTableView = WHERE("Vessel Code"=filter(''), "Vessel Name"=filter('')); // Process only blank records

            trigger OnAfterGetRecord()
            var
                VesselInbound: Record "Vessel Export Inbound";
                InStr: InStream;
                XmlDoc: XmlDocument;
                xmlDoc2: XmlDocument;
                xmlNodList: XmlNodeList;
                xmlNod: XmlNode;
                xmlNod2: XmlNode;
                RootNode: XmlElement;
                VesselCodeNode: XmlElement;
                VesselNameNode: XmlElement;
                VesselCode: Text[20];
                VesselName: Text[50];
                XmlString: Text[1024]; // Adjust size based on expected XML content
                Textvar: Text;
                XmlBuffer: Record "XML Buffer" temporary;
                Firstpos: Integer;
                SecondPos: Integer;
            begin
                XmlBuffer.DeleteAll();
                // Check if the "Data" Blob field has content
                VesselCode:='';
                VesselName:='';
                "Vessel Export Inbound".CalcFields(Data);
                if "Vessel Export Inbound"."Data".HasValue()then begin
                    "Vessel Export Inbound"."Data".CreateInStream(InStr);
                    // InStr.ReadText(XmlString);
                    // Read the Blob content into a text variable
                    XmlBuffer.LoadFromStream(InStr);
                    XmlBuffer.SetRange(XmlBuffer.Type, XmlBuffer.Type::Element);
                    if XmlBuffer.FindFirst()then repeat // Check if the current node is 'vesselCode' or 'vesselName'
                            if XmlBuffer.Name = 'vesselCode' then VesselCode:=XmlBuffer.Value;
                            if XmlBuffer.Name = 'vesselName' then VesselName:=XmlBuffer.Value;
                        until XmlBuffer.Next() = 0;
                    // Update the record with parsed values
                    if(VesselCode <> '')then "Vessel Export Inbound"."Vessel Code":=VesselCode;
                    if(VesselName <> '')then "Vessel Export Inbound"."Vessel Name":=VesselName;
                    "Vessel Export Inbound".Modify();
                end;
            // until VesselInbound.Next() = 0;
            // end;
            end;
        // end;
        }
    }
}
