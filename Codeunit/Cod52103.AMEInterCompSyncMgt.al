codeunit 57100 "ITOS IC Sync Mgt."
{

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterInsertEvent', '', false, false)]
    local procedure Item_OnAfterInsertEvent(Rec: record Item)
    var
        InterCompSyncSetup: record "ITOS IC Sync Setup";
        InterCompSetup: Record "IC Setup";
    begin
        if not InterCompSetup."ITOS Sync Items to IC" then
            exit;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Unit of Measure", 'OnAfterInsertEvent', '', false, false)]
    local procedure ItemUOM_OnAfterInsertEvent(Rec: record "Item Unit of Measure")
    var
        InterCompSyncSetup: record "ITOS IC Sync Setup";
        ICSyncLog: Record "ITOS IC Sync Entries";
        ICSetup: Record "IC Setup";
    begin
        if not ICSetup."ITOS Sync Items to IC" then
            exit;

        InterCompSyncSetup.SetCurrentKey("ITOS Table No.", "ITOS Primary Key 1", "ITOS Primary Key 1", "ITOS Primary Key 2", "ITOS Primary Key 3", "ITOS Company Name");
        InterCompSyncSetup.SetRange("ITOS Table No.", Database::Item);
        InterCompSyncSetup.SetRange("ITOS Primary Key 1", REc."Item No.");
        InterCompSyncSetup.SetRange("ITOS Status", InterCompSyncSetup."ITOS Status"::Active);
        if InterCompSyncSetup.FindFirst() then
            repeat
                ICSyncLog.Init();
                ICSyncLog."ITOS Table No." := Database::"Item Unit of Measure";
                ICSyncLog."ITOS Primary Key 1" := Rec."Item No.";
                ICSyncLog."ITOS Primary Key 2" := rec.Code;
                ICSyncLog."ITOS Company Name" := InterCompSyncSetup."ITOS Company Name";
                ICSyncLog.Insert(true);
            until InterCompSyncSetup.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterInsertEvent', '', false, false)]
    local procedure Vendor_OnAfterInsertEvent(var Rec: Record Vendor)
    var
        InterCompSyncSetup: record "ITOS IC Sync Setup";
        InterCompSetup: Record "IC Setup";
    begin
        if not InterCompSetup."ITOS Sync Items to IC" then
            exit;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterInsertEvent', '', false, false)]
    local procedure Customer_OnAfterInsertEvent(var Rec: Record Customer)
    var
        InterCompSyncSetup: record "ITOS IC Sync Setup";
        InterCompSetup: Record "IC Setup";
    begin
        if not InterCompSetup."ITOS Sync Items to IC" then
            exit;
    end;

    [EventSubscriber(ObjectType::Table, Database::Dimension, 'OnAfterInsertEvent', '', false, false)]
    local procedure Dim_OnAfterInsertEvent(var Rec: Record Dimension)
    var
        InterCompSyncSetup: record "ITOS IC Sync Setup";
        InterCompSetup: Record "IC Setup";
    begin
        if not InterCompSetup."ITOS Sync Items to IC" then
            exit;
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Account", 'OnAfterInsertEvent', '', false, false)]
    local procedure GLAccount_OnAfterInsertEvent(var Rec: Record "G/L Account")
    var
        InterCompSyncSetup: record "ITOS IC Sync Setup";
        InterCompSetup: Record "IC Setup";
    begin
        if not InterCompSetup."ITOS Sync Items to IC" then
            exit;
    end;


    [TryFunction]
    procedure SendItemToIC(ItemRec: Record Item)
    var
        ICSyncSetup: Record "ITOS IC Sync Setup";
        ICSetup: Record "IC Setup";
    begin
        if ICSetup.Get() then
            ICSetup.TestField("ITOS Sync Items to IC", true);

        Clear(ICSyncSetup);
        ICSyncSetup.Reset();
        ICSyncSetup.SetCurrentKey("ITOS Table No.", "ITOS Primary Key 1", "ITOS Primary Key 2", "ITOS Primary Key 3", "ITOS Company Name");
        ICSyncSetup.SetRange("ITOS Table No.", Database::Item);
        ICSyncSetup.SetRange("ITOS Primary Key 1", ItemRec."No.");
        ICSyncSetup.SetRange("ITOS Status", ICSyncSetup."ITOS Status"::Active);
        if not ICSyncSetup.FindFirst() then
            Error('Setup not found');

        CreateSyncLogForItem(ItemRec, ICSyncSetup);
        ProcessICSyncEntries();
    end;

    procedure CreateSyncLogForItem(ItemRec: Record Item; var ICSyncSetup: Record "ITOS IC Sync Setup")
    var
        ICSyncLog: Record "ITOS IC Sync Entries";
        ItemUOM: Record "Item Unit of Measure";
    begin
        if ICSyncSetup.FindFirst() then
            repeat
                Clear(ICSyncLog);
                ICSyncLog.Init();
                ICSyncLog."ITOS Table No." := Database::Item;
                ICSyncLog."ITOS Primary Key 1" := ItemRec."No.";
                ICSyncLog."ITOS Company Name" := ICSyncSetup."ITOS Company Name";
                ICSyncLog."ITOS Status" := ICSyncLog."ITOS Status"::Created;
                ICSyncLog.Insert(true);
                //if ItemUOM.Get(ItemRec."No.", ItemRec."Base Unit of Measure") then
                //  CreateSyncLogForItemUOM(ItemUOM, ICSyncSetup);

                Clear(ItemUOM);
                ItemUOM.SetCurrentKey("Item No.", Code);
                ItemUOM.SetRange("Item No.", ItemRec."No.");
                if ItemUOM.FindFirst() then
                    repeat
                        CreateSyncLogForItemUOM(ItemUOM, ICSyncSetup);
                    until ItemUOM.Next() = 0;

                CreateAssemblyItem(ItemRec, ICSyncSetup);

            until ICSyncSetup.Next() = 0;
    end;

    procedure CreateSyncLogForDefaultDimension(TableNo: Integer; No: Code[20]; var ICSyncSetup2: Record "ITOS IC Sync Setup")
    var
        myInt: Integer;
        DefaultDim: Record "Default Dimension";
        ICSyncSetup: Record "ITOS IC Sync Setup";
        ICSyncLog: Record "ITOS IC Sync Entries";
    begin
        ICSyncSetup.CopyFilters(ICSyncSetup2);
        if ICSyncSetup.FindFirst() then
            repeat
                DefaultDim.SetCurrentKey("Table ID", "No.", "Dimension Code");
                DefaultDim.SetRange("Table ID", TableNo);
                DefaultDim.SetRange("No.", No);
                if DefaultDim.FindFirst() then
                    repeat
                        Clear(ICSyncLog);
                        ICSyncLog.Init();
                        ICSyncLog."ITOS Table No." := Database::"Default Dimension";
                        ICSyncLog."ITOS Primary Key 1" := StrSubstNo('%1', DefaultDim."Table ID");
                        ICSyncLog."ITOS Primary Key 2" := StrSubstNo('%1', DefaultDim."No.");
                        ICSyncLog."ITOS Primary Key 3" := DefaultDim."Dimension Code";
                        ICSyncLog."ITOS Company Name" := ICSyncSetup."ITOS Company Name";
                        ICSyncLog."ITOS Status" := ICSyncLog."ITOS Status"::Created;
                        ICSyncLog.Insert(true);
                    until DefaultDim.Next() = 0;

            until ICSyncSetup.Next() = 0;
    end;


    procedure CreateAssemblyItem(ItemRec: Record Item; var ICSyncSetup2: Record "ITOS IC Sync Setup")
    var
        BomComponentRec: Record "BOM Component";
        BomItem: Record Item;
        ICSyncSetup: Record "ITOS IC Sync Setup";
    begin
        ICSyncSetup.CopyFilters(ICSyncSetup);
        BomComponentRec.SetCurrentKey("Parent Item No.", "Line No.");
        BomComponentRec.SetRange("Parent Item No.", ItemRec."No.");
        if BomComponentRec.FindFirst() then
            repeat
                if BomComponentRec.Type = BomComponentRec.Type::Item then
                    if BomItem.Get(BomComponentRec."No.") then begin
                        CreateSyncLogForItem(BomItem, ICSyncSetup);
                        CreateSyncLogForBomCompoent(BomComponentRec, ICSyncSetup);
                    end;
            until BomComponentRec.Next() = 0;
    end;

    procedure CreateSyncLogForBomCompoent(BomComponentRec: Record "BOM Component"; var ICSyncSetup2: Record "ITOS IC Sync Setup")
    var
        ICSyncLog: Record "ITOS IC Sync Entries";
        ICSyncSetup: Record "ITOS IC Sync Setup";
    begin
        ICSyncSetup.CopyFilters(ICSyncSetup2);
        if ICSyncSetup.FindFirst() then
            repeat
                Clear(ICSyncLog);
                ICSyncLog.Init();
                ICSyncLog."ITOS Table No." := Database::"BOM Component";
                ICSyncLog."ITOS Primary Key 1" := BomComponentRec."Parent Item No.";
                ICSyncLog."ITOS Primary Key 2" := StrSubstNo('%1', BomComponentRec."Line No.");
                ICSyncLog."ITOS Company Name" := ICSyncSetup."ITOS Company Name";
                ICSyncLog."ITOS Status" := ICSyncLog."ITOS Status"::Created;
                ICSyncLog.Insert(true);
            until ICSyncSetup.Next() = 0;
    end;

    procedure CreateSyncLogForItemUOM(ItemUOM: Record "Item Unit of Measure"; var ICSyncSetup2: Record "ITOS IC Sync Setup")
    var
        ICSyncLog: Record "ITOS IC Sync Entries";
        ICSyncSetup: Record "ITOS IC Sync Setup";
    begin
        ICSyncSetup.CopyFilters(ICSyncSetup2);
        if ICSyncSetup.FindFirst() then
            repeat
                Clear(ICSyncLog);
                ICSyncLog.Init();
                ICSyncLog."ITOS Table No." := Database::"Item Unit of Measure";
                ICSyncLog."ITOS Primary Key 1" := ItemUOM."Item No.";
                ICSyncLog."ITOS Primary Key 2" := ItemUOM.Code;
                ICSyncLog."ITOS Company Name" := ICSyncSetup."ITOS Company Name";
                ICSyncLog."ITOS Status" := ICSyncLog."ITOS Status"::Created;
                ICSyncLog.Insert(true);
            until ICSyncSetup.Next() = 0;
    end;

    local procedure ProcessICSyncEntries()
    var
        ICSyncLog: Record "ITOS IC Sync Entries";
        ICSyncLog2: Record "ITOS IC Sync Entries";
        ItemLocal: Record Item;
        CustomerLocal: Record Customer;
        VendorLocal: Record Vendor;
        Item: Record Item;
        Customer: Record Customer;
        Vendor: Record Vendor;
        ItemUOMLocal: Record "Item Unit of Measure";
        ItemUOM: Record "Item Unit of Measure";
        BomComponet: Record "BOM Component";
        BomCompoentLocal: Record "BOM Component";
        DimensionLocal: Record Dimension;
        Dimension: Record Dimension;
        DimValueLocal: Record "Dimension Value";
        DimValue: Record "Dimension Value";
        DefaultDim: Record "Default Dimension";
        DefaultDimLocal: Record "Default Dimension";
    begin
        ICSyncLog.SetCurrentKey("ITOS Entry No.");
        ICSyncLog.SetRange("ITOS Status", ICSyncLog."ITOS Status"::Created);
        if ICSyncLog.FindFirst() then
            repeat
                if ICSyncLog2.Get(ICSyncLog."ITOS Entry No.") then;

                case ICSyncLog."ITOS Table No." of
                    Database::Item:
                        begin
                            if ItemLocal.Get(ICSyncLog."ITOS Primary Key 1") then begin
                                item.ChangeCompany(ICSyncLog."ITOS Company Name");
                                if not Item.Get(ItemLocal."No.") then begin
                                    Item.Init();
                                    Item.TransferFields(ItemLocal);
                                    Item.Insert();
                                end;
                            end;
                        end;
                    Database::"Item Unit of Measure":
                        begin
                            ItemUOMLocal.Get(ICSyncLog."ITOS Primary Key 1", ICSyncLog."ITOS Primary Key 2");
                            ItemUOM.ChangeCompany(ICSyncLog."ITOS Company Name");
                            if not ItemUOM.Get(ItemUOMLocal."Item No.", ItemUOMLocal.Code) then begin
                                ItemUOM.Init();
                                ItemUOM.TransferFields(ItemUOMLocal);
                                ItemUOM.Insert();
                            end;

                        end;
                    Database::"BOM Component":
                        begin
                            if BomCompoentLocal.Get(ICSyncLog."ITOS Primary Key 1", ICSyncLog."ITOS Primary Key 2") then begin
                                BomComponet.ChangeCompany(ICSyncLog."ITOS Company Name");
                                if not BomComponet.Get(BomCompoentLocal."Parent Item No.", BomCompoentLocal."Line No.") then begin
                                    BomComponet.Init();
                                    BomComponet.TransferFields(BomCompoentLocal);
                                    BomComponet.Insert();
                                end;

                            end;
                        end;
                    Database::Customer:
                        begin
                            if CustomerLocal.Get(ICSyncLog."ITOS Primary Key 1") then begin
                                Customer.ChangeCompany(ICSyncLog."ITOS Company Name");
                                if not Customer.Get(CustomerLocal."No.") then begin
                                    Customer.Init();
                                    Customer.TransferFields(CustomerLocal);
                                    Customer.Insert();
                                end;
                            end;

                        end;
                    Database::Vendor:
                        begin
                            if VendorLocal.Get(ICSyncLog."ITOS Primary Key 1") then begin
                                Vendor.ChangeCompany(ICSyncLog."ITOS Company Name");
                                if not Vendor.Get(VendorLocal."No.") then begin
                                    Vendor.Init();
                                    Vendor.TransferFields(VendorLocal);
                                    Vendor.Insert();
                                end;
                            end;
                        end;
                    Database::Dimension:
                        begin
                            if DimensionLocal.Get(ICSyncLog."ITOS Primary Key 1") then begin
                                Dimension.ChangeCompany(ICSyncLog."ITOS Company Name");
                                if not Dimension.Get(DimensionLocal.Code) then begin
                                    Dimension.Init();
                                    Dimension.TransferFields(DimensionLocal);
                                    Dimension.Insert();
                                end;
                            end;
                        end;
                    Database::"Dimension Value":
                        begin
                            DimValueLocal.Get(ICSyncLog."ITOS Primary Key 1", ICSyncLog."ITOS Primary Key 2");
                            DimValue.ChangeCompany(ICSyncLog."ITOS Company Name");
                            if not DimValue.Get(DimValueLocal."Dimension Code", DimValueLocal.Code) then begin
                                DimValue.Init();
                                DimValue.TransferFields(DimValueLocal);
                                DimValue.Insert();
                            end;

                        end;
                    Database::"Default Dimension":
                        begin
                            DefaultDimLocal.Get(ICSyncLog."ITOS Primary Key 1", ICSyncLog."ITOS Primary Key 2", ICSyncLog."ITOS Primary Key 3");
                            DefaultDim.ChangeCompany(ICSyncLog."ITOS Company Name");
                            if not DefaultDim.Get(DefaultDimLocal."Table ID", DefaultDimLocal."No.", DefaultDimLocal."Dimension Code") then begin
                                DefaultDim.Init();
                                DefaultDim.TransferFields(DefaultDimLocal);
                                DefaultDim.Insert();
                            end;
                        end;
                end;

                ICSyncLog2."ITOS Status" := ICSyncLog2."ITOS Status"::"Sync Completed";
                ICSyncLog2.Modify(false);

            until ICSyncLog.Next() = 0;
    end;


    [TryFunction]
    procedure SendCutomerToIC(CustRec: Record Customer)
    var
        ICSyncSetup: Record "ITOS IC Sync Setup";
        ICSetup: Record "IC Setup";
    begin
        if ICSetup.Get() then
            ICSetup.TestField("ITOS Sync Customer to IC", true);

        Clear(ICSyncSetup);
        ICSyncSetup.Reset();
        ICSyncSetup.SetCurrentKey("ITOS Table No.", "ITOS Primary Key 1", "ITOS Primary Key 2", "ITOS Primary Key 3", "ITOS Company Name");
        ICSyncSetup.SetRange("ITOS Table No.", Database::Customer);
        ICSyncSetup.SetRange("ITOS Primary Key 1", CustRec."No.");
        ICSyncSetup.SetRange("ITOS Status", ICSyncSetup."ITOS Status"::Active);
        if not ICSyncSetup.FindFirst() then
            Error('Setup not found');

        CreateSyncLogForCustomer(CustRec, ICSyncSetup);
        ProcessICSyncEntries();
    end;

    procedure CreateSyncLogForCustomer(CustRec: Record Customer; var ICSyncSetup: Record "ITOS IC Sync Setup")
    var
        ICSyncLog: Record "ITOS IC Sync Entries";
    // ContactRec: Record Contact;
    begin
        if ICSyncSetup.FindFirst() then
            repeat
                Clear(ICSyncLog);
                ICSyncLog.Init();
                ICSyncLog."ITOS Table No." := Database::Customer;
                ICSyncLog."ITOS Primary Key 1" := CustRec."No.";
                ICSyncLog."ITOS Company Name" := ICSyncSetup."ITOS Company Name";
                ICSyncLog."ITOS Status" := ICSyncLog."ITOS Status"::Created;
                ICSyncLog.Insert(true);
            //if ItemUOM.Get(ItemRec."No.", ItemRec."Base Unit of Measure") then
            //  CreateSyncLogForItemUOM(ItemUOM, ICSyncSetup);
            // Clear(ContactRec);
            // ContactRec.SetCurrentKey("No.");
            // ContactRec.SetRange("No.", CustRec."No.");
            // if ContactRec.FindFirst() then
            //     repeat
            //         CreateSyncLogForCustomerContact(ContactRec, ICSyncSetup);
            //     until ContactRec.Next() = 0;

            until ICSyncSetup.Next() = 0;
    end;

    [TryFunction]
    procedure SendVendorToIC(VendorRec: Record Vendor)
    var
        ICSyncSetup: Record "ITOS IC Sync Setup";
        ICSetup: Record "IC Setup";
    begin
        if ICSetup.Get() then
            ICSetup.TestField("ITOS Sync-Vendor to IC", true);

        Clear(ICSyncSetup);
        ICSyncSetup.Reset();
        ICSyncSetup.SetCurrentKey("ITOS Table No.", "ITOS Primary Key 1", "ITOS Primary Key 2", "ITOS Primary Key 3", "ITOS Company Name");
        ICSyncSetup.SetRange("ITOS Table No.", Database::Vendor);
        ICSyncSetup.SetRange("ITOS Primary Key 1", VendorRec."No.");
        ICSyncSetup.SetRange("ITOS Status", ICSyncSetup."ITOS Status"::Active);
        if not ICSyncSetup.FindFirst() then
            Error('Setup not found');

        CreateSyncLogForVendor(VendorRec, ICSyncSetup);
        ProcessICSyncEntries();
    end;

    procedure CreateSyncLogForVendor(VendorRec: Record Vendor; var ICSyncSetup: Record "ITOS IC Sync Setup")
    var
        ICSyncLog: Record "ITOS IC Sync Entries";
    begin
        if ICSyncSetup.FindFirst() then
            repeat
                Clear(ICSyncLog);
                ICSyncLog.Init();
                ICSyncLog."ITOS Table No." := Database::Vendor;
                ICSyncLog."ITOS Primary Key 1" := VendorRec."No.";
                ICSyncLog."ITOS Company Name" := ICSyncSetup."ITOS Company Name";
                ICSyncLog."ITOS Status" := ICSyncLog."ITOS Status"::Created;
                ICSyncLog.Insert(true);
            //if ItemUOM.Get(ItemRec."No.", ItemRec."Base Unit of Measure") then
            //  CreateSyncLogForItemUOM(ItemUOM, ICSyncSetup);
            until ICSyncSetup.Next() = 0;
    end;

    [TryFunction]
    procedure SendDimensionToIC(DimensionRec: Record Dimension)
    var
        ICSyncSetup: Record "ITOS IC Sync Setup";
        ICSetup: Record "IC Setup";
    begin
        if ICSetup.Get() then
            ICSetup.TestField("ITOS Sync-Dimension to IC", true);

        Clear(ICSyncSetup);
        ICSyncSetup.Reset();
        ICSyncSetup.SetCurrentKey("ITOS Table No.", "ITOS Primary Key 1", "ITOS Primary Key 2", "ITOS Primary Key 3", "ITOS Company Name");
        ICSyncSetup.SetRange("ITOS Table No.", Database::Dimension);
        ICSyncSetup.SetRange("ITOS Primary Key 1", DimensionRec.Code);
        ICSyncSetup.SetRange("ITOS Status", ICSyncSetup."ITOS Status"::Active);
        if not ICSyncSetup.FindFirst() then
            Error('Setup not found');

        CreateSyncLogForDimension(DimensionRec, ICSyncSetup);
        ProcessICSyncEntries();
    end;

    procedure CreateSyncLogForDimension(DimensionRec: Record Dimension; var ICSyncSetup: Record "ITOS IC Sync Setup")
    var
        ICSyncLog: Record "ITOS IC Sync Entries";
        DimValue: Record "Dimension Value";
    begin
        if ICSyncSetup.FindFirst() then
            repeat
                Clear(ICSyncLog);
                ICSyncLog.Init();
                ICSyncLog."ITOS Table No." := Database::Dimension;
                ICSyncLog."ITOS Primary Key 1" := DimensionRec.Code;
                ICSyncLog."ITOS Company Name" := ICSyncSetup."ITOS Company Name";
                ICSyncLog."ITOS Status" := ICSyncLog."ITOS Status"::Created;
                ICSyncLog.Insert(true);
                //if ItemUOM.Get(ItemRec."No.", ItemRec."Base Unit of Measure") then
                //  CreateSyncLogForItemUOM(ItemUOM, ICSyncSetup);
                Clear(DimValue);
                DimValue.SetCurrentKey("Dimension Code", Code);
                DimValue.SetRange("Dimension Code", DimensionRec.Code);
                if DimValue.FindFirst() then
                    repeat
                        CreateSyncLogForDimensionValue(DimValue, ICSyncSetup);
                    until DimValue.Next() = 0;
            until ICSyncSetup.Next() = 0;
    end;

    procedure CreateSyncLogForDimensionValue(DimValue: Record "Dimension Value"; var ICSyncSetup: Record "ITOS IC Sync Setup")
    var
        ICSyncLog: Record "ITOS IC Sync Entries";
    begin
        if ICSyncSetup.FindFirst() then
            repeat
                Clear(ICSyncLog);
                ICSyncLog.Init();
                ICSyncLog."ITOS Table No." := Database::"Dimension Value";
                ICSyncLog."ITOS Primary Key 1" := DimValue."Dimension Code";
                ICSyncLog."ITOS Primary Key 2" := DimValue."Code";
                ICSyncLog."ITOS Company Name" := ICSyncSetup."ITOS Company Name";
                ICSyncLog."ITOS Status" := ICSyncLog."ITOS Status"::Created;
                ICSyncLog.Insert(true);
            until ICSyncSetup.Next() = 0;
    end;

    //Company.SETFILTER(Name,'<>%1',COMPANYNAME);
    // IF Company.FINDFIRST THEN
    //     REPEAT
    //      IF Company."Create Item" THEN BEGIN
    //      ItemCategory.CHANGECOMPANY(Company.Name);
    //      IF NOT ItemCategory.GET(ItemRec."Item Category Code") THEN BEGIN 
    //        ItemCategoryLocal.GET(ItemRec."Item Category Code");
    //        ItemCategory.INIT;
    //        ItemCategory.TRANSFERFIELDS(ItemCategoryLocal);
    //        ItemCategory.INSERT;
    //      END;
    //      ProductGroup.CHANGECOMPANY(Company.Name);
    //      IF NOT ProductGroup.GET(ItemRec."Item Category Code",ItemRec."Product Group Code") THEN BEGIN
    //        ProductGroupLocal.GET(ItemRec."Item Category Code",ItemRec."Product Group Code");
    //        ProductGroup.INIT;
    //        ProductGroup.TRANSFERFIELDS(ProductGroupLocal);
    //        ProductGroup.INSERT;
    //      END; 
    //      ItemAttributeValueMappingLocal.SETRANGE("Table ID",5722);
    //      ItemAttributeValueMappingLocal.SETRANGE("No.",ItemRec."Item Category Code");
    //      IF ItemAttributeValueMappingLocal.FINDFIRST THEN 
    //        BEGIN
    //          REPEAT
    //           ItemAttributeValueMapping.CHANGECOMPANY(Company.Name);
    //           ItemAttributeValueMapping.SETRANGE("Table ID",5722);
    //           ItemAttributeValueMapping.SETRANGE("No.",ItemRec."Item Category Code");
    //           ItemAttributeValueMapping.SETRANGE("Item Attribute ID",ItemAttributeValueMappingLocal."Item Attribute ID");
    //           IF NOT ItemAttributeValueMapping.FINDFIRST THEN 
    //             BEGIN
    //               ItemAttributeValueMapping.INIT;
    //               ItemAttributeValueMapping.TRANSFERFIELDS(ItemAttributeValueMappingLocal);
    //               ItemAttributeValueMapping.INSERT;
    //             END;
    //          UNTIL ItemAttributeValueMappingLocal.NEXT = 0; 
    //        END;
    //      //ATOS
    //      ItemAttributeValueMappingLocal.SETRANGE("Table ID",27);
    //      ItemAttributeValueMappingLocal.SETRANGE("No.",ItemRec."No.");
    //      IF ItemAttributeValueMappingLocal.FINDFIRST THEN 
    //        BEGIN
    //          REPEAT
    //           ItemAttributeValueMapping.CHANGECOMPANY(Company.Name);
    //           ItemAttributeValueMapping.SETRANGE("Table ID",27);
    //           ItemAttributeValueMapping.SETRANGE("No.",ItemRec."No.");
    //           ItemAttributeValueMapping.SETRANGE("Item Attribute ID",ItemAttributeValueMappingLocal."Item Attribute ID");
    //           IF NOT ItemAttributeValueMapping.FINDFIRST THEN 
    //             BEGIN
    //               ItemAttributeValueMapping.INIT;
    //               ItemAttributeValueMapping.TRANSFERFIELDS(ItemAttributeValueMappingLocal);
    //               ItemAttributeValueMapping.INSERT;

    //               CLEAR(ItemAttValueLocal);
    //               ItemAttValueLocal.RESET;
    //               ItemAttValueLocal.SETRANGE("Attribute ID",ItemAttributeValueMappingLocal."Item Attribute ID");
    //               ItemAttValueLocal.SETRANGE(ID,ItemAttributeValueMappingLocal."Item Attribute Value ID");
    //               IF ItemAttValueLocal.FINDFIRST THEN BEGIN
    //                 ItemAttValue.CHANGECOMPANY(Company.Name);
    //                 ItemAttValue.INIT;
    //                 ItemAttValue.TRANSFERFIELDS(ItemAttValueLocal);
    //                 IF ItemAttValue.INSERT THEN;
    //               END;
    //             END;
    //          UNTIL ItemAttributeValueMappingLocal.NEXT = 0; 
    //        END;
    //      //ATOS
    //      UnitofMeasure.CHANGECOMPANY(Company.Name);
    //      IF NOT(UnitofMeasure.GET(ItemRec."Base Unit of Measure")) THEN 
    //        BEGIN
    //          UnitofMeasureLocal.GET(ItemRec."Base Unit of Measure");
    //          UnitofMeasure.INIT;
    //          UnitofMeasure.TRANSFERFIELDS(UnitofMeasureLocal);
    //          UnitofMeasure.INSERT; 
    //        END;
    //      ItemUnitofMeasure.CHANGECOMPANY(Company.Name);
    //      IF NOT(ItemUnitofMeasure.GET(ItemRec."No.",ItemRec."Base Unit of Measure")) THEN 
    //        BEGIN
    //          ItemUnitofMeasureLocal.GET(ItemRec."No.",ItemRec."Base Unit of Measure");
    //          ItemUnitofMeasure.INIT;
    //          ItemUnitofMeasure.TRANSFERFIELDS(ItemUnitofMeasureLocal);
    //          ItemUnitofMeasure.INSERT; 
    //        END;
    //      CompanyItem.CHANGECOMPANY(Company.Name);
    //      //MESSAGE(Company.Name);
    //      //  MESSAGE(ParaItem);
    //      IF NOT CompanyItem.GET(ItemRec."No.") THEN BEGIN
    //        CompanyItem.INIT;
    //        CompanyItem.TRANSFERFIELDS(ItemRec);
    //        CompanyItem.INSERT;    
    //       END;
    //     END;
    //  UNTIL Company.NEXT = 0;

    var
        Text0001: Label 'Inter-company sync setup is not defined for %1';


}