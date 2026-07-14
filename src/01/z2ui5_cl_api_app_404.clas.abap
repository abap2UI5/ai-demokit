"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.FlexBox - FlexBoxNested
"! https://sdk.openui5.org/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxNested
CLASS z2ui5_cl_api_app_404 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_404 IMPLEMENTATION.

  " NOTES (generation):
  " - IMPROVISED: the original sample colours .item1..item6 and the h2 headings
  "   via a separate style.css; the previous port injected it through an
  "   html:style block. z2ui5_cl_api_xml has no raw-text/CDATA node, so that CSS
  "   cannot be emitted - the styleClass attributes are ported 1:1 but the flex
  "   items render without their background colours. Dropped.

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
        )->attr( n = `xmlns`      v = `sap.m`
        )->attr( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->attr( n = `xmlns:core` v = `sap.ui.core`

        )->open( `HBox`
            )->attr( n = `fitContainer` v = `true`
            )->attr( n = `alignItems`   v = `Stretch`
            )->attr( n = `class`        v = `sapUiSmallMargin nestedFlexboxes`

            )->open( n = `HTML` ns = `core`
                )->attr( n = `content` v = `<h2>1</h2>`

                )->open( n = `layoutData` ns = `core`
                    )->leaf( `FlexItemData`
                        )->attr( n = `growFactor` v = `2`
                        )->attr( n = `styleClass` v = `item1`

                )->shut(
            )->shut(
            )->open( n = `HTML` ns = `core`
                )->attr( n = `content` v = `<h2>2</h2>`

                )->open( n = `layoutData` ns = `core`
                    )->leaf( `FlexItemData`
                        )->attr( n = `growFactor` v = `3`
                        )->attr( n = `styleClass` v = `item2`

                )->shut(
            )->shut(
            )->open( `VBox`
                )->attr( n = `fitContainer` v = `true`

                )->open( `layoutData`
                    )->leaf( `FlexItemData`
                        )->attr( n = `growFactor` v = `7`

                )->shut(
                )->open( n = `HTML` ns = `core`
                    )->attr( n = `content` v = `<h2>3</h2>`

                    )->open( n = `layoutData` ns = `core`
                        )->leaf( `FlexItemData`
                            )->attr( n = `growFactor` v = `5`
                            )->attr( n = `styleClass` v = `item3`

                    )->shut(
                )->shut(
                )->open( `HBox`
                    )->attr( n = `fitContainer` v = `true`
                    )->attr( n = `alignItems`   v = `Stretch`

                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->attr( n = `growFactor` v = `3`

                    )->shut(
                    )->open( n = `HTML` ns = `core`
                        )->attr( n = `content` v = `<h2>4</h2>`

                        )->open( n = `layoutData` ns = `core`
                            )->leaf( `FlexItemData`
                                )->attr( n = `growFactor` v = `1`
                                )->attr( n = `styleClass` v = `item4`

                        )->shut(
                    )->shut(
                    )->open( n = `HTML` ns = `core`
                        )->attr( n = `content` v = `<h2>5</h2>`

                        )->open( n = `layoutData` ns = `core`
                            )->leaf( `FlexItemData`
                                )->attr( n = `growFactor` v = `1`
                                )->attr( n = `styleClass` v = `item5`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
            )->open( n = `HTML` ns = `core`
                )->attr( n = `content` v = `<h2>6</h2>`

                )->open( n = `layoutData` ns = `core`
                    )->leaf( `FlexItemData`
                        )->attr( n = `growFactor` v = `5`
                        )->attr( n = `styleClass` v = `item6` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
