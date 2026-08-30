" @keywords select sap.m selectchangeevents listitem
" @summary Demonstrates the use of 'change' and 'liveChange' events.
CLASS z2ui5_cl_smpc_app_511 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid TYPE string,
             name      TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

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
                                                                             t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` )
                                                                                              ( `change event fired! ` && |\n| && ` Selected Item id: {0}` && |\n| && `Previously Selected Item id: {1}` )
                                                                                              ( `${$parameters>/selectedItem}.getId()` )
                                                                                              ( `${$parameters>/previousSelectedItem}.getId()` ) ) )
                    )->a( n = `liveChange`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                             t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` )
                                                                                              ( `liveChange event fired! ` && |\n| && ` Selected item id: {0}` )
                                                                                              ( `${$parameters>/selectedItem}.getId()` ) ) )

                    )->tag( n = `ListItem` ns = `core`
                        )->a( n = `key`  v = `{PRODUCTID}`
                        )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the ten products the controller seeds inline, verbatim
    t_products = VALUE #(
        ( productid = `HT-1001` name = `Notebook Basic 17` )
        ( productid = `HT-1002` name = `Notebook Basic 18` )
        ( productid = `HT-1003` name = `Notebook Basic 19` )
        ( productid = `HT-1007` name = `ITelO Vault` )
        ( productid = `HT-1010` name = `Notebook Professional 15` )
        ( productid = `HT-1011` name = `Notebook Professional 17` )
        ( productid = `HT-1020` name = `ITelO Vault Net` )
        ( productid = `HT-1021` name = `ITelO Vault SAT` )
        ( productid = `HT-1022` name = `Comfort Easy` )
        ( productid = `HT-1023` name = `Comfort Senior` ) ).

  ENDMETHOD.

ENDCLASS.
