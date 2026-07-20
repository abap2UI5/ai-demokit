CLASS z2ui5_cl_ai_app_032 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_032 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(warning_text) = `Warning message. Extra long text used as a warning message. Extra long text used as a warning message - 2. ` &&
                         `Extra long text used as a warning message - 3. Extra long text used as a warning message - 4. ` &&
                         `Extra long text used as a warning message - 5.`.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->leaf( `Input`
                )->a( n = `value` v = `Value state None`
                )->a( n = `class` v = `sapUiSmallMarginTopBottom`

            )->leaf( `Input`
                )->a( n = `showClearIcon` v = `true`
                )->a( n = `valueState`    v = `Success`
                )->a( n = `value`         v = `Value state Success`
                )->a( n = `class`         v = `sapUiSmallMarginTopBottom`

            )->leaf( `Input`
                )->a( n = `showClearIcon`  v = `true`
                )->a( n = `valueState`     v = `Warning`
                )->a( n = `valueStateText` v = warning_text
                )->a( n = `value`          v = `Value state Warning.`
                )->a( n = `class`          v = `sapUiSmallMarginTopBottom`

            )->open( `Input`
                )->a( n = `showClearIcon` v = `true`
                )->a( n = `valueState`    v = `Warning`
                )->a( n = `value`         v = `Value state Warning with message containing a link.`
                )->a( n = `class`         v = `sapUiSmallMarginTopBottom`

                )->open( `formattedValueStateText`
                    )->open( `FormattedText`
                        )->a( n = `htmlText` v = `There is a conflict with the current value. Recommendation based on: %%0`

                        )->open( `controls`
                            )->leaf( `Link`
                                )->a( n = `text`  v = `See more information`
                                )->a( n = `href`  v = ``
                                )->a( n = `press` v = client->_event( `LINK_PRESS` )

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->leaf( `Input`
                )->a( n = `valueState` v = `Error`
                )->a( n = `value`      v = `Value state Error`
                )->a( n = `class`      v = `sapUiSmallMarginTopBottom`

            )->leaf( `Input`
                )->a( n = `valueState` v = `Information`
                )->a( n = `value`      v = `Value state Information`
                )->a( n = `class`      v = `sapUiSmallMarginTopBottom`

            )->open( `Input`
                )->a( n = `valueState` v = `Information`
                )->a( n = `value`      v = `Value state Information with message containing multiple links.`
                )->a( n = `class`      v = `sapUiSmallMarginTopBottom`

                )->open( `formattedValueStateText`
                    )->open( `FormattedText`
                        )->a( n = `htmlText` v = `Recommendation based on: %%0 and %%1.`

                        )->open( `controls`
                            )->leaf( `Link`
                                )->a( n = `text`  v = `link 1`
                                )->a( n = `press` v = client->_event( `LINK_PRESS` )
                            )->leaf( `Link`
                                )->a( n = `text`  v = `link 2`
                                )->a( n = `press` v = client->_event( `LINK_PRESS` )

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `LINK_PRESS`.
        client->message_toast_display(
          text = `You have pressed a link in value state message`
          my   = `center center`
          at   = `center center` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
