"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.ObjectStatus - ObjectStatus
"! https://sdk.openui5.org/entity/sap.m.ObjectStatus/sample/sap.m.sample.ObjectStatus
"! NOTES (generation):
"! - 1.71: ObjectStatus states Indication06-Indication20 are newer than UI5 1.71
"!   (added ~1.130). The controls are kept but their state is set to "None", so
"!   the indication colours differ from the original - verify if relevant.
"! - IMPROVISED: the active status press originally opens a controller-built
"!   Dialog; replaced with message_toast_display, since a Dialog is not a 1:1
"!   view element.
CLASS z2ui5_cl_api_app_529 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_529 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `width` v = `100%`

            )->open( n = `BlockLayout` ns = `l`
                )->open( n = `BlockLayoutRow` ns = `l`
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->open( n = `VerticalLayout` ns = `l`
                            )->a( n = `class` v = `sapUiContentPadding`
                            )->a( n = `width` v = `100%`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `ObjectStatus with different value states`
                                )->a( n = `design`   v = `Bold`
                                )->a( n = `wrapping` v = `true`
                                )->a( n = `class`    v = `sapUiSmallMarginTop`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Unknown`
                                )->a( n = `state` v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Currently closed`
                                )->a( n = `icon`  v = `sap-icon://information`
                                )->a( n = `state` v = `Information`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Product Shipped`
                                )->a( n = `icon`  v = `sap-icon://sys-enter-2`
                                )->a( n = `state` v = `Success`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Product Missing`
                                )->a( n = `icon`  v = `sap-icon://alert`
                                )->a( n = `state` v = `Warning`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Product Damaged`
                                )->a( n = `icon`  v = `sap-icon://error`
                                )->a( n = `state` v = `Error`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Product Damaged`
                                )->a( n = `state` v = `Error`
                            " original .handleStatusPressed opens a Dialog; here the press is wired to a message toast
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`  v = `sapUiSmallMarginBottom`
                                )->a( n = `title`  v = `Product status`
                                )->a( n = `text`   v = `Damaged`
                                )->a( n = `active` v = `true`
                                )->a( n = `state`  v = `Error`
                                )->a( n = `press`  v = client->_event( `STATUS_PRESSED` )
                                )->a( n = `icon`   v = `sap-icon://error`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`  v = `sapUiSmallMarginBottom`
                                )->a( n = `title`  v = `Test`
                                )->a( n = `active` v = `true`
                                )->a( n = `state`  v = `Error`
                                )->a( n = `icon`   v = `sap-icon://error`

                        )->shut(
                    )->shut(
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->open( n = `VerticalLayout` ns = `l`
                            )->a( n = `class` v = `sapUiContentPadding`
                            )->a( n = `width` v = `100%`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Inverted ObjectStatus with different value states.`
                                )->a( n = `design`   v = `Bold`
                                )->a( n = `wrapping` v = `true`
                                )->a( n = `class`    v = `sapUiSmallMarginTop`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Unknown`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Currently closed (click)`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `active`   v = `true`
                                )->a( n = `icon`     v = `sap-icon://information`
                                )->a( n = `state`    v = `Information`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Product Shipped`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `icon`     v = `sap-icon://sys-enter-2`
                                )->a( n = `state`    v = `Success`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Product Missing`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `icon`     v = `sap-icon://alert`
                                )->a( n = `state`    v = `Warning`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Product Damaged`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Error`
                                )->a( n = `icon`     v = `sap-icon://error`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Error`
                                )->a( n = `icon`     v = `sap-icon://error`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut(
        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( n = `BlockLayout` ns = `l`
                )->open( n = `BlockLayoutRow` ns = `l`
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->leaf( `Label`
                            )->a( n = `text`     v = `ObjectStatus with different indication states.`
                            )->a( n = `design`   v = `Bold`
                            )->a( n = `wrapping` v = `true`
                            )->a( n = `class`    v = `sapUiSmallMarginBottom`

                        )->open( n = `VerticalLayout` ns = `l`
                            )->a( n = `width` v = `100%`

                            )->leaf( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Indication 1`
                                )->a( n = `state` v = `Indication01`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Indication 2`
                                )->a( n = `state` v = `Indication02`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Indication 3`
                                )->a( n = `state` v = `Indication03`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`  v = `sapUiSmallMarginBottom`
                                )->a( n = `text`   v = `Indication 4 active`
                                )->a( n = `active` v = `true`
                                )->a( n = `state`  v = `Indication04`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Indication 5`
                                )->a( n = `state` v = `Indication05`
                            " state None: original states Indication06-Indication20 were added after UI5 1.71 (since 1.130)
                            )->leaf( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Indication 6`
                                )->a( n = `state` v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Indication 7`
                                )->a( n = `state` v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Indication 8`
                                )->a( n = `state` v = `None`

                        )->shut(
                    )->shut(
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->leaf( `Label`
                            )->a( n = `text`     v = `Inverted ObjectStatus with different indication states.`
                            )->a( n = `design`   v = `Bold`
                            )->a( n = `wrapping` v = `true`
                            )->a( n = `class`    v = `sapUiSmallMarginBottom`

                        )->open( n = `VerticalLayout` ns = `l`
                            )->a( n = `width` v = `100%`

                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication1`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication01`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication2`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication02`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication3 active`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `active`   v = `true`
                                )->a( n = `state`    v = `Indication03`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication4`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication04`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication5 active`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `active`   v = `true`
                                )->a( n = `state`    v = `Indication05`
                            " state None: original IndicationNN (>Indication05) is newer than UI5 1.71
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication6 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `icon`     v = `sap-icon://attachment`
                                )->a( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication7 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication8 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication9 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication10`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `None`

                        )->shut(
                    )->shut(
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->open( n = `VerticalLayout` ns = `l`
                            )->a( n = `width` v = `100%`

                            )->leaf( `Label`
                                )->a( n = `text`     v = `Inverted ObjectStatus with different indication states.`
                                )->a( n = `design`   v = `Bold`
                                )->a( n = `wrapping` v = `true`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                            " state None: original IndicationNN (>Indication05) is newer than UI5 1.71
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication11`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication12 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication13 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication14 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `icon`     v = `sap-icon://notes`
                                )->a( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication15 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication16`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication17 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication18`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication19 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication20`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `None`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut(
        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->leaf( `Label`
                )->a( n = `text`     v = `ObjectStatus with style sapMObjectStatusLarge applied`
                )->a( n = `design`   v = `Bold`
                )->a( n = `wrapping` v = `true`
                )->a( n = `class`    v = `sapUiSmallMarginTop`
            )->leaf( `ObjectStatus`
                )->a( n = `class` v = `sapMObjectStatusLarge`
                )->a( n = `title` v = `Product status`
                )->a( n = `text`  v = `Shipped`
                )->a( n = `state` v = `Success`
                )->a( n = `icon`  v = `sap-icon://sys-enter-2`
            )->leaf( `ObjectStatus`
                )->a( n = `class`    v = `sapMObjectStatusLarge`
                )->a( n = `text`     v = `Shipped`
                )->a( n = `state`    v = `Success`
                )->a( n = `inverted` v = `true`
                )->a( n = `icon`     v = `sap-icon://sys-enter-2`

        )->shut(
        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->leaf( `Label`
                )->a( n = `text`     v = `ObjectStatus with and without sapMObjectStatusLongText CSS class`
                )->a( n = `design`   v = `Bold`
                )->a( n = `wrapping` v = `true`
                )->a( n = `class`    v = `sapUiSmallMarginTop`

            )->open( `Table`
                )->open( `columns`
                    )->open( `Column`
                        )->leaf( `Text`
                            )->a( n = `text` v = `ObjectStatus with default text wrapping`

                    )->shut(
                    )->open( `Column`
                        )->leaf( `Text`
                            )->a( n = `text` v = `ObjectStatus with enchanced text wrapping via 'sapMObjectStatusLongText' CSS class`

                    )->shut(
                )->shut(

                )->open( `items`
                    )->open( `ColumnListItem`
                        )->open( `cells`
                            )->leaf( `ObjectStatus`
                                )->a( n = `title` v = `Product status`
                                )->a( n = `text`  v = `VeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrapping`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class` v = `sapMObjectStatusLongText`
                                )->a( n = `title` v = `Product status`
                                )->a( n = `text`  v = `VeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrapping` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `STATUS_PRESSED`.
        " the original controller opens a Dialog showing this error description
        client->message_toast_display( `Product was damaged along transportation.` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
