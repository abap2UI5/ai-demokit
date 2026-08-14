CLASS z2ui5_cl_smpc_app_003 DEFINITION PUBLIC.

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

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_003 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( n = `content` ns = `l`
                )->ele( `Breadcrumbs`
                    )->a( n = `currentLocationText` v = `Laptop`
                    )->a( n = `separatorStyle`      v = client->_bind( selected )

                    )->tag( `Link`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been activated` ) ( `${$source>/text}` ) ) )
                        )->a( n = `text`  v = `Products`
                    )->tag( `Link`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been activated` ) ( `${$source>/text}` ) ) )
                        )->a( n = `text`  v = `Suppliers`
                    )->tag( `Link`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been activated` ) ( `${$source>/text}` ) ) )
                        )->a( n = `text`  v = `Titanium`
                    )->tag( `Link`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been activated` ) ( `${$source>/text}` ) ) )
                        )->a( n = `text`  v = `Ultra portable`
                    )->tag( `Link`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been activated` ) ( `${$source>/text}` ) ) )
                        )->a( n = `text`  v = `12 inch`
                    )->tag( `Link`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been activated` ) ( `${$source>/text}` ) ) )
                        )->a( n = `text`  v = `Super portable deluxe`

                )->end(
                )->ele( `HBox`
                    )->a( n = `alignItems` v = `Center`

                    )->ele( `items`
                        )->tag( `Label`
                            )->a( n = `labelFor` v = `separatorSelect`
                            )->a( n = `text`     v = `Change separator style`

                        " no change event: selectedKey and separatorStyle share the same
                        " two-way bound path, so picking a separator updates instantly client-side
                        )->ele( `Select`
                            )->a( n = `class`       v = `sapUiSmallMarginBegin`
                            )->a( n = `id`          v = `separatorSelect`
                            )->a( n = `selectedKey` v = client->_bind( selected )
                            )->a( n = `items`       v = client->_bind( t_items )

                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `{KEY}`
                                )->a( n = `text` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

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

ENDCLASS.
