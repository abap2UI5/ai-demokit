"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.FlexBox - FlexBoxNested
"! https://sdk.openui5.org/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxNested
"! API USAGE AUDIT: (a) frontend_action (_event_client): NO | (b) event t_arg: NO
"! NOTES (generation):
"! - IMPROVISED: the original sample colours .item1..item6 and the h2 headings
"!   via a separate style.css; the previous port injected it through an
"!   html:style block. z2ui5_cl_api_xml has no raw-text/CDATA node, so that CSS
"!   cannot be emitted - the styleClass attributes are ported 1:1 but the flex
"!   items render without their background colours. Dropped.
CLASS z2ui5_cl_api_app_404 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_404 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the original sample's style.css cannot be injected via z2ui5_cl_api_xml
    " (no raw-text node) - see NOTES; styleClass item1..item6 kept but unstyled
    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `HBox`
            )->a( n = `fitContainer` v = `true`
            )->a( n = `alignItems`   v = `Stretch`
            )->a( n = `class`        v = `sapUiSmallMargin nestedFlexboxes`

            )->open( n = `HTML` ns = `core`
                )->a( n = `content` v = `<h2>1</h2>`

                )->open( n = `layoutData` ns = `core`
                    )->leaf( `FlexItemData`
                        )->a( n = `growFactor` v = `2`
                        )->a( n = `styleClass` v = `item1`

                )->shut(
            )->shut(
            )->open( n = `HTML` ns = `core`
                )->a( n = `content` v = `<h2>2</h2>`

                )->open( n = `layoutData` ns = `core`
                    )->leaf( `FlexItemData`
                        )->a( n = `growFactor` v = `3`
                        )->a( n = `styleClass` v = `item2`

                )->shut(
            )->shut(
            )->open( `VBox`
                )->a( n = `fitContainer` v = `true`

                )->open( `layoutData`
                    )->leaf( `FlexItemData`
                        )->a( n = `growFactor` v = `7`

                )->shut(
                )->open( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<h2>3</h2>`

                    )->open( n = `layoutData` ns = `core`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `5`
                            )->a( n = `styleClass` v = `item3`

                    )->shut(
                )->shut(
                )->open( `HBox`
                    )->a( n = `fitContainer` v = `true`
                    )->a( n = `alignItems`   v = `Stretch`

                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `3`

                    )->shut(
                    )->open( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<h2>4</h2>`

                        )->open( n = `layoutData` ns = `core`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`
                                )->a( n = `styleClass` v = `item4`

                        )->shut(
                    )->shut(
                    )->open( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<h2>5</h2>`

                        )->open( n = `layoutData` ns = `core`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`
                                )->a( n = `styleClass` v = `item5`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
            )->open( n = `HTML` ns = `core`
                )->a( n = `content` v = `<h2>6</h2>`

                )->open( n = `layoutData` ns = `core`
                    )->leaf( `FlexItemData`
                        )->a( n = `growFactor` v = `5`
                        )->a( n = `styleClass` v = `item6` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
