"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.RangeSlider - RangeSlider
"! https://sdk.openui5.org/entity/sap.m.RangeSlider/sample/sap.m.sample.RangeSlider
CLASS z2ui5_cl_api_app_472 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA rs1_value  TYPE string.
    DATA rs1_value2 TYPE string.
    DATA rs2_value  TYPE string.
    DATA rs2_value2 TYPE string.
    DATA rs3_value  TYPE string.
    DATA rs3_value2 TYPE string.
    DATA rs4_value  TYPE string.
    DATA rs4_value2 TYPE string.
    DATA rs5_value  TYPE string.
    DATA rs5_value2 TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS data_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_472 IMPLEMENTATION.

  " NOTES (generation):
  " - IMPROVISED: the sample binds the composite RangeSlider "range" property
  "   (an array [low, high] - range="{/RS1}" / range="0,100"). abap2UI5 binds
  "   scalar ABAP fields, so each range is expressed as the equivalent value /
  "   value2 properties the control keeps in sync - identical rendering.

  METHOD data_init.

    rs1_value  = `0`.
    rs1_value2 = `100`.
    rs2_value  = `-50`.
    rs2_value2 = `50`.
    rs3_value  = `20`.
    rs3_value2 = `80`.
    rs4_value  = `-500`.
    rs4_value2 = `500`.
    rs5_value  = `0`.
    rs5_value2 = `500`.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->attr( n = `xmlns`     v = `sap.m`
        )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->attr( n = `xmlns:l`   v = `sap.ui.layout`

        )->open( n = `VerticalLayout` ns = `l`
            )->attr( n = `class` v = `sapUiContentPadding`
            )->attr( n = `width` v = `100%`

            )->leaf( `Text`
                )->attr( n = `text`  v = `RangeSlider with text fields`
                )->attr( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `RangeSlider`
                )->attr( n = `showAdvancedTooltip` v = `true`
                )->attr( n = `value`               v = client->_bind_edit( rs1_value )
                )->attr( n = `value2`              v = client->_bind_edit( rs1_value2 )
                )->attr( n = `min`                 v = `0`
                )->attr( n = `max`                 v = `100`
                )->attr( n = `width`               v = `80%`
                )->attr( n = `class`               v = `sapUiMediumMarginBottom`
            )->leaf( `RangeSlider`
                )->attr( n = `showAdvancedTooltip` v = `true`
                )->attr( n = `value`               v = client->_bind_edit( rs2_value )
                )->attr( n = `value2`              v = client->_bind_edit( rs2_value2 )
                )->attr( n = `min`                 v = `-50`
                )->attr( n = `max`                 v = `50`
                )->attr( n = `width`               v = `10rem`
                )->attr( n = `class`               v = `sapUiMediumMarginBottom`
            )->leaf( `RangeSlider`
                )->attr( n = `showAdvancedTooltip` v = `true`
                )->attr( n = `value`               v = client->_bind_edit( rs3_value )
                )->attr( n = `value2`              v = client->_bind_edit( rs3_value2 )
                )->attr( n = `min`                 v = `0`
                )->attr( n = `max`                 v = `100`
                )->attr( n = `width`               v = `10rem`
                )->attr( n = `class`               v = `sapUiMediumMarginBottom`
            )->leaf( `RangeSlider`
                )->attr( n = `showAdvancedTooltip` v = `true`
                )->attr( n = `value`               v = client->_bind_edit( rs4_value )
                )->attr( n = `value2`              v = client->_bind_edit( rs4_value2 )
                )->attr( n = `min`                 v = `-1000`
                )->attr( n = `max`                 v = `1000`
                )->attr( n = `width`               v = `100%`
                )->attr( n = `class`               v = `sapUiMediumMarginBottom`
            )->leaf( `RangeSlider`
                )->attr( n = `showAdvancedTooltip` v = `true`
                )->attr( n = `value`               v = client->_bind_edit( rs5_value )
                )->attr( n = `value2`              v = client->_bind_edit( rs5_value2 )
                )->attr( n = `min`                 v = `0`
                )->attr( n = `max`                 v = `500`
                )->attr( n = `width`               v = `100%`
                )->attr( n = `class`               v = `sapUiLargeMarginBottom`
            )->leaf( `Text`
                )->attr( n = `text`  v = `RangeSlider with inputs`
                )->attr( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `RangeSlider`
                )->attr( n = `showAdvancedTooltip` v = `true`
                )->attr( n = `value`               v = `0`
                )->attr( n = `value2`              v = `100`
                )->attr( n = `min`                 v = `0`
                )->attr( n = `max`                 v = `500`
                )->attr( n = `width`               v = `100%`
                )->attr( n = `showHandleTooltip`   v = `false`
                )->attr( n = `inputsAsTooltips`    v = `true`
                )->attr( n = `class`               v = `sapUiLargeMarginBottom`
            )->leaf( `Text`
                )->attr( n = `text`  v = `RangeSlider with tickmarks`
                )->attr( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `RangeSlider`
                )->attr( n = `showAdvancedTooltip` v = `true`
                )->attr( n = `enableTickmarks`     v = `true`
                )->attr( n = `value`               v = `0`
                )->attr( n = `value2`              v = `10`
                )->attr( n = `min`                 v = `0`
                )->attr( n = `max`                 v = `10`
                )->attr( n = `class`               v = `sapUiMediumMarginBottom`
            )->leaf( `RangeSlider`
                )->attr( n = `showAdvancedTooltip` v = `true`
                )->attr( n = `enableTickmarks`     v = `true`
                )->attr( n = `class`               v = `sapUiMediumMarginBottom`
            )->leaf( `Text`
                )->attr( n = `text`  v = `RangeSlider with tickmarks and step '5'`
                )->attr( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `RangeSlider`
                )->attr( n = `showAdvancedTooltip` v = `true`
                )->attr( n = `enableTickmarks`     v = `true`
                )->attr( n = `min`                 v = `-100`
                )->attr( n = `max`                 v = `100`
                )->attr( n = `step`                v = `5`
                )->attr( n = `class`               v = `sapUiLargeMarginBottom`
            )->leaf( `Text`
                )->attr( n = `text`  v = `RangeSlider with tickmarks and labels`
                )->attr( n = `class` v = `sapUiSmallMarginBottom`

            )->open( `RangeSlider`
                )->attr( n = `showAdvancedTooltip` v = `true`
                )->attr( n = `min`                 v = `0`
                )->attr( n = `max`                 v = `30`
                )->attr( n = `value`               v = `5`
                )->attr( n = `value2`              v = `20`
                )->attr( n = `enableTickmarks`     v = `true`
                )->attr( n = `class`               v = `sapUiSmallMarginBottom`

                )->leaf( `ResponsiveScale`
                    )->attr( n = `tickmarksBetweenLabels` v = `3` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      data_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
