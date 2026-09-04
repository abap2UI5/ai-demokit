" @keywords filter sap.ui.model boundfilters.filterbar table title toolbar label input toolbarspacer button column text
" @summary This sample shows how bound filters work in a filter bar. As the user enters values, a toolbar with filter inputs instantly filters the customer table. It also demonstrates how to use the filter API to change the bound filters programmatically.
CLASS z2ui5_cl_smpc_app_264 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_teammember,
             firstname  TYPE string,
             lastname   TYPE string,
             age        TYPE i,
             department TYPE string,
             location   TYPE string,
           END OF ty_s_teammember.

    DATA t_teammembers      TYPE STANDARD TABLE OF ty_s_teammember WITH DEFAULT KEY.
    DATA departmentprefix   TYPE string.
    DATA locationprefix     TYPE string.
    DATA firstname          TYPE string.
    DATA lastname           TYPE string.
    DATA showorganizational TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_264 IMPLEMENTATION.

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
    DATA temp1 TYPE string.
    DATA lv_boundfilters LIKE temp1.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " onToggleFilters replaces the binding's filter set with the other pair
    " (organizational <-> personal). abap2UI5 bakes the binding info at render
    " time, so the toggle event redraws the view with the other boundFilters
    " list instead of calling ListBinding.filter (app 241 precedent). Only the
    " fragment is composed here - every client->_bind( ) call stays inline.
    
    IF showorganizational = abap_true.
      temp1 = |\{ path: 'LOCATION', operator: 'StartsWith', value1: '{ client->_bind( locationprefix ) }' \}, | && |\{ path: 'DEPARTMENT', operator: 'StartsWith', value1: '{ client->_bind( departmentprefix ) }' \}|.
    ELSE.
      temp1 = |\{ path: 'FIRSTNAME', operator: 'StartsWith', value1: '{ client->_bind( firstname ) }' \}, | && |\{ path: 'LASTNAME', operator: 'StartsWith', value1: '{ client->_bind( lastname ) }' \}|.
    ENDIF.
    
    lv_boundfilters = temp1.

    view->ele( n = `View` ns = `mvc`
        )->a( n = `class`       v = `sapUiSizeCompact`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`  v = `sap.ui.core`
        )->a( n = `xmlns:table` v = `sap.ui.table`
        )->a( n = `xmlns:rm`    v = `sap.ui.table.rowmodes`
        " use odata types as they map empty input to null
        )->a( n = `core:require` v = `{StringType: 'sap/ui/model/odata/type/String'}`

        )->ele( n = `Table` ns = `table`
            )->a( n = `id`   v = `myTable`
            )->a( n = `rows` v = |\{ path: '{ client->_bind_path( t_teammembers ) }', | &&
                                 |boundFilters: [{ lv_boundfilters }] \}|

            )->ele( n = `extension` ns = `table`
                )->tag( `Title`
                    )->a( n = `id`   v = `title`
                    )->a( n = `text` v = `Employees`

                )->ele( `Toolbar`
                    )->tag( `Label`
                        )->a( n = `text`     v = `Department prefix`
                        )->a( n = `labelFor` v = `departmentInput`
                        )->a( n = `visible`  v = client->_bind( showorganizational )
                    )->tag( `Input`
                        )->a( n = `id`      v = `departmentInput`
                        )->a( n = `width`   v = `200px`
                        )->a( n = `value`   v = |\{ path: '{ client->_bind_path( departmentprefix ) }', type: 'StringType' \}|
                        )->a( n = `visible` v = client->_bind( showorganizational )
                    )->tag( `Label`
                        )->a( n = `text`     v = `Location prefix`
                        )->a( n = `labelFor` v = `locationInput`
                        )->a( n = `visible`  v = client->_bind( showorganizational )
                    )->tag( `Input`
                        )->a( n = `id`      v = `locationInput`
                        )->a( n = `width`   v = `200px`
                        )->a( n = `value`   v = |\{ path: '{ client->_bind_path( locationprefix ) }', type: 'StringType' \}|
                        )->a( n = `visible` v = client->_bind( showorganizational )
                    )->tag( `Label`
                        )->a( n = `text`     v = `First name prefix`
                        )->a( n = `labelFor` v = `firstNameInput`
                        )->a( n = `visible`  v = |\{= !%{ client->_bind( showorganizational ) }\}|
                    )->tag( `Input`
                        )->a( n = `id`      v = `firstNameInput`
                        )->a( n = `width`   v = `200px`
                        )->a( n = `value`   v = |\{ path: '{ client->_bind_path( firstname ) }', type: 'StringType' \}|
                        )->a( n = `visible` v = |\{= !%{ client->_bind( showorganizational ) }\}|
                    )->tag( `Label`
                        )->a( n = `text`     v = `Last name prefix`
                        )->a( n = `labelFor` v = `lastNameInput`
                        )->a( n = `visible`  v = |\{= !%{ client->_bind( showorganizational ) }\}|
                    )->tag( `Input`
                        )->a( n = `id`      v = `lastNameInput`
                        )->a( n = `width`   v = `200px`
                        )->a( n = `value`   v = |\{ path: '{ client->_bind_path( lastname ) }', type: 'StringType' \}|
                        )->a( n = `visible` v = |\{= !%{ client->_bind( showorganizational ) }\}|
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `id`    v = `toggleFiltersButton`
                        )->a( n = `press` v = client->_event( `TOGGLE_FILTERS` )
                        )->a( n = `text`  v = |\{= %{ client->_bind( showorganizational ) } ? 'Show Personal Filters' : 'Show Organizational Filters'\}|

                )->end(
            )->end(

            )->ele( n = `columns` ns = `table`
                )->ele( n = `Column` ns = `table`
                    )->tag( `Label`
                        )->a( n = `text` v = `Department`

                    )->ele( n = `template` ns = `table`
                        )->tag( `Text`
                            )->a( n = `text` v = `{DEPARTMENT}`

                    )->end(
                )->end(

                )->ele( n = `Column` ns = `table`
                    )->tag( `Label`
                        )->a( n = `text` v = `First Name`

                    )->ele( n = `template` ns = `table`
                        )->tag( `Text`
                            )->a( n = `text` v = `{FIRSTNAME}`

                    )->end(
                )->end(

                )->ele( n = `Column` ns = `table`
                    )->tag( `Label`
                        )->a( n = `text` v = `Last Name`

                    )->ele( n = `template` ns = `table`
                        )->tag( `Text`
                            )->a( n = `text` v = `{LASTNAME}`

                    )->end(
                )->end(

                )->ele( n = `Column` ns = `table`
                    )->tag( `Label`
                        )->a( n = `text` v = `Age`

                    )->ele( n = `template` ns = `table`
                        )->tag( `Text`
                            )->a( n = `text` v = `{AGE}`

                    )->end(
                )->end(

                )->ele( n = `Column` ns = `table`
                    )->tag( `Label`
                        )->a( n = `text` v = `Location`

                    )->ele( n = `template` ns = `table`
                        )->tag( `Text`
                            )->a( n = `text` v = `{LOCATION}`

                        ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA temp1 TYPE xsdboolean.

    IF client->get_event( ) = `TOGGLE_FILTERS`.
      " onToggleFilters: flip ui>/showOrganizational and apply the other
      " filter pair to the rows binding - here the flag flips and the view is
      " redrawn, which re-bakes the boundFilters list into the binding info
      
      temp1 = boolc( showorganizational = abap_false ).
      showorganizational = temp1.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.
    DATA temp2 LIKE t_teammembers.
    DATA temp3 LIKE LINE OF temp2.

    " the four filter> fields start undefined in the original JSONModel
    showorganizational = abap_true.

    
    CLEAR temp2.
    
    temp3-firstname = `John`.
    temp3-lastname = `Doe`.
    temp3-age = 28.
    temp3-department = `Development`.
    temp3-location = `Walldorf`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstname = `Jane`.
    temp3-lastname = `Smith`.
    temp3-age = 34.
    temp3-department = `Consulting`.
    temp3-location = `New York`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstname = `Michael`.
    temp3-lastname = `Johnson`.
    temp3-age = 45.
    temp3-department = `Management`.
    temp3-location = `Bangalore`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstname = `Emily`.
    temp3-lastname = `Davis`.
    temp3-age = 29.
    temp3-department = `Development`.
    temp3-location = `Sydney`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstname = `Chris`.
    temp3-lastname = `Brown`.
    temp3-age = 38.
    temp3-department = `Consulting`.
    temp3-location = `Berlin`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstname = `Jessica`.
    temp3-lastname = `Williams`.
    temp3-age = 41.
    temp3-department = `Development`.
    temp3-location = `Walldorf`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstname = `David`.
    temp3-lastname = `Jones`.
    temp3-age = 52.
    temp3-department = `Management`.
    temp3-location = `New York`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstname = `Sarah`.
    temp3-lastname = `Miller`.
    temp3-age = 27.
    temp3-department = `Development`.
    temp3-location = `Bangalore`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstname = `Daniel`.
    temp3-lastname = `Wilson`.
    temp3-age = 33.
    temp3-department = `Consulting`.
    temp3-location = `Sydney`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstname = `Laura`.
    temp3-lastname = `Moore`.
    temp3-age = 24.
    temp3-department = `Development`.
    temp3-location = `Berlin`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstname = `James`.
    temp3-lastname = `Taylor`.
    temp3-age = 36.
    temp3-department = `Consulting`.
    temp3-location = `Walldorf`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstname = `Emma`.
    temp3-lastname = `Anderson`.
    temp3-age = 30.
    temp3-department = `Development`.
    temp3-location = `New York`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstname = `Robert`.
    temp3-lastname = `Thomas`.
    temp3-age = 50.
    temp3-department = `Consulting`.
    temp3-location = `Bangalore`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstname = `Olivia`.
    temp3-lastname = `Jackson`.
    temp3-age = 22.
    temp3-department = `Development`.
    temp3-location = `Sydney`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstname = `William`.
    temp3-lastname = `White`.
    temp3-age = 47.
    temp3-department = `Consulting`.
    temp3-location = `Berlin`.
    INSERT temp3 INTO TABLE temp2.
    t_teammembers = temp2.

  ENDMETHOD.

ENDCLASS.
