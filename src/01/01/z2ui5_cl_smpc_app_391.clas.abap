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
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `List`
            )->a( n = `headerText` v = `Input List Item`

            )->open( `InputListItem`
                )->a( n = `label` v = `Battery Saving`

                )->open( `SegmentedButton`
                    )->a( n = `selectedKey` v = `SBYes`

                    )->open( `items`
                        )->leaf( `SegmentedButtonItem`
                            )->a( n = `text` v = `High`
                            )->a( n = `key`  v = `SBYes`
                        )->leaf( `SegmentedButtonItem`
                            )->a( n = `text` v = `Low`
                        )->leaf( `SegmentedButtonItem`
                            )->a( n = `text` v = `Off` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
