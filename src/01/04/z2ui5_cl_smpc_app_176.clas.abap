" @keywords gridlist grid list sap.f gridlistboxcontainergrouping slider panel toolbar title toolbarspacer searchfield vbox
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
    DATA t_items      TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.
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
                )->a( n = `items`            v = |\{ path: '{ client->_bind( val = t_items path = abap_true ) }', sorter: \{ path: 'GROUP', descending: false, group: true \} \}|
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

    slider_value = 100.
    t_items = VALUE #(
      ( title = `Grid item title 1` subtitle = `Subtitle 1` group = `Group A` )
      ( title = `Grid item title 2` subtitle = `Subtitle 2` group = `Group A` )
      ( title = `Grid item title 3` subtitle = `Subtitle 3` group = `Group A` )
      ( title = `Grid item title 4` subtitle = `Subtitle 4` group = `Group A` )
      ( title = `Grid item title 5` subtitle = `Subtitle 5` group = `Group A` )
      ( title = `Grid item title 6` subtitle = `Subtitle 6` group = `Group A` )
      ( title = `Grid item title 7` subtitle = `Subtitle 7` group = `Group A` )
      ( title = `Grid item title 8` subtitle = `Subtitle 8` group = `Group A` )
      ( title = `Grid item title 9` subtitle = `Subtitle 9` group = `Group A` )
      ( title = `Grid item title 10` subtitle = `Subtitle 10` group = `Group B` )
      ( title = `Grid item title 11` subtitle = `Subtitle 11` group = `Group B` )
      ( title = `Grid item title 12` subtitle = `Subtitle 12` group = `Group B` )
      ( title = `Grid item title 13` subtitle = `Subtitle 13` group = `Group B` )
      ( title = `Grid item title 14` subtitle = `Subtitle 14` group = `Group B` )
      ( title = `Grid item title 15` subtitle = `Subtitle 15` group = `Group B` )
      ( title = `Grid item title 16` subtitle = `Subtitle 16` group = `Group B` )
      ( title = `Grid item title 17` subtitle = `Subtitle 17` group = `Group B` )
      ( title = `Grid item title 18` subtitle = `Subtitle 18` group = `Group B` )
      ( title = `Grid item title 19 Grid item title 19 Grid item title 19 Grid item title 19 Grid item title 19 Grid item title 19 Grid item title 19 ` subtitle = `Subtitle 19` group = `Group B` )
      ( title = `Grid item title 20` subtitle = `Subtitle 20` group = `Group B` )
      ( title = `Grid item title 21` subtitle = `Subtitle 21` group = `Group B` )
      ( title = `Grid item title 22` subtitle = `Subtitle 22` group = `Group B` )
      ( title = `Grid item title 23` subtitle = `Subtitle 23` group = `Group B` )
      ( title = `Grid item title 24` subtitle = `Subtitle 24` group = `Group B` )
      ( title = `Grid item title 25` subtitle = `Subtitle 25` group = `Group B` )
      ( title = `Grid item title 26` subtitle = `Subtitle 26` group = `Group B` )
      ( title = `Grid item title 27` subtitle = `Subtitle 27` group = `Group B` )
    ).

  ENDMETHOD.

ENDCLASS.
