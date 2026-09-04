" @keywords html sap.ui.core raw injection verticallayout
" @summary With the HTML controls you can easily embed any kind of HTML content into your UI5 mobile application.
CLASS z2ui5_cl_smpc_app_120 DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS view_display.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_app_120 IMPLEMENTATION.
  METHOD z2ui5_if_app~main.
    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.
  ENDMETHOD.

  METHOD view_display.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).
    " raw HTML injected via the core:HTML content attribute (the builder xml-escapes it into the attribute)
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`
            )->tag( n = `HTML` ns = `core`
                )->a( n = `content` v = `<div class="content"><h4>Lorem ipsum</h4><div>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, ` &&
                                        `sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                        `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est ` &&
                                        `Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod ` &&
                                        `tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo ` &&
                                        `duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</div>` &&
                                        `<a target="_blank" href="http://en.wikipedia.org/wiki/Lorem_ipsum">Learn more about Lorem Ipsum ...</a></div>` ).
    client->view_display( view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
