" @keywords text sap.m textemptyindicator panel simpleform label switch
" @summary The Text control has a property allowing an empty text indicator to be displayed.
CLASS z2ui5_cl_smpc_app_439 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_439 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`      v = `sap.ui.layout.form`
        )->a( n = `displayBlock` v = `true`

        )->ele( `Panel`
            )->a( n = `id`         v = `containerLayout`
            )->a( n = `headerText` v = `emptyIndicatorMode:'On`
            )->a( n = `width`      v = `100%`

            )->ele( n = `SimpleForm` ns = `f`
                )->a( n = `layout`          v = `ResponsiveGridLayout`
                )->a( n = `editable`        v = `true`
                )->a( n = `adjustLabelSpan` v = `false`
                )->a( n = `labelSpanXL`     v = `2`
                )->a( n = `labelSpanL`      v = `2`
                )->a( n = `labelSpanM`      v = `3`
                )->a( n = `labelSpanS`      v = `5`

                )->tag( `Label`
                    )->a( n = `text` v = `Products`
                " emptyIndicatorMode is @since 1.87 - On always renders the dash
                )->tag( `Text`
                    )->a( n = `id`                 v = `text0`
                    )->a( n = `emptyIndicatorMode` v = `On`
                    )->a( n = `text`               v = ``

            )->end(
        )->end(

        )->ele( `Panel`
            )->a( n = `id`         v = `containerAuto`
            )->a( n = `headerText` v = `emptyIndicatorMode:'Auto'`
            )->a( n = `width`      v = `100%`

            )->ele( n = `SimpleForm` ns = `f`
                )->a( n = `layout`          v = `ResponsiveGridLayout`
                )->a( n = `editable`        v = `true`
                )->a( n = `adjustLabelSpan` v = `false`
                )->a( n = `labelSpanXL`     v = `2`
                )->a( n = `labelSpanL`      v = `2`
                )->a( n = `labelSpanM`      v = `3`
                )->a( n = `labelSpanS`      v = `5`

                )->tag( `Text`
                    )->a( n = `text` v = `Toggle switch to add 'sapMShowEmpty-CTX' css class to the Panel`
                " onCssClassChange calls containerAuto.toggleStyleClass('sapMShowEmpty-CTX') -
                " the same call, client-side, through control_by_id
                )->tag( `Switch`
                    )->a( n = `id`     v = `CssClassSwitch`
                    )->a( n = `state`  v = `false`
                    )->a( n = `change` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                     t_arg = VALUE #( ( `containerAuto` ) ( `toggleStyleClass` ) ( `sapMShowEmpty-CTX` ) ) )
                )->tag( `Label`
                    )->a( n = `text` v = `Products`
                " Auto renders the dash only inside a sapMShowEmpty-CTX container
                )->tag( `Text`
                    )->a( n = `emptyIndicatorMode` v = `Auto`
                    )->a( n = `text`               v = `` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
