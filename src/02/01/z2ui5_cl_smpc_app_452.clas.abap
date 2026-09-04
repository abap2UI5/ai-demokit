" @keywords messagestrip message strip sap.m custommessagestripdesign verticallayout panel horizontallayout label select item
" @summary Demonstrates MessageStrips with different colorSet and colorScheme properties.
CLASS z2ui5_cl_smpc_app_452 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA color_set TYPE string VALUE `1`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_452 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " _updateDesignForColorSet writes ColorSet1 / ColorSet2 onto all ten strips -
    " one expression binding over the two-way bound Select key does the same
    DATA color_set_expr TYPE string.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    color_set_expr = |\{= ${ client->_bind( color_set ) } === '1' ? 'ColorSet1' : 'ColorSet2' \}|.

    
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `id`    v = `oVerticalContent`
            )->a( n = `width` v = `100%`

            )->ele( n = `content` ns = `l`

                )->ele( `Panel`
                    )->a( n = `headerText` v = `ColorSet Configuration`
                    )->a( n = `class`      v = `sapUiMediumMarginBottom`

                    )->ele( `content`
                        )->ele( n = `HorizontalLayout` ns = `l`

                            )->ele( n = `content` ns = `l`
                                )->tag( `Label`
                                    )->a( n = `text`  v = `ColorSet:`
                                    )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginTop`
                                )->ele( `Select`
                                    )->a( n = `id`          v = `colorSetSelect`
                                    )->a( n = `class`       v = `sapUiMediumMarginEnd`
                                    )->a( n = `selectedKey` v = client->_bind( color_set )

                                    )->ele( `items`
                                        )->tag( n = `Item` ns = `core`
                                            )->a( n = `key`  v = `1`
                                            )->a( n = `text` v = `ColorSet 1`
                                        )->tag( n = `Item` ns = `core`
                                            )->a( n = `key`  v = `2`
                                            )->a( n = `text` v = `ColorSet 2`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `Panel`
                    )->a( n = `headerText` v = `All Color Schemes (1-10)`
                    )->a( n = `class`      v = `sapUiMediumMarginBottom`

                    )->ele( `content`
                        )->tag( `MessageStrip`
                            )->a( n = `id`              v = `messageStrip_scheme1`
                            )->a( n = `text`            v = `Color Scheme 1 - Information message`
                            )->a( n = `type`            v = `Information`
                            )->a( n = `colorSet`        v = color_set_expr
                            )->a( n = `colorScheme`     v = `1`
                            )->a( n = `showIcon`        v = `true`
                            )->a( n = `showCloseButton` v = `true`
                            )->a( n = `class`           v = `sapUiSmallMarginBottom`
                        )->tag( `MessageStrip`
                            )->a( n = `id`              v = `messageStrip_scheme2`
                            )->a( n = `text`            v = `Color Scheme 2 - Success message`
                            )->a( n = `type`            v = `Success`
                            )->a( n = `colorSet`        v = color_set_expr
                            )->a( n = `colorScheme`     v = `2`
                            )->a( n = `showIcon`        v = `true`
                            )->a( n = `showCloseButton` v = `true`
                            )->a( n = `class`           v = `sapUiSmallMarginBottom`
                        )->tag( `MessageStrip`
                            )->a( n = `id`              v = `messageStrip_scheme3`
                            )->a( n = `text`            v = `Color Scheme 3 - Warning message`
                            )->a( n = `type`            v = `Warning`
                            )->a( n = `colorSet`        v = color_set_expr
                            )->a( n = `colorScheme`     v = `3`
                            )->a( n = `showIcon`        v = `true`
                            )->a( n = `showCloseButton` v = `true`
                            )->a( n = `class`           v = `sapUiSmallMarginBottom`
                        )->tag( `MessageStrip`
                            )->a( n = `id`              v = `messageStrip_scheme4`
                            )->a( n = `text`            v = `Color Scheme 4 - Error message`
                            )->a( n = `type`            v = `Error`
                            )->a( n = `colorSet`        v = color_set_expr
                            )->a( n = `colorScheme`     v = `4`
                            )->a( n = `showIcon`        v = `true`
                            )->a( n = `showCloseButton` v = `true`
                            )->a( n = `class`           v = `sapUiSmallMarginBottom`
                        )->tag( `MessageStrip`
                            )->a( n = `id`              v = `messageStrip_scheme5`
                            )->a( n = `text`            v = `Color Scheme 5 - Information message`
                            )->a( n = `type`            v = `Information`
                            )->a( n = `colorSet`        v = color_set_expr
                            )->a( n = `colorScheme`     v = `5`
                            )->a( n = `showIcon`        v = `true`
                            )->a( n = `showCloseButton` v = `true`
                            )->a( n = `class`           v = `sapUiSmallMarginBottom`
                        )->tag( `MessageStrip`
                            )->a( n = `id`              v = `messageStrip_scheme6`
                            )->a( n = `text`            v = `Color Scheme 6 - Success message`
                            )->a( n = `type`            v = `Success`
                            )->a( n = `colorSet`        v = color_set_expr
                            )->a( n = `colorScheme`     v = `6`
                            )->a( n = `showIcon`        v = `true`
                            )->a( n = `showCloseButton` v = `true`
                            )->a( n = `class`           v = `sapUiSmallMarginBottom`
                        )->tag( `MessageStrip`
                            )->a( n = `id`              v = `messageStrip_scheme7`
                            )->a( n = `text`            v = `Color Scheme 7 - Warning message`
                            )->a( n = `type`            v = `Warning`
                            )->a( n = `colorSet`        v = color_set_expr
                            )->a( n = `colorScheme`     v = `7`
                            )->a( n = `showIcon`        v = `true`
                            )->a( n = `showCloseButton` v = `true`
                            )->a( n = `class`           v = `sapUiSmallMarginBottom`
                        )->tag( `MessageStrip`
                            )->a( n = `id`              v = `messageStrip_scheme8`
                            )->a( n = `text`            v = `Color Scheme 8 - Error message`
                            )->a( n = `type`            v = `Error`
                            )->a( n = `colorSet`        v = color_set_expr
                            )->a( n = `colorScheme`     v = `8`
                            )->a( n = `showIcon`        v = `true`
                            )->a( n = `showCloseButton` v = `true`
                            )->a( n = `class`           v = `sapUiSmallMarginBottom`
                        )->tag( `MessageStrip`
                            )->a( n = `id`              v = `messageStrip_scheme9`
                            )->a( n = `text`            v = `Color Scheme 9 - Information message`
                            )->a( n = `type`            v = `Information`
                            )->a( n = `colorSet`        v = color_set_expr
                            )->a( n = `colorScheme`     v = `9`
                            )->a( n = `showIcon`        v = `true`
                            )->a( n = `showCloseButton` v = `true`
                            )->a( n = `class`           v = `sapUiSmallMarginBottom`
                        )->tag( `MessageStrip`
                            )->a( n = `id`              v = `messageStrip_scheme10`
                            )->a( n = `text`            v = `Color Scheme 10 - Success message`
                            )->a( n = `type`            v = `Success`
                            )->a( n = `colorSet`        v = color_set_expr
                            )->a( n = `colorScheme`     v = `10`
                            )->a( n = `showIcon`        v = `true`
                            )->a( n = `showCloseButton` v = `true`
                            )->a( n = `class`           v = `sapUiSmallMarginBottom`
                             ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
