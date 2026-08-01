CLASS z2ui5_cl_ai_app_260 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_260 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " Block->content inlining (app 188/217 precedent): the blocks / moreBlocks
    " aggregations hold SharedBlocks BlockBase controls (goals:GoalsBlock,
    " personal:*). A BlockBase is only a lazy-loading wrapper around a view and
    " each of these views is a static SimpleForm, so the view content is
    " inlined here 1:1.
    view->open( n = `View` ns = `mvc`
        )->a( n = `height`      v = `100%`
        )->a( n = `xmlns`       v = `sap.uxap`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`     v = `sap.m`
        )->a( n = `xmlns:core`  v = `sap.ui.core`
        )->a( n = `xmlns:l`     v = `sap.ui.layout`
        )->a( n = `xmlns:forms` v = `sap.ui.layout.form`

        )->open( `ObjectPageLayout`
            )->a( n = `id`                        v = `ObjectPageLayout`
            )->a( n = `preserveHeaderStateOnScroll` v = `true`
            )->a( n = `upperCaseAnchorBar`        v = `false`

            )->open( `headerTitle`
                )->open( `ObjectPageDynamicHeaderTitle`
                    )->open( `heading`
                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text` v = `Denise Smith`

                    )->shut(

                    )->open( `expandedContent`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `text` v = `Example of a ObjectPage with Header Content always shown on desktop`

                    )->shut(

                    )->open( `snappedContent`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `text` v = `Example of a ObjectPage with Header Content always shown on desktop`

                    )->shut(

                    )->open( `snappedTitleOnMobile`
                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text` v = `Example of a ObjectPage with Header Content always shown on desktop`

                    )->shut(

                    )->open( `actions`
                        )->leaf( n = `Button` ns = `m`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `type` v = `Emphasized`
                        )->leaf( n = `Button` ns = `m`
                            )->a( n = `type` v = `Transparent`
                            )->a( n = `text` v = `Delete`
                        )->leaf( n = `Button` ns = `m`
                            )->a( n = `type` v = `Transparent`
                            )->a( n = `text` v = `Copy`
                        )->leaf( n = `OverflowToolbarButton` ns = `m`
                            )->a( n = `icon`    v = `sap-icon://action`
                            )->a( n = `type`    v = `Transparent`
                            )->a( n = `text`    v = `Share`
                            )->a( n = `tooltip` v = `action`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `headerContent`
                )->open( n = `FlexBox` ns = `m`
                    )->a( n = `wrap`         v = `Wrap`
                    )->a( n = `fitContainer` v = `true`

                    )->open( n = `VerticalLayout` ns = `l`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

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

                    )->open( n = `VerticalLayout` ns = `l`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `width` v = `200px`
                            )->a( n = `text`  v = `Hi, I'm Denise. I am passionate about what I do and I'll go the extra mile to make the customer win.`

                    )->shut(

                    )->open( n = `HorizontalLayout` ns = `l`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `In Stock`
                            )->a( n = `state` v = `Error`
                            )->a( n = `class` v = `sapUiMediumMarginEnd`
                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `title` v = `Label`
                            )->a( n = `text`  v = `In Stock`
                            )->a( n = `state` v = `Warning`

                    )->shut(
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

                                " goals:GoalsBlock inlined
                                )->open( n = `SimpleForm` ns = `forms`
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

                                " personal:BlockPhoneNumber inlined
                                )->open( n = `SimpleForm` ns = `forms`
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

                                " personal:BlockSocial inlined
                                )->open( n = `SimpleForm` ns = `forms`
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

                                " personal:BlockAdresses inlined
                                )->open( n = `SimpleForm` ns = `forms`
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

                                " personal:BlockMailing inlined (its BlockBase
                                " columnLayout='1' has no counterpart here)
                                )->open( n = `SimpleForm` ns = `forms`
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

                                " personal:PersonalBlockPart1 inlined
                                )->open( n = `SimpleForm` ns = `forms`
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

                                " personal:PersonalBlockPart2 inlined
                                )->open( n = `SimpleForm` ns = `forms`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Payment method for Expenses`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Extra Travel Expenses`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Cash 100 USD`

                                ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
