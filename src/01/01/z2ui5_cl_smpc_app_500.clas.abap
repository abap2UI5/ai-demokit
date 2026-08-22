" @keywords standardmargins standard margins sap.ui.core standardnomargins text objectheader objectstatus objectattribute
" @summary Use our standard 'No-Margins' classes to remove existing margins from your control. You can either remove all margins at once or remove the margin on one or more sides.
CLASS z2ui5_cl_smpc_app_500 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the two records the original binds with binding="{/ProductCollection/0}"
    " and binding="{/ProductCollection/1}"
    DATA p1_name          TYPE string.
    DATA p1_price         TYPE p LENGTH 8 DECIMALS 2.
    DATA p1_currencycode  TYPE string.
    DATA p1_weightmeasure TYPE string.
    DATA p1_weightunit    TYPE string.
    DATA p1_width         TYPE string.
    DATA p1_depth         TYPE string.
    DATA p1_height        TYPE string.
    DATA p1_dimunit       TYPE string.
    DATA p1_description   TYPE string.
    DATA p2_name          TYPE string.
    DATA p2_price         TYPE p LENGTH 8 DECIMALS 2.
    DATA p2_currencycode  TYPE string.
    DATA p2_weightmeasure TYPE string.
    DATA p2_weightunit    TYPE string.
    DATA p2_width         TYPE string.
    DATA p2_depth         TYPE string.
    DATA p2_height        TYPE string.
    DATA p2_dimunit       TYPE string.
    DATA p2_description   TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_500 IMPLEMENTATION.

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

        )->tag( `Text`
            )->a( n = `text`  v = `ObjectHeader with its top and end margins removed:`
            )->a( n = `class` v = `sapUiExploredNoMarginInfo`

        )->ele( `ObjectHeader`
            )->a( n = `title`      v = client->_bind( p1_name )
            )->a( n = `number`     v = |\{ parts:[\{path:'{ client->_bind( val = p1_price path = abap_true ) }'\},| &&
                                        |\{path:'{ client->_bind( val = p1_currencycode path = abap_true ) }'\}],| &&
                                        | type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
            )->a( n = `numberUnit` v = client->_bind( p1_currencycode )
            )->a( n = `class`      v = `sapUiNoMarginTop sapUiNoMarginEnd`

            )->ele( `statuses`
                )->tag( `ObjectStatus`
                    )->a( n = `text`  v = `Some Damaged`
                    )->a( n = `state` v = `Error`
                )->tag( `ObjectStatus`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Success`

            )->end(
            )->ele( `attributes`
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = |{ client->_bind( p1_weightmeasure ) } { client->_bind( p1_weightunit ) }|
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = |{ client->_bind( p1_width ) } x { client->_bind( p1_depth ) } x { client->_bind( p1_height ) } { client->_bind( p1_dimunit ) }|
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = client->_bind( p1_description )
                )->tag( `ObjectAttribute`
                    )->a( n = `text`   v = `www.sap.com`
                    )->a( n = `active` v = `true`

            )->end(
        )->end(

        )->tag( `Text`
            )->a( n = `text`  v = `ObjectHeader with its bottom and begin margins removed:`
            )->a( n = `class` v = `sapUiExploredNoMarginInfo`

        )->ele( `ObjectHeader`
            )->a( n = `title`      v = client->_bind( p2_name )
            )->a( n = `number`     v = |\{ parts:[\{path:'{ client->_bind( val = p2_price path = abap_true ) }'\},| &&
                                        |\{path:'{ client->_bind( val = p2_currencycode path = abap_true ) }'\}],| &&
                                        | type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
            )->a( n = `numberUnit` v = client->_bind( p2_currencycode )
            )->a( n = `class`      v = `sapUiNoMarginBottom sapUiNoMarginBegin`

            )->ele( `statuses`
                )->tag( `ObjectStatus`
                    )->a( n = `text`  v = `Some Damaged`
                    )->a( n = `state` v = `Error`
                )->tag( `ObjectStatus`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Success`

            )->end(
            )->ele( `attributes`
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = |{ client->_bind( p2_weightmeasure ) } { client->_bind( p2_weightunit ) }|
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = |{ client->_bind( p2_width ) } x { client->_bind( p2_depth ) } x { client->_bind( p2_height ) } { client->_bind( p2_dimunit ) }|
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = client->_bind( p2_description )
                )->tag( `ObjectAttribute`
                    )->a( n = `text`   v = `www.sap.com`
                    )->a( n = `active` v = `true`

            )->end(
        )->end(

        )->tag( `Text`
            )->a( n = `text`  v = `By default, ObjectHeader instances come with a 16px (1rem) margin all around. In our example, we ` &&
                                  `added pre-defined css classes 'sapUiNoMarginTop' and 'sapUiNoMarginEnd' to remove the top and right ` &&
                                  `margin from the first ObjectHeader and 'sapUiNoMarginBottom' and 'sapUiNoMarginBegin' to remove the ` &&
                                  `bottom and left margin from the second ObjectHeader(in left-to-right mode). To see what happens in ` &&
                                  `Right-To-Left mode open 'Settings' by pressing the cog wheel button next to 'Entities'.`
            )->a( n = `class` v = `sapUiExploredNoMarginInfo` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " /ProductCollection/0 and /ProductCollection/1 of ui5/mock/products.json
    p1_name          = `Notebook Basic 15`.
    p1_price         = '956.00'.
    p1_currencycode  = `EUR`.
    p1_weightmeasure = `4.2`.
    p1_weightunit    = `KG`.
    p1_width         = `30`.
    p1_depth         = `18`.
    p1_height        = `3`.
    p1_dimunit       = `cm`.
    p1_description   = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.

    p2_name          = `Notebook Basic 17`.
    p2_price         = '1249.00'.
    p2_currencycode  = `EUR`.
    p2_weightmeasure = `4.5`.
    p2_weightunit    = `KG`.
    p2_width         = `29`.
    p2_depth         = `17`.
    p2_height        = `3.1`.
    p2_dimunit       = `cm`.
    p2_description   = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.

  ENDMETHOD.

ENDCLASS.
