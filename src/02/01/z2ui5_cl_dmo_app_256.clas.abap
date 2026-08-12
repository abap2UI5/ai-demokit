CLASS z2ui5_cl_dmo_app_256 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_256 IMPLEMENTATION.

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

        )->leaf( `Title`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->a( n = `text`  v = `Open Date Range Selection by Another Control`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->leaf( `Label`
                )->a( n = `text` v = `By Button with text`
            )->leaf( `Button`
                )->a( n = `ariaHasPopup` v = `Dialog`
                )->a( n = `text`         v = `Open Date Range Selection`
                )->a( n = `press`        v = client->follow_up_action( val = client->cs_event-control_by_id t_arg = VALUE #( ( `HiddenDRS` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

        )->shut(
        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->leaf( `Label`
                )->a( n = `text` v = `By Button with icon`
            )->leaf( `Button`
                )->a( n = `ariaHasPopup` v = `Dialog`
                )->a( n = `tooltip`      v = `Open Date Range Selection`
                )->a( n = `icon`         v = `sap-icon://appointment-2`
                )->a( n = `press`        v = client->follow_up_action( val = client->cs_event-control_by_id t_arg = VALUE #( ( `HiddenDRS` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

        )->shut(
        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->leaf( `Label`
                )->a( n = `text` v = `By Link`
            )->leaf( `Link`
                )->a( n = `ariaHasPopup` v = `Dialog`
                )->a( n = `text`         v = `Open Date Range Selection`
                )->a( n = `press`        v = client->follow_up_action( val = client->cs_event-control_by_id t_arg = VALUE #( ( `HiddenDRS` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

        )->shut(
        )->leaf( `DateRangeSelection`
            )->a( n = `id`        v = `HiddenDRS`
            )->a( n = `hideInput` v = `true`
            )->a( n = `change`    v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Date range selected: {0}` ) ( `${$parameters>/value}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
