CLASS z2ui5_cl_smpc_app_371 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_371 IMPLEMENTATION.

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

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( n = `content` ns = `l`
                )->leaf( `TextArea`
                    )->a( n = `valueState`  v = `Warning`
                    )->a( n = `placeholder` v = `ValueState : Warning`
                    )->a( n = `width`       v = `100%`
                )->leaf( `TextArea`
                    )->a( n = `valueState`  v = `Error`
                    )->a( n = `placeholder` v = `ValueState : Error`
                    )->a( n = `width`       v = `100%`
                )->leaf( `TextArea`
                    )->a( n = `valueState`  v = `Success`
                    )->a( n = `placeholder` v = `ValueState : Success`
                    )->a( n = `width`       v = `100%`
                )->leaf( `TextArea`
                    )->a( n = `valueState`  v = `Information`
                    )->a( n = `placeholder` v = `ValueState : Information`
                    )->a( n = `width`       v = `100%` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
