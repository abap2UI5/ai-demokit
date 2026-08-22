" @keywords objectattribute object attribute sap.m objectheaderactiveattributes objectheader objectstatus dialog ratingindicator textarea button
CLASS z2ui5_cl_smpc_app_518 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the record the original binds with binding="{/ProductCollection/0}"
    DATA name          TYPE string.
    DATA price         TYPE p LENGTH 8 DECIMALS 2.
    DATA currencycode  TYPE string.
    DATA weightmeasure TYPE string.
    DATA weightunit    TYPE string.
    DATA width         TYPE string.
    DATA depth         TYPE string.
    DATA height        TYPE string.
    DATA dimunit       TYPE string.
    DATA description   TYPE string.
    DATA feedback      TYPE string.
    DATA rating        TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_feedback_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_518 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `ObjectHeader`
            )->a( n = `title`      v = client->_bind( name )
            )->a( n = `number`     v = |\{ parts:[\{path:'{ client->_bind( val = price path = abap_true ) }'\},| &&
                                        |\{path:'{ client->_bind( val = currencycode path = abap_true ) }'\}],| &&
                                        | type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
            )->a( n = `numberUnit` v = client->_bind( currencycode )
            )->a( n = `class`      v = `sapUiResponsivePadding--header`

            )->ele( `statuses`
                )->tag( `ObjectStatus`
                    )->a( n = `text`  v = `Some Damaged`
                    )->a( n = `state` v = `Error`
                )->tag( `ObjectStatus`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Success`

            )->end(

            )->tag( `ObjectAttribute`
                )->a( n = `text` v = |{ client->_bind( weightmeasure ) } { client->_bind( weightunit ) }|
            )->tag( `ObjectAttribute`
                )->a( n = `text` v = |{ client->_bind( width ) } x { client->_bind( depth ) } x { client->_bind( height ) } { client->_bind( dimunit ) }|
            )->tag( `ObjectAttribute`
                )->a( n = `text` v = client->_bind( description )
            " handleFeedbacklinkPressed builds a feedback Dialog in the controller -
            " the same dialog is built here and shown with popup_display
            )->tag( `ObjectAttribute`
                )->a( n = `text`         v = `Provide feedback`
                )->a( n = `active`       v = `true`
                )->a( n = `ariaHasPopup` v = `Dialog`
                )->a( n = `press`        v = client->_event( `FEEDBACK` )
            " handleSAPLinkPressed calls URLHelper.redirect( 'http://www.sap.com', true )
            )->tag( `ObjectAttribute`
                )->a( n = `text`   v = `www.sap.com`
                )->a( n = `active` v = `true`
                )->a( n = `press`  v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                 t_arg = VALUE #( ( `REDIRECT` ) ( |\{ URL: 'http://www.sap.com', NEW_WINDOW: true \}| ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `FEEDBACK`.
        popup_feedback_display( ).

      WHEN `FEEDBACK_SUBMIT`.
        client->message_toast_display( text = `Feedback sent.` duration = `2000` ).
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_feedback_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `Dialog`
            )->a( n = `title` v = `Provide feedback`

            )->ele( `content`
                )->tag( `RatingIndicator`
                    )->a( n = `maxValue` v = `5`
                    )->a( n = `value`    v = client->_bind( rating )
                )->tag( `TextArea`
                    )->a( n = `placeholder` v = `What do you think about this item?`
                    )->a( n = `rows`        v = `5`
                    )->a( n = `cols`        v = `30`
                    )->a( n = `width`       v = `100%`
                    )->a( n = `value`       v = client->_bind( feedback )

            )->end(
            )->ele( `beginButton`
                )->tag( `Button`
                    )->a( n = `type`  v = `Accept`
                    )->a( n = `text`  v = `Submit`
                    )->a( n = `press` v = client->_event( `FEEDBACK_SUBMIT` )

            )->end(
            )->ele( `endButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Cancel`
                    )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " /ProductCollection/0 of ui5/mock/products.json, the fields the view binds
    name          = `Notebook Basic 15`.
    price         = '956.00'.
    currencycode  = `EUR`.
    weightmeasure = `4.2`.
    weightunit    = `KG`.
    width         = `30`.
    depth         = `18`.
    height        = `3`.
    dimunit       = `cm`.
    description   = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.

  ENDMETHOD.

ENDCLASS.
