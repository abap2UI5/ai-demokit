" @keywords generictile generic tile sap.m generictileaslaunchtile simpleform label input button html tilecontent imagecontent
" @summary Shows Launch Tile samples that can contain header, subheader, image content, unit, and a footer.
CLASS z2ui5_cl_smpc_app_517 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA loading_seconds TYPE string VALUE `-1`.
    DATA tile_state      TYPE string VALUE `Loaded`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_517 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE string_table.
    DATA temp7 TYPE string_table.
    DATA temp8 TYPE string_table.
    DATA temp9 TYPE string_table.
    DATA temp10 TYPE string_table.
    DATA temp11 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `The GenericTile is pressed.` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `The GenericTile is pressed.` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `The GenericTile is pressed.` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `The GenericTile is pressed.` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `The GenericTile is pressed.` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `MESSAGE_TOAST` INTO TABLE temp6.
    INSERT `show` INTO TABLE temp6.
    INSERT `The GenericTile is pressed.` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `MESSAGE_TOAST` INTO TABLE temp7.
    INSERT `show` INTO TABLE temp7.
    INSERT `The GenericTile is pressed.` INTO TABLE temp7.
    
    CLEAR temp8.
    INSERT `MESSAGE_TOAST` INTO TABLE temp8.
    INSERT `show` INTO TABLE temp8.
    INSERT `The GenericTile is pressed.` INTO TABLE temp8.
    
    CLEAR temp9.
    INSERT `MESSAGE_TOAST` INTO TABLE temp9.
    INSERT `show` INTO TABLE temp9.
    INSERT `The GenericTile is pressed.` INTO TABLE temp9.
    
    CLEAR temp10.
    INSERT `MESSAGE_TOAST` INTO TABLE temp10.
    INSERT `show` INTO TABLE temp10.
    INSERT `The GenericTile is pressed.` INTO TABLE temp10.
    
    CLEAR temp11.
    INSERT `MESSAGE_TOAST` INTO TABLE temp11.
    INSERT `show` INTO TABLE temp11.
    INSERT `The GenericTile is pressed.` INTO TABLE temp11.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `editable` v = `true`
            )->a( n = `width`    v = `40rem`
            )->a( n = `layout`   v = `ResponsiveGridLayout`

            )->tag( `Label`
                )->a( n = `text` v = `Loading time`
            )->tag( `Input`
                )->a( n = `id`          v = `loadingMinSeconds`
                )->a( n = `width`       v = `8rem`
                )->a( n = `type`        v = `Number`
                )->a( n = `description` v = `seconds`
                )->a( n = `value`       v = client->_bind( loading_seconds )
            " onFormSubmit sets every tile to Loading and back to Loaded after the
            " entered number of seconds - the state is one bound property and the
            " framework's own timer brings it back
            )->tag( `Button`
                )->a( n = `text`  v = `Start loading`
                )->a( n = `type`  v = `Emphasized`
                )->a( n = `press` v = client->_event( `START_LOADING` )

        )->end(

        )->tag( n = `HTML` ns = `core`
            " the sample's own style.css (one rule: .tileLayout floats left) - literal
            " braces escaped \{ \} because the XMLView binding parser reads an
            " unescaped brace as a binding (the app-028 form)
            )->a( n = `content` v = `<style>.tileLayout\{float:left\}</style>`

        )->ele( `GenericTile`
            )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header` v = `Country-Specific Profit Margin`
            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                            t_arg = temp1 )
            )->a( n = `frameType` v = `OneByHalf`
            )->a( n = `subheader` v = `Subtitle`
            )->a( n = `state` v = client->_bind( tile_state )

            )->ele( `TileContent`

                )->tag( `ImageContent`
                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header` v = `Sales Fulfillment Application Title`
            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                            t_arg = temp2 )
            )->a( n = `frameType` v = `TwoByHalf`
            )->a( n = `subheader` v = `Subtitle`
            )->a( n = `state` v = client->_bind( tile_state )

            )->tag( `TileContent`

        )->end(

        )->ele( `GenericTile`
            )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header` v = `Manage Activity Master Data Type`
            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                            t_arg = temp3 )
            )->a( n = `frameType` v = `TwoByHalf`
            )->a( n = `subheader` v = `Subtitle`
            )->a( n = `state` v = client->_bind( tile_state )

            )->ele( `TileContent`
                )->a( n = `unit` v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->tag( `ImageContent`
                    )->a( n = `src` v = `sap-icon://home-share`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header` v = `Right click to open in new tab`
            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                            t_arg = temp4 )
            )->a( n = `subheader` v = `Link tile`
            )->a( n = `url` v = `https://www.sap.com/`
            )->a( n = `state` v = client->_bind( tile_state )

            )->ele( `TileContent`

                )->tag( `ImageContent`
                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header` v = `Sales Fulfillment Application Title`
            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                            t_arg = temp5 )
            )->a( n = `subheader` v = `Subtitle`
            )->a( n = `state` v = client->_bind( tile_state )

            )->ele( `TileContent`
                )->a( n = `unit` v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->tag( `ImageContent`
                    )->a( n = `src` v = `sap-icon://home-share`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header` v = `Manage Activity Master Data Type`
            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                            t_arg = temp6 )
            )->a( n = `subheader` v = `Subtitle`
            )->a( n = `state` v = client->_bind( tile_state )

            )->ele( `TileContent`

                )->tag( `ImageContent`
                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header` v = `Manage Activity Master Data Type With a Long Title Without an Icon`
            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                            t_arg = temp7 )
            )->a( n = `subheader` v = `Subtitle Launch Tile`
            )->a( n = `mode` v = `HeaderMode`
            )->a( n = `state` v = client->_bind( tile_state )

            )->ele( `TileContent`
                )->a( n = `unit` v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header` v = `Jessica D. Prince Senior Consultant`
            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                            t_arg = temp8 )
            )->a( n = `subheader` v = `Department`
            )->a( n = `appShortcut` v = `shortcut`
            )->a( n = `systemInfo` v = `systeminfo`
            )->a( n = `state` v = client->_bind( tile_state )

            )->ele( `TileContent`

                )->tag( `ImageContent`
                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/ProfileImage_LargeGenTile.png`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header` v = `Sales Fulfillment Application Title`
            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                            t_arg = temp9 )
            )->a( n = `frameType` v = `OneByHalf`
            )->a( n = `state` v = client->_bind( tile_state )

            )->ele( `TileContent`
                )->a( n = `unit` v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header` v = `Sales Fulfillment Application Title`
            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                            t_arg = temp10 )
            )->a( n = `frameType` v = `TwoByHalf`
            )->a( n = `state` v = client->_bind( tile_state )

            )->ele( `TileContent`
                )->a( n = `unit` v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header` v = `Jessica D. Prince Senior Consultant`
            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                            t_arg = temp11 )
            )->a( n = `frameType` v = `TwoByHalf`
            )->a( n = `subheader` v = `Department`
            )->a( n = `state` v = client->_bind( tile_state )

            )->ele( `TileContent`

                )->tag( `ImageContent`
                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/ProfileImage_LargeGenTile.png`

            )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE i.
        DATA temp5 TYPE string.
        DATA seconds LIKE temp3.
        DATA temp4 TYPE string_table.
        DATA temp6 LIKE LINE OF temp4.

    CASE client->get_event( ).

      WHEN `START_LOADING`.
        tile_state = `Loading`.
        " the length term matters as much as the character one: without it
        " `99999999999` passes CO and overflows CONV i, and 2147484 already
        " overflows the `seconds * 1000` below, which calculates in i
        
        
        IF loading_seconds CO `0123456789` AND loading_seconds IS NOT INITIAL AND strlen( loading_seconds ) <= 6.
          temp5 = loading_seconds.
        ELSE.
          temp5 = `0`.
        ENDIF.
        temp3 = temp5.
        
        seconds = temp3.
        
        CLEAR temp4.
        INSERT `LOADED` INTO TABLE temp4.
        
        temp6 = |{ seconds * 1000 }|.
        INSERT temp6 INTO TABLE temp4.
        client->follow_up_action( val   = client->cs_event-start_timer
                                  t_arg = temp4 ).

      WHEN `LOADED`.
        tile_state = `Loaded`.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
