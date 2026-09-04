" @keywords segmentedbutton segmented button sap.m segmentedbuttonvsd verticallayout viewsettingsdialog viewsettingsitem viewsettingsfilteritem
" @summary Segmented Button used in View Settings Dialog component
CLASS z2ui5_cl_smpc_app_516 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_dialog_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_516 IMPLEMENTATION.

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
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Button`
                )->a( n = `text`  v = `Open View Settings Dialog`
                )->a( n = `press` v = client->_event( `DIALOG_OPEN` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA filter_string TYPE string.

    CASE client->get_event( ).

      WHEN `DIALOG_OPEN`.
        popup_dialog_display( ).

      WHEN `CONFIRM`.
        " handleConfirm toasts the dialog's filterString when there is one
        
        filter_string = client->get_event_arg( ).
        IF filter_string IS NOT INITIAL.
          client->message_toast_display( filter_string ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD popup_dialog_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `ViewSettingsDialog`
            )->a( n = `id`      v = `mySettingsDialog`
            )->a( n = `confirm` v = client->_event( val = `CONFIRM` arg = `${$parameters>/filterString}` )

            )->ele( `sortItems`
                )->tag( `ViewSettingsItem`
                    )->a( n = `text`     v = `Field 1`
                    )->a( n = `key`      v = `1`
                    )->a( n = `selected` v = `true`
                )->tag( `ViewSettingsItem`
                    )->a( n = `text` v = `Field 2`
                    )->a( n = `key`  v = `2`
                )->tag( `ViewSettingsItem`
                    )->a( n = `text` v = `Field 3`
                    )->a( n = `key`  v = `3`

            )->end(
            )->ele( `groupItems`
                )->tag( `ViewSettingsItem`
                    )->a( n = `text`     v = `Field 1`
                    )->a( n = `key`      v = `1`
                    )->a( n = `selected` v = `true`
                )->tag( `ViewSettingsItem`
                    )->a( n = `text` v = `Field 2`
                    )->a( n = `key`  v = `2`
                )->tag( `ViewSettingsItem`
                    )->a( n = `text` v = `Field 3`
                    )->a( n = `key`  v = `3`

            )->end(
            )->ele( `filterItems`
                )->ele( `ViewSettingsFilterItem`
                    )->a( n = `text` v = `Field1`
                    )->a( n = `key`  v = `1`

                    )->ele( `items`
                        )->tag( `ViewSettingsItem`
                            )->a( n = `text` v = `Value A`
                            )->a( n = `key`  v = `1a`
                        )->tag( `ViewSettingsItem`
                            )->a( n = `text` v = `Value B`
                            )->a( n = `key`  v = `1b`
                        )->tag( `ViewSettingsItem`
                            )->a( n = `text` v = `Value C`
                            )->a( n = `key`  v = `1c`

                    )->end(
                )->end(

                )->ele( `ViewSettingsFilterItem`
                    )->a( n = `text` v = `Field2`
                    )->a( n = `key`  v = `2`

                    )->ele( `items`
                        )->tag( `ViewSettingsItem`
                            )->a( n = `text` v = `Value A`
                            )->a( n = `key`  v = `2a`
                        )->tag( `ViewSettingsItem`
                            )->a( n = `text` v = `Value B`
                            )->a( n = `key`  v = `2b`
                        )->tag( `ViewSettingsItem`
                            )->a( n = `text` v = `Value C`
                            )->a( n = `key`  v = `2c`

                    )->end(
                )->end(

                )->ele( `ViewSettingsFilterItem`
                    )->a( n = `text` v = `Field3`
                    )->a( n = `key`  v = `3`

                    )->ele( `items`
                        )->tag( `ViewSettingsItem`
                            )->a( n = `text` v = `Value A`
                            )->a( n = `key`  v = `3a`
                        )->tag( `ViewSettingsItem`
                            )->a( n = `text` v = `Value B`
                            )->a( n = `key`  v = `3b`
                        )->tag( `ViewSettingsItem`
                            )->a( n = `text` v = `Value C`
                            )->a( n = `key`  v = `3c` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
