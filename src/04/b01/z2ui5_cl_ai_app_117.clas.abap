CLASS z2ui5_cl_ai_app_117 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_117 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`    v = `sap.f`
        )->a( n = `xmlns:card` v = `sap.f.cards`
        )->a( n = `height`     v = `100%`

        )->open( n = `Card` ns = `f`
            )->a( n = `class` v = `sapUiMediumMargin`
            )->a( n = `width` v = `300px`

            )->open( n = `header` ns = `f`
                )->leaf( n = `Header` ns = `card`
                    )->a( n = `title`    v = `Buy bus ticket on-line`
                    )->a( n = `subtitle` v = `Buy a single-ride ticket for a date`
                    )->a( n = `iconSrc`  v = `sap-icon://bus-public-transport`

            )->shut(
            )->open( n = `content` ns = `f`
                )->open( `VBox`
                    )->a( n = `height`         v = `110px`
                    )->a( n = `class`          v = `sapUiSmallMargin`
                    )->a( n = `justifyContent` v = `SpaceBetween`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Card content (original: From/To ComboBoxes + a date picker + a Buy button)`
                    )->leaf( `Button`
                        )->a( n = `text` v = `Buy Now`
                        )->a( n = `type` v = `Emphasized` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
