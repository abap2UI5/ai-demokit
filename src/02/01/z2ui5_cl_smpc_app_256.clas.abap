" @keywords daterangeselection date range selection sap.m daterangeselectionhidden title vbox label button link
" @summary This example shows Date Range Selection which is opened by another control.
CLASS z2ui5_cl_smpc_app_256 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_256 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `HiddenDRS` INTO TABLE temp1.
    INSERT `openBy` INTO TABLE temp1.
    INSERT `$event.oSource.sId` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `HiddenDRS` INTO TABLE temp2.
    INSERT `openBy` INTO TABLE temp2.
    INSERT `$event.oSource.sId` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `HiddenDRS` INTO TABLE temp3.
    INSERT `openBy` INTO TABLE temp3.
    INSERT `$event.oSource.sId` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `Date range selected: {0}` INTO TABLE temp4.
    INSERT `${$parameters>/value}` INTO TABLE temp4.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->tag( `Title`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->a( n = `text`  v = `Open Date Range Selection by Another Control`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->tag( `Label`
                )->a( n = `text` v = `By Button with text`
            )->tag( `Button`
                )->a( n = `ariaHasPopup` v = `Dialog`
                )->a( n = `text`         v = `Open Date Range Selection`
                )->a( n = `press`        v = client->follow_up_action( val = client->cs_event-control_by_id t_arg = temp1 )

        )->end(
        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->tag( `Label`
                )->a( n = `text` v = `By Button with icon`
            )->tag( `Button`
                )->a( n = `ariaHasPopup` v = `Dialog`
                )->a( n = `tooltip`      v = `Open Date Range Selection`
                )->a( n = `icon`         v = `sap-icon://appointment-2`
                )->a( n = `press`        v = client->follow_up_action( val = client->cs_event-control_by_id t_arg = temp2 )

        )->end(
        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->tag( `Label`
                )->a( n = `text` v = `By Link`
            )->tag( `Link`
                )->a( n = `ariaHasPopup` v = `Dialog`
                )->a( n = `text`         v = `Open Date Range Selection`
                )->a( n = `press`        v = client->follow_up_action( val = client->cs_event-control_by_id t_arg = temp3 )

        )->end(
        )->tag( `DateRangeSelection`
            )->a( n = `id`        v = `HiddenDRS`
            )->a( n = `hideInput` v = `true`
            )->a( n = `change`    v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp4 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
