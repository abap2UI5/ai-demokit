CLASS z2ui5_cl_smpc_app_526 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_row,
             name        TYPE string,
             description TYPE string,
             icon        TYPE string,
             state       TYPE string,
             info        TYPE string,
             infostate   TYPE string,
             title       TYPE string,
           END OF ty_s_row.
    TYPES ty_t_row TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

    DATA t_order    TYPE string_table.
    DATA t_contacts TYPE ty_t_row.
    DATA t_products TYPE ty_t_row.
    DATA t_tasks    TYPE ty_t_row.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_526 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    DATA(scroll) = view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`       v = `sap.f`
        )->a( n = `xmlns:card`    v = `sap.f.cards`
        )->a( n = `xmlns:dnd`     v = `sap.ui.core.dnd`
        )->a( n = `xmlns:dndgrid` v = `sap.f.dnd`
        )->a( n = `displayBlock`  v = `true`
        )->a( n = `height`        v = `100%`

        )->ele( `ScrollContainer`
            )->a( n = `height`   v = `100%`
            )->a( n = `width`    v = `100%`
            )->a( n = `vertical` v = `true` ).

    " press wire dropped (declared): RevealGrid is a sample-local JS helper
    " module (grid outline overlay) with no declarative equivalent
    scroll->tag( `ToggleButton`
        )->a( n = `id`    v = `revealGrid`
        )->a( n = `text`  v = `Reveal Grid`
        )->a( n = `class` v = `sapUiSmallMarginBegin sapUiSmallMarginTop sapUiTinyMarginBottom` ).

    DATA(grid) = scroll->ele( n = `GridContainer` ns = `f`
        )->a( n = `id`        v = `grid1`
        )->a( n = `class`     v = `sapUiSmallMargin`
        )->a( n = `snapToRow` v = `true` ).

    grid->ele( n = `dragDropConfig` ns = `f`
        )->tag( n = `DragInfo` ns = `dnd`
            )->a( n = `sourceAggregation` v = `items`
        )->tag( n = `GridDropInfo` ns = `dndgrid`
            )->a( n = `targetAggregation` v = `items`
            )->a( n = `dropPosition`      v = `Between`
            )->a( n = `dropLayout`        v = `Horizontal`
            " the drop handler reorders the grid items; the port sends the two
            " indices and the position and reorders the ORDER table in ABAP
            )->a( n = `drop`              v = client->_event( val   = `DROP`
                                                              t_arg = VALUE #(
                                                                ( `${$parameters>/draggedControl/oParent}.indexOfItem(${$parameters>/draggedControl})` )
                                                                ( `${$parameters>/droppedControl} ? ${$parameters>/droppedControl/oParent}.indexOfItem(${$parameters>/droppedControl}) : -1` )
                                                                ( `${$parameters>/dropPosition}` ) ) ) ).

    grid->ele( n = `layout` ns = `f`
        )->tag( n = `GridContainerSettings` ns = `f`
            )->a( n = `rowSize`    v = `84px`
            )->a( n = `columnSize` v = `84px`
            )->a( n = `gap`        v = `8px` ).

    grid->ele( n = `layoutXS` ns = `f`
        )->tag( n = `GridContainerSettings` ns = `f`
            )->a( n = `rowSize`    v = `70px`
            )->a( n = `columnSize` v = `70px`
            )->a( n = `gap`        v = `8px` ).

    " the ten grid children are STATIC in the original and the drop handler
    " reorders them in place; the port emits them in the order t_order holds,
    " which is what the drop round-trip rewrites
    LOOP AT t_order INTO DATA(key).

      CASE key.

        WHEN `tile_sales`.
          DATA(tile) = grid->ele( `GenericTile`
              )->a( n = `header`    v = `Sales Fulfillment Application Title`
              )->a( n = `subheader` v = `Subtitle` ).
          tile->ele( `layoutData`
              )->tag( n = `GridContainerItemLayoutData` ns = `f`
                  )->a( n = `minRows` v = `2`
                  )->a( n = `columns` v = `2` ).
          tile->ele( `TileContent`
              )->a( n = `unit`   v = `EUR`
              )->a( n = `footer` v = `Current Quarter`
              )->tag( `ImageContent`
                  )->a( n = `src` v = `sap-icon://home-share` ).

        WHEN `tile_activity`.
          tile = grid->ele( `GenericTile`
              )->a( n = `header`    v = `Manage Activity Master Data Type`
              )->a( n = `subheader` v = `Subtitle` ).
          tile->ele( `layoutData`
              )->tag( n = `GridContainerItemLayoutData` ns = `f`
                  )->a( n = `minRows` v = `2`
                  )->a( n = `columns` v = `2` ).
          tile->ele( `TileContent`
              )->tag( `ImageContent`
                  )->a( n = `src` v = `sap-icon://activities` ).

        WHEN `card_medium`.
          DATA(card) = grid->ele( n = `Card` ns = `f` ).
          card->ele( n = `layoutData` ns = `f`
              )->tag( n = `GridContainerItemLayoutData` ns = `f`
                  )->a( n = `minRows` v = `4`
                  )->a( n = `columns` v = `3` ).
          card->ele( n = `header` ns = `f`
              )->tag( n = `Header` ns = `card`
                  )->a( n = `title`    v = `Contacts`
                  )->a( n = `subtitle` v = `Recent`
                  )->a( n = `iconSrc`  v = `sap-icon://activities` ).
          card->ele( n = `content` ns = `f`
              )->ele( `List`
                  )->a( n = `showSeparators` v = `None`
                  )->a( n = `items`          v = client->_bind( t_contacts )
                  )->tag( `StandardListItem`
                      )->a( n = `title` v = `{TITLE}`
                      )->a( n = `icon`  v = `{ICON}` ).

        WHEN `card_large`.
          card = grid->ele( n = `Card` ns = `f` ).
          card->ele( n = `layoutData` ns = `f`
              )->tag( n = `GridContainerItemLayoutData` ns = `f`
                  )->a( n = `minRows` v = `4`
                  )->a( n = `columns` v = `4` ).
          card->ele( n = `header` ns = `f`
              )->tag( n = `Header` ns = `card`
                  )->a( n = `title`      v = `Request list content Card`
                  )->a( n = `subtitle`   v = `Card subtitle`
                  )->a( n = `iconSrc`    v = `sap-icon://accept`
                  )->a( n = `statusText` v = `100 of 200` ).
          card->ele( n = `content` ns = `f`
              )->ele( `List`
                  )->a( n = `showSeparators` v = `None`
                  )->a( n = `items`          v = client->_bind( t_products )
                  )->tag( `StandardListItem`
                      )->a( n = `title`       v = `{NAME}`
                      )->a( n = `description` v = `{DESCRIPTION}`
                      )->a( n = `icon`        v = `{ICON}`
                      )->a( n = `highlight`   v = `{STATE}`
                      )->a( n = `info`        v = `{INFO}`
                      )->a( n = `infoState`   v = `{INFOSTATE}` ).

        WHEN `card_small`.
          card = grid->ele( n = `Card` ns = `f` ).
          card->ele( n = `layoutData` ns = `f`
              )->tag( n = `GridContainerItemLayoutData` ns = `f`
                  )->a( n = `minRows` v = `2`
                  )->a( n = `columns` v = `2` ).
          card->ele( n = `header` ns = `f`
              )->tag( n = `Header` ns = `card`
                  )->a( n = `title`    v = `Tasks`
                  )->a( n = `subtitle` v = `Upcoming`
                  )->a( n = `iconSrc`  v = `sap-icon://activities` ).
          card->ele( n = `content` ns = `f`
              )->ele( `List`
                  )->a( n = `showSeparators` v = `None`
                  )->a( n = `items`          v = client->_bind( t_tasks )
                  )->tag( `StandardListItem`
                      )->a( n = `title`     v = `{TITLE}`
                      )->a( n = `icon`      v = `{ICON}`
                      )->a( n = `infoState` v = `{INFOSTATE}` ).

        WHEN `tile_totals`.
          tile = grid->ele( `GenericTile`
              )->a( n = `header`    v = `Cumulative Totals`
              )->a( n = `subheader` v = `Subtitle` ).
          tile->ele( `layoutData`
              )->tag( n = `GridContainerItemLayoutData` ns = `f`
                  )->a( n = `minRows` v = `2`
                  )->a( n = `columns` v = `2` ).
          tile->ele( `TileContent`
              )->a( n = `unit`   v = `Unit`
              )->a( n = `footer` v = `Footer Text`
              )->tag( `NumericContent`
                  )->a( n = `value` v = `12` ).

        WHEN `tile_travel`.
          tile = grid->ele( `GenericTile`
              )->a( n = `header`    v = `Travel and Expenses`
              )->a( n = `subheader` v = `Access Concur` ).
          tile->ele( `layoutData`
              )->tag( n = `GridContainerItemLayoutData` ns = `f`
                  )->a( n = `minRows` v = `2`
                  )->a( n = `columns` v = `2` ).
          tile->ele( `TileContent`
              )->tag( `ImageContent`
                  )->a( n = `src` v = `sap-icon://travel-expense` ).

        WHEN `tile_success`.
          tile = grid->ele( `GenericTile`
              )->a( n = `header`    v = `Success Map`
              )->a( n = `subheader` v = `Access Success Map` ).
          tile->ele( `layoutData`
              )->tag( n = `GridContainerItemLayoutData` ns = `f`
                  )->a( n = `minRows` v = `2`
                  )->a( n = `columns` v = `2` ).
          tile->ele( `TileContent`
              )->a( n = `unit`   v = `EUR`
              )->a( n = `footer` v = `Current Quarter`
              )->tag( `ImageContent`
                  )->a( n = `src` v = `sap-icon://map-3` ).

        WHEN `text_some`.
          DATA(text) = grid->ele( `Text`
              )->a( n = `text` v = `Some text` ).
          text->ele( `layoutData`
              )->tag( n = `GridContainerItemLayoutData` ns = `f`
                  )->a( n = `minRows` v = `2`
                  )->a( n = `columns` v = `2` ).

        WHEN `tile_calendar`.
          tile = grid->ele( `GenericTile`
              )->a( n = `header` v = `My Team Calendar` ).
          tile->ele( `layoutData`
              )->tag( n = `GridContainerItemLayoutData` ns = `f`
                  )->a( n = `minRows` v = `2`
                  )->a( n = `columns` v = `2` ).
          tile->ele( `TileContent`
              )->a( n = `unit`   v = `EUR`
              )->a( n = `footer` v = `Current Quarter`
              )->tag( `ImageContent`
                  )->a( n = `src` v = `sap-icon://check-availability` ).

      ENDCASE.

    ENDLOOP.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `DROP`.

      DATA(drag_index)    = CONV i( client->get_event_arg( ) ).
      DATA(drop_index)    = CONV i( client->get_event_arg( 2 ) ).
      DATA(drop_position) = client->get_event_arg( 3 ).

      IF drag_index >= 0 AND drag_index < lines( t_order ).

        " the drop handler's own index arithmetic, 1:1
        DATA(key) = t_order[ drag_index + 1 ].
        DELETE t_order INDEX drag_index + 1.

        IF drag_index < drop_index.
          drop_index = drop_index - 1.
        ENDIF.
        IF drop_position = `After`.
          drop_index = drop_index + 1.
        ENDIF.
        IF drop_index < 0 OR drop_index > lines( t_order ).
          drop_index = lines( t_order ).
        ENDIF.

        INSERT key INTO t_order INDEX drop_index + 1.

        " the ten children are emitted from t_order, so the reordered view has
        " to be sent again - the model alone carries none of this (app 436 idiom)
        view_display( ).

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    t_order = VALUE #( ( `tile_sales` ) ( `tile_activity` ) ( `card_medium` ) ( `card_large` ) ( `card_small` )
                       ( `tile_totals` ) ( `tile_travel` ) ( `tile_success` ) ( `text_some` ) ( `tile_calendar` ) ).

    " cardManifests.json listContent/mediumList - the Contacts card's six rows
    t_contacts = VALUE #(
      ( title = `Alain Chevalier`  icon = `sap-icon://person-placeholder` )
      ( title = `Monique Legrand`  icon = `sap-icon://account` )
      ( title = `Elena Petrova`    icon = `sap-icon://business-card` )
      ( title = `Monique Legrand`  icon = `sap-icon://account` )
      ( title = `Alain Chevalier`  icon = `sap-icon://account` )
      ( title = `Elena Petrova`    icon = `sap-icon://business-card` ) ).

    " listContent/largeList - maxItems is 7, so the eighth row of the manifest
    " never reaches the card and is not seeded here either
    t_products = VALUE #(
      ( name = `Notebook Basic 15`
        description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`
        state = `Information` info = `27.45 EUR` infostate = `Success` )
      ( name = `Notebook Basic 17`
        description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`
        state = `Success` info = `27.45 EUR` infostate = `Success` )
      ( name = `Notebook Basic 18`
        description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`
        state = `Warning` info = `9.45 EUR` infostate = `Error` )
      ( name = `Notebook Basic 19`
        description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`
        state = `Error` info = `9.45 EUR` infostate = `Error` )
      ( name = `ITelO Vault`
        description = `Digital Organizer with State-of-the-Art Storage Encryption`
        state = `Success` info = `29.45 EUR` infostate = `Success` )
      ( name = `Notebook Professional 15`
        description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - ` &&
                      `DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`
        state = `Success` info = `29.45 EUR` infostate = `Success` )
      ( name = `Notebook Professional 26`
        description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - ` &&
                      `DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`
        state = `Success` info = `29.45 EUR` infostate = `Success` ) ).

    " listContent/smallList - the Tasks card's two rows
    t_tasks = VALUE #(
      ( title = `Call Simone`     icon = `sap-icon://call`  infostate = `Error` )
      ( title = `Write to Elena`  icon = `sap-icon://email` infostate = `Warning` ) ).

  ENDMETHOD.

ENDCLASS.
