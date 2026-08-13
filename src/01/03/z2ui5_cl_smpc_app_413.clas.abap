CLASS z2ui5_cl_smpc_app_413 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_413 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " Block->content inlining (app 217/188/161 precedent, CAPABILITIES 'Custom
    " BlockBase blocks in a sap.uxap.ObjectPageLayout'): the original blocks
    " and moreBlocks aggregations hold custom BlockBase controls from the
    " sample's SharedBlocks JS - a BlockBase is only a lazy-loading wrapper
    " around a view, so each block's content (a sap.ui.layout.form.SimpleForm)
    " is inlined directly here.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `height`       v = `100%`

        )->open( `ObjectPageLayout`
            )->a( n = `id`                       v = `ObjectPageLayout`
            )->a( n = `showTitleInHeaderContent` v = `true`
            )->a( n = `upperCaseAnchorBar`       v = `false`

            )->open( `headerTitle`
                )->open( `ObjectPageHeader`
                    )->a( n = `id`                            v = `headerForTest`
                    )->a( n = `objectTitle`                   v = `Rowan Atkinson`
                    )->a( n = `objectImageShape`              v = `Circle`
                    )->a( n = `objectSubtitle`                v = `Manager, HCM`
                    )->a( n = `isObjectTitleAlwaysVisible`    v = `false`
                    )->a( n = `isObjectSubtitleAlwaysVisible` v = `false`
                    )->a( n = `isActionAreaAlwaysVisible`     v = `true`
                    )->a( n = `showPlaceholder`               v = `true`

                    )->open( `navigationBar`
                        )->open( n = `Bar` ns = `m`
                            )->open( n = `contentLeft` ns = `m`
                                )->leaf( n = `Button` ns = `m`
                                    )->a( n = `icon`    v = `sap-icon://nav-back`
                                    )->a( n = `tooltip` v = `nav-back`

                            )->shut(

                            )->open( n = `contentMiddle` ns = `m`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Employee Profile`

                            )->shut(
                        )->shut(
                    )->shut(

                    )->open( `actions`
                        )->leaf( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://tree`
                            )->a( n = `text`    v = `tree`
                            )->a( n = `tooltip` v = `tree`
                        )->leaf( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://action`
                            )->a( n = `text`    v = `action`
                            )->a( n = `tooltip` v = `action`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `headerContent`
                )->open( n = `VerticalLayout` ns = `layout`
                    )->leaf( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Address`
                        )->a( n = `text`  v = `BLR.01, B2.023`
                    )->leaf( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Office phone`
                        )->a( n = `text`  v = `+91-90100-98100`
                    )->leaf( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Email`
                        )->a( n = `text`  v = `rowan@pic.com`

                )->shut(

                " image srcs absolutized from ./test-resources/... to the sdk.openui5.org host (asset-URL rule)
                )->open( n = `HorizontalLayout` ns = `layout`
                    )->leaf( n = `Image` ns = `m`
                        )->a( n = `width`  v = `21px`
                        )->a( n = `height` v = `21px`
                        )->a( n = `src`    v = `https://sdk.openui5.org/test-resources/sap/uxap/images/linkedInIcon.png`
                    )->leaf( n = `Image` ns = `m`
                        )->a( n = `width`  v = `20px`
                        )->a( n = `height` v = `20px`
                        )->a( n = `src`    v = `https://sdk.openui5.org/test-resources/sap/uxap/images/facebookIcon.png`
                    )->leaf( n = `Image` ns = `m`
                        )->a( n = `width`  v = `21px`
                        )->a( n = `height` v = `21px`
                        )->a( n = `src`    v = `https://sdk.openui5.org/test-resources/sap/uxap/images/twitterIcon.png`

                )->shut(

                )->leaf( n = `ObjectStatus` ns = `m`
                    )->a( n = `state` v = `Success`
                    )->a( n = `icon`  v = `sap-icon://employee-approvals`
                    )->a( n = `text`  v = `Available`

                )->open( n = `VerticalLayout` ns = `layout`
                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `Bangalore, India`
                    )->leaf( n = `Label` ns = `m`
                        )->a( n = `text` v = `3:00 PM, Friday`

                )->shut(
            )->shut(

            )->open( `sections`
                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `2014 Goals Plan`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
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

ENDCLASS.
