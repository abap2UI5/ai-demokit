CLASS z2ui5_cl_ai_app_188 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_188 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`        v = `100%`
        )->a( n = `xmlns`         v = `sap.uxap`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:layout`  v = `sap.ui.layout`
        )->a( n = `xmlns:m`       v = `sap.m`
        )->a( n = `xmlns:form`    v = `sap.ui.layout.form`

        )->open( `ObjectPageLayout`
            )->a( n = `id`                       v = `ObjectPageLayout`
            )->a( n = `showTitleInHeaderContent` v = `true`
            )->a( n = `upperCaseAnchorBar`       v = `false`

            )->open( `headerTitle`
                )->open( `ObjectPageDynamicHeaderTitle`

                    )->open( `expandedHeading`
                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`     v = `Denise Smith`
                            )->a( n = `wrapping` v = `true`

                    )->shut(

                    )->open( `snappedHeading`
                        )->open( n = `FlexBox` ns = `m`
                            )->a( n = `fitContainer` v = `true`
                            )->a( n = `alignItems`   v = `Center`

                            )->leaf( n = `Avatar` ns = `m`
                                )->a( n = `src`             v = `sap-icon://picture`
                                )->a( n = `backgroundColor` v = `Random`
                                )->a( n = `class`           v = `sapUiTinyMarginEnd`
                            )->leaf( n = `Title` ns = `m`
                                )->a( n = `text`     v = `Denise Smith`
                                )->a( n = `wrapping` v = `true`

                        )->shut(
                    )->shut(

                    )->open( `expandedContent`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior Developer`

                    )->shut(

                    )->open( `snappedContent`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior Developer`

                    )->shut(

                    )->open( `snappedTitleOnMobile`
                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text` v = `Senior Developer`

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
                    )->a( n = `wrap` v = `Wrap`

                    )->leaf( n = `Avatar` ns = `m`
                        )->a( n = `src`             v = `sap-icon://picture`
                        )->a( n = `backgroundColor` v = `Random`
                        )->a( n = `displaySize`     v = `L`
                        )->a( n = `class`           v = `sapUiTinyMarginEnd`

                    )->open( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `title` v = `User ID`
                            )->a( n = `text`  v = `12345678`
                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `title` v = `Language`
                            )->a( n = `text`  v = `English`
                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `title` v = `Country`
                            )->a( n = `text`  v = `USA`
                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `title` v = `Phone Number`
                            )->a( n = `text`  v = `1-844-726-7733`

                    )->shut(

                    )->open( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

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

                    )->open( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->open( n = `layoutData` ns = `layout`
                            )->leaf( `ObjectPageHeaderLayoutData`
                                )->a( n = `visibleS` v = `false`
                                )->a( n = `visibleM` v = `false`

                        )->shut(

                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `Senior UI Developer`
                            )->a( n = `state` v = `Success`
                        )->leaf( n = `RatingIndicator` ns = `m`
                            )->a( n = `maxValue` v = `6`
                            )->a( n = `value`    v = `5`
                            )->a( n = `tooltip`  v = `Rating Tooltip`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `sections`
                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `2014 Goals Plan`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Goal summary`
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

                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Goal summary`
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

                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Goal summary`
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

                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Goal summary`
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
                                        )->a( n = `text` v = `Due Dec 31 Cascaded` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
