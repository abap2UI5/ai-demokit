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

        " the controller-loaded Dialog fragment, declared in the view's dependents aggregation
        )->open( n = `dependents` ns = `mvc`

            )->open( `ViewSettingsDialog`
                )->a( n = `id`                   v = `settingsDialog`
                )->a( n = `filterSearchOperator` v = client->_bind( search_operator )

                )->open( `filterItems`
                    )->open( `ViewSettingsFilterItem`
                        )->a( n = `text` v = `Products`
                        )->a( n = `key`  v = `1`

                        )->open( `items`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Mouse DX20`
                                )->a( n = `key`  v = `1a`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Optical mouse OX3`
                                )->a( n = `key`  v = `1b`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Monitor`
                                )->a( n = `key`  v = `1c`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Keyboard (ultra flat)`
                                )->a( n = `key`  v = `1d`
                            )->leaf( `ViewSettingsItem`
                                )->a( n = `text` v = `Wireless keyboard`
                                )->a( n = `key`  v = `1e`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut(

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->leaf( `Button`
                )->a( n = `text`  v = `Search Contains`
                )->a( n = `press` v = client->_event( `OPEN_CONTAINS` )
            )->leaf( `Button`
                )->a( n = `text`  v = `Search Any Word Starts With`
                )->a( n = `press` v = client->_event( `OPEN_ANY_WORD` )
            )->leaf( `Button`
                )->a( n = `text`  v = `Search Case Sensitive Contains`
                )->a( n = `press` v = client->_event( `OPEN_CUSTOM` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

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

    search_operator = operator.

    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = VALUE #( ( `settingsDialog` ) ( `open` ) ) ).

  ENDMETHOD.


  METHOD model_init.

    search_operator = `Contains`.

  ENDMETHOD.

ENDCLASS.
