" @keywords selectdialog select dialog sap.m selectdialoglazyloading button standardlistitem
" @summary Select Dialog lazy loading example with JSON model.
CLASS z2ui5_cl_smpc_app_422 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name        TYPE string,
             description TYPE string,
           END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_422 IMPLEMENTATION.

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

        )->ele( `Button`
            )->a( n = `text`         v = `Show Select Dialog`
            " onOpenDialogPress opens the dependent dialog 1:1, roundtrip-free
            )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                   t_arg = VALUE #( ( `mySelectDialog` ) ( `open` ) ) )
            )->a( n = `class`        v = `sapUiSmallMargin`
            )->a( n = `ariaHasPopup` v = `Dialog`

        )->end(

        " the Dialog fragment is declared as a view dependent and opened by id -
        " the core:FragmentDefinition root itself has no counterpart
        )->ele( n = `dependents` ns = `mvc`
            )->ele( `SelectDialog`
                )->a( n = `id`               v = `mySelectDialog`
                )->a( n = `initialFocus`     v = `SearchField`
                )->a( n = `noDataText`       v = `No Products Found`
                )->a( n = `title`            v = `Select Product`
                " onSearch: Contains filter on the items binding, resolved on the
                " client - the model stays untouched
                )->a( n = `search`           v = client->follow_up_action( val   = client->cs_event-binding_call
                                                                           t_arg = VALUE #( ( `mySelectDialog` ) ( `items` ) ( `filter` ) ( `NAME` ) ( `Contains` ) ( `${$parameters>/value}` ) ) )
                )->a( n = `growingThreshold` v = `30`
                )->a( n = `updateStarted`    v = client->_event( val = `UPDATE_STARTED` arg = `${$parameters>/reason}` )
                )->a( n = `items`            v = client->_bind( t_products )

                )->tag( `StandardListItem`
                    )->a( n = `title`            v = `{NAME}`
                    )->a( n = `description`      v = `{DESCRIPTION}`
                    )->a( n = `iconDensityAware` v = `false`
                    )->a( n = `iconInset`        v = `false`
                    )->a( n = `type`             v = `Active` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    " onUpdateStarted: only a Growing update lazy-loads the next slice
    IF client->get_event( ) = `UPDATE_STARTED` AND client->get_event_arg( ) = `Growing`.
      " 1:1 with the original loop: it starts at length-1 and adds 30 rows,
      " capped at 1001 - including its off-by-one re-append of the last row
      DATA(idx) = lines( t_products ) - 1.
      DATA(upper) = nmin( val1 = idx + 30 val2 = 1001 ).
      WHILE idx < upper.
        APPEND VALUE #( name = |Name { idx }| description = |Description { idx }| ) TO t_products.
        idx = idx + 1.
      ENDWHILE.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the original seeds productCollection with a generation loop (1..31), not a mock file
    DO 31 TIMES.
      APPEND VALUE #( name = |Name { sy-index }| description = |Description { sy-index }| ) TO t_products.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
