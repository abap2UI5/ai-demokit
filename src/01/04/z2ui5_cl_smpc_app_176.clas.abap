" @keywords gridlist grid list sap.f gridlistboxcontainergrouping slider panel toolbar title toolbarspacer searchfield gridboxlayout
" @summary This sample illustrates subgroups with headers, custom header and lazy loading of GridList items.
CLASS z2ui5_cl_smpc_app_176 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_item,
        title    TYPE string,
        subtitle TYPE string,
        group    TYPE string,
      END OF ty_s_item.
    DATA t_items      TYPE STANDARD TABLE OF ty_s_item WITH DEFAULT KEY.
    DATA slider_value TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_176 IMPLEMENTATION.

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
                        )->a( n = `text` v = `GridList with GridBoxLayout`

                )->end(
            )->end(

            )->ele( n = `GridList` ns = `f`
                )->a( n = `id`               v = `gridList`
                )->a( n = `items`            v = |\{ path: '{ client->_bind_path( t_items ) }', sorter: \{ path: 'GROUP', descending: false, group: true \} \}|
                )->a( n = `growing`          v = `true`
                )->a( n = `growingThreshold` v = `9`

                )->ele( n = `headerToolbar` ns = `f`
                    )->ele( `Toolbar`
                        )->tag( `Title`
                            )->a( n = `text` v = `GridList, using custom header with SearchField`
                        )->tag( `ToolbarSpacer`
                        )->tag( `SearchField`
                            )->a( n = `width` v = `15rem`

                    )->end(
                )->end(

                )->ele( n = `customLayout` ns = `f`
                    )->tag( n = `GridBoxLayout` ns = `grid`

                )->end(

                )->ele( n = `GridListItem` ns = `f`
                    )->ele( `VBox`
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
    temp2-group = `Group A`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 2`.
    temp2-subtitle = `Subtitle 2`.
    temp2-group = `Group A`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 3`.
    temp2-subtitle = `Subtitle 3`.
    temp2-group = `Group A`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 4`.
    temp2-subtitle = `Subtitle 4`.
    temp2-group = `Group A`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 5`.
    temp2-subtitle = `Subtitle 5`.
    temp2-group = `Group A`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 6`.
    temp2-subtitle = `Subtitle 6`.
    temp2-group = `Group A`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 7`.
    temp2-subtitle = `Subtitle 7`.
    temp2-group = `Group A`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 8`.
    temp2-subtitle = `Subtitle 8`.
    temp2-group = `Group A`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 9`.
    temp2-subtitle = `Subtitle 9`.
    temp2-group = `Group A`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 10`.
    temp2-subtitle = `Subtitle 10`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 11`.
    temp2-subtitle = `Subtitle 11`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 12`.
    temp2-subtitle = `Subtitle 12`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 13`.
    temp2-subtitle = `Subtitle 13`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 14`.
    temp2-subtitle = `Subtitle 14`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 15`.
    temp2-subtitle = `Subtitle 15`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 16`.
    temp2-subtitle = `Subtitle 16`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 17`.
    temp2-subtitle = `Subtitle 17`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 18`.
    temp2-subtitle = `Subtitle 18`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 19 Grid item title 19 Grid item title 19 Grid item title 19 Grid item title 19 Grid item title 19 Grid item title 19 `.
    temp2-subtitle = `Subtitle 19`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 20`.
    temp2-subtitle = `Subtitle 20`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 21`.
    temp2-subtitle = `Subtitle 21`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 22`.
    temp2-subtitle = `Subtitle 22`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 23`.
    temp2-subtitle = `Subtitle 23`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 24`.
    temp2-subtitle = `Subtitle 24`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 25`.
    temp2-subtitle = `Subtitle 25`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 26`.
    temp2-subtitle = `Subtitle 26`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Grid item title 27`.
    temp2-subtitle = `Subtitle 27`.
    temp2-group = `Group B`.
    INSERT temp2 INTO TABLE temp1.
    t_items = temp1.

  ENDMETHOD.

ENDCLASS.
