" @keywords flexiblecolumnlayout flexible column layout sap.f flexiblecolumnlayoutcolumnresize objectpagelayout objectpagedynamicheadertitle title objectpagesection objectpagesubsection button
" @summary FlexibleColumnLayout where the app programmatically scrolls to some item within the newly navigated column, once the column is fully resized
CLASS z2ui5_cl_smpc_app_577 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_section,
             tablename   TYPE string,
             sectionname TYPE string,
           END OF ty_s_section.
    TYPES ty_t_section TYPE STANDARD TABLE OF ty_s_section WITH EMPTY KEY.

    DATA t_sections TYPE ty_t_section.
    " the FlexibleColumnLayout state the router drives in the original
    DATA layout     TYPE string VALUE `OneColumn`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_577 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    DATA(fcl) = view->ele( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:f`      v = `sap.f`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:uxap`   v = `sap.uxap`

        )->ele( n = `FlexibleColumnLayout` ns = `f`
            )->a( n = `id`                           v = `fcl`
            )->a( n = `autoFocus`                    v = `false`
            )->a( n = `restoreFocusOnBackNavigation` v = `true`
            )->a( n = `backgroundDesign`             v = `Translucent`
            )->a( n = `layout`                       v = client->_bind( layout ) ).

    " List.view.xml - the ObjectPage whose sections come from the model
    fcl->ele( n = `beginColumnPages` ns = `f`
        )->ele( n = `ObjectPageLayout` ns = `uxap`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`
            )->a( n = `sections`           v = client->_bind( t_sections )

            )->ele( n = `headerTitle` ns = `uxap`
                )->ele( n = `ObjectPageDynamicHeaderTitle` ns = `uxap`
                    )->ele( n = `heading` ns = `uxap`
                        )->tag( `Title`
                            )->a( n = `text` v = `Sections`

                    )->end(
                )->end(
            )->end(
            )->ele( n = `sections` ns = `uxap`
                )->ele( n = `ObjectPageSection` ns = `uxap`
                    )->a( n = `title` v = `{SECTIONNAME}`

                    )->ele( n = `subSections` ns = `uxap`
                        )->ele( n = `ObjectPageSubSection` ns = `uxap`

                            )->ele( n = `actions` ns = `uxap`
                                )->tag( `Button`
                                    )->a( n = `text`  v = `To Detail`
                                    )->a( n = `press` v = client->_event( `TO_DETAIL` )

                            )->end(
                            )->ele( n = `blocks` ns = `uxap`
                                )->ele( n = `SimpleForm` ns = `form`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( `Label`
                                        )->a( n = `text` v = `Content`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `some content goes here...`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(
    )->end( ).

    " Detail.view.xml - the DynamicPage of the mid column
    fcl->ele( n = `midColumnPages` ns = `f`
        )->ele( n = `DynamicPage` ns = `f`
            )->a( n = `id`                       v = `dynamicPageId`
            )->a( n = `toggleHeaderOnTitleClick` v = `false`

            )->ele( n = `title` ns = `f`
                )->ele( n = `DynamicPageTitle` ns = `f`
                    )->ele( n = `heading` ns = `f`
                        )->tag( `Title`
                            )->a( n = `text` v = `Details Page`

                    )->end(
                    )->ele( n = `navigationActions` ns = `f`
                        )->tag( `Button`
                            )->a( n = `icon`    v = `sap-icon://decline`
                            )->a( n = `tooltip` v = `Close column`
                            )->a( n = `type`    v = `Transparent`
                            )->a( n = `press`   v = client->_event( `CLOSE_COLUMN` )

                    )->end(
                )->end(
            )->end(
            )->ele( n = `header` ns = `f`
                )->ele( n = `DynamicPageHeader` ns = `f`
                    )->a( n = `pinnable` v = `false`

                    )->ele( n = `HorizontalLayout` ns = `layout`
                        )->a( n = `allowWrapping` v = `true`

                        )->ele( n = `VerticalLayout` ns = `layout`
                            )->a( n = `class` v = `sapUiMediumMarginEnd`

                            )->tag( `ObjectAttribute`
                                )->a( n = `title` v = `Location`
                                )->a( n = `text`  v = `Warehouse A`
                            )->tag( `ObjectAttribute`
                                )->a( n = `title` v = `Halway`
                                )->a( n = `text`  v = `23L`
                            )->tag( `ObjectAttribute`
                                )->a( n = `title` v = `Rack`
                                )->a( n = `text`  v = `34`

                        )->end(
                        )->ele( n = `VerticalLayout` ns = `layout`

                            )->tag( `ObjectAttribute`
                                )->a( n = `title` v = `Availability`
                            )->tag( `ObjectStatus`
                                )->a( n = `text`  v = `In Stock`
                                )->a( n = `state` v = `Success`

                        )->end(
                    )->end(
                )->end(
            )->end(
            )->ele( n = `content` ns = `f`
                )->tag( `MessageStrip`
                    )->a( n = `type` v = `Success`
                    )->a( n = `text` v = `Close this column to return to the previous page and resume its scroll position`

            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `TO_DETAIL`.
        " toDetail: navTo('detail') with the helper's next layout for level 1
        layout = `MidColumnFullScreen`.

      WHEN `CLOSE_COLUMN`.
        " handleClose: navTo('list') with the helper's closeColumn layout
        layout = `OneColumn`.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " webapp/data/sections.json - the twelve sections
    t_sections = VALUE #(
      ( tablename = `Navigate to section 0`  sectionname = `Section 0` )
      ( tablename = `Navigate to section 1`  sectionname = `Section 1` )
      ( tablename = `Navigate to section 2`  sectionname = `Section 2` )
      ( tablename = `Navigate to section 3`  sectionname = `Section 3` )
      ( tablename = `Navigate to section 4`  sectionname = `Section 4` )
      ( tablename = `Navigate to section 5`  sectionname = `Section 5` )
      ( tablename = `Navigate to section 6`  sectionname = `Section 6` )
      ( tablename = `Navigate to section 7`  sectionname = `Section 7` )
      ( tablename = `Navigate to section 8`  sectionname = `Section 8` )
      ( tablename = `Navigate to section 9`  sectionname = `Section 9` )
      ( tablename = `Navigate to section 10` sectionname = `Section 10` )
      ( tablename = `Navigate to section 11` sectionname = `Section 11` ) ).

  ENDMETHOD.

ENDCLASS.
