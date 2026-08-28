" @keywords objectpagelayout object layout sap.uxap objectpageblockviewtypes objectpageaccessiblelandmarkinfo objectpageheader objectpageheaderactionbutton breadcrumbs link verticallayout horizontallayout
" @summary ObjectPage sample with blocks that use different view types
CLASS z2ui5_cl_smpc_app_589 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA show_footer TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_589 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 401/416 precedent): the four sections hold the
    " SAME goals block authored four ways - a typed view (GoalsBlockView.js), a
    " JSON view, an HTML view and an XML view - which is the whole point of the
    " sample. abap2UI5 emits one XML view, so each block's CONTENT is inlined and
    " the four view TYPES collapse to one (see sidecar)
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:forms`  v = `sap.ui.layout.form`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                       v = `ObjectPageLayout`
            )->a( n = `enableLazyLoading`        v = `false`
            )->a( n = `showTitleInHeaderContent` v = `true`
            )->a( n = `showEditHeaderButton`     v = `true`
            )->a( n = `upperCaseAnchorBar`       v = `false`
            " the third action button's toggleFooter does setShowFooter( !getShowFooter( ) );
            " a bindable property beats a frontend action, so it is bound two-way
            )->a( n = `showFooter`               v = client->_bind( show_footer )

            )->ele( `landmarkInfo`
                )->tag( `ObjectPageAccessibleLandmarkInfo`
                    )->a( n = `rootRole`           v = `Region`
                    )->a( n = `rootLabel`          v = `Order Information`
                    )->a( n = `contentRole`        v = `Main`
                    )->a( n = `contentLabel`       v = `Order Details`
                    )->a( n = `headerRole`         v = `Region`
                    )->a( n = `headerLabel`        v = `Order Header`
                    )->a( n = `footerRole`         v = `Region`
                    )->a( n = `footerLabel`        v = `Order Footer`
                    )->a( n = `navigationRole`     v = `Navigation`
                    )->a( n = `navigationLabel`    v = `Order navigation`
                    )->a( n = `headerContentLabel` v = `Header Content Label`
            )->end(

            )->ele( `headerTitle`
                )->ele( `ObjectPageHeader`
                    )->a( n = `objectImageURI`                v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`
                    )->a( n = `objectTitle`                   v = `Denise Smith`
                    )->a( n = `objectImageShape`              v = `Circle`
                    )->a( n = `objectImageAlt`                v = `Denise Smith`
                    )->a( n = `objectSubtitle`                v = `Senior UI Developer`
                    )->a( n = `isObjectTitleAlwaysVisible`    v = `false`
                    )->a( n = `isObjectSubtitleAlwaysVisible` v = `false`

                    )->ele( `actions`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon` v = `sap-icon://pull-down`
                            )->a( n = `text` v = `show section`
                            )->a( n = `type` v = `Emphasized`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon` v = `sap-icon://show`
                            )->a( n = `text` v = `show state`
                            )->a( n = `type` v = `Emphasized`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `text`     v = `Toggle Footer`
                            )->a( n = `hideIcon` v = `true`
                            )->a( n = `hideText` v = `false`
                            )->a( n = `type`     v = `Emphasized`
                            )->a( n = `press`    v = client->_event( `TOGGLE_FOOTER` )
                    )->end(

                    )->ele( `breadcrumbs`
                        )->ele( n = `Breadcrumbs` ns = `m`
                            )->a( n = `id`                  v = `breadcrumbsId`
                            )->a( n = `currentLocationText` v = `Object Page Example`

                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Page 1 a very long link`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Page 1 a very long link clicked` ) ) )
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Page 2 long link`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Page 2 long link clicked` ) ) )
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `headerContent`
                )->ele( n = `VerticalLayout` ns = `layout`
                    )->tag( n = `Link` ns = `m`
                        )->a( n = `text` v = `+33 6 4512 5158`
                    )->tag( n = `Link` ns = `m`
                        )->a( n = `text` v = `DeniseSmith@sap.com`
                )->end(

                )->ele( n = `HorizontalLayout` ns = `layout`
                    )->tag( n = `Image` ns = `m`
                        )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/uxap/images/linkedin.png`
                    )->tag( n = `Image` ns = `m`
                        )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/uxap/images/Twitter.png`
                )->end(

                )->ele( n = `VerticalLayout` ns = `layout`
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `Hello! I am Tim and I use UxAP`

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `height` v = `63px`
                        )->tag( n = `Label` ns = `m`
                            )->a( n = `text` v = `Achieved goals`
                        )->tag( n = `ProgressIndicator` ns = `m`
                            )->a( n = `percentValue` v = `30`
                            )->a( n = `displayValue` v = `30%`
                            )->a( n = `showValue`    v = `true`
                            )->a( n = `state`        v = `None`
                    )->end(
                )->end(

                )->ele( n = `VerticalLayout` ns = `layout`
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `San Jose, USA`
                )->end(
            )->end(

            )->ele( `sections`

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Typed View`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " goals:GoalsBlockJS -> GoalsBlockView.js, the typed
                                " view: the same three goals plus a Button, and the
                                " sample's own 'accross' typo in the first label
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `width`    v = `100%`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->a( n = `editable` v = `false`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Evangelize the UI framework accross the company`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `4 days overdue Cascaded`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = ` `
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Get trained in development management direction`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Due Nov 21`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = ` `
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Mentor junior developers`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Due Dec 31 Cascaded`
                                    )->tag( n = `Button` ns = `m`
                                        )->a( n = `text`  v = `Hello from a typed view`
                                        )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                        t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Button was presed` ) ) )
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `JSON View`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " goals:GoalsBlockJSON -> GoalsBlock.view.json: an
                                " Image and a Button, both with their own ids
                                )->tag( n = `Image` ns = `m`
                                    )->a( n = `id`  v = `MyImage`
                                    )->a( n = `src` v = `https://sdk.openui5.org/resources/sap/ui/documentation/sdk/images/logo_ui5.png`
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `MyButton`
                                    )->a( n = `text`  v = `Hello from JSON view`
                                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Button was presed` ) ) )
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `HTML View`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " goals:GoalsBlockHTML -> GoalsBlock.view.html: a bare
                                " <div> sentence and a Panel with one Button; the div
                                " becomes an m:Text (see sidecar)
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `This is the content of an HTML view`

                                )->ele( n = `Panel` ns = `m`
                                    )->a( n = `id` v = `myPanel`
                                    )->tag( n = `Button` ns = `m`
                                        )->a( n = `id`    v = `Button1`
                                        )->a( n = `text`  v = `Hello from HTML view`
                                        )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                        t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Button was presed` ) ) )
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `XML View`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " goals:GoalsBlock -> GoalsBlock.view.xml, the same
                                " three goals as a plain XML view
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Evangelize the UI framework across the company`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `4 days overdue Cascaded`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Get trained in development management direction`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Due Nov 21`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Mentor junior developers`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Due Dec 31 Cascaded`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `footer`
                )->ele( n = `OverflowToolbar` ns = `m`
                    )->tag( n = `ToolbarSpacer` ns = `m`
                    )->tag( n = `Button` ns = `m`
                        )->a( n = `type` v = `Accept`
                        )->a( n = `text` v = `Accept`
                    )->tag( n = `Button` ns = `m`
                        )->a( n = `type` v = `Reject`
                        )->a( n = `text` v = `Reject` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `TOGGLE_FOOTER`.
      " toggleFooter: setShowFooter( !getShowFooter( ) )
      show_footer = xsdbool( show_footer = abap_false ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
