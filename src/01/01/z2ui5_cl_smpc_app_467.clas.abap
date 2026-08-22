" @keywords icontabbar icon tab bar sap.m icontabbarinlineicons icontabfilter text
" @summary This sample illustrates tab icons for inline mode.
CLASS z2ui5_cl_smpc_app_467 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_tab,
             key     TYPE i,
             text    TYPE string,
             content TYPE string,
             icon    TYPE string,
           END OF ty_s_tab.
    TYPES ty_t_tab TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    DATA t_tabs TYPE ty_t_tab.


  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_467 IMPLEMENTATION.

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

        " onInit adds the 12 IconTabFilters in a loop - a bound items aggregation
        " over the same 12 rows, which is the abap2UI5 form of addItem( )
        )->ele( `IconTabBar`
            )->a( n = `id`    v = `idIconTabBar`
            )->a( n = `class` v = `sapUiResponsiveContentPadding`
            )->a( n = `headerMode` v = `Inline`
            )->a( n = `items` v = client->_bind( t_tabs )

            )->ele( `items`
                )->ele( `IconTabFilter`
                    )->a( n = `text` v = `{TEXT}`
                    )->a( n = `key`  v = `{KEY}`
                    )->a( n = `icon` v = `{ICON}`

                    )->ele( `content`
                        )->tag( `Text`
                            )->a( n = `text` v = `{CONTENT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the controller builds Tab 1..12 with Content 1..12 and then gives every tab a
    " RANDOM icon out of three; a backend cannot repeat a client-side random draw,
    " so the port walks the same three icons in order
    DO 12 TIMES.
      DATA(index) = sy-index.
      INSERT VALUE #( key     = index
                      text    = |Tab { index }|
                      content = |Content { index }|
                      icon    = SWITCH #( index MOD 3
                                          WHEN 1 THEN `sap-icon://history`
                                          WHEN 2 THEN `sap-icon://home`
                                          WHEN 0 THEN `sap-icon://employee` ) )
             INTO TABLE t_tabs.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
