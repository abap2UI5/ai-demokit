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

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " Block->content inlining (app 217/401/402 precedent, CAPABILITIES 'Custom
    " BlockBase blocks in a sap.uxap.ObjectPageLayout'): the original blocks
    " and moreBlocks aggregations hold custom BlockBase controls from the
    " sample's SharedBlocks JS - a BlockBase is only a lazy-loading wrapper
    " around a view, so each block's content (a form:SimpleForm) is inlined
    " directly here (see sidecar).
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `height`       v = `100%`

        )->open( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `isChildPage`        v = `true`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->open( `headerTitle`
                " objectImageURI points at the sdk.openui5.org host per the
                " offline asset-URL rule (see sidecar)
                )->open( `ObjectPageHeader`
                    )->a( n = `id`               v = `headerForTest`
                    )->a( n = `objectTitle`      v = `Denise Smith`
                    )->a( n = `objectSubtitle`   v = `Example of a child page in ObjectPage terms`
                    )->a( n = `objectImageShape` v = `Circle`
                    )->a( n = `objectImageURI`   v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`

                    )->open( `actions`
                        )->leaf( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://action`
                            )->a( n = `text`    v = `action`
                            )->a( n = `tooltip` v = `action`
                        )->leaf( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://action-settings`
                            )->a( n = `text`    v = `settings`
                            )->a( n = `tooltip` v = `action-settings`
                        )->leaf( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://edit`
                            )->a( n = `text`    v = `edit`
                            )->a( n = `tooltip` v = `edit`
                        )->leaf( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://save`
                            )->a( n = `text`    v = `save`
                            )->a( n = `visible` v = `false`
                            )->a( n = `tooltip` v = `save`
                        " the controller's named 'buttons' JSONModel is folded onto the
                        " default model root: buttons>/text and buttons>/icon become
                        " bound root fields; the sixth button's .onFormat formatter
                        " result is computed in model_init (see sidecar)
                        )->leaf( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://refresh`
                            )->a( n = `text`    v = client->_bind( text )
                            )->a( n = `tooltip` v = `refresh`
                        )->leaf( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = client->_bind( icon )
                            )->a( n = `text`    v = client->_bind( formatted_text )
                            )->a( n = `tooltip` v = `chain-link`

                    )->shut(

                    )->open( `breadcrumbs`
                        )->open( n = `Breadcrumbs` ns = `m`
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Page 2 long link`
                                )->a( n = `press` v = client->_event( `LINK2_PRESS` )

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `headerContent`
                )->open( n = `VerticalLayout` ns = `layout`
                    )->leaf( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `User ID`
                        )->a( n = `text`  v = `12345678`
                    )->leaf( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Functional Area`
                        )->a( n = `text`  v = `Developement`
                    )->leaf( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Cost Center`
                        )->a( n = `text`  v = `PI DFA GD Programs and Product`
                    )->leaf( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Email`
                        )->a( n = `text`  v = `email@address.com`

                )->shut(

                )->leaf( n = `Text` ns = `m`
                    )->a( n = `width` v = `200px`
                    )->a( n = `text`  v = `Hi, I'm Denise. I am passionate about what I do and I'll go the extra mile to make the customer win.`
                )->leaf( n = `ObjectStatus` ns = `m`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Error`
                )->leaf( n = `ObjectStatus` ns = `m`
                    )->a( n = `title` v = `Label`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Warning`

            )->shut(

            )->open( `sections`
                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `2014 Goals Plan`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = ` `
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->open( n = `SimpleForm` ns = `form`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Evangelize the UI framework across the company`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `4 days overdue Cascaded`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Get trained in development management direction`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Due Nov 21`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Mentor junior developers`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Due Dec 31 Cascaded`

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Personal`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Connect`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->open( n = `SimpleForm` ns = `form`
                                    )->a( n = `layout` v = `ColumnLayout`
                                    )->a( n = `width`  v = `100%`

                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Phone Numbers`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Home`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `+ 1 415-321-1234`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Office phone`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `+ 1 415-321-5555`

                                )->shut(

                                )->open( n = `SimpleForm` ns = `form`
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `labelSpanL`       v = `4`
                                    )->a( n = `labelSpanM`       v = `4`
                                    )->a( n = `labelSpanS`       v = `4`
                                    )->a( n = `emptySpanL`       v = `0`
                                    )->a( n = `emptySpanM`       v = `0`
                                    )->a( n = `emptySpanS`       v = `0`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `width`            v = `100%`

                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Social Accounts`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `LinkedIn`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `/DeniseSmith`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Twitter`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `@DeniseSmith`

                                )->shut(

                                )->open( n = `SimpleForm` ns = `form`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `width`    v = `100%`

                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Addresses`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Home Address`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `2096 Mission Street`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Mailing Address`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `PO Box 32114`

                                )->shut(

                                )->open( n = `SimpleForm` ns = `form`
                                    )->a( n = `layout` v = `ColumnLayout`
                                    )->a( n = `width`  v = `100%`

                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Mailing Address`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Work`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `DeniseSmith@sap.com`

                                )->shut(
                            )->shut(
                        )->shut(

                        )->open( `ObjectPageSubSection`
                            )->a( n = `id`             v = `paymentSubSection`
                            )->a( n = `title`          v = `Payment information`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->open( n = `SimpleForm` ns = `form`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Main Payment Method`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Bank Transfer`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Sparkasse Heimfeld, Germany`

                                )->shut(
                            )->shut(

                            )->open( `moreBlocks`
                                )->open( n = `SimpleForm` ns = `form`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Payment method for Expenses`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Extra Travel Expenses`
                                    )->leaf( n = `Text` ns = `m`
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
