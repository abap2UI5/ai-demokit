" @keywords objectpageheader object header sap.uxap alternativeprofileobjectpageheader objectpagelayout objectpageheaderactionbutton objectpagesection objectpagesubsection responsivepopover label
CLASS z2ui5_cl_smpc_app_414 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " handlePress toggles ObjectPageLayout.showHeaderContent - two-way bound here
    DATA show_header_content TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_414 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      " the original never sets showHeaderContent in the view - the UI5 default is true
      show_header_content = abap_true.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 217/188/178/161 precedent, CAPABILITIES 'Custom
    " BlockBase blocks in a sap.uxap.ObjectPageLayout'): the original blocks and
    " moreBlocks aggregations hold custom BlockBase controls from the sample's
    " SharedBlocks JS - a BlockBase is only a lazy-loading wrapper around a view,
    " so each block's content (a sap.ui.layout.form.SimpleForm) is inlined here.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `height`       v = `100%`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                       v = `ObjectPageLayout`
            )->a( n = `showTitleInHeaderContent` v = `true`
            " handlePress toggles the header content imperatively; bound two-way instead
            )->a( n = `showHeaderContent`        v = client->_bind( show_header_content )

            )->ele( `headerTitle`
                )->ele( `ObjectPageHeader`
                    )->a( n = `id`                            v = `headerForTest`
                    )->a( n = `objectTitle`                   v = `Denise Smith`
                    )->a( n = `showTitleSelector`             v = `true`
                    )->a( n = `showMarkers`                   v = `true`
                    )->a( n = `markFavorite`                  v = `true`
                    )->a( n = `markFlagged`                   v = `true`
                    )->a( n = `markChanges`                   v = `true`
                    " handleMarkChangesPress: unsaved-changes popover, anchored at the pressed control
                    )->a( n = `markChangesPress`              v = client->_event( val   = `MARK_CHANGES_PRESS`
                                                                                  t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                    )->a( n = `objectSubtitle`                v = `Senior Developer`
                    " asset URI absolutized to the OpenUI5 host per the offline asset-URL rule
                    )->a( n = `objectImageURI`                v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_273624.png`
                    )->a( n = `objectImageShape`              v = `Circle`
                    )->a( n = `isObjectTitleAlwaysVisible`    v = `false`
                    )->a( n = `isObjectSubtitleAlwaysVisible` v = `false`
                    )->a( n = `showPlaceholder`               v = `true`

                    )->ele( `actions`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `text`    v = `Public Profile`
                            )->a( n = `icon`    v = `sap-icon://edit`
                            )->a( n = `press`   v = client->_event( `TOGGLE_HEADER_CONTENT` )
                            )->a( n = `tooltip` v = `edit`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `text`    v = `Take Action`
                            )->a( n = `icon`    v = `sap-icon://action`
                            )->a( n = `tooltip` v = `action`

                    )->end(
                )->end(
            )->end(

            )->ele( `headerContent`
                )->ele( n = `VerticalLayout` ns = `layout`
                    )->tag( n = `Link` ns = `m`
                        )->a( n = `text` v = `denise-smith`
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `(321) 123-4567`
                    )->tag( n = `Link` ns = `m`
                        )->a( n = `text` v = `DeniseSmith@sap.com`

                    )->ele( n = `HorizontalLayout` ns = `layout`
                        )->tag( n = `Image` ns = `m`
                            )->a( n = `height` v = `24px`
                            )->a( n = `width`  v = `24px`
                            )->a( n = `src`    v = `https://sdk.openui5.org/test-resources/sap/uxap/images/twitterIcon.png`
                        )->tag( n = `Image` ns = `m`
                            )->a( n = `height` v = `24px`
                            )->a( n = `width`  v = `24px`
                            )->a( n = `src`    v = `https://sdk.openui5.org/test-resources/sap/uxap/images/linkedInIcon.png`

                    )->end(
                )->end(

                )->tag( n = `Text` ns = `m`
                    )->a( n = `width` v = `200px`
                    )->a( n = `text`  v = `Hi, I'm Denise. I am passionate about what I do and I'll go the extra mile to make the customer win.`

                )->ele( n = `VerticalLayout` ns = `layout`
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `Profile completion`
                    )->tag( n = `ProgressIndicator` ns = `m`
                        )->a( n = `percentValue` v = `30`
                        )->a( n = `displayValue` v = `30%`
                        )->a( n = `showValue`    v = `true`
                        )->a( n = `state`        v = `None`

                )->end(
            )->end(

            )->ele( `sections`
                )->ele( `ObjectPageSection`
                    )->a( n = `title` v = `2014 Goals Plan`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
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
                    )->a( n = `title` v = `Personal`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title` v = `Connect`

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
                            )->a( n = `id`    v = `paymentSubSection`
                            )->a( n = `title` v = `Payment information`

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

    CASE client->get_event( ).

      WHEN `TOGGLE_HEADER_CONTENT`.
        " handlePress: the original toggles the layout's showHeaderContent state
        show_header_content = xsdbool( show_header_content = abap_false ).

      WHEN `MARK_CHANGES_PRESS`.
        " handleMarkChangesPress: the PopoverUnsavedChanges fragment, built
        " server-side and opened anchored at the pressed header control
        DATA(popover) = z2ui5_cl_ui5_view_builder=>factory( ).
        popover->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`

            )->ele( `ResponsivePopover`
                )->a( n = `title`     v = `Unsaved changes`
                )->a( n = `class`     v = `sapUiContentPadding`
                )->a( n = `placement` v = `Bottom`

                )->ele( `content`
                    )->tag( `Label`
                        )->a( n = `text` v = `Another user changes this [entity] without saving changes!` ).

        client->popover_display( xml   = popover->stringify( )
                                 by_id = client->get_event_arg( ) ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
