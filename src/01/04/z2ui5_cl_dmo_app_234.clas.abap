CLASS z2ui5_cl_dmo_app_234 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        text TYPE string,
      END OF ty_s_row.
    TYPES ty_t_row TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.
    DATA t_list         TYPE ty_t_row.
    DATA t_detail       TYPE ty_t_row.
    DATA t_detaildetail TYPE ty_t_row.
    DATA layout         TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_234 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the three column views (List/Detail/DetailDetail) are inlined into one view;
    " the original's nested mvc:XMLView reference in beginColumnPages is dropped
    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`      v = `sap.f`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `height`       v = `100%`

        " FlexibleColumnLayout carries the f: prefix here (default xmlns is sap.m for the pages);
        " layout is bound two-way in place of the controller's setLayout calls
        )->open( n = `FlexibleColumnLayout` ns = `f`
            )->a( n = `id`     v = `fcl`
            )->a( n = `layout` v = client->_bind( layout )

            )->open( n = `beginColumnPages` ns = `f`
                )->open( `Page`
                    )->a( n = `id`    v = `listPage`
                    )->a( n = `title` v = `List page`

                    )->open( `Table`
                        )->a( n = `items` v = client->_bind( t_list )

                        )->open( `columns`
                            )->open( `Column`
                                )->leaf( `Label`
                                    )->a( n = `text` v = `List`

                            )->shut(
                        )->shut(
                        )->open( `items`
                            )->open( `ColumnListItem`
                                )->a( n = `type`   v = `Navigation`
                                )->a( n = `vAlign` v = `Middle`
                                )->a( n = `press`  v = client->_event( `LIST_PRESS` )

                                )->open( `cells`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `{TEXT}`

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
            )->open( n = `midColumnPages` ns = `f`
                )->open( `Page`
                    )->a( n = `id`    v = `detailPage`
                    )->a( n = `title` v = `Detail page`

                    )->open( `Table`
                        )->a( n = `items` v = client->_bind( t_detail )

                        )->open( `columns`
                            )->open( `Column`
                                )->leaf( `Label`
                                    )->a( n = `text` v = `Detail List`

                            )->shut(
                        )->shut(
                        )->open( `items`
                            )->open( `ColumnListItem`
                                )->a( n = `type`   v = `Navigation`
                                )->a( n = `vAlign` v = `Middle`
                                )->a( n = `press`  v = client->_event( `DETAIL_PRESS` )

                                )->open( `cells`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `{TEXT}`

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
            )->open( n = `endColumnPages` ns = `f`
                )->open( `Page`
                    )->a( n = `id`               v = `detailDetailPage`
                    )->a( n = `title`            v = `DetailDetail page`
                    )->a( n = `backgroundDesign` v = `Transparent`

                    )->open( `headerContent`
                        )->leaf( `Button`
                            )->a( n = `type`    v = `Transparent`
                            )->a( n = `icon`    v = `sap-icon://decline`
                            )->a( n = `press`   v = client->_event( `CLOSE` )
                            )->a( n = `tooltip` v = `Close end column`

                    )->shut(
                    )->open( `content`
                        )->open( `Table`
                            )->a( n = `items` v = client->_bind( t_detaildetail )

                            )->open( `columns`
                                )->open( `Column`
                                    )->leaf( `Label`
                                        )->a( n = `text` v = `DetailDetail List`

                                )->shut(
                            )->shut(
                            )->open( `items`
                                )->open( `ColumnListItem`
                                    )->a( n = `vAlign` v = `Middle`

                                    )->open( `cells`
                                        )->leaf( `Text`
                                            )->a( n = `text` v = `{TEXT}`

                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `LIST_PRESS`.
        " like handleListPress: open the mid column (TwoColumnsBeginExpanded) and toast
        layout = `TwoColumnsBeginExpanded`.
        client->message_toast_display( `Loading mid column...` ).
        client->view_model_update( ).

      WHEN `DETAIL_PRESS`.
        " like handleDetailPress: open the end column (ThreeColumnsMidExpanded) and toast
        layout = `ThreeColumnsMidExpanded`.
        client->message_toast_display( `Loading end column...` ).
        client->view_model_update( ).

      WHEN `CLOSE`.
        " like handleClose: back to the mid column (TwoColumnsBeginExpanded) and toast
        layout = `TwoColumnsBeginExpanded`.
        client->message_toast_display( `Closing end column...` ).
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the original starts with only the begin column; layout defaults to OneColumn
    layout = `OneColumn`.

    " the three column views hold 26 static, identical navigation rows each -
    " reproduced as a bound aggregation over a 26-row model (same rendered output)
    t_list         = VALUE #( FOR i = 1 UNTIL i > 26 ( text = `Open mid column` ) ).
    t_detail       = VALUE #( FOR j = 1 UNTIL j > 26 ( text = `Open end column` ) ).
    t_detaildetail = VALUE #( FOR k = 1 UNTIL k > 26 ( text = `No more columns` ) ).

  ENDMETHOD.

ENDCLASS.
