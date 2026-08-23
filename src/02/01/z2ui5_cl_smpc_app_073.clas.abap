" @keywords objectattribute object attribute sap.m active attributes customcontent verticallayout label link text dialog
" @summary This is an example of Object Attribute used standalone.
CLASS z2ui5_cl_smpc_app_073 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        weight_measure TYPE string,
        weight_unit    TYPE string,
        width          TYPE string,
        depth          TYPE string,
        height         TYPE string,
        dim_unit       TYPE string,
      END OF ty_s_product.
    DATA s_product TYPE ty_s_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_073 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
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
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( n = `content` ns = `l`
                )->tag( `Label`
                    )->a( n = `text`   v = `Not active Object Attribute with title and text`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                " element binding kept 1:1 - a one-record structure S_PRODUCT instead of ProductCollection record 0 (see sidecar)
                )->tag( `ObjectAttribute`
                    )->a( n = `binding` v = client->_bind( s_product )
                    )->a( n = `title`   v = `Weight`
                    )->a( n = `text`    v = `{WEIGHT_MEASURE} {WEIGHT_UNIT}`

                )->tag( `Label`
                    )->a( n = `text`   v = `Not active Object Attribute only with set text`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->tag( `ObjectAttribute`
                    )->a( n = `binding` v = client->_bind( s_product )
                    )->a( n = `text`    v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`

                )->tag( `Label`
                    )->a( n = `text`   v = `Active Object Attribute with title and text which opens popup on press`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->tag( `ObjectAttribute`
                    )->a( n = `title`        v = `Click to`
                    )->a( n = `text`         v = `Provide feedback`
                    )->a( n = `active`       v = `true`
                    " POST-1.71: ariaHasPopup (since UI5 1.97) kept 1:1
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->_event( `FEEDBACK` )

                )->tag( `Label`
                    )->a( n = `text`   v = `Active Object Attribute with title and text which opens link on press`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->tag( `ObjectAttribute`
                    )->a( n = `title`  v = `Visit our site`
                    )->a( n = `text`   v = `www.sap.com`
                    )->a( n = `active` v = `true`
                    " the original handleSAPLinkPressed - URLHelper redirect as the URLHELPER REDIRECT frontend action (see sidecar)
                    )->a( n = `press`  v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                     t_arg = VALUE #( ( `REDIRECT` ) ( |\{ URL: 'http://www.sap.com', NEW_WINDOW: true \}| ) ) )

                )->tag( `Label`
                    )->a( n = `text`   v = `Active Object Attribute which has only title, therefore no link is displayed`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->tag( `ObjectAttribute`
                    )->a( n = `title`  v = `Created by`
                    )->a( n = `active` v = `true`
                    )->a( n = `press`  v = client->_event( `FEEDBACK` )

                )->tag( `Label`
                    )->a( n = `text`   v = `Active Object Attribute with long title and long text which will truncate and occupy 50% each`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->tag( `ObjectAttribute`
                    )->a( n = `title`  v = `Some very long title that will strat to truncate on smaller screen`
                    )->a( n = `text`   v = `Some very long text that will strat to truncate on smaller screen`
                    )->a( n = `active` v = `true`

                )->tag( `Label`
                    )->a( n = `text`   v = `Object Attribute with customContent aggregation containing sap.m.Link`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->ele( `ObjectAttribute`
                    )->a( n = `title` v = `Custom content`
                    )->ele( `customContent`
                        )->tag( `Link`
                            )->a( n = `text` v = `this is sap.m.Link`

                    )->end(
                )->end(

                )->tag( `Label`
                    )->a( n = `text`   v = `Object Attribute with customContent aggregation containing sap.m.Text`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->ele( `ObjectAttribute`
                    )->a( n = `title` v = `Custom content`
                    )->ele( `customContent`
                        )->tag( `Text`
                            )->a( n = `text` v = `some text set inside sap.m.Text`

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `FEEDBACK`.
        " the original's handleFeedbacklinkPressed - a Dialog with a RatingIndicator + TextArea and Submit/Cancel
        DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).
        popup->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->ele( `Dialog`
                )->a( n = `title` v = `Provide feedback`
                )->a( n = `class` v = `sapUiContentPadding`
                )->tag( `RatingIndicator`
                    )->a( n = `maxValue` v = `5`
                )->tag( `TextArea`
                    )->a( n = `placeholder` v = `What do you think about this item?`
                    )->a( n = `rows`        v = `5`
                    )->a( n = `cols`        v = `30`
                    )->a( n = `width`       v = `100%`
                )->ele( `beginButton`
                    )->tag( `Button`
                        )->a( n = `text`  v = `Submit`
                        )->a( n = `type`  v = `Accept`
                        )->a( n = `press` v = client->_event( `SUBMIT` )

                )->end(
                )->ele( `endButton`
                    )->tag( `Button`
                        )->a( n = `text`  v = `Cancel`
                        )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close )

                )->end(
            )->end( ).
        client->popup_display( popup->stringify( ) ).

      WHEN `SUBMIT`.
        client->popup_destroy( ).
        client->message_toast_display( `Feedback sent.` ).
    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the bound record /ProductCollection/0 (Notebook Basic 15) of ui5/mock/products.json, verbatim
    s_product = VALUE #( weight_measure = `4.2` weight_unit = `KG`
                         width          = `30`  depth       = `18`
                         height         = `3`   dim_unit    = `cm` ).

  ENDMETHOD.

ENDCLASS.
