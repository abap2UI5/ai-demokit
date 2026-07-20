CLASS z2ui5_cl_ai_app_549 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_549 IMPLEMENTATION.

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
        )->a( n = `xmlns:l`   v = `sap.ui.layout`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( n = `Grid` ns = `l`
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
                )->a( n = `hSpacing`    v = `0`
                )->a( n = `vSpacing`    v = `0`
                )->a( n = `defaultSpan` v = `L4 M6 S12`
                )->a( n = `width`       v = `100%`

                )->open( `FlexBox`
                    )->a( n = `class`          v = `sapUiTinyMarginBottom`
                    )->a( n = `direction`      v = `Column`
                    )->a( n = `fitContainer`   v = `true`
                    )->a( n = `alignItems`     v = `Start`
                    )->a( n = `justifyContent` v = `Start`

                    )->leaf( `Text`
                        )->a( n = `text`  v = `Generic Tag - KPI`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                    )->open( `GenericTag`
                        )->a( n = `text`   v = `Project Cost`
                        )->a( n = `design` v = `StatusIconHidden`
                        )->a( n = `status` v = `Error`
                        )->a( n = `class`  v = `sapUiSmallMarginBottom`

                        )->leaf( `ObjectNumber`
                            )->a( n = `state`      v = `Error`
                            )->a( n = `emphasized` v = `false`
                            )->a( n = `number`     v = `3.5M`
                            )->a( n = `unit`       v = `EUR`

                    )->shut(
                    )->open( `GenericTag`
                        )->a( n = `text`   v = `Project Cost`
                        )->a( n = `design` v = `StatusIconHidden`
                        )->a( n = `status` v = `Warning`
                        )->a( n = `class`  v = `sapUiSmallMarginBottom`

                        )->leaf( `ObjectNumber`
                            )->a( n = `state`      v = `Warning`
                            )->a( n = `emphasized` v = `false`
                            )->a( n = `number`     v = `2.4M`
                            )->a( n = `unit`       v = `EUR`

                    )->shut(
                    )->open( `GenericTag`
                        )->a( n = `text`   v = `Project Cost`
                        )->a( n = `design` v = `StatusIconHidden`
                        )->a( n = `status` v = `Success`
                        )->a( n = `class`  v = `sapUiSmallMarginBottom`

                        )->leaf( `ObjectNumber`
                            )->a( n = `state`      v = `Success`
                            )->a( n = `emphasized` v = `false`
                            )->a( n = `number`     v = `1.6M`
                            )->a( n = `unit`       v = `EUR`

                    )->shut(
                    )->open( `GenericTag`
                        )->a( n = `text`   v = `PC`
                        )->a( n = `design` v = `StatusIconHidden`
                        )->a( n = `status` v = `Error`
                        )->a( n = `class`  v = `sapUiSmallMarginBottom`

                        )->leaf( `ObjectNumber`
                            )->a( n = `state`      v = `Error`
                            )->a( n = `emphasized` v = `false`
                            )->a( n = `number`     v = `35`
                            )->a( n = `unit`       v = `%`

                    )->shut(
                    )->open( `GenericTag`
                        )->a( n = `text`   v = `PC`
                        )->a( n = `design` v = `StatusIconHidden`
                        )->a( n = `status` v = `Warning`
                        )->a( n = `class`  v = `sapUiSmallMarginBottom`

                        )->leaf( `ObjectNumber`
                            )->a( n = `state`      v = `Warning`
                            )->a( n = `emphasized` v = `false`
                            )->a( n = `number`     v = `71`
                            )->a( n = `unit`       v = `%`

                    )->shut(
                    )->open( `GenericTag`
                        )->a( n = `text`   v = `PC`
                        )->a( n = `design` v = `StatusIconHidden`
                        )->a( n = `status` v = `Success`
                        )->a( n = `class`  v = `sapUiSmallMarginBottom`

                        )->leaf( `ObjectNumber`
                            )->a( n = `state`      v = `Success`
                            )->a( n = `emphasized` v = `false`
                            )->a( n = `number`     v = `96`
                            )->a( n = `unit`       v = `%`

                    )->shut(
                )->shut(
                )->open( `FlexBox`
                    )->a( n = `direction`      v = `Column`
                    )->a( n = `fitContainer`   v = `true`
                    )->a( n = `alignItems`     v = `Start`
                    )->a( n = `justifyContent` v = `Start`

                    )->leaf( `Text`
                        )->a( n = `text`  v = `Generic Tag - KPI (error handling)`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                    )->leaf( `GenericTag`
                        )->a( n = `text`       v = `Project Cost`
                        )->a( n = `design`     v = `StatusIconHidden`
                        )->a( n = `status`     v = `Error`
                        )->a( n = `valueState` v = `Error`
                        )->a( n = `class`      v = `sapUiSmallMarginBottom`

                )->shut(
                )->open( `FlexBox`
                    )->a( n = `direction`      v = `Column`
                    )->a( n = `fitContainer`   v = `true`
                    )->a( n = `alignItems`     v = `Start`
                    )->a( n = `justifyContent` v = `Start`

                    )->leaf( `Text`
                        )->a( n = `text`  v = `Generic Tag - Situation`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                    )->leaf( `GenericTag`
                        )->a( n = `text`   v = `Shortage Expected`
                        )->a( n = `status` v = `Warning`
                        )->a( n = `class`  v = `sapUiSmallMarginBottom`
                    )->leaf( `GenericTag`
                        )->a( n = `text`   v = `Material Shortage`
                        )->a( n = `status` v = `Warning`
                        )->a( n = `class`  v = `sapUiSmallMarginBottom`

                )->shut(
                )->open( `FlexBox`
                    )->a( n = `direction`      v = `Column`
                    )->a( n = `fitContainer`   v = `true`
                    )->a( n = `alignItems`     v = `Start`
                    )->a( n = `justifyContent` v = `Start`

                    )->leaf( `Text`
                        )->a( n = `text`  v = `Generic Tag with label`
                        )->a( n = `id`    v = `genericTagLabel`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                    " ariaLabelledBy (since UI5 1.97) kept for the 1:1 port
                    )->open( `GenericTag`
                        )->a( n = `ariaLabelledBy` v = `genericTagLabel`
                        )->a( n = `text`           v = `Project Cost`
                        )->a( n = `design`         v = `StatusIconHidden`
                        )->a( n = `status`         v = `Error`
                        )->a( n = `class`          v = `sapUiSmallMarginBottom`

                        )->leaf( `ObjectNumber`
                            )->a( n = `state`      v = `Error`
                            )->a( n = `emphasized` v = `false`
                            )->a( n = `number`     v = `3.5M`
                            )->a( n = `unit`       v = `EUR` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
