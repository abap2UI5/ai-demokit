"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.StepInput - StepInput
"! https://sdk.openui5.org/entity/sap.m.StepInput/sample/sap.m.sample.StepInput
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

  " NOTES (generation):
  " - IMPROVISED: the sample binds a List to the JSON model /modelData and renders
  "   one templated CustomListItem per row. The rows are unrolled into static list
  "   items here because every row sets a different subset of the StepInput
  "   properties - an empty ABAP model field would bind as "" instead of leaving
  "   the property at its default, so a bound template would not render 1:1.

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

    DATA(change) = client->_event( val   = `CHANGE`
                                   t_arg = VALUE #( ( `${$parameters>/value}` ) ) ).

    DATA(list) = view->open( n = `View` ns = `mvc`
            )->attr( n = `xmlns`     v = `sap.m`
            )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`

            )->open( `List`
                )->attr( n = `id` v = `idTable` ).

    render_item( list  = list
                 label = `Step = 1 (default); value = 6, min = 5, max = 15, width = 120px`
        )->leaf( `StepInput`
            )->attr( n = `value`  v = `6`
            )->attr( n = `min`    v = `5`
            )->attr( n = `max`    v = `15`
            )->attr( n = `width`  v = `120px`
            )->attr( n = `change` v = change ).

    render_item( list  = list
                 label = `Step = 1 (default); value = 6, min = 5, max = 15, width = 120px, with validation on LiveChange`
        )->leaf( `StepInput`
            )->attr( n = `value`          v = `6`
            )->attr( n = `min`            v = `5`
            )->attr( n = `max`            v = `15`
            )->attr( n = `width`          v = `120px`
            )->attr( n = `validationMode` v = `LiveChange`
            )->attr( n = `change`         v = change ).

    render_item( list  = list
                 label = `Step = 5, no value, no min, no max, width = 120px`
        )->leaf( `StepInput`
            )->attr( n = `step`   v = `5`
            )->attr( n = `width`  v = `120px`
            )->attr( n = `change` v = change ).

    render_item( list  = list
                 label = `Step = 5, no value, no min, no max, width = 120px, largerStep = 3`
        )->leaf( `StepInput`
            )->attr( n = `step`       v = `5`
            )->attr( n = `width`      v = `120px`
            )->attr( n = `largerStep` v = `3`
            )->attr( n = `change`     v = change ).

    render_item( list  = list
                 label = `Step = 1.1, no value, displayValuePrecision = 1, min = -6, max = 23.5, width = 120px`
        )->leaf( `StepInput`
            )->attr( n = `step`                  v = `1.1`
            )->attr( n = `min`                   v = `-6`
            )->attr( n = `max`                   v = `23.5`
            )->attr( n = `width`                 v = `120px`
            )->attr( n = `displayValuePrecision` v = `1`
            )->attr( n = `change`                v = change ).

    render_item( list  = list
                 label = `Disabled, value = 12.3, displayValuePrecision = 1, width = 120px`
        )->leaf( `StepInput`
            )->attr( n = `value`                 v = `12.3`
            )->attr( n = `enabled`               v = `false`
            )->attr( n = `width`                 v = `120px`
            )->attr( n = `displayValuePrecision` v = `1`
            )->attr( n = `change`                v = change ).

    render_item( list  = list
                 label = `Read only, value = 123, default width of 100%`
        )->leaf( `StepInput`
            )->attr( n = `value`    v = `123`
            )->attr( n = `editable` v = `false`
            )->attr( n = `change`   v = change ).

    render_item( list  = list
                 label = `Step = 0.05; value = 1.32, displayValuePrecision = 3, min = -5, max = 15`
        )->leaf( `StepInput`
            )->attr( n = `value`                 v = `1.32`
            )->attr( n = `step`                  v = `0.05`
            )->attr( n = `min`                   v = `-5`
            )->attr( n = `max`                   v = `15`
            )->attr( n = `displayValuePrecision` v = `3`
            )->attr( n = `change`                v = change ).

    render_item( list  = list
                 label = `Step = 1.05; value = 1.5675, displayValuePrecision = 2, no Min and Max`
        )->leaf( `StepInput`
            )->attr( n = `value`                 v = `1.5675`
            )->attr( n = `step`                  v = `1.05`
            )->attr( n = `displayValuePrecision` v = `2`
            )->attr( n = `change`                v = change ).

    render_item( list  = list
                 label = `Step = -1 (which becomes 1), value = 20, width = 120px`
        )->leaf( `StepInput`
            )->attr( n = `value`  v = `20`
            )->attr( n = `step`   v = `-1`
            )->attr( n = `width`  v = `120px`
            )->attr( n = `change` v = change ).

    render_item( list  = list
                 label = `Step = 1 (default); value = 6, min = 5, max = 15, width = 240px, with added description and default fieldWidth 50%`
        )->leaf( `StepInput`
            )->attr( n = `value`       v = `6`
            )->attr( n = `min`         v = `5`
            )->attr( n = `max`         v = `15`
            )->attr( n = `width`       v = `240px`
            )->attr( n = `description` v = `EUR`
            )->attr( n = `change`      v = change ).

    render_item( list  = list
                 label = `Step = 1 (default); value = 160, with added description and fieldWidth set to 70%`
        )->leaf( `StepInput`
            )->attr( n = `value`       v = `160`
            )->attr( n = `fieldWidth`  v = `70%`
            )->attr( n = `description` v = `EUR`
            )->attr( n = `change`      v = change ).

    render_item( list  = list
                 label = `Step = 1 (default); value = 160, align:Center`
        )->leaf( `StepInput`
            )->attr( n = `value`     v = `160`
            )->attr( n = `textAlign` v = `Center`
            )->attr( n = `change`    v = change ).

    render_item( list  = list
                 label = `Step = 5, stepMode = Multiple, min = -40, max = 100, value = 10,`
        )->leaf( `StepInput`
            )->attr( n = `value`    v = `10`
            )->attr( n = `step`     v = `5`
            )->attr( n = `max`      v = `100`
            )->attr( n = `min`      v = `-40`
            )->attr( n = `stepMode` v = `Multiple`
            )->attr( n = `change`   v = change ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD render_item.

    result = list->open( `CustomListItem`
        )->open( `HBox`
            )->attr( n = `class`          v = `sapUiTinyMargin`
            )->attr( n = `justifyContent` v = `SpaceBetween`
            )->attr( n = `alignItems`     v = `Center`

            )->open( `VBox`
                )->attr( n = `class` v = `sapUiSmallMarginEnd`

                )->leaf( `Label`
                    )->attr( n = `text`     v = label
                    )->attr( n = `wrapping` v = `true`

            )->shut(
            )->open( `VBox` ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `CHANGE`.
        client->message_toast_display( |Value changed to '{ client->get_event_arg( 1 ) }'| ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
