" @keywords tabcontainer tab container sap.m tabcontainericons tabcontaineritem form title responsivegridlayout formcontainer formelement text
" @summary This example shows how you can add additional text and an Icon to the tabs in TabContainer.
CLASS z2ui5_cl_smpc_app_451 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_emp,
             name           TYPE string,
             emp_first_name TYPE string,
             emp_last_name  TYPE string,
             position       TYPE string,
             icon           TYPE string,
             modified       TYPE abap_bool,
             salary         TYPE p LENGTH 8 DECIMALS 2,
           END OF ty_s_emp.
    TYPES ty_t_emp TYPE STANDARD TABLE OF ty_s_emp WITH EMPTY KEY.

    DATA t_employees TYPE ty_t_emp.

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


CLASS z2ui5_cl_smpc_app_451 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `TabContainer`
            )->a( n = `items`             v = client->_bind( t_employees )
            )->a( n = `id`                v = `myTabContainer`
            )->a( n = `showAddNewButton`  v = `true`
            )->a( n = `class`             v = `sapUiResponsiveContentPadding sapUiResponsivePadding--header`
            )->a( n = `addNewButtonPress` v = client->_event( `ADD` )
            " itemCloseHandler calls oEvent.preventDefault() unconditionally and lets a
            " MessageBox.confirm decide - the eBP wire cancels the built-in close and
            " transports the tab name plus its row index (app 093 precedent)
            )->a( n = `itemClose`         v = client->_event( val    = `CLOSE`
                                                              t_arg  = VALUE #( ( `${$parameters>/item}.getName()` ) ( `${$parameters>/item/oParent}.indexOfItem(${$parameters>/item})` ) )
                                                              s_ctrl = VALUE #( check_prevent_default = abap_true ) )

            )->ele( `items`
                )->ele( `TabContainerItem`
                    )->a( n = `name`           v = `{NAME}`
                    )->a( n = `additionalText` v = `{POSITION}`
                    )->a( n = `icon`           v = `{ICON}`
                    )->a( n = `iconTooltip`    v = `iconTooltip`
                    )->a( n = `modified`       v = `{MODIFIED}`

                    )->ele( `content`
                        )->ele( n = `Form` ns = `f`
                            )->a( n = `editable` v = `false`

                            )->ele( n = `title` ns = `f`
                                )->tag( n = `Title` ns = `core`
                                    )->a( n = `text` v = `Employee`

                            )->end(
                            )->ele( n = `layout` ns = `f`
                                )->tag( n = `ResponsiveGridLayout` ns = `f`

                            )->end(
                            )->ele( n = `FormContainer` ns = `f`

                                )->ele( n = `FormElement` ns = `f`
                                    )->a( n = `label` v = `First Name`

                                    )->ele( n = `fields` ns = `f`
                                        )->tag( `Text`
                                            )->a( n = `text` v = `{EMP_FIRST_NAME}`

                                    )->end(
                                )->end(

                                )->ele( n = `FormElement` ns = `f`
                                    )->a( n = `label` v = `Last Name`

                                    )->ele( n = `fields` ns = `f`
                                        )->tag( `Text`
                                            )->a( n = `text` v = `{EMP_LAST_NAME}`

                                    )->end(
                                )->end(

                                )->ele( n = `FormElement` ns = `f`
                                    )->a( n = `label` v = `Position`

                                    )->ele( n = `fields` ns = `f`
                                        )->tag( `Text`
                                            )->a( n = `text` v = `{POSITION}`

                                    )->end(
                                )->end(

                                )->ele( n = `FormElement` ns = `f`
                                    )->a( n = `label` v = `Salary`

                                    )->ele( n = `fields` ns = `f`
                                        )->tag( `Text`
                                            )->a( n = `text` v = `{SALARY} EUR` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `ADD`.
        " addNewButtonPressHandler adds a new employee tab
        APPEND VALUE #( name     = `New employee`
                        position = `Developer`
                        icon     = `sap-icon://group`
                        modified = abap_false ) TO t_employees.

      WHEN `CLOSE`.
        close_name  = client->get_event_arg( ).
        close_index = client->get_event_arg( 2 ).
        client->message_box_display( text    = |Do you want to close the tab '{ close_name }'?|
                                     type    = `confirm`
                                     onclose = `CLOSE_DECIDE` ).

      WHEN `CLOSE_DECIDE`.
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

    " the four employees the controller seeds, verbatim (the first icon is the
    " sample's own image, re-hosted on the demo kit host)
    t_employees = VALUE #(
      ( name = `Jean Doe`       emp_first_name = `Jean`     emp_last_name = `Doe`     position = `Senior Developer`
        icon = `https://sdk.openui5.org/test-resources/sap/m/images/Woman_04.png` salary = '1455.22' )
      ( name = `John Smith`     emp_first_name = `John`     emp_last_name = `Smith`   position = `Developer`
        icon = `sap-icon://notes` salary = '1390.77' modified = abap_true )
      ( name = `Particia Clark` emp_first_name = `Particia` emp_last_name = `Clark`   position = `Developer`
        icon = `sap-icon://group` salary = '1189.00' )
      ( name = `Tim McAfeed`    emp_first_name = `Tim`      emp_last_name = `McAfeed` position = `Junior Developer`
        icon = `sap-icon://group` salary = '1235.37' ) ).

  ENDMETHOD.

ENDCLASS.
