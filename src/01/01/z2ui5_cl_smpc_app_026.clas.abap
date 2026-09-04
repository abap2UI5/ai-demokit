" @keywords flexbox flex box sap.m boxes nested. remember html hbox flexitemdata vbox
" @summary Flex Boxes can be nested. Remember also that HBox and VBox are 'convenience' controls based on the Flex Box control.
CLASS z2ui5_cl_smpc_app_026 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_026 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the sample's style.css, injected via a core:HTML content attribute
    " (see CAPABILITIES.md) - placed before the HBox so it is no flex item
    " literal braces escaped as \{ \} - the XMLView binding parser reads
    " unescaped braces in attribute values as a binding
    DATA css TYPE string.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    css = `<style>.nestedFlexboxes .item1\{padding:1rem;background-color:#d1dbbd\}` &&
                `.nestedFlexboxes .item2\{padding:1rem;background-color:#7D8A2E\}` &&
                `.nestedFlexboxes .item3\{padding:1rem;background-color:#C9D787\}` &&
                `.nestedFlexboxes .item4\{padding:1rem;background-color:#FFFFFF\}` &&
                `.nestedFlexboxes .item5\{padding:1rem;background-color:#FFC0A9\}` &&
                `.nestedFlexboxes .item6\{padding:1rem;background-color:#FF8598\}` &&
                `.nestedFlexboxes h2\{color:#32363a\}</style>`.

    
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = css

        )->ele( `HBox`
            )->a( n = `fitContainer` v = `true`
            )->a( n = `alignItems`   v = `Stretch`
            )->a( n = `class`        v = `sapUiSmallMargin nestedFlexboxes`

            )->ele( n = `HTML` ns = `core`
                )->a( n = `content` v = `<h2>1</h2>`

                )->ele( n = `layoutData` ns = `core`
                    )->tag( `FlexItemData`
                        )->a( n = `growFactor` v = `2`
                        )->a( n = `styleClass` v = `item1`

                )->end(
            )->end(
            )->ele( n = `HTML` ns = `core`
                )->a( n = `content` v = `<h2>2</h2>`

                )->ele( n = `layoutData` ns = `core`
                    )->tag( `FlexItemData`
                        )->a( n = `growFactor` v = `3`
                        )->a( n = `styleClass` v = `item2`

                )->end(
            )->end(
            )->ele( `VBox`
                )->a( n = `fitContainer` v = `true`

                )->ele( `layoutData`
                    )->tag( `FlexItemData`
                        )->a( n = `growFactor` v = `7`

                )->end(
                )->ele( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<h2>3</h2>`

                    )->ele( n = `layoutData` ns = `core`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `5`
                            )->a( n = `styleClass` v = `item3`

                    )->end(
                )->end(
                )->ele( `HBox`
                    )->a( n = `fitContainer` v = `true`
                    )->a( n = `alignItems`   v = `Stretch`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `3`

                    )->end(
                    )->ele( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<h2>4</h2>`

                        )->ele( n = `layoutData` ns = `core`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`
                                )->a( n = `styleClass` v = `item4`

                        )->end(
                    )->end(
                    )->ele( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<h2>5</h2>`

                        )->ele( n = `layoutData` ns = `core`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`
                                )->a( n = `styleClass` v = `item5`

                        )->end(
                    )->end(
                )->end(
            )->end(
            )->ele( n = `HTML` ns = `core`
                )->a( n = `content` v = `<h2>6</h2>`

                )->ele( n = `layoutData` ns = `core`
                    )->tag( `FlexItemData`
                        )->a( n = `growFactor` v = `5`
                        )->a( n = `styleClass` v = `item6` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
