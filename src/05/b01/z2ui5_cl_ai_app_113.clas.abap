CLASS z2ui5_cl_ai_app_113 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_113 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:tnt` v = `sap.tnt`
        )->a( n = `height`    v = `100%`

        )->open( `ScrollContainer`
            )->a( n = `vertical` v = `true`
            )->a( n = `height`   v = `100%`

            )->open( `FlexBox`
                )->a( n = `direction` v = `Column`
                )->a( n = `alignItems` v = `Start`
                )->a( n = `class`     v = `sapUiMediumMargin`

            )->open( `FlexBox`
                )->a( n = `direction`  v = `Row`
                )->a( n = `alignItems` v = `Start`
                )->a( n = `class`      v = `sapUiTinyMarginBottom`

                )->leaf( `Text`
                    )->a( n = `text`  v = `Color Scheme 1`
                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                )->leaf( n = `InfoLabel` ns = `tnt`
                    )->a( n = `id`   v = `il1`
                    )->a( n = `text` v = `2`
                    )->a( n = `renderMode` v = `Narrow`
                    )->a( n = `colorScheme` v = `1`

            )->shut(
            )->open( `FlexBox`
                )->a( n = `direction`  v = `Row`
                )->a( n = `alignItems` v = `Start`
                )->a( n = `class`      v = `sapUiTinyMarginBottom`

                )->leaf( `Text`
                    )->a( n = `text`  v = `Color Scheme 2`
                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                )->leaf( n = `InfoLabel` ns = `tnt`
                    )->a( n = `id`   v = `il2`
                    )->a( n = `text` v = `5`
                    )->a( n = `renderMode` v = `Narrow`
                    )->a( n = `colorScheme` v = `2`

            )->shut(
            )->open( `FlexBox`
                )->a( n = `direction`  v = `Row`
                )->a( n = `alignItems` v = `Start`
                )->a( n = `class`      v = `sapUiTinyMarginBottom`

                )->leaf( `Text`
                    )->a( n = `text`  v = `Color Scheme 3`
                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                )->leaf( n = `InfoLabel` ns = `tnt`
                    )->a( n = `id`   v = `il3`
                    )->a( n = `text` v = `12.5`
                    )->a( n = `renderMode` v = `Narrow`
                    )->a( n = `colorScheme` v = `3`

            )->shut(
            )->open( `FlexBox`
                )->a( n = `direction`  v = `Row`
                )->a( n = `alignItems` v = `Start`
                )->a( n = `class`      v = `sapUiTinyMarginBottom`

                )->leaf( `Text`
                    )->a( n = `text`  v = `Color Scheme 4`
                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                )->leaf( n = `InfoLabel` ns = `tnt`
                    )->a( n = `id`   v = `il4`
                    )->a( n = `text` v = `2k`
                    )->a( n = `renderMode` v = `Narrow`
                    )->a( n = `colorScheme` v = `4`

            )->shut(
            )->open( `FlexBox`
                )->a( n = `direction`  v = `Row`
                )->a( n = `alignItems` v = `Start`
                )->a( n = `class`      v = `sapUiTinyMarginBottom`

                )->leaf( `Text`
                    )->a( n = `text`  v = `Color Scheme 5`
                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                )->leaf( n = `InfoLabel` ns = `tnt`
                    )->a( n = `id`   v = `il5`
                    )->a( n = `text` v = `text info label`
                    )->a( n = `renderMode` v = `Loose`
                    )->a( n = `colorScheme` v = `5`

            )->shut(
            )->open( `FlexBox`
                )->a( n = `direction`  v = `Row`
                )->a( n = `alignItems` v = `Start`
                )->a( n = `class`      v = `sapUiTinyMarginBottom`

                )->leaf( `Text`
                    )->a( n = `text`  v = `Color Scheme 6`
                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                )->leaf( n = `InfoLabel` ns = `tnt`
                    )->a( n = `id`   v = `il6`
                    )->a( n = `text` v = `just a long info label`
                    )->a( n = `colorScheme` v = `6`
                    )->a( n = `width` v = `140px`

            )->shut(
            )->open( `FlexBox`
                )->a( n = `direction`  v = `Row`
                )->a( n = `alignItems` v = `Start`
                )->a( n = `class`      v = `sapUiTinyMarginBottom`

                )->leaf( `Text`
                    )->a( n = `text`  v = `Color Scheme 7`
                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                )->leaf( n = `InfoLabel` ns = `tnt`
                    )->a( n = `id`   v = `il7`
                    )->a( n = `text` v = `label shorter than width`
                    )->a( n = `colorScheme` v = `7`
                    )->a( n = `width` v = `250px`

            )->shut(
            )->open( `FlexBox`
                )->a( n = `direction`  v = `Row`
                )->a( n = `alignItems` v = `Start`
                )->a( n = `class`      v = `sapUiTinyMarginBottom`

                )->leaf( `Text`
                    )->a( n = `text`  v = `Color Scheme 8`
                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                )->leaf( n = `InfoLabel` ns = `tnt`
                    )->a( n = `id`   v = `il8`
                    )->a( n = `text` v = `with icon`
                    )->a( n = `colorScheme` v = `8`
                    )->a( n = `icon` v = `sap-icon://home-share`

            )->shut(
            )->open( `FlexBox`
                )->a( n = `direction`  v = `Row`
                )->a( n = `alignItems` v = `Start`
                )->a( n = `class`      v = `sapUiTinyMarginBottom`

                )->leaf( `Text`
                    )->a( n = `text`  v = `Color Scheme 9`
                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                )->leaf( n = `InfoLabel` ns = `tnt`
                    )->a( n = `id`   v = `il9`
                    )->a( n = `text` v = `in warehouse`
                    )->a( n = `colorScheme` v = `9`

            )->shut(
            )->open( `FlexBox`
                )->a( n = `direction`  v = `Row`
                )->a( n = `alignItems` v = `Start`
                )->a( n = `class`      v = `sapUiTinyMarginBottom`

                )->leaf( `Text`
                    )->a( n = `text`  v = `Color Scheme 10`
                    )->a( n = `class` v = `sapUiTinyMarginEnd`
                )->leaf( n = `InfoLabel` ns = `tnt`
                    )->a( n = `id`   v = `il10`
                    )->a( n = `text` v = `display only in form`
                    )->a( n = `colorScheme` v = `1`
                    )->a( n = `displayOnly` v = `true`

            )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
