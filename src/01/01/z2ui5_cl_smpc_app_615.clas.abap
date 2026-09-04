" @keywords objectheader object header sap.m objectheaderresponsiveiv objectattribute objectstatus objectmarker icontabbar icontabfilter text responsivepopover
" @summary This is a responsive Object Header with a Title, number, 6 Statuses/Attributes rendered in 3 columns in a Master/Detail mode (fullScreenOptimized = false).
CLASS z2ui5_cl_smpc_app_615 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the record the original binds with binding="{/ProductCollection/3}",
    " seeded at the model root and bound absolutely
    DATA productid     TYPE string.
    DATA name          TYPE string.
    DATA description   TYPE string.
    DATA suppliername  TYPE string.
    DATA category      TYPE string.
    DATA price         TYPE p LENGTH 8 DECIMALS 2.
    DATA currencycode  TYPE string.
    DATA productpicurl TYPE string.
    DATA weightmeasure TYPE string.
    DATA weightunit    TYPE string.
    DATA width         TYPE string.
    DATA depth         TYPE string.
    DATA height        TYPE string.
    DATA dimunit       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_615 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `myPopover` INTO TABLE temp1.
    INSERT `openBy` INTO TABLE temp1.
    INSERT `$event.oSource.sId` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `ObjectHeader`
            )->a( n = `id`                  v = `oh1`
            )->a( n = `responsive`          v = `true`
            )->a( n = `fullScreenOptimized` v = `false`
            )->a( n = `icon`                v = client->_bind( productpicurl )
            )->a( n = `iconAlt`             v = client->_bind( name )
            )->a( n = `intro`               v = client->_bind( description )
            )->a( n = `title`               v = client->_bind( name )
            )->a( n = `titleActive`         v = `true`
            " handleTitlePress loads Popover.fragment.xml and opens it by the
            " title's domRef - the same popover is declared in dependents and
            " opened anchored to the pressed control, roundtrip-free
            )->a( n = `titlePress`          v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                          t_arg = temp1 )
            )->a( n = `number`              v = |\{ parts:[\{path:'{ client->_bind_path( price ) }'\},| &&
                                                 |\{path:'{ client->_bind_path( currencycode ) }'\}],| &&
                                                 | type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
            )->a( n = `numberUnit`          v = client->_bind( currencycode )
            )->a( n = `showTitleSelector`   v = `true`
            " onPress - MessageBox.alert( 'Link was clicked!' )
            )->a( n = `titleSelectorPress`  v = client->_event( `TITLE_SELECTOR` )
            )->a( n = `numberState`         v = `Success`
            )->a( n = `backgroundDesign`    v = `Translucent`
            )->a( n = `class`               v = `sapUiResponsivePadding--header`

            )->tag( `ObjectAttribute`
                )->a( n = `title` v = `ProductID`
                )->a( n = `text`  v = client->_bind( productid )
            )->tag( `ObjectAttribute`
                )->a( n = `title` v = `Manufacturer`
                )->a( n = `text`  v = client->_bind( suppliername )
            )->tag( `ObjectAttribute`
                )->a( n = `title` v = `Category`
                )->a( n = `text`  v = client->_bind( category )
            )->tag( `ObjectAttribute`
                )->a( n = `title` v = `Weight per unit`
                )->a( n = `text`  v = |{ client->_bind( weightmeasure ) } { client->_bind( weightunit ) }|
            )->tag( `ObjectAttribute`
                )->a( n = `title` v = `Dimension per unit`
                )->a( n = `text`  v = |{ client->_bind( width ) } x { client->_bind( depth ) } x { client->_bind( height ) } { client->_bind( dimunit ) }|

            )->ele( `statuses`
                )->tag( `ObjectStatus`
                    )->a( n = `title` v = `Approval`
                    )->a( n = `text`  v = `Pending`
                    )->a( n = `state` v = `Warning`

            )->end(

            )->ele( `markers`
                )->tag( `ObjectMarker`
                    )->a( n = `type` v = `Flagged`
                )->tag( `ObjectMarker`
                    )->a( n = `type` v = `Favorite`

            )->end(

            )->ele( `headerContainer`
                )->ele( `IconTabBar`
                    )->a( n = `id`          v = `itb1`
                    )->a( n = `selectedKey` v = `key3`
                    )->a( n = `upperCase`   v = `true`
                    )->a( n = `class`       v = `sapUiResponsiveContentPadding`

                    )->ele( `items`
                        )->ele( `IconTabFilter`
                            )->a( n = `key`   v = `info`
                            )->a( n = `icon`  v = `sap-icon://hint`

                            )->tag( `Text`
                                )->a( n = `text` v = `Info content goes here ...`

                        )->end(

                        )->ele( `IconTabFilter`
                            )->a( n = `key`   v = `attachments`
                            )->a( n = `icon`  v = `sap-icon://attachment`
                            )->a( n = `count` v = `3`

                            )->tag( `Text`
                                )->a( n = `text` v = `Attachments go here ...`

                        )->end(

                        )->ele( `IconTabFilter`
                            )->a( n = `key`   v = `notes`
                            )->a( n = `icon`  v = `sap-icon://notes`
                            )->a( n = `count` v = `12`

                            )->tag( `Text`
                                )->a( n = `text` v = `Notes go here ...`

                        )->end(

                        )->ele( `IconTabFilter`
                            )->a( n = `key`   v = `people`
                            )->a( n = `icon`  v = `sap-icon://group`

                            )->tag( `Text`
                                )->a( n = `text` v = `People content goes here ...`

                        )->end(

                        )->ele( `IconTabFilter`
                            )->a( n = `key`   v = `info2`
                            )->a( n = `icon`  v = `sap-icon://hint`

                            )->tag( `Text`
                                )->a( n = `text` v = `Info content goes here ...`

                        )->end(

                        )->ele( `IconTabFilter`
                            )->a( n = `key`   v = `attachments2`
                            )->a( n = `icon`  v = `sap-icon://attachment`
                            )->a( n = `count` v = `3`

                            )->tag( `Text`
                                )->a( n = `text` v = `Attachments go here ...`

                        )->end(

                        )->ele( `IconTabFilter`
                            )->a( n = `key`   v = `notes2`
                            )->a( n = `icon`  v = `sap-icon://notes`
                            )->a( n = `count` v = `12`

                            )->tag( `Text`
                                )->a( n = `text` v = `Notes go here ...`

                        )->end(

                        )->ele( `IconTabFilter`
                            )->a( n = `key`   v = `people2`
                            )->a( n = `icon`  v = `sap-icon://group`

                            )->tag( `Text`
                                )->a( n = `text` v = `People content goes here ...`

                        )->end(
                    )->end(
                )->end(
            )->end(

            " the fragment the controller loads lazily and adds to the view's
            " dependents - declared inline here, opened by the title press above
            )->ele( `dependents`
                )->ele( `ResponsivePopover`
                    )->a( n = `id`    v = `myPopover`
                    )->a( n = `title` v = `About`
                    )->a( n = `class` v = `sapUiContentPadding`

                    )->tag( `Text`
                        )->a( n = `text` v = `... more content goes here` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `TITLE_SELECTOR`.
      " onPress - MessageBox.alert("Link was clicked!")
      client->message_box_display( text = `Link was clicked!` type = `alert` ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " /ProductCollection/3 of ui5/mock/products.json, the fields the view binds
    productid     = `HT-1003`.
    name          = `Notebook Basic 19`.
    description   = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    suppliername  = `Smartcards`.
    category      = `Laptops`.
    price         = '1650.00'.
    currencycode  = `EUR`.
    productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    weightmeasure = `4.2`.
    weightunit    = `KG`.
    width         = `32`.
    depth         = `21`.
    height        = `4`.
    dimunit       = `cm`.

  ENDMETHOD.

ENDCLASS.
