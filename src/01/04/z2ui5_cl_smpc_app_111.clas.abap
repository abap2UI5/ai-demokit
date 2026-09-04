" @keywords gridlist grid list sap.f layout slider panel toolbar title gridlistitem vbox flexitemdata
" @summary A GridList with the default grid layout, resized live with a slider to show how the grid reflows.
CLASS z2ui5_cl_smpc_app_111 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_item,
             title    TYPE string,
             subtitle TYPE string,
           END OF ty_s_item.
    DATA t_items TYPE STANDARD TABLE OF ty_s_item WITH DEFAULT KEY.
    DATA slider_value TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_111 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`   v = `sap.f`

        )->tag( `Slider`
            )->a( n = `value` v = client->_bind( slider_value )

        )->ele( `Panel`
            )->a( n = `id`               v = `panelForGridList`
            )->a( n = `backgroundDesign` v = `Transparent`
            " original onSliderMoved sets the panel width imperatively; here it is a roundtrip-free expression binding over the slider value
            )->a( n = `width`            v = |\{= ${ client->_bind( slider_value ) } + '%' \}|

            )->ele( `headerToolbar`
                )->ele( `Toolbar`
                    )->a( n = `height` v = `3rem`
                    )->tag( `Title`
                        )->a( n = `text` v = `GridList with default grid layout`

                )->end(
            )->end(
            )->ele( n = `GridList` ns = `f`
                )->a( n = `id`         v = `gridList`
                )->a( n = `headerText` v = `GridList header`
                )->a( n = `items`      v = client->_bind( t_items )

                )->ele( n = `GridListItem` ns = `f`
                    )->ele( `VBox`
                        )->a( n = `class` v = `sapUiSmallMargin`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor`   v = `1`
                                )->a( n = `shrinkFactor` v = `0`

                        )->end(
                        )->tag( `Title`
                            )->a( n = `text`     v = `{TITLE}`
                            )->a( n = `wrapping` v = `true`
                        )->tag( `Label`
                            )->a( n = `text`     v = `{SUBTITLE}`
                            )->a( n = `wrapping` v = `true` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.
    DATA temp1 LIKE t_items.
    DATA temp2 LIKE LINE OF temp1.

    slider_value = 100.
    
    CLEAR temp1.
    
    temp2-title = `Grid item title 1`.
    temp2-subtitle = `Subtitle 1`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 2`.
    temp2-subtitle = `Subtitle 2`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 3`.
    temp2-subtitle = `Subtitle 3`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 4`.
    temp2-subtitle = `Subtitle 4`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 5`.
    temp2-subtitle = `Subtitle 5`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 6 Grid item title Grid item title Grid item title Grid item title Grid item title`.
    temp2-subtitle = `Subtitle 6`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Very long Grid item title that should wrap 7`.
    temp2-subtitle = `This is a long subtitle 7`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title B 8`.
    temp2-subtitle = `Subtitle 8`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title B 9 Grid item title B  Grid item title B 9 Grid item title B 9Grid item title B 9title B 9 Grid item title B 9Grid item title B`.
    temp2-subtitle = `Subtitle 9`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title B 10`.
    temp2-subtitle = `Subtitle 10`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title B 11`.
    temp2-subtitle = `Subtitle 11`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title B 12`.
    temp2-subtitle = `Subtitle 12`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 13`.
    temp2-subtitle = `Subtitle 13`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 14`.
    temp2-subtitle = `Subtitle 14`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 15`.
    temp2-subtitle = `Subtitle 15`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 16`.
    temp2-subtitle = `Subtitle 16`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 17`.
    temp2-subtitle = `Subtitle 17`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 18`.
    temp2-subtitle = `Subtitle 18`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Very long Grid item title that should wrap 19`.
    temp2-subtitle = `This is a long subtitle 19`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title B 20`.
    temp2-subtitle = `Subtitle 20`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title B 21`.
    temp2-subtitle = `Subtitle 21`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title B 22`.
    temp2-subtitle = `Subtitle 22`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title B 23`.
    temp2-subtitle = `Subtitle 23`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title B 24`.
    temp2-subtitle = `Subtitle 24`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title B 21`.
    temp2-subtitle = `Subtitle 21`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title B 22`.
    temp2-subtitle = `Subtitle 22`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title B 23`.
    temp2-subtitle = `Subtitle 23`.
    INSERT temp2 INTO TABLE temp1.
    t_items = temp1.

  ENDMETHOD.

ENDCLASS.
