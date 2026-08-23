" @keywords flexbox flex box sap.m flexboxnav html vbox panel flexitemdata
" @summary Here is an example of how you can use navigation items as unordered list items in a Flex Box.
CLASS z2ui5_cl_smpc_app_474 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_474 IMPLEMENTATION.

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
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's style.css, injected via a core:HTML content attribute (see
        " CAPABILITIES.md) - the list styling both FlexBoxes rely on, verbatim.
        " Literal braces are escaped \{ \} in a backtick literal
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>` &&
                                    `.navigationExamples .code\{margin: 0 5%; font-family: Consolas, Courier, monospace;\}` &&
                                    `.navigationExamples .ne-flexbox1, .navigationExamples .ne-flexbox2\{padding: 0;\}` &&
                                    `.navigationExamples .ne-flexbox1 li\{margin: 0.4em; padding: 0.4em 1.3em; list-style-type: none; text-align: center; background-color: #193441; cursor: pointer;\}` &&
                                    `.navigationExamples .ne-flexbox1 li:hover\{background-color: orange;\}` &&
                                    `.navigationExamples .ne-flexbox2 li\{margin: 0.5em; width: 25%; min-width: 15%; list-style-type: none; text-align: center; background-color: #193441;` &&
                                    ` padding: 0.4em; transition: width 0.5s ease-out, background-color 0.5s ease-out, flex-basis 0.5s ease-out; cursor: pointer;\}` &&
                                    `.navigationExamples .ne-flexbox2 li:hover\{flex-basis: 35% !important; background-color: orange;\}` &&
                                    `.navigationExamples .ne-flexbox1 li a, .navigationExamples .ne-flexbox2 li a\{color: #fff; text-decoration: none; font-size: 0.875rem;\}` &&
                                    `</style>`

        )->ele( `VBox`
            )->a( n = `class` v = `navigationExamples`

            )->ele( `Panel`
                )->a( n = `headerText` v = `Variable width`

                )->ele( `FlexBox`
                    )->a( n = `class`          v = `ne-flexbox1`
                    )->a( n = `renderType`     v = `List`
                    )->a( n = `justifyContent` v = `Center`
                    )->a( n = `alignItems`     v = `Center`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<a >Item 1</a>`
                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<a >Long item 2</a>`
                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<a >Item 3</a>`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Same width, transition effect`

                )->ele( `FlexBox`
                    )->a( n = `class`          v = `ne-flexbox2`
                    )->a( n = `renderType`     v = `List`
                    )->a( n = `justifyContent` v = `SpaceBetween`
                    )->a( n = `alignItems`     v = `Center`

                    )->ele( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<a >Item 1</a>`

                        )->ele( n = `layoutData` ns = `core`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`
                                )->a( n = `baseSize`   v = `25%`

                        )->end(
                    )->end(

                    )->ele( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<a >Long item 2</a>`

                        )->ele( n = `layoutData` ns = `core`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`
                                )->a( n = `baseSize`   v = `25%`

                        )->end(
                    )->end(

                    )->ele( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<a >Item 3</a>`

                        )->ele( n = `layoutData` ns = `core`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`
                                )->a( n = `baseSize`   v = `25%`

                        )->end(
                    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
