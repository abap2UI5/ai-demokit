CLASS z2ui5_cl_dmo_app_297 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA date_value_state TYPE string.
    DATA date_value_state_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_297 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        " the three controller-loaded fragments, declared in the view's dependents aggregation
        )->open( n = `dependents` ns = `mvc`

            )->open( `ViewSettingsDialog`
                )->a( n = `id`      v = `settingsDialog`
                )->a( n = `confirm` v = client->_event( val   = `CONFIRM`
                                                        t_arg = VALUE #( ( `${$parameters>/filterString}` ) ) )

                )->open( `sortItems`
                    )->leaf( `ViewSettingsItem`
                        )->a( n = `text`     v = `Field 1`
                        )->a( n = `key`      v = `1`
                        )->a( n = `selected` v = `true`
                    )->leaf( `ViewSettingsItem`
                        )->a( n = `text` v = `Field 2`
                        )->a( n = `key`  v = `2`
                    )->leaf( `ViewSettingsItem`
                        )->a( n = `text` v = `Field 3`
                        )->a( n = `key`  v = `3`

                )->shut(
                )->open( `groupItems`
                    )->leaf( `ViewSettingsItem`
                        )->a( n = `text`     v = `Field 1`
                        )->a( n = `key`      v = `1`
                        )->a( n = `selected` v = `true`
                    )->leaf( `ViewSettingsItem`
                        )->a( n = `text` v = `Field 2`
                        )->a( n = `key`  v = `2`
                    )->leaf( `ViewSettingsItem`
                        )->a( n = `text` v = `Field 3`
                        )->a( n = `key`  v = `3`

                )->shut(
                )->open( `filterItems`
                    )->open( `ViewSettingsFilterItem`
                        )->a( n = `text` v = `Field1`
                        )->a( n = `key`  v = `1`

                        )->open( `items`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Value A`
                                )->a( n = `key`  v = `1a`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Value B`
                                )->a( n = `key`  v = `1b`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Value C`
                                )->a( n = `key`  v = `1c`

                        )->shut(
                    )->shut(
                    )->open( `ViewSettingsFilterItem`
                        )->a( n = `text` v = `Field2`
                        )->a( n = `key`  v = `2`

                        )->open( `items`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Value A`
                                )->a( n = `key`  v = `2a`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Value B`
                                )->a( n = `key`  v = `2b`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Value C`
                                )->a( n = `key`  v = `2c`

                        )->shut(
                    )->shut(
                    )->open( `ViewSettingsFilterItem`
                        )->a( n = `text` v = `Field3`
                        )->a( n = `key`  v = `3`

                        )->open( `items`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Value A`
                                )->a( n = `key`  v = `3a`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Value B`
                                )->a( n = `key`  v = `3b`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Value C`
                                )->a( n = `key`  v = `3c`

                        )->shut(
                    )->shut(
                )->shut(
                )->open( `customTabs`
                    )->open( `ViewSettingsCustomTab`
                        )->a( n = `id`      v = `app-settings`
                        )->a( n = `icon`    v = `sap-icon://action-settings`
                        )->a( n = `title`   v = `Settings`
                        )->a( n = `tooltip` v = `Application Settings`

                        )->open( `content`
                            )->open( `Panel`
                                )->a( n = `height` v = `338px`

                                )->open( `content`

                                    )->leaf( `Label`
                                        )->a( n = `text`   v = `Theme`
                                        )->a( n = `design` v = `Bold`
                                        )->a( n = `id`     v = `VSDThemeLabel`

                                    )->open( `SegmentedButton`
                                        )->a( n = `class`        v = `vsdSetting`
                                        )->a( n = `selectedItem` v = `VSDsap_quartzlight`
                                        )->a( n = `id`           v = `VSDThemeButtons`
                                        )->a( n = `width`        v = `100%`

                                        )->open( `items`
                                            )->leaf( `SegmentedButtonItem`
                                                )->a( n = `text` v = `High Contrast Black`
                                                )->a( n = `id`   v = `VSDsap_hcb`
                                            )->leaf( `SegmentedButtonItem`
                                                )->a( n = `text` v = `Quartz Light`
                                                )->a( n = `id`   v = `VSDsap_quartzlight`

                                        )->shut(
                                    )->shut(

                                    )->leaf( `Label`
                                        )->a( n = `text`   v = `Compact Content Density`
                                        )->a( n = `design` v = `Bold`

                                    )->open( `SegmentedButton`
                                        )->a( n = `class`        v = `vsdSetting`
                                        )->a( n = `selectedItem` v = `VSDcompactOn`
                                        )->a( n = `id`           v = `VSDCompactModeButtons`
                                        )->a( n = `width`        v = `100%`

                                        )->open( `items`
                                            )->leaf( `SegmentedButtonItem`
                                                )->a( n = `text` v = `On`
                                                )->a( n = `id`   v = `VSDcompactOn`
                                            )->leaf( `SegmentedButtonItem`
                                                )->a( n = `text` v = `Off`
                                                )->a( n = `id`   v = `VSDcompactOff`

                                        )->shut(
                                    )->shut(

                                    )->leaf( `Label`
                                        )->a( n = `text`   v = `Right To Left Mode`
                                        )->a( n = `design` v = `Bold`

                                    )->open( `SegmentedButton`
                                        )->a( n = `selectedItem` v = `VSDRTLOff`
                                        )->a( n = `id`           v = `VSDRTLButtons`
                                        )->a( n = `width`        v = `100%`

                                        )->open( `items`
                                            )->leaf( `SegmentedButtonItem`
                                                )->a( n = `text` v = `On`
                                                )->a( n = `id`   v = `VSDRTLOn`
                                            )->leaf( `SegmentedButtonItem`
                                                )->a( n = `text` v = `Off`
                                                )->a( n = `id`   v = `VSDRTLOff`

                                        )->shut(
                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                    )->open( `ViewSettingsCustomTab`
                        )->a( n = `id`      v = `example-settings`
                        )->a( n = `tooltip` v = `default icon`

                        )->open( `content`
                            )->leaf( `Button`
                                )->a( n = `text` v = `simple button example`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `ViewSettingsDialog`
                )->a( n = `id`      v = `settingsDialogCustomTab`
                )->a( n = `confirm` v = client->_event( val   = `CONFIRM`
                                                        t_arg = VALUE #( ( `${$parameters>/filterString}` ) ) )

                )->open( `customTabs`
                    )->open( `ViewSettingsCustomTab`
                        )->a( n = `id`      v = `app-settings-single`
                        )->a( n = `icon`    v = `sap-icon://action-settings`
                        )->a( n = `title`   v = `Settings`
                        )->a( n = `tooltip` v = `Application Settings`

                        )->open( `content`
                            )->open( `Panel`
                                )->a( n = `height` v = `386px`

                                )->leaf( `Label`
                                    )->a( n = `text`   v = `Theme`
                                    )->a( n = `design` v = `Bold`
                                    )->a( n = `id`     v = `VSDThemeLabelSingle`

                                )->open( `SegmentedButton`
                                    )->a( n = `class`        v = `vsdSetting`
                                    )->a( n = `selectedItem` v = `VSDsap_quartzlightSingle`
                                    )->a( n = `id`           v = `VSDThemeButtonsSingle`
                                    )->a( n = `width`        v = `100%`

                                    )->open( `items`
                                        )->leaf( `SegmentedButtonItem`
                                            )->a( n = `text` v = `High Contrast Black`
                                            )->a( n = `id`   v = `VSDsap_hcbSingle`
                                        )->leaf( `SegmentedButtonItem`
                                            )->a( n = `text` v = `Quartz Light`
                                            )->a( n = `id`   v = `VSDsap_quartzlightSingle`

                                    )->shut(
                                )->shut(

                                )->leaf( `Label`
                                    )->a( n = `text`   v = `Compact Content Density`
                                    )->a( n = `design` v = `Bold`

                                )->open( `SegmentedButton`
                                    )->a( n = `class`        v = `vsdSetting`
                                    )->a( n = `selectedItem` v = `VSDcompactOnSingle`
                                    )->a( n = `id`           v = `VSDCompactModeButtonsSingle`
                                    )->a( n = `width`        v = `100%`

                                    )->open( `items`
                                        )->leaf( `SegmentedButtonItem`
                                            )->a( n = `text` v = `On`
                                            )->a( n = `id`   v = `VSDcompactOnSingle`
                                        )->leaf( `SegmentedButtonItem`
                                            )->a( n = `text` v = `Off`
                                            )->a( n = `id`   v = `VSDcompactOffSingle`

                                    )->shut(
                                )->shut(

                                )->leaf( `Label`
                                    )->a( n = `text`   v = `Right To Left Mode`
                                    )->a( n = `design` v = `Bold`

                                )->open( `SegmentedButton`
                                    )->a( n = `selectedItem` v = `VSDRTLOffSingle`
                                    )->a( n = `id`           v = `VSDRTLButtonsSingle`
                                    )->a( n = `width`        v = `100%`

                                    )->open( `items`
                                        )->leaf( `SegmentedButtonItem`
                                            )->a( n = `text` v = `On`
                                            )->a( n = `id`   v = `VSDRTLOnSingle`
                                        )->leaf( `SegmentedButtonItem`
                                            )->a( n = `text` v = `Off`
                                            )->a( n = `id`   v = `VSDRTLOffSingle`

                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `ViewSettingsDialog`
                )->a( n = `id`          v = `settingsDialogDatePicker`
                )->a( n = `confirm`     v = client->_event( val   = `CONFIRM`
                                                            t_arg = VALUE #( ( `${$parameters>/filterString}` ) ) )
                )->a( n = `beforeClose` v = client->_event(
                          val    = `BEFORE_CLOSE`
                          s_ctrl = VALUE #( prevent_default_expr = |${ client->_bind( val  = date_value_state
                                                                                     path = abap_true ) } === 'Error'| ) )

                )->open( `customTabs`
                    )->open( `ViewSettingsCustomTab`
                        )->a( n = `id`      v = `app-settings-datepicker`
                        )->a( n = `icon`    v = `sap-icon://action-settings`
                        )->a( n = `title`   v = `Settings`
                        )->a( n = `tooltip` v = `Application Settings`

                        )->open( `content`
                            )->leaf( `DatePicker`
                                )->a( n = `id`             v = `datePicker`
                                )->a( n = `class`          v = `vsd-dp`
                                )->a( n = `width`          v = `80%`
                                )->a( n = `valueState`     v = client->_bind( date_value_state )
                                )->a( n = `valueStateText` v = client->_bind( date_value_state_text )
                                )->a( n = `change`         v = client->_event(
                                          val   = `DATE_CHANGE`
                                          t_arg = VALUE #( ( `${$parameters>/valid}` ) ) )

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut(

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->leaf( `Button`
                )->a( n = `text`  v = `Open View Settings Dialog with several tabs`
                )->a( n = `press` v = client->_event( `OPEN_DIALOG` )
            )->leaf( `Button`
                )->a( n = `text`  v = `Open View Settings Dialog with single custom tab`
                )->a( n = `press` v = client->_event( `OPEN_SINGLE_TAB` )
            )->leaf( `Button`
                )->a( n = `text`  v = `Open View Settings Dialog with single custom tab with DatePicker`
                )->a( n = `press` v = client->_event( `OPEN_DATE_PICKER` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `OPEN_DIALOG`.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `settingsDialog` ) ( `open` ) ) ).

      WHEN `OPEN_SINGLE_TAB`.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `settingsDialogCustomTab` ) ( `open` ) ) ).

      WHEN `OPEN_DATE_PICKER`.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `settingsDialogDatePicker` ) ( `open` ) ) ).

      WHEN `DATE_CHANGE`.
        " the original validateDate: an unparsable date marks the field
        IF client->get_event_arg( ) = abap_true.
          date_value_state      = `None`.
          date_value_state_text = ``.

        ELSE.
          date_value_state      = `Error`.
          date_value_state_text = `Invalid date. Please enter a date in the correct format.`.
        ENDIF.
        client->view_model_update( ).

      WHEN `BEFORE_CLOSE`.
        " the client already vetoed the close when the state is Error (see the
        " prevent_default_expr on the wire); the backend only adds the message
        IF date_value_state = `Error`.
          client->message_toast_display( `The entered date is invalid. Please correct it before closing the dialog.` ).
        ENDIF.

      WHEN `CONFIRM`.
        DATA(filter_string) = client->get_event_arg( ).
        IF filter_string IS NOT INITIAL.
          client->message_toast_display( filter_string ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    date_value_state = `None`.

  ENDMETHOD.

ENDCLASS.
