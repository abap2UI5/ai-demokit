" @keywords selectdialog select dialog sap.m selectdialoglazyloading button standardlistitem
" @summary Select Dialog lazy loading example with JSON model.
CLASS z2ui5_cl_smpc_app_422 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name        TYPE string,
             description TYPE string,
           END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `mySelectDialog` INTO TABLE temp1.
    INSERT `open` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `mySelectDialog` INTO TABLE temp2.
    INSERT `items` INTO TABLE temp2.
    INSERT `filter` INTO TABLE temp2.
    INSERT `NAME` INTO TABLE temp2.
    INSERT `Contains` INTO TABLE temp2.
    INSERT `${$parameters>/value}` INTO TABLE temp2.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `Button`
            )->a( n = `text`         v = `Show Select Dialog`
            " onOpenDialogPress opens the dependent dialog 1:1, roundtrip-free
            )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                   t_arg = temp1 )
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
                                                                           t_arg = temp2 )
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
      DATA idx TYPE i.
      DATA upper TYPE i.
        DATA temp3 TYPE z2ui5_cl_smpc_app_422=>ty_s_product.

    " onUpdateStarted: only a Growing update lazy-loads the next slice
    IF client->get_event( ) = `UPDATE_STARTED` AND client->get_event_arg( ) = `Growing`.
      " 1:1 with the original loop: it starts at length-1 and adds 30 rows,
      " capped at 1001 - including its off-by-one re-append of the last row
      
      idx = lines( t_products ) - 1.
      
      upper = nmin( val1 = idx + 30 val2 = 1001 ).
      WHILE idx < upper.
        
        CLEAR temp3.
        temp3-name = |Name { idx }|.
        temp3-description = |Description { idx }|.
        APPEND temp3 TO t_products.
        idx = idx + 1.
      ENDWHILE.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.
      DATA temp4 TYPE z2ui5_cl_smpc_app_422=>ty_s_product.

    " the original seeds productCollection with a generation loop (1..31), not a mock file
    DO 31 TIMES.
      
      CLEAR temp4.
      temp4-name = |Name { sy-index }|.
      temp4-description = |Description { sy-index }|.
      APPEND temp4 TO t_products.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
