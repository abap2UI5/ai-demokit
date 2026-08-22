" @keywords generictile sap.m generictilelinemode linemode slidetile tilecontent numericcontent newscontent linktilecontent sizebehavior scope
CLASS z2ui5_cl_smpc_app_606 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_tile,
             title    TYPE string,
             subtitle TYPE string,
             footer   TYPE string,
             unit     TYPE string,
             kpivalue TYPE string,
             scale    TYPE string,
             state    TYPE string,
             color    TYPE string,
             trend    TYPE string,
           END OF ty_s_tile.
    TYPES ty_t_tile TYPE STANDARD TABLE OF ty_s_tile WITH EMPTY KEY.

    TYPES: BEGIN OF ty_s_link_content,
             iconsrc  TYPE string,
             linktext TYPE string,
             linkhref TYPE string,
           END OF ty_s_link_content.
    TYPES: BEGIN OF ty_s_link_tile,
             title    TYPE string,
             contents TYPE STANDARD TABLE OF ty_s_link_content WITH EMPTY KEY,
           END OF ty_s_link_tile.
    TYPES ty_t_link_tile TYPE STANDARD TABLE OF ty_s_link_tile WITH EMPTY KEY.

    TYPES: BEGIN OF ty_s_slide,
             backgroundimage TYPE string,
             footer          TYPE string,
             contenttext     TYPE string,
             subtitle        TYPE string,
             state           TYPE string,
             tooltip         TYPE string,
           END OF ty_s_slide.
    TYPES ty_t_slide TYPE STANDARD TABLE OF ty_s_slide WITH EMPTY KEY.

    TYPES: BEGIN OF ty_s_scope,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_scope.
    TYPES ty_t_scope TYPE STANDARD TABLE OF ty_s_scope WITH EMPTY KEY.

    DATA t_tiles       TYPE ty_t_tile.
    DATA t_link_tiles  TYPE ty_t_link_tile.
    DATA t_slide1      TYPE ty_t_slide.
    DATA t_slide2      TYPE ty_t_slide.
    DATA t_scopes      TYPE ty_t_scope.

    DATA scope         TYPE string.
    DATA size_behavior TYPE string.
    DATA enforce_small TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_606 IMPLEMENTATION.

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

    DATA(page) = view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`

        )->ele( `Page`
            )->a( n = `showHeader` v = `true` ).

    page->ele( `customHeader`
        )->ele( `OverflowToolbar`
            )->tag( `ToolbarSpacer`
            )->tag( `Label`
                )->a( n = `text` v = `Enforce small size:`
            " changeEnforceSmall writes /sizeBehavior; both halves are bindable,
            " so the Switch and the tiles share one flag and one expression
            )->tag( `Switch`
                )->a( n = `id`     v = `enforceSmallSwitch`
                )->a( n = `state`  v = client->_bind( enforce_small )
                )->a( n = `change` v = client->_event( `ENFORCE_SMALL` )
            )->tag( `Label`
                )->a( n = `text` v = `Tile Actions:`
            )->ele( `ComboBox`
                )->a( n = `selectedKey` v = client->_bind( scope )
                )->a( n = `items`       v = client->_bind( t_scopes )
                )->ele( `items`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `{KEY}`
                        )->a( n = `text` v = `{TEXT}`
                )->end(
            )->end(
        )->end(
    )->end( ).

    DATA(content) = page->ele( `content` ).

    content->tag( `MessageStrip`
        )->a( n = `showIcon` v = `true`
        )->a( n = `type`     v = `Information`
        )->a( n = `text`     v = `Compare same content of Generic Tiles in regular and in line mode; no line mode equivalent for Slide Tile.`
        )->a( n = `class`    v = `sapUiTinyMargin` ).

    DATA(box) = content->ele( `VBox`
        )->a( n = `class` v = `sapUiTinyMargin` ).

    box->ele( n = `HorizontalLayout` ns = `l`
        )->a( n = `id`            v = `TileContainerExpanded`
        )->a( n = `allowWrapping` v = `true`
        )->a( n = `content`       v = client->_bind( t_tiles )
        )->a( n = `class`         v = `sapUiTinyMarginTopBottom`

        )->ele( `GenericTile`
            )->a( n = `header`       v = `{TITLE}`
            )->a( n = `subheader`    v = `{SUBTITLE}`
            )->a( n = `state`        v = `{STATE}`
            )->a( n = `scope`        v = client->_bind( scope )
            )->a( n = `press`        v = client->_event( val   = `TILE_PRESS`
                                                          t_arg = VALUE #( ( `\${\$source>/header}` ) ( `\${\$parameters>/action}` ) ) )
            )->a( n = `class`        v = `sapUiTinyMarginEnd`
            )->a( n = `sizeBehavior` v = client->_bind( size_behavior )

            )->ele( `TileContent`
                )->a( n = `unit`   v = `{UNIT}`
                )->a( n = `footer` v = `{FOOTER}`
                )->tag( `NumericContent`
                    )->a( n = `withMargin`  v = `false`
                    )->a( n = `value`       v = `{KPIVALUE}`
                    )->a( n = `valueColor`  v = `{COLOR}`
                    )->a( n = `indicator`   v = `{TREND}`
                    )->a( n = `scale`       v = `{SCALE}`
            )->end(
        )->end(
    )->end( ).

    box->ele( n = `HorizontalLayout` ns = `l`
        )->a( n = `id`            v = `LinkTiles`
        )->a( n = `allowWrapping` v = `true`
        )->a( n = `content`       v = client->_bind( t_link_tiles )
        )->a( n = `class`         v = `sapUiTinyMarginTopBottom`

        )->ele( `GenericTile`
            )->a( n = `header`           v = `{TITLE}`
            )->a( n = `frameType`        v = `TwoByOne`
            )->a( n = `linkTileContents` v = `{CONTENTS}`

            )->ele( `linkTileContents`
                )->tag( `LinkTileContent`
                    )->a( n = `iconSrc`   v = `{ICONSRC}`
                    )->a( n = `linkText`  v = `{LINKTEXT}`
                    )->a( n = `linkHref`  v = `{LINKHREF}`
                    )->a( n = `linkPress` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                         t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed on Link` ) ) )
            )->end(
        )->end(
    )->end( ).

    DATA(slides) = box->ele( n = `HorizontalLayout` ns = `l`
        )->a( n = `id`            v = `SlideTileContainer`
        )->a( n = `allowWrapping` v = `true`
        )->a( n = `class`         v = `sapUiTinyMarginTopBottom` ).

    slides->ele( `SlideTile`
        )->a( n = `id`           v = `slideTile1`
        )->a( n = `tiles`        v = client->_bind( t_slide1 )
        )->a( n = `scope`        v = |\{= ${ client->_bind( scope ) } === 'Actions' ? 'Actions' : 'Display' \}|
        )->a( n = `tooltip`      v = `SlideTile 1`
        )->a( n = `press`        v = client->_event( val   = `SLIDE_PRESS`
                                                      t_arg = VALUE #( ( `SlideTile 1` ) ( `\${\$parameters>/action}` ) ) )
        )->a( n = `class`        v = `sapUiTinyMarginEnd`
        )->a( n = `sizeBehavior` v = client->_bind( size_behavior )

        )->ele( `GenericTile`
            )->a( n = `id`              v = `tile6`
            )->a( n = `backgroundImage` v = `{BACKGROUNDIMAGE}`
            )->a( n = `state`           v = `{STATE}`
            )->a( n = `tooltip`         v = `{TOOLTIP}`
            )->a( n = `frameType`       v = `TwoByOne`
            )->a( n = `press`           v = client->_event( val   = `TILE_PRESS`
                                                             t_arg = VALUE #( ( `\${\$source>/tooltip}` ) ( `\${\$parameters>/action}` ) ) )
            )->a( n = `sizeBehavior`    v = client->_bind( size_behavior )

            )->ele( `TileContent`
                )->a( n = `footer` v = `{FOOTER}`
                )->tag( `NewsContent`
                    )->a( n = `contentText` v = `{CONTENTTEXT}`
                    )->a( n = `subheader`   v = `{SUBTITLE}`
            )->end(
        )->end(
    )->end( ).

    slides->ele( `SlideTile`
        )->a( n = `id`             v = `slideTile2`
        )->a( n = `tiles`          v = client->_bind( t_slide2 )
        )->a( n = `scope`          v = |\{= ${ client->_bind( scope ) } === 'Actions' ? 'Actions' : 'Display' \}|
        )->a( n = `tooltip`        v = `SlideTile 2`
        )->a( n = `press`          v = client->_event( val   = `SLIDE_PRESS`
                                                        t_arg = VALUE #( ( `SlideTile 2` ) ( `\${\$parameters>/action}` ) ) )
        )->a( n = `transitionTime` v = `250`
        )->a( n = `displayTime`    v = `2500`
        )->a( n = `sizeBehavior`   v = client->_bind( size_behavior )

        )->ele( `GenericTile`
            )->a( n = `id`              v = `tile7`
            )->a( n = `backgroundImage` v = `{BACKGROUNDIMAGE}`
            )->a( n = `state`           v = `{STATE}`
            )->a( n = `tooltip`         v = `{TOOLTIP}`
            )->a( n = `frameType`       v = `TwoByOne`
            )->a( n = `press`           v = client->_event( val   = `TILE_PRESS`
                                                             t_arg = VALUE #( ( `\${\$source>/tooltip}` ) ( `\${\$parameters>/action}` ) ) )
            )->a( n = `sizeBehavior`    v = client->_bind( size_behavior )

            )->ele( `TileContent`
                )->a( n = `footer` v = `{FOOTER}`
                )->tag( `NewsContent`
                    )->a( n = `contentText` v = `{CONTENTTEXT}`
                    )->a( n = `subheader`   v = `{SUBTITLE}`
            )->end(
        )->end(
    )->end( ).

    box->ele( n = `HorizontalLayout` ns = `l`
        )->a( n = `id`            v = `tileContainerCollapsed`
        )->a( n = `allowWrapping` v = `true`
        )->a( n = `content`       v = client->_bind( t_tiles )
        )->a( n = `class`         v = `sapMSampleTileContainer`

        )->ele( `GenericTile`
            )->a( n = `id`           v = `tile4`
            )->a( n = `header`       v = `{TITLE}`
            )->a( n = `subheader`    v = `{SUBTITLE}`
            )->a( n = `state`        v = `{STATE}`
            )->a( n = `scope`        v = client->_bind( scope )
            )->a( n = `mode`         v = `LineMode`
            )->a( n = `press`        v = client->_event( val   = `TILE_PRESS`
                                                          t_arg = VALUE #( ( `\${\$source>/header}` ) ( `\${\$parameters>/action}` ) ) )
            )->a( n = `sizeBehavior` v = client->_bind( size_behavior )
            )->a( n = `class`        v = `sapUiTinyMarginEnd sapUiTinyMarginBottom`

            )->ele( `TileContent`
                )->a( n = `footer` v = `{FOOTER}`
                )->tag( `NumericContent`
                    )->a( n = `withMargin` v = `false`
                    )->a( n = `value`      v = `{KPIVALUE}`
                    )->a( n = `valueColor` v = `{COLOR}`
                    )->a( n = `indicator`  v = `{TREND}`
                    )->a( n = `scale`      v = `{SCALE}`
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `ENFORCE_SMALL`.
        " changeEnforceSmall: /sizeBehavior = state ? 'Small' : 'Responsive'
        size_behavior = COND #( WHEN enforce_small = abap_true THEN `Small` ELSE `Responsive` ).

      WHEN `TILE_PRESS` OR `SLIDE_PRESS`.
        " press / pressSlideTile: the tile name is its header or its tooltip, and
        " a Remove action gets its own message
        DATA(tile_name) = client->get_event_arg( ).
        DATA(action)    = client->get_event_arg( 2 ).
        DATA(kind)      = COND string( WHEN client->get_event( ) = `SLIDE_PRESS`
                                       THEN `SlideTile`
                                       ELSE `GenericTile` ).
        IF action = `Remove`.
          client->message_toast_display( |Remove action of { kind } "{ tile_name }" has been pressed.| ).
        ELSE.
          client->message_toast_display( |The { kind } "{ tile_name }" has been pressed.| ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " tiles.json - the four scopes the ComboBox offers and the model's own seeds
    t_scopes = VALUE #(
      ( key = `Display`      text = `Display` )
      ( key = `Actions`      text = `Actions` )
      ( key = `ActionMore`   text = `ActionMore` )
      ( key = `ActionRemove` text = `ActionRemove` ) ).
    scope         = `Display`.
    size_behavior = `Responsive`.

    t_tiles = VALUE #(
      ( title    = `Jessica Danielle Johnson `
        subtitle = `Senior Consultant, Department Sales & Distribution`
        footer   = `Current Quarter`
        unit     = `EUR`
        kpivalue = `12`
        scale    = `k`
        state    = `Loaded`
        color    = `Good`
        trend    = `Up` )
      ( title    = `Manage Master Data Type Activity With a Long Title and Without an Icon`
        subtitle = `Subtitle for Activity`
        footer   = `Current Quarter`
        unit     = `EUR`
        kpivalue = `5`
        scale    = ``
        state    = `Loaded`
        color    = `Critical`
        trend    = `Down` )
      ( title    = `Business Decisions`
        subtitle = `Approval Needed`
        footer   = `Current Quarter`
        unit     = `EUR`
        kpivalue = `12`
        scale    = ``
        state    = `Loading`
        color    = `Critical`
        trend    = `Down` )
      ( title    = `Manage Assets`
        subtitle = ``
        footer   = ``
        unit     = ``
        kpivalue = `500`
        scale    = ``
        state    = `Failed`
        color    = `Error`
        trend    = `Up` )
      ( title    = `Manage Invoices`
        subtitle = `Payment Open`
        footer   = ``
        unit     = ``
        kpivalue = `1`
        scale    = `k`
        state    = `Disabled`
        color    = `Critical`
        trend    = `Down` )
    ).

    t_link_tiles = VALUE #(
      ( title    = `Jessica Danielle Johnson`
        contents = VALUE #(
          ( iconsrc = `sap-icon://action-settings` linktext = `SAP` linkhref = `http://www.sap.com` )
          ( iconsrc = `sap-icon://action-settings` linktext = `SAP` linkhref = `http://www.sap.com` )
          ( iconsrc = `sap-icon://action-settings` linktext = `SAP` linkhref = `http://www.sap.com` )
          ( iconsrc = `sap-icon://action-settings` linktext = `SAP` linkhref = `http://www.sap.com` )
          ( iconsrc = `sap-icon://action-settings` linktext = `SAP` linkhref = `http://www.sap.com` )
          ( iconsrc = `sap-icon://action-settings` linktext = `SAP` linkhref = `http://www.sap.com` )
        ) )
    ).

    t_slide1 = VALUE #(
      ( backgroundimage = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileLineMode/images/NewsImage2.png`
        footer          = `August 22, 2016`
        contenttext     = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`
        subtitle        = `Today, SAP News`
        state           = `Loaded`
        tooltip         = `NewsTile 1 of SlideTile 1` )
      ( backgroundimage = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileLineMode/images/NewsImage1.png`
        footer          = `August 21, 2016`
        contenttext     = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
        subtitle        = `Today, SAP News`
        state           = `Loaded`
        tooltip         = `NewsTile 2 of SlideTile 1` )
    ).

    t_slide2 = VALUE #(
      ( backgroundimage = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileLineMode/images/NewsImage1.png`
        footer          = `August 21, 2016`
        contenttext     = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
        subtitle        = `Today, SAP News`
        state           = `Loading`
        tooltip         = `NewsTile 1 of SlideTile 2` )
      ( backgroundimage = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileLineMode/images/NewsImage2.png`
        footer          = `August 22, 2016`
        contenttext     = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`
        subtitle        = `Today, SAP News`
        state           = `Failed`
        tooltip         = `NewsTile 2 of SlideTile 2` )
    ).

  ENDMETHOD.

ENDCLASS.
