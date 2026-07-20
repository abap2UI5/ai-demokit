CLASS z2ui5_cl_ai_app_001 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_001 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `List`
            )->a( n = `headerText` v = `Actions`

            )->leaf( `ActionListItem`
                )->a( n = `text` v = `Reject`
            )->leaf( `ActionListItem`
                )->a( n = `text` v = `Accept`
            )->leaf( `ActionListItem`
                )->a( n = `text` v = `Email`
            )->leaf( `ActionListItem`
                )->a( n = `text` v = `Forward`
            )->leaf( `ActionListItem`
                )->a( n = `text` v = `Delete` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
