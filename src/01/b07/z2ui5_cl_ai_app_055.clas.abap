CLASS z2ui5_cl_ai_app_055 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_055 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `IconTabHeader`
            )->a( n = `mode` v = `Inline`

            )->open( `items`
                )->leaf( `IconTabFilter`
                    )->a( n = `key`  v = `info`
                    )->a( n = `text` v = `Info`
                )->leaf( `IconTabFilter`
                    )->a( n = `key`   v = `attachments`
                    )->a( n = `text`  v = `Attachments`
                    )->a( n = `count` v = `3`
                )->leaf( `IconTabFilter`
                    )->a( n = `key`   v = `notes`
                    )->a( n = `text`  v = `Notes`
                    )->a( n = `count` v = `12`
                )->leaf( `IconTabFilter`
                    )->a( n = `key`  v = `people`
                    )->a( n = `text` v = `People` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
