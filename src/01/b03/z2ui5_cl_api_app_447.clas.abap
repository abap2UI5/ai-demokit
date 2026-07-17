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

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_api_xml.
    view = z2ui5_cl_api_xml=>factory( ).

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
                )->a( n = `text`         v = `Action`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `press`        v = client->_event( `INITIAL_FOCUS_ON_ACTION` )
                )->a( n = `width`        v = `250px`
                )->a( n = `ariaHasPopup` v = `Dialog`

            )->leaf( `Button`
                )->a( n = `text`         v = `Custom action`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `press`        v = client->_event( `INITIAL_FOCUS_ON_CUSTOM_ACTION` )
                )->a( n = `width`        v = `250px`
                )->a( n = `ariaHasPopup` v = `Dialog` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE string_table.
        DATA temp3 TYPE string_table.

    CASE client->get( )-event.

      WHEN `INITIAL_FOCUS_ON_ACTION`.

        " the original dependentOn option is omitted - message_box_display does not expose it
        
        CLEAR temp1.
        INSERT `OK` INTO TABLE temp1.
        INSERT `CANCEL` INTO TABLE temp1.
        client->message_box_display(
          text             = |Initial button focus is set by attribute \n initialFocus: sap.m.MessageBox.Action.CANCEL|
          type             = `warning`
          icon             = `WARNING`
          title            = `Focus on a Button`
          actions          = temp1
          emphasizedaction = `OK`
          initialfocus     = `CANCEL`
          styleclass       = `sapUiResponsivePadding--header sapUiResponsivePadding--content sapUiResponsivePadding--footer` ).

      WHEN `INITIAL_FOCUS_ON_CUSTOM_ACTION`.

        " the original dependentOn option is omitted - message_box_display does not expose it
        
        CLEAR temp3.
        INSERT `YES` INTO TABLE temp3.
        INSERT `NO` INTO TABLE temp3.
        INSERT `Custom Action` INTO TABLE temp3.
        client->message_box_display(
          text             = |Initial button focus is set by attribute \n initialFocus: "Custom button" \n Note: The name is not case sensitive|
          type             = `show`
          icon             = `WARNING`
          title            = `Focus on a Custom Action`
          actions          = temp3
          emphasizedaction = `Custom Action`
          initialfocus     = `Custom Action`
          styleclass       = `sapUiResponsivePadding--header sapUiResponsivePadding--content sapUiResponsivePadding--footer` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
