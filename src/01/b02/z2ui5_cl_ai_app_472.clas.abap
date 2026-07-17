CLASS z2ui5_cl_ai_app_472 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA rs1_value  TYPE i.
    DATA rs1_value2 TYPE i.
    DATA rs2_value  TYPE i.
    DATA rs2_value2 TYPE i.
    DATA rs3_value  TYPE i.
    DATA rs3_value2 TYPE i.
    DATA rs4_value  TYPE i.
    DATA rs4_value2 TYPE i.
    DATA rs5_value  TYPE i.
    DATA rs5_value2 TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_472 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    rs1_value  = 0.
    rs1_value2 = 100.
    rs2_value  = -50.
    rs2_value2 = 50.
    rs3_value  = 20.
    rs3_value2 = 80.
    rs4_value  = -500.
    rs4_value2 = 500.
    rs5_value  = 0.
    rs5_value2 = 500.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->leaf( `Text`
                )->a( n = `text`  v = `RangeSlider with text fields`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `RangeSlider`
                )->a( n = `showAdvancedTooltip` v = `true`
                )->a( n = `value`               v = client->_bind_edit( rs1_value )
                )->a( n = `value2`              v = client->_bind_edit( rs1_value2 )
                )->a( n = `min`                 v = `0`
                )->a( n = `max`                 v = `100`
                )->a( n = `width`               v = `80%`
                )->a( n = `class`               v = `sapUiMediumMarginBottom`
            )->leaf( `RangeSlider`
                )->a( n = `showAdvancedTooltip` v = `true`
                )->a( n = `value`               v = client->_bind_edit( rs2_value )
                )->a( n = `value2`              v = client->_bind_edit( rs2_value2 )
                )->a( n = `min`                 v = `-50`
                )->a( n = `max`                 v = `50`
                )->a( n = `width`               v = `10rem`
                )->a( n = `class`               v = `sapUiMediumMarginBottom`
            )->leaf( `RangeSlider`
                )->a( n = `showAdvancedTooltip` v = `true`
                )->a( n = `value`               v = client->_bind_edit( rs3_value )
                )->a( n = `value2`              v = client->_bind_edit( rs3_value2 )
                )->a( n = `min`                 v = `0`
                )->a( n = `max`                 v = `100`
                )->a( n = `width`               v = `10rem`
                )->a( n = `class`               v = `sapUiMediumMarginBottom`
            )->leaf( `RangeSlider`
                )->a( n = `showAdvancedTooltip` v = `true`
                )->a( n = `value`               v = client->_bind_edit( rs4_value )
                )->a( n = `value2`              v = client->_bind_edit( rs4_value2 )
                )->a( n = `min`                 v = `-1000`
                )->a( n = `max`                 v = `1000`
                )->a( n = `width`               v = `100%`
                )->a( n = `class`               v = `sapUiMediumMarginBottom`
            )->leaf( `RangeSlider`
                )->a( n = `showAdvancedTooltip` v = `true`
                )->a( n = `value`               v = client->_bind_edit( rs5_value )
                )->a( n = `value2`              v = client->_bind_edit( rs5_value2 )
                )->a( n = `min`                 v = `0`
                )->a( n = `max`                 v = `500`
                )->a( n = `width`               v = `100%`
                )->a( n = `class`               v = `sapUiLargeMarginBottom`
            )->leaf( `Text`
                )->a( n = `text`  v = `RangeSlider with inputs`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `RangeSlider`
                )->a( n = `showAdvancedTooltip` v = `true`
                )->a( n = `value`               v = `0`
                )->a( n = `value2`              v = `100`
                )->a( n = `min`                 v = `0`
                )->a( n = `max`                 v = `500`
                )->a( n = `width`               v = `100%`
                )->a( n = `showHandleTooltip`   v = `false`
                )->a( n = `inputsAsTooltips`    v = `true`
                )->a( n = `class`               v = `sapUiLargeMarginBottom`
            )->leaf( `Text`
                )->a( n = `text`  v = `RangeSlider with tickmarks`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `RangeSlider`
                )->a( n = `showAdvancedTooltip` v = `true`
                )->a( n = `enableTickmarks`     v = `true`
                )->a( n = `value`               v = `0`
                )->a( n = `value2`              v = `10`
                )->a( n = `min`                 v = `0`
                )->a( n = `max`                 v = `10`
                )->a( n = `class`               v = `sapUiMediumMarginBottom`
            )->leaf( `RangeSlider`
                )->a( n = `showAdvancedTooltip` v = `true`
                )->a( n = `enableTickmarks`     v = `true`
                )->a( n = `class`               v = `sapUiMediumMarginBottom`
            )->leaf( `Text`
                )->a( n = `text`  v = `RangeSlider with tickmarks and step '5'`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `RangeSlider`
                )->a( n = `showAdvancedTooltip` v = `true`
                )->a( n = `enableTickmarks`     v = `true`
                )->a( n = `min`                 v = `-100`
                )->a( n = `max`                 v = `100`
                )->a( n = `step`                v = `5`
                )->a( n = `class`               v = `sapUiLargeMarginBottom`
            )->leaf( `Text`
                )->a( n = `text`  v = `RangeSlider with tickmarks and labels`
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->open( `RangeSlider`
                )->a( n = `showAdvancedTooltip` v = `true`
                )->a( n = `min`                 v = `0`
                )->a( n = `max`                 v = `30`
                )->a( n = `value`               v = `5`
                )->a( n = `value2`              v = `20`
                )->a( n = `enableTickmarks`     v = `true`
                )->a( n = `class`               v = `sapUiSmallMarginBottom`

                )->leaf( `ResponsiveScale`
                    )->a( n = `tickmarksBetweenLabels` v = `3` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
