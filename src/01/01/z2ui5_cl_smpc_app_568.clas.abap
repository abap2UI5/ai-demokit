" @keywords table sap.m tablecontextualwidthstatic messagestrip overflowtoolbar button column label columnlistitem
" @summary This example shows the container-based pop-in behavior. The container has static width.
CLASS z2ui5_cl_smpc_app_568 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_person,
             firstname TYPE string,
             lastname  TYPE string,
             birthdate TYPE string,
             gender    TYPE string,
           END OF ty_s_person.
    TYPES ty_t_person TYPE STANDARD TABLE OF ty_s_person WITH DEFAULT KEY.

    DATA t_people         TYPE ty_t_person.
    " onPress swaps the table's contextualWidth; the property is bindable, so
    " the button only has to change the field
    DATA contextual_width TYPE string VALUE `500px`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_568 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->tag( `MessageStrip`
            )->a( n = `text`     v = `Table is initially setting contextualWidth to 500px. Press button to change the contextualWidth.`
            )->a( n = `type`     v = `Success`
            )->a( n = `class`    v = `sapUiSmallMargin`
            )->a( n = `showIcon` v = `true`

        )->ele( `OverflowToolbar`
            )->tag( `Button`
                )->a( n = `text`  v = `change contextualWidth to 100px`
                )->a( n = `press` v = client->_event( `CHANGE_WIDTH` )

        )->end(

        )->ele( `Table`
            )->a( n = `id`              v = `table`
            )->a( n = `contextualWidth` v = client->_bind( contextual_width )
            )->a( n = `popinLayout`     v = `GridSmall`
            )->a( n = `headerText`      v = `Products`
            )->a( n = `items`           v = client->_bind( t_people )

            )->ele( `columns`
                )->ele( `Column`

                    )->ele( `header`
                        )->tag( `Label`
                            )->a( n = `text` v = `First Name`

                    )->end(
                )->end(
                )->ele( `Column`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `minScreenWidth` v = `Phone`

                    )->ele( `header`
                        )->tag( `Label`
                            )->a( n = `text` v = `Last Name`

                    )->end(
                )->end(
                )->ele( `Column`
                    )->a( n = `minScreenWidth` v = `Phone`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `popinDisplay`   v = `Inline`
                    )->a( n = `hAlign`         v = `Right`

                    )->ele( `header`
                        )->tag( `Label`
                            )->a( n = `text` v = `Birth Date`

                    )->end(
                )->end(
                )->ele( `Column`
                    )->a( n = `width`          v = `4rem`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `Right`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `popinDisplay`   v = `Inline`

                    )->ele( `header`
                        )->tag( `Label`
                            )->a( n = `text` v = `Gender`

                    )->end(
                )->end(
            )->end(
            )->ele( `items`
                )->ele( `ColumnListItem`

                    )->ele( `cells`
                        )->tag( `Label`
                            )->a( n = `text` v = `{FIRSTNAME}`
                        )->tag( `Label`
                            )->a( n = `text` v = `{LASTNAME}`
                        )->tag( `Label`
                            )->a( n = `text` v = `{BIRTHDATE}`
                        )->tag( `Label`
                            )->a( n = `text` v = `{GENDER}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    " onPress: setContextualWidth('100px') - a bindable property, so the handler
    " only writes the field the table binds
    IF client->get_event( ) = `CHANGE_WIDTH`.
      contextual_width = `100px`.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the controller's oData, verbatim
    DATA temp1 TYPE z2ui5_cl_smpc_app_568=>ty_t_person.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-firstname = `John`.
    temp2-lastname = `Doe`.
    temp2-birthdate = `1986-05-11`.
    temp2-gender = `Male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Harry`.
    temp2-lastname = `Potter`.
    temp2-birthdate = `1976-05-19`.
    temp2-gender = `Male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Heinz`.
    temp2-lastname = `Piper`.
    temp2-birthdate = `1989-08-08`.
    temp2-gender = `Male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Indiana`.
    temp2-lastname = `Jones`.
    temp2-birthdate = `1991-12-03`.
    temp2-gender = `Male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Darth`.
    temp2-lastname = `Vader`.
    temp2-birthdate = `1977-02-24`.
    temp2-gender = `Male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Barbara`.
    temp2-lastname = `Dreher`.
    temp2-birthdate = `1999-08-31`.
    temp2-gender = `Female`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Dante`.
    temp2-lastname = `Alighieri`.
    temp2-birthdate = `1982-04-22`.
    temp2-gender = `Male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Mark`.
    temp2-lastname = `Anson`.
    temp2-birthdate = `1984-05-24`.
    temp2-gender = `Male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Jane`.
    temp2-lastname = `Doe`.
    temp2-birthdate = `1976-07-17`.
    temp2-gender = `Female`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Sean`.
    temp2-lastname = `Penn`.
    temp2-birthdate = `1977-09-15`.
    temp2-gender = `Male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Terry`.
    temp2-lastname = `Jones`.
    temp2-birthdate = `1988-06-07`.
    temp2-gender = `Male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Leia`.
    temp2-lastname = `Vader`.
    temp2-birthdate = `1991-11-09`.
    temp2-gender = `Female`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Karla`.
    temp2-lastname = `Damon`.
    temp2-birthdate = `1981-12-08`.
    temp2-gender = `Female`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Andante`.
    temp2-lastname = `Allegro`.
    temp2-birthdate = `1985-07-02`.
    temp2-gender = `Male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `John`.
    temp2-lastname = `Dufke`.
    temp2-birthdate = `1979-08-17`.
    temp2-gender = `Male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Hermione`.
    temp2-lastname = `Potter`.
    temp2-birthdate = `1971-06-15`.
    temp2-gender = `Female`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Dante`.
    temp2-lastname = `Alioli`.
    temp2-birthdate = `1987-05-11`.
    temp2-gender = `Male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Heinz`.
    temp2-lastname = `Pepper`.
    temp2-birthdate = `1995-10-21`.
    temp2-gender = `Male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `John`.
    temp2-lastname = `Johnson`.
    temp2-birthdate = `1981-10-26`.
    temp2-gender = `Male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Luke`.
    temp2-lastname = `Vader`.
    temp2-birthdate = `1972-06-06`.
    temp2-gender = `Male`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Petra`.
    temp2-lastname = `Delorean`.
    temp2-birthdate = `1988-04-24`.
    temp2-gender = `Female`.
    INSERT temp2 INTO TABLE temp1.
    temp2-firstname = `Venus`.
    temp2-lastname = `Botticelli`.
    temp2-birthdate = `1976-09-08`.
    temp2-gender = `Female`.
    INSERT temp2 INTO TABLE temp1.
    t_people = temp1.

  ENDMETHOD.

ENDCLASS.
