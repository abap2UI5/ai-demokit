CLASS z2ui5_cl_ai_app_073 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_ai_app_073 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( n = `content` ns = `l`
                )->leaf( `Label`
                    )->a( n = `text`   v = `Not active Object Attribute with title and text`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->leaf( `ObjectAttribute`
                    )->a( n = `binding` v = client->_bind( s_product )
                    )->a( n = `title`   v = `Weight`
                    )->a( n = `text`    v = `{WEIGHT_MEASURE} {WEIGHT_UNIT}`

                )->leaf( `Label`
                    )->a( n = `text`   v = `Not active Object Attribute only with set text`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->leaf( `ObjectAttribute`
                    )->a( n = `binding` v = client->_bind( s_product )
                    )->a( n = `text`    v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`

                )->leaf( `Label`
                    )->a( n = `text`   v = `Active Object Attribute with title and text which opens popup on press`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->leaf( `ObjectAttribute`
                    )->a( n = `title`        v = `Click to`
                    )->a( n = `text`         v = `Provide feedback`
                    )->a( n = `active`       v = `true`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->_event( `FEEDBACK` )

                )->leaf( `Label`
                    )->a( n = `text`   v = `Active Object Attribute with title and text which opens link on press`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->leaf( `ObjectAttribute`
                    )->a( n = `title`  v = `Visit our site`
                    )->a( n = `text`   v = `www.sap.com`
                    )->a( n = `active` v = `true`
                    )->a( n = `press`  v = client->_event_client( val   = client->cs_event-open_new_tab
                                                                  t_arg = VALUE #( ( `http://www.sap.com` ) ) )

                )->leaf( `Label`
                    )->a( n = `text`   v = `Active Object Attribute which has only title, therefore no link is displayed`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->leaf( `ObjectAttribute`
                    )->a( n = `title`  v = `Created by`
                    )->a( n = `active` v = `true`
                    )->a( n = `press`  v = client->_event( `FEEDBACK` )

                )->leaf( `Label`
                    )->a( n = `text`   v = `Active Object Attribute with long title and long text which will truncate and occupy 50% each`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->leaf( `ObjectAttribute`
                    )->a( n = `title`  v = `Some very long title that will strat to truncate on smaller screen`
                    )->a( n = `text`   v = `Some very long text that will strat to truncate on smaller screen`
                    )->a( n = `active` v = `true`

                )->leaf( `Label`
                    )->a( n = `text`   v = `Object Attribute with customContent aggregation containing sap.m.Link`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->open( `ObjectAttribute`
                    )->a( n = `title` v = `Custom content`
                    )->open( `customContent`
                        )->leaf( `Link`
                            )->a( n = `text` v = `this is sap.m.Link`

                    )->shut(
                )->shut(

                )->leaf( `Label`
                    )->a( n = `text`   v = `Object Attribute with customContent aggregation containing sap.m.Text`
                    )->a( n = `design` v = `Bold`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                )->open( `ObjectAttribute`
                    )->a( n = `title` v = `Custom content`
                    )->open( `customContent`
                        )->leaf( `Text`
                            )->a( n = `text` v = `some text set inside sap.m.Text`

                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `FEEDBACK`.
        " the original's handleFeedbacklinkPressed - a Dialog with a RatingIndicator + TextArea and Submit/Cancel
        DATA(popup) = z2ui5_cl_ai_xml=>factory( ).
        popup->open( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->open( `Dialog`
                )->a( n = `title` v = `Provide feedback`
                )->a( n = `class` v = `sapUiContentPadding`
                )->leaf( `RatingIndicator`
                    )->a( n = `maxValue` v = `5`
                )->leaf( `TextArea`
                    )->a( n = `placeholder` v = `What do you think about this item?`
                    )->a( n = `rows`        v = `5`
                    )->a( n = `cols`        v = `30`
                    )->a( n = `width`       v = `100%`
                )->open( `beginButton`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `Submit`
                        )->a( n = `type`  v = `Accept`
                        )->a( n = `press` v = client->_event( `SUBMIT` )

                )->shut(
                )->open( `endButton`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `Cancel`
                        )->a( n = `press` v = client->_event_client( client->cs_event-popup_close )

                )->shut(
            )->shut( ).
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
