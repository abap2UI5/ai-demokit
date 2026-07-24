CLASS z2ui5_cl_ai_app_165 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_165 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " The ProductSwitch itself is built in the sample's controller (fnOpen) and
    " shown in a popover; the shipped view is just the trigger button plus two
    " explanatory texts, rebuilt 1:1 here. abap2UI5 has no JS controller, so the
    " button press raises a client toast in place of the controller-built popup.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `height`       v = `100%`

        )->open( n = `VerticalLayout` ns = `layout`
            )->a( n = `class` v = `sapUiContentPadding`

            )->leaf( `Button`
                )->a( n = `id`    v = `pSwitchBtn`
                )->a( n = `icon`  v = `sap-icon://menu`
                )->a( n = `text`  v = `Open Product Switch`
                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Open Product Switch` ) ) )

            )->leaf( `Text`
                )->a( n = `text` v = `Note: Redirection logic should be handled by the app developer.`

            )->leaf( `Text`
                )->a( n = `text` v = `You can use sap.m.URLHelper, as shown in the fnChange method of the ProductSwitchNavigation controller.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
