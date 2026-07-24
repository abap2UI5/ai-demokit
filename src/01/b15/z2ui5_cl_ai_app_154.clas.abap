CLASS z2ui5_cl_ai_app_154 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA html TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_154 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiMediumMargin`
            )->leaf( `FormattedText`
                )->a( n = `htmlText` v = client->_bind( html ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    html = `<h3>subheader</h3><p>link: <a href="//www.sap.com" style="color:green; font-weight:600;">link to sap.com</a> - links open in a new window.</p><p>paragraph: <str` &&
           `ong>strong</strong> and <em>emphasized</em>.</p><p>list:</p><ul><li>list item 1</li><li>list item 2<ul><li>sub item 1</li><li>sub item 2</li></ul></li></ul><p>p` &&
           `re:</p><pre>abc    def    ghi</pre><p>code: <code>var el = document.getElementById("myId");</code></p><p>cite: <cite>a reference to a source</cite></p><dl><dt>d` &&
           `efinition:</dt><dd>definition list of terms and descriptions</dd>`.

  ENDMETHOD.

ENDCLASS.
