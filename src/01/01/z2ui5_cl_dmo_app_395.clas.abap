CLASS z2ui5_cl_dmo_app_395 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_395 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `OverflowToolbar`
            )->a( n = `design` v = `Transparent`
            )->a( n = `height` v = `3rem`

            )->leaf( `Title`
                )->a( n = `text` v = `Title Only`

        )->shut(

        )->open( `OverflowToolbar`
            )->a( n = `design` v = `Transparent`
            )->a( n = `height` v = `3rem`

            )->leaf( `Title`
                )->a( n = `text` v = `Title and Actions`
            )->leaf( `ToolbarSpacer`
            )->leaf( `Button`
                )->a( n = `icon` v = `sap-icon://group-2`
            )->leaf( `Button`
                )->a( n = `icon` v = `sap-icon://action-settings` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
