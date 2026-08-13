CLASS z2ui5_cl_smpc_app_387 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_387 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->leaf( `Label`
                )->a( n = `text`     v = `Product`
                )->a( n = `labelFor` v = `wrappingMultiInput`

            )->open( `MultiInput`
                )->a( n = `id`             v = `wrappingMultiInput`
                )->a( n = `placeholder`    v = `Enter product`
                )->a( n = `showSuggestion` v = `true`
                )->a( n = `width`          v = `50%`

                )->open( `suggestionItems`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `1`
                        )->a( n = `text`
                                 v = `Wireless DSL/ Repeater and Print Server Lorem ipsum dolar st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor incidunt ut labore et ` &&
                                     `dolore magna aliquyam erat, diam nonumy eirmod tempor individunt ut labore et dolore magna aliquyam erat, sed justo et ea rebum.`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `2`
                        )->a( n = `text`
                                 v = `7" Widescreen Portable DVD Player w MP3, consetetur sadipscing, sed diam nonumy eirmod tempor invidunt ut labore et dolore et dolore magna aliquyam ` &&
                                     `erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergen, no sea takimata. Tortor pretium viverra ` &&
                                     `suspendisse potenti nullam.`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `3`
                        )->a( n = `text` v = `Portable DVD Player with 9" LCD Monitor` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
