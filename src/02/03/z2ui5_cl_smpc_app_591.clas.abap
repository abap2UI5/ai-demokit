" @keywords objectpagelayout object layout sap.uxap objectpageformlayout objectpagedynamicheadertitle breadcrumbs link title flexbox avatar text
" @summary Object Page automatically adjusts form layout to match block column layout
CLASS z2ui5_cl_smpc_app_591 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_591 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) OR client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 401/416 precedent): the two sections hold one
    " form block each plus four blockcolor:BlockBlue fillers, every one of them a
    " BlockBase around a static view - inlined 1:1 below (see sidecar)
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:forms`  v = `sap.ui.layout.form`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `enableLazyLoading`  v = `true`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->ele( `headerTitle`
                )->ele( `ObjectPageDynamicHeaderTitle`

                    )->ele( `breadcrumbs`
                        )->ele( n = `Breadcrumbs` ns = `m`
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
                                )->a( n = `src`   v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                            )->tag( n = `Title` ns = `m`
                                )->a( n = `text`     v = `Denise Smith`
                                )->a( n = `wrapping` v = `true`
                        )->end(
                    )->end(

                    )->ele( `expandedContent`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior UI Developer`
                    )->end(

                    )->ele( `snappedContent`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior UI Developer`
                    )->end(

                    )->ele( `snappedTitleOnMobile`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text` v = `Senior UI Developer`
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
                    )->a( n = `wrap`         v = `Wrap`
                    )->a( n = `fitContainer` v = `true`

                    )->tag( n = `Avatar` ns = `m`
                        )->a( n = `class`       v = `sapUiSmallMarginEnd`
                        )->a( n = `src`         v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`
                        )->a( n = `displaySize` v = `L`

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`
                        )->tag( n = `Link` ns = `m`
                            )->a( n = `text` v = `+33 6 4512 5158`
                        )->tag( n = `Link` ns = `m`
                            )->a( n = `text` v = `DeniseSmith@sap.com`

                        )->ele( n = `HorizontalLayout` ns = `layout`
                            )->tag( n = `Image` ns = `m`
                                )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/uxap/images/linkedin.png`
                            )->tag( n = `Image` ns = `m`
                                )->a( n = `src`   v = `https://sdk.openui5.org/test-resources/sap/uxap/images/Twitter.png`
                                )->a( n = `class` v = `sapUiSmallMarginBegin`
                        )->end(
                    )->end(

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`
                        )->tag( n = `Label` ns = `m`
                            )->a( n = `text` v = `Hello! I am Denise and I use UxAP`

                        )->ele( n = `VBox` ns = `m`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Achieved goals`
                            )->tag( n = `ProgressIndicator` ns = `m`
                                )->a( n = `percentValue` v = `30`
                                )->a( n = `displayValue` v = `30%`
                        )->end(
                    )->end(

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`
                        )->tag( n = `Label` ns = `m`
                            )->a( n = `text` v = `San Jose, USA`
                    )->end(
                )->end(
            )->end(

            )->ele( `sections`

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Personal`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " personal:PersonalFormBlock (columnLayout="3") inlined
                                )->ele( n = `Form` ns = `forms`
                                    )->a( n = `width` v = `100%`

                                    )->ele( n = `layout` ns = `forms`
                                        )->tag( n = `ColumnLayout` ns = `forms`
                                    )->end(

                                    )->ele( n = `formContainers` ns = `forms`

                                        )->ele( n = `FormContainer` ns = `forms`
                                            )->a( n = `id`    v = `addressInfo`
                                            )->a( n = `title` v = `Addresses`
                                            )->ele( n = `formElements` ns = `forms`

                                                )->ele( n = `FormElement` ns = `forms`
                                                    )->a( n = `label` v = `Home Address`
                                                    )->ele( n = `fields` ns = `forms`
                                                        )->tag( n = `Text` ns = `m`
                                                            )->a( n = `text` v = `2096 Mission Street`
                                                    )->end(
                                                )->end(

                                                )->ele( n = `FormElement` ns = `forms`
                                                    )->a( n = `label` v = `Home Mailing Address`
                                                    )->ele( n = `fields` ns = `forms`
                                                        )->tag( n = `Text` ns = `m`
                                                            )->a( n = `text` v = `PO Box 32114`
                                                    )->end(
                                                )->end(

                                                )->ele( n = `FormElement` ns = `forms`
                                                    )->a( n = `label` v = `Office Address`
                                                    )->ele( n = `fields` ns = `forms`
                                                        )->tag( n = `Text` ns = `m`
                                                            )->a( n = `text` v = `4311 Green Street`
                                                    )->end(
                                                )->end(

                                                )->ele( n = `FormElement` ns = `forms`
                                                    )->a( n = `label` v = `Office Mailing Address`
                                                    )->ele( n = `fields` ns = `forms`
                                                        )->tag( n = `Text` ns = `m`
                                                            )->a( n = `text` v = `PO Box 95493`
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(

                                        )->ele( n = `FormContainer` ns = `forms`
                                            )->a( n = `id`    v = `socialInfo`
                                            )->a( n = `title` v = `Social Accounts`
                                            )->ele( n = `formElements` ns = `forms`

                                                )->ele( n = `FormElement` ns = `forms`
                                                    )->a( n = `label` v = `LinkedIn`
                                                    )->ele( n = `fields` ns = `forms`
                                                        )->tag( n = `Text` ns = `m`
                                                            )->a( n = `text` v = `/DeniseSmith`
                                                    )->end(
                                                )->end(

                                                )->ele( n = `FormElement` ns = `forms`
                                                    )->a( n = `label` v = `Twitter`
                                                    )->ele( n = `fields` ns = `forms`
                                                        )->tag( n = `Text` ns = `m`
                                                            )->a( n = `text` v = `@DeniseSmith`
                                                    )->end(
                                                )->end(

                                                )->ele( n = `FormElement` ns = `forms`
                                                    )->a( n = `label` v = `Facebook`
                                                    )->ele( n = `fields` ns = `forms`
                                                        )->tag( n = `Text` ns = `m`
                                                            )->a( n = `text` v = `/DenisSmith`
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(

                                " blockcolor:BlockBlue - a bare coloured html:div
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Arbitrary block content...`

                                " blockcolor:BlockBlue - a bare coloured html:div
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Arbitrary block content...`

                                " blockcolor:BlockBlue - a bare coloured html:div
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Arbitrary block content...`

                                " blockcolor:BlockBlue - a bare coloured html:div
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Arbitrary block content...`

                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Employment`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Employment`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " employment:BlockJobInfo (columnLayout="3") inlined
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `editable` v = `true`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `General`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Job classification`
                                    )->tag( n = `Input` ns = `m`
                                        )->a( n = `value` v = `Senior Ui Developer (UIDEV-SR)`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Pay Grade`
                                    )->tag( n = `Input` ns = `m`
                                        )->a( n = `value` v = `Salary Grade 18 (GR-14)`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Job title`
                                    )->tag( n = `Input` ns = `m`
                                        )->a( n = `value` v = `Developer`
                                )->end(

                                " blockcolor:BlockBlue - a bare coloured html:div
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Arbitrary block content...`

                                " blockcolor:BlockBlue - a bare coloured html:div
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Arbitrary block content...`

                                " blockcolor:BlockBlue - a bare coloured html:div
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Arbitrary block content...`

                                " blockcolor:BlockBlue - a bare coloured html:div
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Arbitrary block content...`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
