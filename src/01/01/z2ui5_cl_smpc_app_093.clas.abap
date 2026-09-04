" @keywords tabcontainer tab container sap.m editable employee tabs tabcontaineritem label input
" @summary The sap.m.TabContainer allows for working with multiple tabs.
CLASS z2ui5_cl_smpc_app_093 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_emp,
        name           TYPE string,
        modified       TYPE abap_bool,
        emp_first_name TYPE string,
        emp_last_name  TYPE string,
        " SALARY carries no typed binding anywhere - the original binds it into a
        " plain Input over a JSONModel that holds whatever the user types. A packed
        " field cannot: a table cell that fails to convert is swallowed by
        " delta_apply_field's "skip just this cell", so an entry like 1,455.22 was
        " discarded without an error and the browser kept showing it (measured)
        salary         TYPE string,
      END OF ty_s_emp.
    DATA t_employees TYPE STANDARD TABLE OF ty_s_emp WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    " the tab pending the close confirmation (name + row index), kept across
    " the MessageBox round-trip
    DATA close_name  TYPE string.
    DATA close_index TYPE i.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_093 IMPLEMENTATION.

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
    DATA temp2 TYPE z2ui5_if_client=>ty_s_event_control.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `${$parameters>/item}.getName()` INTO TABLE temp1.
    INSERT `${$parameters>/item/oParent}.indexOfItem(${$parameters>/item})` INTO TABLE temp1.
    
    CLEAR temp2.
    temp2-check_prevent_default = abap_true.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `TabContainer`
            )->a( n = `items`             v = client->_bind( t_employees )
            )->a( n = `id`                v = `myTabContainer`
            )->a( n = `showAddNewButton`  v = `true`
            )->a( n = `class`             v = `sapUiResponsiveContentPadding sapUiResponsivePadding--header`
            )->a( n = `addNewButtonPress` v = client->_event( `ADD` )
            " itemCloseHandler: oEvent.preventDefault() unconditionally, then a
            " MessageBox.confirm decides - the eBP wire cancels the built-in close
            " and transports the tab name + its row index for the server decision
            )->a( n = `itemClose`         v = client->_event( val    = `CLOSE`
                                                              t_arg  = temp1
                                                              s_ctrl = temp2 )

            )->ele( `items`
                )->ele( `TabContainerItem`
                    )->a( n = `name`     v = `{NAME}`
                    )->a( n = `modified` v = `{MODIFIED}`
                    )->ele( `content`
                        )->tag( `Label`
                            )->a( n = `text` v = `First Name:`
                        )->tag( `Input`
                            )->a( n = `value` v = `{EMP_FIRST_NAME}`
                        )->tag( `Label`
                            )->a( n = `text` v = `Last Name:`
                        )->tag( `Input`
                            )->a( n = `value` v = `{EMP_LAST_NAME}`
                        )->tag( `Label`
                            )->a( n = `text` v = `Salary:`
                        )->tag( `Input`
                            )->a( n = `value`       v = `{SALARY}`
                            )->a( n = `description` v = `EUR`

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE z2ui5_cl_smpc_app_093=>ty_s_emp.

    CASE client->get_event( ).
      WHEN `ADD`.
        " addNewButtonPressHandler: add a new, empty employee tab
        
        CLEAR temp3.
        temp3-name = `New employee`.
        temp3-modified = abap_false.
        APPEND temp3 TO t_employees.
      WHEN `CLOSE`.
        " itemCloseHandler: confirm before closing; the answer comes back as
        " the CLOSE_DECIDE event's action argument
        close_name  = client->get_event_arg( ).
        close_index = client->get_event_arg( 2 ).
        client->message_box_display( text    = |Do you want to close the tab '{ close_name }'?|
                                     type    = `confirm`
                                     onclose = `CLOSE_DECIDE` ).

      WHEN `CLOSE_DECIDE`.
        " OK removes the tab row (the bound-aggregation form of removeItem)
        IF client->get_event_arg( ) = `OK`.
          IF close_index >= 0 AND close_index < lines( t_employees ).
            DELETE t_employees INDEX close_index + 1.
          ENDIF.
          client->message_toast_display( text = |Item closed: { close_name }| duration = `500` ).
        ELSE.
          client->message_toast_display( text = |Item close canceled: { close_name }| duration = `500` ).
        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    DATA temp4 LIKE t_employees.
    DATA temp5 LIKE LINE OF temp4.
    CLEAR temp4.
    
    temp5-name = `Jean Doe`.
    temp5-emp_first_name = `Jean`.
    temp5-emp_last_name = `Doe`.
    temp5-salary = `1455.22`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `John Smith`.
    temp5-emp_first_name = `John`.
    temp5-emp_last_name = `Smith`.
    temp5-salary = `1390.77`.
    temp5-modified = abap_true.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Particia Clark`.
    temp5-emp_first_name = `Particia`.
    temp5-emp_last_name = `Clark`.
    temp5-salary = `1189`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Tim McAfeed`.
    temp5-emp_first_name = `Tim`.
    temp5-emp_last_name = `McAfeed`.
    temp5-salary = `1235.37`.
    INSERT temp5 INTO TABLE temp4.
    t_employees = temp4.

  ENDMETHOD.

ENDCLASS.
