" @keywords newscontent news content sap.m tile tilecontent
" @summary This control is used to display the news content text and subheader in a tile.
CLASS z2ui5_cl_smpc_app_063 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_063 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `The news content is pressed.` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `TileContent`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `content`
                )->tag( `NewsContent`
                    )->a( n = `contentText` v = `SAP Unveils Powerful New Player Comparison Tool Exclusively on NFL.com`
                    )->a( n = `subheader`   v = `August 21, 2013`
                    )->a( n = `press`       v = client->follow_up_action( val   = client->cs_event-control_global
                                                                          t_arg = temp1 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
