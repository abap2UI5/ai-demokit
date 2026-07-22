CLASS z2ui5_cl_ai_app_068 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_068 IMPLEMENTATION.

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

            )->leaf( `Text`
                )->a( n = `text`  v = `Slider without text field`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `Slider`
                )->a( n = `value` v = `30`
                )->a( n = `width` v = `90%`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `Slider`
                )->a( n = `value` v = `27`
                )->a( n = `width` v = `10em`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `Slider`
                )->a( n = `value` v = `40`
                )->a( n = `width` v = `15em`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `Slider`
                )->a( n = `value` v = `9`
                )->a( n = `width` v = `77%`
                )->a( n = `min`   v = `0`
                )->a( n = `max`   v = `10`
                )->a( n = `class` v = `sapUiMediumMarginBottom`

            )->leaf( `Text`
                )->a( n = `text`  v = `Slider whose value cannot be changed`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `Slider`
                )->a( n = `value`   v = `5`
                )->a( n = `width`   v = `66%`
                )->a( n = `min`     v = `0`
                )->a( n = `max`     v = `50`
                )->a( n = `enabled` v = `false`
                )->a( n = `class`   v = `sapUiMediumMarginBottom`

            )->leaf( `Text`
                )->a( n = `text`  v = `Slider with text field`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `Slider`
                )->a( n = `value`               v = `50`
                )->a( n = `width`               v = `100%`
                )->a( n = `min`                 v = `0`
                )->a( n = `max`                 v = `100`
                )->a( n = `showAdvancedTooltip` v = `true`
                )->a( n = `showHandleTooltip`   v = `false`
                )->a( n = `class`               v = `sapUiMediumMarginBottom`

            )->leaf( `Text`
                )->a( n = `text`  v = `Slider with input field`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `Slider`
                )->a( n = `value`               v = `30`
                )->a( n = `width`               v = `100%`
                )->a( n = `min`                 v = `0`
                )->a( n = `max`                 v = `200`
                )->a( n = `showAdvancedTooltip` v = `true`
                )->a( n = `showHandleTooltip`   v = `false`
                )->a( n = `inputsAsTooltips`    v = `true`
                )->a( n = `class`               v = `sapUiMediumMarginBottom`

            )->leaf( `Text`
                )->a( n = `text`  v = `Slider with tickmarks`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `Slider`
                )->a( n = `enableTickmarks` v = `true`
                )->a( n = `min`             v = `0`
                )->a( n = `max`             v = `10`
                )->a( n = `class`           v = `sapUiMediumMarginBottom`
                )->a( n = `width`           v = `100%`
            )->leaf( `Slider`
                )->a( n = `enableTickmarks` v = `true`
                )->a( n = `class`           v = `sapUiMediumMarginBottom`
                )->a( n = `width`           v = `100%`

            )->leaf( `Text`
                )->a( n = `text`  v = `Slider with tickmarks and step '5'`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `Slider`
                )->a( n = `enableTickmarks` v = `true`
                )->a( n = `min`             v = `-100`
                )->a( n = `max`             v = `100`
                )->a( n = `step`            v = `5`
                )->a( n = `class`           v = `sapUiLargeMarginBottom`
                )->a( n = `width`           v = `100%`

            )->leaf( `Text`
                )->a( n = `text`  v = `Slider with tickmarks and labels`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->open( `Slider`
                )->a( n = `min`             v = `0`
                )->a( n = `max`             v = `30`
                )->a( n = `enableTickmarks` v = `true`
                )->a( n = `class`           v = `sapUiSmallMarginBottom`
                )->a( n = `width`           v = `100%`

                )->leaf( `ResponsiveScale`
                    )->a( n = `tickmarksBetweenLabels` v = `3`

            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
