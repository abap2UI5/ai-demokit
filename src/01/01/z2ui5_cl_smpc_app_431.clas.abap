" @keywords containerpadding container padding sap.ui.core containerresponsivepadding messagestrip panel toolbar text toolbarspacer button horizontallayout
" @summary Apply the CSS class 'sapUiResponsiveContentPadding' on a UI5 container control to add a responsive padding based on the screen size around the container content area.
CLASS z2ui5_cl_smpc_app_431 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_431 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->tag( `MessageStrip`
            )->a( n = `text`  v = `A panel by default has a fixed content padding of 1rem (16px). By by setting the CSS class ` &&
                                  `'sapUiResponsiveContentPadding' to the container control you will get a responsive padding based on ` &&
                                  `the current screen size and the app mode around the content area. On phone devices and small screens ` &&
                                  `no padding is applied, on tablet devices and inside a SplitApp control a medium padding is applied, ` &&
                                  `and on desktop and fullscreen applications a large padding is applied. Try the fullscreen mode of the ` &&
                                  `Explored app to see the difference`
            )->a( n = `class` v = `sapUiTinyMargin`

        )->ele( `Panel`
            )->a( n = `class` v = `sapUiResponsiveContentPadding`

            )->ele( `headerToolbar`
                )->ele( `Toolbar`
                    )->a( n = `height` v = `3rem`

                    )->tag( `Text`
                        )->a( n = `text`  v = `Header`
                        )->a( n = `class` v = `sapMH4FontSize`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `icon` v = `sap-icon://settings`
                    )->tag( `Button`
                        )->a( n = `icon` v = `sap-icon://drop-down-list`

                )->end(
            )->end(

            )->ele( `content`
                )->ele( n = `HorizontalLayout` ns = `l`

                    " {img>/products/pic1} of ui5/mock/img.json - the named img model
                    " folds to the mock's own value, re-hosted on sdk.openui5.org
                    )->tag( `Image`
                        )->a( n = `width`        v = `10em`
                        )->a( n = `densityAware` v = `false`
                        )->a( n = `src`          v = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`

                )->end(

                )->tag( `Text`
                    )->a( n = `text` v = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor ` &&
                                         `invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam ` &&
                                         `et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est ` &&
                                         `Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam ` &&
                                         `nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                         `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor ` &&
                                         `invidunt ut labore et dolore magna aliquyam erat` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
