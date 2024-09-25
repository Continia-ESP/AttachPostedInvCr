codeunit 50001 "Attach Purch. Inv"
{
    TableNo = 6085590;
    trigger OnRun()

    begin
        Template.GET(Rec."Template No.");

        IF Field.GET(Rec."Template No.", Field.Type::Header, 'DOCNO') THEN
            DocNo := CaptureMgt.GetText(Rec, Field.Type::Header, Field.Code, 0);

        IF PurchDocMgt.GetDocumentType(Rec) = 2 THEN BEGIN
            PurchInvHeader.SETCURRENTKEY("Vendor Invoice No.");
            PurchInvHeader.SETRANGE("Buy-from Vendor No.", Rec.GetSourceID);
            PurchInvHeader.SETRANGE("Vendor Invoice No.", DocNo);
            IF NOT PurchInvHeader.FINDSET THEN
                EXIT;

            RecID := PurchInvHeader.RECORDID;
            TableNo := DATABASE::"Purchase Header";
        END ELSE BEGIN
            PurchCrMemoHeader.SETCURRENTKEY("Vendor Cr. Memo No.");
            PurchCrMemoHeader.SETRANGE("Buy-from Vendor No.", Rec.GetSourceID);
            PurchCrMemoHeader.SETRANGE("Vendor Cr. Memo No.", DocNo);
            IF NOT PurchCrMemoHeader.FINDSET THEN
                EXIT;

            RecID := PurchCrMemoHeader.RECORDID;
            TableNo := DATABASE::"Purchase Header";
        END;

        RecID := PurchInvHeader.RECORDID;
        TableNo := DATABASE::"Purchase Header";

        RecordLink.INIT;
        RecordLink."Record ID" := RecID;
        RecordLink.URL1 := GetFile(Rec);
        RecordLink.Description := STRSUBSTNO(ShipmentTxt, Rec.TABLECAPTION, Rec."No.");
        RecordLink.Type := RecordLink.Type::Link;
        RecordLink.Created := CREATEDATETIME(TODAY, TIME);
        RecordLink."User ID" := USERID;
        RecordLink.Company := COMPANYNAME;
        RecordLink.INSERT;

        Rec.Status := Rec.Status::Registered;
        Rec."Created Doc. Table No." := TableNo;
        Rec."Created Doc. Subtype" := 2;
        Rec."Created Doc. No." := PurchInvHeader."Pre-Assigned No.";
        Rec.MODIFY(TRUE);
    end;

    PROCEDURE GetFile(Document: Record 6085590): Text;
    VAR
        TempFile: Record 6085614 temporary;
    BEGIN
        IF Document."File Type" = Document."File Type"::OCR THEN
            Document.GetPdfFile(TempFile)
        ELSE BEGIN
            Document.GetMiscFile(TempFile);
            //TempFile.LoadData;
            //TempFile."File Location" := TempFile."File Location"::Memory;
            //TempFile.Name := Document.Description + '.' + Document."File Extension";
        END;

        EXIT(TempFile.Path + '\' + TempFile.Name);
    END;

    var
        Template: Record 6085579;
        Field: Record 6085580;
        Value: Record 6085593;
        CaptureMgt: Codeunit 6085576;
        DocumentCategory: Record 6085575;
        PurchInvHeader: Record 122;
        PurchCrMemoHeader: Record 124;
        RecordLink: Record 2000000068;
        RecID: RecordID;
        TableNo: Integer;
        DocNo: Code[35];
        PurchDocMgt: Codeunit 6085709;
        ShipmentTxt: TextConst ENU = '%1 - %2';
}

