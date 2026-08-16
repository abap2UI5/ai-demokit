CLASS z2ui5_cl_smpc_app_070 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA pi_a_value   TYPE i.
    DATA pi_a_display TYPE string.
    DATA pi_b_value   TYPE i.
    DATA pi_b_display TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_070 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Text`
                )->a( n = `text`  v = `Regular Mode`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->tag( `ProgressIndicator`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue` v = `30`
                )->a( n = `displayValue` v = `30%`
                )->a( n = `showValue`    v = `true`
                )->a( n = `state`        v = `None`
            )->tag( `ProgressIndicator`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue` v = `50`
                )->a( n = `showValue`    v = `false`
                )->a( n = `state`        v = `Error`
            )->tag( `ProgressIndicator`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue` v = `99`
                )->a( n = `displayValue` v = `0.99GB of 1GB`
                )->a( n = `showValue`    v = `true`
                )->a( n = `state`        v = `Success`
            )->tag( `ProgressIndicator`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue` v = `25`
                )->a( n = `displayValue` v = `25%`
                )->a( n = `showValue`    v = `true`
                )->a( n = `state`        v = `Warning`
            )->tag( `ProgressIndicator`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue` v = `40`
                )->a( n = `displayValue` v = `40%`
                )->a( n = `showValue`    v = `true`
                )->a( n = `state`        v = `Information`

            )->tag( `Text`
                )->a( n = `text`  v = `Information Popover Scenario`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->tag( `ProgressIndicator`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue` v = `40`
                )->a( n = `displayValue` v = `Reduce container width until this text is truncated, then press the ProgressIndicator`
                )->a( n = `showValue`    v = `true`
                )->a( n = `state`        v = `Success`

            )->tag( `Text`
                )->a( n = `text`  v = `Invalid percent values`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->tag( `ProgressIndicator`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue` v = `-20`
                )->a( n = `displayValue` v = `-20`
                )->a( n = `showValue`    v = `true`
                )->a( n = `state`        v = `None`
            )->tag( `ProgressIndicator`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue` v = `120`
                )->a( n = `displayValue` v = `120`
                )->a( n = `showValue`    v = `true`
                )->a( n = `state`        v = `None`

            )->tag( `Text`
                )->a( n = `text`  v = `Display Only Mode`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->tag( `ProgressIndicator`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue` v = `30`
                )->a( n = `displayValue` v = `30%`
                )->a( n = `showValue`    v = `true`
                )->a( n = `state`        v = `None`
                )->a( n = `displayOnly`  v = `true`
            )->tag( `ProgressIndicator`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue` v = `50`
                )->a( n = `showValue`    v = `false`
                )->a( n = `state`        v = `Error`
                )->a( n = `displayOnly`  v = `true`
            )->tag( `ProgressIndicator`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue` v = `99`
                )->a( n = `displayValue` v = `0.99GB of 1GB`
                )->a( n = `showValue`    v = `true`
                )->a( n = `state`        v = `Success`
                )->a( n = `displayOnly`  v = `true`
            )->tag( `ProgressIndicator`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue` v = `25`
                )->a( n = `displayValue` v = `25%`
                )->a( n = `showValue`    v = `true`
                )->a( n = `state`        v = `Warning`
                )->a( n = `displayOnly`  v = `true`
            )->tag( `ProgressIndicator`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue` v = `40`
                )->a( n = `displayValue` v = `40%`
                )->a( n = `showValue`    v = `true`
                )->a( n = `state`        v = `Information`
                )->a( n = `displayOnly`  v = `true`

            )->tag( `Text`
                )->a( n = `text`  v = `Set the ProgressIndicator to 100% with animation`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            " the two interactive ProgressIndicators bind percentValue and displayValue two-way, replacing the original setter calls (see sidecar)
            )->tag( `ProgressIndicator`
                )->a( n = `id`           v = `pi-with-animation`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue` v = client->_bind( pi_a_value )
                )->a( n = `displayValue` v = client->_bind( pi_a_display )
                )->a( n = `state`        v = `Success`
                )->a( n = `displayOnly`  v = `true`
            )->ele( `FlexBox`
                )->tag( `Button`
                    )->a( n = `id`    v = `pi-with-animation-button0`
                    )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->a( n = `text`  v = `Set to 0%`
                    )->a( n = `press` v = client->_event( val = `SET` t_arg = VALUE #( ( `A` ) ( `0` ) ) )
                )->tag( `Button`
                    )->a( n = `id`    v = `pi-with-animation-button100`
                    )->a( n = `text`  v = `Set to 100%`
                    )->a( n = `press` v = client->_event( val = `SET` t_arg = VALUE #( ( `A` ) ( `100` ) ) )

            )->end(

            )->tag( `Text`
                )->a( n = `text`  v = `Set the ProgressIndicator to 100% without animation`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->tag( `ProgressIndicator`
                )->a( n = `id`               v = `pi-without-animation`
                )->a( n = `class`            v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue`     v = client->_bind( pi_b_value )
                )->a( n = `displayValue`     v = client->_bind( pi_b_display )
                )->a( n = `state`            v = `Success`
                )->a( n = `displayOnly`      v = `true`
                " POST-1.71: displayAnimation (since UI5 1.73) kept 1:1
                )->a( n = `displayAnimation` v = `false`
            )->ele( `FlexBox`
                )->tag( `Button`
                    )->a( n = `id`    v = `pi-without-animation-button0`
                    )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->a( n = `text`  v = `Set to 0%`
                    )->a( n = `press` v = client->_event( val = `SET` t_arg = VALUE #( ( `B` ) ( `0` ) ) )
                )->tag( `Button`
                    )->a( n = `id`    v = `pi-without-animation-button100`
                    )->a( n = `text`  v = `Set to 100%`
                    )->a( n = `press` v = client->_event( val = `SET` t_arg = VALUE #( ( `B` ) ( `100` ) ) )

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `SET`.
      " the original's onPIChangeValueButtonPressed - setPercentValue/setDisplayValue on the target PI
      DATA(target) = client->get_event_arg( ).
      DATA(value)  = client->get_event_arg( 2 ).
      IF target = `A`.
        pi_a_value   = value.
        pi_a_display = |{ value }%|.
      ELSE.
        pi_b_value   = value.
        pi_b_display = |{ value }%|.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the two interactive ProgressIndicators start at 0% (the original's displayValue="0%")
    pi_a_display = `0%`.
    pi_b_display = `0%`.

  ENDMETHOD.

ENDCLASS.
