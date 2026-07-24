CLASS z2ui5_cl_ai_app_096 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mode_idx TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_096 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:custom` v = `http://schemas.sap.com/sapui5/extension/sap.ui.core.CustomData/1`

        )->open( `SplitContainer`
            )->a( n = `id`            v = `SplitContDemo`
            )->a( n = `initialDetail` v = `detail`
            )->a( n = `initialMaster` v = `master`

            )->open( `detailPages`
                )->open( `Page`
                    )->a( n = `id`               v = `detail`
                    )->a( n = `title`            v = `Detail 1`
                    )->a( n = `backgroundDesign` v = `Solid`
                    )->a( n = `showNavButton`    v = `{= !${device>/system/desktop} }`
                    )->a( n = `navButtonPress`   v = client->_event( `DETAIL_BACK` )

                    )->leaf( `Label`
                        )->a( n = `text`  v = `Detail page 1`
                        )->a( n = `class` v = `sapUiTinyMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `Go to Detail page 2`
                        )->a( n = `press` v = client->_event( `NAV_TO_DETAIL` )

                )->shut(
                )->open( `Page`
                    )->a( n = `id`               v = `detailDetail`
                    )->a( n = `title`            v = `Detail Detail`
                    )->a( n = `backgroundDesign` v = `Solid`
                    )->a( n = `showNavButton`    v = `true`
                    )->a( n = `navButtonPress`   v = client->_event( `DETAIL_BACK` )

                    )->open( `VBox`
                        )->a( n = `class` v = `sapUiSmallMargin`

                        )->leaf( `Label`
                            )->a( n = `text` v = `This is Detail Page 2`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Here you could change the Split Application mode. After the mode change, resize the browser window to see the difference in the master form behaviour.`

                        )->open( `RadioButtonGroup`
                            )->a( n = `columns`       v = `1`
                            )->a( n = `width`         v = `500px`
                            )->a( n = `class`         v = `sapUiMediumMarginBottom`
                            )->a( n = `selectedIndex` v = client->_bind( mode_idx )
                            )->a( n = `select`        v = client->_event( `MODE_BTN` )

                            )->open( `buttons`
                                )->leaf( `RadioButton`
                                    )->a( n = `id`                 v = `RB1-1`
                                    )->a( n = `text`               v = `show/hide`
                                    )->a( n = `selected`           v = `true`
                                    )->a( n = `custom:splitAppMode` v = `ShowHideMode`
                                )->leaf( `RadioButton`
                                    )->a( n = `id`                 v = `RB1-2`
                                    )->a( n = `text`               v = `stretch/compress`
                                    )->a( n = `custom:splitAppMode` v = `StretchCompressMode`
                                )->leaf( `RadioButton`
                                    )->a( n = `id`                 v = `RB1-3`
                                    )->a( n = `text`               v = `hide`
                                    )->a( n = `custom:splitAppMode` v = `HideMode`
                                )->leaf( `RadioButton`
                                    )->a( n = `id`                 v = `RB1-4`
                                    )->a( n = `text`               v = `popover`
                                    )->a( n = `custom:splitAppMode` v = `PopoverMode`

                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
                )->open( `Page`
                    )->a( n = `id`               v = `detail2`
                    )->a( n = `title`            v = `Detail 3 Page`
                    )->a( n = `backgroundDesign` v = `Solid`
                    )->a( n = `showNavButton`    v = `true`
                    )->a( n = `navButtonPress`   v = client->_event( `DETAIL_BACK` )

                    )->leaf( `Label`
                        )->a( n = `text` v = `This is Detail Page 3`
                    )->leaf( `Input`
                    )->leaf( `Label`
                        )->a( n = `text` v = `Label 2`
                    )->leaf( `Input`
                    )->leaf( `Label`
                        )->a( n = `text` v = `Label 3`
                    )->leaf( `Input`
                    )->leaf( `Label`
                        )->a( n = `text` v = `Label 4`
                    )->leaf( `Input`
                    )->leaf( `Label`
                        )->a( n = `text` v = `Label 5`
                    )->leaf( `Input`

                )->shut(
            )->shut(
            )->open( `masterPages`
                )->open( `Page`
                    )->a( n = `id`               v = `master`
                    )->a( n = `title`            v = `Master 1`
                    )->a( n = `backgroundDesign` v = `List`

                    )->open( `List`
                        )->leaf( `StandardListItem`
                            )->a( n = `title` v = `To Master2`
                            )->a( n = `type`  v = `Navigation`
                            )->a( n = `press` v = client->_event( `GO_TO_MASTER` )

                )->shut(
                )->shut(
                )->open( `Page`
                    )->a( n = `id`               v = `master2`
                    )->a( n = `title`            v = `Master 2`
                    )->a( n = `backgroundDesign` v = `List`
                    )->a( n = `showNavButton`    v = `true`
                    )->a( n = `navButtonPress`   v = client->_event( `MASTER_BACK` )

                    )->open( `List`
                        )->leaf( `StandardListItem`
                            )->a( n = `title`     v = `To Detail 1`
                            )->a( n = `type`      v = `Active`
                            )->a( n = `custom:to` v = `detail`
                            )->a( n = `press`     v = client->_event( val = `NAV_DETAIL` t_arg = VALUE #( ( `detail` ) ) )
                        )->leaf( `StandardListItem`
                            )->a( n = `title`     v = `To Detail 2`
                            )->a( n = `type`      v = `Active`
                            )->a( n = `custom:to` v = `detailDetail`
                            )->a( n = `press`     v = client->_event( val = `NAV_DETAIL` t_arg = VALUE #( ( `detailDetail` ) ) )
                        )->leaf( `StandardListItem`
                            )->a( n = `title`     v = `To Detail 3`
                            )->a( n = `type`      v = `Active`
                            )->a( n = `custom:to` v = `detail2`
                            )->a( n = `press`     v = client->_event( val = `NAV_DETAIL` t_arg = VALUE #( ( `detail2` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `NAV_TO_DETAIL`.
        client->follow_up_action( val = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `SplitContDemo` ) ( `to` ) ( `detailDetail` ) ) ).

      WHEN `DETAIL_BACK`.
        client->follow_up_action( val = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `SplitContDemo` ) ( `backDetail` ) ) ).

      WHEN `MASTER_BACK`.
        client->follow_up_action( val = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `SplitContDemo` ) ( `backMaster` ) ) ).

      WHEN `GO_TO_MASTER`.
        client->follow_up_action( val = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `SplitContDemo` ) ( `toMaster` ) ( `master2` ) ) ).

      WHEN `NAV_DETAIL`.
        client->follow_up_action( val = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `SplitContDemo` ) ( `toDetail` ) ( client->get_event_arg( ) ) ) ).

      WHEN `MODE_BTN`.
        DATA(mode) = SWITCH string( mode_idx
                                    WHEN 0 THEN `ShowHideMode`
                                    WHEN 1 THEN `StretchCompressMode`
                                    WHEN 2 THEN `HideMode`
                                    WHEN 3 THEN `PopoverMode` ).
        client->follow_up_action( val = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `SplitContDemo` ) ( `setMode` ) ( mode ) ) ).
        client->message_toast_display( text = |Split Container mode is changed to: { mode }| duration = `5000` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
