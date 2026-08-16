CLASS z2ui5_cl_smpc_app_403 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_403 IMPLEMENTATION.

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
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->ele( `subHeader`
                )->ele( `Toolbar`
                    )->a( n = `design` v = `Info`

                    )->tag( n = `Icon` ns = `core`
                        )->a( n = `src` v = `sap-icon://begin`
                    )->tag( `Text`
                        )->a( n = `text` v = `This sample demonstrates classes which let you to add negative margin at two opposite sides (begin/end).`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `class` v = `sapUiTinyNegativeMarginBeginEnd`

                )->ele( `content`
                    )->tag( `Text`
                        )->a( n = `text`  v = `This panel uses margin class 'sapUiTinyNegativeMarginBeginEnd' to add a -0.5rem space at the panel's left and right sides.`
                        )->a( n = `class` v = `sapMH4FontSize`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `class` v = `sapUiSmallNegativeMarginBeginEnd`

                )->ele( `content`
                    )->tag( `Text`
                        )->a( n = `text`  v = `This panel uses margin class 'sapUiSmallNegativeMarginBeginEnd' to add a -1rem space at the panel's left and right sides.`
                        )->a( n = `class` v = `sapMH4FontSize`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `class` v = `sapUiMediumNegativeMarginBeginEnd`

                )->ele( `content`
                    )->tag( `Text`
                        )->a( n = `text`  v = `This panel uses margin class 'sapUiMediumNegativeMarginBeginEnd' to add a -2rem space at the panel's left and right sides.`
                        )->a( n = `class` v = `sapMH4FontSize`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `class` v = `sapUiLargeNegativeMarginBeginEnd`

                )->ele( `content`
                    )->tag( `Text`
                        )->a( n = `text`  v = `This panel uses margin class 'sapUiLargeNegativeMarginBeginEnd' to add a -3rem space at the panel's left and right sides.`
                        )->a( n = `class` v = `sapMH4FontSize` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
