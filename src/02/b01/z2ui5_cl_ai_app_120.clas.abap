CLASS z2ui5_cl_ai_app_120 DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS view_display.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_ai_app_120 IMPLEMENTATION.
  METHOD z2ui5_if_app~main.
    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.
  ENDMETHOD.

  METHOD view_display.
    DATA(view) = z2ui5_cl_ai_xml=>factory( ).
    " raw HTML injected via the core:HTML content attribute (the builder xml-escapes it into the attribute)
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`
            )->leaf( n = `HTML` ns = `core`
                )->a( n = `content` v = `<div class="content"><h4>Lorem ipsum</h4><div>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, ` &&
                                        `sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.</div>` &&
                                        `<a target="_blank" href="http://en.wikipedia.org/wiki/Lorem_ipsum">Learn more about Lorem Ipsum ...</a></div>` ).
    client->view_display( view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
