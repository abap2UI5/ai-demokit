" @keywords breadcrumbs sap.m breadcrumbswithoutcurrentpage verticallayout link hbox label select item
" @summary The breadcrumb shows the position of the object page in the application hiearchy, without the current page. Use this breadcrumb for the object page only.
CLASS z2ui5_cl_smpc_app_441 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_style,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_style.
    TYPES ty_t_style TYPE STANDARD TABLE OF ty_s_style WITH DEFAULT KEY.

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
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `{0} has been clicked` INTO TABLE temp1.
    INSERT `${$source>/text}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `{0} has been clicked` INTO TABLE temp2.
    INSERT `${$source>/text}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `{0} has been clicked` INTO TABLE temp3.
    INSERT `${$source>/text}` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `{0} has been clicked` INTO TABLE temp4.
    INSERT `${$source>/text}` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `{0} has been clicked` INTO TABLE temp5.
    INSERT `${$source>/text}` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `MESSAGE_TOAST` INTO TABLE temp6.
    INSERT `show` INTO TABLE temp6.
    INSERT `{0} has been clicked` INTO TABLE temp6.
    INSERT `${$source>/text}` INTO TABLE temp6.
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
                                                                    t_arg = temp1 )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 1`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = temp2 )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 2`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = temp3 )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 3`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = temp4 )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 4`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = temp5 )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 5`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = temp6 )

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
    DATA temp3 TYPE z2ui5_cl_smpc_app_441=>ty_t_style.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-key = `Slash`.
    temp4-text = `Slash`.
    INSERT temp4 INTO TABLE temp3.
    temp4-key = `BackSlash`.
    temp4-text = `BackSlash`.
    INSERT temp4 INTO TABLE temp3.
    temp4-key = `DoubleSlash`.
    temp4-text = `DoubleSlash`.
    INSERT temp4 INTO TABLE temp3.
    temp4-key = `DoubleBackSlash`.
    temp4-text = `DoubleBackSlash`.
    INSERT temp4 INTO TABLE temp3.
    temp4-key = `GreaterThan`.
    temp4-text = `GreaterThan`.
    INSERT temp4 INTO TABLE temp3.
    temp4-key = `DoubleGreaterThan`.
    temp4-text = `DoubleGreaterThan`.
    INSERT temp4 INTO TABLE temp3.
    t_items = temp3.

  ENDMETHOD.

ENDCLASS.
