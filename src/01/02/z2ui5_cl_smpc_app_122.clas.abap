CLASS z2ui5_cl_smpc_app_122 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_122 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        " the sample's style.css, injected via a core:HTML content attribute
        " (see CAPABILITIES.md) - the five size classes the Icons below carry,
        " including the <600px media query, verbatim. Literal braces are escaped
        " \{ \} in a backtick literal: the XMLView parser reads an unescaped
        " brace as a binding
        )->leaf( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>` &&
                                    `.size1\{font-size:1.5rem\}` &&
                                    `.size2\{font-size:2.5rem\}` &&
                                    `.size3\{font-size:5rem\}` &&
                                    `.size4\{font-size:7.5rem\}` &&
                                    `.size5\{font-size:10rem\}` &&
                                    `@media (max-width:599px)\{` &&
                                    `.size1\{font-size:1rem\}` &&
                                    `.size2\{font-size:2rem\}` &&
                                    `.size3\{font-size:3rem\}` &&
                                    `.size4\{font-size:4rem\}` &&
                                    `.size5\{font-size:5rem\}\}` &&
                                    `</style>`

        )->open( `HBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->open( n = `Icon` ns = `core`
                )->a( n = `src`   v = `sap-icon://syringe`
                )->a( n = `class` v = `size1`
                )->a( n = `color` v = `#031E48`
                )->open( n = `layoutData` ns = `core`
                    )->leaf( `FlexItemData`
                        )->a( n = `growFactor` v = `1`

                )->shut(
            )->shut(

            )->open( n = `Icon` ns = `core`
                )->a( n = `src`   v = `sap-icon://pharmacy`
                )->a( n = `class` v = `size2`
                )->a( n = `color` v = `#64E4CE`
                )->open( n = `layoutData` ns = `core`
                    )->leaf( `FlexItemData`
                        )->a( n = `growFactor` v = `1`

                )->shut(
            )->shut(

            )->open( n = `Icon` ns = `core`
                )->a( n = `src`   v = `sap-icon://electrocardiogram`
                )->a( n = `class` v = `size3`
                )->a( n = `color` v = `#E69A17`
                )->open( n = `layoutData` ns = `core`
                    )->leaf( `FlexItemData`
                        )->a( n = `growFactor` v = `1`

                )->shut(
            )->shut(

            )->open( n = `Icon` ns = `core`
                )->a( n = `src`   v = `sap-icon://doctor`
                )->a( n = `class` v = `size4`
                )->a( n = `color` v = `#1C4C98`
                )->open( n = `layoutData` ns = `core`
                    )->leaf( `FlexItemData`
                        )->a( n = `growFactor` v = `1`

                )->shut(
            )->shut(

            )->open( n = `Icon` ns = `core`
                )->a( n = `src`   v = `sap-icon://stethoscope`
                )->a( n = `class` v = `size5`
                )->a( n = `color` v = `#8875E7`
                )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Over budget!` ) ) )
                )->open( n = `layoutData` ns = `core`
                    )->leaf( `FlexItemData`
                        )->a( n = `growFactor` v = `1` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
