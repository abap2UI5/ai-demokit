" @keywords overflowtoolbar overflow toolbar sap.m titletoolbar title toolbarspacer button
" @summary The sap.m.Title control can be used to place a title inside an OverflowToolbar/Toolbar.
CLASS z2ui5_cl_smpc_app_395 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_395 IMPLEMENTATION.

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
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `OverflowToolbar`
            )->a( n = `design` v = `Transparent`
            )->a( n = `height` v = `3rem`

            )->tag( `Title`
                )->a( n = `text` v = `Title Only`

        )->end(

        )->ele( `OverflowToolbar`
            )->a( n = `design` v = `Transparent`
            )->a( n = `height` v = `3rem`

            )->tag( `Title`
                )->a( n = `text` v = `Title and Actions`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `icon` v = `sap-icon://group-2`
            )->tag( `Button`
                )->a( n = `icon` v = `sap-icon://action-settings` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
