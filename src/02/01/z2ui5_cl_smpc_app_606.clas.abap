" @keywords generictile generic tile sap.m generictilelinemode overflowtoolbar toolbarspacer label switch combobox item tilecontent
" @summary Shows Generic Tile regular and in line mode, and you can switch between the display scope and actions scope for Generic Tiles on a web page.
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
    TYPES ty_t_tile TYPE STANDARD TABLE OF ty_s_tile WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_s_link_content,
             iconsrc  TYPE string,
             linktext TYPE string,
             linkhref TYPE string,
           END OF ty_s_link_content.
    TYPES: BEGIN OF ty_s_link_tile,
             title    TYPE string,
             contents TYPE STANDARD TABLE OF ty_s_link_content WITH DEFAULT KEY,
           END OF ty_s_link_tile.
    TYPES ty_t_link_tile TYPE STANDARD TABLE OF ty_s_link_tile WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_s_slide,
             backgroundimage TYPE string,
             footer          TYPE string,
             contenttext     TYPE string,
             subtitle        TYPE string,
             state           TYPE string,
             tooltip         TYPE string,
           END OF ty_s_slide.
    TYPES ty_t_slide TYPE STANDARD TABLE OF ty_s_slide WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_s_scope,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_scope.
    TYPES ty_t_scope TYPE STANDARD TABLE OF ty_s_scope WITH DEFAULT KEY.

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

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA content TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA box TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA slides TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp5 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp7 TYPE string_table.
    DATA temp6 TYPE string_table.
    DATA temp9 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    page = view->ele( n = `View` ns = `mvc`
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

    
    content = page->ele( `content` ).

    content->tag( `MessageStrip`
        )->a( n = `showIcon` v = `true`
        )->a( n = `type`     v = `Information`
        )->a( n = `text`     v = `Compare same content of Generic Tiles in regular and in line mode; no line mode equivalent for Slide Tile.`
        )->a( n = `class`    v = `sapUiTinyMargin` ).

    
    box = content->ele( `VBox`
        )->a( n = `class` v = `sapUiTinyMargin` ).

    
    CLEAR temp1.
    INSERT `${$source>/header}` INTO TABLE temp1.
    INSERT `${$parameters>/action}` INTO TABLE temp1.
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
                                                          t_arg = temp1 )
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

    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `Pressed on Link` INTO TABLE temp3.
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
                                                                         t_arg = temp3 )
            )->end(
        )->end(
    )->end( ).

    
    slides = box->ele( n = `HorizontalLayout` ns = `l`
        )->a( n = `id`            v = `SlideTileContainer`
        )->a( n = `allowWrapping` v = `true`
        )->a( n = `class`         v = `sapUiTinyMarginTopBottom` ).

    
    CLEAR temp5.
    INSERT `SlideTile 1` INTO TABLE temp5.
    INSERT `${$parameters>/action}` INTO TABLE temp5.
    
    CLEAR temp2.
    INSERT `${$source>/tooltip}` INTO TABLE temp2.
    INSERT `${$parameters>/action}` INTO TABLE temp2.
    slides->ele( `SlideTile`
        )->a( n = `id`           v = `slideTile1`
        )->a( n = `tiles`        v = client->_bind( t_slide1 )
        )->a( n = `scope`        v = |\{= ${ client->_bind( scope ) } === 'Actions' ? 'Actions' : 'Display' \}|
        )->a( n = `tooltip`      v = `SlideTile 1`
        )->a( n = `press`        v = client->_event( val   = `SLIDE_PRESS`
                                                      t_arg = temp5 )
        )->a( n = `class`        v = `sapUiTinyMarginEnd`
        )->a( n = `sizeBehavior` v = client->_bind( size_behavior )

        )->ele( `GenericTile`
            )->a( n = `id`              v = `tile6`
            )->a( n = `backgroundImage` v = `{BACKGROUNDIMAGE}`
            )->a( n = `state`           v = `{STATE}`
            )->a( n = `tooltip`         v = `{TOOLTIP}`
            )->a( n = `frameType`       v = `TwoByOne`
            )->a( n = `press`           v = client->_event( val   = `TILE_PRESS`
                                                             t_arg = temp2 )
            )->a( n = `sizeBehavior`    v = client->_bind( size_behavior )

            )->ele( `TileContent`
                )->a( n = `footer` v = `{FOOTER}`
                )->tag( `NewsContent`
                    )->a( n = `contentText` v = `{CONTENTTEXT}`
                    )->a( n = `subheader`   v = `{SUBTITLE}`
            )->end(
        )->end(
    )->end( ).

    
    CLEAR temp7.
    INSERT `SlideTile 2` INTO TABLE temp7.
    INSERT `${$parameters>/action}` INTO TABLE temp7.
    
    CLEAR temp6.
    INSERT `${$source>/tooltip}` INTO TABLE temp6.
    INSERT `${$parameters>/action}` INTO TABLE temp6.
    slides->ele( `SlideTile`
        )->a( n = `id`             v = `slideTile2`
        )->a( n = `tiles`          v = client->_bind( t_slide2 )
        )->a( n = `scope`          v = |\{= ${ client->_bind( scope ) } === 'Actions' ? 'Actions' : 'Display' \}|
        )->a( n = `tooltip`        v = `SlideTile 2`
        )->a( n = `press`          v = client->_event( val   = `SLIDE_PRESS`
                                                        t_arg = temp7 )
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
                                                             t_arg = temp6 )
            )->a( n = `sizeBehavior`    v = client->_bind( size_behavior )

            )->ele( `TileContent`
                )->a( n = `footer` v = `{FOOTER}`
                )->tag( `NewsContent`
                    )->a( n = `contentText` v = `{CONTENTTEXT}`
                    )->a( n = `subheader`   v = `{SUBTITLE}`
            )->end(
        )->end(
    )->end( ).

    
    CLEAR temp9.
    INSERT `${$source>/header}` INTO TABLE temp9.
    INSERT `${$parameters>/action}` INTO TABLE temp9.
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
                                                          t_arg = temp9 )
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
        DATA temp11 TYPE string.
        DATA tile_name TYPE string.
        DATA action TYPE string.
        DATA temp12 TYPE string.
        DATA kind LIKE temp12.

    CASE client->get_event( ).

      WHEN `ENFORCE_SMALL`.
        " changeEnforceSmall: /sizeBehavior = state ? 'Small' : 'Responsive'
        
        IF enforce_small = abap_true.
          temp11 = `Small`.
        ELSE.
          temp11 = `Responsive`.
        ENDIF.
        size_behavior = temp11.

      WHEN `TILE_PRESS` OR `SLIDE_PRESS`.
        " press / pressSlideTile: the tile name is its header or its tooltip, and
        " a Remove action gets its own message
        
        tile_name = client->get_event_arg( ).
        
        action    = client->get_event_arg( 2 ).
        
        IF client->get_event( ) = `SLIDE_PRESS`.
          temp12 = `SlideTile`.
        ELSE.
          temp12 = `GenericTile`.
        ENDIF.
        
        kind = temp12.
        IF action = `Remove`.
          client->message_toast_display( |Remove action of { kind } "{ tile_name }" has been pressed.| ).
        ELSE.
          client->message_toast_display( |The { kind } "{ tile_name }" has been pressed.| ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " tiles.json - the four scopes the ComboBox offers and the model's own seeds
    DATA temp13 TYPE z2ui5_cl_smpc_app_606=>ty_t_scope.
    DATA temp14 LIKE LINE OF temp13.
    DATA temp15 TYPE z2ui5_cl_smpc_app_606=>ty_t_tile.
    DATA temp16 LIKE LINE OF temp15.
    DATA temp17 TYPE z2ui5_cl_smpc_app_606=>ty_t_link_tile.
    DATA temp18 LIKE LINE OF temp17.
    DATA temp9 TYPE z2ui5_cl_smpc_app_606=>ty_s_link_tile-contents.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp19 TYPE z2ui5_cl_smpc_app_606=>ty_t_slide.
    DATA temp20 LIKE LINE OF temp19.
    DATA temp21 TYPE z2ui5_cl_smpc_app_606=>ty_t_slide.
    DATA temp22 LIKE LINE OF temp21.
    CLEAR temp13.
    
    temp14-key = `Display`.
    temp14-text = `Display`.
    INSERT temp14 INTO TABLE temp13.
    temp14-key = `Actions`.
    temp14-text = `Actions`.
    INSERT temp14 INTO TABLE temp13.
    temp14-key = `ActionMore`.
    temp14-text = `ActionMore`.
    INSERT temp14 INTO TABLE temp13.
    temp14-key = `ActionRemove`.
    temp14-text = `ActionRemove`.
    INSERT temp14 INTO TABLE temp13.
    t_scopes = temp13.
    scope         = `Display`.
    size_behavior = `Responsive`.

    
    CLEAR temp15.
    
    temp16-title = `Jessica Danielle Johnson `.
    temp16-subtitle = `Senior Consultant, Department Sales & Distribution`.
    temp16-footer = `Current Quarter`.
    temp16-unit = `EUR`.
    temp16-kpivalue = `12`.
    temp16-scale = `k`.
    temp16-state = `Loaded`.
    temp16-color = `Good`.
    temp16-trend = `Up`.
    INSERT temp16 INTO TABLE temp15.
    temp16-title = `Manage Master Data Type Activity With a Long Title and Without an Icon`.
    temp16-subtitle = `Subtitle for Activity`.
    temp16-footer = `Current Quarter`.
    temp16-unit = `EUR`.
    temp16-kpivalue = `5`.
    temp16-scale = ``.
    temp16-state = `Loaded`.
    temp16-color = `Critical`.
    temp16-trend = `Down`.
    INSERT temp16 INTO TABLE temp15.
    temp16-title = `Business Decisions`.
    temp16-subtitle = `Approval Needed`.
    temp16-footer = `Current Quarter`.
    temp16-unit = `EUR`.
    temp16-kpivalue = `12`.
    temp16-scale = ``.
    temp16-state = `Loading`.
    temp16-color = `Critical`.
    temp16-trend = `Down`.
    INSERT temp16 INTO TABLE temp15.
    temp16-title = `Manage Assets`.
    temp16-subtitle = ``.
    temp16-footer = ``.
    temp16-unit = ``.
    temp16-kpivalue = `500`.
    temp16-scale = ``.
    temp16-state = `Failed`.
    temp16-color = `Error`.
    temp16-trend = `Up`.
    INSERT temp16 INTO TABLE temp15.
    temp16-title = `Manage Invoices`.
    temp16-subtitle = `Payment Open`.
    temp16-footer = ``.
    temp16-unit = ``.
    temp16-kpivalue = `1`.
    temp16-scale = `k`.
    temp16-state = `Disabled`.
    temp16-color = `Critical`.
    temp16-trend = `Down`.
    INSERT temp16 INTO TABLE temp15.
    t_tiles = temp15.

    
    CLEAR temp17.
    
    temp18-title = `Jessica Danielle Johnson`.
    
    CLEAR temp9.
    
    temp10-iconsrc = `sap-icon://action-settings`.
    temp10-linktext = `SAP`.
    temp10-linkhref = `http://www.sap.com`.
    INSERT temp10 INTO TABLE temp9.
    temp10-iconsrc = `sap-icon://action-settings`.
    temp10-linktext = `SAP`.
    temp10-linkhref = `http://www.sap.com`.
    INSERT temp10 INTO TABLE temp9.
    temp10-iconsrc = `sap-icon://action-settings`.
    temp10-linktext = `SAP`.
    temp10-linkhref = `http://www.sap.com`.
    INSERT temp10 INTO TABLE temp9.
    temp10-iconsrc = `sap-icon://action-settings`.
    temp10-linktext = `SAP`.
    temp10-linkhref = `http://www.sap.com`.
    INSERT temp10 INTO TABLE temp9.
    temp10-iconsrc = `sap-icon://action-settings`.
    temp10-linktext = `SAP`.
    temp10-linkhref = `http://www.sap.com`.
    INSERT temp10 INTO TABLE temp9.
    temp10-iconsrc = `sap-icon://action-settings`.
    temp10-linktext = `SAP`.
    temp10-linkhref = `http://www.sap.com`.
    INSERT temp10 INTO TABLE temp9.
    temp18-contents = temp9.
    INSERT temp18 INTO TABLE temp17.
    t_link_tiles = temp17.

    
    CLEAR temp19.
    
    temp20-backgroundimage = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileLineMode/images/NewsImage2.png`.
    temp20-footer = `August 22, 2016`.
    temp20-contenttext = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`.
    temp20-subtitle = `Today, SAP News`.
    temp20-state = `Loaded`.
    temp20-tooltip = `NewsTile 1 of SlideTile 1`.
    INSERT temp20 INTO TABLE temp19.
    temp20-backgroundimage = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileLineMode/images/NewsImage1.png`.
    temp20-footer = `August 21, 2016`.
    temp20-contenttext = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`.
    temp20-subtitle = `Today, SAP News`.
    temp20-state = `Loaded`.
    temp20-tooltip = `NewsTile 2 of SlideTile 1`.
    INSERT temp20 INTO TABLE temp19.
    t_slide1 = temp19.

    
    CLEAR temp21.
    
    temp22-backgroundimage = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileLineMode/images/NewsImage1.png`.
    temp22-footer = `August 21, 2016`.
    temp22-contenttext = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`.
    temp22-subtitle = `Today, SAP News`.
    temp22-state = `Loading`.
    temp22-tooltip = `NewsTile 1 of SlideTile 2`.
    INSERT temp22 INTO TABLE temp21.
    temp22-backgroundimage = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileLineMode/images/NewsImage2.png`.
    temp22-footer = `August 22, 2016`.
    temp22-contenttext = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`.
    temp22-subtitle = `Today, SAP News`.
    temp22-state = `Failed`.
    temp22-tooltip = `NewsTile 2 of SlideTile 2`.
    INSERT temp22 INTO TABLE temp21.
    t_slide2 = temp21.

  ENDMETHOD.

ENDCLASS.
