CLASS z2ui5_cl_smpc_app_416 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA text TYPE string.
    DATA icon TYPE string.
    DATA formatted_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_416 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 217/401/402 precedent, CAPABILITIES 'Custom
    " BlockBase blocks in a sap.uxap.ObjectPageLayout'): the original blocks
    " and moreBlocks aggregations hold custom BlockBase controls from the
    " sample's SharedBlocks JS - a BlockBase is only a lazy-loading wrapper
    " around a view, so each block's content (a form:SimpleForm) is inlined
    " directly here (see sidecar).
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `height`       v = `100%`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `isChildPage`        v = `true`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->ele( `headerTitle`
                " objectImageURI points at the sdk.openui5.org host per the
                " offline asset-URL rule (see sidecar)
                )->ele( `ObjectPageHeader`
                    )->a( n = `id`               v = `headerForTest`
                    )->a( n = `objectTitle`      v = `Denise Smith`
                    )->a( n = `objectSubtitle`   v = `Example of a child page in ObjectPage terms`
                    )->a( n = `objectImageShape` v = `Circle`
                    )->a( n = `objectImageURI`   v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`

                    )->ele( `actions`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://action`
                            )->a( n = `text`    v = `action`
                            )->a( n = `tooltip` v = `action`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://action-settings`
                            )->a( n = `text`    v = `settings`
                            )->a( n = `tooltip` v = `action-settings`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://edit`
                            )->a( n = `text`    v = `edit`
                            )->a( n = `tooltip` v = `edit`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://save`
                            )->a( n = `text`    v = `save`
                            )->a( n = `visible` v = `false`
                            )->a( n = `tooltip` v = `save`
                        " the controller's named 'buttons' JSONModel is folded onto the
                        " default model root: buttons>/text and buttons>/icon become
                        " bound root fields; the sixth button's .onFormat formatter
                        " result is computed in model_init (see sidecar)
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://refresh`
                            )->a( n = `text`    v = client->_bind( text )
                            )->a( n = `tooltip` v = `refresh`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = client->_bind( icon )
                            )->a( n = `text`    v = client->_bind( formatted_text )
                            )->a( n = `tooltip` v = `chain-link`

                    )->end(

                    )->ele( `breadcrumbs`
                        )->ele( n = `Breadcrumbs` ns = `m`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Page 2 long link`
                                )->a( n = `press` v = client->_event( `LINK2_PRESS` )

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `headerContent`
                )->ele( n = `VerticalLayout` ns = `layout`
                    )->tag( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `User ID`
                        )->a( n = `text`  v = `12345678`
                    )->tag( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Functional Area`
                        )->a( n = `text`  v = `Developement`
                    )->tag( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Cost Center`
                        )->a( n = `text`  v = `PI DFA GD Programs and Product`
                    )->tag( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Email`
                        )->a( n = `text`  v = `email@address.com`

                )->end(

                )->tag( n = `Text` ns = `m`
                    )->a( n = `width` v = `200px`
                    )->a( n = `text`  v = `Hi, I'm Denise. I am passionate about what I do and I'll go the extra mile to make the customer win.`
                )->tag( n = `ObjectStatus` ns = `m`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Error`
                )->tag( n = `ObjectStatus` ns = `m`
                    )->a( n = `title` v = `Label`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Warning`

            )->end(

            )->ele( `sections`
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `2014 Goals Plan`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = ` `
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `form`
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

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Personal`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Connect`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `form`
                                    )->a( n = `layout` v = `ColumnLayout`
                                    )->a( n = `width`  v = `100%`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Phone Numbers`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Home`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `+ 1 415-321-1234`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Office phone`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `+ 1 415-321-5555`

                                )->end(

                                )->ele( n = `SimpleForm` ns = `form`
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `labelSpanL`       v = `4`
                                    )->a( n = `labelSpanM`       v = `4`
                                    )->a( n = `labelSpanS`       v = `4`
                                    )->a( n = `emptySpanL`       v = `0`
                                    )->a( n = `emptySpanM`       v = `0`
                                    )->a( n = `emptySpanS`       v = `0`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `width`            v = `100%`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Social Accounts`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `LinkedIn`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `/DeniseSmith`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Twitter`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `@DeniseSmith`

                                )->end(

                                )->ele( n = `SimpleForm` ns = `form`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `width`    v = `100%`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Addresses`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Home Address`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `2096 Mission Street`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Mailing Address`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `PO Box 32114`

                                )->end(

                                )->ele( n = `SimpleForm` ns = `form`
                                    )->a( n = `layout` v = `ColumnLayout`
                                    )->a( n = `width`  v = `100%`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Mailing Address`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Work`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `DeniseSmith@sap.com`

                                )->end(
                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `paymentSubSection`
                            )->a( n = `title`          v = `Payment information`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `form`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Main Payment Method`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Bank Transfer`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Sparkasse Heimfeld, Germany`

                                )->end(
                            )->end(

                            )->ele( `moreBlocks`
                                )->ele( n = `SimpleForm` ns = `form`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Payment method for Expenses`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Extra Travel Expenses`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Cash 100 USD` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `LINK2_PRESS`.
        " the controller's handleLink2Press constant-text MessageToast
        client->message_toast_display( `Page 2 long link clicked` ).
    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the controller's named 'buttons' JSONModel, folded onto the one default
    " model root; formatted_text is the constant result of the controller's
    " .onFormat formatter, computed here per the thin-frontend rule
    text = `working binding`.
    icon = `sap-icon://chain-link`.
    formatted_text = `formatted link`.

  ENDMETHOD.

ENDCLASS.
