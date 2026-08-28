" @keywords objectstatus object status sap.m text semantic states verticallayout blocklayout blocklayoutrow blocklayoutcell label
" @summary The object status is a small building block representing a status with a semantic color.
CLASS z2ui5_cl_smpc_app_042 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_042 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
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
            )->a( n = `width` v = `100%`

            )->ele( n = `BlockLayout` ns = `l`
                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->ele( n = `VerticalLayout` ns = `l`
                            )->a( n = `class` v = `sapUiContentPadding`
                            )->a( n = `width` v = `100%`

                            )->tag( `Label`
                                )->a( n = `text`     v = `ObjectStatus with different value states`
                                )->a( n = `design`   v = `Bold`
                                )->a( n = `wrapping` v = `true`
                                )->a( n = `class`    v = `sapUiSmallMarginTop`
                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Unknown`
                                )->a( n = `state` v = `None`
                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Currently closed`
                                )->a( n = `icon`  v = `sap-icon://information`
                                )->a( n = `state` v = `Information`
                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Product Shipped`
                                )->a( n = `icon`  v = `sap-icon://sys-enter-2`
                                )->a( n = `state` v = `Success`
                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Product Missing`
                                )->a( n = `icon`  v = `sap-icon://alert`
                                )->a( n = `state` v = `Warning`
                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Product Damaged`
                                )->a( n = `icon`  v = `sap-icon://error`
                                )->a( n = `state` v = `Error`
                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Product Damaged`
                                )->a( n = `state` v = `Error`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`  v = `sapUiSmallMarginBottom`
                                )->a( n = `title`  v = `Product status`
                                )->a( n = `text`   v = `Damaged`
                                )->a( n = `active` v = `true`
                                )->a( n = `state`  v = `Error`
                                )->a( n = `press`  v = client->_event( `STATUS_PRESSED` )
                                )->a( n = `icon`   v = `sap-icon://error`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`  v = `sapUiSmallMarginBottom`
                                )->a( n = `title`  v = `Test`
                                )->a( n = `active` v = `true`
                                )->a( n = `state`  v = `Error`
                                )->a( n = `icon`   v = `sap-icon://error`

                        )->end(
                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->ele( n = `VerticalLayout` ns = `l`
                            )->a( n = `class` v = `sapUiContentPadding`
                            )->a( n = `width` v = `100%`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Inverted ObjectStatus with different value states.`
                                )->a( n = `design`   v = `Bold`
                                )->a( n = `wrapping` v = `true`
                                )->a( n = `class`    v = `sapUiSmallMarginTop`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Unknown`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `None`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Currently closed (click)`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `active`   v = `true`
                                )->a( n = `icon`     v = `sap-icon://information`
                                )->a( n = `state`    v = `Information`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Product Shipped`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `icon`     v = `sap-icon://sys-enter-2`
                                )->a( n = `state`    v = `Success`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Product Missing`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `icon`     v = `sap-icon://alert`
                                )->a( n = `state`    v = `Warning`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Product Damaged`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Error`
                                )->a( n = `icon`     v = `sap-icon://error`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Error`
                                )->a( n = `icon`     v = `sap-icon://error`

                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(
        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( n = `BlockLayout` ns = `l`
                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->tag( `Label`
                            )->a( n = `text`     v = `ObjectStatus with different indication states.`
                            )->a( n = `design`   v = `Bold`
                            )->a( n = `wrapping` v = `true`
                            )->a( n = `class`    v = `sapUiSmallMarginBottom`

                        )->ele( n = `VerticalLayout` ns = `l`
                            )->a( n = `width` v = `100%`

                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Indication 1`
                                )->a( n = `state` v = `Indication01`
                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Indication 2`
                                )->a( n = `state` v = `Indication02`
                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Indication 3`
                                )->a( n = `state` v = `Indication03`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`  v = `sapUiSmallMarginBottom`
                                )->a( n = `text`   v = `Indication 4 active`
                                )->a( n = `active` v = `true`
                                )->a( n = `state`  v = `Indication04`
                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Indication 5`
                                )->a( n = `state` v = `Indication05`
                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Indication 6`
                                )->a( n = `state` v = `Indication06`
                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Indication 7`
                                )->a( n = `state` v = `Indication07`
                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->a( n = `text`  v = `Indication 8`
                                )->a( n = `state` v = `Indication08`

                        )->end(
                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->tag( `Label`
                            )->a( n = `text`     v = `Inverted ObjectStatus with different indication states.`
                            )->a( n = `design`   v = `Bold`
                            )->a( n = `wrapping` v = `true`
                            )->a( n = `class`    v = `sapUiSmallMarginBottom`

                        )->ele( n = `VerticalLayout` ns = `l`
                            )->a( n = `width` v = `100%`

                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication1`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication01`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication2`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication02`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication3 active`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `active`   v = `true`
                                )->a( n = `state`    v = `Indication03`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication4`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication04`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication5 active`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `active`   v = `true`
                                )->a( n = `state`    v = `Indication05`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication6 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `icon`     v = `sap-icon://attachment`
                                )->a( n = `state`    v = `Indication06`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication7 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication07`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication8 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication08`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication9 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication09`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication10`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication10`

                        )->end(
                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->ele( n = `VerticalLayout` ns = `l`
                            )->a( n = `width` v = `100%`

                            )->tag( `Label`
                                )->a( n = `text`     v = `Inverted ObjectStatus with different indication states.`
                                )->a( n = `design`   v = `Bold`
                                )->a( n = `wrapping` v = `true`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication11`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication11`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication12 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication12`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication13 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication13`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication14 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `icon`     v = `sap-icon://notes`
                                )->a( n = `state`    v = `Indication14`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication15 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication15`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication16`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication16`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication17 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication17`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication18`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication18`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication19 active`
                                )->a( n = `active`   v = `true`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication19`
                            )->tag( `ObjectStatus`
                                )->a( n = `class`    v = `sapUiSmallMarginBottom`
                                )->a( n = `text`     v = `Inverted Indication20`
                                )->a( n = `inverted` v = `true`
                                )->a( n = `state`    v = `Indication20`

                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(
        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Label`
                )->a( n = `text`     v = `ObjectStatus with style sapMObjectStatusLarge applied`
                )->a( n = `design`   v = `Bold`
                )->a( n = `wrapping` v = `true`
                )->a( n = `class`    v = `sapUiSmallMarginTop`
            )->tag( `ObjectStatus`
                )->a( n = `class` v = `sapMObjectStatusLarge`
                )->a( n = `title` v = `Product status`
                )->a( n = `text`  v = `Shipped`
                )->a( n = `state` v = `Success`
                )->a( n = `icon`  v = `sap-icon://sys-enter-2`
            )->tag( `ObjectStatus`
                )->a( n = `class`    v = `sapMObjectStatusLarge`
                )->a( n = `text`     v = `Shipped`
                )->a( n = `state`    v = `Success`
                )->a( n = `inverted` v = `true`
                )->a( n = `icon`     v = `sap-icon://sys-enter-2`

        )->end(
        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Label`
                )->a( n = `text`     v = `ObjectStatus with and without sapMObjectStatusLongText CSS class`
                )->a( n = `design`   v = `Bold`
                )->a( n = `wrapping` v = `true`
                )->a( n = `class`    v = `sapUiSmallMarginTop`

            )->ele( `Table`
                )->ele( `columns`
                    )->ele( `Column`
                        )->tag( `Text`
                            )->a( n = `text` v = `ObjectStatus with default text wrapping`

                    )->end(
                    )->ele( `Column`
                        )->tag( `Text`
                            )->a( n = `text` v = `ObjectStatus with enchanced text wrapping via 'sapMObjectStatusLongText' CSS class`

                    )->end(
                )->end(

                )->ele( `items`
                    )->ele( `ColumnListItem`
                        )->ele( `cells`
                            )->tag( `ObjectStatus`
                                )->a( n = `title` v = `Product status`
                                )->a( n = `text`  v = `VeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrapping`
                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapMObjectStatusLongText`
                                )->a( n = `title` v = `Product status`
                                )->a( n = `text`  v = `VeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrappingVeryLongTextToDemonstrateWrapping` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `STATUS_PRESSED`.
      " the original controller builds this Dialog (title/VBox/Text/OK button) and opens it
      DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

      popup->ele( n = `FragmentDefinition` ns = `core`
          )->a( n = `xmlns`      v = `sap.m`
          )->a( n = `xmlns:core` v = `sap.ui.core`

          )->ele( `Dialog`
              )->a( n = `title` v = `Error description`

              )->ele( `VBox`
                  )->a( n = `fitContainer` v = `true`

                  )->tag( `Text`
                      )->a( n = `text` v = `Product was damaged along transportation.`

              )->end(
              )->ele( `buttons`
                  )->tag( `Button`
                      )->a( n = `text`  v = `OK`
                      )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close ) ).

      client->popup_display( popup->stringify( ) ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
