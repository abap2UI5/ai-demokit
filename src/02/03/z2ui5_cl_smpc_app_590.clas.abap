" @keywords objectpagelayout formfocusableinput sap.uxap simpleform columnlayout columnelementdata focus objectpagesection
CLASS z2ui5_cl_smpc_app_590 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_590 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) OR client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 401/416 precedent): the six Personal sections
    " each hold one blockcolor:BlockBlue, a BlockBase around a view whose whole
    " body is a coloured html:div - inlined as the text it shows (see sidecar)
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:f`      v = `sap.ui.layout.form`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->ele( `headerTitle`
                )->ele( `ObjectPageDynamicHeaderTitle`

                    )->ele( `breadcrumbs`
                        )->ele( n = `Breadcrumbs` ns = `m`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `Page 1 a very long link`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `Page 2 long link`
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

                    )->ele( `snappedContent`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior UI Developer`
                    )->end(

                    )->ele( `expandedContent`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior UI Developer`
                    )->end(

                    )->ele( `snappedTitleOnMobile`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text` v = `Senior UI Developer`
                    )->end(

                    )->ele( `actions`
                        " handleFocusBtnPress walks the selected section's DOM for its
                        " first editable input; only the Employment form has one, so the
                        " press focuses that input by id (see sidecar)
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `type`  v = `Emphasized`
                            )->a( n = `text`  v = `Focus`
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                            t_arg = VALUE #( ( `nameInput` ) ( `focus` ) ) )
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
                    )->a( n = `title`          v = `Personal 1`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " blockcolor:BlockBlue - a bare coloured html:div
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Arbitrary block content...`
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Personal 2`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " blockcolor:BlockBlue - a bare coloured html:div
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Arbitrary block content...`
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Personal 3`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " blockcolor:BlockBlue - a bare coloured html:div
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Arbitrary block content...`
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Personal 4`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " blockcolor:BlockBlue - a bare coloured html:div
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Arbitrary block content...`
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Personal 5`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " blockcolor:BlockBlue - a bare coloured html:div
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Arbitrary block content...`
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Personal 6`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " blockcolor:BlockBlue - a bare coloured html:div
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Arbitrary block content...`
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `Employment`
                    )->a( n = `title`          v = `Employment`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `f`
                                    )->a( n = `editable`  v = `true`
                                    )->a( n = `layout`    v = `ColumnLayout`
                                    )->a( n = `columnsM`  v = `2`
                                    )->a( n = `columnsL`  v = `3`
                                    )->a( n = `columnsXL` v = `4`

                                    )->ele( n = `content` ns = `f`
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = `Name`
                                        " the Focus button's target: the first editable
                                        " input of the only section that has one
                                        )->tag( n = `Input` ns = `m`
                                            )->a( n = `id` v = `nameInput`
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = `Street/No.`
                                        )->tag( n = `Input` ns = `m`

                                        )->ele( n = `Input` ns = `m`
                                            )->ele( n = `layoutData` ns = `m`
                                                )->tag( n = `ColumnElementData` ns = `f`
                                                    )->a( n = `cellsSmall` v = `2`
                                                    )->a( n = `cellsLarge` v = `1`
                                            )->end(
                                        )->end(

                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = `ZIP Code/City`

                                        )->ele( n = `Input` ns = `m`
                                            )->ele( n = `layoutData` ns = `m`
                                                )->tag( n = `ColumnElementData` ns = `f`
                                                    )->a( n = `cellsSmall` v = `3`
                                                    )->a( n = `cellsLarge` v = `2`
                                            )->end(
                                        )->end(

                                        )->tag( n = `Input` ns = `m`
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = `Country`

                                        )->ele( n = `Select` ns = `m`
                                            )->a( n = `id` v = `country`
                                            )->ele( n = `items` ns = `m`
                                                )->tag( n = `Item` ns = `core`
                                                    )->a( n = `text` v = `England`
                                                    )->a( n = `key`  v = `England`
                                                )->tag( n = `Item` ns = `core`
                                                    )->a( n = `text` v = `Germany`
                                                    )->a( n = `key`  v = `Germany`
                                                )->tag( n = `Item` ns = `core`
                                                    )->a( n = `text` v = `USA`
                                                    )->a( n = `key`  v = `USA`
                                            )->end(
                                        )->end(

                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = `Web`
                                        )->tag( n = `Input` ns = `m`
                                            )->a( n = `type` v = `Url`
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = `Twitter`
                                        )->tag( n = `Input` ns = `m`
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = `Email`
                                        )->tag( n = `Input` ns = `m`
                                            )->a( n = `type` v = `Email`
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = `Tel.`
                                        )->tag( n = `Input` ns = `m`
                                            )->a( n = `type` v = `Tel`
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = `SMS`
                                        )->tag( n = `Input` ns = `m`
                                            )->a( n = `type` v = `Tel`
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = `Mobile`
                                        )->tag( n = `Input` ns = `m`
                                            )->a( n = `type` v = `Tel`
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = `Pager`
                                        )->tag( n = `Input` ns = `m`
                                            )->a( n = `type` v = `Tel`
                                        )->tag( n = `Label` ns = `m`
                                            )->a( n = `text` v = `Fax`
                                        )->tag( n = `Input` ns = `m`
                                            )->a( n = `type` v = `Tel`
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
