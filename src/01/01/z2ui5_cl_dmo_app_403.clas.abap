CLASS z2ui5_cl_dmo_app_403 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_403 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->open( `subHeader`
                )->open( `Toolbar`
                    )->a( n = `design` v = `Info`

                    )->leaf( n = `Icon` ns = `core`
                        )->a( n = `src` v = `sap-icon://begin`
                    )->leaf( `Text`
                        )->a( n = `text` v = `This sample demonstrates classes which let you to add negative margin at two opposite sides (begin/end).`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->a( n = `class` v = `sapUiTinyNegativeMarginBeginEnd`

                )->open( `content`
                    )->leaf( `Text`
                        )->a( n = `text`  v = `This panel uses margin class 'sapUiTinyNegativeMarginBeginEnd' to add a -0.5rem space at the panel's left and right sides.`
                        )->a( n = `class` v = `sapMH4FontSize`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->a( n = `class` v = `sapUiSmallNegativeMarginBeginEnd`

                )->open( `content`
                    )->leaf( `Text`
                        )->a( n = `text`  v = `This panel uses margin class 'sapUiSmallNegativeMarginBeginEnd' to add a -1rem space at the panel's left and right sides.`
                        )->a( n = `class` v = `sapMH4FontSize`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->a( n = `class` v = `sapUiMediumNegativeMarginBeginEnd`

                )->open( `content`
                    )->leaf( `Text`
                        )->a( n = `text`  v = `This panel uses margin class 'sapUiMediumNegativeMarginBeginEnd' to add a -2rem space at the panel's left and right sides.`
                        )->a( n = `class` v = `sapMH4FontSize`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->a( n = `class` v = `sapUiLargeNegativeMarginBeginEnd`

                )->open( `content`
                    )->leaf( `Text`
                        )->a( n = `text`  v = `This panel uses margin class 'sapUiLargeNegativeMarginBeginEnd' to add a -3rem space at the panel's left and right sides.`
                        )->a( n = `class` v = `sapMH4FontSize` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
