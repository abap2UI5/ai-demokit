" @keywords flexiblecolumnlayout flexible column layout sap.f flexiblecolumnlayoutcolumnresize objectpagelayout objectpagedynamicheadertitle title objectpagesection objectpagesubsection button
" @summary FlexibleColumnLayout where the app programmatically scrolls to some item within the newly navigated column, once the column is fully resized
CLASS z2ui5_cl_smpc_app_577 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_section,
             tablename   TYPE string,
             sectionname TYPE string,
           END OF ty_s_section.
    TYPES ty_t_section TYPE STANDARD TABLE OF ty_s_section WITH DEFAULT KEY.

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
    METHODS hash_push IMPORTING check_replace TYPE abap_bool OPTIONAL.
    METHODS section_select.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_577 IMPLEMENTATION.

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

    " the router also matches a deep link / reload (`#/3`, `#/detail/
    " MidColumnFullScreen`): the live hash rides in s_config-hash on every
    " request; applying it is idempotent, so a rebuild whose hash matches the
    " state simply re-derives it
    DATA lv_hash TYPE z2ui5_if_client=>ty_s_get-s_config-hash.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA fcl TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string_table.
    lv_hash = client->get( )-s_config-hash.
    IF lv_hash IS NOT INITIAL AND lv_hash <> `#`.
      hash_apply( lv_hash ).
    ENDIF.

    
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `${$parameters>/isNavigationArrow}` INTO TABLE temp1.
    INSERT `${$parameters>/layout}` INTO TABLE temp1.
    
    fcl = view->ele( n = `View` ns = `mvc`
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
            " the original wires stateChange to onStateChanged: only a layout
            " change by a NAVIGATION ARROW replace-navTo's the URL - the flag
            " and the new layout travel with the event, the backend guards on it
            )->a( n = `stateChange`      v = client->_event( val = `STATE_CHANGED` t_arg = temp1 )
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
    
    CLEAR temp3.
    INSERT `HASH_CHANGED` INTO TABLE temp3.
    client->follow_up_action( val   = client->cs_event-hash_attach_changed
                              t_arg = temp3 ).

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
    DATA temp5 TYPE string_table.
    DATA temp1 LIKE LINE OF temp5.
    CLEAR temp5.
    INSERT `ObjectPageLayout` INTO TABLE temp5.
    INSERT `setSelectedSection` INTO TABLE temp5.
    
    temp1 = |ObjectPageLayout/sections/{ section_ix }|.
    INSERT temp1 INTO TABLE temp5.
    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = temp5 ).

  ENDMETHOD.


  METHOD on_event.
        DATA lv_ix TYPE string.

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
        
        lv_ix = client->get_event_arg( ).
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

      WHEN `STATE_CHANGED`.
        " onStateChanged: the layout is a two-way binding, so the model
        " already carries the value this event reports - but when a
        " NAVIGATION ARROW changed it, the original replace-navTo's the
        " URL: same route, new layout, no new history entry
        IF client->get_event_arg( ) = abap_true.
          layout = client->get_event_arg( 2 ).
          hash_push( abap_true ).
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
    DATA lv_hash LIKE iv_hash.
    DATA lt_seg TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA temp7 TYPE string.
    DATA temp8 TYPE string.
    DATA lv_1 LIKE temp7.
    DATA temp9 TYPE string.
    DATA temp10 TYPE string.
    DATA lv_2 LIKE temp9.
        DATA temp11 TYPE string.
    lv_hash = iv_hash.
    IF lv_hash CS `#`.
      lv_hash = substring_after( val = lv_hash sub = `#` ).
    ENDIF.
    SHIFT lv_hash LEFT DELETING LEADING `/`.
    
    SPLIT lv_hash AT `/` INTO TABLE lt_seg.
    DELETE lt_seg WHERE table_line IS INITIAL.

    
    CLEAR temp7.
    
    READ TABLE lt_seg INTO temp8 INDEX 1.
    IF sy-subrc = 0.
      temp7 = temp8.
    ENDIF.
    
    lv_1 = temp7.
    
    CLEAR temp9.
    
    READ TABLE lt_seg INTO temp10 INDEX 2.
    IF sy-subrc = 0.
      temp9 = temp10.
    ENDIF.
    
    lv_2 = temp9.

    CASE lv_1.
      WHEN ``.
        route      = `list`.
        layout     = `OneColumn`.
        section_ix = -1.

      WHEN `detail`.
        route  = `detail`.
        
        IF lv_2 IS NOT INITIAL.
          temp11 = lv_2.
        ELSE.
          temp11 = `MidColumnFullScreen`.
        ENDIF.
        layout = temp11.

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

    DATA lv_hash TYPE string.
    " the router's navTo, write side: compose the current route the way the
    " manifest patterns spell it and push it as the app-owned hash. The bare
    " list route pushes '/' - the leading slash is normalised away, so the
    " URL carries an empty app hash exactly like the original's
    " navTo('list') without a section
    CASE route.
      WHEN `detail`.
        lv_hash = |/detail/{ layout }|.
      WHEN OTHERS.
        IF section_ix >= 0.
          lv_hash = |/{ section_ix }|.
        ELSE.
          lv_hash = `/`.
        ENDIF.
    ENDCASE.

    " a NAVIGATION ARROW rewrites the URL in place (the original's
    " replace-navTo) - everything else is a real, pushed history entry
    IF check_replace = abap_true.
      client->hash_replace( lv_hash ).
    ELSE.
      client->hash_set( lv_hash ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " webapp/data/sections.json - the twelve sections
    DATA temp12 TYPE z2ui5_cl_smpc_app_577=>ty_t_section.
    DATA temp13 LIKE LINE OF temp12.
    CLEAR temp12.
    
    temp13-tablename = `Navigate to section 0`.
    temp13-sectionname = `Section 0`.
    INSERT temp13 INTO TABLE temp12.
    temp13-tablename = `Navigate to section 1`.
    temp13-sectionname = `Section 1`.
    INSERT temp13 INTO TABLE temp12.
    temp13-tablename = `Navigate to section 2`.
    temp13-sectionname = `Section 2`.
    INSERT temp13 INTO TABLE temp12.
    temp13-tablename = `Navigate to section 3`.
    temp13-sectionname = `Section 3`.
    INSERT temp13 INTO TABLE temp12.
    temp13-tablename = `Navigate to section 4`.
    temp13-sectionname = `Section 4`.
    INSERT temp13 INTO TABLE temp12.
    temp13-tablename = `Navigate to section 5`.
    temp13-sectionname = `Section 5`.
    INSERT temp13 INTO TABLE temp12.
    temp13-tablename = `Navigate to section 6`.
    temp13-sectionname = `Section 6`.
    INSERT temp13 INTO TABLE temp12.
    temp13-tablename = `Navigate to section 7`.
    temp13-sectionname = `Section 7`.
    INSERT temp13 INTO TABLE temp12.
    temp13-tablename = `Navigate to section 8`.
    temp13-sectionname = `Section 8`.
    INSERT temp13 INTO TABLE temp12.
    temp13-tablename = `Navigate to section 9`.
    temp13-sectionname = `Section 9`.
    INSERT temp13 INTO TABLE temp12.
    temp13-tablename = `Navigate to section 10`.
    temp13-sectionname = `Section 10`.
    INSERT temp13 INTO TABLE temp12.
    temp13-tablename = `Navigate to section 11`.
    temp13-sectionname = `Section 11`.
    INSERT temp13 INTO TABLE temp12.
    t_sections = temp12.

  ENDMETHOD.

ENDCLASS.
