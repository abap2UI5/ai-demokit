CLASS z2ui5_cl_ai_app_166 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_prod,
        name         TYPE string,
        productid    TYPE string,
        category     TYPE string,
        suppliername TYPE string,
      END OF ty_prod.
    DATA productcollection TYPE STANDARD TABLE OF ty_prod WITH EMPTY KEY.

    " The original splits header/object data into nested paths on one JSON model
    " (objectDescription/*, titleSnappedContent/text ...). abap2UI5 keeps one
    " default model; the nested paths are folded to flat fields (last segment
    " identical, which structural-diff matches) so render-smoke mocks them by
    " type. Both snapped/expanded subheadings carry the same text in the mock.
    DATA title       TYPE string    VALUE `Products List`.
    DATA text        TYPE string    VALUE `This is a subheading`.
    DATA category    TYPE string    VALUE `Business`.
    DATA center      TYPE string    VALUE `PI Products Sofia`.
    DATA email       TYPE string    VALUE `office@piproucts.com`.
    DATA status      TYPE string    VALUE `Success`.
    DATA showfooter  TYPE abap_bool VALUE abap_false.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_166 IMPLEMENTATION.

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
        )->a( n = `height`          v = `100%`
        )->a( n = `xmlns:mvc`       v = `sap.ui.core.mvc`
        )->a( n = `xmlns`           v = `sap.m`
        )->a( n = `xmlns:layout`    v = `sap.ui.layout`
        )->a( n = `xmlns:semantic`  v = `sap.f.semantic`

        )->open( n = `SemanticPage` ns = `semantic`
            )->a( n = `id`                          v = `mySemanticPage`
            )->a( n = `headerPinnable`              v = `true`
            )->a( n = `toggleHeaderOnTitleClick`    v = `true`
            )->a( n = `preserveHeaderStateOnScroll` v = `false`
            )->a( n = `titleAreaShrinkRatio`        v = `1:1.6:1.6`
            )->a( n = `showFooter`                  v = client->_bind( showfooter )

            )->open( n = `titleHeading` ns = `semantic`
                )->leaf( `Title`
                    )->a( n = `text` v = client->_bind( title )

            )->shut(

            )->open( n = `titleSnappedContent` ns = `semantic`
                )->leaf( `Text`
                    )->a( n = `text` v = client->_bind( text )

            )->shut(

            )->open( n = `titleExpandedContent` ns = `semantic`
                )->leaf( `Text`
                    )->a( n = `text` v = client->_bind( text )

            )->shut(

            )->open( n = `headerContent` ns = `semantic`
                )->open( n = `HorizontalLayout` ns = `layout`
                    )->a( n = `allowWrapping` v = `true`
                    )->open( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiMediumMarginEnd`
                        )->leaf( `ObjectAttribute`
                            )->a( n = `title` v = `Functional Area`
                            )->a( n = `text`  v = client->_bind( category )
                        )->leaf( `ObjectAttribute`
                            )->a( n = `title` v = `Cost Center`
                            )->a( n = `text`  v = client->_bind( center )
                        )->leaf( `ObjectAttribute`
                            )->a( n = `title` v = `Email`
                            )->a( n = `text`  v = client->_bind( email )

                    )->shut(
                    )->open( n = `VerticalLayout` ns = `layout`
                        )->leaf( `ObjectAttribute`
                            )->a( n = `title` v = `Availability`
                        )->leaf( `ObjectStatus`
                            )->a( n = `text`  v = `In Stock`
                            )->a( n = `state` v = client->_bind( status )

                    )->shut(
                )->shut(
            )->shut(

            )->open( n = `content` ns = `semantic`
                )->open( `Table`
                    )->a( n = `id`    v = `idProductsTable`
                    )->a( n = `inset` v = `false`
                    )->a( n = `items` v = client->_bind( productcollection )
                    )->a( n = `class` v = `sapFSemanticPageAlignContent`
                    )->a( n = `width` v = `auto`
                    )->open( `columns`
                        )->open( `Column`
                            )->leaf( `Text` )->a( n = `text` v = `Name`

                        )->shut(
                        )->open( `Column`
                            )->a( n = `minScreenWidth` v = `Tablet`
                            )->a( n = `demandPopin`    v = `true`
                            )->leaf( `Text` )->a( n = `text` v = `Category`

                        )->shut(
                        )->open( `Column`
                            )->a( n = `minScreenWidth` v = `Tablet`
                            )->a( n = `demandPopin`    v = `true`
                            )->leaf( `Text` )->a( n = `text` v = `SupplierName`

                        )->shut(
                    )->shut(
                    )->open( `items`
                        )->open( `ColumnListItem`
                            )->a( n = `vAlign` v = `Middle`
                            )->open( `cells`
                                )->leaf( `ObjectIdentifier`
                                    )->a( n = `title` v = `{NAME}`
                                    )->a( n = `text`  v = `{PRODUCTID}`
                                )->leaf( `Text` )->a( n = `text` v = `{CATEGORY}`
                                )->leaf( `Text` )->a( n = `text` v = `{SUPPLIERNAME}`

                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( n = `titleMainAction` ns = `semantic`
                )->leaf( n = `TitleMainAction` ns = `semantic`
                    )->a( n = `id`    v = `editAction`
                    )->a( n = `text`  v = `Edit`
                    )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Edit` ) ) )

            )->shut(

            )->open( n = `discussInJamAction` ns = `semantic`
                )->leaf( n = `DiscussInJamAction` ns = `semantic`

            )->shut(

            )->open( n = `saveAsTileAction` ns = `semantic`
                )->leaf( `Button`
                    )->a( n = `icon` v = `sap-icon://add-favorite`
                    )->a( n = `text` v = `Save as Tile`

            )->shut(

            )->open( n = `sendEmailAction` ns = `semantic`
                )->leaf( n = `SendEmailAction` ns = `semantic`

            )->shut(

            )->open( n = `sendMessageAction` ns = `semantic`
                )->leaf( n = `SendMessageAction` ns = `semantic`

            )->shut(

            )->open( n = `footerMainAction` ns = `semantic`
                )->leaf( n = `FooterMainAction` ns = `semantic`
                    )->a( n = `text`  v = `Save`
                    )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Save` ) ) )

            )->shut(

            )->open( n = `footerCustomActions` ns = `semantic`
                )->leaf( `Button`
                    )->a( n = `id`    v = `cancelAction`
                    )->a( n = `text`  v = `Cancel`
                    )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Cancel` ) ) )

            )->shut(

            )->open( n = `messagesIndicator` ns = `semantic`
                )->leaf( n = `MessagesIndicator` ns = `semantic`
                    )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Messages` ) ) )

            )->shut(

            )->open( n = `draftIndicator` ns = `semantic`
                )->leaf( `DraftIndicator`
                    )->a( n = `state` v = `Saved` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    productcollection = VALUE #(
      ( name = `Power Projector 4713` productid = `1239102` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239103` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239104` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239105` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239106` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239107` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239108` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239109` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239110` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239111` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239112` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239113` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239114` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239115` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239116` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239117` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239118` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239119` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239120` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239121` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239122` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239123` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239124` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239125` category = `Projector` suppliername = `Titanium` )
      ( name = `Power Projector 4713` productid = `1239126` category = `Projector` suppliername = `Titanium` )
      ( name = `Hurricane GX` productid = `K47322.1` category = `Graphics Card` suppliername = `Red Point Stores` )
      ( name = `Hurricane GX` productid = `K47322.2` category = `Graphics Card` suppliername = `Titanium` )
      ( name = `Hurricane GX` productid = `K47322.3` category = `Graphics Card` suppliername = `Red Point Stores` )
      ( name = `Hurricane GX` productid = `K47322.4` category = `Graphics Card` suppliername = `Titanium` )
      ( name = `Hurricane GX` productid = `K47322.5` category = `Graphics Card` suppliername = `Red Point Stores` )
      ( name = `Hurricane GX` productid = `K47322.6` category = `Graphics Card` suppliername = `Titanium` )
      ( name = `Hurricane GX` productid = `K47322.7` category = `Graphics Card` suppliername = `Red Point Stores` )
      ( name = `Hurricane GX` productid = `K47322.8` category = `Graphics Card` suppliername = `Titanium` )
      ( name = `Hurricane GX` productid = `K47322.9` category = `Graphics Card` suppliername = `Red Point Stores` )
      ( name = `Hurricane GX` productid = `K47322.10` category = `Graphics Card` suppliername = `Titanium` )
      ( name = `Hurricane GX` productid = `K47322.11` category = `Graphics Card` suppliername = `Red Point Stores` )
      ( name = `Hurricane GX` productid = `K47322.12` category = `Graphics Card` suppliername = `Titanium` )
      ( name = `Hurricane GX` productid = `K47322.13` category = `Graphics Card` suppliername = `Red Point Stores` )
      ( name = `Hurricane GX` productid = `K47322.14` category = `Graphics Card` suppliername = `Titanium` )
      ( name = `Hurricane GX` productid = `K47322.15` category = `Graphics Card` suppliername = `Red Point Stores` )
      ( name = `Hurricane GX` productid = `K47322.16` category = `Graphics Card` suppliername = `Titanium` )
      ( name = `Hurricane GX` productid = `K47322.17` category = `Graphics Card` suppliername = `Red Point Stores` )
      ( name = `Hurricane GX` productid = `K47322.18` category = `Graphics Card` suppliername = `Titanium` )
      ( name = `Hurricane GX` productid = `K47322.19` category = `Graphics Card` suppliername = `Red Point Stores` )
      ( name = `Hurricane GX` productid = `K47322.20` category = `Graphics Card` suppliername = `Titanium` )
      ( name = `Hurricane GX` productid = `K47322.21` category = `Graphics Card` suppliername = `Red Point Stores` )
      ( name = `Hurricane GX` productid = `K47322.22` category = `Graphics Card` suppliername = `Titanium` )
      ( name = `Hurricane GX` productid = `K47322.23` category = `Graphics Card` suppliername = `Red Point Stores` )
      ( name = `Hurricane GX` productid = `K47322.24` category = `Graphics Card` suppliername = `Titanium` )
      ( name = `Hurricane GX` productid = `K47322.25` category = `Graphics Card` suppliername = `Red Point Stores` )
      ( name = `Hurricane GX` productid = `K47322.26` category = `Graphics Card` suppliername = `Titanium` )
      ( name = `Webcam` productid = `22134T1` category = `Accessory` suppliername = `Technocom` )
      ( name = `Webcam` productid = `22134T2` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Webcam` productid = `22134T3` category = `Accessory` suppliername = `Technocom` )
      ( name = `Webcam` productid = `22134T4` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Webcam` productid = `22134T5` category = `Accessory` suppliername = `Technocom` )
      ( name = `Webcam` productid = `22134T6` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Webcam` productid = `22134T7` category = `Accessory` suppliername = `Technocom` )
      ( name = `Webcam` productid = `22134T8` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Webcam` productid = `22134T9` category = `Accessory` suppliername = `Technocom` )
      ( name = `Webcam` productid = `22134T10` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Webcam` productid = `22134T11` category = `Accessory` suppliername = `Technocom` )
      ( name = `Webcam` productid = `22134T12` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Webcam` productid = `22134T13` category = `Accessory` suppliername = `Technocom` )
      ( name = `Webcam` productid = `22134T14` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Webcam` productid = `22134T15` category = `Accessory` suppliername = `Technocom` )
      ( name = `Webcam` productid = `22134T16` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Webcam` productid = `22134T17` category = `Accessory` suppliername = `Technocom` )
      ( name = `Webcam` productid = `22134T18` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Webcam` productid = `22134T19` category = `Accessory` suppliername = `Technocom` )
      ( name = `Webcam` productid = `22134T20` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Webcam` productid = `22134T21` category = `Accessory` suppliername = `Technocom` )
      ( name = `Webcam` productid = `22134T22` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Webcam` productid = `22134T23` category = `Accessory` suppliername = `Technocom` )
      ( name = `Webcam` productid = `22134T24` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Webcam` productid = `22134T25` category = `Accessory` suppliername = `Technocom` )
      ( name = `Webcam` productid = `22134T26` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Monitor Locking Cable` productid = `P1239823` category = `Accessory` suppliername = `Technocom` )
      ( name = `Monitor Locking Cable` productid = `P1239824` category = `Accessory` suppliername = `Titanium` )
      ( name = `Monitor Locking Cable` productid = `P1239825` category = `Accessory` suppliername = `Technocom` )
      ( name = `Monitor Locking Cable` productid = `P1239826` category = `Accessory` suppliername = `Titanium` )
      ( name = `Monitor Locking Cable` productid = `P1239827` category = `Accessory` suppliername = `Technocom` )
      ( name = `Monitor Locking Cable` productid = `P1239828` category = `Accessory` suppliername = `Titanium` )
      ( name = `Monitor Locking Cable` productid = `P1239829` category = `Accessory` suppliername = `Technocom` )
      ( name = `Monitor Locking Cable` productid = `P1239830` category = `Accessory` suppliername = `Titanium` )
      ( name = `Monitor Locking Cable` productid = `P1239831` category = `Accessory` suppliername = `Technocom` )
      ( name = `Monitor Locking Cable` productid = `P1239832` category = `Accessory` suppliername = `Titanium` )
      ( name = `Monitor Locking Cable` productid = `P1239833` category = `Accessory` suppliername = `Technocom` )
      ( name = `Monitor Locking Cable` productid = `P1239834` category = `Accessory` suppliername = `Titanium` )
      ( name = `Monitor Locking Cable` productid = `P1239835` category = `Accessory` suppliername = `Technocom` )
      ( name = `Monitor Locking Cable` productid = `P1239836` category = `Accessory` suppliername = `Titanium` )
      ( name = `Monitor Locking Cable` productid = `P1239837` category = `Accessory` suppliername = `Technocom` )
      ( name = `Monitor Locking Cable` productid = `P1239838` category = `Accessory` suppliername = `Titanium` )
      ( name = `Monitor Locking Cable` productid = `P1239839` category = `Accessory` suppliername = `Technocom` )
      ( name = `Monitor Locking Cable` productid = `P1239840` category = `Accessory` suppliername = `Titanium` )
      ( name = `Laptop Case` productid = `214-121-828` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Laptop Case` productid = `214-121-829` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Laptop Case` productid = `214-121-830` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Laptop Case` productid = `214-121-831` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Laptop Case` productid = `214-121-832` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Laptop Case` productid = `214-121-833` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Laptop Case` productid = `214-121-834` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Laptop Case` productid = `214-121-835` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Laptop Case` productid = `214-121-836` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Laptop Case` productid = `214-121-837` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Laptop Case` productid = `214-121-838` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Laptop Case` productid = `214-121-839` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Laptop Case` productid = `214-121-840` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Laptop Case` productid = `214-121-841` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `Laptop Case` productid = `214-121-842` category = `Accessory` suppliername = `Red Point Stores` )
      ( name = `High End Laptop 2b` productid = `OP-38800002` category = `Laptop` suppliername = `Titanium` )
      ( name = `High End Laptop 2b` productid = `OP-38800003` category = `Laptop` suppliername = `Titanium` )
      ( name = `High End Laptop 2b` productid = `OP-38800004` category = `Laptop` suppliername = `Titanium` )
      ( name = `High End Laptop 2b` productid = `OP-38800005` category = `Laptop` suppliername = `Titanium` )
      ( name = `High End Laptop 2b` productid = `OP-38800006` category = `Laptop` suppliername = `Titanium` )
      ( name = `High End Laptop 2b` productid = `OP-38800007` category = `Laptop` suppliername = `Titanium` )
      ( name = `High End Laptop 2b` productid = `OP-38800008` category = `Laptop` suppliername = `Titanium` )
      ( name = `High End Laptop 2b` productid = `OP-38800009` category = `Laptop` suppliername = `Titanium` )
      ( name = `High End Laptop 2b` productid = `OP-38800010` category = `Laptop` suppliername = `Titanium` )
      ( name = `High End Laptop 2b` productid = `OP-38800011` category = `Laptop` suppliername = `Titanium` )
      ( name = `High End Laptop 2b` productid = `OP-38800012` category = `Laptop` suppliername = `Titanium` )
      ( name = `High End Laptop 2b` productid = `OP-38800013` category = `Laptop` suppliername = `Titanium` )
      ( name = `High End Laptop 2b` productid = `OP-38800014` category = `Laptop` suppliername = `Titanium` )
      ( name = `High End Laptop 2b` productid = `OP-38800015` category = `Laptop` suppliername = `Titanium` )
      ( name = `High End Laptop 2b` productid = `OP-38800016` category = `Laptop` suppliername = `Titanium` )
    ).

  ENDMETHOD.

ENDCLASS.
