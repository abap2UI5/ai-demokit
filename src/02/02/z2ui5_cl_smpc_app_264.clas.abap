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

    DATA t_teammembers      TYPE STANDARD TABLE OF ty_s_teammember WITH EMPTY KEY.
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
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " onToggleFilters replaces the binding's filter set with the other pair
    " (organizational <-> personal). abap2UI5 bakes the binding info at render
    " time, so the toggle event redraws the view with the other boundFilters
    " list instead of calling ListBinding.filter (app 241 precedent). Only the
    " fragment is composed here - every client->_bind( ) call stays inline.
    DATA(lv_boundfilters) = COND string(
      WHEN showorganizational = abap_true
      THEN |\{ path: 'LOCATION', operator: 'StartsWith', value1: '{ client->_bind( locationprefix ) }' \}, | &&
           |\{ path: 'DEPARTMENT', operator: 'StartsWith', value1: '{ client->_bind( departmentprefix ) }' \}|
      ELSE |\{ path: 'FIRSTNAME', operator: 'StartsWith', value1: '{ client->_bind( firstname ) }' \}, | &&
           |\{ path: 'LASTNAME', operator: 'StartsWith', value1: '{ client->_bind( lastname ) }' \}| ).

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
            )->a( n = `rows` v = |\{ path: '{ client->_bind( val = t_teammembers path = abap_true ) }', | &&
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
                        )->a( n = `value`   v = |\{ path: '{ client->_bind( val = departmentprefix path = abap_true ) }', type: 'StringType' \}|
                        )->a( n = `visible` v = client->_bind( showorganizational )
                    )->tag( `Label`
                        )->a( n = `text`     v = `Location prefix`
                        )->a( n = `labelFor` v = `locationInput`
                        )->a( n = `visible`  v = client->_bind( showorganizational )
                    )->tag( `Input`
                        )->a( n = `id`      v = `locationInput`
                        )->a( n = `width`   v = `200px`
                        )->a( n = `value`   v = |\{ path: '{ client->_bind( val = locationprefix path = abap_true ) }', type: 'StringType' \}|
                        )->a( n = `visible` v = client->_bind( showorganizational )
                    )->tag( `Label`
                        )->a( n = `text`     v = `First name prefix`
                        )->a( n = `labelFor` v = `firstNameInput`
                        )->a( n = `visible`  v = |\{= !%{ client->_bind( showorganizational ) }\}|
                    )->tag( `Input`
                        )->a( n = `id`      v = `firstNameInput`
                        )->a( n = `width`   v = `200px`
                        )->a( n = `value`   v = |\{ path: '{ client->_bind( val = firstname path = abap_true ) }', type: 'StringType' \}|
                        )->a( n = `visible` v = |\{= !%{ client->_bind( showorganizational ) }\}|
                    )->tag( `Label`
                        )->a( n = `text`     v = `Last name prefix`
                        )->a( n = `labelFor` v = `lastNameInput`
                        )->a( n = `visible`  v = |\{= !%{ client->_bind( showorganizational ) }\}|
                    )->tag( `Input`
                        )->a( n = `id`      v = `lastNameInput`
                        )->a( n = `width`   v = `200px`
                        )->a( n = `value`   v = |\{ path: '{ client->_bind( val = lastname path = abap_true ) }', type: 'StringType' \}|
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

    IF client->get( )-event = `TOGGLE_FILTERS`.
      " onToggleFilters: flip ui>/showOrganizational and apply the other
      " filter pair to the rows binding - here the flag flips and the view is
      " redrawn, which re-bakes the boundFilters list into the binding info
      showorganizational = xsdbool( showorganizational = abap_false ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the four filter> fields start undefined in the original JSONModel
    showorganizational = abap_true.

    t_teammembers = VALUE #(
      ( firstname = `John`    lastname = `Doe`       age = 28 department = `Development` location = `Walldorf` )
      ( firstname = `Jane`    lastname = `Smith`     age = 34 department = `Consulting`  location = `New York` )
      ( firstname = `Michael` lastname = `Johnson`   age = 45 department = `Management`  location = `Bangalore` )
      ( firstname = `Emily`   lastname = `Davis`     age = 29 department = `Development` location = `Sydney` )
      ( firstname = `Chris`   lastname = `Brown`     age = 38 department = `Consulting`  location = `Berlin` )
      ( firstname = `Jessica` lastname = `Williams`  age = 41 department = `Development` location = `Walldorf` )
      ( firstname = `David`   lastname = `Jones`     age = 52 department = `Management`  location = `New York` )
      ( firstname = `Sarah`   lastname = `Miller`    age = 27 department = `Development` location = `Bangalore` )
      ( firstname = `Daniel`  lastname = `Wilson`    age = 33 department = `Consulting`  location = `Sydney` )
      ( firstname = `Laura`   lastname = `Moore`     age = 24 department = `Development` location = `Berlin` )
      ( firstname = `James`   lastname = `Taylor`    age = 36 department = `Consulting`  location = `Walldorf` )
      ( firstname = `Emma`    lastname = `Anderson`  age = 30 department = `Development` location = `New York` )
      ( firstname = `Robert`  lastname = `Thomas`    age = 50 department = `Consulting`  location = `Bangalore` )
      ( firstname = `Olivia`  lastname = `Jackson`   age = 22 department = `Development` location = `Sydney` )
      ( firstname = `William` lastname = `White`     age = 47 department = `Consulting`  location = `Berlin` ) ).

  ENDMETHOD.

ENDCLASS.
