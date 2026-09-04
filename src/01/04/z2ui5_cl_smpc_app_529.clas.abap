" @keywords semanticpage semantic sap.f.semantic semanticpagefreestyle title breadcrumbs link image text horizontallayout verticallayout objectattribute
" @summary This sample demonstrates a SemanticPage with all semantic-specific actions both in the title and in the footer areas.
CLASS z2ui5_cl_smpc_app_529 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_prod,
             name         TYPE string,
             productid    TYPE string,
             category     TYPE string,
             suppliername TYPE string,
           END OF ty_prod.
    DATA productcollection TYPE STANDARD TABLE OF ty_prod WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_s_message,
             type    TYPE string,
             message TYPE string,
             target  TYPE string,
           END OF ty_s_message.
    DATA t_messages TYPE STANDARD TABLE OF ty_s_message WITH DEFAULT KEY.

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
    DATA not_mobile TYPE string.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " notMobile is Device.system.phone negated - the device model carries the
    " same fact to the client, so the two full-screen actions bind an expression
    
    not_mobile = |\{= !$\{device>/system/phone\} \}|.

    
    CLEAR temp1.
    INSERT `messagePopover` INTO TABLE temp1.
    INSERT `toggleBy` INTO TABLE temp1.
    INSERT `$event.oSource.sId` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`         v = `100%`
        )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
        )->a( n = `xmlns`          v = `sap.m`
        )->a( n = `xmlns:layout`   v = `sap.ui.layout`
        )->a( n = `xmlns:semantic` v = `sap.f.semantic`
        )->a( n = `xmlns:z2ui5`    v = `z2ui5.cc`

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

            " onInit: Messaging.addMessages( new Message({ message: 'Something wrong
            " happened', type: Error }) ) - the app-authored message goes through the
            " z2ui5.cc.MessageManager companion control (app 065/166 idiom). Without
            " it nothing ever feeds the message> model, and SemanticConfiguration
            " binds MessagesIndicator.visible to a formatter over message>/ - so the
            " indicator does not render at all and its MessagePopover cannot be
            " opened. It renders nothing itself, so it lives in dependents
            )->ele( n = `dependents` ns = `semantic`
                )->tag( n = `MessageManager` ns = `z2ui5`
                    )->a( n = `items` v = client->_bind( t_messages )

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
                                                                    t_arg = temp1 )

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
      DATA temp1 TYPE xsdboolean.

    IF client->get_event( ) = `TOGGLE_FOOTER`.
      " showFooter: setShowFooter( !getShowFooter() )
      
      temp1 = boolc( showfooter = abap_false ).
      showfooter = temp1.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.
    DATA temp3 LIKE t_messages.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 LIKE productcollection.
    DATA temp6 LIKE LINE OF temp5.

    " titleSnappedContent/text - the braces are part of the DATA the model
    " carries, not a binding, so the string template escapes them
    text = |Filtered by \{Name, Price, Category\}|.

    " the single Error message the controller registers on init
    
    CLEAR temp3.
    
    temp4-type = `Error`.
    temp4-message = `Something wrong happened`.
    temp4-target = ``.
    INSERT temp4 INTO TABLE temp3.
    t_messages = temp3.

    
    CLEAR temp5.
    
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239102`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239103`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239104`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239105`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239106`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239107`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239108`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239109`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239110`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239111`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239112`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239113`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239114`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239115`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239116`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239117`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239118`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239119`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239120`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239121`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239122`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239123`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239124`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239125`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Projector 4713`.
    temp6-productid = `1239126`.
    temp6-category = `Projector`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.1`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.2`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.3`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.4`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.5`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.6`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.7`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.8`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.9`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.10`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.11`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.12`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.13`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.14`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.15`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.16`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.17`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.18`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.19`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.20`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.21`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.22`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.23`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.24`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.25`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `K47322.26`.
    temp6-category = `Graphics Card`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T1`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T2`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T3`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T4`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T5`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T6`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T7`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T8`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T9`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T10`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T11`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T12`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T13`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T14`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T15`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T16`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T17`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T18`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T19`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T20`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T21`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T22`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T23`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T24`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T25`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Webcam`.
    temp6-productid = `22134T26`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239823`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239824`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239825`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239826`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239827`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239828`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239829`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239830`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239831`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239832`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239833`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239834`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239835`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239836`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239837`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239838`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239839`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Monitor Locking Cable`.
    temp6-productid = `P1239840`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laptop Case`.
    temp6-productid = `214-121-828`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laptop Case`.
    temp6-productid = `214-121-829`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laptop Case`.
    temp6-productid = `214-121-830`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laptop Case`.
    temp6-productid = `214-121-831`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laptop Case`.
    temp6-productid = `214-121-832`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laptop Case`.
    temp6-productid = `214-121-833`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laptop Case`.
    temp6-productid = `214-121-834`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laptop Case`.
    temp6-productid = `214-121-835`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laptop Case`.
    temp6-productid = `214-121-836`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laptop Case`.
    temp6-productid = `214-121-837`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laptop Case`.
    temp6-productid = `214-121-838`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laptop Case`.
    temp6-productid = `214-121-839`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laptop Case`.
    temp6-productid = `214-121-840`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laptop Case`.
    temp6-productid = `214-121-841`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laptop Case`.
    temp6-productid = `214-121-842`.
    temp6-category = `Accessory`.
    temp6-suppliername = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `High End Laptop 2b`.
    temp6-productid = `OP-38800002`.
    temp6-category = `Laptop`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `High End Laptop 2b`.
    temp6-productid = `OP-38800003`.
    temp6-category = `Laptop`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `High End Laptop 2b`.
    temp6-productid = `OP-38800004`.
    temp6-category = `Laptop`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `High End Laptop 2b`.
    temp6-productid = `OP-38800005`.
    temp6-category = `Laptop`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `High End Laptop 2b`.
    temp6-productid = `OP-38800006`.
    temp6-category = `Laptop`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `High End Laptop 2b`.
    temp6-productid = `OP-38800007`.
    temp6-category = `Laptop`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `High End Laptop 2b`.
    temp6-productid = `OP-38800008`.
    temp6-category = `Laptop`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `High End Laptop 2b`.
    temp6-productid = `OP-38800009`.
    temp6-category = `Laptop`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `High End Laptop 2b`.
    temp6-productid = `OP-38800010`.
    temp6-category = `Laptop`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `High End Laptop 2b`.
    temp6-productid = `OP-38800011`.
    temp6-category = `Laptop`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `High End Laptop 2b`.
    temp6-productid = `OP-38800012`.
    temp6-category = `Laptop`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `High End Laptop 2b`.
    temp6-productid = `OP-38800013`.
    temp6-category = `Laptop`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `High End Laptop 2b`.
    temp6-productid = `OP-38800014`.
    temp6-category = `Laptop`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `High End Laptop 2b`.
    temp6-productid = `OP-38800015`.
    temp6-category = `Laptop`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `High End Laptop 2b`.
    temp6-productid = `OP-38800016`.
    temp6-category = `Laptop`.
    temp6-suppliername = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    productcollection = temp5.

  ENDMETHOD.

ENDCLASS.
