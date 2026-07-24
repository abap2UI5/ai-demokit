CLASS z2ui5_cl_ai_app_185 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_item,
        key            TYPE i,
        text           TYPE string,
        additionaltext TYPE string,
      END OF ty_item.
    DATA t_items TYPE STANDARD TABLE OF ty_item WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_185 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " The default model is one array of rows; abap2UI5's single default model is
    " an object, so the sample's root-array bindings ({/}, /9/text) resolve
    " against the T_ITEMS member (last path segment identical). The original's
    " '.whitespace2Char' formatter is applied in model_init - see the sidecar.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`

        )->open( `MessageStrip`
            )->a( n = `text`  v = `More information could be found on the following page:`
            )->a( n = `class` v = `sapUiMediumMargin`

            )->open( `link`
                )->leaf( `Link`
                    )->a( n = `text` v = `Whitespaces concept`
                    )->a( n = `href` v = `topic/37deb0bee3e2474887f1521cc583ab69`

            )->shut(
        )->shut(

        )->open( n = `Form` ns = `f`
            )->a( n = `editable` v = `true`

            )->open( n = `layout` ns = `f`
                )->leaf( n = `ResponsiveGridLayout` ns = `f`
                    )->a( n = `labelSpanXL`             v = `4`
                    )->a( n = `labelSpanL`              v = `3`
                    )->a( n = `labelSpanM`              v = `4`
                    )->a( n = `labelSpanS`              v = `12`
                    )->a( n = `adjustLabelSpan`         v = `false`
                    )->a( n = `emptySpanXL`             v = `0`
                    )->a( n = `emptySpanL`              v = `4`
                    )->a( n = `emptySpanM`              v = `0`
                    )->a( n = `emptySpanS`              v = `0`
                    )->a( n = `columnsXL`               v = `2`
                    )->a( n = `columnsL`                v = `1`
                    )->a( n = `columnsM`                v = `1`
                    )->a( n = `singleContainerFullSize` v = `false`

            )->shut(

            )->open( n = `formContainers` ns = `f`
                )->open( n = `FormContainer` ns = `f`
                    )->open( n = `formElements` ns = `f`
                        )->open( n = `FormElement` ns = `f`
                            )->a( n = `label` v = `sap.m.Input`

                            )->open( n = `fields` ns = `f`
                                )->open( `Input`
                                    )->a( n = `placeholder`     v = `Type 'Text'`
                                    )->a( n = `showSuggestion`  v = `true`
                                    )->a( n = `suggestionItems` v = client->_bind( t_items )

                                    )->open( `suggestionItems`
                                        )->leaf( n = `ListItem` ns = `core`
                                            )->a( n = `key`            v = `{KEY}`
                                            )->a( n = `text`           v = `{TEXT}`
                                            )->a( n = `additionalText` v = `{ADDITIONALTEXT}`

                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(

                        )->open( n = `FormElement` ns = `f`
                            )->a( n = `label` v = `sap.m.MultiInput`

                            )->open( n = `fields` ns = `f`
                                )->open( `MultiInput`
                                    )->a( n = `placeholder`     v = `Type 'Text'`
                                    )->a( n = `showSuggestion`  v = `true`
                                    )->a( n = `suggestionItems` v = client->_bind( t_items )

                                    )->open( `suggestionItems`
                                        )->leaf( n = `ListItem` ns = `core`
                                            )->a( n = `key`            v = `{KEY}`
                                            )->a( n = `text`           v = `{TEXT}`
                                            )->a( n = `additionalText` v = `{ADDITIONALTEXT}`

                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(

                        )->open( n = `FormElement` ns = `f`
                            )->a( n = `label` v = `sap.m.MultiComboBox`

                            )->open( n = `fields` ns = `f`
                                )->open( `MultiComboBox`
                                    )->a( n = `placeholder`          v = `Type 'Text'`
                                    )->a( n = `showSecondaryValues`  v = `true`
                                    )->a( n = `items`                v = client->_bind( t_items )

                                    )->leaf( n = `ListItem` ns = `core`
                                        )->a( n = `key`            v = `{KEY}`
                                        )->a( n = `text`           v = `{TEXT}`
                                        )->a( n = `additionalText` v = `{ADDITIONALTEXT}`

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut(

        )->open( n = `Form` ns = `f`
            )->a( n = `editable` v = `false`

            )->open( n = `layout` ns = `f`
                )->leaf( n = `ResponsiveGridLayout` ns = `f`
                    )->a( n = `labelSpanXL`             v = `4`
                    )->a( n = `labelSpanL`              v = `3`
                    )->a( n = `labelSpanM`              v = `4`
                    )->a( n = `labelSpanS`              v = `12`
                    )->a( n = `adjustLabelSpan`         v = `false`
                    )->a( n = `emptySpanXL`             v = `0`
                    )->a( n = `emptySpanL`              v = `4`
                    )->a( n = `emptySpanM`              v = `0`
                    )->a( n = `emptySpanS`              v = `0`
                    )->a( n = `columnsXL`               v = `2`
                    )->a( n = `columnsL`                v = `1`
                    )->a( n = `columnsM`                v = `1`
                    )->a( n = `singleContainerFullSize` v = `false`

            )->shut(

            )->open( n = `formContainers` ns = `f`
                )->open( n = `FormContainer` ns = `f`
                    )->open( n = `formElements` ns = `f`
                        )->open( n = `FormElement` ns = `f`
                            )->a( n = `label` v = `sap.m.Token`

                            )->open( n = `fields` ns = `f`
                                )->leaf( `Token`
                                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = t_items path = abap_true ) }/9/TEXT' \}|
                                    )->a( n = `key`  v = |\{ path: '{ client->_bind( val = t_items path = abap_true ) }/9/KEY' \}|

                            )->shut(
                        )->shut(

                        )->open( n = `FormElement` ns = `f`
                            )->a( n = `label` v = `sap.m.Text`

                            )->open( n = `fields` ns = `f`
                                )->leaf( `ObjectStatus`
                                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = t_items path = abap_true ) }/9/TEXT' \}|

                            )->shut(
                        )->shut(

                        )->open( n = `FormElement` ns = `f`
                            )->a( n = `label` v = `sap.m.ObjectNumber`

                            )->open( n = `fields` ns = `f`
                                )->leaf( `ObjectNumber`
                                    )->a( n = `number` v = |\{ path: '{ client->_bind( val = t_items path = abap_true ) }/9/TEXT' \}|

                            )->shut(
                        )->shut(

                        )->open( n = `FormElement` ns = `f`
                            )->a( n = `label` v = `sap.m.Title`

                            )->open( n = `fields` ns = `f`
                                )->leaf( `Title`
                                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = t_items path = abap_true ) }/9/TEXT' \}|

                            )->shut(
                        )->shut(

                        )->open( n = `FormElement` ns = `f`
                            )->a( n = `label` v = `sap.m.Label`

                            )->open( n = `fields` ns = `f`
                                )->leaf( `Label`
                                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = t_items path = abap_true ) }/9/TEXT' \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " The original controller builds 10 rows ("Text with <n> whitespaces" /
    " "Additional text with <n> whitespaces") and a '.whitespace2Char' formatter
    " turns every doubled space into space + non-breaking space so consecutive
    " whitespaces stay visible. abap2UI5 is a thin frontend, so that
    " presentation transform is applied here in ABAP (identical output) and the
    " view binds the finished text.
    CONSTANTS lc_nbsp TYPE string VALUE ` `.

    DATA(lv_repl) = ` ` && lc_nbsp.
    DATA lv_inverted TYPE i.
    DATA lv_text TYPE string.
    DATA lv_add  TYPE string.

    DO 10 TIMES.
      DATA(lv_i) = sy-index.
      lv_inverted = 11 - lv_i.

      lv_text = |Text with { repeat( val = ` ` occ = lv_i - 1 ) }{ lv_i } whitespaces|.
      lv_add  = |Additional text with { repeat( val = ` ` occ = lv_inverted - 1 ) }{ lv_inverted } whitespaces|.

      REPLACE ALL OCCURRENCES OF `  ` IN lv_text WITH lv_repl.
      REPLACE ALL OCCURRENCES OF `  ` IN lv_add  WITH lv_repl.

      APPEND VALUE #( key            = lv_i
                      text           = lv_text
                      additionaltext = lv_add ) TO t_items.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
