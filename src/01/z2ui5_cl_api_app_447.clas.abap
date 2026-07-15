"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.MessageBox - MessageBoxInitialFocus
"! https://sdk.openui5.org/entity/sap.m.MessageBox/sample/sap.m.sample.MessageBoxInitialFocus
"! NOTES (generation):
"! - IMPROVISED: the sample opens a sap.m.MessageBox from its controller; there
"!   is no such control in the view. It is mapped to abap2UI5's
"!   client->message_box_display, driven by two buttons wired to events.
"! - 1.71: the buttons' ariaHasPopup="Dialog" is dropped (available only since
"!   UI5 1.84).
"! - 1.71: the MessageBox emphasizedAction / dependentOn options of the original
"!   are dropped (available only since UI5 1.75 / 1.124).
CLASS z2ui5_cl_api_app_447 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_447 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    " ariaHasPopup="Dialog" on both buttons is omitted (available only since UI5 1.84)
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->leaf( `Text`
                )->a( n = `text` v = `Different approaches to set Initial focus`

            )->leaf( `Button`
                )->a( n = `text`  v = `Action`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `INITIAL_FOCUS_ON_ACTION` )
                )->a( n = `width` v = `250px`

            )->leaf( `Button`
                )->a( n = `text`  v = `Custom action`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `INITIAL_FOCUS_ON_CUSTOM_ACTION` )
                )->a( n = `width` v = `250px` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `INITIAL_FOCUS_ON_ACTION`.

        " the original emphasizedAction option (since UI5 1.75) is omitted here
        client->message_box_display(
          text         = |Initial button focus is set by attribute \n initialFocus: sap.m.MessageBox.Action.CANCEL|
          type         = `warning`
          icon         = `WARNING`
          title        = `Focus on a Button`
          actions      = VALUE #( ( `OK` ) ( `CANCEL` ) )
          initialfocus = `CANCEL`
          styleclass   = `sapUiResponsivePadding--header sapUiResponsivePadding--content sapUiResponsivePadding--footer` ).

      WHEN `INITIAL_FOCUS_ON_CUSTOM_ACTION`.

        " the original dependentOn option (since UI5 1.124) is omitted here
        client->message_box_display(
          text         = |Initial button focus is set by attribute \n initialFocus: "Custom button" \n Note: The name is not case sensitive|
          type         = `show`
          icon         = `WARNING`
          title        = `Focus on a Custom Action`
          actions      = VALUE #( ( `YES` ) ( `NO` ) ( `Custom Action` ) )
          initialfocus = `Custom Action`
          styleclass   = `sapUiResponsivePadding--header sapUiResponsivePadding--content sapUiResponsivePadding--footer` ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
