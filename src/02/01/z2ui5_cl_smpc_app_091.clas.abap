" @keywords timepicker time picker sap.m opened another hidden input title vbox label button
" @summary This example demonstrates the Time Picker that is opened by another control.
CLASS z2ui5_cl_smpc_app_091 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_091 IMPLEMENTATION.

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

        )->tag( `Title`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->a( n = `text`  v = `Open Time Picker by Another Control`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->tag( `Label`
                )->a( n = `text` v = `By Button with text`
            )->tag( `Button`
                )->a( n = `ariaHasPopup` v = `Dialog`
                )->a( n = `text`         v = `Open Time Picker`
                )->a( n = `press`        v = client->follow_up_action( val = client->cs_event-control_by_id t_arg = VALUE #( ( `HiddenTP` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

        )->end(
        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->tag( `Label`
                )->a( n = `text` v = `By Button with icon`
            )->tag( `Button`
                )->a( n = `ariaHasPopup` v = `Dialog`
                )->a( n = `tooltip`      v = `Open Time Picker`
                )->a( n = `icon`         v = `sap-icon://time-entry-request`
                )->a( n = `press`        v = client->follow_up_action( val = client->cs_event-control_by_id t_arg = VALUE #( ( `HiddenTP` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

        )->end(
        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->tag( `Label`
                )->a( n = `text` v = `By Link`
            )->tag( `Link`
                )->a( n = `ariaHasPopup` v = `Dialog`
                )->a( n = `text`         v = `Open Time Picker`
                )->a( n = `press`        v = client->follow_up_action( val = client->cs_event-control_by_id t_arg = VALUE #( ( `HiddenTP` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

        )->end(

        )->tag( `TimePicker`
            )->a( n = `id`        v = `HiddenTP`
            )->a( n = `hideInput` v = `true`
            )->a( n = `change`    v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Time selected: {0}` ) ( `${$parameters>/value}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
