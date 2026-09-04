" @keywords splitcontainer split container sap.m master-detail navigation label button vbox text radiobuttongroup radiobutton
" @summary SplitContainer maintains two NavContainers if running on tablet or desktop and one NavContainer - on phone. The display of master NavContainer depends on the portrait/landscape orientation of the device and the mode of SplitContainer.
CLASS z2ui5_cl_smpc_app_096 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mode_idx TYPE i.
    DATA mode     TYPE string VALUE `ShowHideMode`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_096 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:custom` v = `http://schemas.sap.com/sapui5/extension/sap.ui.core.CustomData/1`

        )->ele( `SplitContainer`
            )->a( n = `id`            v = `SplitContDemo`
            )->a( n = `mode`          v = client->_bind( mode )
            )->a( n = `initialDetail` v = `detail`
            )->a( n = `initialMaster` v = `master`

            )->ele( `detailPages`
                )->ele( `Page`
                    )->a( n = `id`               v = `detail`
                    )->a( n = `title`            v = `Detail 1`
                    )->a( n = `backgroundDesign` v = `Solid`
                    )->a( n = `showNavButton`    v = `{= !${device>/system/desktop} }`
                    )->a( n = `navButtonPress`   v = client->_event( `DETAIL_BACK` )

                    )->tag( `Label`
                        )->a( n = `text`  v = `Detail page 1`
                        )->a( n = `class` v = `sapUiTinyMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text`  v = `Go to Detail page 2`
                        )->a( n = `press` v = client->_event( `NAV_TO_DETAIL` )

                )->end(
                )->ele( `Page`
                    )->a( n = `id`               v = `detailDetail`
                    )->a( n = `title`            v = `Detail Detail`
                    )->a( n = `backgroundDesign` v = `Solid`
                    )->a( n = `showNavButton`    v = `true`
                    )->a( n = `navButtonPress`   v = client->_event( `DETAIL_BACK` )

                    )->ele( `VBox`
                        )->a( n = `class` v = `sapUiSmallMargin`

                        )->tag( `Label`
                            )->a( n = `text` v = `This is Detail Page 2`
                        )->tag( `Text`
                            )->a( n = `text` v = `Here you could change the Split Application mode. After the mode change, resize the browser window to see the difference in the master form behaviour.`

                        )->ele( `RadioButtonGroup`
                            )->a( n = `columns`       v = `1`
                            )->a( n = `width`         v = `500px`
                            )->a( n = `class`         v = `sapUiMediumMarginBottom`
                            )->a( n = `selectedIndex` v = client->_bind( mode_idx )
                            )->a( n = `select`        v = client->_event( `MODE_BTN` )

                            )->ele( `buttons`
                                )->tag( `RadioButton`
                                    )->a( n = `id`                 v = `RB1-1`
                                    )->a( n = `text`               v = `show/hide`
                                    )->a( n = `selected`           v = `true`
                                    )->a( n = `custom:splitAppMode` v = `ShowHideMode`
                                )->tag( `RadioButton`
                                    )->a( n = `id`                 v = `RB1-2`
                                    )->a( n = `text`               v = `stretch/compress`
                                    )->a( n = `custom:splitAppMode` v = `StretchCompressMode`
                                )->tag( `RadioButton`
                                    )->a( n = `id`                 v = `RB1-3`
                                    )->a( n = `text`               v = `hide`
                                    )->a( n = `custom:splitAppMode` v = `HideMode`
                                )->tag( `RadioButton`
                                    )->a( n = `id`                 v = `RB1-4`
                                    )->a( n = `text`               v = `popover`
                                    )->a( n = `custom:splitAppMode` v = `PopoverMode`

                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `Page`
                    )->a( n = `id`               v = `detail2`
                    )->a( n = `title`            v = `Detail 3 Page`
                    )->a( n = `backgroundDesign` v = `Solid`
                    )->a( n = `showNavButton`    v = `true`
                    )->a( n = `navButtonPress`   v = client->_event( `DETAIL_BACK` )

                    )->tag( `Label`
                        )->a( n = `text` v = `This is Detail Page 3`
                    )->tag( `Input`
                    )->tag( `Label`
                        )->a( n = `text` v = `Label 2`
                    )->tag( `Input`
                    )->tag( `Label`
                        )->a( n = `text` v = `Label 3`
                    )->tag( `Input`
                    )->tag( `Label`
                        )->a( n = `text` v = `Label 4`
                    )->tag( `Input`
                    )->tag( `Label`
                        )->a( n = `text` v = `Label 5`
                    )->tag( `Input`

                )->end(
            )->end(
            )->ele( `masterPages`
                )->ele( `Page`
                    )->a( n = `id`               v = `master`
                    )->a( n = `title`            v = `Master 1`
                    )->a( n = `backgroundDesign` v = `List`

                    )->ele( `List`
                        )->tag( `StandardListItem`
                            )->a( n = `title` v = `To Master2`
                            )->a( n = `type`  v = `Navigation`
                            )->a( n = `press` v = client->_event( `GO_TO_MASTER` )

                    )->end(
                )->end(
                )->ele( `Page`
                    )->a( n = `id`               v = `master2`
                    )->a( n = `title`            v = `Master 2`
                    )->a( n = `backgroundDesign` v = `List`
                    )->a( n = `showNavButton`    v = `true`
                    )->a( n = `navButtonPress`   v = client->_event( `MASTER_BACK` )

                    )->ele( `List`
                        )->a( n = `itemPress` v = client->_event( val = `NAV_DETAIL` arg = `${$parameters>/listItem}.getCustomData()[0].getValue()` )

                        )->tag( `StandardListItem`
                            )->a( n = `title`     v = `To Detail 1`
                            )->a( n = `type`      v = `Active`
                            )->a( n = `custom:to` v = `detail`
                        )->tag( `StandardListItem`
                            )->a( n = `title`     v = `To Detail 2`
                            )->a( n = `type`      v = `Active`
                            )->a( n = `custom:to` v = `detailDetail`
                        )->tag( `StandardListItem`
                            )->a( n = `title`     v = `To Detail 3`
                            )->a( n = `type`      v = `Active`
                            )->a( n = `custom:to` v = `detail2` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE string_table.
        DATA temp3 TYPE string_table.
        DATA temp5 TYPE string_table.
        DATA temp7 TYPE string_table.
        DATA temp9 TYPE string_table.
        DATA temp11 TYPE string.

    CASE client->get_event( ).

      WHEN `NAV_TO_DETAIL`.
        
        CLEAR temp1.
        INSERT `SplitContDemo` INTO TABLE temp1.
        INSERT `to` INTO TABLE temp1.
        INSERT `detailDetail` INTO TABLE temp1.
        client->follow_up_action( val = client->cs_event-control_by_id
                                  t_arg = temp1 ).

      WHEN `DETAIL_BACK`.
        
        CLEAR temp3.
        INSERT `SplitContDemo` INTO TABLE temp3.
        INSERT `backDetail` INTO TABLE temp3.
        client->follow_up_action( val = client->cs_event-control_by_id
                                  t_arg = temp3 ).

      WHEN `MASTER_BACK`.
        
        CLEAR temp5.
        INSERT `SplitContDemo` INTO TABLE temp5.
        INSERT `backMaster` INTO TABLE temp5.
        client->follow_up_action( val = client->cs_event-control_by_id
                                  t_arg = temp5 ).

      WHEN `GO_TO_MASTER`.
        
        CLEAR temp7.
        INSERT `SplitContDemo` INTO TABLE temp7.
        INSERT `toMaster` INTO TABLE temp7.
        INSERT `master2` INTO TABLE temp7.
        client->follow_up_action( val = client->cs_event-control_by_id
                                  t_arg = temp7 ).

      WHEN `NAV_DETAIL`.
        
        CLEAR temp9.
        INSERT `SplitContDemo` INTO TABLE temp9.
        INSERT `toDetail` INTO TABLE temp9.
        INSERT client->get_event_arg( ) INTO TABLE temp9.
        client->follow_up_action( val = client->cs_event-control_by_id
                                  t_arg = temp9 ).

      WHEN `MODE_BTN`.
        " the original calls setMode( ); mode is a bindable property, so it is
        " bound two-way and only assigned here
        
        CASE mode_idx.
          WHEN 0.
            temp11 = `ShowHideMode`.
          WHEN 1.
            temp11 = `StretchCompressMode`.
          WHEN 2.
            temp11 = `HideMode`.
          WHEN 3.
            temp11 = `PopoverMode`.
        ENDCASE.
        mode = temp11.
        client->message_toast_display( text = |Split Container mode is changed to: { mode }| duration = `5000` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
