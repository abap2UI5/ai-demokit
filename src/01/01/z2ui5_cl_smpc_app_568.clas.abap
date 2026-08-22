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
    TYPES ty_t_person TYPE STANDARD TABLE OF ty_s_person WITH EMPTY KEY.

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
    t_people = VALUE #(
      ( firstname = `John`      lastname = `Doe`        birthdate = `1986-05-11` gender = `Male` )
      ( firstname = `Harry`     lastname = `Potter`     birthdate = `1976-05-19` gender = `Male` )
      ( firstname = `Heinz`     lastname = `Piper`      birthdate = `1989-08-08` gender = `Male` )
      ( firstname = `Indiana`   lastname = `Jones`      birthdate = `1991-12-03` gender = `Male` )
      ( firstname = `Darth`     lastname = `Vader`      birthdate = `1977-02-24` gender = `Male` )
      ( firstname = `Barbara`   lastname = `Dreher`     birthdate = `1999-08-31` gender = `Female` )
      ( firstname = `Dante`     lastname = `Alighieri`  birthdate = `1982-04-22` gender = `Male` )
      ( firstname = `Mark`      lastname = `Anson`      birthdate = `1984-05-24` gender = `Male` )
      ( firstname = `Jane`      lastname = `Doe`        birthdate = `1976-07-17` gender = `Female` )
      ( firstname = `Sean`      lastname = `Penn`       birthdate = `1977-09-15` gender = `Male` )
      ( firstname = `Terry`     lastname = `Jones`      birthdate = `1988-06-07` gender = `Male` )
      ( firstname = `Leia`      lastname = `Vader`      birthdate = `1991-11-09` gender = `Female` )
      ( firstname = `Karla`     lastname = `Damon`      birthdate = `1981-12-08` gender = `Female` )
      ( firstname = `Andante`   lastname = `Allegro`    birthdate = `1985-07-02` gender = `Male` )
      ( firstname = `John`      lastname = `Dufke`      birthdate = `1979-08-17` gender = `Male` )
      ( firstname = `Hermione`  lastname = `Potter`     birthdate = `1971-06-15` gender = `Female` )
      ( firstname = `Dante`     lastname = `Alioli`     birthdate = `1987-05-11` gender = `Male` )
      ( firstname = `Heinz`     lastname = `Pepper`     birthdate = `1995-10-21` gender = `Male` )
      ( firstname = `John`      lastname = `Johnson`    birthdate = `1981-10-26` gender = `Male` )
      ( firstname = `Luke`      lastname = `Vader`      birthdate = `1972-06-06` gender = `Male` )
      ( firstname = `Petra`     lastname = `Delorean`   birthdate = `1988-04-24` gender = `Female` )
      ( firstname = `Venus`     lastname = `Botticelli` birthdate = `1976-09-08` gender = `Female` ) ).

  ENDMETHOD.

ENDCLASS.
