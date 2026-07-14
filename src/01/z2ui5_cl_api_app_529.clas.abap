"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.ObjectStatus - ObjectStatus
"! https://sdk.openui5.org/entity/sap.m.ObjectStatus/sample/sap.m.sample.ObjectStatus
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

  " NOTES (generation):
  " - 1.71: ObjectStatus states Indication06-Indication20 are newer than UI5 1.71
  "   (added ~1.130). The controls are kept but their state is set to "None", so
  "   the indication colours differ from the original - verify if relevant.
  " - IMPROVISED: the active status press originally opens a controller-built
  "   Dialog; replaced with message_toast_display, since a Dialog is not a 1:1
  "   view element.

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
        )->attr( n = `xmlns:l`   v = `sap.ui.layout`
        )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->attr( n = `xmlns`     v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->attr( n = `width` v = `100%`

            )->open( n = `BlockLayout` ns = `l`
                )->open( n = `BlockLayoutRow` ns = `l`
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->open( n = `VerticalLayout` ns = `l`
                            )->attr( n = `class` v = `sapUiContentPadding`
                            )->attr( n = `width` v = `100%`

                            )->leaf( `Label`
                                )->attr( n = `text`     v = `ObjectStatus with different value states`
                                )->attr( n = `design`   v = `Bold`
                                )->attr( n = `wrapping` v = `true`
                                )->attr( n = `class`    v = `sapUiSmallMarginTop`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class` v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`  v = `Unknown`
                                )->attr( n = `state` v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class` v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`  v = `Currently closed`
                                )->attr( n = `icon`  v = `sap-icon://information`
                                )->attr( n = `state` v = `Information`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class` v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`  v = `Product Shipped`
                                )->attr( n = `icon`  v = `sap-icon://sys-enter-2`
                                )->attr( n = `state` v = `Success`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class` v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`  v = `Product Missing`
                                )->attr( n = `icon`  v = `sap-icon://alert`
                                )->attr( n = `state` v = `Warning`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class` v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`  v = `Product Damaged`
                                )->attr( n = `icon`  v = `sap-icon://error`
                                )->attr( n = `state` v = `Error`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class` v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`  v = `Product Damaged`
                                )->attr( n = `state` v = `Error`
                            " original .handleStatusPressed opens a Dialog; here the press is wired to a message toast
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`  v = `sapUiSmallMarginBottom`
                                )->attr( n = `title`  v = `Product status`
                                )->attr( n = `text`   v = `Damaged`
                                )->attr( n = `active` v = `true`
                                )->attr( n = `state`  v = `Error`
                                )->attr( n = `press`  v = client->_event( `STATUS_PRESSED` )
                                )->attr( n = `icon`   v = `sap-icon://error`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`  v = `sapUiSmallMarginBottom`
                                )->attr( n = `title`  v = `Test`
                                )->attr( n = `active` v = `true`
                                )->attr( n = `state`  v = `Error`
                                )->attr( n = `icon`   v = `sap-icon://error`

                        )->shut(
                    )->shut(
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->open( n = `VerticalLayout` ns = `l`
                            )->attr( n = `class` v = `sapUiContentPadding`
                            )->attr( n = `width` v = `100%`

                            )->leaf( `Label`
                                )->attr( n = `text`     v = `Inverted ObjectStatus with different value states.`
                                )->attr( n = `design`   v = `Bold`
                                )->attr( n = `wrapping` v = `true`
                                )->attr( n = `class`    v = `sapUiSmallMarginTop`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Unknown`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Currently closed (click)`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `active`   v = `true`
                                )->attr( n = `icon`     v = `sap-icon://information`
                                )->attr( n = `state`    v = `Information`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Product Shipped`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `icon`     v = `sap-icon://sys-enter-2`
                                )->attr( n = `state`    v = `Success`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Product Missing`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `icon`     v = `sap-icon://alert`
                                )->attr( n = `state`    v = `Warning`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Product Damaged`
                                )->attr( n = `active`   v = `true`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `Error`
                                )->attr( n = `icon`     v = `sap-icon://error`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `active`   v = `true`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `Error`
                                )->attr( n = `icon`     v = `sap-icon://error`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut(
        )->open( n = `VerticalLayout` ns = `l`
            )->attr( n = `class` v = `sapUiContentPadding`
            )->attr( n = `width` v = `100%`

            )->open( n = `BlockLayout` ns = `l`
                )->open( n = `BlockLayoutRow` ns = `l`
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->leaf( `Label`
                            )->attr( n = `text`     v = `ObjectStatus with different indication states.`
                            )->attr( n = `design`   v = `Bold`
                            )->attr( n = `wrapping` v = `true`
                            )->attr( n = `class`    v = `sapUiSmallMarginBottom`

                        )->open( n = `VerticalLayout` ns = `l`
                            )->attr( n = `width` v = `100%`

                            )->leaf( `ObjectStatus`
                                )->attr( n = `class` v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`  v = `Indication 1`
                                )->attr( n = `state` v = `Indication01`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class` v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`  v = `Indication 2`
                                )->attr( n = `state` v = `Indication02`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class` v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`  v = `Indication 3`
                                )->attr( n = `state` v = `Indication03`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`  v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`   v = `Indication 4 active`
                                )->attr( n = `active` v = `true`
                                )->attr( n = `state`  v = `Indication04`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class` v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`  v = `Indication 5`
                                )->attr( n = `state` v = `Indication05`
                            " state None: original states Indication06-Indication20 were added after UI5 1.71 (since 1.130)
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class` v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`  v = `Indication 6`
                                )->attr( n = `state` v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class` v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`  v = `Indication 7`
                                )->attr( n = `state` v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class` v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`  v = `Indication 8`
                                )->attr( n = `state` v = `None`

                        )->shut(
                    )->shut(
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->leaf( `Label`
                            )->attr( n = `text`     v = `Inverted ObjectStatus with different indication states.`
                            )->attr( n = `design`   v = `Bold`
                            )->attr( n = `wrapping` v = `true`
                            )->attr( n = `class`    v = `sapUiSmallMarginBottom`

                        )->open( n = `VerticalLayout` ns = `l`
                            )->attr( n = `width` v = `100%`

                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication1`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `Indication01`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication2`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `Indication02`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication3 active`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `active`   v = `true`
                                )->attr( n = `state`    v = `Indication03`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication4`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `Indication04`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication5 active`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `active`   v = `true`
                                )->attr( n = `state`    v = `Indication05`
                            " state None: original IndicationNN (>Indication05) is newer than UI5 1.71
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication6 active`
                                )->attr( n = `active`   v = `true`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `icon`     v = `sap-icon://attachment`
                                )->attr( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication7 active`
                                )->attr( n = `active`   v = `true`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication8 active`
                                )->attr( n = `active`   v = `true`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication9 active`
                                )->attr( n = `active`   v = `true`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication10`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `None`

                        )->shut(
                    )->shut(
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->open( n = `VerticalLayout` ns = `l`
                            )->attr( n = `width` v = `100%`

                            )->leaf( `Label`
                                )->attr( n = `text`     v = `Inverted ObjectStatus with different indication states.`
                                )->attr( n = `design`   v = `Bold`
                                )->attr( n = `wrapping` v = `true`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                            " state None: original IndicationNN (>Indication05) is newer than UI5 1.71
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication11`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication12 active`
                                )->attr( n = `active`   v = `true`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication13 active`
                                )->attr( n = `active`   v = `true`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication14 active`
                                )->attr( n = `active`   v = `true`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `icon`     v = `sap-icon://notes`
                                )->attr( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication15 active`
                                )->attr( n = `active`   v = `true`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication16`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication17 active`
                                )->attr( n = `active`   v = `true`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication18`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication19 active`
                                )->attr( n = `active`   v = `true`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `None`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class`    v = `sapUiSmallMarginBottom`
                                )->attr( n = `text`     v = `Inverted Indication20`
                                )->attr( n = `inverted` v = `true`
                                )->attr( n = `state`    v = `None`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut(
        )->open( n = `VerticalLayout` ns = `l`
            )->attr( n = `class` v = `sapUiContentPadding`
            )->attr( n = `width` v = `100%`

            )->leaf( `Label`
                )->attr( n = `text`     v = `ObjectStatus with style sapMObjectStatusLarge applied`
                )->attr( n = `design`   v = `Bold`
                )->attr( n = `wrapping` v = `true`
                )->attr( n = `class`    v = `sapUiSmallMarginTop`
            )->leaf( `ObjectStatus`
                )->attr( n = `class` v = `sapMObjectStatusLarge`
                )->attr( n = `title` v = `Product status`
                )->attr( n = `text`  v = `Shipped`
                )->attr( n = `state` v = `Success`
                )->attr( n = `icon`  v = `sap-icon://sys-enter-2`
            )->leaf( `ObjectStatus`
                )->attr( n = `class`    v = `sapMObjectStatusLarge`
                )->attr( n = `text`     v = `Shipped`
                )->attr( n = `state`    v = `Success`
                )->attr( n = `inverted` v = `true`
                )->attr( n = `icon`     v = `sap-icon://sys-enter-2`

        )->shut(
        )->open( n = `VerticalLayout` ns = `l`
            )->attr( n = `class` v = `sapUiContentPadding`
            )->attr( n = `width` v = `100%`

            )->leaf( `Label`
                )->attr( n = `text`     v = `ObjectStatus with and without sapMObjectStatusLongText CSS class`
                )->attr( n = `design`   v = `Bold`
                )->attr( n = `wrapping` v = `true`
                )->attr( n = `class`    v = `sapUiSmallMarginTop`

            )->open( `Table`
                )->open( `columns`
                    )->open( `Column`
                        )->leaf( `Text`
                            )->attr( n = `text` v = `ObjectStatus with default text wrapping`

                    )->shut(
                    )->open( `Column`
                        )->leaf( `Text`
                            )->attr( n = `text` v = `ObjectStatus with enchanced text wrapping via 'sapMObjectStatusLongText' CSS class`

                    )->shut(
                )->shut(

                )->open( `items`
                    )->open( `ColumnListItem`
                        )->open( `cells`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `title` v = `Product status`
                                )->attr( n = `text`  v = `VeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrapping`
                            )->leaf( `ObjectStatus`
                                )->attr( n = `class` v = `sapMObjectStatusLongText`
                                )->attr( n = `title` v = `Product status`
                                )->attr( n = `text`  v = `VeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrapping` ).

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
