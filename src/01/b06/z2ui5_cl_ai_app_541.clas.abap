CLASS z2ui5_cl_ai_app_541 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA drs1_start TYPE string.
    DATA drs1_end TYPE string.
    DATA drs2_start TYPE string.
    DATA drs2_end TYPE string.
    DATA drs2_min_date TYPE string.
    DATA drs2_max_date TYPE string.
    DATA drs3_start TYPE string.
    DATA drs3_end TYPE string.
    DATA drs4_start TYPE string.
    DATA drs4_end TYPE string.
    DATA drs5_start TYPE string.
    DATA drs5_end TYPE string.
    DATA drs1_value_state TYPE string.
    DATA drs2_value_state TYPE string.
    DATA drs3_value_state TYPE string.
    DATA drs4_value_state TYPE string.
    DATA drs5_value_state TYPE string.
    DATA event_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_541 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the original controller's UI5Date objects kept as ISO strings - the Date part types parse them via their source pattern
    drs1_start       = `2014-02-02`.
    drs1_end         = `2014-02-17`.
    drs2_start       = `2016-02-16`.
    drs2_end         = `2016-02-18`.
    drs2_min_date    = `2016-01-01`.
    drs2_max_date    = `2016-12-31`.
    drs3_start       = `2014-02-02`.
    drs3_end         = `2014-02-17`.
    drs4_start       = `2019-04-02`.
    drs4_end         = `2019-10-17`.
    drs5_start       = `2009-02-02`.
    drs5_end         = `2025-02-17`.
    drs1_value_state = `None`.
    drs2_value_state = `None`.
    drs3_value_state = `None`.
    drs4_value_state = `None`.
    drs5_value_state = `None`.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->leaf( `Label`
                )->a( n = `text`     v = `DateRangeSelection displayFormat 'yyyy/MM/dd', set via binding:`
                )->a( n = `labelFor` v = `DRS1`
            " valueState is bound on every DateRangeSelection - the original change handler sets it imperatively on the event source
            )->leaf( `DateRangeSelection`
                )->a( n = `id`         v = `DRS1`
                )->a( n = `class`      v = `DRS1`
                )->a( n = `value`      v = |\{ 'type': 'sap.ui.model.type.DateInterval', 'formatOptions': \{ 'pattern': 'yyyy/MM/dd' \}, 'parts': [| &&
                                           | \{ 'type': 'sap.ui.model.type.Date', 'formatOptions': \{ 'source': \{ 'pattern': 'yyyy-MM-dd' \} \}, 'path': '{ client->_bind( val = drs1_start path = abap_true ) }' \},| &&
                                           | \{ 'type': 'sap.ui.model.type.Date', 'formatOptions': \{ 'source': \{ 'pattern': 'yyyy-MM-dd' \} \}, 'path': '{ client->_bind( val = drs1_end path = abap_true ) }' \} ] \}|
                )->a( n = `change`     v = client->_event( val   = `CHANGE`
                                                           t_arg = VALUE #( ( `$event.oSource.sId` )
                                                                            ( `${$parameters>/from}` )
                                                                            ( `${$parameters>/to}` )
                                                                            ( `${$parameters>/valid}` ) ) )
                )->a( n = `valueState` v = client->_bind( drs1_value_state )
            )->leaf( `Label`
                )->a( n = `text`     v = `DateRangeSelection with minDate=2016-01-01 and maxDate=2016-12-31:`
                )->a( n = `labelFor` v = `DRS2`
            " the original controller's onInit sets minDate/maxDate imperatively - bound here via Formatter.DateCreateObject (core:require on the view root)
            )->leaf( `DateRangeSelection`
                )->a( n = `id`         v = `DRS2`
                )->a( n = `change`     v = client->_event( val   = `CHANGE`
                                                           t_arg = VALUE #( ( `$event.oSource.sId` )
                                                                            ( `${$parameters>/from}` )
                                                                            ( `${$parameters>/to}` )
                                                                            ( `${$parameters>/valid}` ) ) )
                )->a( n = `value`      v = |\{ 'type': 'sap.ui.model.type.DateInterval', 'parts': [| &&
                                           | \{ 'type': 'sap.ui.model.type.Date', 'formatOptions': \{ 'source': \{ 'pattern': 'yyyy-MM-dd' \} \}, 'path': '{ client->_bind( val = drs2_start path = abap_true ) }' \},| &&
                                           | \{ 'type': 'sap.ui.model.type.Date', 'formatOptions': \{ 'source': \{ 'pattern': 'yyyy-MM-dd' \} \}, 'path': '{ client->_bind( val = drs2_end path = abap_true ) }' \} ] \}|
                )->a( n = `minDate`    v = |\{ path: '{ client->_bind( val = drs2_min_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `maxDate`    v = |\{ path: '{ client->_bind( val = drs2_max_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `valueState` v = client->_bind( drs2_value_state )
            )->leaf( `Label`
                )->a( n = `text`     v = `DateRangeSelection with OK button in the footer and with shortcut for today:`
                )->a( n = `labelFor` v = `DRS3`
            " showCurrentDateButton is since UI5 1.95, kept for the 1:1 port (POST_171)
            )->leaf( `DateRangeSelection`
                )->a( n = `id`                    v = `DRS3`
                )->a( n = `showCurrentDateButton` v = `true`
                )->a( n = `showFooter`            v = `true`
                )->a( n = `change`                v = client->_event( val   = `CHANGE`
                                                                      t_arg = VALUE #( ( `$event.oSource.sId` )
                                                                                       ( `${$parameters>/from}` )
                                                                                       ( `${$parameters>/to}` )
                                                                                       ( `${$parameters>/valid}` ) ) )
                )->a( n = `value`                 v = |\{ 'type': 'sap.ui.model.type.DateInterval', 'parts': [| &&
                                                      | \{ 'type': 'sap.ui.model.type.Date', 'formatOptions': \{ 'source': \{ 'pattern': 'yyyy-MM-dd' \} \}, 'path': '{ client->_bind( val = drs3_start path = abap_true ) }' \},| &&
                                                      | \{ 'type': 'sap.ui.model.type.Date', 'formatOptions': \{ 'source': \{ 'pattern': 'yyyy-MM-dd' \} \}, 'path': '{ client->_bind( val = drs3_end path = abap_true ) }' \} ] \}|
                )->a( n = `valueState`            v = client->_bind( drs3_value_state )
            )->leaf( `Label`
                )->a( n = `text`     v = `DateRangeSelection with displayFormat 'MM/yyyy':`
                )->a( n = `labelFor` v = `DRS4`
            )->leaf( `DateRangeSelection`
                )->a( n = `id`         v = `DRS4`
                )->a( n = `change`     v = client->_event( val   = `CHANGE`
                                                           t_arg = VALUE #( ( `$event.oSource.sId` )
                                                                            ( `${$parameters>/from}` )
                                                                            ( `${$parameters>/to}` )
                                                                            ( `${$parameters>/valid}` ) ) )
                )->a( n = `value`      v = |\{ 'type': 'sap.ui.model.type.DateInterval', 'formatOptions': \{ 'pattern': 'MM/yyyy' \}, 'parts': [| &&
                                           | \{ 'type': 'sap.ui.model.type.Date', 'formatOptions': \{ 'source': \{ 'pattern': 'yyyy-MM-dd' \} \}, 'path': '{ client->_bind( val = drs4_start path = abap_true ) }' \},| &&
                                           | \{ 'type': 'sap.ui.model.type.Date', 'formatOptions': \{ 'source': \{ 'pattern': 'yyyy-MM-dd' \} \}, 'path': '{ client->_bind( val = drs4_end path = abap_true ) }' \} ] \}|
                )->a( n = `valueState` v = client->_bind( drs4_value_state )
            )->leaf( `Label`
                )->a( n = `text`     v = `DateRangeSelection with displayFormat 'yyyy':`
                )->a( n = `labelFor` v = `DRS5`
            )->leaf( `DateRangeSelection`
                )->a( n = `id`            v = `DRS5`
                )->a( n = `displayFormat` v = `yyyy`
                )->a( n = `change`        v = client->_event( val   = `CHANGE`
                                                              t_arg = VALUE #( ( `$event.oSource.sId` )
                                                                               ( `${$parameters>/from}` )
                                                                               ( `${$parameters>/to}` )
                                                                               ( `${$parameters>/valid}` ) ) )
                )->a( n = `value`         v = |\{ 'type': 'sap.ui.model.type.DateInterval', 'formatOptions': \{ 'pattern': 'yyyy' \}, 'parts': [| &&
                                              | \{ 'type': 'sap.ui.model.type.Date', 'formatOptions': \{ 'source': \{ 'pattern': 'yyyy-MM-dd' \} \}, 'path': '{ client->_bind( val = drs5_start path = abap_true ) }' \},| &&
                                              | \{ 'type': 'sap.ui.model.type.Date', 'formatOptions': \{ 'source': \{ 'pattern': 'yyyy-MM-dd' \} \}, 'path': '{ client->_bind( val = drs5_end path = abap_true ) }' \} ] \}|
                )->a( n = `valueState`    v = client->_bind( drs5_value_state )
            )->leaf( `Label`
                )->a( n = `text`     v = `Change event`
                )->a( n = `labelFor` v = `TextEvent`
            " text is bound - the original change handler sets it imperatively
            )->leaf( `Text`
                )->a( n = `id`   v = `TextEvent`
                )->a( n = `text` v = client->_bind( event_text ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    DATA valid TYPE abap_bool.

    CASE client->get( )-event.

      WHEN `CHANGE`.
        DATA(source_id) = client->get_event_arg( ).
        DATA(date_from) = client->get_event_arg( 2 ).
        DATA(date_to)   = client->get_event_arg( 3 ).
        valid = client->get_event_arg( 4 ).
        event_text = |Id: { source_id }\nFrom: { date_from }\nTo: { date_to }|.
        DATA(value_state) = COND string( WHEN valid = abap_true THEN `None` ELSE `Error` ).
        IF source_id CS `DRS1`.
          drs1_value_state = value_state.
        ELSEIF source_id CS `DRS2`.
          drs2_value_state = value_state.
        ELSEIF source_id CS `DRS3`.
          drs3_value_state = value_state.
        ELSEIF source_id CS `DRS4`.
          drs4_value_state = value_state.
        ELSEIF source_id CS `DRS5`.
          drs5_value_state = value_state.
        ENDIF.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
