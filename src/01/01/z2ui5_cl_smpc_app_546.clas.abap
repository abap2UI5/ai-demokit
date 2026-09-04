" @keywords planningcalendar planning calendar sap.m planningcalendardnd vbox title label select item planningcalendarrow calendarappointment
" @summary PlanningCalendar with draggable appointments. The sample represents three possible roles. If you are logged as an Admin, you can move appointments both within the same row and between different rows without any restrictions.
CLASS z2ui5_cl_smpc_app_546 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_appointment,
             start_at  TYPE string,
             end_at    TYPE string,
             title     TYPE string,
             info      TYPE string,
             type      TYPE string,
             pic       TYPE string,
             tentative TYPE abap_bool,
           END OF ty_s_appointment.
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_person,
             pic            TYPE string,
             name           TYPE string,
             role           TYPE string,
             t_appointments TYPE ty_t_appointment,
           END OF ty_s_person.
    TYPES temp1_5fd692513d TYPE STANDARD TABLE OF ty_s_person WITH DEFAULT KEY.
DATA t_people TYPE temp1_5fd692513d.

    DATA start_date TYPE string.
    DATA role_key   TYPE string.
    DATA user_role  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.
    METHODS iso_of
      IMPORTING first         TYPE i
      RETURNING VALUE(result) TYPE string.
    METHODS index_of
      IMPORTING path          TYPE string
                last          TYPE abap_bool DEFAULT abap_true
      RETURNING VALUE(result) TYPE i.
    METHODS overlaps
      IMPORTING row_index     TYPE i
                skip_index    TYPE i
                start_at      TYPE string
                end_at        TYPE string
      RETURNING VALUE(result) TYPE abap_bool.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_546 IMPLEMENTATION.

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
    DATA can_modify TYPE string.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " canModifyAppointments( name ) is a formatter over the row's name and the
    " picked role: a manager and an admin may modify every row, everyone else
    " only their own. Both values are on the client, so the three flags are one
    " expression binding rather than a formatter
    
    can_modify = |\{= ${ client->_bind( user_role ) } === 'manager' \|\| | &&
                       |${ client->_bind( user_role ) } === 'admin' \|\| | &&
                       |${ client->_bind( user_role ) } === $\{NAME\} \}|.

    " the drop, resize and create wires all carry the interval's LOCAL date parts
    " (a UTC toISOString( ) would shift the day) plus the binding paths that name
    " the row and the appointment
    
    CLEAR temp1.
    INSERT `${$parameters>/startDate}.getFullYear()` INTO TABLE temp1.
    INSERT `${$parameters>/startDate}.getMonth() + 1` INTO TABLE temp1.
    INSERT `${$parameters>/startDate}.getDate()` INTO TABLE temp1.
    INSERT `${$parameters>/startDate}.getHours()` INTO TABLE temp1.
    INSERT `${$parameters>/startDate}.getMinutes()` INTO TABLE temp1.
    INSERT `${$parameters>/endDate}.getFullYear()` INTO TABLE temp1.
    INSERT `${$parameters>/endDate}.getMonth() + 1` INTO TABLE temp1.
    INSERT `${$parameters>/endDate}.getDate()` INTO TABLE temp1.
    INSERT `${$parameters>/endDate}.getHours()` INTO TABLE temp1.
    INSERT `${$parameters>/endDate}.getMinutes()` INTO TABLE temp1.
    INSERT `${$parameters>/appointment}.getBindingContext().getPath()` INTO TABLE temp1.
    INSERT `${$parameters>/calendarRow}.getBindingContext().getPath()` INTO TABLE temp1.
    INSERT `${$parameters>/copy} ? 'X' : ''` INTO TABLE temp1.
    INSERT `${$parameters>/calendarRow}.getTitle()` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$parameters>/startDate}.getFullYear()` INTO TABLE temp2.
    INSERT `${$parameters>/startDate}.getMonth() + 1` INTO TABLE temp2.
    INSERT `${$parameters>/startDate}.getDate()` INTO TABLE temp2.
    INSERT `${$parameters>/startDate}.getHours()` INTO TABLE temp2.
    INSERT `${$parameters>/startDate}.getMinutes()` INTO TABLE temp2.
    INSERT `${$parameters>/endDate}.getFullYear()` INTO TABLE temp2.
    INSERT `${$parameters>/endDate}.getMonth() + 1` INTO TABLE temp2.
    INSERT `${$parameters>/endDate}.getDate()` INTO TABLE temp2.
    INSERT `${$parameters>/endDate}.getHours()` INTO TABLE temp2.
    INSERT `${$parameters>/endDate}.getMinutes()` INTO TABLE temp2.
    INSERT `${$parameters>/appointment}.getBindingContext().getPath()` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `${$parameters>/startDate}.getFullYear()` INTO TABLE temp3.
    INSERT `${$parameters>/startDate}.getMonth() + 1` INTO TABLE temp3.
    INSERT `${$parameters>/startDate}.getDate()` INTO TABLE temp3.
    INSERT `${$parameters>/startDate}.getHours()` INTO TABLE temp3.
    INSERT `${$parameters>/startDate}.getMinutes()` INTO TABLE temp3.
    INSERT `${$parameters>/endDate}.getFullYear()` INTO TABLE temp3.
    INSERT `${$parameters>/endDate}.getMonth() + 1` INTO TABLE temp3.
    INSERT `${$parameters>/endDate}.getDate()` INTO TABLE temp3.
    INSERT `${$parameters>/endDate}.getHours()` INTO TABLE temp3.
    INSERT `${$parameters>/endDate}.getMinutes()` INTO TABLE temp3.
    INSERT `${$parameters>/calendarRow}.getBindingContext().getPath()` INTO TABLE temp3.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `PlanningCalendar`
                )->a( n = `id`                        v = `PC1`
                )->a( n = `startDate`                 v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `rows`                      v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization` v = `Filled`

                )->ele( `toolbarContent`
                    )->tag( `Title`
                        )->a( n = `text`       v = `Title`
                        )->a( n = `titleStyle` v = `H4`
                    )->tag( `Label`
                        )->a( n = `text` v = `Logged in as`

                    )->ele( `Select`
                        )->a( n = `id`          v = `userRole`
                        )->a( n = `change`      v = client->_event( val = `ROLE_CHANGE` arg = `${$parameters>/selectedItem}.getKey()` )
                        )->a( n = `selectedKey` v = client->_bind( role_key )
                        )->a( n = `width`       v = `230px`

                        )->ele( `items`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `admin`
                                )->a( n = `text` v = `Admin`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `manager`
                                )->a( n = `text` v = `Manager`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `donna`
                                )->a( n = `text` v = `Donna Moore`

                        )->end(
                    )->end(
                )->end(

                )->ele( `rows`
                    )->ele( `PlanningCalendarRow`
                        )->a( n = `icon`                          v = `{PIC}`
                        )->a( n = `title`                         v = `{NAME}`
                        )->a( n = `text`                          v = `{ROLE}`
                        )->a( n = `enableAppointmentsDragAndDrop` v = can_modify
                        )->a( n = `enableAppointmentsResize`      v = can_modify
                        )->a( n = `enableAppointmentsCreate`      v = can_modify
                        )->a( n = `appointmentDrop`               v = client->_event(
                                  val   = `APPT_DROP`
                                  t_arg = temp1 )
                        )->a( n = `appointmentResize`             v = client->_event(
                                  val   = `APPT_RESIZE`
                                  t_arg = temp2 )
                        )->a( n = `appointmentCreate`             v = client->_event(
                                  val   = `APPT_CREATE`
                                  t_arg = temp3 )
                        )->a( n = `appointments`                  v = `{path: 'T_APPOINTMENTS', templateShareable: false}`

                        )->ele( `appointments`
                            )->tag( n = `CalendarAppointment` ns = `unified`
                                )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`      v = `{PIC}`
                                )->a( n = `title`     v = `{TITLE}`
                                )->a( n = `text`      v = `{INFO}`
                                )->a( n = `type`      v = `{TYPE}`
                                )->a( n = `tentative` v = `{TENTATIVE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE string.
        DATA drop_start TYPE string.
        DATA drop_end TYPE string.
        DATA appt_path TYPE string.
        DATA row_path TYPE string.
        DATA is_copy TYPE abap_bool.
        DATA temp1 TYPE xsdboolean.
        DATA row_title TYPE string.
        DATA src_row TYPE i.
        DATA appt_idx TYPE i.
        DATA dest_row TYPE i.
        FIELD-SYMBOLS <source> TYPE z2ui5_cl_smpc_app_546=>ty_s_person.
          DATA moved TYPE z2ui5_cl_smpc_app_546=>ty_s_appointment.
          DATA temp4 LIKE LINE OF <source>-t_appointments.
          DATA temp6 LIKE sy-tabix.
          DATA title LIKE moved-title.
          FIELD-SYMBOLS <dest> TYPE z2ui5_cl_smpc_app_546=>ty_s_person.
        DATA res_start TYPE string.
        DATA res_end TYPE string.
        DATA res_path TYPE string.
        DATA res_row TYPE i.
        DATA res_idx TYPE i.
        FIELD-SYMBOLS <row> TYPE z2ui5_cl_smpc_app_546=>ty_s_person.
            DATA res_title TYPE z2ui5_cl_smpc_app_546=>ty_s_appointment-title.
            DATA temp9 LIKE LINE OF <row>-t_appointments.
            DATA temp10 LIKE sy-tabix.
            FIELD-SYMBOLS <temp4> LIKE LINE OF <row>-t_appointments.
            DATA temp5 LIKE sy-tabix.
            FIELD-SYMBOLS <temp6> LIKE LINE OF <row>-t_appointments.
            DATA temp7 LIKE sy-tabix.
        DATA new_start TYPE string.
        DATA new_end TYPE string.
        DATA new_row TYPE i.
        FIELD-SYMBOLS <target> TYPE z2ui5_cl_smpc_app_546=>ty_s_person.
          DATA temp8 TYPE z2ui5_cl_smpc_app_546=>ty_s_appointment.

    CASE client->get_event( ).

      WHEN `ROLE_CHANGE`.
        " getUserRole( ) maps the Select key through the roles table
        role_key  = client->get_event_arg( ).
        
        CASE role_key.
          WHEN `donna`.
            temp3 = `Donna Moore`.
          WHEN OTHERS.
            temp3 = role_key.
        ENDCASE.
        user_role = temp3.

      WHEN `APPT_DROP`.
        
        drop_start = iso_of( 1 ).
        
        drop_end   = iso_of( 6 ).
        
        appt_path  = client->get_event_arg( 11 ).
        
        row_path   = client->get_event_arg( 12 ).
        
        
        temp1 = boolc( client->get_event_arg( 13 ) = `X` ).
        is_copy    = temp1.
        
        row_title  = client->get_event_arg( 14 ).

        
        src_row   = index_of( path = appt_path last = abap_false ).
        
        appt_idx  = index_of( appt_path ).
        
        dest_row  = index_of( row_path ).

        
        READ TABLE t_people INDEX src_row + 1 ASSIGNING <source>.
        IF sy-subrc = 0 AND appt_idx >= 0 AND appt_idx < lines( <source>-t_appointments ).
          
          
          
          temp6 = sy-tabix.
          READ TABLE <source>-t_appointments INDEX appt_idx + 1 INTO temp4.
          sy-tabix = temp6.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          moved = temp4.
          
          title = moved-title.
          moved-start_at = drop_start.
          moved-end_at   = drop_end.

          IF is_copy = abap_false.
            DELETE <source>-t_appointments INDEX appt_idx + 1.
          ENDIF.
          
          READ TABLE t_people INDEX dest_row + 1 ASSIGNING <dest>.
          IF sy-subrc = 0.
            INSERT moved INTO TABLE <dest>-t_appointments.
          ENDIF.

          client->message_toast_display(
              |{ row_title }'s 'Appointment '{ title }' now starts at \n{ drop_start }\n and end at \n{ drop_end }.| ).
        ENDIF.

      WHEN `APPT_RESIZE`.
        
        res_start = iso_of( 1 ).
        
        res_end   = iso_of( 6 ).
        
        res_path  = client->get_event_arg( 11 ).
        
        res_row   = index_of( path = res_path last = abap_false ).
        
        res_idx   = index_of( res_path ).

        
        READ TABLE t_people INDEX res_row + 1 ASSIGNING <row>.
        IF sy-subrc = 0 AND res_idx >= 0 AND res_idx < lines( <row>-t_appointments ).
          " isAppointmentOverlap only ever refuses for the MANAGER role
          IF overlaps( row_index  = res_row
                       skip_index = res_idx
                       start_at   = res_start
                       end_at     = res_end ) = abap_true.
            client->message_toast_display( `As a manager you can not resize events if they overlap with another events` ).
          ELSE.
            
            
            
            temp10 = sy-tabix.
            READ TABLE <row>-t_appointments INDEX res_idx + 1 INTO temp9.
            sy-tabix = temp10.
            IF sy-subrc <> 0.
              ASSERT 1 = 0.
            ENDIF.
            res_title = temp9-title.
            
            
            temp5 = sy-tabix.
            READ TABLE <row>-t_appointments INDEX res_idx + 1 ASSIGNING <temp4>.
            sy-tabix = temp5.
            IF sy-subrc <> 0.
              ASSERT 1 = 0.
            ENDIF.
            <temp4>-start_at = res_start.
            
            
            temp7 = sy-tabix.
            READ TABLE <row>-t_appointments INDEX res_idx + 1 ASSIGNING <temp6>.
            sy-tabix = temp7.
            IF sy-subrc <> 0.
              ASSERT 1 = 0.
            ENDIF.
            <temp6>-end_at   = res_end.
            client->message_toast_display(
                |Appointment '{ res_title }' now starts at \n{ res_start }\n and end at \n{ res_end }.| ).
          ENDIF.
        ENDIF.

      WHEN `APPT_CREATE`.
        
        new_start = iso_of( 1 ).
        
        new_end   = iso_of( 6 ).
        
        new_row   = index_of( client->get_event_arg( 11 ) ).

        
        READ TABLE t_people INDEX new_row + 1 ASSIGNING <target>.
        IF sy-subrc = 0.
          " type must be seeded: an ABAP field is never absent, so an unset type
          " reaches CalendarAppointment.type as "" - not a CalendarDayType member,
          " so validateProperty throws and the binding update takes the view down.
          " The original pushes a JS object with no type key at all, which falls
          " back to the property default - which is Type01, inherited from
          " DateTypeRange.type, NOT None (that is secondaryType's default), so
          " seeding None here would render a different colour than the original
          
          CLEAR temp8.
          temp8-title = `New Appointment`.
          temp8-type = `Type01`.
          temp8-start_at = new_start.
          temp8-end_at = new_end.
          INSERT temp8 INTO TABLE <target>-t_appointments.
          client->message_toast_display( |New Appointment is created at \n{ new_start }\n and end at \n{ new_end }.| ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD iso_of.

    " five consecutive event arguments (year, month, day, hour, minute) as one
    " ISO string - the parts travel LOCAL, so no timezone shifts the day
    DATA temp9 TYPE i.
    DATA temp11 TYPE i.
    DATA temp5 TYPE i.
    DATA temp1 TYPE i.
    temp9 = client->get_event_arg( first + 1 ).
    
    temp11 = client->get_event_arg( first + 2 ).
    
    temp5 = client->get_event_arg( first + 3 ).
    
    temp1 = client->get_event_arg( first + 4 ).
    result = |{ client->get_event_arg( first ) }| &&
             |-{ temp9 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
             |-{ temp11 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
             |T{ temp5 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
             |:{ temp1 WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00|.

  ENDMETHOD.


  METHOD index_of.

    " a binding path is /T_PEOPLE/<row>/T_APPOINTMENTS/<appointment>; `last`
    " picks the appointment index, otherwise the row index
    TYPES temp2 TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
DATA parts TYPE temp2.
        DATA temp10 LIKE LINE OF parts.
        DATA temp11 LIKE sy-tabix.
      DATA temp12 LIKE LINE OF parts.
      DATA temp13 LIKE sy-tabix.
    SPLIT path AT `/` INTO TABLE parts.
    DELETE parts WHERE table_line IS INITIAL.
    result = -1.
    IF last = abap_true.
      IF lines( parts ) >= 1.
        
        
        temp11 = sy-tabix.
        READ TABLE parts INDEX lines( parts ) INTO temp10.
        sy-tabix = temp11.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        result = temp10.
      ENDIF.
    ELSEIF lines( parts ) >= 2.
      
      
      temp13 = sy-tabix.
      READ TABLE parts INDEX 2 INTO temp12.
      sy-tabix = temp13.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      result = temp12.
    ENDIF.

  ENDMETHOD.


  METHOD overlaps.
    FIELD-SYMBOLS <row> TYPE z2ui5_cl_smpc_app_546=>ty_s_person.
    DATA appointment LIKE LINE OF <row>-t_appointments.

    " the manager is the only role the original checks overlaps for
    IF user_role <> `manager`.
      RETURN.
    ENDIF.

    
    READ TABLE t_people INDEX row_index + 1 ASSIGNING <row>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    
    LOOP AT <row>-t_appointments INTO appointment.
      IF sy-tabix - 1 = skip_index.
        CONTINUE.
      ENDIF.
      IF (    appointment-start_at <= start_at AND start_at < appointment-end_at )
         OR ( appointment-start_at <  end_at   AND end_at  <= appointment-end_at )
         OR ( start_at <= appointment-start_at AND appointment-start_at < end_at ).
        result = abap_true.
        RETURN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD model_init.
    DATA temp14 LIKE t_people.
    DATA temp15 LIKE LINE OF temp14.
    DATA temp12 TYPE z2ui5_cl_smpc_app_546=>ty_t_appointment.
    DATA temp13 LIKE LINE OF temp12.
    DATA temp16 TYPE z2ui5_cl_smpc_app_546=>ty_t_appointment.
    DATA temp17 LIKE LINE OF temp16.

    start_date = `2017-11-13T08:00:00`.
    role_key   = `admin`.
    user_role  = `admin`.

    
    CLEAR temp14.
    
    temp15-pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png`.
    temp15-name = `John Miller`.
    temp15-role = `team member`.
    
    CLEAR temp12.
    
    temp13-start_at = `2017-11-13T08:00:00`.
    temp13-end_at = `2017-11-13T09:00:00`.
    temp13-title = `Team sync`.
    temp13-info = `Canteen`.
    temp13-type = `Type07`.
    temp13-pic = `sap-icon://family-care`.
    INSERT temp13 INTO TABLE temp12.
    temp13-start_at = `2017-11-13T09:00:00`.
    temp13-end_at = `2017-11-13T11:00:00`.
    temp13-title = `Morning Sync`.
    temp13-info = `I call you`.
    temp13-type = `Type01`.
    temp13-pic = `sap-icon://call`.
    INSERT temp13 INTO TABLE temp12.
    temp13-start_at = `2017-11-13T10:00:00`.
    temp13-end_at = `2017-11-13T12:00:00`.
    temp13-title = `Sync Bill`.
    temp13-info = `Online`.
    temp13-type = `Type03`.
    INSERT temp13 INTO TABLE temp12.
    temp13-start_at = `2017-11-13T10:00:00`.
    temp13-end_at = `2017-11-13T13:00:00`.
    temp13-title = `Check Flights`.
    temp13-info = `no room`.
    temp13-type = `Type09`.
    temp13-pic = `sap-icon://flight`.
    INSERT temp13 INTO TABLE temp12.
    temp13-start_at = `2017-11-13T13:00:00`.
    temp13-end_at = `2017-11-13T14:00:00`.
    temp13-title = `Lunch`.
    temp13-info = `canteen`.
    temp13-type = `Type05`.
    temp13-pic = `sap-icon://private`.
    INSERT temp13 INTO TABLE temp12.
    temp13-start_at = `2017-11-13T18:00:00`.
    temp13-end_at = `2017-11-13T20:00:00`.
    temp13-title = `Discussion of the plan`.
    temp13-info = `Online meeting`.
    temp13-type = `Type04`.
    INSERT temp13 INTO TABLE temp12.
    temp13-start_at = `2017-11-14T03:00:00`.
    temp13-end_at = `2017-11-14T23:00:00`.
    temp13-title = `Deadline`.
    temp13-type = `Type05`.
    INSERT temp13 INTO TABLE temp12.
    temp13-start_at = `2017-11-14T09:00:00`.
    temp13-end_at = `2017-11-14T14:00:00`.
    temp13-title = `Blocker`.
    temp13-info = `room 6`.
    temp13-type = `Type08`.
    INSERT temp13 INTO TABLE temp12.
    temp13-start_at = `2017-11-17T09:00:00`.
    temp13-end_at = `2017-11-17T18:00:00`.
    temp13-title = `Boss Birthday`.
    temp13-type = `Type02`.
    INSERT temp13 INTO TABLE temp12.
    temp13-start_at = `2017-11-24T09:00:00`.
    temp13-end_at = `2017-11-24T18:00:00`.
    temp13-title = `Urgent Planning`.
    temp13-type = `Type08`.
    INSERT temp13 INTO TABLE temp12.
    temp13-start_at = `2017-11-20T01:00:00`.
    temp13-end_at = `2017-11-20T23:00:00`.
    temp13-title = `Planning`.
    temp13-type = `Type09`.
    INSERT temp13 INTO TABLE temp12.
    temp15-t_appointments = temp12.
    INSERT temp15 INTO TABLE temp14.
    temp15-pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/Donna_Moore.jpg`.
    temp15-name = `Donna Moore`.
    temp15-role = `team member`.
    
    CLEAR temp16.
    
    temp17-start_at = `2017-11-13T08:00:00`.
    temp17-end_at = `2017-11-13T09:26:00`.
    temp17-title = `Team sync`.
    temp17-info = `Canteen`.
    temp17-type = `Type07`.
    temp17-pic = `sap-icon://family-care`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-11-13T10:00:00`.
    temp17-end_at = `2017-11-13T12:00:00`.
    temp17-title = `Sync John`.
    temp17-info = `Online`.
    temp17-type = `Type03`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-11-13T11:00:00`.
    temp17-end_at = `2017-11-13T12:00:00`.
    temp17-title = `Prep for planning`.
    temp17-info = `room 5`.
    temp17-type = `Type01`.
    temp17-pic = `sap-icon://family-care`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-11-13T18:00:00`.
    temp17-end_at = `2017-11-13T20:00:00`.
    temp17-title = `Check Flights`.
    temp17-info = `no room`.
    temp17-type = `Type09`.
    temp17-pic = `sap-icon://flight`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-11-13T18:00:00`.
    temp17-end_at = `2017-11-13T20:00:00`.
    temp17-title = `Discussion of the plan`.
    temp17-info = `Online meeting`.
    temp17-type = `Type04`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-11-20T01:00:00`.
    temp17-end_at = `2017-11-20T23:00:00`.
    temp17-title = `Planning`.
    temp17-type = `Type09`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2018-03-20T01:00:00`.
    temp17-end_at = `2018-03-20T23:00:00`.
    temp17-title = `Off`.
    temp17-type = `Type08`.
    INSERT temp17 INTO TABLE temp16.
    temp15-t_appointments = temp16.
    INSERT temp15 INTO TABLE temp14.
    t_people = temp14.

  ENDMETHOD.

ENDCLASS.
