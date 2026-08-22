CLASS z2ui5_cl_smpc_app_529 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_prod,
             name         TYPE string,
             productid    TYPE string,
             category     TYPE string,
             suppliername TYPE string,
           END OF ty_prod.
    DATA productcollection TYPE STANDARD TABLE OF ty_prod WITH EMPTY KEY.

    TYPES: BEGIN OF ty_s_message,
             type    TYPE string,
             message TYPE string,
             target  TYPE string,
           END OF ty_s_message.
    DATA t_messages TYPE STANDARD TABLE OF ty_s_message WITH EMPTY KEY.

    " The original keeps the header data in nested paths on one JSON model
    " (title, titleSnappedContent/text, objectDescription/category|center|email|
    " status). abap2UI5 keeps one default model, so the nested paths are folded
    " to flat fields - the last segment is identical, which structural-diff matches
    DATA title      TYPE string    VALUE `Products List`.
    DATA text       TYPE string.
    DATA category   TYPE string    VALUE `Business`.
    DATA center     TYPE string    VALUE `PI Products Sofia`.
    DATA email      TYPE string    VALUE `office@piproucts.com`.
    DATA status     TYPE string    VALUE `Success`.
    DATA showfooter TYPE abap_bool VALUE abap_true.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_529 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " notMobile is Device.system.phone negated - the device model carries the
    " same fact to the client, so the two full-screen actions bind an expression
    DATA(not_mobile) = |\{= !$\{device>/system/phone\} \}|.

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`         v = `100%`
        )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
        )->a( n = `xmlns`          v = `sap.m`
        )->a( n = `xmlns:layout`   v = `sap.ui.layout`
        )->a( n = `xmlns:semantic` v = `sap.f.semantic`

        )->ele( n = `SemanticPage` ns = `semantic`
            )->a( n = `id`                          v = `mySemanticPage`
            )->a( n = `headerPinnable`              v = `true`
            )->a( n = `toggleHeaderOnTitleClick`    v = `true`
            )->a( n = `preserveHeaderStateOnScroll` v = `false`
            )->a( n = `titleAreaShrinkRatio`        v = `1:1.6:1.6`
            " showFooter is static true in the view and the ToggleFooter button
            " flips it in the controller - bound here so the toggle can reach it
            )->a( n = `showFooter`                  v = client->_bind( showfooter )

            )->ele( n = `titleHeading` ns = `semantic`
                )->tag( `Title`
                    )->a( n = `text` v = client->_bind( title )

            )->end(
            )->ele( n = `titleBreadcrumbs` ns = `semantic`
                )->ele( `Breadcrumbs`
                    )->tag( `Link`
                        )->a( n = `text` v = `Home`
                    )->tag( `Link`
                        )->a( n = `text` v = `Page 1`
                    )->tag( `Link`
                        )->a( n = `text` v = `Page 2`
                    )->tag( `Link`
                        )->a( n = `text` v = `Page 3`
                    )->tag( `Link`
                        )->a( n = `text` v = `Page 4`
                    )->tag( `Link`
                        )->a( n = `text` v = `Page 5`

                )->end(
            )->end(
            )->ele( n = `titleSnappedOnMobile` ns = `semantic`
                )->tag( `Title`
                    )->a( n = `text` v = client->_bind( text )

            )->end(
            )->ele( n = `titleContent` ns = `semantic`
                )->tag( `Image`
                    )->a( n = `src`     v = `https://sdk.openui5.org/test-resources/sap/f/images/KPI.png`
                    )->a( n = `tooltip` v = `This is just a placeholder, not a real KPI control.`
                    )->a( n = `height`  v = `2rem`
                    )->a( n = `width`   v = `3.5rem`

            )->end(
            )->ele( n = `titleSnappedContent` ns = `semantic`
                )->tag( `Text`
                    )->a( n = `text` v = client->_bind( text )

            )->end(

            )->ele( n = `headerContent` ns = `semantic`
                )->ele( n = `HorizontalLayout` ns = `layout`
                    )->a( n = `allowWrapping` v = `true`

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiMediumMarginEnd`

                        )->tag( `ObjectAttribute`
                            )->a( n = `title` v = `Functional Area`
                            )->a( n = `text`  v = client->_bind( category )
                        )->tag( `ObjectAttribute`
                            )->a( n = `title` v = `Cost Center`
                            )->a( n = `text`  v = client->_bind( center )
                        )->tag( `ObjectAttribute`
                            )->a( n = `title` v = `Email`
                            )->a( n = `text`  v = client->_bind( email )

                    )->end(
                    )->ele( n = `VerticalLayout` ns = `layout`

                        )->tag( `ObjectAttribute`
                            )->a( n = `title` v = `Availability`
                        )->tag( `ObjectStatus`
                            )->a( n = `text`  v = `In Stock`
                            )->a( n = `state` v = client->_bind( status )

                    )->end(
                )->end(
            )->end(

            )->ele( n = `content` ns = `semantic`
                )->ele( `Table`
                    )->a( n = `id`    v = `idProductsTable`
                    )->a( n = `inset` v = `false`
                    )->a( n = `items` v = client->_bind( productcollection )
                    )->a( n = `class` v = `sapFSemanticPageAlignContent`
                    )->a( n = `width` v = `auto`

                    )->ele( `columns`
                        )->ele( `Column`
                            )->tag( `Text`
                                )->a( n = `text` v = `Name`

                        )->end(
                        )->ele( `Column`
                            )->a( n = `minScreenWidth` v = `Tablet`
                            )->a( n = `demandPopin`    v = `true`
                            )->tag( `Text`
                                )->a( n = `text` v = `Category`

                        )->end(
                        )->ele( `Column`
                            )->a( n = `minScreenWidth` v = `Tablet`
                            )->a( n = `demandPopin`    v = `true`
                            )->tag( `Text`
                                )->a( n = `text` v = `SupplierName`

                        )->end(
                    )->end(

                    )->ele( `items`
                        )->ele( `ColumnListItem`
                            )->a( n = `vAlign` v = `Middle`

                            )->ele( `cells`
                                )->tag( `ObjectIdentifier`
                                    )->a( n = `title` v = `{NAME}`
                                    )->a( n = `text`  v = `{PRODUCTID}`
                                )->tag( `Text`
                                    )->a( n = `text` v = `{CATEGORY}`
                                )->tag( `Text`
                                    )->a( n = `text` v = `{SUPPLIERNAME}`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `titleMainAction` ns = `semantic`
                )->tag( n = `TitleMainAction` ns = `semantic`
                    )->a( n = `text` v = `Edit`

            )->end(
            )->ele( n = `addAction` ns = `semantic`
                )->tag( n = `AddAction` ns = `semantic`

            )->end(
            )->ele( n = `deleteAction` ns = `semantic`
                )->tag( n = `DeleteAction` ns = `semantic`

            )->end(
            )->ele( n = `copyAction` ns = `semantic`
                )->tag( n = `CopyAction` ns = `semantic`

            )->end(
            )->ele( n = `editAction` ns = `semantic`
                )->tag( n = `EditAction` ns = `semantic`

            )->end(
            )->ele( n = `favoriteAction` ns = `semantic`
                )->tag( n = `FavoriteAction` ns = `semantic`

            )->end(
            )->ele( n = `flagAction` ns = `semantic`
                )->tag( n = `FlagAction` ns = `semantic`

            )->end(
            )->ele( n = `closeAction` ns = `semantic`
                )->tag( n = `CloseAction` ns = `semantic`

            )->end(
            )->ele( n = `fullScreenAction` ns = `semantic`
                )->tag( n = `FullScreenAction` ns = `semantic`
                    )->a( n = `visible` v = not_mobile

            )->end(
            )->ele( n = `exitFullScreenAction` ns = `semantic`
                )->tag( n = `ExitFullScreenAction` ns = `semantic`
                    )->a( n = `visible` v = not_mobile

            )->end(

            )->ele( n = `titleCustomTextActions` ns = `semantic`
                )->tag( `Button`
                    )->a( n = `text`  v = `ToggleFooter`
                    )->a( n = `press` v = client->_event( `TOGGLE_FOOTER` )

            )->end(
            )->ele( n = `titleCustomIconActions` ns = `semantic`
                )->tag( `OverflowToolbarButton`
                    )->a( n = `icon` v = `sap-icon://cart`
                    )->a( n = `text` v = `cart`

            )->end(

            )->ele( n = `discussInJamAction` ns = `semantic`
                )->tag( n = `DiscussInJamAction` ns = `semantic`

            )->end(
            )->ele( n = `shareInJamAction` ns = `semantic`
                )->tag( n = `ShareInJamAction` ns = `semantic`

            )->end(
            )->ele( n = `printAction` ns = `semantic`
                )->tag( n = `PrintAction` ns = `semantic`

            )->end(
            )->ele( n = `sendEmailAction` ns = `semantic`
                )->tag( n = `SendEmailAction` ns = `semantic`

            )->end(
            )->ele( n = `sendMessageAction` ns = `semantic`
                )->tag( n = `SendMessageAction` ns = `semantic`

            )->end(

            )->ele( n = `customShareActions` ns = `semantic`
                )->tag( `Button`
                    )->a( n = `icon` v = `sap-icon://bed`
                    )->a( n = `text` v = `Bed`
                )->tag( `Button`
                    )->a( n = `icon` v = `sap-icon://flight`
                    )->a( n = `text` v = `Flight`

            )->end(

            )->ele( n = `positiveAction` ns = `semantic`
                )->tag( n = `PositiveAction` ns = `semantic`

            )->end(
            )->ele( n = `negativeAction` ns = `semantic`
                )->tag( n = `NegativeAction` ns = `semantic`

            )->end(

            )->ele( n = `messagesIndicator` ns = `semantic`
                )->ele( n = `MessagesIndicator` ns = `semantic`
                    )->a( n = `id`    v = `messagesIndicatorBtn`
                    " onMessagesButtonPress builds a MessagePopover over the message>
                    " model and opens it at the button - declared in dependents and
                    " opened roundtrip-free (app 066 idiom)
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                    t_arg = VALUE #( ( `messagePopover` )
                                                                                     ( `toggleBy` )
                                                                                     ( `$event.oSource.sId` ) ) )

                    )->ele( n = `dependents` ns = `semantic`
                        )->ele( `MessagePopover`
                            )->a( n = `id`    v = `messagePopover`
                            )->a( n = `items` v = `{ path: 'message>/' }`

                            )->ele( `items`
                                )->tag( `MessageItem`
                                    )->a( n = `type`        v = `{message>type}`
                                    )->a( n = `title`       v = `{message>message}`
                                    )->a( n = `description` v = `{message>description}`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `footerCustomActions` ns = `semantic`
                )->tag( `Button`
                    )->a( n = `text` v = `Save`
                )->tag( `Button`
                    )->a( n = `text` v = `Cancel` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `TOGGLE_FOOTER`.
      " showFooter: setShowFooter( !getShowFooter() )
      showfooter = xsdbool( showfooter = abap_false ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " titleSnappedContent/text - the braces are part of the DATA the model
    " carries, not a binding, so the string template escapes them
    text = |Filtered by \{Name, Price, Category\}|.

    " the single Error message the controller registers on init
    t_messages = VALUE #( ( type    = `Error`
                            message = `Something wrong happened`
                            target  = `` ) ).

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
      ( name = `High End Laptop 2b` productid = `OP-38800016` category = `Laptop` suppliername = `Titanium` ) ).

  ENDMETHOD.

ENDCLASS.
