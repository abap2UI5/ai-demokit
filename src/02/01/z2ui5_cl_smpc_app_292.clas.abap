" @keywords panel sap.m panelbackgrounddesign verticallayout horizontallayout label select item text messagestrip
" @summary Panels support different background designs for better visual distinction inside containers. [since rel. 1.150]
CLASS z2ui5_cl_smpc_app_292 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA background TYPE string VALUE `Solid`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_292 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " onBackgroundDesignChange sets the panel's backgroundDesign from the
    " selected key. Both are bindable properties over the same field, so the
    " Select writes it and the Panel reads it - no round-trip and no handler
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `width` v = `100%`
            )->a( n = `class` v = `sapUiResponsiveMargin`

            )->ele( n = `HorizontalLayout` ns = `l`
                )->a( n = `class` v = `sapUiSmallMarginBottom`

                )->tag( `Label`
                    )->a( n = `text`  v = `Background Design:`
                    )->a( n = `class` v = `sapUiSmallMarginEnd`

                )->ele( `Select`
                    )->a( n = `id`          v = `backgroundDesignSelect`
                    )->a( n = `selectedKey` v = client->_bind( background )

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `Solid`
                        )->a( n = `text` v = `Solid`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `Translucent`
                        )->a( n = `text` v = `Translucent`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `Transparent`
                        )->a( n = `text` v = `Transparent`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `Contrast`
                        )->a( n = `text` v = `Contrast`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `id`               v = `demoPanel`
                )->a( n = `headerText`       v = `Panel Header`
                )->a( n = `expandable`       v = `true`
                )->a( n = `expanded`         v = `true`
                )->a( n = `backgroundDesign` v = client->_bind( background )
                )->a( n = `width`            v = `100%`

                )->ele( `content`
                    )->tag( `Text`
                        )->a( n = `text` v = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, ` &&
                                             `sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est ` &&
                                             `Lorem ipsum dolor sit amet.`

                )->end(
            )->end(

            )->tag( `MessageStrip`
                )->a( n = `text`     v = `Note: The Contrast background design is only visible in Horizon themes (Morning/Evening). In other themes, it falls back to ` &&
                                         `Solid background.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`
                )->a( n = `class`    v = `sapUiSmallMarginTop` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
