CLASS z2ui5_cl_ai_app_250 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_250 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the controller builds six differently configured ColorPalettePopover
    " instances lazily and openBy()s them; here they are declared once in the
    " view's dependents and opened roundtrip-free (all extra controls declared)
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( n = `dependents` ns = `mvc`
            )->leaf( `ColorPalettePopover`
                )->a( n = `id`           v = `oColorPalettePopoverFull`
                )->a( n = `defaultColor` v = `black`
                )->a( n = `colorSelect`  v = client->_event_client( val   = client->cs_event-control_global
                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Color Selected: value - {0}, \n defaultAction - {1}` ) ( `${$parameters>/value}` ) ( `${$parameters>/defaultAction}` ) ) )
            )->leaf( `ColorPalettePopover`
                )->a( n = `id`                     v = `oColorPalettePopoverCustom`
                )->a( n = `defaultColor`           v = `white`
                )->a( n = `showDefaultColorButton` v = `false`
                " hsl(0,100%,71%) and rgb(255,234,234) cannot ride an XML string[]
                " attribute (the parser splits on commas) - their hex equivalents
                " #ff6b6b / #ffeaea render the same swatches (declared)
                )->a( n = `colors`                 v = `#292f36,#4ecdc4,#3a506b,#ff6b6b,white,lightcyan,#ffeaea`
                )->a( n = `colorSelect`            v = client->_event_client( val   = client->cs_event-control_global
                                                                              t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Color Selected: value - {0}, \n defaultAction - {1}` ) ( `${$parameters>/value}` ) ( `${$parameters>/defaultAction}` ) ) )
            )->leaf( `ColorPalettePopover`
                )->a( n = `id`                   v = `oColorPalettePopoverMinDef`
                )->a( n = `showMoreColorsButton` v = `false`
                )->a( n = `colors`               v = `red,#ffff00`
                )->a( n = `colorSelect`          v = client->_event_client( val   = client->cs_event-control_global
                                                                            t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Color Selected: value - {0}, \n defaultAction - {1}` ) ( `${$parameters>/value}` ) ( `${$parameters>/defaultAction}` ) ) )
            )->leaf( `ColorPalettePopover`
                )->a( n = `id`                     v = `oColorPalettePopoverMin`
                )->a( n = `showDefaultColorButton` v = `false`
                )->a( n = `showMoreColorsButton`   v = `false`
                )->a( n = `colorSelect`            v = client->_event_client( val   = client->cs_event-control_global
                                                                              t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Color Selected: value - {0}, \n defaultAction - {1}` ) ( `${$parameters>/value}` ) ( `${$parameters>/defaultAction}` ) ) )
            )->leaf( `ColorPalettePopover`
                )->a( n = `id`                     v = `oColorPaletteDisplayMode`
                )->a( n = `showDefaultColorButton` v = `false`
                )->a( n = `displayMode`            v = `Simplified`
                )->a( n = `colorSelect`            v = client->_event_client( val   = client->cs_event-control_global
                                                                              t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Color Selected: value - {0}, \n defaultAction - {1}` ) ( `${$parameters>/value}` ) ( `${$parameters>/defaultAction}` ) ) )
                " handleLiveChange paints the liveChangeButton's icon in the
                " colour being picked. The original writes the rgba() straight
                " onto the ICON's DOM node; the `css` action writes on the
                " button's OWN node instead - measured 2026-08-06: the icon
                " INHERITS color from the button root, so the effect is the
                " same without reaching into internal DOM. The rgba() string is
                " composed on the client from the four event parameters
                )->a( n = `liveChange`             v = client->_event_client(
                          val   = client->cs_event-control_by_id
                          t_arg = VALUE #( ( `liveChangeButton` )
                                           ( `css` )
                                           ( `color` )
                                           ( `'rgba(' + ${$parameters>/r} + ',' + ${$parameters>/g} + ',' + ` &&
                                             `${$parameters>/b} + ',' + ${$parameters>/alpha} + ')'` ) ) )
            )->leaf( `ColorPalettePopover`
                )->a( n = `id`                      v = `oColorPaletteSelectedColor`
                )->a( n = `colors`                  v = `lightgray,lightblue,cornflowerblue,darkslateblue`
                )->a( n = `selectedColor`           v = `lightblue`
                )->a( n = `showRecentColorsSection` v = `false`
                )->a( n = `showMoreColorsButton`    v = `false`

        )->shut(

        )->open( `Table`
            )->a( n = `id`         v = `samplesTable`
            )->a( n = `headerText` v = `Color Palette in a Popover`
            )->a( n = `class`      v = `sapUiLargeMarginBottom`

            )->open( `columns`
                )->open( `Column`
                    )->leaf( `Text`
                        )->a( n = `text` v = `Description`

                )->shut(
                )->open( `Column`
                    )->a( n = `width` v = `30%`
                    )->leaf( `Text`
                        )->a( n = `text` v = `Action`

                )->shut(
            )->shut(

            )->open( `ColumnListItem`
                )->leaf( `Label`
                    )->a( n = `text` v = `Default set of colors with both "Default Color" and "More Colors..." buttons`
                )->leaf( `Button`
                    )->a( n = `icon`         v = `sap-icon://text-color`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->_event_client( val   = client->cs_event-control_by_id
                                                                        t_arg = VALUE #( ( `oColorPalettePopoverFull` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

            )->shut(
            )->open( `ColumnListItem`
                )->leaf( `Label`
                    )->a( n = `text` v = `Default set of colors without any additional buttons`
                )->leaf( `Button`
                    )->a( n = `icon`         v = `sap-icon://color-fill`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->_event_client( val   = client->cs_event-control_by_id
                                                                        t_arg = VALUE #( ( `oColorPalettePopoverMin` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

            )->shut(
            )->open( `ColumnListItem`
                )->leaf( `Label`
                    )->a( n = `text` v = `Custom set of colors with "More Colors..." button`
                )->leaf( `Button`
                    )->a( n = `icon`         v = `sap-icon://color-fill`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->_event_client( val   = client->cs_event-control_by_id
                                                                        t_arg = VALUE #( ( `oColorPalettePopoverCustom` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

            )->shut(
            )->open( `ColumnListItem`
                )->leaf( `Label`
                    )->a( n = `text` v = `Two custom colors with "Default Color" button`
                )->leaf( `Button`
                    )->a( n = `icon`         v = `sap-icon://palette`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->_event_client( val   = client->cs_event-control_by_id
                                                                        t_arg = VALUE #( ( `oColorPalettePopoverMinDef` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

            )->shut(
            )->open( `ColumnListItem`
                )->leaf( `Label`
                    )->a( n = `text` v = `Default set of colors with "More Colors..." button and displayMode set to "Simplified"`
                )->leaf( `Button`
                    )->a( n = `icon`         v = `sap-icon://color-fill`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->_event_client( val   = client->cs_event-control_by_id
                                                                        t_arg = VALUE #( ( `oColorPaletteDisplayMode` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

            )->shut(
            )->open( `ColumnListItem`
                )->leaf( `Label`
                    )->a( n = `text` v = `liveChange of the Default set of colors with "More Colors..." button and displayMode set to "Simplified"`
                )->leaf( `Button`
                    )->a( n = `id`           v = `liveChangeButton`
                    )->a( n = `icon`         v = `sap-icon://color-fill`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->_event_client( val   = client->cs_event-control_by_id
                                                                        t_arg = VALUE #( ( `oColorPaletteDisplayMode` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

            )->shut(
            )->open( `ColumnListItem`
                )->leaf( `Label`
                    )->a( n = `text` v = `Custom set of colors with a selected color and with no additional buttons`
                )->leaf( `Button`
                    )->a( n = `icon`         v = `sap-icon://cursor-arrow`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->_event_client( val   = client->cs_event-control_by_id
                                                                        t_arg = VALUE #( ( `oColorPaletteSelectedColor` ) ( `openBy` ) ( `$event.oSource.sId` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
