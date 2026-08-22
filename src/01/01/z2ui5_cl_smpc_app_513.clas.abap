" @keywords objectheader object header sap.m objectheaderresponsiveii objectattribute objectstatus objectmarker icontabbar icontabfilter image text
" @summary This is a responsive Object Header with a Title, 2 Statuses/Attributes rendered below the title in a Master/Detail mode (fullScreenOptimized = false).
CLASS z2ui5_cl_smpc_app_513 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the record the original binds with binding="{/ProductCollection/0}",
    " seeded at the model root and bound absolutely
    DATA description   TYPE string.
    DATA price         TYPE p LENGTH 8 DECIMALS 2.
    DATA currencycode  TYPE string.
    DATA suppliername  TYPE string.
    DATA quantity      TYPE i.
    DATA productpicurl TYPE string.
    DATA width         TYPE string.
    DATA depth         TYPE string.
    DATA height        TYPE string.
    DATA dimunit       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_513 IMPLEMENTATION.

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
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `ObjectHeader`
            )->a( n = `id`                  v = `oh1`
            )->a( n = `responsive`          v = `true`
            )->a( n = `fullScreenOptimized` v = `false`
            )->a( n = `intro`               v = client->_bind( description )
            )->a( n = `title`               v = `Long title truncated to 80 chars on all devices and to 50 chars on phone portrait`
            )->a( n = `number`              v = |\{ parts:[\{path:'{ client->_bind( val = price path = abap_true ) }'\},| &&
                                                 |\{path:'{ client->_bind( val = currencycode path = abap_true ) }'\}],| &&
                                                 | type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
            )->a( n = `numberUnit`          v = client->_bind( currencycode )
            )->a( n = `numberState`         v = `Success`
            )->a( n = `backgroundDesign`    v = `Translucent`
            )->a( n = `class`               v = `sapUiResponsivePadding--header`

            )->tag( `ObjectAttribute`
                )->a( n = `title` v = `Manufacturer`
                )->a( n = `text`  v = client->_bind( suppliername )

            )->ele( `statuses`
                )->tag( `ObjectStatus`
                    )->a( n = `title` v = `Approval`
                    )->a( n = `text`  v = `Pending`
                    )->a( n = `state` v = `Warning`

            )->end(
            )->ele( `markers`
                )->tag( `ObjectMarker`
                    )->a( n = `type` v = `Flagged`
                )->tag( `ObjectMarker`
                    )->a( n = `type` v = `Favorite`

            )->end(
            )->ele( `headerContainer`
                )->ele( `IconTabBar`
                    )->a( n = `id`          v = `itb1`
                    )->a( n = `selectedKey` v = `key3`
                    )->a( n = `upperCase`   v = `true`
                    )->a( n = `class`       v = `sapUiResponsiveContentPadding`

                    )->ele( `items`
                        )->ele( `IconTabFilter`
                            )->a( n = `text`  v = `Info`
                            )->a( n = `count` v = client->_bind( quantity )
                            )->a( n = `key`   v = `key1`

                            )->ele( n = `VerticalLayout` ns = `l`
                                )->a( n = `class` v = `sapUiContentPadding`
                                )->a( n = `width` v = `100%`

                                )->ele( n = `content` ns = `l`
                                    )->tag( `Image`
                                        )->a( n = `src` v = client->_bind( productpicurl )
                                    )->tag( `Text`
                                        )->a( n = `text` v = |{ client->_bind( width ) } x { client->_bind( depth ) } x { client->_bind( height ) } { client->_bind( dimunit ) }|

                                )->end(
                            )->end(
                        )->end(

                        )->ele( `IconTabFilter`
                            )->a( n = `text`  v = `Activities`
                            )->a( n = `count` v = `10`
                            )->a( n = `key`   v = `key2`

                            )->ele( n = `VerticalLayout` ns = `l`
                                )->a( n = `class` v = `sapUiContentPadding`
                                )->a( n = `width` v = `100%`

                                )->ele( n = `content` ns = `l`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `Activity content goes here ...`

                                )->end(
                            )->end(
                        )->end(

                        )->ele( `IconTabFilter`
                            )->a( n = `text`  v = `Attachments`
                            )->a( n = `count` v = `1`
                            )->a( n = `key`   v = `key3`

                            )->tag( `Link`
                                )->a( n = `text`  v = `Attachment`
                                )->a( n = `press` v = client->_event( `LINK_PRESS` )

                        )->end(

                        )->ele( `IconTabFilter`
                            )->a( n = `text`  v = `PartnerInfo`
                            )->a( n = `key`   v = `key4`
                            )->a( n = `count` v = `1`

                            )->tag( `Link`
                                )->a( n = `text`   v = `Partner SAP SE`
                                )->a( n = `target` v = `_blank`
                                )->a( n = `href`   v = `http://www.sap.com/` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `LINK_PRESS`.
      " onPress - MessageBox.alert("Link was clicked!")
      client->message_box_display( text = `Link was clicked!` type = `alert` ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " /ProductCollection/0 of ui5/mock/products.json, the fields the view binds
    description   = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    price         = '956.00'.
    currencycode  = `EUR`.
    suppliername  = `Very Best Screens`.
    quantity      = 10.
    productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    width         = `30`.
    depth         = `18`.
    height        = `3`.
    dimunit       = `cm`.

  ENDMETHOD.

ENDCLASS.
