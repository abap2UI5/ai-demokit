CLASS z2ui5_cl_ai_app_091 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_091 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).


    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->leaf( `Title`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->a( n = `text`  v = `Open Time Picker by Another Control`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->leaf( `Label`
                )->a( n = `text` v = `By Button with text`
            )->leaf( `Button`
                )->a( n = `ariaHasPopup` v = `Dialog`
                )->a( n = `text`         v = `Open Time Picker`
                )->a( n = `press`        v = client->_event_client( val = client->cs_event-control_by_id t_arg = VALUE #( ( `HiddenTP` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

        )->shut(
        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->leaf( `Label`
                )->a( n = `text` v = `By Button with icon`
            )->leaf( `Button`
                )->a( n = `ariaHasPopup` v = `Dialog`
                )->a( n = `tooltip`      v = `Open Time Picker`
                )->a( n = `icon`         v = `sap-icon://time-entry-request`
                )->a( n = `press`        v = client->_event_client( val = client->cs_event-control_by_id t_arg = VALUE #( ( `HiddenTP` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

        )->shut(
        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->leaf( `Label`
                )->a( n = `text` v = `By Link`
            )->leaf( `Link`
                )->a( n = `ariaHasPopup` v = `Dialog`
                )->a( n = `text`         v = `Open Time Picker`
                )->a( n = `press`        v = client->_event_client( val = client->cs_event-control_by_id t_arg = VALUE #( ( `HiddenTP` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

        )->shut(

        )->leaf( `TimePicker`
            )->a( n = `id`        v = `HiddenTP`
            )->a( n = `hideInput` v = `true`
            )->a( n = `change`    v = client->_event( val = `CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `CHANGE`.
        client->message_toast_display( |Time selected: { client->get_event_arg( ) }| ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
