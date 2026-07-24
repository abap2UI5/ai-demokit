CLASS z2ui5_cl_ai_app_098 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_098 IMPLEMENTATION.

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
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        " the controller-loaded fragments, declared in the view's dependents aggregation
        )->open( n = `dependents` ns = `mvc`

            )->open( `ViewSettingsDialog`
                )->a( n = `id`      v = `vsd`
                )->a( n = `confirm` v = client->_event( val = `CONFIRM` t_arg = VALUE #( ( `${$parameters>/filterString}` ) ) )

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
            )->shut(

            )->open( `ViewSettingsDialog`
                )->a( n = `id`               v = `vsdPreselected`
                )->a( n = `title`            v = `Preselected Settings`
                )->a( n = `sortDescending`   v = `true`
                )->a( n = `groupDescending`  v = `true`
                )->a( n = `confirm`          v = client->_event( val = `CONFIRM` t_arg = VALUE #( ( `${$parameters>/filterString}` ) ) )
                )->a( n = `selectedSortItem` v = `sortItem3`

                )->open( `sortItems`
                    )->leaf( `ViewSettingsItem`
                        )->a( n = `text` v = `Field 1`
                        )->a( n = `key`  v = `1`
                    )->leaf( `ViewSettingsItem`
                        )->a( n = `text` v = `Field 2`
                        )->a( n = `key`  v = `2`
                    )->leaf( `ViewSettingsItem`
                        )->a( n = `id`   v = `sortItem3`
                        )->a( n = `text` v = `Field 3`
                        )->a( n = `key`  v = `3`

                )->shut(
                )->open( `groupItems`
                    )->leaf( `ViewSettingsItem`
                        )->a( n = `text` v = `Field 1`
                        )->a( n = `key`  v = `1`
                    )->leaf( `ViewSettingsItem`
                        )->a( n = `text`     v = `Field 2`
                        )->a( n = `key`      v = `2`
                        )->a( n = `selected` v = `true`
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
                                )->a( n = `text`     v = `Value A`
                                )->a( n = `key`      v = `1a`
                                )->a( n = `selected` v = `true`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Value B`
                                )->a( n = `key`  v = `1b`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Value C`
                                )->a( n = `key`  v = `1c`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Value D`
                                )->a( n = `key`  v = `1d`

                        )->shut(
                    )->shut(
                    )->open( `ViewSettingsFilterItem`
                        )->a( n = `text` v = `Field2`
                        )->a( n = `key`  v = `2`

                        )->open( `items`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text`     v = `Value A`
                                )->a( n = `key`      v = `2a`
                                )->a( n = `selected` v = `true`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text`     v = `Value B`
                                )->a( n = `key`      v = `2b`
                                )->a( n = `selected` v = `true`

                        )->shut(
                    )->shut(
                    )->open( `ViewSettingsFilterItem`
                        )->a( n = `text` v = `Field3`
                        )->a( n = `key`  v = `3`

                        )->open( `items`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text`     v = `Value A`
                                )->a( n = `key`      v = `3a`
                                )->a( n = `selected` v = `true`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text`     v = `Value B`
                                )->a( n = `key`      v = `3b`
                                )->a( n = `selected` v = `true`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text`     v = `Value C`
                                )->a( n = `key`      v = `3c`
                                )->a( n = `selected` v = `true`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Value D`
                                )->a( n = `key`  v = `3d`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Value E`
                                )->a( n = `key`  v = `3e`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `ViewSettingsDialog`
                )->a( n = `id`      v = `vsdPreset`
                )->a( n = `confirm` v = client->_event( val = `CONFIRM` t_arg = VALUE #( ( `${$parameters>/filterString}` ) ) )

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
                " presetFilterItems added declaratively (the original adds them in _presetFiltersInit; the Filter payload is inert here — no list is bound)
                )->open( `presetFilterItems`
                    )->leaf( `ViewSettingsItem`
                        )->a( n = `key`  v = `myPresetFilter1`
                        )->a( n = `text` v = `A very complex filter`
                    )->leaf( `ViewSettingsItem`
                        )->a( n = `key`  v = `myPresetFilter2`
                        )->a( n = `text` v = `Ridiculously complex filter`
                    )->leaf( `ViewSettingsItem`
                        )->a( n = `key`  v = `myPresetFilter3`
                        )->a( n = `text` v = `Expensive stuff`

                )->shut(
            )->shut(
        )->shut(

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->leaf( `Button`
                )->a( n = `text`  v = `Open View Settings Dialog`
                )->a( n = `press` v = client->_event( `OPEN_DIALOG` )
            )->leaf( `Button`
                )->a( n = `text`  v = `Open View Settings Dialog in Filter view`
                )->a( n = `press` v = client->_event( `OPEN_FILTER` )
            )->leaf( `Button`
                )->a( n = `text`  v = `Open View Settings Dialog with preselected filters`
                )->a( n = `press` v = client->_event( `OPEN_PRESELECTED` )
            )->leaf( `Button`
                )->a( n = `text`  v = `Open View Settings Dialog with presetFilterItems`
                )->a( n = `press` v = client->_event( `OPEN_PRESET` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `OPEN_DIALOG`.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `vsd` ) ( `open` ) ) ).

      WHEN `OPEN_FILTER`.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `vsd` ) ( `open` ) ( `filter` ) ) ).

      WHEN `OPEN_PRESELECTED`.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `vsdPreselected` ) ( `open` ) ( `filter` ) ) ).

      WHEN `OPEN_PRESET`.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `vsdPreset` ) ( `open` ) ( `filter` ) ) ).

      WHEN `CONFIRM`.
        DATA(filter_string) = client->get_event_arg( ).
        IF filter_string IS NOT INITIAL.
          client->message_toast_display( filter_string ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
