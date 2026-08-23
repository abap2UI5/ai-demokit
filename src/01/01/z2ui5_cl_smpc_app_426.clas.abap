" @keywords flexbox flex box sap.m flexboxcols html verticallayout text flexitemdata
" @summary You can create balanced areas with Flex Box, such as these columns with equal height regardless of content.
CLASS z2ui5_cl_smpc_app_426 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_426 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's style.css, injected via a core:HTML content attribute
        " (see CAPABILITIES.md) - the min-height of the equal columns and the
        " flex-item padding verbatim. Literal braces are escaped \{ \} in a
        " backtick literal: the XMLView parser reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>` &&
                                    `.equalColumns .columns \{min-height:200px\}` &&
                                    `.equalColumns .columns .sapMFlexItem \{padding:0.5rem\}` &&
                                    `</style>`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding equalColumns`
            )->a( n = `width` v = `100%`

            )->ele( `FlexBox`
                )->a( n = `class` v = `columns`

                )->ele( `Text`
                    )->a( n = `text` v = `Although they have different amounts of text, both columns are of equal height.`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor`       v = `1`
                            )->a( n = `baseSize`         v = `0`
                            )->a( n = `backgroundDesign` v = `Solid`
                            )->a( n = `styleClass`       v = `sapUiTinyMargin`

                    )->end(
                )->end(

                )->ele( `Text`
                    )->a( n = `text` v = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore ` &&
                                         `et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo hey nonny no duo dolores ` &&
                                         `et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum ` &&
                                         `dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore ` &&
                                         `magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita ` &&
                                         `kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor`       v = `1`
                            )->a( n = `baseSize`         v = `0`
                            )->a( n = `backgroundDesign` v = `Solid`
                            )->a( n = `styleClass`       v = `sapUiTinyMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
