page 50100 "My Prompt Dialog"
{
    Caption = 'Crete a draft';
    PageType = PromptDialog;
    Extensible = false;
    PromptMode = Prompt;
    IsPreview = true;


    layout
    {
        area(content)
        {
            field("Your Input"; YourInput)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OK)
            {
                ApplicationArea = All;
                Caption = 'OK';
                trigger OnAction()
                begin
                    // Add your logic here
                    Message('You entered: %1', YourInput);
                end;
            }

            action(Cancel)
            {
                ApplicationArea = All;
                Caption = 'Cancel';
                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        YourInput: Text[100];

    trigger OnInit()
    begin
        CurrPage.PromptMode := PromptMode::Generate;
    end;
}