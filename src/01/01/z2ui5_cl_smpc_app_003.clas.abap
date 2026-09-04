" @keywords breadcrumbs sap.m breadcrumb trail separator verticallayout link hbox label select item
" @summary Breadcrumbs is useful for displaying link hierarchy
CLASS z2ui5_cl_smpc_app_003 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_item,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_item.
    DATA t_items TYPE STANDARD TABLE OF ty_s_item WITH DEFAULT KEY.
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
    INSERT `{0} has been activated` INTO TABLE temp1.
    INSERT `${$source>/text}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `{0} has been activated` INTO TABLE temp2.
    INSERT `${$source>/text}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `{0} has been activated` INTO TABLE temp3.
    INSERT `${$source>/text}` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `{0} has been activated` INTO TABLE temp4.
    INSERT `${$source>/text}` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `{0} has been activated` INTO TABLE temp5.
    INSERT `${$source>/text}` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `MESSAGE_TOAST` INTO TABLE temp6.
    INSERT `show` INTO TABLE temp6.
    INSERT `{0} has been activated` INTO TABLE temp6.
    INSERT `${$source>/text}` INTO TABLE temp6.
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
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp1 )
                        )->a( n = `text`  v = `Products`
                    )->tag( `Link`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp2 )
                        )->a( n = `text`  v = `Suppliers`
                    )->tag( `Link`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp3 )
                        )->a( n = `text`  v = `Titanium`
                    )->tag( `Link`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp4 )
                        )->a( n = `text`  v = `Ultra portable`
                    )->tag( `Link`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp5 )
                        )->a( n = `text`  v = `12 inch`
                    )->tag( `Link`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp6 )
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
    DATA temp3 LIKE t_items.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 LIKE LINE OF t_items.
    DATA temp6 LIKE sy-tabix.
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

    " original: selected = oMData[0].text -> the first item's text
    
    
    temp6 = sy-tabix.
    READ TABLE t_items INDEX 1 INTO temp5.
    sy-tabix = temp6.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    selected = temp5-text.

  ENDMETHOD.

ENDCLASS.
