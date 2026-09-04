" @keywords colorpalette color palette sap.m colorpalettepopover table column text columnlistitem label button
" @summary The ColorPalette in a popover (by use of thin wrapper control sap.m.ColorPalettePopover).
CLASS z2ui5_cl_smpc_app_250 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_250 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE string_table.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE string_table.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE string_table.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 TYPE string_table.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp11 TYPE string_table.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp13 TYPE string_table.
    DATA temp14 TYPE string_table.
    DATA temp15 TYPE string_table.
    DATA temp16 TYPE string_table.
    DATA temp17 TYPE string_table.
    DATA temp18 TYPE string_table.
    DATA temp19 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the controller builds six differently configured ColorPalettePopover
    " instances lazily and openBy()s them; here they are declared once in the
    " view's dependents and opened roundtrip-free (all extra controls declared)
    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    
    temp2 = `Color Selected: value - {0}, ` && |\n| && ` defaultAction - {1}`.
    INSERT temp2 INTO TABLE temp1.
    INSERT `${$parameters>/value}` INTO TABLE temp1.
    INSERT `${$parameters>/defaultAction}` INTO TABLE temp1.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    
    temp4 = `Color Selected: value - {0}, ` && |\n| && ` defaultAction - {1}`.
    INSERT temp4 INTO TABLE temp3.
    INSERT `${$parameters>/value}` INTO TABLE temp3.
    INSERT `${$parameters>/defaultAction}` INTO TABLE temp3.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    
    temp6 = `Color Selected: value - {0}, ` && |\n| && ` defaultAction - {1}`.
    INSERT temp6 INTO TABLE temp5.
    INSERT `${$parameters>/value}` INTO TABLE temp5.
    INSERT `${$parameters>/defaultAction}` INTO TABLE temp5.
    
    CLEAR temp7.
    INSERT `MESSAGE_TOAST` INTO TABLE temp7.
    INSERT `show` INTO TABLE temp7.
    
    temp8 = `Color Selected: value - {0}, ` && |\n| && ` defaultAction - {1}`.
    INSERT temp8 INTO TABLE temp7.
    INSERT `${$parameters>/value}` INTO TABLE temp7.
    INSERT `${$parameters>/defaultAction}` INTO TABLE temp7.
    
    CLEAR temp9.
    INSERT `MESSAGE_TOAST` INTO TABLE temp9.
    INSERT `show` INTO TABLE temp9.
    
    temp10 = `Color Selected: value - {0}, ` && |\n| && ` defaultAction - {1}`.
    INSERT temp10 INTO TABLE temp9.
    INSERT `${$parameters>/value}` INTO TABLE temp9.
    INSERT `${$parameters>/defaultAction}` INTO TABLE temp9.
    
    CLEAR temp11.
    INSERT `liveChangeButton` INTO TABLE temp11.
    INSERT `css` INTO TABLE temp11.
    INSERT `color` INTO TABLE temp11.
    
    temp12 = `${$parameters>/r} !== undefined ? 'rgba(' + ${$parameters>/r} + ',' + ${$parameters>/g} + ',' + ` && `${$parameters>/b} + ',' + ${$parameters>/alpha} + ')' : ''`.
    INSERT temp12 INTO TABLE temp11.
    
    CLEAR temp13.
    INSERT `oColorPalettePopoverFull` INTO TABLE temp13.
    INSERT `openBy` INTO TABLE temp13.
    INSERT `$event.oSource.sId` INTO TABLE temp13.
    
    CLEAR temp14.
    INSERT `oColorPalettePopoverMin` INTO TABLE temp14.
    INSERT `openBy` INTO TABLE temp14.
    INSERT `$event.oSource.sId` INTO TABLE temp14.
    
    CLEAR temp15.
    INSERT `oColorPalettePopoverCustom` INTO TABLE temp15.
    INSERT `openBy` INTO TABLE temp15.
    INSERT `$event.oSource.sId` INTO TABLE temp15.
    
    CLEAR temp16.
    INSERT `oColorPalettePopoverMinDef` INTO TABLE temp16.
    INSERT `openBy` INTO TABLE temp16.
    INSERT `$event.oSource.sId` INTO TABLE temp16.
    
    CLEAR temp17.
    INSERT `oColorPaletteDisplayMode` INTO TABLE temp17.
    INSERT `openBy` INTO TABLE temp17.
    INSERT `$event.oSource.sId` INTO TABLE temp17.
    
    CLEAR temp18.
    INSERT `oColorPaletteDisplayMode` INTO TABLE temp18.
    INSERT `openBy` INTO TABLE temp18.
    INSERT `$event.oSource.sId` INTO TABLE temp18.
    
    CLEAR temp19.
    INSERT `oColorPaletteSelectedColor` INTO TABLE temp19.
    INSERT `openBy` INTO TABLE temp19.
    INSERT `$event.oSource.sId` INTO TABLE temp19.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( n = `dependents` ns = `mvc`
            )->tag( `ColorPalettePopover`
                )->a( n = `id`           v = `oColorPalettePopoverFull`
                )->a( n = `defaultColor` v = `black`
                )->a( n = `colorSelect`  v = client->follow_up_action( val   = client->cs_event-control_global
                                                                       t_arg = temp1 )
            )->tag( `ColorPalettePopover`
                )->a( n = `id`                     v = `oColorPalettePopoverCustom`
                )->a( n = `defaultColor`           v = `white`
                )->a( n = `showDefaultColorButton` v = `false`
                " hsl(0,100%,71%) and rgb(255,234,234) cannot ride an XML string[]
                " attribute (the parser splits on commas) - their hex equivalents
                " #ff6b6b / #ffeaea render the same swatches (declared)
                )->a( n = `colors`                 v = `#292f36,#4ecdc4,#3a506b,#ff6b6b,white,lightcyan,#ffeaea`
                )->a( n = `colorSelect`            v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                 t_arg = temp3 )
            )->tag( `ColorPalettePopover`
                )->a( n = `id`                   v = `oColorPalettePopoverMinDef`
                )->a( n = `showMoreColorsButton` v = `false`
                )->a( n = `colors`               v = `red,#ffff00`
                )->a( n = `colorSelect`          v = client->follow_up_action( val   = client->cs_event-control_global
                                                                               t_arg = temp5 )
            )->tag( `ColorPalettePopover`
                )->a( n = `id`                     v = `oColorPalettePopoverMin`
                )->a( n = `showDefaultColorButton` v = `false`
                )->a( n = `showMoreColorsButton`   v = `false`
                )->a( n = `colorSelect`            v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                 t_arg = temp7 )
            )->tag( `ColorPalettePopover`
                )->a( n = `id`                     v = `oColorPaletteDisplayMode`
                )->a( n = `showDefaultColorButton` v = `false`
                )->a( n = `displayMode`            v = `Simplified`
                )->a( n = `colorSelect`            v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                 t_arg = temp9 )
                " handleLiveChange paints the liveChangeButton's icon in the
                " colour being picked. The original writes the rgba() straight
                " onto the ICON's DOM node; the `css` action writes on the
                " button's OWN node instead - measured 2026-08-06: the icon
                " INHERITS color from the button root, so the effect is the
                " same without reaching into internal DOM. The rgba() string is
                " composed on the client from the four event parameters - and the
                " expression MUST BEGIN WITH $ : get_t_arg leaves an argument raw
                " only when it starts with $ or { (or is an .eB/.eF call), so the
                " earlier form that opened with 'rgba(' was wrapped in a JS string
                " literal, reached the css setter as text and was dropped by CSSOM.
                " The leading ${$parameters>/r} test is inert (the parameter is
                " always present when liveChange fires) and buys the raw branch
                )->a( n = `liveChange`             v = client->follow_up_action(
                          val   = client->cs_event-control_by_id
                          t_arg = temp11 )
            )->tag( `ColorPalettePopover`
                )->a( n = `id`                      v = `oColorPaletteSelectedColor`
                )->a( n = `colors`                  v = `lightgray,lightblue,cornflowerblue,darkslateblue`
                )->a( n = `selectedColor`           v = `lightblue`
                )->a( n = `showRecentColorsSection` v = `false`
                )->a( n = `showMoreColorsButton`    v = `false`

        )->end(

        )->ele( `Table`
            )->a( n = `id`         v = `samplesTable`
            )->a( n = `headerText` v = `Color Palette in a Popover`
            )->a( n = `class`      v = `sapUiLargeMarginBottom`

            )->ele( `columns`
                )->ele( `Column`
                    )->tag( `Text`
                        )->a( n = `text` v = `Description`

                )->end(
                )->ele( `Column`
                    )->a( n = `width` v = `30%`
                    )->tag( `Text`
                        )->a( n = `text` v = `Action`

                )->end(
            )->end(

            )->ele( `ColumnListItem`
                )->tag( `Label`
                    )->a( n = `text` v = `Default set of colors with both "Default Color" and "More Colors..." buttons`
                )->tag( `Button`
                    )->a( n = `icon`         v = `sap-icon://text-color`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                           t_arg = temp13 )

            )->end(
            )->ele( `ColumnListItem`
                )->tag( `Label`
                    )->a( n = `text` v = `Default set of colors without any additional buttons`
                )->tag( `Button`
                    )->a( n = `icon`         v = `sap-icon://color-fill`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                           t_arg = temp14 )

            )->end(
            )->ele( `ColumnListItem`
                )->tag( `Label`
                    )->a( n = `text` v = `Custom set of colors with "More Colors..." button`
                )->tag( `Button`
                    )->a( n = `icon`         v = `sap-icon://color-fill`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                           t_arg = temp15 )

            )->end(
            )->ele( `ColumnListItem`
                )->tag( `Label`
                    )->a( n = `text` v = `Two custom colors with "Default Color" button`
                )->tag( `Button`
                    )->a( n = `icon`         v = `sap-icon://palette`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                           t_arg = temp16 )

            )->end(
            )->ele( `ColumnListItem`
                )->tag( `Label`
                    )->a( n = `text` v = `Default set of colors with "More Colors..." button and displayMode set to "Simplified"`
                )->tag( `Button`
                    )->a( n = `icon`         v = `sap-icon://color-fill`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                           t_arg = temp17 )

            )->end(
            )->ele( `ColumnListItem`
                )->tag( `Label`
                    )->a( n = `text` v = `liveChange of the Default set of colors with "More Colors..." button and displayMode set to "Simplified"`
                )->tag( `Button`
                    )->a( n = `id`           v = `liveChangeButton`
                    )->a( n = `icon`         v = `sap-icon://color-fill`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                           t_arg = temp18 )

            )->end(
            )->ele( `ColumnListItem`
                )->tag( `Label`
                    )->a( n = `text` v = `Custom set of colors with a selected color and with no additional buttons`
                )->tag( `Button`
                    )->a( n = `icon`         v = `sap-icon://cursor-arrow`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                           t_arg = temp19 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
