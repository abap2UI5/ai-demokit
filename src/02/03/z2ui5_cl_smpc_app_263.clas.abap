" @keywords objectpagelayout object layout sap.uxap objectpageresetselectedsection navcontainer verticallayout messagestrip list standardlistitem checkbox objectpagedynamicheadertitle
" @summary Object Page sample showing how to ensure the page is always scrolled to the top on any subsequent navigation to the page, regardless of its previously selected section in the preceding navigation.
CLASS z2ui5_cl_smpc_app_263 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_employee,
        name    TYPE string,
        job     TYPE string,
        picture TYPE string,
      END OF ty_s_employee.

    DATA reset_check TYPE abap_bool.
    DATA t_employees TYPE STANDARD TABLE OF ty_s_employee WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_263 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 LIKE LINE OF t_employees.
    DATA temp4 LIKE sy-tabix.
    DATA temp5 LIKE LINE OF t_employees.
    DATA temp6 LIKE sy-tabix.
    DATA temp7 LIKE LINE OF t_employees.
    DATA temp8 LIKE sy-tabix.
    DATA temp9 LIKE LINE OF t_employees.
    DATA temp10 LIKE sy-tabix.
    DATA temp11 LIKE LINE OF t_employees.
    DATA temp12 LIKE sy-tabix.
    DATA temp13 LIKE LINE OF t_employees.
    DATA temp14 LIKE sy-tabix.
    DATA temp15 LIKE LINE OF t_employees.
    DATA temp16 LIKE sy-tabix.
    DATA temp17 LIKE LINE OF t_employees.
    DATA temp18 LIKE sy-tabix.
    DATA temp19 LIKE LINE OF t_employees.
    DATA temp20 LIKE sy-tabix.
    DATA temp21 LIKE LINE OF t_employees.
    DATA temp22 LIKE sy-tabix.
    DATA temp23 LIKE LINE OF t_employees.
    DATA temp24 LIKE sy-tabix.
    DATA temp25 LIKE LINE OF t_employees.
    DATA temp26 LIKE sy-tabix.
    DATA temp27 LIKE LINE OF t_employees.
    DATA temp28 LIKE sy-tabix.
    DATA temp29 LIKE LINE OF t_employees.
    DATA temp30 LIKE sy-tabix.
    DATA temp31 LIKE LINE OF t_employees.
    DATA temp32 LIKE sy-tabix.
    DATA temp33 LIKE LINE OF t_employees.
    DATA temp34 LIKE sy-tabix.
    DATA temp35 LIKE LINE OF t_employees.
    DATA temp36 LIKE sy-tabix.
    DATA temp37 LIKE LINE OF t_employees.
    DATA temp38 LIKE sy-tabix.
    DATA temp39 LIKE LINE OF t_employees.
    DATA temp40 LIKE sy-tabix.
    DATA temp41 LIKE LINE OF t_employees.
    DATA temp42 LIKE sy-tabix.
    DATA temp43 LIKE LINE OF t_employees.
    DATA temp44 LIKE sy-tabix.
    DATA temp45 LIKE LINE OF t_employees.
    DATA temp46 LIKE sy-tabix.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " Navigation: _navTo(page) is the client-side NavContainer.to() - wired
    " roundtrip-free via follow_up_action( control_by_id ). The navigate event
    " itself goes to the backend (NAVIGATE) because onNavigate reads the
    " checkbox state before resetting the ObjectPage's selected section.
    " Blocks: every SharedBlocks BlockBase is inlined with its view content
    " (app 188/217 precedent); the empN> named models the ModelMapping
    " elements feed are folded onto ONE table, addressed per row by the cell
    " binding, so the model keeps the /Employee array shape (app 230).
    
    CLEAR temp1.
    INSERT `navigationContainer` INTO TABLE temp1.
    INSERT `to` INTO TABLE temp1.
    INSERT `page2` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `navigationContainer` INTO TABLE temp2.
    INSERT `to` INTO TABLE temp2.
    INSERT `page1` INTO TABLE temp2.
    
    
    temp4 = sy-tabix.
    READ TABLE t_employees INDEX 1 INTO temp3.
    sy-tabix = temp4.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp6 = sy-tabix.
    READ TABLE t_employees INDEX 1 INTO temp5.
    sy-tabix = temp6.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp8 = sy-tabix.
    READ TABLE t_employees INDEX 2 INTO temp7.
    sy-tabix = temp8.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp10 = sy-tabix.
    READ TABLE t_employees INDEX 2 INTO temp9.
    sy-tabix = temp10.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp12 = sy-tabix.
    READ TABLE t_employees INDEX 1 INTO temp11.
    sy-tabix = temp12.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp14 = sy-tabix.
    READ TABLE t_employees INDEX 1 INTO temp13.
    sy-tabix = temp14.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp16 = sy-tabix.
    READ TABLE t_employees INDEX 1 INTO temp15.
    sy-tabix = temp16.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp18 = sy-tabix.
    READ TABLE t_employees INDEX 2 INTO temp17.
    sy-tabix = temp18.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp20 = sy-tabix.
    READ TABLE t_employees INDEX 2 INTO temp19.
    sy-tabix = temp20.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp22 = sy-tabix.
    READ TABLE t_employees INDEX 2 INTO temp21.
    sy-tabix = temp22.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp24 = sy-tabix.
    READ TABLE t_employees INDEX 3 INTO temp23.
    sy-tabix = temp24.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp26 = sy-tabix.
    READ TABLE t_employees INDEX 3 INTO temp25.
    sy-tabix = temp26.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp28 = sy-tabix.
    READ TABLE t_employees INDEX 3 INTO temp27.
    sy-tabix = temp28.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp30 = sy-tabix.
    READ TABLE t_employees INDEX 4 INTO temp29.
    sy-tabix = temp30.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp32 = sy-tabix.
    READ TABLE t_employees INDEX 4 INTO temp31.
    sy-tabix = temp32.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp34 = sy-tabix.
    READ TABLE t_employees INDEX 4 INTO temp33.
    sy-tabix = temp34.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp36 = sy-tabix.
    READ TABLE t_employees INDEX 5 INTO temp35.
    sy-tabix = temp36.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp38 = sy-tabix.
    READ TABLE t_employees INDEX 5 INTO temp37.
    sy-tabix = temp38.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp40 = sy-tabix.
    READ TABLE t_employees INDEX 5 INTO temp39.
    sy-tabix = temp40.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp42 = sy-tabix.
    READ TABLE t_employees INDEX 6 INTO temp41.
    sy-tabix = temp42.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp44 = sy-tabix.
    READ TABLE t_employees INDEX 6 INTO temp43.
    sy-tabix = temp44.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp46 = sy-tabix.
    READ TABLE t_employees INDEX 6 INTO temp45.
    sy-tabix = temp46.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:forms`  v = `sap.ui.layout.form`

        )->ele( n = `NavContainer` ns = `m`
            )->a( n = `id`       v = `navigationContainer`
            )->a( n = `navigate` v = client->_event( val = `NAVIGATE` arg = `${$parameters>/toId}` )

            )->ele( n = `Page` ns = `m`
                )->a( n = `id`    v = `page1`
                )->a( n = `title` v = `Page 1`

                )->ele( n = `VerticalLayout` ns = `layout`
                    )->a( n = `class` v = `sapUiContentPadding`
                    )->a( n = `width` v = `100%`

                    )->tag( n = `MessageStrip` ns = `m`
                        )->a( n = `showIcon` v = `true`
                        )->a( n = `text`     v = `This example shows how to reset the selected section of the ObjectPage `
                                              && `to the first visible and scroll to the top upon revisiting the page.`

                    )->ele( n = `List` ns = `m`
                        )->tag( n = `StandardListItem` ns = `m`
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                            t_arg = temp1 )
                            )->a( n = `title` v = `To ObjectPage`
                            )->a( n = `type`  v = `Navigation`

                    )->end(

                    )->tag( n = `CheckBox` ns = `m`
                        )->a( n = `id`       v = `resetCheck`
                        )->a( n = `selected` v = client->_bind( reset_check )
                        )->a( n = `text`     v = `reset its selected section to the first visible and scroll to the top`

                )->end(
            )->end(

            )->ele( n = `Page` ns = `m`
                )->a( n = `id`              v = `page2`
                )->a( n = `title`           v = `Page 2`
                )->a( n = `showNavButton`   v = `true`
                )->a( n = `navButtonPress`  v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                          t_arg = temp2 )

                )->ele( `ObjectPageLayout`
                    )->a( n = `id`                       v = `ObjectPageLayout`
                    )->a( n = `enableLazyLoading`        v = `true`
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

                            )->end(

                            )->ele( n = `HorizontalLayout` ns = `layout`
                                )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                                )->tag( n = `Image` ns = `m`
                                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/uxap/images/linkedin.png`
                                )->tag( n = `Image` ns = `m`
                                    )->a( n = `src`   v = `https://sdk.openui5.org/test-resources/sap/uxap/images/Twitter.png`
                                    )->a( n = `class` v = `sapUiSmallMarginBegin`

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
                            )->a( n = `id`             v = `goals`
                            )->a( n = `title`          v = `2014 Goals Plan`

                            )->ele( `subSections`
                                )->ele( `ObjectPageSubSection`
                                    )->a( n = `id`             v = `goalsSS1`
                                    )->a( n = `titleUppercase` v = `false`

                                    )->ele( `blocks`

                                        " goals:GoalsBlock inlined
                                        )->ele( n = `SimpleForm` ns = `forms`
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
                            )->a( n = `titleUppercase` v = `false`
                            )->a( n = `id`             v = `personal`
                            )->a( n = `title`          v = `Personal`

                            )->ele( `subSections`
                                )->ele( `ObjectPageSubSection`
                                    )->a( n = `id`             v = `personalSS1`
                                    )->a( n = `title`          v = `Connect`
                                    )->a( n = `titleUppercase` v = `false`

                                    )->ele( `blocks`

                                        " personal:BlockPhoneNumber inlined
                                        )->ele( n = `SimpleForm` ns = `forms`
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

                                        " personal:BlockSocial inlined
                                        )->ele( n = `SimpleForm` ns = `forms`
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

                                        " personal:BlockAdresses inlined
                                        )->ele( n = `SimpleForm` ns = `forms`
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

                                        " personal:BlockMailing inlined
                                        )->ele( n = `SimpleForm` ns = `forms`
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
                                    )->a( n = `id`             v = `personalSS2`
                                    )->a( n = `title`          v = `Payment information`
                                    )->a( n = `titleUppercase` v = `false`

                                    )->ele( `blocks`

                                        " personal:PersonalBlockPart1 inlined
                                        )->ele( n = `SimpleForm` ns = `forms`
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

                                        " personal:PersonalBlockPart2 inlined
                                        )->ele( n = `SimpleForm` ns = `forms`
                                            )->a( n = `editable` v = `false`
                                            )->a( n = `layout`   v = `ColumnLayout`

                                            )->tag( n = `Title` ns = `core`
                                                )->a( n = `text` v = `Payment method for Expenses`
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Extra Travel Expenses`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Cash 100 USD`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(

                        )->ele( `ObjectPageSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->a( n = `id`             v = `employment`
                            )->a( n = `title`          v = `Employment`

                            )->ele( `subSections`
                                )->ele( `ObjectPageSubSection`
                                    )->a( n = `id`             v = `employmentSS1`
                                    )->a( n = `title`          v = `Job information`
                                    )->a( n = `titleUppercase` v = `false`

                                    )->ele( `blocks`

                                        " employment:BlockJobInfoPart1 inlined
                                        )->ele( n = `SimpleForm` ns = `forms`
                                            )->a( n = `labelSpanL`       v = `4`
                                            )->a( n = `labelSpanM`       v = `4`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `labelSpanS`       v = `4`
                                            )->a( n = `emptySpanL`       v = `0`
                                            )->a( n = `emptySpanM`       v = `0`
                                            )->a( n = `emptySpanS`       v = `0`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `width`            v = `100%`

                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Job classification`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Senior Ui Developer (UIDEV-SR)`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = ` `
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Pay Grade`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Salary Grade 18 (GR-14)`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = ` `
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Job title`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Developer`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = ` `
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Local Job Title`
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Ui Developer`

                                        )->end(

                                        " employment:BlockJobInfoPart2 inlined
                                        )->ele( n = `SimpleForm` ns = `forms`
                                            )->a( n = `labelSpanL`       v = `4`
                                            )->a( n = `labelSpanM`       v = `4`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `labelSpanS`       v = `4`
                                            )->a( n = `emptySpanL`       v = `0`
                                            )->a( n = `emptySpanM`       v = `0`
                                            )->a( n = `emptySpanS`       v = `0`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `width`            v = `100%`

                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Employee Class`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Employee`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = ` `
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `FTE`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `1`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = ` `
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Standard Weekly Hours`
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `40`

                                        )->end(

                                        " employment:BlockJobInfoPart3 inlined
                                        )->ele( n = `HorizontalLayout` ns = `layout`
                                            )->a( n = `class` v = `sapUiSmallMarginTop`

                                            )->ele( n = `VerticalLayout` ns = `layout`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Manager`

                                                )->ele( n = `HorizontalLayout` ns = `layout`
                                                    )->ele( n = `content` ns = `layout`
                                                        )->ele( n = `VerticalLayout` ns = `layout`
                                                            )->tag( n = `Text` ns = `m`
                                                                )->a( n = `text` v = `James Smith`
                                                            )->tag( n = `Text` ns = `m`
                                                                )->a( n = `text` v = `Development Manager`

                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(

                                )->ele( `ObjectPageSubSection`
                                    )->a( n = `id`             v = `employmentSS2`
                                    )->a( n = `title`          v = `Employee Details`
                                    )->a( n = `titleUppercase` v = `false`

                                    )->ele( `blocks`

                                        " employment:BlockEmpDetailPart1 inlined
                                        )->ele( n = `SimpleForm` ns = `forms`
                                            )->a( n = `labelSpanL`       v = `4`
                                            )->a( n = `labelSpanM`       v = `4`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `labelSpanS`       v = `4`
                                            )->a( n = `emptySpanL`       v = `0`
                                            )->a( n = `emptySpanM`       v = `0`
                                            )->a( n = `emptySpanS`       v = `0`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `width`            v = `100%`

                                            )->tag( n = `Title` ns = `core`
                                                )->a( n = `text` v = `Termination information`
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Ok to return`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `No`
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Regret Termination`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Yes`

                                        )->end(
                                    )->end(

                                    )->ele( `moreBlocks`

                                        " employment:BlockEmpDetailPart2 inlined
                                        )->ele( n = `SimpleForm` ns = `forms`
                                            )->a( n = `labelSpanL`       v = `4`
                                            )->a( n = `labelSpanM`       v = `4`
                                            )->a( n = `labelSpanS`       v = `4`
                                            )->a( n = `emptySpanL`       v = `0`
                                            )->a( n = `emptySpanM`       v = `0`
                                            )->a( n = `emptySpanS`       v = `0`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `width`            v = `100%`

                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Start Date`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jan 01, 2001`
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `End Date`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jun 30, 2014`
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Last Date Worked`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jun 01, 2014`
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Payroll End Date`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jun 01, 2014`

                                        )->end(

                                        " employment:BlockEmpDetailPart3 inlined
                                        )->ele( n = `SimpleForm` ns = `forms`
                                            )->a( n = `labelSpanL`       v = `4`
                                            )->a( n = `labelSpanM`       v = `4`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `labelSpanS`       v = `4`
                                            )->a( n = `emptySpanL`       v = `0`
                                            )->a( n = `emptySpanM`       v = `0`
                                            )->a( n = `emptySpanS`       v = `0`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `width`            v = `100%`

                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Payroll End Date`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jan 01, 2014`
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Benefits End Date`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jun 30, 2014`
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Stock End Date`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `Jun 01, 2014`
                                            )->tag( n = `Label` ns = `m`
                                                )->a( n = `text` v = `Eligible for Salary Contribution`
                                            )->tag( n = `Text` ns = `m`
                                                )->a( n = `text` v = `No`

                                        )->end(
                                    )->end(
                                )->end(

                                )->ele( `ObjectPageSubSection`
                                    )->a( n = `id`             v = `employmentSS3`
                                    )->a( n = `title`          v = `Job Relationship`
                                    )->a( n = `titleUppercase` v = `false`

                                    )->ele( `blocks`

                                        " employment:EmploymentBlockJob inlined
                                        " with its Collapsed view (the block's
                                        " initial mode); emp1>/emp2> are rows
                                        " 1-2 of the one seeded table
                                        )->ele( n = `Grid` ns = `layout`
                                            )->a( n = `defaultSpan` v = `L4 M6 S12`
                                            )->a( n = `hSpacing`    v = `0`
                                            )->a( n = `width`       v = `100%`

                                            )->ele( n = `content` ns = `layout`
                                                )->ele( n = `VerticalLayout` ns = `layout`
                                                    )->ele( n = `HorizontalLayout` ns = `layout`
                                                        )->ele( n = `Grid` ns = `layout`
                                                            )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                            )->a( n = `hSpacing`    v = `0`
                                                            )->a( n = `width`       v = `100%`

                                                            )->ele( n = `content` ns = `layout`
                                                                )->ele( n = `VerticalLayout` ns = `layout`
                                                                    )->tag( n = `Label` ns = `m`
                                                                        )->a( n = `text` v = client->_bind( val = temp3-name tab = t_employees tab_index = 1 )
                                                                    )->tag( n = `Label` ns = `m`
                                                                        )->a( n = `text` v = client->_bind( val = temp5-job tab = t_employees tab_index = 1 )

                                                                    )->ele( n = `layoutData` ns = `layout`
                                                                        )->tag( n = `GridData` ns = `layout`
                                                                            )->a( n = `span` v = `L12 M12 S12`

                                                                    )->end(
                                                                )->end(
                                                            )->end(
                                                        )->end(
                                                    )->end(

                                                    )->ele( n = `layoutData` ns = `layout`
                                                        )->tag( n = `GridData` ns = `layout`
                                                            )->a( n = `linebreak` v = `true`

                                                    )->end(

                                                    )->ele( n = `HorizontalLayout` ns = `layout`
                                                        )->ele( n = `Grid` ns = `layout`
                                                            )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                            )->a( n = `hSpacing`    v = `0`
                                                            )->a( n = `width`       v = `100%`

                                                            )->ele( n = `VerticalLayout` ns = `layout`
                                                                )->tag( n = `Label` ns = `m`
                                                                    )->a( n = `text` v = client->_bind( val = temp7-name tab = t_employees tab_index = 2 )
                                                                )->tag( n = `Label` ns = `m`
                                                                    )->a( n = `text` v = client->_bind( val = temp9-job tab = t_employees tab_index = 2 )

                                                                )->ele( n = `layoutData` ns = `layout`
                                                                    )->tag( n = `GridData` ns = `layout`
                                                                        )->a( n = `span` v = `L12 M12 S12`

                                                                )->end(
                                                            )->end(
                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(

                        )->ele( `ObjectPageSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->a( n = `id`             v = `connections`
                            )->a( n = `title`          v = `Connections`

                            )->ele( `subSections`
                                )->ele( `ObjectPageSubSection`
                                    )->a( n = `id`             v = `connectionsSS1`
                                    )->a( n = `titleUppercase` v = `false`

                                    )->ele( `blocks`

                                        " connections:ConnectionsBlock inlined -
                                        " six Panels over emp1>..emp6>, which
                                        " are the six rows of one table
                                        )->ele( n = `Panel` ns = `m`
                                            )->ele( n = `VBox` ns = `m`
                                                )->tag( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( val = temp11-picture tab = t_employees tab_index = 1 )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( val = temp13-name tab = t_employees tab_index = 1 )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( val = temp15-job tab = t_employees tab_index = 1 )

                                            )->end(
                                        )->end(

                                        )->ele( n = `Panel` ns = `m`
                                            )->ele( n = `VBox` ns = `m`
                                                )->tag( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( val = temp17-picture tab = t_employees tab_index = 2 )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( val = temp19-name tab = t_employees tab_index = 2 )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( val = temp21-job tab = t_employees tab_index = 2 )

                                            )->end(
                                        )->end(

                                        )->ele( n = `Panel` ns = `m`
                                            )->ele( n = `VBox` ns = `m`
                                                )->tag( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( val = temp23-picture tab = t_employees tab_index = 3 )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( val = temp25-name tab = t_employees tab_index = 3 )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( val = temp27-job tab = t_employees tab_index = 3 )

                                            )->end(
                                        )->end(

                                        )->ele( n = `Panel` ns = `m`
                                            )->ele( n = `VBox` ns = `m`
                                                )->tag( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( val = temp29-picture tab = t_employees tab_index = 4 )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( val = temp31-name tab = t_employees tab_index = 4 )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( val = temp33-job tab = t_employees tab_index = 4 )

                                            )->end(
                                        )->end(

                                        )->ele( n = `Panel` ns = `m`
                                            )->ele( n = `VBox` ns = `m`
                                                )->tag( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( val = temp35-picture tab = t_employees tab_index = 5 )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( val = temp37-name tab = t_employees tab_index = 5 )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( val = temp39-job tab = t_employees tab_index = 5 )

                                            )->end(
                                        )->end(

                                        )->ele( n = `Panel` ns = `m`
                                            )->ele( n = `VBox` ns = `m`
                                                )->tag( n = `Image` ns = `m`
                                                    )->a( n = `src` v = client->_bind( val = temp41-picture tab = t_employees tab_index = 6 )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( val = temp43-name tab = t_employees tab_index = 6 )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = client->_bind( val = temp45-job tab = t_employees tab_index = 6 )

                                        ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA temp3 TYPE string_table.

    " onNavigate: when page2 becomes the destination and the checkbox is
    " ticked, the controller calls setSelectedSection(null) so the page
    " reopens on its first visible section. Reproduced 1:1 since the
    " association setters take an EMPTY argument as null (the
    " controlIdOrNull argument kind); the earlier substitute - naming the
    " first section explicitly - is gone.
    IF client->get_event( ) = `NAVIGATE`
        AND reset_check = abap_true
        AND client->get_event_arg( ) CS `page2`.
      
      CLEAR temp3.
      INSERT `ObjectPageLayout` INTO TABLE temp3.
      INSERT `setSelectedSection` INTO TABLE temp3.
      INSERT `` INTO TABLE temp3.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp3 ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.
    DATA temp5 LIKE t_employees.
    DATA temp6 LIKE LINE OF temp5.

    " SharedJSONData/HRData.json /Employee rows 0-5, the records the block
    " ModelMapping elements map onto the internal models emp1>..emp6> - one
    " table, so the model keeps the array shape the original addresses and the
    " view addresses it per row (client->_bind( tab / tab_index ))
    reset_check = abap_true.
    
    CLEAR temp5.
    
    temp6-name = `Michael Adams`.
    temp6-job = `Scrum Master`.
    temp6-picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `John Miller`.
    temp6-job = `Product Owner`.
    temp6-picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Richard Wilson`.
    temp6-job = `Ux Designer`.
    temp6-picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Julie Armstrong`.
    temp6-job = `Quality Engineer`.
    temp6-picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Denise Smith`.
    temp6-job = `Team Member`.
    temp6-picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Richard Adams`.
    temp6-job = `Team Member`.
    temp6-picture = `https://sdk.openui5.org/test-resources/sap/uxap/images/person.png`.
    INSERT temp6 INTO TABLE temp5.
    t_employees = temp5.

  ENDMETHOD.

ENDCLASS.
