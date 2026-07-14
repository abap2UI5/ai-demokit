"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.Breadcrumbs - Breadcrumbs
"! https://sdk.openui5.org/entity/sap.m.Breadcrumbs/sample/sap.m.sample.Breadcrumbs
CLASS z2ui5_cl_api_app_530 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_item,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_item.
    DATA t_items TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.
    DATA selected TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS data_init.
    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_530 IMPLEMENTATION.

  " NOTES (generation):
  " - LIVE-TEST: the link press reads the clicked link's text via the event arg
  "   ${$source>/text}. This $source> form is not used anywhere else in the repo
  "   and is unverified - confirm it delivers the text in a running system.

  METHOD data_init.

    " Rows built in the original onInit from the sap.m BreadcrumbsSeparatorStyle enum
    " (UI5 1.71): key = enum name, text = enum value (value equals name here)
    t_items = VALUE #(
      ( key = `Slash`             text = `Slash` )
      ( key = `BackSlash`         text = `BackSlash` )
      ( key = `DoubleBackSlash`   text = `DoubleBackSlash` )
      ( key = `DoubleSlash`       text = `DoubleSlash` )
      ( key = `DoubleGreaterThan` text = `DoubleGreaterThan` )
      ( key = `GreaterThan`       text = `GreaterThan` ) ).

    " original: selected = oMData[0].text -> the first item's text
    selected = `Slash`.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->attr( n = `xmlns`      v = `sap.m`
        )->attr( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->attr( n = `xmlns:l`    v = `sap.ui.layout`
        )->attr( n = `xmlns:core` v = `sap.ui.core`

        )->open( n = `VerticalLayout` ns = `l`
            )->attr( n = `class` v = `sapUiContentPadding`
            )->attr( n = `width` v = `100%`

            )->open( n = `content` ns = `l`
                )->open( `Breadcrumbs`
                    )->attr( n = `currentLocationText` v = `Laptop`
                    )->attr( n = `separatorStyle`      v = client->_bind_edit( selected )

                    )->leaf( `Link`
                        )->attr( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                                 t_arg = VALUE #( ( `${$source>/text}` ) ) )
                        )->attr( n = `text`  v = `Products`
                    )->leaf( `Link`
                        )->attr( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                                 t_arg = VALUE #( ( `${$source>/text}` ) ) )
                        )->attr( n = `text`  v = `Suppliers`
                    )->leaf( `Link`
                        )->attr( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                                 t_arg = VALUE #( ( `${$source>/text}` ) ) )
                        )->attr( n = `text`  v = `Titanium`
                    )->leaf( `Link`
                        )->attr( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                                 t_arg = VALUE #( ( `${$source>/text}` ) ) )
                        )->attr( n = `text`  v = `Ultra portable`
                    )->leaf( `Link`
                        )->attr( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                                 t_arg = VALUE #( ( `${$source>/text}` ) ) )
                        )->attr( n = `text`  v = `12 inch`
                    )->leaf( `Link`
                        )->attr( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                                 t_arg = VALUE #( ( `${$source>/text}` ) ) )
                        )->attr( n = `text`  v = `Super portable deluxe`

                )->shut(
                )->open( `HBox`
                    )->attr( n = `alignItems` v = `Center`

                    )->open( `items`
                        )->leaf( `Label`
                            )->attr( n = `labelFor` v = `separatorSelect`
                            )->attr( n = `text`     v = `Change separator style`

                        )->open( `Select`
                            )->attr( n = `class`       v = `sapUiSmallMarginBegin`
                            )->attr( n = `id`          v = `separatorSelect`
                            )->attr( n = `selectedKey` v = client->_bind_edit( selected )
                            )->attr( n = `change`      v = client->_event( val   = `SEP_CHANGE`
                                                                           t_arg = VALUE #( ( `${$parameters>/selectedItem/mProperties/key}` ) ) )
                            )->attr( n = `items`       v = client->_bind( t_items )

                            )->leaf( n = `Item` ns = `core`
                                )->attr( n = `key`  v = `{TEXT}`
                                )->attr( n = `text` v = `{KEY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `LINK_PRESS`.
        client->message_toast_display( |{ client->get_event_arg( 1 ) } has been activated| ).

      WHEN `SEP_CHANGE`.
        selected = client->get_event_arg( 1 ).
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      data_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
