" @keywords icontabbar icon tab bar sap.m icontabbarstartandendoverflow icontabfilter text
" @summary This sample illustrates the start and end overflow mode of the Icon Tab Bar.
CLASS z2ui5_cl_smpc_app_466 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_tab,
             key     TYPE i,
             text    TYPE string,
             content TYPE string,
           END OF ty_s_tab.
    TYPES ty_t_tab TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    DATA t_tabs TYPE ty_t_tab.


  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_466 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        " onInit adds the 50 IconTabFilters in a loop - a bound items aggregation
        " over the same 50 rows, which is the abap2UI5 form of addItem( )
        )->ele( `IconTabBar`
            )->a( n = `id`    v = `idIconTabBar`
            )->a( n = `class` v = `sapUiResponsiveContentPadding`
            )->a( n = `selectedKey`      v = `18`
            )->a( n = `tabsOverflowMode` v = `StartAndEnd`
            )->a( n = `items` v = client->_bind( t_tabs )

            )->ele( `items`
                )->ele( `IconTabFilter`
                    )->a( n = `text` v = `{TEXT}`
                    )->a( n = `key`  v = `{KEY}`

                    )->ele( `content`
                        )->tag( `Text`
                            )->a( n = `text` v = `{CONTENT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the controller builds Tab 1..50 with Content 1..50 in a loop
    DO 50 TIMES.
      DATA(index) = sy-index.
      INSERT VALUE #( key     = index
                      text    = |Tab { index }|
                      content = |Content { index }| )
             INTO TABLE t_tabs.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
