" @keywords icontabheader icon tab header sap.m inline mode icontabfilter
CLASS z2ui5_cl_smpc_app_055 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_055 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `IconTabHeader`
            )->a( n = `mode` v = `Inline`

            )->ele( `items`
                )->tag( `IconTabFilter`
                    )->a( n = `key`  v = `info`
                    )->a( n = `text` v = `Info`
                )->tag( `IconTabFilter`
                    )->a( n = `key`   v = `attachments`
                    )->a( n = `text`  v = `Attachments`
                    )->a( n = `count` v = `3`
                )->tag( `IconTabFilter`
                    )->a( n = `key`   v = `notes`
                    )->a( n = `text`  v = `Notes`
                    )->a( n = `count` v = `12`
                )->tag( `IconTabFilter`
                    )->a( n = `key`  v = `people`
                    )->a( n = `text` v = `People` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
