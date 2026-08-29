" @keywords progressindicator progress indicator sap.m progressindicatorwithannouncement verticallayout text flexbox button
" @summary Announce the progress of the ProgressIndicator.
CLASS z2ui5_cl_smpc_app_435 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA value_animated    TYPE i.
    DATA display_animated  TYPE string VALUE `0%`.
    DATA value_plain       TYPE i.
    DATA display_plain     TYPE string VALUE `0%`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_435 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( n = `content` ns = `l`
                )->tag( `Text`
                    )->a( n = `text`  v = `Set the ProgressIndicator to 100% with animation`
                    )->a( n = `class` v = `sapUiSmallMarginBottom`
                " the original sets displayValue and percentValue imperatively in
                " onPIChangeValueButtonPressed - both are bound here and written in ABAP
                )->tag( `ProgressIndicator`
                    )->a( n = `id`           v = `pi-with-animation`
                    )->a( n = `class`        v = `sapUiSmallMarginBottom`
                    )->a( n = `displayValue` v = client->_bind( display_animated )
                    )->a( n = `percentValue` v = client->_bind( value_animated )
                    )->a( n = `state`        v = `Success`
                    )->a( n = `displayOnly`  v = `true`

                )->ele( `FlexBox`

                    )->tag( `Button`
                        )->a( n = `id`    v = `pi-with-animation-button0`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                        )->a( n = `text`  v = `Set to 0%`
                        )->a( n = `press` v = client->_event( val = `SET_VALUE` arg = `$event.oSource.sId` )
                    )->tag( `Button`
                        )->a( n = `id`    v = `pi-with-animation-button50`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                        )->a( n = `text`  v = `Set to 50%`
                        )->a( n = `press` v = client->_event( val = `SET_VALUE` arg = `$event.oSource.sId` )
                    )->tag( `Button`
                        )->a( n = `id`    v = `pi-with-animation-button100`
                        )->a( n = `text`  v = `Set to 100%`
                        )->a( n = `press` v = client->_event( val = `SET_VALUE` arg = `$event.oSource.sId` )

                )->end(

                )->tag( `Text`
                    )->a( n = `text`  v = `Set the ProgressIndicator to 100% without animation`
                    )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->tag( `ProgressIndicator`
                    )->a( n = `id`               v = `pi-without-animation`
                    )->a( n = `class`            v = `sapUiSmallMarginBottom`
                    )->a( n = `displayValue`     v = client->_bind( display_plain )
                    )->a( n = `percentValue`     v = client->_bind( value_plain )
                    )->a( n = `state`            v = `Success`
                    )->a( n = `displayOnly`      v = `true`
                    )->a( n = `displayAnimation` v = `false`

                )->ele( `FlexBox`

                    )->tag( `Button`
                        )->a( n = `id`    v = `pi-without-animation-button0`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                        )->a( n = `text`  v = `Set to 0%`
                        )->a( n = `press` v = client->_event( val = `SET_VALUE` arg = `$event.oSource.sId` )
                    )->tag( `Button`
                        )->a( n = `id`    v = `pi-without-animation-button50`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                        )->a( n = `text`  v = `Set to 50%`
                        )->a( n = `press` v = client->_event( val = `SET_VALUE` arg = `$event.oSource.sId` )
                    )->tag( `Button`
                        )->a( n = `id`    v = `pi-without-animation-button100`
                        )->a( n = `text`  v = `Set to 100%`
                        )->a( n = `press` v = client->_event( val = `SET_VALUE` arg = `$event.oSource.sId` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `SET_VALUE`.

      " the original reads the pressed button's id and splits it into the
      " ProgressIndicator id and the value - the same split, done in ABAP
      DATA(source_id) = client->get_event_arg( ).
      DATA(offset)    = find( val = source_id sub = `button` ).
      IF offset < 0.
        RETURN.
      ENDIF.
      DATA(indicator) = substring( val = source_id len = offset - 1 ).
      DATA(value)     = CONV i( substring( val = source_id off = offset + 6 ) ).

      DATA(previous) = COND string( WHEN indicator CS `pi-with-animation` THEN display_animated ELSE display_plain ).

      IF indicator CS `pi-with-animation`.
        value_animated   = value.
        display_animated = |{ value }%|.
      ELSE.
        value_plain   = value.
        display_plain = |{ value }%|.
      ENDIF.

      " InvisibleMessage.getInstance().announce( ... ) - a singleton with no
      " control id, so the announcement goes through the global target
      client->follow_up_action( val   = client->cs_event-control_global
                                t_arg = VALUE #( ( `INVISIBLE_MESSAGE` )
                                                 ( `announce` )
                                                 ( |Previous value was { previous }. New value is { value }%.| ) ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
