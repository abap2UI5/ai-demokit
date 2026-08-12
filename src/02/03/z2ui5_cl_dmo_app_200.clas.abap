CLASS z2ui5_cl_dmo_app_200 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_200 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " robot.png avatar assets rewritten from the sample's relative
    " ./test-resources path to the sdk.openui5.org host (offline asset rule)
    view->open( n = `View` ns = `mvc`
        )->a( n = `height`      v = `100%`
        )->a( n = `xmlns`       v = `sap.uxap`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`     v = `sap.m`
        )->a( n = `xmlns:core`  v = `sap.ui.core`
        )->a( n = `xmlns:forms` v = `sap.ui.layout.form`

        )->open( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->open( `headerTitle`
                )->open( `ObjectPageDynamicHeaderTitle`

                    )->open( `expandedHeading`
                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text` v = `Robot Arm Series 9`

                    )->shut(

                    )->open( `snappedHeading`
                        )->open( n = `HBox` ns = `m`
                            " POST-1.71: sap.m.Avatar (since 1.73) kept 1:1, here and in headerContent
                            )->leaf( n = `Avatar` ns = `m`
                                )->a( n = `src`          v = `https://sdk.openui5.org/test-resources/sap/uxap/images/robot.png`
                                )->a( n = `class`        v = `sapUiMediumMarginEnd`
                                )->a( n = `displayShape` v = `Square`

                            )->open( n = `VBox` ns = `m`
                                )->leaf( n = `Title` ns = `m`
                                    )->a( n = `text` v = `Robot Arm Series 9`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `PO-48865`

                            )->shut(
                        )->shut(
                    )->shut(

                    )->open( `expandedContent`
                        )->leaf( n = `Label` ns = `m`
                            )->a( n = `text` v = `PO-48865`

                    )->shut(

                    )->open( `snappedTitleOnMobile`
                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text` v = `Robot Arm Series 9`

                    )->shut(

                    )->open( `actions`
                        )->leaf( n = `Button` ns = `m`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `type` v = `Emphasized`
                        )->leaf( n = `Button` ns = `m`
                            )->a( n = `text` v = `Delete`
                        )->leaf( n = `Button` ns = `m`
                            )->a( n = `text` v = `Simulate Assembly`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `headerContent`
                )->open( n = `FlexBox` ns = `m`
                    )->a( n = `wrap`         v = `Wrap`
                    )->a( n = `fitContainer` v = `true`

                    )->leaf( n = `Avatar` ns = `m`
                        )->a( n = `src`          v = `https://sdk.openui5.org/test-resources/sap/uxap/images/robot.png`
                        )->a( n = `class`        v = `sapUiMediumMarginEnd`
                        )->a( n = `displayShape` v = `Square`
                        )->a( n = `displaySize`  v = `L`

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->open( n = `HBox` ns = `m`
                            )->a( n = `class`      v = `sapUiTinyMarginBottom`
                            )->a( n = `renderType` v = `Bare`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Manufacturer:`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                            )->leaf( n = `Text` ns = `m`
                                )->a( n = `text` v = ` Robotech`

                        )->shut(

                        )->open( n = `HBox` ns = `m`
                            )->a( n = `class`      v = `sapUiTinyMarginBottom`
                            )->a( n = `renderType` v = `Bare`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Factory:`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                            )->leaf( n = `Text` ns = `m`
                                )->a( n = `text` v = ` Orlando, Florida`

                        )->shut(

                        )->open( n = `HBox` ns = `m`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Supplier:`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text` v = `Robotech (234242343)`

                        )->shut(
                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Status`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `Delivery`
                            )->a( n = `state` v = `Success`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Delivery Time`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `12 Days`
                            )->a( n = `icon`  v = `sap-icon://shipping-status`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Assembly Option`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `To Be Selected`
                            )->a( n = `state` v = `Error`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->shut(

                    )->open( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd`

                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Monthly Leasing Instalment`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->leaf( n = `ObjectNumber` ns = `m`
                            )->a( n = `number`     v = `379.99`
                            )->a( n = `unit`       v = `USD`
                            )->a( n = `emphasized` v = `false`
                            )->a( n = `class`      v = `sapMObjectNumberLarge`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `sections`
                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `General Information`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`     v = `Order Details`
                            " POST-1.71: showTitle (since 1.77) kept 1:1, here and on the Products subsection
                            )->a( n = `showTitle` v = `false`

                            )->open( `blocks`
                                )->open( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`    v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->a( n = `columnsM` v = `2`
                                    )->a( n = `columnsL` v = `3`
                                    )->a( n = `columnsXL` v = `4`

                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Order Details`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Order ID`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `589946637`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Cotract`
                                    )->leaf( n = `Link` ns = `m`
                                        )->a( n = `text` v = `10045876`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Transaction Date:`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `May 6, 2018`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Expected Delivery Date`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `June 23, 2018`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Factory`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Orlando, FL`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Supplier`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Robotech`
                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Configuration Accounts`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Model`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Robot Arm Series 9`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Color`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `White (default)`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Socket`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Default Socket 10`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Leasing Instalment`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `379.99 USD per month`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Axis`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `6 Axis`

                                )->shut(
                            )->shut(
                        )->shut(

                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`     v = `Products`
                            )->a( n = `showTitle` v = `false`

                            )->open( `blocks`
                                )->open( n = `Table` ns = `m`
                                    )->a( n = `class` v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `width` v = `auto`

                                    )->open( n = `headerToolbar` ns = `m`
                                        )->open( n = `OverflowToolbar` ns = `m`
                                            )->leaf( n = `Title` ns = `m`
                                                )->a( n = `text`  v = `Products`
                                                )->a( n = `level` v = `H2`
                                            )->leaf( n = `ToolbarSpacer` ns = `m`
                                            )->leaf( n = `SearchField` ns = `m`
                                                )->a( n = `width` v = `17.5rem`
                                            )->leaf( n = `OverflowToolbarButton` ns = `m`
                                                )->a( n = `tooltip` v = `Sort`
                                                )->a( n = `text`    v = `Sort`
                                                )->a( n = `icon`    v = `sap-icon://sort`
                                            )->leaf( n = `OverflowToolbarButton` ns = `m`
                                                )->a( n = `tooltip` v = `Filter`
                                                )->a( n = `text`    v = `Filter`
                                                )->a( n = `icon`    v = `sap-icon://filter`
                                            )->leaf( n = `OverflowToolbarButton` ns = `m`
                                                )->a( n = `tooltip` v = `Group`
                                                )->a( n = `text`    v = `Group`
                                                )->a( n = `icon`    v = `sap-icon://group-2`
                                            )->leaf( n = `OverflowToolbarButton` ns = `m`
                                                )->a( n = `tooltip` v = `Settings`
                                                )->a( n = `text`    v = `Settings`
                                                )->a( n = `icon`    v = `sap-icon://action-settings`

                                        )->shut(
                                    )->shut(

                                    )->open( n = `columns` ns = `m`
                                        )->open( n = `Column` ns = `m`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Document Number`

                                        )->shut(

                                        )->open( n = `Column` ns = `m`
                                            )->a( n = `minScreenWidth` v = `Tablet`
                                            )->a( n = `demandPopin`    v = `true`

                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Company`

                                        )->shut(

                                        )->open( n = `Column` ns = `m`
                                            )->a( n = `minScreenWidth` v = `Tablet`
                                            )->a( n = `demandPopin`    v = `true`

                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Contact Person`

                                        )->shut(

                                        )->open( n = `Column` ns = `m`
                                            )->a( n = `minScreenWidth` v = `Tablet`
                                            )->a( n = `demandPopin`    v = `true`

                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Posting Date`

                                        )->shut(

                                        )->open( n = `Column` ns = `m`
                                            )->a( n = `hAlign` v = `End`

                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Amount (Local Currency)`

                                        )->shut(
                                    )->shut(

                                    )->open( n = `items` ns = `m`
                                        )->open( n = `ColumnListItem` ns = `m`
                                            )->leaf( n = `Link` ns = `m`
                                                )->a( n = `text` v = `10223882001820`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jologa`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Denise Smith`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `11/15/19`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `12,897.00 EUR`

                                        )->shut(

                                        )->open( n = `ColumnListItem` ns = `m`
                                            )->leaf( n = `Link` ns = `m`
                                                )->a( n = `text` v = `10223882001820`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jologa`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Denise Smith`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `11/15/19`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `12,897.00 EUR`

                                        )->shut(

                                        )->open( n = `ColumnListItem` ns = `m`
                                            )->leaf( n = `Link` ns = `m`
                                                )->a( n = `text` v = `10223882001820`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jologa`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Denise Smith`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `11/15/19`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `12,897.00 EUR`

                                        )->shut(

                                        )->open( n = `ColumnListItem` ns = `m`
                                            )->leaf( n = `Link` ns = `m`
                                                )->a( n = `text` v = `10223882001820`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jologa`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Denise Smith`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `11/15/19`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `12,897.00 EUR`

                                        )->shut(

                                        )->open( n = `ColumnListItem` ns = `m`
                                            )->leaf( n = `Link` ns = `m`
                                                )->a( n = `text` v = `10223882001820`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jologa`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Denise Smith`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `11/15/19`
                                            )->leaf( n = `Text` ns = `m`
                                                )->a( n = `text` v = `12,897.00 EUR`

                                        )->shut(
                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Contact Information`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title` v = `Contact Information`

                            )->open( `blocks`
                                )->open( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`    v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->a( n = `columnsM` v = `2`
                                    )->a( n = `columnsL` v = `3`
                                    )->a( n = `columnsXL` v = `4`

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
                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Mailing Address`
                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Work`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `DeniseSmith@sap.com` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
