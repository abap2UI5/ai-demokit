CLASS z2ui5_cl_ai_app_530 DEFINITION PUBLIC.

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

    METHODS model_init.
    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_530 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

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
    selected = t_items[ 1 ]-text.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( n = `content` ns = `l`
                )->open( `Breadcrumbs`
                    )->a( n = `currentLocationText` v = `Laptop`
                    )->a( n = `separatorStyle`      v = client->_bind( selected )

                    )->leaf( `Link`
                        )->a( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                              t_arg = VALUE #( ( `${$source>/text}` ) ) )
                        )->a( n = `text`  v = `Products`
                    )->leaf( `Link`
                        )->a( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                              t_arg = VALUE #( ( `${$source>/text}` ) ) )
                        )->a( n = `text`  v = `Suppliers`
                    )->leaf( `Link`
                        )->a( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                              t_arg = VALUE #( ( `${$source>/text}` ) ) )
                        )->a( n = `text`  v = `Titanium`
                    )->leaf( `Link`
                        )->a( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                              t_arg = VALUE #( ( `${$source>/text}` ) ) )
                        )->a( n = `text`  v = `Ultra portable`
                    )->leaf( `Link`
                        )->a( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                              t_arg = VALUE #( ( `${$source>/text}` ) ) )
                        )->a( n = `text`  v = `12 inch`
                    )->leaf( `Link`
                        )->a( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                              t_arg = VALUE #( ( `${$source>/text}` ) ) )
                        )->a( n = `text`  v = `Super portable deluxe`

                )->shut(
                )->open( `HBox`
                    )->a( n = `alignItems` v = `Center`

                    )->open( `items`
                        )->leaf( `Label`
                            )->a( n = `labelFor` v = `separatorSelect`
                            )->a( n = `text`     v = `Change separator style`

                        " no change event: selectedKey and separatorStyle share the same
                        " two-way bound path, so picking a separator updates instantly client-side
                        )->open( `Select`
                            )->a( n = `class`       v = `sapUiSmallMarginBegin`
                            )->a( n = `id`          v = `separatorSelect`
                            )->a( n = `selectedKey` v = client->_bind( selected )
                            )->a( n = `items`       v = client->_bind( t_items )

                            )->leaf( n = `Item` ns = `core`
                                )->a( n = `key`  v = `{TEXT}`
                                )->a( n = `text` v = `{KEY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `LINK_PRESS`.
        client->message_toast_display( |{ client->get_event_arg( ) } has been activated| ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
