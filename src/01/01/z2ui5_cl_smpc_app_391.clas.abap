CLASS z2ui5_cl_smpc_app_391 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_391 IMPLEMENTATION.

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

        )->ele( `List`
            )->a( n = `headerText` v = `Input List Item`

            )->ele( `InputListItem`
                )->a( n = `label` v = `Battery Saving`

                )->ele( `SegmentedButton`
                    )->a( n = `selectedKey` v = `SBYes`

                    )->ele( `items`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `text` v = `High`
                            )->a( n = `key`  v = `SBYes`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `text` v = `Low`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `text` v = `Off` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
