" @keywords gridlist grid list sap.f gridlistkeyboardarrowsnavigation app slider vbox title label
" @summary This sample demonstrates the keyboard navigation between multiple grids
CLASS z2ui5_cl_smpc_app_582 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_item,
             title TYPE string,
           END OF ty_s_item.
    TYPES ty_t_item TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.

    DATA t_items1 TYPE ty_t_item.
    DATA t_items2 TYPE ty_t_item.
    DATA t_items3 TYPE ty_t_item.
    DATA t_items4 TYPE ty_t_item.
    " the sample's onSliderMoved handler is replaced by a two-way binding: the
    " container width is an expression over the very property the slider writes
    DATA slider_value TYPE i VALUE 100.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_582 IMPLEMENTATION.

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

    DATA(page) = view->ele( n = `View` ns = `mvc`
        )->a( n = `height`        v = `100%`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `xmlns:f`       v = `sap.f`
        )->a( n = `xmlns:cssgrid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`

        )->ele( `App`
            )->ele( `Page`
                )->a( n = `class`      v = `sapUiResponsivePadding--content`
                )->a( n = `showHeader` v = `false` ).

    " the Reveal Grids toggle needs the sample's own RevealGrid helper (see
    " sidecar); the slider drives the container width through its bound property
    page->tag( `ToggleButton`
        )->a( n = `id`    v = `revealGrid`
        )->a( n = `text`  v = `Reveal Grids`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Slider`
            )->a( n = `value` v = client->_bind( slider_value ) ).

    DATA(container) = page->ele( n = `CSSGrid` ns = `cssgrid`
        )->a( n = `id`    v = `container`
        )->a( n = `width` v = |\{= ${ client->_bind( slider_value ) } + '%' \}|

        )->ele( n = `customLayout` ns = `cssgrid`
            )->ele( n = `GridResponsiveLayout` ns = `cssgrid`
                )->a( n = `containerQuery` v = `true`

                )->ele( n = `layout` ns = `cssgrid`
                    )->tag( n = `GridSettings` ns = `cssgrid`
                        )->a( n = `gridGap`             v = `1rem`
                        )->a( n = `gridTemplateColumns` v = `repeat(2, 1fr)`

                )->end(
                )->ele( n = `layoutS` ns = `cssgrid`
                    )->tag( n = `GridSettings` ns = `cssgrid`
                        )->a( n = `gridGap`             v = `1rem`
                        )->a( n = `gridTemplateColumns` v = `1fr`

                )->end(
            )->end(
        )->end( ).

    container->ele( n = `GridList` ns = `f`
        )->a( n = `id`             v = `gridList1`
        )->a( n = `headerText`     v = `GridList 1`
        )->a( n = `items`          v = client->_bind( t_items1 )
        " onBorderReached toasts the grid the focus left and then moves it into
        " the neighbouring one; only the toast can travel (see sidecar)
        )->a( n = `borderReached`  v = client->follow_up_action(
                  val   = client->cs_event-control_global
                  t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                   ( `show` )
                                   ( `Reached border of GridList 1` ) ) )

        )->ele( n = `customLayout` ns = `f`
            )->tag( n = `GridBasicLayout` ns = `cssgrid`
                )->a( n = `gridAutoRows`        v = `5rem`
                )->a( n = `gridTemplateColumns` v = `repeat(auto-fill, minmax(5rem, 1fr))`
                )->a( n = `gridGap`             v = `0.5rem`

        )->end(
        )->ele( n = `GridListItem` ns = `f`

            )->ele( n = `layoutData` ns = `f`
                )->tag( n = `GridItemLayoutData` ns = `cssgrid`
                    )->a( n = `gridRow`    v = `span 2`
                    )->a( n = `gridColumn` v = `span 2`

            )->end(
            )->ele( `VBox`
                )->a( n = `class` v = `sapUiSmallMargin`

                )->tag( `Title`
                    )->a( n = `text`     v = `{TITLE}`
                    )->a( n = `wrapping` v = `true`
                )->tag( `Label`
                    )->a( n = `text`     v = `Subtitle`
                    )->a( n = `wrapping` v = `true`

            )->end(
        )->end(
    )->end( ).

    container->ele( n = `GridList` ns = `f`
        )->a( n = `id`             v = `gridList2`
        )->a( n = `headerText`     v = `GridList 2`
        )->a( n = `items`          v = client->_bind( t_items2 )
        " onBorderReached toasts the grid the focus left and then moves it into
        " the neighbouring one; only the toast can travel (see sidecar)
        )->a( n = `borderReached`  v = client->follow_up_action(
                  val   = client->cs_event-control_global
                  t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                   ( `show` )
                                   ( `Reached border of GridList 2` ) ) )

        )->ele( n = `customLayout` ns = `f`
            )->tag( n = `GridBasicLayout` ns = `cssgrid`
                )->a( n = `gridAutoRows`        v = `5rem`
                )->a( n = `gridTemplateColumns` v = `repeat(auto-fill, minmax(5rem, 1fr))`
                )->a( n = `gridGap`             v = `0.5rem`

        )->end(
        )->ele( n = `GridListItem` ns = `f`

            )->ele( n = `layoutData` ns = `f`
                )->tag( n = `GridItemLayoutData` ns = `cssgrid`
                    )->a( n = `gridRow`    v = `span 1`
                    )->a( n = `gridColumn` v = `span 3`

            )->end(
            )->ele( `VBox`
                )->a( n = `class` v = `sapUiSmallMargin`

                )->tag( `Title`
                    )->a( n = `text`     v = `{TITLE}`
                    )->a( n = `wrapping` v = `true`
                )->tag( `Label`
                    )->a( n = `text`     v = `Subtitle`
                    )->a( n = `wrapping` v = `true`

            )->end(
        )->end(
    )->end( ).

    container->ele( n = `GridList` ns = `f`
        )->a( n = `id`             v = `gridList3`
        )->a( n = `headerText`     v = `GridList 3`
        )->a( n = `items`          v = client->_bind( t_items3 )
        " onBorderReached toasts the grid the focus left and then moves it into
        " the neighbouring one; only the toast can travel (see sidecar)
        )->a( n = `borderReached`  v = client->follow_up_action(
                  val   = client->cs_event-control_global
                  t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                   ( `show` )
                                   ( `Reached border of GridList 3` ) ) )

        )->ele( n = `customLayout` ns = `f`
            )->tag( n = `GridBasicLayout` ns = `cssgrid`
                )->a( n = `gridAutoRows`        v = `5rem`
                )->a( n = `gridTemplateColumns` v = `repeat(auto-fill, minmax(5rem, 1fr))`
                )->a( n = `gridGap`             v = `0.5rem`

        )->end(
        )->ele( n = `GridListItem` ns = `f`

            )->ele( n = `layoutData` ns = `f`
                )->tag( n = `GridItemLayoutData` ns = `cssgrid`
                    )->a( n = `gridRow`    v = `span 2`
                    )->a( n = `gridColumn` v = `span 3`

            )->end(
            )->ele( `VBox`
                )->a( n = `class` v = `sapUiSmallMargin`

                )->tag( `Title`
                    )->a( n = `text`     v = `{TITLE}`
                    )->a( n = `wrapping` v = `true`
                )->tag( `Label`
                    )->a( n = `text`     v = `Subtitle`
                    )->a( n = `wrapping` v = `true`

            )->end(
        )->end(
    )->end( ).

    container->ele( n = `GridList` ns = `f`
        )->a( n = `id`             v = `gridList4`
        )->a( n = `headerText`     v = `GridList 4`
        )->a( n = `items`          v = client->_bind( t_items4 )
        " onBorderReached toasts the grid the focus left and then moves it into
        " the neighbouring one; only the toast can travel (see sidecar)
        )->a( n = `borderReached`  v = client->follow_up_action(
                  val   = client->cs_event-control_global
                  t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                   ( `show` )
                                   ( `Reached border of GridList 4` ) ) )

        )->ele( n = `customLayout` ns = `f`
            )->tag( n = `GridBasicLayout` ns = `cssgrid`
                )->a( n = `gridAutoRows`        v = `5rem`
                )->a( n = `gridTemplateColumns` v = `repeat(auto-fill, minmax(5rem, 1fr))`
                )->a( n = `gridGap`             v = `0.5rem`

        )->end(
        )->ele( n = `GridListItem` ns = `f`

            )->ele( n = `layoutData` ns = `f`
                )->tag( n = `GridItemLayoutData` ns = `cssgrid`
                    )->a( n = `gridRow`    v = `span 3`
                    )->a( n = `gridColumn` v = `span 2`

            )->end(
            )->ele( `VBox`
                )->a( n = `class` v = `sapUiSmallMargin`

                )->tag( `Title`
                    )->a( n = `text`     v = `{TITLE}`
                    )->a( n = `wrapping` v = `true`
                )->tag( `Label`
                    )->a( n = `text`     v = `Subtitle`
                    )->a( n = `wrapping` v = `true`

            )->end(
        )->end(
    )->end( ).
    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " model/data.json - the four item lists. Only the title is bound by the item
    " template; the mock's subtitle, counter and type are not
    t_items1 = VALUE #( ( title = `Item 1` ) ( title = `Item 2` ) ( title = `Item 3` ) ( title = `Item 4` ) ).
    t_items2 = VALUE #( ( title = `Item 1` ) ( title = `Item 2` ) ( title = `Item 3` ) ( title = `Item 4` ) ).
    t_items3 = VALUE #( ( title = `Item 1` ) ( title = `Item 2` ) ( title = `Item 3` ) ( title = `Item 4` ) ( title = `Item 5` ) ).
    t_items4 = VALUE #( ( title = `Item 1` ) ( title = `Item 2` ) ( title = `Item 3` ) ( title = `Item 4` ) ( title = `Item 5` ) ).

  ENDMETHOD.

ENDCLASS.
