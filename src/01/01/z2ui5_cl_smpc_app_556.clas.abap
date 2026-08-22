" @keywords datepicker date picker sap.m datepickermassedit vbox table toolbar title toolbarspacer button column
" @summary Using calendar in a dialog for changing dates in mass editing scenario.
CLASS z2ui5_cl_smpc_app_556 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name         TYPE string,
             suppliername TYPE string,
             dateofsale   TYPE string,
             selected     TYPE abap_bool,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products    TYPE ty_t_product.
    DATA selected_date TYPE string.
    DATA has_selection TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_date_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_556 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `Table`
                )->a( n = `id`    v = `selectionTable`
                )->a( n = `mode`  v = `MultiSelect`
                )->a( n = `items` v = client->_bind( t_products )
                " handleTableSelectionChange only enables the button when at least
                " one row is selected; the row flag is bound two-way, so the
                " selection reaches the backend and the button reads it from there
                )->a( n = `selectionChange` v = client->_event( `SELECTION_CHANGE` )

                )->ele( `headerToolbar`
                    )->ele( `Toolbar`
                        )->tag( `Title`
                            )->a( n = `text`  v = `Products`
                            )->a( n = `level` v = `H2`
                        )->tag( `ToolbarSpacer`
                        )->tag( `Button`
                            )->a( n = `text`    v = `Change Dates`
                            )->a( n = `id`      v = `changeDatesButton`
                            )->a( n = `enabled` v = client->_bind( has_selection )
                            )->a( n = `press`   v = client->_event( `CHANGE_DATES` )

                    )->end(
                )->end(

                )->ele( `columns`
                    )->ele( `Column`
                        )->tag( `Text`
                            )->a( n = `text` v = `Product Name`

                    )->end(
                    )->ele( `Column`
                        )->tag( `Text`
                            )->a( n = `text` v = `Supplier Name`

                    )->end(
                    )->ele( `Column`
                        )->tag( `Text`
                            )->a( n = `text` v = `Time of buying`

                    )->end(
                )->end(

                )->ele( `items`
                    )->ele( `ColumnListItem`
                        )->a( n = `vAlign`   v = `Middle`
                        )->a( n = `type`     v = `Navigation`
                        )->a( n = `selected` v = `{SELECTED}`

                        )->ele( `cells`
                            )->tag( `Text`
                                )->a( n = `text`     v = `{NAME}`
                                )->a( n = `wrapping` v = `false`
                            )->tag( `Text`
                                )->a( n = `text`     v = `{SUPPLIERNAME}`
                                )->a( n = `wrapping` v = `false`
                            )->tag( `DatePicker`
                                )->a( n = `id`            v = `datePicker`
                                )->a( n = `value`         v = `{DATEOFSALE}`
                                )->a( n = `valueFormat`   v = `yyyy-MM-dd`
                                )->a( n = `displayFormat` v = `long` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_date_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the dialog and its Calendar are built in the controller (new Dialog({ ... }))
    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`

        )->ele( `Dialog`
            )->a( n = `title` v = `Select New Date`

            )->ele( `beginButton`
                )->tag( `Button`
                    )->a( n = `text`    v = `OK`
                    " handleCalendarSelect enables OK once a date is picked
                    )->a( n = `enabled` v = |\{= ${ client->_bind( selected_date ) } !== '' \}|
                    )->a( n = `press`   v = client->_event( `DATE_OK` )

            )->end(
            )->ele( `endButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Close`
                    )->a( n = `press` v = client->_event( `DATE_CLOSE` )

            )->end(

            )->ele( n = `Calendar` ns = `unified`
                )->a( n = `width`  v = `100%`
                )->a( n = `select` v = client->_event(
                          val   = `CALENDAR_SELECT`
                          t_arg = VALUE #(
                            ( `$event.oSource.getSelectedDates()[0].getStartDate().getFullYear()` )
                            ( `$event.oSource.getSelectedDates()[0].getStartDate().getMonth() + 1` )
                            ( `$event.oSource.getSelectedDates()[0].getStartDate().getDate()` ) ) ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SELECTION_CHANGE`.
        " handleTableSelectionChange enables the button while at least one row is
        " selected; the row flags are bound two-way, so the count is already here
        has_selection = xsdbool( line_exists( t_products[ selected = abap_true ] ) ).

      WHEN `CHANGE_DATES`.
        selected_date = ``.
        popup_date_display( ).

      WHEN `CALENDAR_SELECT`.
        selected_date = |{ client->get_event_arg( ) }| &&
                        |-{ CONV i( client->get_event_arg( 2 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                        |-{ CONV i( client->get_event_arg( 3 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.

      WHEN `DATE_OK`.
        " the OK button writes the picked date into every SELECTED row
        LOOP AT t_products ASSIGNING FIELD-SYMBOL(<product>) WHERE selected = abap_true.
          <product>-dateofsale = selected_date.
        ENDLOOP.
        client->popup_destroy( ).

      WHEN `DATE_CLOSE`.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " setSizeLimit( 10 ) keeps the first ten rows of the mock collection
    t_products = VALUE #(
      ( name = `Notebook Basic 15` suppliername = `Very Best Screens` dateofsale = `2017-03-26` )
      ( name = `Notebook Basic 17` suppliername = `Very Best Screens` dateofsale = `2017-04-17` )
      ( name = `Notebook Basic 18` suppliername = `Very Best Screens` dateofsale = `2017-01-07` )
      ( name = `Notebook Basic 19` suppliername = `Smartcards` dateofsale = `2017-04-09` )
      ( name = `ITelO Vault` suppliername = `Technocom` dateofsale = `2017-05-17` )
      ( name = `Notebook Professional 15` suppliername = `Very Best Screens` dateofsale = `2017-02-22` )
      ( name = `Notebook Professional 17` suppliername = `Very Best Screens` dateofsale = `2017-01-02` )
      ( name = `ITelO Vault Net` suppliername = `Technocom` dateofsale = `2017-05-08` )
      ( name = `ITelO Vault SAT` suppliername = `Technocom` dateofsale = `2017-06-30` )
      ( name = `Comfort Easy` suppliername = `Technocom` dateofsale = `2017-03-02` )
    ).

  ENDMETHOD.

ENDCLASS.
