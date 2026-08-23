" @keywords breadcrumbs sap.m breadcrumbswithoutcurrentpage verticallayout link hbox label select item
" @summary The breadcrumb shows the position of the object page in the application hiearchy, without the current page. Use this breadcrumb for the object page only.
CLASS z2ui5_cl_smpc_app_441 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_style,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_style.
    TYPES ty_t_style TYPE STANDARD TABLE OF ty_s_style WITH EMPTY KEY.

    DATA t_items         TYPE ty_t_style.
    DATA separator_style TYPE string VALUE `Slash`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_441 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            " no currentLocationText and no current-page Link - the Breadcrumbs
            " renders links only, which is what this sample shows
            )->ele( `Breadcrumbs`
                )->a( n = `separatorStyle` v = client->_bind( separator_style )

                " onPress shows MessageToast.show( link text + ' has been clicked' ) -
                " composed on the client from the pressed Link's own text
                )->tag( `Link`
                    )->a( n = `text`  v = `Home`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been clicked` ) ( `${$source>/text}` ) ) )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 1`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been clicked` ) ( `${$source>/text}` ) ) )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 2`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been clicked` ) ( `${$source>/text}` ) ) )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 3`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been clicked` ) ( `${$source>/text}` ) ) )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 4`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been clicked` ) ( `${$source>/text}` ) ) )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 5`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been clicked` ) ( `${$source>/text}` ) ) )

            )->end(

            )->ele( `HBox`
                )->a( n = `alignItems` v = `Center`

                )->tag( `Label`
                    )->a( n = `labelFor` v = `separatorSelect`
                    )->a( n = `text`     v = `Change separator style`
                " onChange writes selectedItem.getKey( ) into /separatorStyle, which the
                " Breadcrumbs binds - one two-way bound field does the same (change dropped)
                )->ele( `Select`
                    )->a( n = `class`       v = `sapUiSmallMarginBegin`
                    )->a( n = `id`          v = `separatorSelect`
                    )->a( n = `selectedKey` v = client->_bind( separator_style )
                    )->a( n = `items`       v = client->_bind( t_items )

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `{TEXT}`
                        )->a( n = `text` v = `{KEY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " onInit builds the item list from Object.keys( sap.m.BreadcrumbsSeparatorStyle ):
    " key = the member name, text = its value - identical strings in this enum,
    " in the order library.js declares them
    t_items = VALUE #(
        ( key = `Slash`             text = `Slash` )
        ( key = `BackSlash`         text = `BackSlash` )
        ( key = `DoubleSlash`       text = `DoubleSlash` )
        ( key = `DoubleBackSlash`   text = `DoubleBackSlash` )
        ( key = `GreaterThan`       text = `GreaterThan` )
        ( key = `DoubleGreaterThan` text = `DoubleGreaterThan` ) ).

  ENDMETHOD.

ENDCLASS.
