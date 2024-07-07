pageextension 57105 "ITOS Dimensions" extends Dimensions
{
    actions
    {
        addlast(processing)
        {
            action(ITOSSyncSetup)
            {
                Caption = 'IC Sync Setup';
                ApplicationArea = All;
                RunObject = page "ITOS Inter-Company Sync Setup";
                RunPageLink = "ITOS Primary Key 1" = field(Code), "ITOS Table No." = const(Database::Dimension);
            }
        }
        addlast("F&unctions")
        {
            action("ITOSSendToIC")
            {
                ApplicationArea = Intercompany;
                Caption = 'Send IC Dimension';
                Image = IntercompanyOrder;

                trigger OnAction()
                var
                    ICSyncMgt: Codeunit "ITOS IC Sync Mgt.";
                begin
                    If not ICSyncMgt.SendDimensionToIC(Rec) then
                        Message(GetLastErrorText());
                end;
            }
        }


    }
}

