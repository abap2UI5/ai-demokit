" @keywords viewsettingsdialog settings dialog sap.m viewsettingsdialogcustom viewsettingscustomitem slider verticallayout button
" @summary You can have custom filters in your View Settings Dialog, as shown in this example here.
CLASS z2ui5_cl_smpc_app_295 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA slider_value TYPE i.
    DATA filter_count TYPE i.
    DATA filter_selected TYPE abap_bool.

  PROTECTED SECTION.
    CONSTANTS c_reset_value TYPE i VALUE 50.

    DATA client TYPE REF TO z2ui5_if_client.

    DATA previous_value TYPE i.

    METHODS view_display.
    METHODS on_event.
    METHODS filter_state_set
      IMPORTING
        active TYPE abap_bool.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_295 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        " the controller-loaded Dialog fragment, declared in the view's dependents aggregation
        )->ele( n = `dependents` ns = `mvc`

            )->ele( `ViewSettingsDialog`
                )->a( n = `id`           v = `settingsDialog`
                )->a( n = `confirm`      v = client->_event( val = `CONFIRM` arg = `${$parameters>/filterString}` )
                )->a( n = `cancel`       v = client->_event( `CANCEL` )
                )->a( n = `resetFilters` v = client->_event( `RESET_FILTERS` )

                )->ele( `filterItems`
                    )->ele( `ViewSettingsCustomItem`
                        )->a( n = `id`          v = `idCustomFilterItem`
                        )->a( n = `text`        v = `Custom Filter`
                        )->a( n = `key`         v = `myFilter`
                        )->a( n = `filterCount` v = client->_bind( filter_count )
                        )->a( n = `selected`    v = client->_bind( filter_selected )

                        )->ele( `customControl`
                            )->tag( `Slider`
                                )->a( n = `step`   v = `10`
                                )->a( n = `value`  v = client->_bind( slider_value )
                                )->a( n = `change` v = client->_event( val = `SLIDER_CHANGE` arg = `${$parameters>/value}` )

                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Button`
                )->a( n = `text`  v = `Open with Custom Filter`
                )->a( n = `press` v = client->_event( `OPEN_DIALOG` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE string_table.
        DATA temp2 TYPE xsdboolean.
        DATA filter_string TYPE string.
        DATA temp3 TYPE xsdboolean.

    CASE client->get_event( ).

      WHEN `OPEN_DIALOG`.
        
        CLEAR temp1.
        INSERT `settingsDialog` INTO TABLE temp1.
        INSERT `open` INTO TABLE temp1.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp1 ).

      WHEN `SLIDER_CHANGE`.
        " the original compares the new value against the last confirmed one
        " and marks the custom filter active when they differ
        slider_value = client->get_event_arg( ).
        
        temp2 = boolc( slider_value <> previous_value ).
        filter_state_set( temp2 ).

      WHEN `CONFIRM`.
        previous_value = slider_value.
        
        filter_string = client->get_event_arg( ).
        IF filter_string IS NOT INITIAL.
          client->message_toast_display( |{ filter_string } Value is { slider_value }| ).
        ENDIF.

      WHEN `CANCEL`.
        " discard the unconfirmed value and re-derive the filter state from it
        slider_value = previous_value.
        
        temp3 = boolc( previous_value <> c_reset_value ).
        filter_state_set( temp3 ).

      WHEN `RESET_FILTERS`.
        slider_value = c_reset_value.
        filter_state_set( abap_false ).

    ENDCASE.

  ENDMETHOD.


  METHOD filter_state_set.

    DATA temp3 TYPE i.
    IF active = abap_true.
      temp3 = 1.
    ELSE.
      temp3 = 0.
    ENDIF.
    filter_count    = temp3.
    filter_selected = active.


  ENDMETHOD.


  METHOD model_init.

    slider_value   = c_reset_value.
    previous_value = c_reset_value.

  ENDMETHOD.

ENDCLASS.
