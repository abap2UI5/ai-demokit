" @keywords customtreeitem custom tree item sap.m con flexbox button input flexitemdata
" @summary With the Custom Tree Item you can add any kind of content to Tree.
CLASS z2ui5_cl_smpc_app_015 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_node5,
        text TYPE string,
        ref  TYPE string,
      END OF ty_s_node5.
    TYPES ty_t_node5 TYPE STANDARD TABLE OF ty_s_node5 WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_node4,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE ty_t_node5,
      END OF ty_s_node4.
    TYPES ty_t_node4 TYPE STANDARD TABLE OF ty_s_node4 WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_node3,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE ty_t_node4,
      END OF ty_s_node3.
    TYPES ty_t_node3 TYPE STANDARD TABLE OF ty_s_node3 WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_node2,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE ty_t_node3,
      END OF ty_s_node2.
    TYPES ty_t_node2 TYPE STANDARD TABLE OF ty_s_node2 WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_node1,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE ty_t_node2,
      END OF ty_s_node1.
    DATA t_tree TYPE STANDARD TABLE OF ty_s_node1 WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_015 IMPLEMENTATION.

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
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Tree`
            )->a( n = `id`    v = `Tree`
            )->a( n = `items` v = |\{ path: '{ client->_bind_path( t_tree ) }' \}|
            )->a( n = `mode`  v = `MultiSelect`

            )->ele( `CustomTreeItem`
                )->ele( `FlexBox`
                    )->a( n = `alignItems` v = `Start`
                    )->a( n = `width`      v = `100%`

                    )->ele( `items`
                        )->tag( `Button`
                            )->a( n = `icon`  v = `{REF}`
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                            t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Button pressed` ) ) )
                            )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->ele( `Input`
                            )->a( n = `value` v = `{TEXT}`

                            )->ele( `layoutData`
                                )->tag( `FlexItemData`
                                    )->a( n = `growFactor` v = `1` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    t_tree = VALUE #(
      ( text = `Node1` ref = `sap-icon://attachment-audio` nodes = VALUE #(
          ( text = `Node1-1` ref = `sap-icon://attachment-e-pub` nodes = VALUE #(
              ( text = `Node1-1-1` ref = `sap-icon://attachment-html` )
              ( text = `Node1-1-2` ref = `sap-icon://attachment-photo` nodes = VALUE #(
                  ( text = `Node1-1-1` ref = `sap-icon://attachment-text-file` nodes = VALUE #(
                      ( text = `Node1-1-1-1` ref = `sap-icon://attachment-video` )
                      ( text = `Node1-1-1-2` ref = `sap-icon://attachment-zip-file` )
                      ( text = `Node1-1-1-3` ref = `sap-icon://course-program` ) ) ) ) ) ) )
          ( text = `Node1-2`     ref = `sap-icon://create` ) ) )
      ( text = `Node2`       ref = `sap-icon://customer-financial-fact-sheet` ) ).

  ENDMETHOD.

ENDCLASS.
