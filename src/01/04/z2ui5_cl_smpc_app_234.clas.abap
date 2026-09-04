" @keywords flexiblecolumnlayout flexible column layout sap.f master-detail table label columnlistitem text button
" @summary Clicking on a link in a column opens the next column.
CLASS z2ui5_cl_smpc_app_234 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        text TYPE string,
      END OF ty_s_row.
    TYPES ty_t_row TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.
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


CLASS z2ui5_cl_smpc_app_234 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the three column views (List/Detail/DetailDetail) are inlined into one view;
    " the original's nested mvc:XMLView reference in beginColumnPages is dropped
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`      v = `sap.f`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `height`       v = `100%`

        " FlexibleColumnLayout carries the f: prefix here (default xmlns is sap.m for the pages);
        " layout is bound two-way in place of the controller's setLayout calls
        )->ele( n = `FlexibleColumnLayout` ns = `f`
            )->a( n = `id`     v = `fcl`
            )->a( n = `layout` v = client->_bind( layout )

            )->ele( n = `beginColumnPages` ns = `f`
                )->ele( `Page`
                    )->a( n = `id`    v = `listPage`
                    )->a( n = `title` v = `List page`

                    )->ele( `Table`
                        )->a( n = `items` v = client->_bind( t_list )

                        )->ele( `columns`
                            )->ele( `Column`
                                )->tag( `Label`
                                    )->a( n = `text` v = `List`

                            )->end(
                        )->end(
                        )->ele( `items`
                            )->ele( `ColumnListItem`
                                )->a( n = `type`   v = `Navigation`
                                )->a( n = `vAlign` v = `Middle`
                                )->a( n = `press`  v = client->_event( `LIST_PRESS` )

                                )->ele( `cells`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `{TEXT}`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
            )->ele( n = `midColumnPages` ns = `f`
                )->ele( `Page`
                    )->a( n = `id`    v = `detailPage`
                    )->a( n = `title` v = `Detail page`

                    )->ele( `Table`
                        )->a( n = `items` v = client->_bind( t_detail )

                        )->ele( `columns`
                            )->ele( `Column`
                                )->tag( `Label`
                                    )->a( n = `text` v = `Detail List`

                            )->end(
                        )->end(
                        )->ele( `items`
                            )->ele( `ColumnListItem`
                                )->a( n = `type`   v = `Navigation`
                                )->a( n = `vAlign` v = `Middle`
                                )->a( n = `press`  v = client->_event( `DETAIL_PRESS` )

                                )->ele( `cells`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `{TEXT}`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
            )->ele( n = `endColumnPages` ns = `f`
                )->ele( `Page`
                    )->a( n = `id`               v = `detailDetailPage`
                    )->a( n = `title`            v = `DetailDetail page`
                    )->a( n = `backgroundDesign` v = `Transparent`

                    )->ele( `headerContent`
                        )->tag( `Button`
                            )->a( n = `type`    v = `Transparent`
                            )->a( n = `icon`    v = `sap-icon://decline`
                            )->a( n = `press`   v = client->_event( `CLOSE` )
                            )->a( n = `tooltip` v = `Close end column`

                    )->end(
                    )->ele( `content`
                        )->ele( `Table`
                            )->a( n = `items` v = client->_bind( t_detaildetail )

                            )->ele( `columns`
                                )->ele( `Column`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `DetailDetail List`

                                )->end(
                            )->end(
                            )->ele( `items`
                                )->ele( `ColumnListItem`
                                    )->a( n = `vAlign` v = `Middle`

                                    )->ele( `cells`
                                        )->tag( `Text`
                                            )->a( n = `text` v = `{TEXT}`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `LIST_PRESS`.
        " like handleListPress: open the mid column (TwoColumnsBeginExpanded) and toast
        layout = `TwoColumnsBeginExpanded`.
        client->message_toast_display( `Loading mid column...` ).

      WHEN `DETAIL_PRESS`.
        " like handleDetailPress: open the end column (ThreeColumnsMidExpanded) and toast
        layout = `ThreeColumnsMidExpanded`.
        client->message_toast_display( `Loading end column...` ).

      WHEN `CLOSE`.
        " like handleClose: back to the mid column (TwoColumnsBeginExpanded) and toast
        layout = `TwoColumnsBeginExpanded`.
        client->message_toast_display( `Closing end column...` ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.
    DATA temp1 TYPE z2ui5_cl_smpc_app_234=>ty_t_row.
    DATA i TYPE i.
    DATA temp3 LIKE sy-index.
      DATA temp2 LIKE LINE OF temp1.
    DATA temp4 TYPE z2ui5_cl_smpc_app_234=>ty_t_row.
    DATA j TYPE i.
    DATA temp6 LIKE sy-index.
      DATA temp5 LIKE LINE OF temp4.
    DATA temp7 TYPE z2ui5_cl_smpc_app_234=>ty_t_row.
    DATA k TYPE i.
    DATA temp9 LIKE sy-index.
      DATA temp8 LIKE LINE OF temp7.

    " the original starts with only the begin column; layout defaults to OneColumn
    layout = `OneColumn`.

    " the three column views hold 26 static, identical navigation rows each -
    " reproduced as a bound aggregation over a 26-row model (same rendered output)
    
    CLEAR temp1.
    
    i = 1.
    
    temp3 = sy-index.
    WHILE NOT i > 26.
      sy-index = temp3.
      
      temp2-text = `Open mid column`.
      INSERT temp2 INTO TABLE temp1.
      i = i + 1.
    ENDWHILE.
    t_list         = temp1.
    
    CLEAR temp4.
    
    j = 1.
    
    temp6 = sy-index.
    WHILE NOT j > 26.
      sy-index = temp6.
      
      temp5-text = `Open end column`.
      INSERT temp5 INTO TABLE temp4.
      j = j + 1.
    ENDWHILE.
    t_detail       = temp4.
    
    CLEAR temp7.
    
    k = 1.
    
    temp9 = sy-index.
    WHILE NOT k > 26.
      sy-index = temp9.
      
      temp8-text = `No more columns`.
      INSERT temp8 INTO TABLE temp7.
      k = k + 1.
    ENDWHILE.
    t_detaildetail = temp7.

  ENDMETHOD.

ENDCLASS.
