CLASS z2ui5_cl_api_app_530 DEFINITION PUBLIC.

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

    METHODS model_init.
    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_530 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " Rows built in the original onInit from the sap.m BreadcrumbsSeparatorStyle enum
    " (UI5 1.71): key = enum name, text = enum value (value equals name here)
    DATA temp1 LIKE t_items.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 LIKE LINE OF t_items.
    DATA temp4 LIKE sy-tabix.
    CLEAR temp1.
    
    temp2-key = `Slash`.
    temp2-text = `Slash`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `BackSlash`.
    temp2-text = `BackSlash`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `DoubleBackSlash`.
    temp2-text = `DoubleBackSlash`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `DoubleSlash`.
    temp2-text = `DoubleSlash`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `DoubleGreaterThan`.
    temp2-text = `DoubleGreaterThan`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `GreaterThan`.
    temp2-text = `GreaterThan`.
    INSERT temp2 INTO TABLE temp1.
    t_items = temp1.

    " original: selected = oMData[0].text -> the first item's text
    
    
    temp4 = sy-tabix.
    READ TABLE t_items INDEX 1 INTO temp3.
    sy-tabix = temp4.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    selected = temp3-text.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_api_xml.
    DATA temp5 TYPE string_table.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp6 TYPE string_table.
    view = z2ui5_cl_api_xml=>factory( ).

    
    CLEAR temp5.
    INSERT `${$source>/text}` INTO TABLE temp5.
    
    CLEAR temp1.
    INSERT `${$source>/text}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$source>/text}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `${$source>/text}` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `${$source>/text}` INTO TABLE temp4.
    
    CLEAR temp6.
    INSERT `${$source>/text}` INTO TABLE temp6.
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
                    )->a( n = `separatorStyle`      v = client->_bind_edit( selected )

                    )->leaf( `Link`
                        )->a( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                              t_arg = temp5 )
                        )->a( n = `text`  v = `Products`
                    )->leaf( `Link`
                        )->a( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                              t_arg = temp1 )
                        )->a( n = `text`  v = `Suppliers`
                    )->leaf( `Link`
                        )->a( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                              t_arg = temp2 )
                        )->a( n = `text`  v = `Titanium`
                    )->leaf( `Link`
                        )->a( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                              t_arg = temp3 )
                        )->a( n = `text`  v = `Ultra portable`
                    )->leaf( `Link`
                        )->a( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                              t_arg = temp4 )
                        )->a( n = `text`  v = `12 inch`
                    )->leaf( `Link`
                        )->a( n = `press` v = client->_event( val   = `LINK_PRESS`
                                                              t_arg = temp6 )
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
                            )->a( n = `selectedKey` v = client->_bind_edit( selected )
                            )->a( n = `items`       v = client->_bind_edit( t_items )

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
