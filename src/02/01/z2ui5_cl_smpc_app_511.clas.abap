" @keywords select sap.m selectchangeevents listitem
" @summary Demonstrates the use of 'change' and 'liveChange' events.
CLASS z2ui5_cl_smpc_app_511 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid TYPE string,
             name      TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products       TYPE ty_t_product.
    DATA selected_product TYPE string VALUE `HT-1001`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_511 IMPLEMENTATION.

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
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE string_table.
    DATA temp4 LIKE LINE OF temp3.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    
    temp2 = `change event fired! ` && |\n| && ` Selected Item id: {0}` && |\n| && `Previously Selected Item id: {1}`.
    INSERT temp2 INTO TABLE temp1.
    INSERT `${$parameters>/selectedItem}.getId()` INTO TABLE temp1.
    INSERT `${$parameters>/previousSelectedItem}.getId()` INTO TABLE temp1.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    
    temp4 = `liveChange event fired! ` && |\n| && ` Selected item id: {0}`.
    INSERT temp4 INTO TABLE temp3.
    INSERT `${$parameters>/selectedItem}.getId()` INTO TABLE temp3.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->ele( `content`
                " both handlers only toast the ids of the involved items - composed on
                " the client from the event parameters, so neither needs a round-trip
                )->ele( `Select`
                    )->a( n = `forceSelection` v = `false`
                    )->a( n = `selectedKey`    v = client->_bind( selected_product )
                    )->a( n = `items`          v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|
                    )->a( n = `change`         v = client->follow_up_action( val   = client->cs_event-control_global
                                                                             t_arg = temp1 )
                    )->a( n = `liveChange`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                             t_arg = temp3 )

                    )->tag( n = `ListItem` ns = `core`
                        )->a( n = `key`  v = `{PRODUCTID}`
                        )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the ten products the controller seeds inline, verbatim
    DATA temp3 TYPE z2ui5_cl_smpc_app_511=>ty_t_product.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-productid = `HT-1001`.
    temp4-name = `Notebook Basic 17`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1002`.
    temp4-name = `Notebook Basic 18`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1003`.
    temp4-name = `Notebook Basic 19`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1007`.
    temp4-name = `ITelO Vault`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1010`.
    temp4-name = `Notebook Professional 15`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1011`.
    temp4-name = `Notebook Professional 17`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1020`.
    temp4-name = `ITelO Vault Net`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1021`.
    temp4-name = `ITelO Vault SAT`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1022`.
    temp4-name = `Comfort Easy`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1023`.
    temp4-name = `Comfort Senior`.
    INSERT temp4 INTO TABLE temp3.
    t_products = temp3.

  ENDMETHOD.

ENDCLASS.
