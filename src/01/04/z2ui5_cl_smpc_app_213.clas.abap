" @keywords gridlist grid list sap.f gridlistbreakpoints slider panel toolbar title gridresponsivelayout gridsettings gridlistitem
" @summary This sample illustrates how to configure the responsive settings for different container sizes.
CLASS z2ui5_cl_smpc_app_213 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_item,
        title    TYPE string,
        subtitle TYPE string,
      END OF ty_item.
    DATA t_items      TYPE STANDARD TABLE OF ty_item WITH DEFAULT KEY.
    DATA slider_value TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_213 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Layout changed to {0}` INTO TABLE temp1.
    INSERT `${$parameters>/layout}` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:f`    v = `sap.f`

        )->tag( `Slider`
            )->a( n = `value` v = client->_bind( slider_value )

        )->ele( `Panel`
            )->a( n = `id`               v = `panelForGridList`
            )->a( n = `backgroundDesign` v = `Transparent`
            )->a( n = `width`            v = |\{= ${ client->_bind( slider_value ) } + '%' \}|

            )->ele( `headerToolbar`
                )->ele( `Toolbar`
                    )->a( n = `height` v = `3rem`

                    )->tag( `Title`
                        )->a( n = `text` v = `GridList with break point S, M, L, XL`

                )->end(
            )->end(

            )->ele( n = `GridList` ns = `f`
                )->a( n = `id`         v = `gridList`
                )->a( n = `headerText` v = `GridList header`
                )->a( n = `items`      v = client->_bind( t_items )

                )->ele( n = `customLayout` ns = `f`
                    )->ele( n = `GridResponsiveLayout` ns = `grid`
                        )->a( n = `layoutChange` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp1 )

                        )->ele( n = `layoutS` ns = `grid`
                            )->tag( n = `GridSettings` ns = `grid`
                                )->a( n = `gridTemplateColumns` v = `repeat(auto-fit, 8rem)`
                                )->a( n = `gridGap`             v = `0.25rem 0.25rem`

                        )->end(
                        )->ele( n = `layoutM` ns = `grid`
                            )->tag( n = `GridSettings` ns = `grid`
                                )->a( n = `gridTemplateColumns` v = `repeat(auto-fit, 12rem)`
                                )->a( n = `gridGap`             v = `0.5rem 0.5rem`

                        )->end(
                        )->ele( n = `layoutL` ns = `grid`
                            )->tag( n = `GridSettings` ns = `grid`
                                )->a( n = `gridTemplateColumns` v = `repeat(auto-fit, 16rem)`
                                )->a( n = `gridGap`             v = `0.75rem 0.75rem`

                        )->end(
                        )->ele( n = `layoutXL` ns = `grid`
                            )->tag( n = `GridSettings` ns = `grid`
                                )->a( n = `gridTemplateColumns` v = `repeat(auto-fit, 20rem)`
                                )->a( n = `gridGap`             v = `1rem 1rem`

                        )->end(
                    )->end(
                )->end(

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
    DATA temp3 LIKE t_items.
    DATA temp4 LIKE LINE OF temp3.

    slider_value = 100.

    " Grid items inlined from the sample's model/items.json (27 rows).
    
    CLEAR temp3.
    
    temp4-title = `Grid item title 1`.
    temp4-subtitle = `Subtitle 1`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title 2`.
    temp4-subtitle = `Subtitle 2`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title 3`.
    temp4-subtitle = `Subtitle 3`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title 4`.
    temp4-subtitle = `Subtitle 4`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title 5`.
    temp4-subtitle = `Subtitle 5`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title 6 Grid item title Grid item title Grid item title Grid item title Grid item title`.
    temp4-subtitle = `Subtitle 6`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Very long Grid item title that should wrap 7`.
    temp4-subtitle = `This is a long subtitle 7`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title B 8`.
    temp4-subtitle = `Subtitle 8`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title B 9 Grid item title B  Grid item title B 9 Grid item title B 9Grid item title B 9title B 9 Grid item title B 9Grid item title B`.
    temp4-subtitle = `Subtitle 9`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title B 10`.
    temp4-subtitle = `Subtitle 10`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title B 11`.
    temp4-subtitle = `Subtitle 11`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title B 12`.
    temp4-subtitle = `Subtitle 12`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title 13`.
    temp4-subtitle = `Subtitle 13`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title 14`.
    temp4-subtitle = `Subtitle 14`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title 15`.
    temp4-subtitle = `Subtitle 15`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title 16`.
    temp4-subtitle = `Subtitle 16`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title 17`.
    temp4-subtitle = `Subtitle 17`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title 18`.
    temp4-subtitle = `Subtitle 18`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Very long Grid item title that should wrap 19`.
    temp4-subtitle = `This is a long subtitle 19`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title B 20`.
    temp4-subtitle = `Subtitle 20`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title B 21`.
    temp4-subtitle = `Subtitle 21`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title B 22`.
    temp4-subtitle = `Subtitle 22`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title B 23`.
    temp4-subtitle = `Subtitle 23`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title B 24`.
    temp4-subtitle = `Subtitle 24`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title B 21`.
    temp4-subtitle = `Subtitle 21`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title B 22`.
    temp4-subtitle = `Subtitle 22`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Grid item title B 23`.
    temp4-subtitle = `Subtitle 23`.
    INSERT temp4 INTO TABLE temp3.
    t_items = temp3.

  ENDMETHOD.

ENDCLASS.
