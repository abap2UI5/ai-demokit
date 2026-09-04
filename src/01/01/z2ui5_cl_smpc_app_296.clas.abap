" @keywords viewsettingsdialog settings dialog sap.m viewsettingsdialogcustomfilterdetails viewsettingsfilteritem viewsettingsitem verticallayout button
" @summary You can filter the items in the filter details page using different string filter operators.
CLASS z2ui5_cl_smpc_app_296 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA search_operator TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS dialog_open
      IMPORTING
        operator TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_296 IMPLEMENTATION.

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
                )->a( n = `id`                   v = `settingsDialog`
                )->a( n = `filterSearchOperator` v = client->_bind( search_operator )

                )->ele( `filterItems`
                    )->ele( `ViewSettingsFilterItem`
                        )->a( n = `text` v = `Products`
                        )->a( n = `key`  v = `1`

                        )->ele( `items`
                            )->tag( `ViewSettingsItem`
                                )->a( n = `text` v = `Mouse DX20`
                                )->a( n = `key`  v = `1a`
                            )->tag( `ViewSettingsItem`
                                )->a( n = `text` v = `Optical mouse OX3`
                                )->a( n = `key`  v = `1b`
                            )->tag( `ViewSettingsItem`
                                )->a( n = `text` v = `Monitor`
                                )->a( n = `key`  v = `1c`
                            )->tag( `ViewSettingsItem`
                                )->a( n = `text` v = `Keyboard (ultra flat)`
                                )->a( n = `key`  v = `1d`
                            )->tag( `ViewSettingsItem`
                                )->a( n = `text` v = `Wireless keyboard`
                                )->a( n = `key`  v = `1e`

                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Button`
                )->a( n = `text`  v = `Search Contains`
                )->a( n = `press` v = client->_event( `OPEN_CONTAINS` )
            )->tag( `Button`
                )->a( n = `text`  v = `Search Any Word Starts With`
                )->a( n = `press` v = client->_event( `OPEN_ANY_WORD` )
            )->tag( `Button`
                )->a( n = `text`  v = `Search Case Sensitive Contains`
                )->a( n = `press` v = client->_event( `OPEN_CUSTOM` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `OPEN_CONTAINS`.
        dialog_open( `Contains` ).

      WHEN `OPEN_ANY_WORD`.
        dialog_open( `AnyWordStartsWith` ).

      WHEN `OPEN_CUSTOM`.
        " the original installs a case-SENSITIVE contains callback here; a live
        " JS function has no declarative equivalent, so the closest built-in
        " operator (case-insensitive Contains) is used instead
        dialog_open( `Contains` ).

    ENDCASE.

  ENDMETHOD.


  METHOD dialog_open.
    DATA temp1 TYPE string_table.

    search_operator = operator.

    
    CLEAR temp1.
    INSERT `settingsDialog` INTO TABLE temp1.
    INSERT `open` INTO TABLE temp1.
    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = temp1 ).

  ENDMETHOD.


  METHOD model_init.

    search_operator = `Contains`.

  ENDMETHOD.

ENDCLASS.
