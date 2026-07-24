CLASS z2ui5_cl_ai_app_137 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        supplier   TYPE string,
        street     TYPE string,
        city       TYPE string,
        phone      TYPE string,
        openorders TYPE i,
      END OF ty_row.
    DATA modeldata TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_137 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->open( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`
            )->a( n = `class`           v = `sapUiContentPadding`

            )->open( n = `content` ns = `m`
                )->open( `Table`
                    )->a( n = `id`                v = `table1`
                    )->a( n = `ariaLabelledBy`    v = `title`
                    )->a( n = `selectionMode`     v = `MultiToggle`
                    )->a( n = `rows`              v = client->_bind( modeldata )
                    )->a( n = `enableColumnFreeze` v = `true`

                    )->open( `extension`
                        )->open( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`
                            )->leaf( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Contacts`

                    )->shut(
                    )->shut(

                    )->open( `columns`
                        )->open( `Column`
                            )->a( n = `width`          v = `11rem`
                            )->a( n = `sortProperty`   v = `supplier`
                            )->a( n = `filterProperty` v = `supplier`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text`      v = `Supplier`
                                )->a( n = `textAlign` v = `Center`
                                )->a( n = `width`     v = `100%`
                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `{SUPPLIER}`

                        )->shut(
                        )->shut(

                        )->open( `Column`
                            )->a( n = `width`          v = `11rem`
                            )->a( n = `sortProperty`   v = `street`
                            )->a( n = `filterProperty` v = `street`
                            )->a( n = `headerSpan`     v = `3,2`
                            )->open( `multiLabels`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text`      v = `Contact`
                                    )->a( n = `textAlign` v = `Center`
                                    )->a( n = `width`     v = `100%`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text`      v = `Address`
                                    )->a( n = `textAlign` v = `Center`
                                    )->a( n = `width`     v = `100%`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text`      v = `Street`
                                    )->a( n = `textAlign` v = `Center`
                                    )->a( n = `width`     v = `100%`

                            )->shut(
                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{STREET}`
                                    )->a( n = `wrapping` v = `false`

                        )->shut(
                        )->shut(

                        )->open( `Column`
                            )->a( n = `width`        v = `11rem`
                            )->a( n = `sortProperty` v = `city`
                            )->a( n = `headerSpan`   v = `2`
                            )->open( `multiLabels`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Contact`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Address`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text`      v = `City`
                                    )->a( n = `textAlign` v = `Center`
                                    )->a( n = `width`     v = `100%`

                            )->shut(
                            )->open( `template`
                                )->leaf( n = `Input` ns = `m`
                                    )->a( n = `value` v = `{CITY}`

                        )->shut(
                        )->shut(

                        )->open( `Column`
                            )->a( n = `width`        v = `11rem`
                            )->a( n = `sortProperty` v = `phone`
                            )->open( `multiLabels`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Contact`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text`      v = `Phone`
                                    )->a( n = `textAlign` v = `Center`
                                    )->a( n = `width`     v = `100%`

                            )->shut(
                            )->open( `template`
                                )->leaf( n = `Input` ns = `m`
                                    )->a( n = `value` v = `{PHONE}`

                        )->shut(
                        )->shut(

                        )->open( `Column`
                            )->a( n = `width` v = `8rem`
                            )->a( n = `hAlign` v = `End`
                            )->open( `multiLabels`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `visible` v = `false`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `visible` v = `false`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Open Orders`

                            )->shut(
                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `{OPENORDERS}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    modeldata = VALUE #(
      ( supplier = `Titanium`          street = `401 23rd St` city = `Port Angeles` phone = `5682-121-828` openorders = 10 )
      ( supplier = `Technocom`         street = `51 39th St`  city = `Smallfield`   phone = `2212-853-789` openorders = 0 )
      ( supplier = `Red Point Stores`  street = `451 55th St` city = `Meridian`     phone = `2234-245-898` openorders = 5 )
      ( supplier = `Technocom`         street = `40 21st St`  city = `Bethesda`     phone = `5512-125-643` openorders = 0 )
      ( supplier = `Very Best Screens` street = `123 72nd St` city = `McLean`       phone = `5412-543-765` openorders = 6 ) ).

  ENDMETHOD.

ENDCLASS.
