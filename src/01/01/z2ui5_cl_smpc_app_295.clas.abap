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
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        " the controller-loaded Dialog fragment, declared in the view's dependents aggregation
        )->ele( n = `dependents` ns = `mvc`

            )->ele( `ViewSettingsDialog`
                )->a( n = `id`           v = `settingsDialog`
                )->a( n = `confirm`      v = client->_event( val   = `CONFIRM`
                                                             t_arg = VALUE #( ( `${$parameters>/filterString}` ) ) )
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
                                )->a( n = `change` v = client->_event( val   = `SLIDER_CHANGE`
                                                                       t_arg = VALUE #( ( `${$parameters>/value}` ) ) )

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

    CASE client->get_event( ).

      WHEN `OPEN_DIALOG`.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `settingsDialog` ) ( `open` ) ) ).

      WHEN `SLIDER_CHANGE`.
        " the original compares the new value against the last confirmed one
        " and marks the custom filter active when they differ
        slider_value = CONV i( client->get_event_arg( ) ).
        filter_state_set( xsdbool( slider_value <> previous_value ) ).

      WHEN `CONFIRM`.
        previous_value = slider_value.
        DATA(filter_string) = client->get_event_arg( ).
        IF filter_string IS NOT INITIAL.
          client->message_toast_display( |{ filter_string } Value is { slider_value }| ).
        ENDIF.

      WHEN `CANCEL`.
        " discard the unconfirmed value and re-derive the filter state from it
        slider_value = previous_value.
        filter_state_set( xsdbool( previous_value <> c_reset_value ) ).

      WHEN `RESET_FILTERS`.
        slider_value = c_reset_value.
        filter_state_set( abap_false ).

    ENDCASE.

  ENDMETHOD.


  METHOD filter_state_set.

    filter_count    = COND #( WHEN active = abap_true THEN 1 ELSE 0 ).
    filter_selected = active.


  ENDMETHOD.


  METHOD model_init.

    slider_value   = c_reset_value.
    previous_value = c_reset_value.

  ENDMETHOD.

ENDCLASS.
