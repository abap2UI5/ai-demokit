" @keywords containerpadding container padding sap.ui.core no content messagestrip icontabbar text icontabfilter icontabseparator
CLASS z2ui5_cl_smpc_app_087 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA total      TYPE i.
    DATA ok         TYPE i.
    DATA heavy      TYPE i.
    DATA overweight TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_087 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->tag( `MessageStrip`
            )->a( n = `text`  v = `The IconTabBar and other container controls have a content padding by default. You can override default container content paddings by setting the CSS class 'sapUiNoContentPadding' to the container control`
            )->a( n = `class` v = `sapUiTinyMargin`

        )->ele( `IconTabBar`
            )->a( n = `id`    v = `idIconTabBar`
            )->a( n = `class` v = `sapUiNoContentPadding`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = `IconTabBar content without padding`

            )->end(

            )->ele( `items`
                )->tag( `IconTabFilter`
                    )->a( n = `showAll` v = `true`
                    )->a( n = `count`   v = client->_bind( total )
                    )->a( n = `text`    v = `Products`
                    )->a( n = `key`     v = `All`
                )->tag( `IconTabSeparator`
                )->tag( `IconTabFilter`
                    )->a( n = `icon`      v = `sap-icon://begin`
                    )->a( n = `iconColor` v = `Positive`
                    )->a( n = `count`     v = client->_bind( ok )
                    )->a( n = `text`      v = `Ok`
                    )->a( n = `key`       v = `Ok`
                )->tag( `IconTabFilter`
                    )->a( n = `icon`      v = `sap-icon://compare`
                    )->a( n = `iconColor` v = `Critical`
                    )->a( n = `count`     v = client->_bind( heavy )
                    )->a( n = `text`      v = `Heavy`
                    )->a( n = `key`       v = `Heavy`
                )->tag( `IconTabFilter`
                    )->a( n = `icon`      v = `sap-icon://inventory`
                    )->a( n = `iconColor` v = `Negative`
                    )->a( n = `count`     v = client->_bind( overweight )
                    )->a( n = `text`      v = `Overweight`
                    )->a( n = `key`       v = `Overweight`

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " /ProductCollectionStats/Counts of ui5/mock/products.json, verbatim
    total      = 123.
    ok         = 53.
    heavy      = 51.
    overweight = 19.

  ENDMETHOD.

ENDCLASS.
