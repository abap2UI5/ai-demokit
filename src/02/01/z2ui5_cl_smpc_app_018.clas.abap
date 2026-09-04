" @keywords datetimepicker date time picker sap.m enables users select bet panel label text
" @summary With the DateTimePicker a Date can be entered or selected including the time part.
CLASS z2ui5_cl_smpc_app_018 DEFINITION PUBLIC.

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

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_018 IMPLEMENTATION.

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
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `$event.oSource.sId` INTO TABLE temp1.
    INSERT `${$parameters>/value}` INTO TABLE temp1.
    INSERT `${$parameters>/valid}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `$event.oSource.sId` INTO TABLE temp2.
    INSERT `${$parameters>/value}` INTO TABLE temp2.
    INSERT `${$parameters>/valid}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `$event.oSource.sId` INTO TABLE temp3.
    INSERT `${$parameters>/value}` INTO TABLE temp3.
    INSERT `${$parameters>/valid}` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `$event.oSource.sId` INTO TABLE temp4.
    INSERT `${$parameters>/value}` INTO TABLE temp4.
    INSERT `${$parameters>/valid}` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `$event.oSource.sId` INTO TABLE temp5.
    INSERT `${$parameters>/value}` INTO TABLE temp5.
    INSERT `${$parameters>/valid}` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `$event.oSource.sId` INTO TABLE temp6.
    INSERT `${$parameters>/value}` INTO TABLE temp6.
    INSERT `${$parameters>/valid}` INTO TABLE temp6.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( `Panel`
            )->a( n = `id`         v = `dateTimePanel`
            )->a( n = `headerText` v = `When DateTimePicker change events are fired the selected date and time is displayed in the Text control`
            )->a( n = `width`      v = `auto`

            )->tag( `Label`
                )->a( n = `text`     v = `Simple DateTimePicker`
                )->a( n = `labelFor` v = `DTP1`
            " valueState bound on every change-firing picker - the original handleChange sets it from the event's valid flag
            )->tag( `DateTimePicker`
                )->a( n = `id`          v = `DTP1`
                )->a( n = `placeholder` v = `Enter Date`
                )->a( n = `valueState`  v = client->_bind( vs_dtp1 )
                )->a( n = `change`      v = client->_event( val   = `CHANGE`
                                                            t_arg = temp1 )
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
            )->tag( `Label`
                )->a( n = `text`     v = `With initialFocusedDateValue UI5Date.getInstance(2017, 5, 13, 11, 12, 13)`
                )->a( n = `labelFor` v = `DTP6`
            " the controller's setInitialFocusedDateValue, bound via the framework's Formatter.DateCreateObject module formatter
            )->tag( `DateTimePicker`
                )->a( n = `id`                      v = `DTP6`
                )->a( n = `placeholder`             v = `Enter Date`
                )->a( n = `initialFocusedDateValue` v = |\{ path: '{ client->_bind_path( init_focus_dtp6 ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `valueState`              v = client->_bind( vs_dtp6 )
                )->a( n = `change`                  v = client->_event( val   = `CHANGE`
                                                                        t_arg = temp2 )
                )->a( n = `class`                   v = `sapUiSmallMarginBottom`
            )->tag( `Label`
                )->a( n = `text`     v = `DateTimePicker with given Value, Formatter, and with shortcuts for current date and current time`
                )->a( n = `labelFor` v = `DTP2`
            " every DateTime type binding gets a source pattern - the ABAP model carries date strings, not JS Date objects
            )->tag( `DateTimePicker`
                )->a( n = `id`                    v = `DTP2`
                )->a( n = `showCurrentDateButton` v = `true`
                )->a( n = `showCurrentTimeButton` v = `true`
                )->a( n = `value`
                         v = |\{ 'path': '{ client->_bind_path( value_dtp2 ) }', 'type': 'sap.ui.model.type.DateTime', 'formatOptions': \{ 'style': 'long', 'source': \{ 'pattern': 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->a( n = `valueState`            v = client->_bind( vs_dtp2 )
                )->a( n = `change`                v = client->_event( val   = `CHANGE`
                                                                      t_arg = temp3 )
                )->a( n = `class`                 v = `sapUiSmallMarginBottom`
            )->tag( `Label`
                )->a( n = `text`     v = `DateTimePicker with given Value and Formatter`
                )->a( n = `labelFor` v = `DTP3`
            )->tag( `DateTimePicker`
                )->a( n = `id`         v = `DTP3`
                )->a( n = `value`
                         v = |\{ 'path': '{ client->_bind_path( value_dtp3 ) }', 'type': 'sap.ui.model.type.DateTime', 'formatOptions': \{ 'pattern': 'M/d/yy h:mm a', 'source': \{ 'pattern': 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->a( n = `valueState` v = client->_bind( vs_dtp3 )
                )->a( n = `change`     v = client->_event( val   = `CHANGE`
                                                           t_arg = temp4 )
                )->a( n = `class`      v = `sapUiSmallMarginBottom`
            )->tag( `Label`
                )->a( n = `text`     v = `DateTimePicker with Islamic date and secondary Gregorian date in calendar`
                )->a( n = `labelFor` v = `DTP4`
            )->tag( `DateTimePicker`
                )->a( n = `id`                    v = `DTP4`
                )->a( n = `value`
                         v = |\{ 'path': '{ client->_bind_path( value_dtp4 ) }', 'type': 'sap.ui.model.type.DateTime',| &&
                             | 'formatOptions': \{ 'calendarType': 'Islamic', 'style': 'short', 'source': \{ 'pattern': 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->a( n = `secondaryCalendarType` v = `Gregorian`
                )->a( n = `valueState`            v = client->_bind( vs_dtp4 )
                )->a( n = `change`                v = client->_event( val   = `CHANGE`
                                                                      t_arg = temp5 )
                )->a( n = `class`                 v = `sapUiSmallMarginBottom`
            )->tag( `Label`
                )->a( n = `text`     v = `DateTimePicker with steps for minutes and seconds sliders`
                )->a( n = `labelFor` v = `DTP7`
            )->tag( `DateTimePicker`
                )->a( n = `id`          v = `DTP7`
                )->a( n = `valueFormat` v = `yyyy-MM-dd-HH-mm-ss`
                )->a( n = `minutesStep` v = `3`
                )->a( n = `secondsStep` v = `5`
                )->a( n = `valueState`  v = client->_bind( vs_dtp7 )
                )->a( n = `change`      v = client->_event( val   = `CHANGE`
                                                            t_arg = temp6 )
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
            " the original handleChange writes the change event result into this text
            )->tag( `Text`
                )->a( n = `id`    v = `textResult`
                )->a( n = `text`  v = client->_bind( text_result )
                )->a( n = `class` v = `sapUiSmallMargin`

        )->end(
        )->ele( `Panel`
            )->a( n = `id`         v = `dataBindingDateTimePanel`
            )->a( n = `headerText` v = `DateTimePicker using data binding`
            )->a( n = `width`      v = `auto`

            )->tag( `Label`
                )->a( n = `text`     v = `DateTimePicker using DataBinding`
                )->a( n = `labelFor` v = `DTP5`
            )->tag( `DateTimePicker`
                )->a( n = `id`    v = `DTP5`
                )->a( n = `value`
                         v = |\{ path: '{ client->_bind_path( value_dtp5 ) }', type: 'sap.ui.model.type.DateTime', formatOptions: \{ style: 'medium', strictParsing: true, source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->tag( `Label`
                )->a( n = `text`     v = `DateTimePicker using DataBinding with value and timezone`
                )->a( n = `labelFor` v = `DTP10`
            " the DateTimeOffset parts carry constraints V4 true - the flat ABAP model ships ISO strings, not JS Date objects
            )->tag( `DateTimePicker`
                )->a( n = `id`    v = `DTP10`
                )->a( n = `value`
                         v = |\{ parts: [ \{ path: '{ client->_bind_path( value_dtp10 ) }', type: 'sap.ui.model.odata.type.DateTimeOffset', constraints: \{ V4: true \} \},| &&
                             | \{ path: '{ client->_bind_path( timezone_dtp10 ) }', type: 'sap.ui.model.odata.type.String' \} ], type: 'sap.ui.model.odata.type.DateTimeWithTimezone' \}|
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->tag( `Label`
                )->a( n = `text`     v = `DateTimePicker using DataBinding with null value and timezone`
                )->a( n = `labelFor` v = `DTP11`
            )->tag( `DateTimePicker`
                )->a( n = `id`                    v = `DTP11`
                )->a( n = `showTimezone`          v = `true`
                )->a( n = `showCurrentTimeButton` v = `true`
                )->a( n = `value`
                         v = |\{ parts: [ \{ path: '{ client->_bind_path( value_dtp11 ) }', type: 'sap.ui.model.odata.type.DateTimeOffset', constraints: \{ V4: true \} \},| &&
                             | \{ path: '{ client->_bind_path( timezone_dtp11 ) }', type: 'sap.ui.model.odata.type.String' \} ], type: 'sap.ui.model.odata.type.DateTimeWithTimezone' \}|
                )->a( n = `class`                 v = `sapUiSmallMarginBottom`

        )->end(
        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `id`         v = `simpleForm`
            )->a( n = `columnsL`   v = `1`
            )->a( n = `columnsM`   v = `1`
            )->a( n = `editable`   v = `true`
            )->a( n = `labelSpanL` v = `12`
            )->a( n = `labelSpanM` v = `12`
            )->a( n = `layout`     v = `ResponsiveGridLayout`

            )->tag( `Title`
                )->a( n = `text`       v = `Using a timezone`
                )->a( n = `titleStyle` v = `H4`
            )->tag( `Label`
                )->a( n = `text`     v = `Showing the timezone label`
                )->a( n = `labelFor` v = `DTP8`
            )->tag( `DateTimePicker`
                )->a( n = `id`           v = `DTP8`
                )->a( n = `value`
                         v = |\{ path: '{ client->_bind_path( value_dtp8 ) }', type: 'sap.ui.model.type.DateTime', formatOptions: \{ 'style': 'medium', source: \{ pattern: 'yyyy-MM-dd HH:mm:ss' \} \} \}|
                )->a( n = `showTimezone` v = `true`
                )->a( n = `timezone`     v = `America/New_York`
                )->a( n = `class`        v = `sapUiSmallMarginBottom` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    DATA valid TYPE abap_bool.
      DATA source_id TYPE string.
      DATA new_value TYPE string.
      DATA temp3 TYPE string.
      DATA state LIKE temp3.

    IF client->get_event( ) = `CHANGE`.
      
      source_id = client->get_event_arg( ).
      
      new_value = client->get_event_arg( 2 ).
      valid = client->get_event_arg( 3 ).
      event_count = event_count + 1.
      text_result = |Change - Event { event_count }: DateTimePicker { source_id }:{ new_value }|.

      
      IF valid = abap_true.
        temp3 = `None`.
      ELSE.
        temp3 = `Error`.
      ENDIF.
      
      state = temp3.
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
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the original's UI5Date instances become date strings - parsed by the source patterns / V4 constraints in the view bindings
    DATA now TYPE string.
    now = |{ sy-datum(4) }-{ sy-datum+4(2) }-{ sy-datum+6(2) } { sy-uzeit(2) }:{ sy-uzeit+2(2) }:{ sy-uzeit+4(2) }|.

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

ENDCLASS.
