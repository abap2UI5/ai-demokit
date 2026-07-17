CLASS z2ui5_cl_api_app_481 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS render_item
      IMPORTING
        list          TYPE REF TO z2ui5_cl_api_xml
        label         TYPE string
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_api_xml.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_481 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    DATA(list) = view->open( n = `View` ns = `mvc`
            )->a( n = `xmlns`     v = `sap.m`
            )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

            )->open( `List`
                )->a( n = `id` v = `idTable` ).

    render_item( list  = list
                 label = `Step = 1 (default); value = 6, min = 5, max = 15, width = 120px`
        )->leaf( `StepInput`
            )->a( n = `value`  v = `6`
            )->a( n = `min`    v = `5`
            )->a( n = `max`    v = `15`
            )->a( n = `width`  v = `120px`
            )->a( n = `change` v = client->_event( val = `CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    render_item( list  = list
                 label = `Step = 1 (default); value = 6, min = 5, max = 15, width = 120px, with validation on LiveChange`
        )->leaf( `StepInput`
            )->a( n = `value`          v = `6`
            )->a( n = `min`            v = `5`
            )->a( n = `max`            v = `15`
            )->a( n = `width`          v = `120px`
            )->a( n = `validationMode` v = `LiveChange`
            )->a( n = `change`         v = client->_event( val = `CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    render_item( list  = list
                 label = `Step = 5, no value, no min, no max, width = 120px`
        )->leaf( `StepInput`
            )->a( n = `step`   v = `5`
            )->a( n = `width`  v = `120px`
            )->a( n = `change` v = client->_event( val = `CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    render_item( list  = list
                 label = `Step = 5, no value, no min, no max, width = 120px, largerStep = 3`
        )->leaf( `StepInput`
            )->a( n = `step`       v = `5`
            )->a( n = `width`      v = `120px`
            )->a( n = `largerStep` v = `3`
            )->a( n = `change`     v = client->_event( val = `CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    render_item( list  = list
                 label = `Step = 1.1, no value, displayValuePrecision = 1, min = -6, max = 23.5, width = 120px`
        )->leaf( `StepInput`
            )->a( n = `step`                  v = `1.1`
            )->a( n = `min`                   v = `-6`
            )->a( n = `max`                   v = `23.5`
            )->a( n = `width`                 v = `120px`
            )->a( n = `displayValuePrecision` v = `1`
            )->a( n = `change`                v = client->_event( val = `CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    render_item( list  = list
                 label = `Disabled, value = 12.3, displayValuePrecision = 1, width = 120px`
        )->leaf( `StepInput`
            )->a( n = `value`                 v = `12.3`
            )->a( n = `enabled`               v = `false`
            )->a( n = `width`                 v = `120px`
            )->a( n = `displayValuePrecision` v = `1`
            )->a( n = `change`                v = client->_event( val = `CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    render_item( list  = list
                 label = `Read only, value = 123, default width of 100%`
        )->leaf( `StepInput`
            )->a( n = `value`    v = `123`
            )->a( n = `editable` v = `false`
            )->a( n = `change`   v = client->_event( val = `CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    render_item( list  = list
                 label = `Step = 0.05; value = 1.32, displayValuePrecision = 3, min = -5, max = 15`
        )->leaf( `StepInput`
            )->a( n = `value`                 v = `1.32`
            )->a( n = `step`                  v = `0.05`
            )->a( n = `min`                   v = `-5`
            )->a( n = `max`                   v = `15`
            )->a( n = `displayValuePrecision` v = `3`
            )->a( n = `change`                v = client->_event( val = `CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    render_item( list  = list
                 label = `Step = 1.05; value = 1.5675, displayValuePrecision = 2, no Min and Max`
        )->leaf( `StepInput`
            )->a( n = `value`                 v = `1.5675`
            )->a( n = `step`                  v = `1.05`
            )->a( n = `displayValuePrecision` v = `2`
            )->a( n = `change`                v = client->_event( val = `CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    render_item( list  = list
                 label = `Step = -1 (which becomes 1), value = 20, width = 120px`
        )->leaf( `StepInput`
            )->a( n = `value`  v = `20`
            )->a( n = `step`   v = `-1`
            )->a( n = `width`  v = `120px`
            )->a( n = `change` v = client->_event( val = `CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    render_item( list  = list
                 label = `Step = 1 (default); value = 6, min = 5, max = 15, width = 240px, with added description and default fieldWidth 50%`
        )->leaf( `StepInput`
            )->a( n = `value`       v = `6`
            )->a( n = `min`         v = `5`
            )->a( n = `max`         v = `15`
            )->a( n = `width`       v = `240px`
            )->a( n = `description` v = `EUR`
            )->a( n = `change`      v = client->_event( val = `CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    render_item( list  = list
                 label = `Step = 1 (default); value = 160, with added description and fieldWidth set to 70%`
        )->leaf( `StepInput`
            )->a( n = `value`       v = `160`
            )->a( n = `fieldWidth`  v = `70%`
            )->a( n = `description` v = `EUR`
            )->a( n = `change`      v = client->_event( val = `CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    render_item( list  = list
                 label = `Step = 1 (default); value = 160, align:Center`
        )->leaf( `StepInput`
            )->a( n = `value`     v = `160`
            )->a( n = `textAlign` v = `Center`
            )->a( n = `change`    v = client->_event( val = `CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    render_item( list  = list
                 label = `Step = 5, stepMode = Multiple, min = -40, max = 100, value = 10,`
        )->leaf( `StepInput`
            )->a( n = `value`    v = `10`
            )->a( n = `step`     v = `5`
            )->a( n = `max`      v = `100`
            )->a( n = `min`      v = `-40`
            )->a( n = `stepMode` v = `Multiple`
            )->a( n = `change`   v = client->_event( val = `CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD render_item.

    result = list->open( `CustomListItem`
        )->open( `HBox`
            )->a( n = `class`          v = `sapUiTinyMargin`
            )->a( n = `justifyContent` v = `SpaceBetween`
            )->a( n = `alignItems`     v = `Center`

            )->open( `VBox`
                )->a( n = `class` v = `sapUiSmallMarginEnd`

                )->leaf( `Label`
                    )->a( n = `text`     v = label
                    )->a( n = `wrapping` v = `true`

            )->shut(
            )->open( `VBox` ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `CHANGE`.
        client->message_toast_display( |Value changed to '{ client->get_event_arg( ) }'| ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
