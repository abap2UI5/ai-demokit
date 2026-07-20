CLASS z2ui5_cl_ai_app_018 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA text_result TYPE string.
    DATA init_focus_dtp6 TYPE string.
    DATA value_dtp2 TYPE string.
    DATA value_dtp3 TYPE string.
    DATA value_dtp4 TYPE string.
    DATA value_dtp5 TYPE string.
    DATA value_dtp8 TYPE string.
    DATA value_dtp10 TYPE string.
    DATA value_dtp11 TYPE string.
    DATA timezone_dtp10 TYPE string.
    DATA timezone_dtp11 TYPE string.
    DATA vs_dtp1 TYPE string.
    DATA vs_dtp2 TYPE string.
    DATA vs_dtp3 TYPE string.
    DATA vs_dtp4 TYPE string.
    DATA vs_dtp6 TYPE string.
    DATA vs_dtp7 TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA event_count TYPE i.

    METHODS model_init.
    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_018 IMPLEMENTATION.

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

    " the original's UI5Date instances become date strings - parsed by the source patterns / V4 constraints in the view bindings
    DATA(now) = |{ sy-datum(4) }-{ sy-datum+4(2) }-{ sy-datum+6(2) } { sy-uzeit(2) }:{ sy-uzeit+2(2) }:{ sy-uzeit+4(2) }|.

    value_dtp2 = `2016-02-18 10:32:30`.
    value_dtp3 = now.
    value_dtp4 = `2016-02-18 10:32:30`.
    value_dtp5 = now.
    value_dtp8 = `2016-02-18 10:32:30`.
    value_dtp10 = `2023-03-31T10:32:30Z`.
    " value_dtp11 stays initial - the original binds null; the original's valueDTP9 is bound by no control and is omitted
    timezone_dtp10 = `Australia/Sydney`.
    timezone_dtp11 = `Asia/Tokyo`.
    init_focus_dtp6 = `2017-06-13T11:12:13`.
    text_result = `Change event result`.
    vs_dtp1 = `None`.
    vs_dtp2 = `None`.
    vs_dtp3 = `None`.
    vs_dtp4 = `None`.
    vs_dtp6 = `None`.
    vs_dtp7 = `None`.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}`

        )->open( `Panel`
            )->a( n = `id`         v = `dateTimePanel`
            )->a( n = `headerText` v = `When DateTimePicker change events are fired the selected date and time is displayed in the Text control`
            )->a( n = `width`      v = `auto`

            )->leaf( `Label`
                )->a( n = `text`     v = `Simple DateTimePicker`
                )->a( n = `labelFor` v = `DTP1`
            " valueState bound on every change-firing picker - the original handleChange sets it from the event's valid flag
            )->leaf( `DateTimePicker`
                )->a( n = `id`          v = `DTP1`
                )->a( n = `placeholder` v = `Enter Date`
                )->a( n = `valueState`  v = client->_bind( vs_dtp1 )
                )->a( n = `change`      v = client->_event( val   = `CHANGE`
                                                            t_arg = VALUE #( ( `$event.oSource.sId` ) ( `${$parameters>/value}` ) ( `${$parameters>/valid}` ) ) )
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
            )->leaf( `Label`
                )->a( n = `text`     v = `With initialFocusedDateValue UI5Date.getInstance(2017, 5, 13, 11, 12, 13)`
                )->a( n = `labelFor` v = `DTP6`
            " the controller's setInitialFocusedDateValue, bound via the framework's Formatter.DateCreateObject module formatter
            )->leaf( `DateTimePicker`
                )->a( n = `id`                      v = `DTP6`
                )->a( n = `placeholder`             v = `Enter Date`
                )->a( n = `initialFocusedDateValue` v = |\{ path: '{ client->_bind( val = init_focus_dtp6 path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `valueState`              v = client->_bind( vs_dtp6 )
                )->a( n = `change`                  v = client->_event( val   = `CHANGE`
                                                                        t_arg = VALUE #( ( `$event.oSource.sId` ) ( `${$parameters>/value}` ) ( `${$parameters>/valid}` ) ) )
                )->a( n = `class`                   v = `sapUiSmallMarginBottom`
            )->leaf( `Label`
                )->a( n = `text`     v = `DateTimePicker with given Value, Formatter, and with shortcuts for current date and current time`
                )->a( n = `labelFor` v = `DTP2`
            " every DateTime type binding gets a source pattern - the ABAP model carries date strings, not JS Date objects
            )->leaf( `DateTimePicker`
                )->a( n = `id`                    v = `DTP2`
                )->a( n = `showCurrentDateButton` v = `true`
                )->a( n = `showCurrentTimeButton` v = `true`
                )->a( n = `value`
                         v = |\{ 'path': '{ client->_bind( val = value_dtp2 path = abap_true ) }', 'type': 'sap.ui.model.type.DateTime', 'formatOptions': \{ 'style': 'long', 'source': \{ 'pattern': 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->a( n = `valueState`            v = client->_bind( vs_dtp2 )
                )->a( n = `change`                v = client->_event( val   = `CHANGE`
                                                                      t_arg = VALUE #( ( `$event.oSource.sId` ) ( `${$parameters>/value}` ) ( `${$parameters>/valid}` ) ) )
                )->a( n = `class`                 v = `sapUiSmallMarginBottom`
            )->leaf( `Label`
                )->a( n = `text`     v = `DateTimePicker with given Value and Formatter`
                )->a( n = `labelFor` v = `DTP3`
            )->leaf( `DateTimePicker`
                )->a( n = `id`         v = `DTP3`
                )->a( n = `value`
                         v = |\{ 'path': '{ client->_bind( val = value_dtp3 path = abap_true ) }', 'type': 'sap.ui.model.type.DateTime', 'formatOptions': \{ 'pattern': 'M/d/yy h:mm a', 'source': \{ 'pattern': 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->a( n = `valueState` v = client->_bind( vs_dtp3 )
                )->a( n = `change`     v = client->_event( val   = `CHANGE`
                                                           t_arg = VALUE #( ( `$event.oSource.sId` ) ( `${$parameters>/value}` ) ( `${$parameters>/valid}` ) ) )
                )->a( n = `class`      v = `sapUiSmallMarginBottom`
            )->leaf( `Label`
                )->a( n = `text`     v = `DateTimePicker with Islamic date and secondary Gregorian date in calendar`
                )->a( n = `labelFor` v = `DTP4`
            )->leaf( `DateTimePicker`
                )->a( n = `id`                    v = `DTP4`
                )->a( n = `value`
                         v = |\{ 'path': '{ client->_bind( val = value_dtp4 path = abap_true ) }', 'type': 'sap.ui.model.type.DateTime',| &&
                             | 'formatOptions': \{ 'calendarType': 'Islamic', 'style': 'short', 'source': \{ 'pattern': 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->a( n = `secondaryCalendarType` v = `Gregorian`
                )->a( n = `valueState`            v = client->_bind( vs_dtp4 )
                )->a( n = `change`                v = client->_event( val   = `CHANGE`
                                                                      t_arg = VALUE #( ( `$event.oSource.sId` ) ( `${$parameters>/value}` ) ( `${$parameters>/valid}` ) ) )
                )->a( n = `class`                 v = `sapUiSmallMarginBottom`
            )->leaf( `Label`
                )->a( n = `text`     v = `DateTimePicker with steps for minutes and seconds sliders`
                )->a( n = `labelFor` v = `DTP7`
            )->leaf( `DateTimePicker`
                )->a( n = `id`          v = `DTP7`
                )->a( n = `valueFormat` v = `yyyy-MM-dd-HH-mm-ss`
                )->a( n = `minutesStep` v = `3`
                )->a( n = `secondsStep` v = `5`
                )->a( n = `valueState`  v = client->_bind( vs_dtp7 )
                )->a( n = `change`      v = client->_event( val   = `CHANGE`
                                                            t_arg = VALUE #( ( `$event.oSource.sId` ) ( `${$parameters>/value}` ) ( `${$parameters>/valid}` ) ) )
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
            " the original handleChange writes the change event result into this text
            )->leaf( `Text`
                )->a( n = `id`    v = `textResult`
                )->a( n = `text`  v = client->_bind( text_result )
                )->a( n = `class` v = `sapUiSmallMargin`

            )->shut(
        )->open( `Panel`
            )->a( n = `id`         v = `dataBindingDateTimePanel`
            )->a( n = `headerText` v = `DateTimePicker using data binding`
            )->a( n = `width`      v = `auto`

            )->leaf( `Label`
                )->a( n = `text`     v = `DateTimePicker using DataBinding`
                )->a( n = `labelFor` v = `DTP5`
            )->leaf( `DateTimePicker`
                )->a( n = `id`    v = `DTP5`
                )->a( n = `value`
                         v = |\{ path: '{ client->_bind( val = value_dtp5 path = abap_true ) }', type: 'sap.ui.model.type.DateTime', formatOptions: \{ style: 'medium', strictParsing: true, source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `Label`
                )->a( n = `text`     v = `DateTimePicker using DataBinding with value and timezone`
                )->a( n = `labelFor` v = `DTP10`
            " the DateTimeOffset parts carry constraints V4 true - the flat ABAP model ships ISO strings, not JS Date objects
            )->leaf( `DateTimePicker`
                )->a( n = `id`    v = `DTP10`
                )->a( n = `value`
                         v = |\{ parts: [ \{ path: '{ client->_bind( val = value_dtp10 path = abap_true ) }', type: 'sap.ui.model.odata.type.DateTimeOffset', constraints: \{ V4: true \} \},| &&
                             | \{ path: '{ client->_bind( val = timezone_dtp10 path = abap_true ) }', type: 'sap.ui.model.odata.type.String' \} ], type: 'sap.ui.model.odata.type.DateTimeWithTimezone' \}|
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->leaf( `Label`
                )->a( n = `text`     v = `DateTimePicker using DataBinding with null value and timezone`
                )->a( n = `labelFor` v = `DTP11`
            )->leaf( `DateTimePicker`
                )->a( n = `id`                    v = `DTP11`
                )->a( n = `showTimezone`          v = `true`
                )->a( n = `showCurrentTimeButton` v = `true`
                )->a( n = `value`
                         v = |\{ parts: [ \{ path: '{ client->_bind( val = value_dtp11 path = abap_true ) }', type: 'sap.ui.model.odata.type.DateTimeOffset', constraints: \{ V4: true \} \},| &&
                             | \{ path: '{ client->_bind( val = timezone_dtp11 path = abap_true ) }', type: 'sap.ui.model.odata.type.String' \} ], type: 'sap.ui.model.odata.type.DateTimeWithTimezone' \}|
                )->a( n = `class`                 v = `sapUiSmallMarginBottom`

            )->shut(
        )->open( n = `SimpleForm` ns = `form`
            )->a( n = `id`         v = `simpleForm`
            )->a( n = `columnsL`   v = `1`
            )->a( n = `columnsM`   v = `1`
            )->a( n = `editable`   v = `true`
            )->a( n = `labelSpanL` v = `12`
            )->a( n = `labelSpanM` v = `12`
            )->a( n = `layout`     v = `ResponsiveGridLayout`

            )->leaf( `Title`
                )->a( n = `text`       v = `Using a timezone`
                )->a( n = `titleStyle` v = `H4`
            )->leaf( `Label`
                )->a( n = `text`     v = `Showing the timezone label`
                )->a( n = `labelFor` v = `DTP8`
            )->leaf( `DateTimePicker`
                )->a( n = `id`           v = `DTP8`
                )->a( n = `value`
                         v = |\{ path: '{ client->_bind( val = value_dtp8 path = abap_true ) }', type: 'sap.ui.model.type.DateTime', formatOptions: \{ 'style': 'medium', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->a( n = `showTimezone` v = `true`
                )->a( n = `timezone`     v = `America/New_York`
                )->a( n = `class`        v = `sapUiSmallMarginBottom` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    DATA valid TYPE abap_bool.

    CASE client->get( )-event.

      WHEN `CHANGE`.
        DATA(source_id) = client->get_event_arg( ).
        DATA(new_value) = client->get_event_arg( 2 ).
        valid = client->get_event_arg( 3 ).
        event_count = event_count + 1.
        text_result = |Change - Event { event_count }: DateTimePicker { source_id }:{ new_value }|.

        DATA(state) = COND string( WHEN valid = abap_true THEN `None` ELSE `Error` ).
        IF source_id CP `*DTP1`.
          vs_dtp1 = state.
        ELSEIF source_id CP `*DTP6`.
          vs_dtp6 = state.
        ELSEIF source_id CP `*DTP2`.
          vs_dtp2 = state.
        ELSEIF source_id CP `*DTP3`.
          vs_dtp3 = state.
        ELSEIF source_id CP `*DTP4`.
          vs_dtp4 = state.
        ELSEIF source_id CP `*DTP7`.
          vs_dtp7 = state.
        ENDIF.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
