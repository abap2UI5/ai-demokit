" @keywords actionlistitem action list item sap.m
" @summary Use the Action List Item to trigger an action directly from a list
CLASS z2ui5_cl_smpc_app_001 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_001 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `List`
            )->a( n = `headerText` v = `Actions`

            )->tag( `ActionListItem`
                )->a( n = `text` v = `Reject`
            )->tag( `ActionListItem`
                )->a( n = `text` v = `Accept`
            )->tag( `ActionListItem`
                )->a( n = `text` v = `Email`
            )->tag( `ActionListItem`
                )->a( n = `text` v = `Forward`
            )->tag( `ActionListItem`
                )->a( n = `text` v = `Delete` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
