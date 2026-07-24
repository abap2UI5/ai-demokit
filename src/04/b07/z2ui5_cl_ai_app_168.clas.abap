CLASS z2ui5_cl_ai_app_168 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_city,
        text TYPE string,
        key  TYPE string,
      END OF ty_city.
    DATA cities TYPE STANDARD TABLE OF ty_city WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_prod,
        title        TYPE string,
        subtitle     TYPE string,
        revenue      TYPE string,
        status       TYPE string,
        statusschema TYPE string,
      END OF ty_prod.
    DATA productitems TYPE STANDARD TABLE OF ty_prod WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_168 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " The original binds two named models (cities>, products>) inside the cards;
    " abap2UI5 keeps one default model, so those bind directly ({cities>/cities}
    " -> {/CITIES}, {products>/productItems} -> {/PRODUCTITEMS}). The switches /
    " toggle / column-change / tile / card presses are controller handlers in
    " the original; here each raises a client toast.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`      v = `sap.f`
        )->a( n = `xmlns:card`   v = `sap.f.cards`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:w`      v = `sap.ui.integration.widgets`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `height`       v = `100%`

        )->open( `ScrollContainer`
            )->a( n = `height`   v = `100%`
            )->a( n = `width`    v = `100%`
            )->a( n = `vertical` v = `true`

            )->open( `ToggleButton`
                )->a( n = `id`    v = `revealGrid`
                )->a( n = `text`  v = `Reveal Grid`
                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Reveal Grid` ) ) )
                )->a( n = `class` v = `sapUiSmallMargin`

            )->shut(

            )->open( `Panel`
                )->a( n = `headerText` v = `Grid Container Properties`
                )->open( `HBox`
                    )->a( n = `alignItems` v = `Center`
                    )->leaf( `Label` )->a( n = `width` v = `8rem` )->a( n = `class` v = `sapUiSmallMarginBegin` )->a( n = `text` v = `Snap to Row:`
                    )->leaf( `Switch` )->a( n = `change` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Snap to row` ) ) ) )->a( n = `state` v = `false`
                    )->leaf( `Text` )->a( n = `class` v = `sapUiTinyMarginBeginEnd` )->a( n = `text` v = `(Should the items stretch to fill the rows which they occupy, or not. If turned on the items will stretch.)`

                )->shut(
                )->open( `HBox`
                    )->a( n = `alignItems` v = `Center`
                    )->leaf( `Label` )->a( n = `width` v = `8rem` )->a( n = `class` v = `sapUiSmallMarginBegin` )->a( n = `text` v = `Allow dense fill:`
                    )->leaf( `Switch` )->a( n = `change` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Allow dense fill` ) ) ) )->a( n = `state` v = `false`
                    )->leaf( `Text` )->a( n = `class` v = `sapUiTinyMarginBeginEnd` )->a( n = `text` v = `(Smaller items will take up all of the available space, ignoring their order.)`

                )->shut(
                )->open( `HBox`
                    )->a( n = `alignItems` v = `Center`
                    )->leaf( `Label` )->a( n = `width` v = `8rem` )->a( n = `class` v = `sapUiSmallMarginBegin` )->a( n = `text` v = `Inline block layout:`
                    )->leaf( `Switch` )->a( n = `change` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Inline block layout` ) ) ) )->a( n = `state` v = `false`
                    )->leaf( `Text` )->a( n = `class` v = `sapUiTinyMarginBeginEnd` )->a( n = `text` v = `(Makes the grid items act like an inline-block elements.)`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->leaf( `Text` )->a( n = `class` v = `sapUiSmallMarginBegin` )->a( n = `id` v = `columnsCountText`

            )->shut(

            )->open( n = `GridContainer` ns = `f`
                )->a( n = `id`            v = `demoGrid`
                )->a( n = `class`         v = `sapUiSmallMargin`
                )->a( n = `columnsChange` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Columns changed` ) ) )
                )->open( n = `layout` ns = `f`
                    )->leaf( n = `GridContainerSettings` ns = `f` )->a( n = `rowSize` v = `84px` )->a( n = `columnSize` v = `84px` )->a( n = `gap` v = `8px`

                )->shut(
                )->open( n = `layoutXS` ns = `f`
                    )->leaf( n = `GridContainerSettings` ns = `f` )->a( n = `rowSize` v = `70px` )->a( n = `columnSize` v = `70px` )->a( n = `gap` v = `8px`

                )->shut(

                    )->open( `GenericTile`
                        )->a( n = `header` v = `Sales Fulfillment Application Title`
                        )->a( n = `subheader` v = `Subtitle`
                        )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Tile pressed` ) ) )
                        )->open( `layoutData`
                            )->leaf( n = `GridContainerItemLayoutData` ns = `f` )->a( n = `minRows` v = `2` )->a( n = `columns` v = `2`

                        )->shut(
                        )->open( `TileContent`
                            )->a( n = `unit` v = `EUR`
                            )->a( n = `footer` v = `Current Quarter`
                            )->leaf( `ImageContent` )->a( n = `src` v = `sap-icon://home-share`

                        )->shut(
                    )->shut(

                    )->open( n = `Card` ns = `w`
                        )->a( n = `manifest` v = `test-resources/sap/f/demokit/sample/GridContainer/cardManifest.json`
                        )->open( n = `layoutData` ns = `w`
                            )->leaf( n = `GridContainerItemLayoutData` ns = `f` )->a( n = `minRows` v = `3` )->a( n = `columns` v = `4`

                        )->shut(
                    )->shut(

                    )->open( `GenericTile`
                        )->a( n = `header` v = `Manage Activity Master Data Type`
                        )->a( n = `subheader` v = `Subtitle`
                        )->open( `layoutData`
                            )->leaf( n = `GridContainerItemLayoutData` ns = `f` )->a( n = `minRows` v = `2` )->a( n = `columns` v = `2`

                        )->shut(
                        )->open( `TileContent`
                            )->leaf( `ImageContent` )->a( n = `src` v = `sap-icon://activities`

                        )->shut(
                    )->shut(

                    )->open( n = `Card` ns = `f`
                        )->open( n = `layoutData` ns = `f`
                            )->leaf( n = `GridContainerItemLayoutData` ns = `f` )->a( n = `columns` v = `4`

                        )->shut(
                        )->open( n = `header` ns = `f`
                            )->leaf( n = `Header` ns = `card`
                                )->a( n = `title`    v = `Buy bus ticket on-line`
                                )->a( n = `subtitle` v = `Buy a single drive ticket for a date`
                                )->a( n = `iconSrc`  v = `sap-icon://bus-public-transport`
                                )->a( n = `press`    v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Card pressed` ) ) )

                        )->shut(
                        )->open( n = `content` ns = `f`
                            )->open( `VBox`
                                )->a( n = `height`          v = `115px`
                                )->a( n = `class`           v = `sapUiSmallMargin`
                                )->a( n = `justifyContent`  v = `SpaceBetween`
                                )->open( `HBox`
                                    )->a( n = `justifyContent` v = `SpaceBetween`
                                    )->open( `ComboBox`
                                        )->a( n = `width`       v = `120px`
                                        )->a( n = `placeholder` v = `From City`
                                        )->a( n = `items`       v = client->_bind( cities )
                                        )->leaf( n = `Item` ns = `core` )->a( n = `key` v = `{KEY}` )->a( n = `text` v = `{TEXT}`

                                    )->shut(
                                    )->open( `ComboBox`
                                        )->a( n = `width`       v = `120px`
                                        )->a( n = `placeholder` v = `To City`
                                        )->a( n = `items`       v = client->_bind( cities )
                                        )->leaf( n = `Item` ns = `core` )->a( n = `key` v = `{KEY}` )->a( n = `text` v = `{TEXT}`

                                    )->shut(
                                )->shut(
                                )->open( `HBox`
                                    )->a( n = `justifyContent` v = `SpaceBetween`
                                    )->leaf( `DatePicker` )->a( n = `width` v = `186px` )->a( n = `placeholder` v = `Choose Date ...`
                                    )->leaf( `Button` )->a( n = `text` v = `Book` )->a( n = `type` v = `Emphasized`

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(

                    )->open( `Text`
                        )->a( n = `text` v = `Lorem ipsum dolor sit amet (content abbreviated from the original filler text)`
                        )->open( `layoutData`
                            )->leaf( n = `GridContainerItemLayoutData` ns = `f` )->a( n = `columns` v = `4`

                    )->shut(
                    )->shut(

                    )->open( `GenericTile`
                        )->a( n = `header` v = `Cumulative Totals`
                        )->a( n = `subheader` v = `Subtitle`
                        )->open( `layoutData`
                            )->leaf( n = `GridContainerItemLayoutData` ns = `f` )->a( n = `minRows` v = `2` )->a( n = `columns` v = `2`

                        )->shut(
                        )->open( `TileContent`
                            )->a( n = `unit` v = `Unit`
                            )->a( n = `footer` v = `Footer Text`
                            )->leaf( `NumericContent` )->a( n = `value` v = `12`

                        )->shut(
                    )->shut(

                    )->open( `GenericTile`
                        )->a( n = `header` v = `Travel and Expenses`
                        )->a( n = `subheader` v = `Access Concur`
                        )->open( `layoutData`
                            )->leaf( n = `GridContainerItemLayoutData` ns = `f` )->a( n = `minRows` v = `2` )->a( n = `columns` v = `2`

                        )->shut(
                        )->open( `TileContent`
                            )->leaf( `ImageContent` )->a( n = `src` v = `sap-icon://travel-expense`

                        )->shut(
                    )->shut(

                    )->open( n = `Card` ns = `f`
                        )->open( n = `layoutData` ns = `f`
                            )->leaf( n = `GridContainerItemLayoutData` ns = `f` )->a( n = `minRows` v = `4` )->a( n = `columns` v = `4`

                        )->shut(
                        )->open( n = `header` ns = `f`
                            )->leaf( n = `Header` ns = `card` )->a( n = `title` v = `Project Cloud Transformation` )->a( n = `subtitle` v = `Revenue per Product | EUR`

                        )->shut(
                        )->open( n = `content` ns = `f`
                            )->open( `List`
                                )->a( n = `showSeparators` v = `None`
                                )->a( n = `items`          v = client->_bind( productitems )
                                )->open( `CustomListItem`
                                    )->open( `HBox`
                                        )->a( n = `alignItems`     v = `Center`
                                        )->a( n = `justifyContent` v = `SpaceBetween`
                                        )->open( `VBox`
                                            )->a( n = `class` v = `sapUiSmallMarginBegin sapUiSmallMarginTopBottom`
                                            )->leaf( `Title` )->a( n = `level` v = `H3` )->a( n = `text` v = `{TITLE}`
                                            )->leaf( `Text` )->a( n = `text` v = `{SUBTITLE}`

                                        )->shut(
                                        )->leaf( `ObjectStatus` )->a( n = `class` v = `sapUiTinyMargin` )->a( n = `text` v = `{REVENUE}` )->a( n = `state` v = `{STATUSSCHEMA}`

                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(

                    )->open( `GenericTile`
                        )->a( n = `header` v = `Success Map`
                        )->a( n = `subheader` v = `Access Success Map`
                        )->open( `layoutData`
                            )->leaf( n = `GridContainerItemLayoutData` ns = `f` )->a( n = `minRows` v = `2` )->a( n = `columns` v = `2`

                        )->shut(
                        )->open( `TileContent`
                            )->a( n = `unit` v = `EUR`
                            )->a( n = `footer` v = `Current Quarter`
                            )->leaf( `ImageContent` )->a( n = `src` v = `sap-icon://map-3`

                        )->shut(
                    )->shut(

                    )->open( `GenericTile`
                        )->a( n = `header` v = `My Team Calendar`
                        )->open( `layoutData`
                            )->leaf( n = `GridContainerItemLayoutData` ns = `f` )->a( n = `minRows` v = `2` )->a( n = `columns` v = `2`

                        )->shut(
                        )->open( `TileContent`
                            )->a( n = `unit` v = `EUR`
                            )->a( n = `footer` v = `Current Quarter`
                            )->leaf( `ImageContent` )->a( n = `src` v = `sap-icon://check-availability`

                        )->shut(
                    )->shut(

                    )->open( `Text`
                        )->a( n = `text` v = `Lorem ipsum dolor sit amet (content abbreviated from the original filler text)`
                        )->open( `layoutData`
                            )->leaf( n = `GridContainerItemLayoutData` ns = `f` )->a( n = `columns` v = `4`

                    )->shut(
                    )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    cities = VALUE #(
      ( text = `Berlin` key = `BR` )
      ( text = `London` key = `LN` )
      ( text = `Madrid` key = `MD` )
      ( text = `Prague` key = `PR` )
      ( text = `Paris` key = `PS` )
      ( text = `Sofia` key = `SF` )
      ( text = `Vienna` key = `VN` )
    ).

    productitems = VALUE #(
      ( title = `Notebook HT` subtitle = `ID23452256-D44` revenue = `27.25K EUR` status = `success` statusschema = `Success` )
      ( title = `Notebook XT` subtitle = `ID27852256-D47` revenue = `7.35K EUR` status = `exceeded` statusschema = `Error` )
      ( title = `Notebook ST` subtitle = `ID123555587-I05` revenue = `22.89K EUR` status = `warning` statusschema = `Warning` )
    ).

  ENDMETHOD.

ENDCLASS.
