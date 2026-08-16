" @keywords objectpageheadercontent object header content sap.uxap objectpageheadercontentpriorities objectpagelayout objectpagedynamicheadertitle objectpageheaderlayoutdata objectpagesection objectpagesubsection
CLASS z2ui5_cl_smpc_app_188 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_188 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 178/161 precedent): the original blocks
    " aggregations each hold the custom BlockBase control goals:GoalsBlock
    " (sample's SharedBlocks JS). A BlockBase is only a lazy-loading wrapper
    " around a view; GoalsBlock's content is a SimpleForm of three Label/Text
    " goal pairs, inlined here as form:SimpleForm in each blocks aggregation -
    " no custom JS control needed, thin frontend preserved (see sidecar).
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`        v = `100%`
        )->a( n = `xmlns`         v = `sap.uxap`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:layout`  v = `sap.ui.layout`
        )->a( n = `xmlns:m`       v = `sap.m`
        )->a( n = `xmlns:form`    v = `sap.ui.layout.form`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                       v = `ObjectPageLayout`
            )->a( n = `showTitleInHeaderContent` v = `true`
            )->a( n = `upperCaseAnchorBar`       v = `false`

            )->ele( `headerTitle`
                )->ele( `ObjectPageDynamicHeaderTitle`

                    )->ele( `expandedHeading`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`     v = `Denise Smith`
                            )->a( n = `wrapping` v = `true`

                    )->end(

                    )->ele( `snappedHeading`
                        )->ele( n = `FlexBox` ns = `m`
                            )->a( n = `fitContainer` v = `true`
                            )->a( n = `alignItems`   v = `Center`

                            )->tag( n = `Avatar` ns = `m`
                                )->a( n = `src`             v = `sap-icon://picture`
                                )->a( n = `backgroundColor` v = `Random`
                                )->a( n = `class`           v = `sapUiTinyMarginEnd`
                            )->tag( n = `Title` ns = `m`
                                )->a( n = `text`     v = `Denise Smith`
                                )->a( n = `wrapping` v = `true`

                        )->end(
                    )->end(

                    )->ele( `expandedContent`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior Developer`

                    )->end(

                    )->ele( `snappedContent`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior Developer`

                    )->end(

                    )->ele( `snappedTitleOnMobile`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text` v = `Senior Developer`

                    )->end(

                    )->ele( `actions`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `type` v = `Emphasized`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `type` v = `Transparent`
                            )->a( n = `text` v = `Delete`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `type` v = `Transparent`
                            )->a( n = `text` v = `Copy`
                        )->tag( n = `OverflowToolbarButton` ns = `m`
                            )->a( n = `icon`    v = `sap-icon://action`
                            )->a( n = `type`    v = `Transparent`
                            )->a( n = `text`    v = `Share`
                            )->a( n = `tooltip` v = `action`

                    )->end(
                )->end(
            )->end(

            )->ele( `headerContent`
                )->ele( n = `FlexBox` ns = `m`
                    )->a( n = `wrap` v = `Wrap`

                    )->tag( n = `Avatar` ns = `m`
                        )->a( n = `src`             v = `sap-icon://picture`
                        )->a( n = `backgroundColor` v = `Random`
                        )->a( n = `displaySize`     v = `L`
                        )->a( n = `class`           v = `sapUiTinyMarginEnd`

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `title` v = `User ID`
                            )->a( n = `text`  v = `12345678`
                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `title` v = `Language`
                            )->a( n = `text`  v = `English`
                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `title` v = `Country`
                            )->a( n = `text`  v = `USA`
                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `title` v = `Phone Number`
                            )->a( n = `text`  v = `1-844-726-7733`

                    )->end(

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

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

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->ele( n = `layoutData` ns = `layout`
                            )->tag( `ObjectPageHeaderLayoutData`
                                )->a( n = `visibleS` v = `false`
                                )->a( n = `visibleM` v = `false`

                        )->end(

                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `Senior UI Developer`
                            )->a( n = `state` v = `Success`
                        )->tag( n = `RatingIndicator` ns = `m`
                            )->a( n = `maxValue` v = `6`
                            )->a( n = `value`    v = `5`
                            )->a( n = `tooltip`  v = `Rating Tooltip`

                    )->end(
                )->end(
            )->end(

            )->ele( `sections`
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `2014 Goals Plan`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Goal summary`
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

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Goal summary`
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

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Goal summary`
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

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Goal summary`
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
                                        )->a( n = `text` v = `Due Dec 31 Cascaded` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
