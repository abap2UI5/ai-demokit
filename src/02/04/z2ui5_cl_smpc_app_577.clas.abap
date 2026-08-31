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

    " the router state the original keeps: the current route and the section
    " index the ':section:' list route carries (this.iSectionIndex, NaN when
    " the URL names none - here -1)
    DATA route      TYPE string VALUE `list`.
    DATA section_ix TYPE i VALUE -1.

    METHODS view_display.
    METHODS on_event.
    METHODS hash_apply IMPORTING iv_hash TYPE string.
    METHODS hash_push.
    METHODS section_select.
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

    " the router also matches a deep link / reload (`#/3`, `#/detail/
    " MidColumnFullScreen`): the live hash rides in s_config-hash on every
    " request; applying it is idempotent, so a rebuild whose hash matches the
    " state simply re-derives it
    DATA(lv_hash) = client->get( )-s_config-hash.
    IF lv_hash IS NOT INITIAL AND lv_hash <> `#`.
      hash_apply( lv_hash ).
    ENDIF.

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
            " List.controller attaches columnResize on the FCL: once the begin
            " column is back to full width the indexed section is re-selected
            )->a( n = `columnResize`                 v = client->_event( val = `COLUMN_RESIZE` arg = `${$parameters>/beginColumn}` )
            )->a( n = `layout`                       v = client->_bind( layout ) ).

    " List.view.xml - the ObjectPage whose sections come from the model.
    " The original attaches the ObjectPage's navigate event to
    " _updateUrlOnNavigate, which writes indexOfSection( section ) into the
    " ':section:' route - the index is computed where the control lives
    fcl->ele( n = `beginColumnPages` ns = `f`
        )->ele( n = `ObjectPageLayout` ns = `uxap`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`
            )->a( n = `navigate`           v = client->_event( val = `NAVIGATE` arg = `${$parameters>/section}.getParent().indexOfSection(${$parameters>/section})` )
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

    " the original's router, app-owned: the hash carries the route the way
    " the manifest patterns spell it, and a hash change the app did not
    " write (browser Back/Forward, a manual edit) round-trips as
    " HASH_CHANGED. Re-asserted per render - it dies with an app switch
    client->follow_up_action( val   = client->cs_event-set_hash_listener
                              t_arg = VALUE #( ( `HASH_CHANGED` ) ) ).

    " _onListMatched on the first rendering: a deep link '#/3' selects the
    " indexed section. A rebuilt ObjectPage is back on its first section while
    " section_ix survives as class state, so the re-issue also restores what
    " the original's live control keeps natively
    IF section_ix >= 0.
      section_select( ).
    ENDIF.

  ENDMETHOD.


  METHOD section_select.

    " setSelectedSection takes a section INSTANCE (an association); the bound
    " sections are runtime clones, addressed positionally as an aggregation
    " item - <id>/<aggregation>/<index>, resolved on the client where the ids
    " are known
    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = VALUE #( ( `ObjectPageLayout` )
                                               ( `setSelectedSection` )
                                               ( |ObjectPageLayout/sections/{ section_ix }| ) ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `TO_DETAIL`.
        " toDetail: navTo('detail') with the helper's next layout for level 1
        route  = `detail`.
        layout = `MidColumnFullScreen`.
        hash_push( ).

      WHEN `CLOSE_COLUMN`.
        " handleClose: navTo('list') with the helper's closeColumn layout -
        " the ':section:' pattern carries no layout and no section, so the
        " URL goes back to the bare start (and iSectionIndex to NaN, here -1)
        route      = `list`.
        layout     = `OneColumn`.
        section_ix = -1.
        hash_push( ).

      WHEN `NAVIGATE`.
        " _updateUrlOnNavigate: the anchor-bar selection writes the section
        " index into the URL
        DATA(lv_ix) = client->get_event_arg( ).
        IF lv_ix CO `0123456789` AND lv_ix IS NOT INITIAL AND strlen( lv_ix ) <= 4.
          section_ix = lv_ix.
          route      = `list`.
          hash_push( ).
        ENDIF.

      WHEN `COLUMN_RESIZE`.
        " onColumnResize: when the begin column has grown back to one column,
        " re-select the section the URL names - the original's
        " _scrollToIndexedSection
        IF client->get_event_arg( ) = abap_true
           AND layout = `OneColumn`
           AND section_ix >= 0.
          section_select( ).
        ENDIF.

      WHEN `HASH_CHANGED`.
        " browser Back/Forward (or a manual edit) moved the app-owned hash -
        " the router's routeMatched: derive route, section index and layout
        " from the hash this request carries. Like the original, a hash
        " change alone does not re-scroll the list (only the first rendering
        " and the column resize do)
        hash_apply( client->get( )-s_config-hash ).

    ENDCASE.

  ENDMETHOD.


  METHOD hash_apply.

    " the router's routeMatched, read side. The original's patterns:
    " '' (list start), '{section}' (the ':section:' list route, a section
    " INDEX), 'detail/{layout}'
    DATA(lv_hash) = iv_hash.
    IF lv_hash CS `#`.
      lv_hash = substring_after( val = lv_hash sub = `#` ).
    ENDIF.
    SHIFT lv_hash LEFT DELETING LEADING `/`.
    SPLIT lv_hash AT `/` INTO TABLE DATA(lt_seg).
    DELETE lt_seg WHERE table_line IS INITIAL.

    DATA(lv_1) = VALUE string( lt_seg[ 1 ] OPTIONAL ).
    DATA(lv_2) = VALUE string( lt_seg[ 2 ] OPTIONAL ).

    CASE lv_1.
      WHEN ``.
        route      = `list`.
        layout     = `OneColumn`.
        section_ix = -1.

      WHEN `detail`.
        route  = `detail`.
        layout = COND #( WHEN lv_2 IS NOT INITIAL THEN lv_2 ELSE `MidColumnFullScreen` ).

      WHEN OTHERS.
        " the single-segment ':section:' list route, e.g. '#/3'
        route  = `list`.
        layout = `OneColumn`.
        IF lv_1 CO `0123456789` AND strlen( lv_1 ) <= 4.
          section_ix = lv_1.
        ELSE.
          section_ix = -1.
        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD hash_push.

    " the router's navTo, write side: compose the current route the way the
    " manifest patterns spell it and push it as the app-owned hash. The bare
    " list route pushes '/' - the leading slash is normalised away, so the
    " URL carries an empty app hash exactly like the original's
    " navTo('list') without a section
    CASE route.
      WHEN `detail`.
        client->set_push_state( |/detail/{ layout }| ).
      WHEN OTHERS.
        IF section_ix >= 0.
          client->set_push_state( |/{ section_ix }| ).
        ELSE.
          client->set_push_state( `/` ).
        ENDIF.
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
