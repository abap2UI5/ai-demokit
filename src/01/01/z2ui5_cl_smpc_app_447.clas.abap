" @keywords messagebox message box sap.m messageboxinfo button
" @summary MessageBox with the option to display detailed information.
CLASS z2ui5_cl_smpc_app_447 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " the responsive padding classes every MessageBox of the sample carries
    CONSTANTS c_padding TYPE string VALUE `sapUiResponsivePadding--header sapUiResponsivePadding--content sapUiResponsivePadding--footer`.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_447 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
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
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Button`
                )->a( n = `text`  v = `Show Details - Text`
                )->a( n = `press` v = client->_event( `TEXT_INFO` )
                )->a( n = `width` v = `250px`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->tag( `Button`
                )->a( n = `text`  v = `Show Details - FormattedText`
                )->a( n = `press` v = client->_event( `FORMATTED_TEXT_INFO` )
                )->a( n = `width` v = `250px`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->tag( `Button`
                )->a( n = `text`  v = `Show Details - JSON`
                )->a( n = `press` v = client->_event( `JSON_INFO` )
                )->a( n = `width` v = `250px`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
            )->tag( `Button`
                )->a( n = `text`  v = `Show Details Async - Text`
                )->a( n = `press` v = client->_event( `TEXT_INFO_ASYNC` )
                )->a( n = `width` v = `250px`
                )->a( n = `class` v = `sapUiSmallMarginBottom` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `TEXT_INFO`.
        client->message_box_display( text         = `Information`
                                     type         = `information`
                                     title        = `Information`
                                     details      = `Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, ` &&
                                    `eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam ` &&
                                    `voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione ` &&
                                    `voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit,` &&
                                    ` sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad ` &&
                                    `minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi ` &&
                                    `consequatur. Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel ` &&
                                    `illum qui dolorem eum fugiat quo voluptas nulla pariatur.`
                                     contentwidth = `100px`
                                     styleclass   = c_padding ).

      WHEN `FORMATTED_TEXT_INFO`.
        " the details are markup - MessageBox renders them as a FormattedText
        client->message_box_display( text         = `Unable to load data.`
                                     type         = `error`
                                     title        = `Error`
                                     details      = `<p><strong>This can happen if:</strong></p>` &&
                                                    `<ul>` &&
                                                    `<li>You are not connected to the internet</li>` &&
                                                    `<li>a backend component is not <em>available</em></li>` &&
                                                    `<li>or an underlying system is down</li>` &&
                                                    `</ul>` &&
                                                    `<p>Get more help <a href='//www.sap.com' target='_top'>here</a>.`
                                     contentwidth = `100px`
                                     styleclass   = c_padding ).

      WHEN `JSON_INFO`.
        " the original hands MessageBox a JS object; the same object as JSON
        client->message_box_display( text         = `Error message`
                                     type         = `error`
                                     title        = `Error`
                                     details      = `\{"glossary":\{"title":"example glossary"\}\}`
                                     contentwidth = `100px`
                                     styleclass   = c_padding ).

      WHEN `TEXT_INFO_ASYNC`.
        " the original resolves the details from a Promise after 2 seconds;
        " the backend has the text right away and passes it as it is
        client->message_box_display( text         = `Information`
                                     type         = `information`
                                     title        = `Information`
                                     details      = `Asynchronously fetched details`
                                     contentwidth = `100px`
                                     styleclass   = c_padding ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
