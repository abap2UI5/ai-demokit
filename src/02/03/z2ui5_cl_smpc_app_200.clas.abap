" @keywords headerfacetpattern header facet pattern sap.uxap objectpagesectionshowtitle objectpagelayout objectpagedynamicheadertitle objectpagesection objectpagesubsection
CLASS z2ui5_cl_smpc_app_200 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_200 IMPLEMENTATION.

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

    " robot.png avatar assets rewritten from the sample's relative
    " ./test-resources path to the sdk.openui5.org host (offline asset rule)
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`      v = `100%`
        )->a( n = `xmlns`       v = `sap.uxap`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`     v = `sap.m`
        )->a( n = `xmlns:core`  v = `sap.ui.core`
        )->a( n = `xmlns:forms` v = `sap.ui.layout.form`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->ele( `headerTitle`
                )->ele( `ObjectPageDynamicHeaderTitle`

                    )->ele( `expandedHeading`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text` v = `Robot Arm Series 9`

                    )->end(

                    )->ele( `snappedHeading`
                        )->ele( n = `HBox` ns = `m`
                            " POST-1.71: sap.m.Avatar (since 1.73) kept 1:1, here and in headerContent
                            )->tag( n = `Avatar` ns = `m`
                                )->a( n = `src`          v = `https://sdk.openui5.org/test-resources/sap/uxap/images/robot.png`
                                )->a( n = `class`        v = `sapUiMediumMarginEnd`
                                )->a( n = `displayShape` v = `Square`

                            )->ele( n = `VBox` ns = `m`
                                )->tag( n = `Title` ns = `m`
                                    )->a( n = `text` v = `Robot Arm Series 9`
                                )->tag( n = `Label` ns = `m`
                                    )->a( n = `text` v = `PO-48865`

                            )->end(
                        )->end(
                    )->end(

                    )->ele( `expandedContent`
                        )->tag( n = `Label` ns = `m`
                            )->a( n = `text` v = `PO-48865`

                    )->end(

                    )->ele( `snappedTitleOnMobile`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text` v = `Robot Arm Series 9`

                    )->end(

                    )->ele( `actions`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `type` v = `Emphasized`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `text` v = `Delete`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `text` v = `Simulate Assembly`

                    )->end(
                )->end(
            )->end(

            )->ele( `headerContent`
                )->ele( n = `FlexBox` ns = `m`
                    )->a( n = `wrap`         v = `Wrap`
                    )->a( n = `fitContainer` v = `true`

                    )->tag( n = `Avatar` ns = `m`
                        )->a( n = `src`          v = `https://sdk.openui5.org/test-resources/sap/uxap/images/robot.png`
                        )->a( n = `class`        v = `sapUiMediumMarginEnd`
                        )->a( n = `displayShape` v = `Square`
                        )->a( n = `displaySize`  v = `L`

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->ele( n = `HBox` ns = `m`
                            )->a( n = `class`      v = `sapUiTinyMarginBottom`
                            )->a( n = `renderType` v = `Bare`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Manufacturer:`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                            )->tag( n = `Text` ns = `m`
                                )->a( n = `text` v = ` Robotech`

                        )->end(

                        )->ele( n = `HBox` ns = `m`
                            )->a( n = `class`      v = `sapUiTinyMarginBottom`
                            )->a( n = `renderType` v = `Bare`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Factory:`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                            )->tag( n = `Text` ns = `m`
                                )->a( n = `text` v = ` Orlando, Florida`

                        )->end(

                        )->ele( n = `HBox` ns = `m`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text`  v = `Supplier:`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `Robotech (234242343)`

                        )->end(
                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Status`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `Delivery`
                            )->a( n = `state` v = `Success`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Delivery Time`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `12 Days`
                            )->a( n = `icon`  v = `sap-icon://shipping-status`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd sapUiSmallMarginBottom`

                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Assembly Option`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `To Be Selected`
                            )->a( n = `state` v = `Error`
                            )->a( n = `class` v = `sapMObjectStatusLarge`

                    )->end(

                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `class` v = `sapUiLargeMarginEnd`

                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`  v = `Monthly Leasing Instalment`
                            )->a( n = `class` v = `sapUiTinyMarginBottom`
                        )->tag( n = `ObjectNumber` ns = `m`
                            )->a( n = `number`     v = `379.99`
                            )->a( n = `unit`       v = `USD`
                            )->a( n = `emphasized` v = `false`
                            )->a( n = `class`      v = `sapMObjectNumberLarge`

                    )->end(
                )->end(
            )->end(

            )->ele( `sections`
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `General Information`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`     v = `Order Details`
                            " POST-1.71: showTitle (since 1.77) kept 1:1, here and on the Products subsection
                            )->a( n = `showTitle` v = `false`

                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`    v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->a( n = `columnsM` v = `2`
                                    )->a( n = `columnsL` v = `3`
                                    )->a( n = `columnsXL` v = `4`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Order Details`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Order ID`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `589946637`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Cotract`
                                    )->tag( n = `Link` ns = `m`
                                        )->a( n = `text` v = `10045876`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Transaction Date:`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `May 6, 2018`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Expected Delivery Date`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `June 23, 2018`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Factory`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Orlando, FL`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Supplier`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Robotech`
                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Configuration Accounts`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Model`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Robot Arm Series 9`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Color`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `White (default)`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Socket`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `Default Socket 10`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Leasing Instalment`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `379.99 USD per month`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Axis`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `6 Axis`

                                )->end(
                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`     v = `Products`
                            )->a( n = `showTitle` v = `false`

                            )->ele( `blocks`
                                )->ele( n = `Table` ns = `m`
                                    )->a( n = `class` v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `width` v = `auto`

                                    )->ele( n = `headerToolbar` ns = `m`
                                        )->ele( n = `OverflowToolbar` ns = `m`
                                            )->tag( n = `Title` ns = `m`
                                                )->a( n = `text`  v = `Products`
                                                )->a( n = `level` v = `H2`
                                            )->tag( n = `ToolbarSpacer` ns = `m`
                                            )->tag( n = `SearchField` ns = `m`
                                                )->a( n = `width` v = `17.5rem`
                                            )->tag( n = `OverflowToolbarButton` ns = `m`
                                                )->a( n = `tooltip` v = `Sort`
                                                )->a( n = `text`    v = `Sort`
                                                )->a( n = `icon`    v = `sap-icon://sort`
                                            )->tag( n = `OverflowToolbarButton` ns = `m`
                                                )->a( n = `tooltip` v = `Filter`
                                                )->a( n = `text`    v = `Filter`
                                                )->a( n = `icon`    v = `sap-icon://filter`
                                            )->tag( n = `OverflowToolbarButton` ns = `m`
                                                )->a( n = `tooltip` v = `Group`
                                                )->a( n = `text`    v = `Group`
                                                )->a( n = `icon`    v = `sap-icon://group-2`
                                            )->tag( n = `OverflowToolbarButton` ns = `m`
                                                )->a( n = `tooltip` v = `Settings`
                                                )->a( n = `text`    v = `Settings`
                                                )->a( n = `icon`    v = `sap-icon://action-settings`

                                        )->end(
                                    )->end(

                                    )->ele( n = `columns` ns = `m`
                                        )->ele( n = `Column` ns = `m`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Document Number`

                                        )->end(

                                        )->ele( n = `Column` ns = `m`
                                            )->a( n = `minScreenWidth` v = `Tablet`
                                            )->a( n = `demandPopin`    v = `true`

                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Company`

                                        )->end(

                                        )->ele( n = `Column` ns = `m`
                                            )->a( n = `minScreenWidth` v = `Tablet`
                                            )->a( n = `demandPopin`    v = `true`

                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Contact Person`

                                        )->end(

                                        )->ele( n = `Column` ns = `m`
                                            )->a( n = `minScreenWidth` v = `Tablet`
                                            )->a( n = `demandPopin`    v = `true`

                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Posting Date`

                                        )->end(

                                        )->ele( n = `Column` ns = `m`
                                            )->a( n = `hAlign` v = `End`

                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Amount (Local Currency)`

                                        )->end(
                                    )->end(

                                    )->ele( n = `items` ns = `m`
                                        )->ele( n = `ColumnListItem` ns = `m`
                                            )->tag( n = `Link` ns = `m`
                                                )->a( n = `text` v = `10223882001820`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jologa`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Denise Smith`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `11/15/19`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `12,897.00 EUR`

                                        )->end(

                                        )->ele( n = `ColumnListItem` ns = `m`
                                            )->tag( n = `Link` ns = `m`
                                                )->a( n = `text` v = `10223882001820`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jologa`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Denise Smith`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `11/15/19`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `12,897.00 EUR`

                                        )->end(

                                        )->ele( n = `ColumnListItem` ns = `m`
                                            )->tag( n = `Link` ns = `m`
                                                )->a( n = `text` v = `10223882001820`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jologa`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Denise Smith`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `11/15/19`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `12,897.00 EUR`

                                        )->end(

                                        )->ele( n = `ColumnListItem` ns = `m`
                                            )->tag( n = `Link` ns = `m`
                                                )->a( n = `text` v = `10223882001820`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jologa`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Denise Smith`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `11/15/19`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `12,897.00 EUR`

                                        )->end(

                                        )->ele( n = `ColumnListItem` ns = `m`
                                            )->tag( n = `Link` ns = `m`
                                                )->a( n = `text` v = `10223882001820`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jologa`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Denise Smith`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `11/15/19`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `12,897.00 EUR`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Contact Information`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title` v = `Contact Information`

                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `class`    v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->a( n = `columnsM` v = `2`
                                    )->a( n = `columnsL` v = `3`
                                    )->a( n = `columnsXL` v = `4`

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
                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Mailing Address`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Work`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `DeniseSmith@sap.com` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
