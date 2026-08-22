" @keywords icontabbar icon tab bar sap.m icontabbardragdrop label stepinput icontabfilter text
" @summary This example shows how the tab filters can be reordered and nested with drag and drop. Works only on desktop devices.
CLASS z2ui5_cl_smpc_app_506 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_tab,
             key     TYPE i,
             text    TYPE string,
             content TYPE string,
           END OF ty_s_tab.
    TYPES ty_t_tab TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    DATA t_tabs       TYPE ty_t_tab.
    DATA nesting_level TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_506 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`   v = `sap.ui.layout.form`

        )->ele( n = `SimpleForm` ns = `f`
            )->a( n = `layout`          v = `ResponsiveGridLayout`
            )->a( n = `editable`        v = `true`
            )->a( n = `adjustLabelSpan` v = `false`
            )->a( n = `labelSpanXL`     v = `2`
            )->a( n = `labelSpanL`      v = `2`
            )->a( n = `labelSpanM`      v = `3`
            )->a( n = `labelSpanS`      v = `5`

            )->tag( `Label`
                )->a( n = `text` v = `Maximum Nesting Level`
            " onMaxNestingLevelChange calls setMaxNestingLevel( value ) - the StepInput
            " value and the IconTabBar property are the same two-way bound field here
            )->tag( `StepInput`
                )->a( n = `value` v = client->_bind( nesting_level )
                )->a( n = `min`   v = `0`
                )->a( n = `max`   v = `100`
                )->a( n = `step`  v = `1`
                )->a( n = `width` v = `120px`

        )->end(

        " onInit adds the 30 IconTabFilters in a loop - a bound items aggregation
        " over the same 30 rows, which is the abap2UI5 form of addItem( )
        )->ele( `IconTabBar`
            )->a( n = `id`                  v = `idIconTabBar`
            )->a( n = `enableTabReordering` v = `true`
            )->a( n = `maxNestingLevel`     v = client->_bind( nesting_level )
            )->a( n = `class`               v = `sapUiResponsiveContentPadding`
            )->a( n = `items`               v = client->_bind( t_tabs )

            )->ele( `items`
                )->ele( `IconTabFilter`
                    )->a( n = `key`  v = `{KEY}`
                    )->a( n = `text` v = `{TEXT}`

                    )->ele( `content`
                        )->tag( `Text`
                            )->a( n = `text` v = `{CONTENT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the controller builds Tab 1..30 with Content 1..30 in a loop
    DO 30 TIMES.
      DATA(index) = sy-index.
      INSERT VALUE #( key     = index
                      text    = |Tab { index }|
                      content = |Content { index }| )
             INTO TABLE t_tabs.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
