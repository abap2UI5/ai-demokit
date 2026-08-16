" @keywords card sap.f fiori vbox hbox combobox datepicker button list customlistitem title text
" @summary This sample illustrates how to specify the predefined header and the content of the Card control.
CLASS z2ui5_cl_smpc_app_117 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_city,
             text TYPE string,
             key  TYPE string,
           END OF ty_s_city.
    TYPES: BEGIN OF ty_s_product,
             title        TYPE string,
             subtitle     TYPE string,
             revenue      TYPE string,
             status       TYPE string,
             statusschema TYPE string,
           END OF ty_s_product.
    DATA t_cities   TYPE STANDARD TABLE OF ty_s_city WITH EMPTY KEY.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_117 IMPLEMENTATION.

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

    " both cards of the sample, rebuilt 1:1. The two named models fold into the
    " one default model (cities> -> T_CITIES, products> -> T_PRODUCTS; the last
    " path segment stays identical, which is what structural-diff matches), and
    " the sorter of the two ComboBoxes rides along as a raw binding-info string
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`      v = `sap.f`
        )->a( n = `xmlns:card`   v = `sap.f.cards`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `height`       v = `100%`

        )->ele( n = `Card` ns = `f`
            )->a( n = `class` v = `sapUiMediumMargin`
            )->a( n = `width` v = `300px`

            )->ele( n = `header` ns = `f`
                )->tag( n = `Header` ns = `card`
                    )->a( n = `title`    v = `Buy bus ticket on-line`
                    )->a( n = `subtitle` v = `Buy a single-ride ticket for a date`
                    )->a( n = `iconSrc`  v = `sap-icon://bus-public-transport`

            )->end(
            )->ele( n = `content` ns = `f`
                )->ele( `VBox`
                    )->a( n = `height`         v = `110px`
                    )->a( n = `class`          v = `sapUiSmallMargin`
                    )->a( n = `justifyContent` v = `SpaceBetween`

                    )->ele( `HBox`
                        )->a( n = `justifyContent` v = `SpaceBetween`

                        )->ele( `ComboBox`
                            )->a( n = `width`       v = `120px`
                            )->a( n = `placeholder` v = `From City`
                            )->a( n = `items`       v = |\{ path: '{ client->_bind( val = t_cities path = abap_true ) }', sorter: \{ path: 'TEXT' \} \}|

                            )->ele( `items`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `{KEY}`
                                    )->a( n = `text` v = `{TEXT}`

                            )->end(
                        )->end(
                        )->ele( `ComboBox`
                            )->a( n = `width`       v = `120px`
                            )->a( n = `placeholder` v = `To City`
                            )->a( n = `items`       v = |\{ path: '{ client->_bind( val = t_cities path = abap_true ) }', sorter: \{ path: 'TEXT' \} \}|

                            )->ele( `items`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `{KEY}`
                                    )->a( n = `text` v = `{TEXT}`

                            )->end(
                        )->end(
                    )->end(
                    )->ele( `HBox`
                        )->a( n = `renderType`     v = `Bare`
                        )->a( n = `justifyContent` v = `SpaceBetween`

                        )->tag( `DatePicker`
                            )->a( n = `width`       v = `200px`
                            )->a( n = `placeholder` v = `Choose Date ...`
                        " onBookPress only toasts a fixed explanation - composed on the
                        " client, so the press needs no round-trip
                        )->tag( `Button`
                            )->a( n = `text`  v = `Book`
                            )->a( n = `press` v = client->follow_up_action(
                                      val   = client->cs_event-control_global
                                      t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                       ( `show` )
                                                       ( `By pressing the 'Book' button a new application can be opened where the actual booking happens. ` &&
                                                         `This can be in the same window, in a new tab or in a dialog.` ) ) )
                            )->a( n = `type`  v = `Emphasized`
                            )->a( n = `class` v = `sapUiTinyMarginBegin`

                    )->end(
                )->end(
            )->end(
        )->end(

        )->ele( n = `Card` ns = `f`
            )->a( n = `class` v = `sapUiMediumMargin`
            )->a( n = `width` v = `300px`

            )->ele( n = `header` ns = `f`
                )->tag( n = `Header` ns = `card`
                    )->a( n = `title`    v = `Project Cloud Transformation`
                    )->a( n = `subtitle` v = `Revenue per Product | EUR`

            )->end(
            )->ele( n = `content` ns = `f`
                )->ele( `List`
                    )->a( n = `class`          v = `sapUiSmallMarginBottom`
                    )->a( n = `showSeparators` v = `None`
                    )->a( n = `items`          v = client->_bind( t_products )

                    )->ele( `CustomListItem`
                        )->ele( `HBox`
                            )->a( n = `alignItems`     v = `Center`
                            )->a( n = `justifyContent` v = `SpaceBetween`

                            )->ele( `VBox`
                                )->a( n = `class` v = `sapUiSmallMarginBegin sapUiSmallMarginTopBottom`

                                )->tag( `Title`
                                    )->a( n = `level` v = `H3`
                                    )->a( n = `text`  v = `{TITLE}`
                                )->tag( `Text`
                                    )->a( n = `text` v = `{SUBTITLE}`

                            )->end(
                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapUiTinyMargin sapUiSmallMarginEnd`
                                )->a( n = `text`  v = `{REVENUE}`
                                )->a( n = `state` v = `{STATUSSCHEMA}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " model/cities.json and model/products.json, verbatim
    t_cities = VALUE #(
      ( text = `Berlin` key = `BR` )
      ( text = `London` key = `LN` )
      ( text = `Madrid` key = `MD` )
      ( text = `Prague` key = `PR` )
      ( text = `Paris`  key = `PS` )
      ( text = `Sofia`  key = `SF` )
      ( text = `Vienna` key = `VN` ) ).

    t_products = VALUE #(
      ( title = `Notebook HT` subtitle = `ID23452256-D44`  revenue = `27.25K EUR` status = `success`  statusschema = `Success` )
      ( title = `Notebook XT` subtitle = `ID27852256-D47`  revenue = `7.35K EUR`  status = `exceeded` statusschema = `Error` )
      ( title = `Notebook ST` subtitle = `ID123555587-I05` revenue = `22.89K EUR` status = `warning`  statusschema = `Warning` ) ).

  ENDMETHOD.

ENDCLASS.
